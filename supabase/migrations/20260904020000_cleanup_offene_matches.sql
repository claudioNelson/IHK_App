-- 20260904020000_cleanup_offene_matches.sql
--
-- Zweck: Verwaiste Arena-Matches automatisch aufraeumen.
-- Stand: 04.09.2026
--
-- Befund (Lese-Analyse): 25 offene Matches (aeltestes 07.08.2026), in denen der
-- Ersteller nicht alle Fragen beantwortet hat, bleiben ewig liegen:
--   * bot_takeover uebernimmt nur offene Matches, deren Ersteller FERTIG ist
--   * cleanup_stale_active_matches raeumt nur status='active' mit started_at
-- Folge: echte Spieler joinen per "Zufaelliges Duell" uralte Matches gegen einen
-- Ersteller, der nie antworten wird (5 Faelle am 02./03.09.2026).
--
-- Aenderungen:
--   1) NEU cleanup_stale_open_matches(p_days default 3): loescht offene Matches
--      ohne Gegner, aelter als p_days, Ersteller nicht fertig. CASCADE raeumt
--      match_questions/match_answers.
--   2) cleanup_stale_active_matches: coalesce(started_at, created_at), damit
--      aktive Matches ohne started_at nicht durchs Raster fallen. Sonst identisch.
--   3) Cron-Job taeglich 04:37 UTC fuer (1).
--   4) Einmaliger Lauf von (1) am Ende, um den Bestand sofort zu bereinigen.
--
-- App-Aenderung: keine. Beide Funktionen werden nur von pg_cron aufgerufen.
-- Rechte: neue Funktion nur fuer postgres/service_role (kein Client-Aufruf).

begin;

-- 1) Neue Aufraeum-Funktion fuer offene Matches
create or replace function public.cleanup_stale_open_matches(p_days integer default 3)
returns table(match_id uuid, action text)
language plpgsql
security definer
set search_path = public, pg_temp
as $function$
declare
  v_match record;
begin
  for v_match in
    select m.id
      from public.matches m
     where m.status = 'open'
       and m.player2_id is null
       and m.created_at < (now() - make_interval(days => p_days))
       and (select count(*) from public.match_answers a
             where a.match_id = m.id and a.user_id = m.player1_id) < m.total_questions
  loop
    delete from public.matches where id = v_match.id;   -- CASCADE: match_questions, match_answers
    match_id := v_match.id; action := 'deleted_open_incomplete'; return next;
  end loop;
end;
$function$;

revoke all on function public.cleanup_stale_open_matches(integer) from public, anon, authenticated;
grant execute on function public.cleanup_stale_open_matches(integer) to service_role;

comment on function public.cleanup_stale_open_matches(integer) is
  'Arena: loescht offene Matches ohne Gegner, aelter als p_days Tage, deren Ersteller nicht alle Fragen beantwortet hat. Laeuft taeglich per pg_cron. (04.09.2026)';

-- 2) Bestehende Funktion: started_at kann null sein -> created_at als Fallback
CREATE OR REPLACE FUNCTION public.cleanup_stale_active_matches(p_hours integer DEFAULT 72)
 RETURNS TABLE(match_id uuid, action text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_match record;
  v_p1_count integer;
  v_p2_count integer;
begin
  for v_match in
    select m.id, m.player1_id, m.player2_id, m.total_questions
    from matches m
    where m.status = 'active'
      and coalesce(m.started_at, m.created_at) < (now() - make_interval(hours => p_hours))
  loop
    select count(*) into v_p1_count
    from match_answers
    where match_answers.match_id = v_match.id and user_id = v_match.player1_id;

    select count(*) into v_p2_count
    from match_answers
    where match_answers.match_id = v_match.id and user_id = v_match.player2_id;

    -- Fall A: Beide fertig -> normal finalisieren
    if v_p1_count >= v_match.total_questions
       and v_p2_count >= v_match.total_questions then
      perform try_finalize_match(v_match.id);
      match_id := v_match.id; action := 'finalized'; return next;

    -- Fall B: Beide haben gar nicht gespielt -> loeschen (CASCADE raeumt Kinder)
    elsif v_p1_count = 0 and v_p2_count = 0 then
      delete from matches where id = v_match.id;
      match_id := v_match.id; action := 'deleted'; return next;

    -- Fall C: Teilweise gespielt (Abbruch) -> als finished schliessen, OHNE score
    else
      update matches
      set status = 'finished', finished_at = now()
      where id = v_match.id;
      match_id := v_match.id; action := 'closed_no_score'; return next;
    end if;
  end loop;
end;
$function$;

-- 3) Taeglicher Cron-Job (cron.schedule mit gleichem Namen aktualisiert einen bestehenden Job)
select cron.schedule('cleanup_stale_open_matches', '37 4 * * *', $$select public.cleanup_stale_open_matches(3)$$);

commit;

-- 4) Einmaliger Lauf jetzt (zeigt die geloeschten Match-IDs):
select * from public.cleanup_stale_open_matches(3);

-- Kontrolle danach:
-- select status, count(*) from matches group by 1;              -- open sollte deutlich kleiner sein
-- select jobname, schedule, active from cron.job order by 1;    -- 4 Jobs, neuer dabei
