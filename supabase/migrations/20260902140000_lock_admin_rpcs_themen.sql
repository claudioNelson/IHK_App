-- 20260902140000_lock_admin_rpcs_themen.sql
--
-- Zweck: Admin-Werkzeuge in der DB gegen Aufruf aus der App/Website sperren.
-- Stand: 02.09.2026
--
-- Befund (claude/datenbank.md, Live-DB):
--   * delete_module_data(bigint,boolean)   SECDEF, EXECUTE fuer PUBLIC + anon
--   * delete_module_data(integer,boolean)  SECDEF, EXECUTE fuer PUBLIC
--   * clear_all_explanations()             SECDEF, EXECUTE fuer PUBLIC
--   * add_question_with_answers(text,text,text,text,text,jsonb) SECDEF, PUBLIC
--   * update_question_explanation(text,text,text,text)          PUBLIC
--   * Policy "themen: write (all)": FOR ALL TO public USING(true) WITH CHECK(true)
--     -> jeder Client (auch anon) kann Themen anlegen/aendern/loeschen.
--
-- Aufrufer-Check (Lese-Agent, 02.09.2026): keine dieser Funktionen wird aus
-- lib/, web/ oder supabase/functions aufgerufen; themen wird vom Client nur
-- gelesen (select). Die drei SELECT-Policies bleiben unangetastet.
--
-- Ergebnis: Funktionen nur noch fuer postgres + service_role (SQL-Editor und
-- Edge Functions funktionieren weiter); Themen koennen nur noch ueber
-- SQL-Editor / service_role geschrieben werden.
--
-- Rueckgaengig (falls je noetig, dann eng gefasst statt wie vorher):
--   create policy "themen: write (admin)" on public.themen for all to authenticated
--     using (public.is_admin()) with check (public.is_admin());
--
-- Zusatzbefund Review: delete_module_data(integer,boolean) hatte KEINEN
-- is_admin()-Check und war fuer PUBLIC ausfuehrbar -> genau diese Luecke
-- schliesst die Migration.

begin;

-- 1) Schreib-Policy auf themen entfernen (SELECT-Policies bleiben)
drop policy if exists "themen: write (all)" on public.themen;

-- 2) Admin-RPCs: kein EXECUTE fuer Clients
revoke all on function public.delete_module_data(bigint, boolean)
  from public, anon, authenticated;
revoke all on function public.delete_module_data(integer, boolean)
  from public, anon, authenticated;
revoke all on function public.clear_all_explanations()
  from public, anon, authenticated;
revoke all on function public.add_question_with_answers(text, text, text, text, text, jsonb)
  from public, anon, authenticated;
revoke all on function public.update_question_explanation(text, text, text, text)
  from public, anon, authenticated;

-- service_role behaelt EXECUTE (war bereits so; idempotent bestaetigen)
grant execute on function public.delete_module_data(bigint, boolean) to service_role;
grant execute on function public.delete_module_data(integer, boolean) to service_role;
grant execute on function public.clear_all_explanations() to service_role;
grant execute on function public.add_question_with_answers(text, text, text, text, text, jsonb) to service_role;
grant execute on function public.update_question_explanation(text, text, text, text) to service_role;

-- 3) search_path fixieren (verhaltensneutral; update_question_explanation ist SECURITY INVOKER, trotzdem harmlos)
alter function public.delete_module_data(bigint, boolean)   set search_path = public, pg_temp;
alter function public.delete_module_data(integer, boolean)  set search_path = public, pg_temp;
alter function public.clear_all_explanations()              set search_path = public, pg_temp;
alter function public.add_question_with_answers(text, text, text, text, text, jsonb) set search_path = public, pg_temp;
alter function public.update_question_explanation(text, text, text, text)            set search_path = public, pg_temp;

commit;

-- Kontrolle danach:
-- select p.oid::regprocedure::text, p.proacl::text, p.proconfig::text
--   from pg_proc p join pg_namespace n on n.oid=p.pronamespace
--  where n.nspname='public' and p.proname in
--   ('delete_module_data','clear_all_explanations','add_question_with_answers','update_question_explanation');
-- Erwartung: proacl nur postgres=X und service_role=X; proconfig gesetzt.
-- select policyname, cmd from pg_policies where tablename='themen';
-- Erwartung: nur noch die drei SELECT-Policies.
