-- 20260902150000_fk_indizes.sql
--
-- Zweck: Indizes auf 13 Fremdschluessel-Spalten ohne Index (Advisor
--        "unindexed_foreign_keys", claude/datenbank.md Punkt 11).
-- Stand: 02.09.2026. Liste lesend aus pg_constraint/pg_index ermittelt.
--
-- Verhaltensneutral: keine Daten, keine Rechte, keine Logik. Nur Joins und
-- Kaskaden-Deletes werden schneller. Tabellen sind klein (max. ~4.400 Zeilen),
-- daher normales create index in einer Transaktion (Sperre im Millisekunden-
-- bereich). idempotent durch "if not exists".

begin;

create index if not exists idx_exams_zertifikat_id            on public.exams (zertifikat_id);
create index if not exists idx_flashcards_frage_id            on public.flashcards (frage_id);
create index if not exists idx_fragen_zertifikat_id           on public.fragen (zertifikat_id);
create index if not exists idx_level_progress_level_id        on public.level_progress (level_id);
create index if not exists idx_match_answers_antwort_id       on public.match_answers (antwort_id);
create index if not exists idx_match_questions_frage_id       on public.match_questions (frage_id);
create index if not exists idx_match_scores_player1_id        on public.match_scores (player1_id);
create index if not exists idx_match_scores_player2_id        on public.match_scores (player2_id);
create index if not exists idx_question_reports_user_id       on public.question_reports (user_id);
create index if not exists idx_spaced_repetition_frage_id     on public.spaced_repetition (frage_id);
create index if not exists idx_sub_questions_question_type_id on public.sub_questions (question_type_id);
create index if not exists idx_user_badges_badge_id           on public.user_badges (badge_id);
create index if not exists idx_user_progress_frage_id         on public.user_progress (frage_id);

commit;

-- Kontrolle danach (Erwartung: 0 Zeilen):
-- select c.conrelid::regclass, a.attname from pg_constraint c
--   join pg_attribute a on a.attrelid=c.conrelid and a.attnum=any(c.conkey)
--  where c.contype='f' and c.connamespace='public'::regnamespace and array_length(c.conkey,1)=1
--    and not exists (select 1 from pg_index i where i.indrelid=c.conrelid and i.indkey[0]=c.conkey[1]);
