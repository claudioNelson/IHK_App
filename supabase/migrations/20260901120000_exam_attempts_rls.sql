-- 20260901120000_exam_attempts_rls.sql
--
-- user_exam_attempts wurde bis heute von keiner App-Version beschrieben.
-- Bevor die App (ab Build 15) Versuche speichert, sicherstellen, dass
-- eingeloggte Nutzer ihre EIGENEN Zeilen lesen, anlegen und bewerten
-- duerfen. Alles idempotent, mehrfach ausfuehrbar.
-- (Lehre aus question_reports: Tabelle ohne GRANTs/Policies = 42501.)

alter table public.user_exam_attempts enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'user_exam_attempts'
      and policyname = 'exam_attempts_select_own'
  ) then
    create policy exam_attempts_select_own on public.user_exam_attempts
      for select to authenticated using (user_id = auth.uid());
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'user_exam_attempts'
      and policyname = 'exam_attempts_insert_own'
  ) then
    create policy exam_attempts_insert_own on public.user_exam_attempts
      for insert to authenticated with check (user_id = auth.uid());
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'user_exam_attempts'
      and policyname = 'exam_attempts_update_own'
  ) then
    create policy exam_attempts_update_own on public.user_exam_attempts
      for update to authenticated
      using (user_id = auth.uid()) with check (user_id = auth.uid());
  end if;
end $$;

grant select, insert, update on public.user_exam_attempts to authenticated;
grant all on public.user_exam_attempts to service_role;

-- exams muss fuer den Slug-Lookup lesbar sein
grant select on public.exams to authenticated, anon;
