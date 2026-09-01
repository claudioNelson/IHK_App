-- 20260901100000_ihk_exams.sql
--
-- Die fuenf IHK-Pruefungssimulationen der App (lib/data/exams/*.dart)
-- bekommen Zeilen in public.exams, damit Ergebnisse in
-- user_exam_attempts eine Referenz haben und im Profil (App + Web)
-- unter "Bestandene Pruefungen" auftauchen koennen.
--
-- typ = 'ihk' unterscheidet sie von den Zertifikats-Uebungen (typ 'uebung').
-- slug = App-interne ID ('ae-1' ...), darueber findet die App die Zeile.

alter table public.exams add column if not exists slug text;
create unique index if not exists exams_slug_key on public.exams (slug) where slug is not null;

-- Sequence absichern, falls frueher Ids von Hand vergeben wurden
select setval(
  pg_get_serial_sequence('public.exams', 'id'),
  greatest((select coalesce(max(id), 0) from public.exams), 1)
);

insert into public.exams
  (name, beschreibung, typ, gesamt_punkte, bestehen_prozent, dauer_minuten,
   anzahl_aufgaben, zertifikat_id, is_published, slug, created_at, updated_at)
select v.name, v.beschreibung, 'ihk', 100, 50, 90, v.aufgaben, null, true, v.slug, now(), now()
from (values
  ('AE Übungsprüfung 1', 'Anwendungsentwicklung · Winter 2016 · TransLogic GmbH', 4, 'ae-1'),
  ('AE Übungsprüfung 2', 'Anwendungsentwicklung · Sommer 2017 · SecureID GmbH', 4, 'ae-2'),
  ('AE Übungsprüfung 3', 'Anwendungsentwicklung · Winter 2019 · RadMobil GmbH', 4, 'ae-3'),
  ('SI Übungsprüfung 1', 'Systemintegration · Sommer 2017 · MediTech Solutions GmbH', 4, 'si-1'),
  ('SI Übungsprüfung 2', 'Systemintegration · Winter 2016 · DataCenter Solutions AG', 4, 'si-2')
) as v(name, beschreibung, aufgaben, slug)
where not exists (select 1 from public.exams e where e.slug = v.slug);
