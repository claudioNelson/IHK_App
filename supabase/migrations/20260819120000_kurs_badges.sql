-- ============================================================================
-- Kurs-Badges fuer den SQL-Kurs (und als Muster fuer Python spaeter)
-- ============================================================================
-- Ausgefuehrt am 20.08.2026 im Projekt ybvwjmaicoffitngtmzl (SQL Editor).
-- Die App vergibt sie ueber BadgeService.checkKursBadges():
--   kurs_sql_start:   erste Lektion komplett geloest
--   kurs_sql_haelfte: die Haelfte der Lektionen (aktuell 7 von 14)
--   kurs_sql_meister: alle 14 Lektionen
--
-- Die badges-Tabelle hat Pflichtspalten category, requirement_type und
-- requirement_value, daher muessen sie hier mitgeliefert werden.

insert into public.badges (id, name, description, icon, category, requirement_type, requirement_value, sort_order) values
  ('kurs_sql_start', 'SQL-Starter',
   'Erste Lektion des SQL-Kurses abgeschlossen', '🌱', 'kurs', 'lektionen_completed', 1, 200),
  ('kurs_sql_haelfte', 'Halbzeit',
   'Die Haelfte des SQL-Kurses geschafft', '⚡', 'kurs', 'lektionen_completed', 7, 201),
  ('kurs_sql_meister', 'SQL-Meister',
   'Alle 14 Lektionen des SQL-Kurses abgeschlossen', '🏆', 'kurs', 'lektionen_completed', 14, 202)
on conflict (id) do nothing;
