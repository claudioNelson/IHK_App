-- 20260904050000_doppelte_policies_entfernen.sql
--
-- Zweck: Redundante RLS-Policies und den doppelten updated_at-Trigger auf
--        profiles entfernen (Advisor "multiple_permissive_policies",
--        claude/datenbank.md Punkt 9). Effektive Berechtigung bleibt EXAKT
--        gleich: Bei permissiven Policies gilt OR ueber alle Policies; entfernt
--        werden nur Policies, deren Bedingung identisch ist (oder strikt enger)
--        und deren Rollen von der bleibenden Policy abgedeckt sind
--        ({public} deckt anon + authenticated).
-- Stand: 04.09.2026, Lese-Agent hat alle Policies (qual/with_check/roles)
--        verglichen. Bewusst NICHT angefasst: Policies mit unterschiedlichen
--        Bedingungen (profiles INSERT, question_reports INSERT, matches/*,
--        exams/exam_questions "veroeffentlicht" fuer anon).
--
-- App-Aenderung: keine.

begin;

-- Inhaltstabellen: 3 identische SELECT-Policies (qual = true) -> 1 bleibt
--   bleibt: "Anyone can view antworten" / "... fragen" / "... themen" / "... modules"
drop policy "antworten: read (all)" on public.antworten;
drop policy "antworten: read (all auth/anon)" on public.antworten;
drop policy "fragen: read (all)" on public.fragen;
drop policy "fragen: read (all auth/anon)" on public.fragen;
drop policy "themen: read (all)" on public.themen;
drop policy "themen: read (all auth/anon)" on public.themen;
drop policy "module: read (all)" on public.module;
drop policy "module: read (all auth/anon)" on public.module;

-- user_progress: englischer Duplikatsatz (deutscher bleibt, identische Bedingung)
drop policy "Users can view own progress" on public.user_progress;
drop policy "Users can insert own progress" on public.user_progress;
drop policy "Users can update own progress" on public.user_progress;

-- user_exam_attempts: englischer Duplikatsatz (deutscher bleibt)
drop policy "exam_attempts_select_own" on public.user_exam_attempts;
drop policy "exam_attempts_insert_own" on public.user_exam_attempts;
drop policy "exam_attempts_update_own" on public.user_exam_attempts;

-- profiles SELECT: engere Policy ist von "Public profiles are viewable by everyone"
-- (qual = true, public) vollstaendig abgedeckt
drop policy "Enable select for users based on user_id" on public.profiles;

-- exakte Duplikate
drop policy "eigene_meldungen_lesen" on public.question_reports;
drop policy "exams_read_authenticated" on public.exams;
drop policy "exam_questions_read_authenticated" on public.exam_questions;

-- doppelter updated_at-Trigger auf profiles: beide Funktionen setzen nur
-- NEW.updated_at = now(); update_profiles_updated_at bleibt, Funktionen bleiben
drop trigger if exists on_profile_updated on public.profiles;

commit;

-- Kontrolle danach (Erwartung: 69 Policies statt 87; profiles hat 3 Trigger):
-- select count(*) from pg_policies where schemaname='public';
-- select tgname from pg_trigger t join pg_class c on c.oid=t.tgrelid
--  where c.relname='profiles' and not t.tgisinternal;
