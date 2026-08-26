-- 20260826120000_signup_ip_helper.sql
--
-- Helfer fuer die Google-Testgeraete-Erkennung in notify-signup:
-- liefert die IP der juengsten Session eines Nutzers aus auth.sessions.
-- Die Edge Function darf auth.sessions nicht direkt lesen (Schema nicht
-- ueber PostgREST exponiert), darum dieser schmale SECURITY-DEFINER-Weg.
-- Ausfuehrbar NUR fuer service_role.

create or replace function public.get_signup_ip(p_user_id uuid)
returns text
language sql
security definer
set search_path = ''
as $$
  select s.ip::text
  from auth.sessions s
  where s.user_id = p_user_id
  order by s.created_at desc
  limit 1;
$$;

revoke all on function public.get_signup_ip(uuid) from public;
revoke all on function public.get_signup_ip(uuid) from anon;
revoke all on function public.get_signup_ip(uuid) from authenticated;
grant execute on function public.get_signup_ip(uuid) to service_role;
