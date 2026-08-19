-- ============================================================================
-- Kurs-Badges fuer den SQL-Kurs (und als Muster fuer Python spaeter)
-- ============================================================================
-- Die App vergibt sie ueber BadgeService.checkKursBadges():
--   kurs_sql_start:   erste Lektion komplett geloest
--   kurs_sql_haelfte: die Haelfte der Lektionen (aktuell 7 von 14)
--   kurs_sql_meister: alle 14 Lektionen
--
-- WICHTIG: vorher pruefen, ob die Spaltennamen zur badges-Tabelle passen:
--   select * from badges limit 3;
-- Erwartet werden: id (text), name, description, icon, sort_order.

insert into public.badges (id, name, description, icon, sort_order) values
  ('kurs_sql_start', 'SQL-Starter',
   'Erste Lektion des SQL-Kurses abgeschlossen', '🌱', 200),
  ('kurs_sql_haelfte', 'Halbzeit',
   'Die Haelfte des SQL-Kurses geschafft', '⚡', 201),
  ('kurs_sql_meister', 'SQL-Meister',
   'Alle 14 Lektionen des SQL-Kurses abgeschlossen', '🏆', 202)
on conflict (id) do nothing;
