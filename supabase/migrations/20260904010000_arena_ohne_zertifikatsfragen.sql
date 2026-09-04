-- 20260904010000_arena_ohne_zertifikatsfragen.sql
--
-- Zweck: Zertifikatsfragen (AWS, SAP, AZ-900, GCP; fragen.zertifikat_id is not null)
--        aus der Arena / den Async-Duellen ausschliessen. Zusaetzlich nur Fragen
--        zulassen, die im Duell beantwortbar sind (MC-Fragen brauchen Antworten).
-- Stand: 04.09.2026
--
-- Befund (Lese-Agent): 330 von 1237 match_questions (27 %) in 119 von 124 Matches
-- waren Zertifikatsfragen. Ursache: create_async_match_any filtert nur nach
-- question_type, nicht nach zertifikat_id. 1 MC-Frage ohne Antworten faellt zusaetzlich raus;
-- fill_blank/sequence (69) tragen ihre Daten in calculation_data und bleiben drin.
--
-- Wirkung: nur NEUE Matches. Laufende Matches (match_questions) bleiben unberuehrt.
-- App-Aenderung: keine (Signatur, Rueckgabewert, Aufruf aus async_duel_service.dart
-- unveraendert; Auswahl ist rein serverseitig).
-- Rechte/Owner: create or replace erhaelt ACL und Owner. SECURITY DEFINER bleibt.
-- search_path wird fixiert (alle Objektverweise sind schemaqualifiziert).
--
-- Kontrolle danach (siehe Ende der Datei).

begin;

CREATE OR REPLACE FUNCTION public.create_async_match_any(p_count integer)
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

  INSERT INTO public.matches (player1_id, total_questions, status)
  VALUES (v_user_id, p_count, 'open')
  RETURNING id INTO v_match_id;

  INSERT INTO public.match_questions (match_id, idx, frage_id)
  SELECT v_match_id, (ROW_NUMBER() OVER () - 1)::integer, f.id
  FROM public.fragen f
  WHERE f.zertifikat_id IS NULL
    AND f.question_type IN ('multiple_choice', 'fill_blank', 'sequence')
    AND (
      f.question_type IN ('fill_blank', 'sequence')
      OR EXISTS (SELECT 1 FROM public.antworten a WHERE a.frage_id = f.id)
    )
  ORDER BY RANDOM()
  LIMIT p_count;

  RETURN v_match_id;
END;
$function$;

comment on function public.create_async_match_any(integer) is
  'Arena: neues Async-Duell mit p_count zufaelligen Fragen. Nur Nicht-Zertifikatsfragen der Typen multiple_choice/fill_blank/sequence, MC nur mit vorhandenen Antworten. (04.09.2026)';

commit;

-- Kontrolle danach:
-- 1) Definition enthaelt den Filter:
-- select pg_get_functiondef('public.create_async_match_any(integer)'::regprocedure) like '%zertifikat_id IS NULL%';
-- 2) Rechte unveraendert (Erwartung wie vorher):
-- select proacl::text, proconfig::text from pg_proc where oid='public.create_async_match_any(integer)'::regprocedure;
-- 3) Nach dem naechsten neuen Duell: keine Zertifikatsfragen mehr in neuen Matches:
-- select count(*) from match_questions mq join fragen f on f.id=mq.frage_id
--   join matches m on m.id=mq.match_id
--  where f.zertifikat_id is not null and m.created_at > now() - interval '1 day';
