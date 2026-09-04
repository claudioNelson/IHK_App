-- 20260904040000_search_path_alle_funktionen.sql
--
-- Zweck: search_path fuer die letzten 16 Funktionen in public fixieren
--        (Advisor "function_search_path_mutable", claude/datenbank.md Punkt 3).
-- Stand: 04.09.2026
--
-- Verhaltensneutral: ALTER FUNCTION ... SET search_path aendert weder Body,
-- Signatur, Rechte noch Owner. Lese-Agent hat alle 16 Bodies geprueft:
-- keine unqualifizierten Verweise auf auth.*, extensions.*, net.*, vault.*;
-- alle referenzierten Tabellen/Funktionen liegen in public, auth.uid()/
-- auth.role() sind qualifiziert. Kein Fall braucht 'extensions' im Pfad.
-- Signaturen exakt aus pg_proc (regprocedure), 16 Treffer bestaetigt.
--
-- Nebenbefund (NICHT Teil dieser Migration): complete_exam_attempt(uuid) hat
-- eine Namenskollision PL/pgSQL-Variablen vs. Spalten (total_points,
-- achieved_points, percentage, passed) -> ambiguous column reference. Wird
-- laut Aufrufer-Check von keinem Client genutzt; separat pruefen.

begin;

alter function public.auth_role()                                    set search_path = public, pg_temp;
alter function public.btrim_null(text)                               set search_path = public, pg_temp;
alter function public.calculate_elo(integer, integer, boolean)       set search_path = public, pg_temp;
alter function public.complete_exam_attempt(uuid)                    set search_path = public, pg_temp;
alter function public.create_async_match(integer, bigint, bigint)    set search_path = public, pg_temp;
alter function public.didactic_explanation_sync()                    set search_path = public, pg_temp;
alter function public.handle_updated_at()                            set search_path = public, pg_temp;
alter function public.is_admin()                                     set search_path = public, pg_temp;
alter function public.pick_random_questions(bigint, bigint, integer) set search_path = public, pg_temp;
alter function public.protect_usage_count()                          set search_path = public, pg_temp;
alter function public.set_default_question_difficulty()              set search_path = public, pg_temp;
alter function public.submit_async_answer(uuid, integer, bigint)     set search_path = public, pg_temp;
alter function public.try_finalize_match(uuid)                       set search_path = public, pg_temp;
alter function public.update_player_stats_on_match_complete()        set search_path = public, pg_temp;
alter function public.update_spaced_repetition_updated_at()          set search_path = public, pg_temp;
alter function public.update_updated_at_column()                     set search_path = public, pg_temp;

commit;

-- Kontrolle danach (Erwartung: 0):
-- select count(*) from pg_proc p where p.pronamespace='public'::regnamespace
--   and (p.proconfig is null or not exists (select 1 from unnest(p.proconfig) c where c like 'search_path=%'));
