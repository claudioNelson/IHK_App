-- 2026-09-09: Code in Fragetexten als Codeblock markieren.
--
-- Die App (ab 1.6.1) rendert im Fragetext und in Antworten Markdown-artige
-- Markierungen: ```...``` als Codeblock (Monospace-Kasten, mehrzeilig),
-- `...` als Inline-Code. Widget: lib/widgets/frage_text.dart.
-- Aeltere App-Versionen zeigen die Backticks als Zeichen mit - harmlos.
--
-- Hier werden die neuen Fragen vom 08.09. (Syntax, SQL Basics, Linux CLI)
-- entsprechend umgeschrieben. Nur Text, keine Struktur.
--
-- Der BEFORE-Trigger trg_didactic_expl_aiu schreibt bei jeder Antwort-
-- Aenderung die Geschwister-Antworten mit; bei mehrzeiligen Updates
-- derselben Frage kollidiert das ("tuple to be updated was already
-- modified"). Deshalb fuer die Dauer der Migration abschalten - die
-- Erklaerungstexte sind bereits vorhanden und bleiben unveraendert.

begin;
alter table public.antworten disable trigger trg_didactic_expl_aiu;

-- Programmierung / Syntax & Grundlagen
update public.fragen set frage = E'Was gibt dieser Code aus?\n```\nint a = 7;\nint b = 2;\nSystem.out.println(a / b);\n```' where id = 230334;
update public.fragen set frage = 'Was ist das Ergebnis von `10 % 3` in den meisten Programmiersprachen?' where id = 230335;
update public.fragen set frage = E'Welche Zeile enthält einen Fehler?\n```\n(1) int zahl = 5;\n(2) String name = "Anna";\n(3) boolean ok = "true";\n(4) double preis = 9.99;\n```' where id = 230336;
update public.antworten set text = 'Zeile 3 – ein `boolean` bekommt `true` ohne Anführungszeichen, `"true"` ist ein String' where frage_id = 230336 and ist_richtig;

-- Datenbanken / SQL Basics: Antworten sind SQL-Anweisungen
update public.antworten set text = '`' || text || '`'
 where frage_id in (230319, 230321, 230322, 230323)
   and text not like '`%';
update public.fragen set frage = 'Was ist der Unterschied zwischen `DELETE FROM kunden WHERE id = 5;` und `DELETE FROM kunden;`?' where id = 230320;

-- Betriebssysteme / Linux CLI
update public.fragen set frage = 'Was bewirkt der Befehl `grep -i fehler /var/log/syslog`?' where id = 230324;
update public.fragen set frage = 'Was ist der Unterschied zwischen `>` und `>>` bei der Ausgabeumleitung?' where id = 230325;
update public.antworten set text = '`>` überschreibt die Zieldatei, `>>` hängt die Ausgabe am Ende an' where frage_id = 230325 and ist_richtig;
update public.antworten set text = '`>` hängt an, `>>` überschreibt' where frage_id = 230325 and text = '> hängt an, >> überschreibt';
update public.antworten set text = '`>` leitet in eine Datei, `>>` in ein Programm' where frage_id = 230325 and text = '> leitet in eine Datei, >> in ein Programm';
update public.fragen set frage = 'Was macht die Befehlskette `cat zugriffe.log | grep 404 | wc -l`?' where id = 230326;
update public.antworten set text = '`' || text || '`' where frage_id = 230327 and text not like '`%';
update public.fragen set frage = 'Was zeigt der Befehl `tail -f /var/log/nginx/error.log`?' where id = 230328;

alter table public.antworten enable trigger trg_didactic_expl_aiu;
commit;

-- Kontrolle: select id, frage from fragen where id in (230334, 230336);
--            select frage_id, text from antworten where frage_id in (230319, 230327) order by 1;
