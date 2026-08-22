-- ============================================================================
-- Kurs-Badges fuer den Python-Kurs
-- ============================================================================
-- Vergabe ueber BadgeService.checkKursBadges(kursSlug: 'python'):
--   kurs_python_start:   erste Lektion komplett geloest
--   kurs_python_haelfte: 7 von 14 geplanten Lektionen
--   kurs_python_meister: alle 14 geplanten Lektionen
-- Die App rechnet gegen Kurs.lektionenGeplant (14), solange der Kurs im
-- Aufbau ist. Im SQL Editor des Projekts ybvwjmaicoffitngtmzl ausfuehren.

insert into public.badges (id, name, description, icon, category, requirement_type, requirement_value, sort_order) values
  ('kurs_python_start', 'Python-Starter',
   'Erste Lektion des Python-Kurses abgeschlossen', '🐍', 'kurs', 'lektionen_completed', 1, 203),
  ('kurs_python_haelfte', 'Schlangenbeschwörer',
   'Die Hälfte des Python-Kurses geschafft', '🔥', 'kurs', 'lektionen_completed', 7, 204),
  ('kurs_python_meister', 'Python-Meister',
   'Alle 14 Lektionen des Python-Kurses abgeschlossen', '👑', 'kurs', 'lektionen_completed', 14, 205)
on conflict (id) do nothing;

select id, name from public.badges where id like 'kurs_%' order by sort_order;
