-- ============================================================================
-- Kurs-Badges fuer den UML-Kurs (App, Release 1.8.0)
-- ============================================================================
-- Vergabe ueber BadgeService.checkKursBadges(kursSlug: 'uml'):
--   kurs_uml_start:   erste Lektion komplett geloest
--   kurs_uml_haelfte: 6 von 11 geplanten Lektionen
--   kurs_uml_meister: alle 11 Lektionen
-- Die App rechnet gegen Kurs.lektionenGeplant (11), Haelfte = ceil(11 / 2).
-- Nur neue Zeilen, keine Aenderung an bestehenden Badges, keine Rechte.
-- sort_order 212 bis 214 (209 frei, 210 und 211 sind Quiz-Badges).
-- Im SQL Editor des Projekts ybvwjmaicoffitngtmzl ausfuehren.

begin;

insert into public.badges (id, name, description, icon, category, requirement_type, requirement_value, sort_order) values
  ('kurs_uml_start', 'UML-Starter',
   'Erste Lektion des UML-Kurses abgeschlossen', '📐', 'kurs', 'lektionen_completed', 1, 212),
  ('kurs_uml_haelfte', 'Modellierer',
   'Die Hälfte des UML-Kurses geschafft', '🗺️', 'kurs', 'lektionen_completed', 6, 213),
  ('kurs_uml_meister', 'UML-Meister',
   'Alle 11 Lektionen des UML-Kurses abgeschlossen', '🏛️', 'kurs', 'lektionen_completed', 11, 214)
on conflict (id) do nothing;

commit;

-- Kontrolle: erwartet 3 Zeilen kurs_uml_* (212 bis 214)
select id, name, requirement_value, sort_order
from public.badges
where id like 'kurs_uml_%'
order by sort_order;
