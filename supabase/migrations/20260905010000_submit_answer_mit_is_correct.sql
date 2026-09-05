-- 2026-09-05: submit_async_answer bekommt einen optionalen Parameter p_is_correct.
--
-- Problem:
--   * Sonderfragen (Lueckentext, Reihenfolge, Rechnen) und Pseudo-Antworten
--     schicken als Platzhalter antwort_id = 1. Der Server schaut nur in
--     antworten.ist_richtig – und Antwort 1 ist eine RICHTIGE Antwort (Frage 1).
--     => Sonderfragen wurden im Match-Score immer als richtig gewertet.
--   * Bei Zeitablauf hat die App gar nichts geschickt => Matches blieben bei
--     9/10 Antworten haengen und wurden nie ausgewertet.
--
-- Loesung:
--   * Neuer 4. Parameter p_is_correct boolean DEFAULT NULL.
--     - NULL  -> wie bisher: ist_richtig aus antworten nachschlagen (Multiple Choice).
--     - true/false -> Wert der App uebernehmen (Sonderfragen, Zeitablauf = false).
--   * Alte App-Versionen rufen weiter mit 3 Parametern auf -> Default NULL -> altes
--     Verhalten. Kein Bruch fuer laufende Installationen.
--
-- antwort_id bleibt NOT NULL mit FK auf antworten -> Platzhalter-Id 1 bleibt
-- als Referenz bestehen, entscheidet aber nicht mehr ueber richtig/falsch.
--
-- Signatur aendert sich -> alte Funktion muss weg (CREATE OR REPLACE geht nicht),
-- sonst haette PostgREST zwei Kandidaten und koennte bei 3 Argumenten nicht
-- eindeutig waehlen.

DROP FUNCTION IF EXISTS public.submit_async_answer(uuid, integer, bigint);

CREATE FUNCTION public.submit_async_answer(
  p_match      uuid,
  p_idx        integer,
  p_antwort_id bigint,
  p_is_correct boolean DEFAULT NULL
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $function$
DECLARE
  v_user_id    uuid;
  v_is_correct boolean;
  v_exists     boolean;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RETURN false;
  END IF;

  -- Pruefe ob User im Match ist (und das Match noch laeuft)
  SELECT EXISTS(
    SELECT 1 FROM public.matches
    WHERE id = p_match
      AND (player1_id = v_user_id OR player2_id = v_user_id)
  ) INTO v_exists;

  IF NOT v_exists THEN
    RETURN false;
  END IF;

  -- Pruefe ob Antwort bereits existiert
  SELECT EXISTS(
    SELECT 1 FROM public.match_answers
    WHERE match_id = p_match
      AND user_id = v_user_id
      AND idx = p_idx
  ) INTO v_exists;

  IF v_exists THEN
    RETURN false; -- Bereits beantwortet
  END IF;

  -- Richtig/falsch: explizit von der App (Sonderfragen, Zeitablauf) oder
  -- wie bisher aus der antworten-Tabelle (Multiple Choice).
  IF p_is_correct IS NOT NULL THEN
    v_is_correct := p_is_correct;
  ELSE
    SELECT ist_richtig INTO v_is_correct
    FROM public.antworten
    WHERE id = p_antwort_id;
  END IF;

  INSERT INTO public.match_answers (match_id, user_id, idx, antwort_id, is_correct)
  VALUES (p_match, v_user_id, p_idx, p_antwort_id, COALESCE(v_is_correct, false));

  RETURN true;
END;
$function$;

-- Rechte wie vorher (anon, authenticated, service_role hatten EXECUTE)
GRANT EXECUTE ON FUNCTION public.submit_async_answer(uuid, integer, bigint, boolean)
  TO anon, authenticated, service_role;

-- PostgREST soll die neue Signatur sofort kennen
NOTIFY pgrst, 'reload schema';
