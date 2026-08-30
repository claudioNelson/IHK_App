-- =====================================================================
--  Lernarena · Arena-Screen fuer den Demo-Account fuellen
--  Zweck: App-Store-Screenshot vom Arena-Tab. Ohne Daten zeigt der
--         Screen nur "Keine aktiven Matches" und keinen ELO-Banner.
--  Konto: demo@lernarena.app
--  Datum: 30.08.2026
--
--  In Supabase ausfuehren: Dashboard -> SQL Editor -> New query.
--  Die Abschnitte einzeln markieren und mit "Run" ausfuehren.
--  Abschnitt 4 macht alles wieder rueckgaengig.
-- =====================================================================


-- ---------------------------------------------------------------------
-- ABSCHNITT 0 · Schema-Check (nur lesen, aendert nichts)
--
-- Ich kenne die Spalten dieser Tabellen nicht sicher. Lauf das hier
-- zuerst. Wenn Abschnitt 2 oder 3 mit "column ... does not exist"
-- abbricht, schick mir die Ausgabe von hier und ich passe das Skript an.
-- ---------------------------------------------------------------------
select table_name, column_name, data_type, is_nullable
from information_schema.columns
where table_schema = 'public'
  and table_name in ('matches', 'match_questions', 'match_answers',
                     'match_scores', 'player_stats')
order by table_name, ordinal_position;

-- Ist match_scores eine Tabelle oder eine View?
select table_name, table_type
from information_schema.tables
where table_schema = 'public' and table_name = 'match_scores';


-- ---------------------------------------------------------------------
-- ABSCHNITT 1 · Spieler-Statistik (bringt den ELO-Banner nach oben)
--
-- Der Banner erscheint nur, wenn matches_played > 0 ist.
-- ELO 1180 ergibt laut async_match_demo_screen.dart die Stufe "GOLD"
-- (>= 1150). 17 Siege / 2 Remis / 5 Niederlagen = 70 % Winrate.
-- ---------------------------------------------------------------------
do $$
declare
  v_user uuid;
begin
  select id into v_user from public.profiles
   where email = 'demo@lernarena.app' limit 1;

  if v_user is null then
    raise exception 'Demo-Konto demo@lernarena.app nicht in profiles gefunden';
  end if;

  -- Erst versuchen zu aktualisieren, sonst anlegen. Bewusst kein
  -- ON CONFLICT: ob auf user_id ein Unique-Index liegt, weiss ich nicht.
  update public.player_stats
     set elo_rating    = 1180,
         matches_played = 24,
         wins          = 17,
         draws         = 2,
         losses        = 5
   where user_id = v_user;

  if not found then
    insert into public.player_stats
      (user_id, elo_rating, matches_played, wins, draws, losses)
    values (v_user, 1180, 24, 17, 2, 5);
  end if;

  raise notice 'player_stats gesetzt fuer %', v_user;
end $$;


-- ---------------------------------------------------------------------
-- ABSCHNITT 2 · Drei Matches anlegen
--
-- Aufbau (so sieht die Liste im Screenshot aus):
--   Match A · 10 Fragen · 4 davon beantwortet -> Badge "NOCH 6 FRAGEN"
--   Match B · 10 Fragen · 7 davon beantwortet -> Badge "NOCH 3 FRAGEN"
--   Match C · 10 Fragen · noch nicht angefangen
--
-- player2_id bleibt leer und der Status ist 'open' — genau das legt
-- auch die App selbst an (create_async_match_any). Der Block versucht
-- zuerst 'active' und faellt auf 'open' zurueck, falls eine Bedingung
-- in der Tabelle einen Gegner verlangt. Die Karte zeigt dann statt
-- "AKTIV" eben "OFFEN"; beides sieht im Screenshot gut aus.
-- ---------------------------------------------------------------------
do $$
declare
  v_user      uuid;
  v_match     uuid;
  v_frage     record;
  v_antwort   record;
  v_idx       int;
  v_plan      int[] := array[4, 7, 0];   -- beantwortete Fragen je Match
  v_alter     int[] := array[1, 2, 0];   -- Alter in Tagen (fuer created_at)
  v_i         int;
