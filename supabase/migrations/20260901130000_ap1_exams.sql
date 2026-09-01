-- 20260901130000_ap1_exams.sql
--
-- Die beiden AP1-Uebungspruefungen der Web-Version (web/data/exams/ap1-*.ts)
-- als exams-Zeilen, damit Web-Ergebnisse in user_exam_attempts gespeichert
-- und im Profil angezeigt werden koennen. Slug = Web-ID.

insert into public.exams
  (name, beschreibung, typ, gesamt_punkte, bestehen_prozent, dauer_minuten,
   anzahl_aufgaben, zertifikat_id, is_published, slug, created_at, updated_at)
select v.name, v.beschreibung, 'ihk', 100, 50, 90, 4, null, true, v.slug, now(), now()
from (values
  ('AP1 Übungsprüfung 1', 'Teil 1 (alle Fachrichtungen) · Herbst 2021 · Zahnarztpraxis Dr. Berger', 'ap1-1'),
  ('AP1 Übungsprüfung 2', 'Teil 1 (alle Fachrichtungen) · Frühjahr 2024 · Architekturbüro Hartmann & Partner', 'ap1-2')
) as v(name, beschreibung, slug)
where not exists (select 1 from public.exams e where e.slug = v.slug);
