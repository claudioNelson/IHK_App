-- ============================================================================
-- Kurs-Badges fuer den Struktogramm-Kurs (App, Release 1.8.0)
-- ============================================================================
-- Vergabe ueber BadgeService.checkKursBadges(kursSlug: 'struktogramm'):
--   kurs_struktogramm_start:   erste Lektion komplett geloest
--   kurs_struktogramm_haelfte: 5 von 10 geplanten Lektionen
--   kurs_struktogramm_meister: alle 10 Lektionen
-- Die App rechnet gegen Kurs.lektionenGeplant (10), Haelfte = ceil(10 / 2).
-- Nur neue Zeilen, keine Aenderung an bestehenden Badges, keine Rechte.
-- Laufende App-Versionen kennen den Kurs nicht und sind nicht betroffen.
-- Icons wie bei den SQL- und Python-Badges.
-- Im SQL Editor des Projekts ybvwjmaicoffitngtmzl ausfuehren.

begin;

insert into public.badges (id, name, description, icon, category, requirement_type, requirement_value, sort_order) values
  ('kurs_struktogramm_start', 'Struktogramm-Starter',
   'Erste Lektion des Struktogramm-Kurses abgeschlossen', '🧩', 'kurs', 'lektionen_completed', 1, 206),
  ('kurs_struktogramm_haelfte', 'Ablaufprofi',
   'Die Hälfte des Struktogramm-Kurses geschafft', '🔀', 'kurs', 'lektionen_completed', 5, 207),
  ('kurs_struktogramm_meister', 'Struktogramm-Meister',
   'Alle 10 Lektionen des Struktogramm-Kurses abgeschlossen', '🎓', 'kurs', 'lektionen_completed', 10, 208)
on conflict (id) do nothing;

commit;

-- Kontrolle: erwartet 3 Zeilen kurs_struktogramm_* (206 bis 208)
select id, name, requirement_value, sort_order
from public.badges
where id like 'kurs_struktogramm_%'
order by sort_order;
