-- 2026-09-17: Nachzug zu 20260917010000 - die zwei Code-Fragen, die dort
-- ausgenommen waren und noch ueber 70 Zeichen je Antwort lagen.

begin;

-- 230328: Was zeigt der Befehl `tail -f /var/log/nginx/error.log`?
update public.antworten set text = 'Das Dateiende und danach live jede neue Zeile' where id = 1006592;
update public.antworten set text = 'Die ersten zehn Zeilen, ohne Nachladen neuer Zeilen' where id = 1006593;
update public.antworten set text = 'Die ganze Datei in einem Editor zum Bearbeiten' where id = 1006594;
update public.antworten set text = 'Größe, Besitzer und Änderungsdatum wie `ls -l`' where id = 1006595;

-- 230336: Welche Zeile enthaelt einen Fehler?
update public.antworten set text = 'Zeile 3, `"true"` ist ein String, kein `boolean`' where id = 1006624;
update public.antworten set text = 'Zeile 1, so kleine Zahlen brauchen `byte` statt `int`' where id = 1006625;
update public.antworten set text = 'Zeile 2, ein `String` braucht einfache Anführungszeichen' where id = 1006626;
update public.antworten set text = 'Zeile 4, ein `double` braucht ein Komma statt Punkt' where id = 1006627;

commit;

-- Kontrolle: select frage_id, string_agg(length(text)::text, '/' order by id) from antworten where frage_id in (230328, 230336) group by 1;
