-- ============================================================================
-- Badges fuer das Anschluss-Quiz (Steckertypen erkennen)
-- ============================================================================
-- Die App vergibt sie ueber BadgeService.checkAnschlussBadges():
--   anschluss_kenner: Quiz mit mindestens 80 Prozent abgeschlossen
--   anschluss_profi:  alle Anschluesse richtig erkannt (100 Prozent)
-- Im SQL Editor des Projekts ybvwjmaicoffitngtmzl ausfuehren.

insert into public.badges (id, name, description, icon, category, requirement_type, requirement_value, sort_order) values
  ('anschluss_kenner', 'Kabelkenner',
   'Anschluss-Quiz mit mindestens 80 Prozent geschafft', '🔌', 'quiz', 'quiz_prozent', 80, 210),
  ('anschluss_profi', 'Anschluss-Profi',
   'Alle Anschlüsse im Quiz richtig erkannt', '🎯', 'quiz', 'quiz_prozent', 100, 211)
on conflict (id) do nothing;
