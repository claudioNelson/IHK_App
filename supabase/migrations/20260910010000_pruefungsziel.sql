-- 2026-09-10: Pruefungsziel je Nutzer (Countdown + Tagesplan, Phase 1).
--
-- Plan: claude/pruefungs-countdown-plan.md. Der Nutzer nennt Pruefung
-- (AP1/AP2), Fachrichtung (AE/SI) und Termin; die App zeigt den Countdown
-- im Lernhub und leitet spaeter den Tagesplan daraus ab.
--
-- profiles: drei neue, optionale Spalten. Die bestehende Policy "Users can
-- update own profile" (authenticated, auth.uid() = id) deckt das Schreiben
-- ab, Gaeste sind ebenfalls authenticated. protect_premium_columns betrifft
-- nur die Premium-Spalten.
--
-- pruefungstermine: Vorschlagsliste, die wir per Migration pflegen (neuer
-- Termin = kein App-Release). Nur lesbar fuer Clients. Bundeslaender mit
-- eigenen Terminen: der Nutzer kann das Datum im Screen immer aendern.
-- Eingetragen wird nur, was bestaetigt ist: AP1 Herbst 2026 = 30.09.2026
-- (AkA-Terminplan). AP2 Winter 2026/27 und AP1 Fruehjahr 2027 folgen nach
-- Gegenpruefung bei IHK/AkA - nicht raten.

begin;

alter table public.profiles
  add column if not exists pruefung       text check (pruefung in ('AP1', 'AP2')),
  add column if not exists fachrichtung   text check (fachrichtung in ('AE', 'SI')),
  add column if not exists pruefungsdatum date;

comment on column public.profiles.pruefung       is 'Zielpruefung: AP1 (Teil 1) oder AP2 (Teil 2). Null = kein Ziel gesetzt.';
comment on column public.profiles.fachrichtung   is 'AE = Anwendungsentwicklung, SI = Systemintegration.';
comment on column public.profiles.pruefungsdatum is 'Termin der Zielpruefung (vom Nutzer bestaetigt oder aus pruefungstermine uebernommen).';

create table if not exists public.pruefungstermine (
  id           serial primary key,
  pruefung     text not null check (pruefung in ('AP1', 'AP2')),
  bezeichnung  text not null,          -- z. B. "Herbst 2026"
  datum        date not null,
  hinweis      text,                   -- z. B. "Bundesweiter AkA-Termin, Bayern/BaWue abweichend"
  aktiv        boolean not null default true
);

alter table public.pruefungstermine enable row level security;
drop policy if exists "pruefungstermine lesen" on public.pruefungstermine;
create policy "pruefungstermine lesen" on public.pruefungstermine
  for select to anon, authenticated using (aktiv);
revoke insert, update, delete on public.pruefungstermine from anon, authenticated;
grant select on public.pruefungstermine to anon, authenticated;
grant all on public.pruefungstermine to service_role;
grant usage, select on sequence public.pruefungstermine_id_seq to service_role;

insert into public.pruefungstermine (pruefung, bezeichnung, datum, hinweis)
values ('AP1', 'Herbst 2026', '2026-09-30', 'Bundesweiter AkA-Termin. Bayern und Baden-Wuerttemberg pruefen teils abweichend - bitte bei deiner IHK nachsehen.')
on conflict do nothing;

commit;

-- Kontrolle:
-- select column_name from information_schema.columns where table_name='profiles' and column_name in ('pruefung','fachrichtung','pruefungsdatum');
-- select * from pruefungstermine;
