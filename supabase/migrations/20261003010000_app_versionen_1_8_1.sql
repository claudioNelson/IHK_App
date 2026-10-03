-- 20261003010000_app_versionen_1_8_1.sql
--
-- Erst einspielen, wenn 1.8.1 in BEIDEN Stores freigegeben ist
-- (Play: Production 100 %, Apple: „Bereit zum Vertrieb“).
--
-- Wirkung: Nutzer mit 1.8.0 sehen beim nächsten Start den Hinweis
-- „Neue Version verfügbar“ (empfohlen, schließbar, erneut nach 7 Tagen),
-- damit die Ada-Korrekturen schnell ankommen. mindest_version bleibt
-- 1.7.3, es gibt also KEIN Pflicht-Update. Ältere Versionen als 1.8.0
-- kennen den Update-Hinweis noch nicht, für sie ändert sich nichts.

begin;

update app_versionen
   set aktuelle_version = '1.8.1',
       aktualisiert_am = now()
 where plattform = 'android';

update app_versionen
   set aktuelle_version = '1.8.1',
       aktualisiert_am = now()
 where plattform = 'ios';

commit;

-- Kontrolle (erwartet: 2 Zeilen, aktuelle_version 1.8.1, mindest_version 1.7.3)
select plattform, aktuelle_version, mindest_version, aktualisiert_am
  from app_versionen
 order by plattform;