begin
  select id into v_user from public.profiles
   where email = 'demo@lernarena.app' limit 1;

  if v_user is null then
    raise exception 'Demo-Konto demo@lernarena.app nicht gefunden';
  end if;

  for v_i in 1..3 loop
    v_match := gen_random_uuid();

    -- Match-Kopf. Erst 'active' probieren, sonst 'open'.
    begin
      insert into public.matches
        (id, status, player1_id, player2_id, total_questions, created_at)
      values (v_match,
              case when v_i = 3 then 'open' else 'active' end,
              v_user, null, 10,
              now() - (v_alter[v_i] || ' days')::interval);
    exception when others then
      raise notice 'Status "active" abgelehnt (%), nehme "open"', sqlerrm;
      insert into public.matches
        (id, status, player1_id, player2_id, total_questions, created_at)
      values (v_match, 'open', v_user, null, 10,
              now() - (v_alter[v_i] || ' days')::interval);
    end;

    -- Zehn echte Fragen anhaengen, die mindestens eine Antwort haben.
    v_idx := 0;
    for v_frage in
      select f.id
        from public.fragen f
       where exists (select 1 from public.antworten a where a.frage_id = f.id)
       order by random()
       limit 10
    loop
      insert into public.match_questions (match_id, idx, frage_id)
      values (v_match, v_idx, v_frage.id);

      -- Fuer die ersten N Fragen eine eigene Antwort eintragen.
      -- Die App zaehlt diese Zeilen und zeigt daraus "NOCH x FRAGEN".
      if v_idx < v_plan[v_i] then
        select a.id, a.ist_richtig into v_antwort
          from public.antworten a
         where a.frage_id = v_frage.id
         order by a.ist_richtig desc   -- moeglichst die richtige Antwort
         limit 1;

        if v_antwort.id is not null then
          insert into public.match_answers
            (match_id, user_id, idx, antwort_id, is_correct)
          values (v_match, v_user, v_idx, v_antwort.id,
                  coalesce(v_antwort.ist_richtig, true));
        end if;
      end if;

      v_idx := v_idx + 1;
    end loop;

    raise notice 'Match % angelegt (% Fragen beantwortet)', v_match, v_plan[v_i];
  end loop;
end $$;


-- ---------------------------------------------------------------------
-- ABSCHNITT 3 · Kontrolle
-- ---------------------------------------------------------------------
select m.id, m.status, m.total_questions, m.created_at,
       (select count(*) from public.match_questions q where q.match_id = m.id) as fragen,
       (select count(*) from public.match_answers  a where a.match_id = m.id) as meine_antworten
  from public.matches m
  join public.profiles p on p.id = m.player1_id
 where p.email = 'demo@lernarena.app'
 order by m.created_at desc;

select * from public.player_stats
 where user_id = (select id from public.profiles where email = 'demo@lernarena.app');


-- ---------------------------------------------------------------------
-- ABSCHNITT 4 · Rueckgaengig machen
--
-- Loescht ausschliesslich Matches, bei denen das Demo-Konto Spieler 1
-- ist. Fremde Daten bleiben unberuehrt.
-- ---------------------------------------------------------------------
-- do $$
-- declare
--   v_user uuid;
-- begin
--   select id into v_user from public.profiles
--    where email = 'demo@lernarena.app' limit 1;
--
--   delete from public.match_answers
--    where match_id in (select id from public.matches where player1_id = v_user);
--   delete from public.match_questions
--    where match_id in (select id from public.matches where player1_id = v_user);
--   delete from public.matches where player1_id = v_user;
--   delete from public.player_stats where user_id = v_user;
-- end $$;
