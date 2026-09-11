-- 2026-09-10: Aktionen (zeitlich begrenzte Angebote), serverseitig schaltbar.
--
-- Anlass: "Pruefungs-Endspurt" zur AP1 am 30.09.2026 - erster Monat Premium
-- fuer 5,99 EUR statt 11,99 EUR. Der Rabatt selbst wird in den Stores
-- konfiguriert (Apple: Einfuehrungsangebot auf lernarena_premium_monthly,
-- Google: Angebot auf Base Plan monthly, Berechtigung "vom Entwickler
-- festgelegt"). Die App zeigt die Aktion nur an, wenn hier eine aktive Zeile
-- im Gueltigkeitszeitraum liegt: Karte im Lernhub unter dem Countdown und
-- Hinweis im Premium-Sheet beim Monatsplan. Premium-Nutzer sehen nichts.
--
-- Damit laesst sich die Aktion beenden oder zur AP2 im Winter wieder
-- einschalten, ohne ein App-Release. Preise stehen bewusst NICHT hier -
-- die kommen weiterhin aus dem Store (Apple prueft, dass angezeigte Preise
-- mit StoreKit uebereinstimmen). Der Text nennt den Rabatt nur beschreibend.
--
-- Nur lesbar fuer Clients, Pflege per SQL-Editor/Migration.

begin;

create table if not exists public.aktionen (
  id           serial primary key,
  schluessel   text not null unique,      -- z. B. 'endspurt_ap1_2026'
  titel        text not null,             -- Karten-Titel
  text         text not null,             -- Karten-Text (ein bis zwei Saetze)
  hinweis      text,                      -- Kleingedrucktes, z. B. Verlaengerung zum Normalpreis
  plan         text check (plan in ('monthly', 'half-year', 'annual')),
  gueltig_von  date not null,
  gueltig_bis  date not null,             -- einschliesslich
  aktiv        boolean not null default true,
  created_at   timestamptz not null default now(),
  check (gueltig_bis >= gueltig_von)
);

comment on table public.aktionen is 'Zeitlich begrenzte Angebote; die App zeigt aktive Zeilen im Zeitraum an. Rabatt wird in den Stores konfiguriert.';

alter table public.aktionen enable row level security;
drop policy if exists "aktionen lesen" on public.aktionen;
create policy "aktionen lesen" on public.aktionen
  for select to anon, authenticated
  using (aktiv and current_date between gueltig_von and gueltig_bis);
revoke insert, update, delete on public.aktionen from anon, authenticated;
grant select on public.aktionen to anon, authenticated;
grant all on public.aktionen to service_role;
grant usage, select on sequence public.aktionen_id_seq to service_role;

insert into public.aktionen (schluessel, titel, text, hinweis, plan, gueltig_von, gueltig_bis)
values (
  'endspurt_ap1_2026',
  'Prüfungs-Endspurt',
  'Bis zur AP1 am 30. September: dein erster Monat Premium zum halben Preis.',
  'Gilt für das Monatsabo, einmalig für den ersten Monat. Danach verlängert es sich zum regulären Preis, jederzeit kündbar.',
  'monthly',
  '2026-09-10',
  '2026-09-30'
)
on conflict (schluessel) do nothing;

commit;

-- Kontrolle:
-- select schluessel, plan, gueltig_von, gueltig_bis, aktiv from aktionen;
-- Aktion beenden: update aktionen set aktiv = false where schluessel = 'endspurt_ap1_2026';
