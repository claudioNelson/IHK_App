-- 20260904030000_join_nur_fertige_matches.sql
--
-- Zweck: "Zufaelliges Duell" soll nur Matches anbieten, deren Ersteller
--        bereits alle Fragen beantwortet hat. Bisher nahm join_random_open_match
--        das aelteste offene Match ohne Gegner, auch wenn der Ersteller nach
--        0 Fragen abgebrochen hatte -> echte Spieler warteten vergeblich
--        (5 Faelle am 02./03.09.2026 mit Juli-Matches).
-- Stand: 04.09.2026
--
-- Aenderungen gegenueber Live:
--   * Bedingung: Ersteller hat >= total_questions Antworten
--   * Ersteller darf kein Bot sein (Bots erstellen keine Matches, Sicherheitsnetz)
--   * FOR UPDATE SKIP LOCKED: zwei gleichzeitige Beitritte bekommen nicht
--     dasselbe Match
--   * SET search_path = public, pg_temp
--   * NULL-Guard: ohne Login (auth.uid() NULL) sofort NULL statt Beitritt mit
--     player2_id = NULL (war eine Luecke)
--   * Matches ohne Ersteller (player1_id NULL) werden nicht mehr angeboten
--     (live 0 Faelle, ohnehin nicht spielbar)
-- Signatur, Rueckgabe (uuid oder NULL) und Rechte unveraendert; die App
-- (async_duel_service.joinRandomMatch) muss nicht angepasst werden.
-- Die App-eigene Liste "Offene Matches" (getOpenMatches) filtert bereits
-- genauso -> Verhalten wird konsistent.

begin;

CREATE OR REPLACE FUNCTION public.join_random_open_match()
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = public, pg_temp
AS $function$
DECLARE
  v_match_id uuid;
  v_user_id uuid;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RETURN NULL;
  END IF;

  -- Aeltestes offenes Match (nicht eigenes), dessen Ersteller fertig ist
  SELECT m.id INTO v_match_id
  FROM public.matches m
  WHERE m.status = 'open'
    AND m.player2_id IS NULL
    AND m.player1_id IS NOT NULL
    AND m.player1_id <> v_user_id
    AND NOT EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = m.player1_id AND p.is_bot = true
    )
    AND (
      SELECT count(*) FROM public.match_answers a
      WHERE a.match_id = m.id AND a.user_id = m.player1_id
    ) >= m.total_questions
  ORDER BY m.created_at
  LIMIT 1
  FOR UPDATE OF m SKIP LOCKED;

  IF v_match_id IS NULL THEN
    RETURN NULL;
  END IF;

  UPDATE public.matches
  SET player2_id = v_user_id,
      status     = 'active',
      started_at = now()
  WHERE id = v_match_id
    AND player2_id IS NULL;

  RETURN v_match_id;
END;
$function$;

comment on function public.join_random_open_match() is
  'Arena: tritt dem aeltesten offenen Match bei, dessen Ersteller alle Fragen beantwortet hat (kein eigenes, kein Bot-Ersteller). NULL wenn keins verfuegbar. (04.09.2026)';

commit;

-- Kontrolle danach:
-- select pg_get_functiondef('public.join_random_open_match()'::regprocedure) like '%SKIP LOCKED%';
-- select proacl::text, proconfig::text from pg_proc where oid='public.join_random_open_match()'::regprocedure;
