-- 20260902090000_google_test_flag.sql
--
-- Dauerhaftes Flag fuer Gast-Accounts, die von Googles Testgeraeten
-- stammen (Pre-Launch-Report/Review nach jedem Play-Upload).
-- Gesetzt wird es ab jetzt von der Edge Function notify-signup (die
-- prueft die Session-IP gegen die Google-Bereiche). Hier zusaetzlich
-- eine einmalige Rueckwirkung fuer bestehende Gaeste, solange deren
-- Sessions noch in auth.sessions liegen.

alter table public.profiles
  add column if not exists is_google_test boolean not null default false;

-- Rueckwirkend markieren: anonymer Account + juengste Session-IP in
-- einem Google-Bereich. Kein Cloud-Hosting (GCP) in der Liste, damit
-- echte Nutzer hinter VPNs nicht getroffen werden.
with google(netz) as (
  values
    ('64.233.160.0/19'::inet), ('66.102.0.0/20'::inet),
    ('66.249.64.0/19'::inet),  ('72.14.192.0/18'::inet),
    ('74.125.0.0/16'::inet),   ('108.177.0.0/17'::inet),
    ('142.250.0.0/15'::inet),  ('172.217.0.0/16'::inet),
    ('173.194.0.0/16'::inet),  ('209.85.128.0/17'::inet),
    ('216.58.192.0/19'::inet), ('216.239.32.0/19'::inet)
)
update public.profiles p
set is_google_test = true
from auth.users u
where u.id = p.id
  and u.is_anonymous
  and p.is_google_test = false
  and exists (
    select 1
    from auth.sessions s
    join google g on s.ip <<= g.netz
    where s.user_id = u.id
  );

-- Damit die Edge Function (service_role) das Flag setzen darf, reicht
-- der bestehende service_role-Zugriff auf profiles.
