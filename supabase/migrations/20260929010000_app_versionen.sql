-- ============================================================================
-- Hinweis auf neue App-Version (App, Release 1.8.0)
-- ============================================================================
-- Eine Zeile je Plattform. Die App (ab 1.8.0) liest beim Start ihre Zeile und
-- vergleicht NUR die Versionsnummer (z. B. 1.8.0), nie die Build-Nummer
-- (die vergibt bei iOS Codemagic).
--   installiert < mindest_version  -> Pflicht-Update (nur fuer Notfaelle)
--   installiert < aktuelle_version -> Hinweis „Neue Version verfuegbar"
-- Startwerte 1.7.3 loesen bei niemandem etwas aus.
-- Anheben erst, wenn die neue Version im jeweiligen Store fuer ALLE verfuegbar
-- ist (Play: 100 % Rollout), per SQL-Editor, siehe claude/update-hinweis-plan.md.
-- Lesen: anon und authenticated (auch vor dem Login). Schreiben: nur SQL-Editor.
-- Plan: claude/update-hinweis-plan.md. Im SQL Editor des Projekts
-- ybvwjmaicoffitngtmzl ausfuehren.

begin;

create table if not exists public.app_versionen (
  plattform        text primary key check (plattform in ('android', 'ios')),
  aktuelle_version text not null check (aktuelle_version ~ '^\d+\.\d+\.\d+$'),
  mindest_version  text not null check (mindest_version ~ '^\d+\.\d+\.\d+$'),
  hinweis          text,
  store_url        text not null,
  aktualisiert_am  timestamptz not null default now()
);

comment on table public.app_versionen is
  'Aktuelle und Mindest-Version der App je Plattform fuer den Update-Hinweis (ab App 1.8.0). Nur per SQL-Editor aendern.';

alter table public.app_versionen enable row level security;

revoke all on public.app_versionen from anon, authenticated;
grant select on public.app_versionen to anon, authenticated;

drop policy if exists "app_versionen lesen" on public.app_versionen;
create policy "app_versionen lesen"
  on public.app_versionen
  for select
  to anon, authenticated
  using (true);

insert into public.app_versionen (plattform, aktuelle_version, mindest_version, hinweis, store_url) values
  ('android', '1.7.3', '1.7.3', null, 'https://play.google.com/store/apps/details?id=app.lernarena'),
  ('ios',     '1.7.3', '1.7.3', null, 'https://apps.apple.com/app/id6802045311')
on conflict (plattform) do nothing;

commit;

-- Kontrolle (der SQL-Editor zeigt nur das letzte Ergebnis, deshalb eine Abfrage):
-- erwartet 2 Zeilen android/ios mit 1.7.3 / 1.7.3, rls_an = true,
-- eine SELECT-Policy fuer anon und authenticated, rechte nur SELECT
select v.plattform, v.aktuelle_version, v.mindest_version, v.store_url,
       c.relrowsecurity as rls_an,
       (select string_agg(policyname || ' ' || cmd || ' ' || array_to_string(roles, ','), '; ')
          from pg_policies where schemaname = 'public' and tablename = 'app_versionen') as policies,
       (select string_agg(grantee || ':' || privilege_type, ', ' order by grantee, privilege_type)
          from information_schema.role_table_grants
         where table_schema = 'public' and table_name = 'app_versionen'
           and grantee in ('anon', 'authenticated')) as rechte
from public.app_versionen v
cross join pg_class c
where c.oid = 'public.app_versionen'::regclass
order by v.plattform;
