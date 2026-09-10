-- 2026-09-08: 20 Fragen (mittel) fuer die fuenf duennen Themen (< 10 Fragen).
--
-- Befund nach den Einstiegsfragen: Nur noch 5 Themen haben unter 10 Fragen,
-- und zwar genau die, die schon 5 einfache hatten und deshalb keine neuen
-- bekamen: SQL Basics (5), Linux CLI & Tools Basics (5), Netz- & Web-Basics
-- (5), Syntax & Grundlagen (7), Hardware-Basics (8). Ihnen fehlt die Stufe
-- 'mittel' (Anwendung, Vergleich, kleine Aufgabe, Fehlersuche).
-- Auffuellen auf je 10: +5 / +5 / +5 / +3 / +2.
-- Fragetexte zum Gegenlesen: docs/neue_fragen_duenne_themen_2026-09-08.md
--
-- IDs 230319-230338 explizit. Antworten ueber die Sequenz, Erklaerung nur
-- bei der richtigen Antwort (Trigger ergaenzt die falschen). Am Ende
-- Themen-Badges neu berechnen (diese Themen bleiben 'leicht': 50 % einfach).

begin;

-- SQL Basics: Welche Abfrage liefert alle Kunden aus Köln, sortiert nach Nachname aufsteigend?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230319, 9003, 9302, 'Welche Abfrage liefert alle Kunden aus Köln, sortiert nach Nachname aufsteigend?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230319, 'SELECT * FROM kunden WHERE ort = ''Köln'' ORDER BY nachname ASC;', true, 'Reihenfolge der Klauseln: SELECT, FROM, WHERE (filtern), ORDER BY (sortieren). Textwerte stehen in einfachen Anführungszeichen, ASC ist aufsteigend und Standard.'),
  (230319, 'SELECT * FROM kunden ORDER BY nachname WHERE ort = ''Köln'';', false, null),
  (230319, 'SELECT * FROM kunden WHERE ort = Köln SORT BY nachname;', false, null),
  (230319, 'SELECT kunden WHERE ort = ''Köln'' ORDER nachname ASC;', false, null);

-- SQL Basics: Was ist der Unterschied zwischen DELETE FROM kunden WHERE id = 5; und DELETE FRO
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230320, 9003, 9302, 'Was ist der Unterschied zwischen DELETE FROM kunden WHERE id = 5; und DELETE FROM kunden;?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230320, 'Die erste Anweisung löscht nur den Kunden mit id 5, die zweite löscht alle Zeilen der Tabelle', true, 'Ohne WHERE gilt DELETE für jede Zeile. Deshalb: WHERE-Bedingung immer zuerst mit SELECT testen, bevor man DELETE oder UPDATE ausführt.'),
  (230320, 'Die zweite Anweisung löscht die ganze Tabelle inklusive Struktur', false, null),
  (230320, 'Die erste löscht die Spalte id', false, null),
  (230320, 'Beide löschen nur eine Zeile', false, null);

-- SQL Basics: Mit welcher Anweisung setzt man den Preis des Produkts mit id 7 auf 19.99?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230321, 9003, 9302, 'Mit welcher Anweisung setzt man den Preis des Produkts mit id 7 auf 19.99?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230321, 'UPDATE produkte SET preis = 19.99 WHERE id = 7;', true, 'UPDATE braucht die Tabelle, SET mit dem neuen Wert und WHERE, um die Zeile einzugrenzen. Ohne WHERE bekämen alle Produkte den Preis 19.99.'),
  (230321, 'UPDATE produkte preis = 19.99 WHERE id = 7;', false, null),
  (230321, 'SET produkte.preis = 19.99 WHERE id = 7;', false, null),
  (230321, 'CHANGE produkte SET preis = 19.99 FOR id = 7;', false, null);

-- SQL Basics: Welche Abfrage findet alle Produkte, deren Name mit „USB“ beginnt?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230322, 9003, 9302, 'Welche Abfrage findet alle Produkte, deren Name mit „USB“ beginnt?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230322, 'SELECT * FROM produkte WHERE name LIKE ''USB%'';', true, 'LIKE vergleicht Muster: % steht für beliebig viele Zeichen, _ für genau eines. ''USB%'' trifft also „USB-Stick“ und „USB-Kabel“, aber nicht „Mini-USB“.'),
  (230322, 'SELECT * FROM produkte WHERE name = ''USB%'';', false, null),
  (230322, 'SELECT * FROM produkte WHERE name LIKE ''%USB'';', false, null),
  (230322, 'SELECT * FROM produkte WHERE name STARTS ''USB'';', false, null);

-- SQL Basics: Welche Abfrage liefert die Anzahl der Bestellungen mit einem Betrag über 100?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230323, 9003, 9302, 'Welche Abfrage liefert die Anzahl der Bestellungen mit einem Betrag über 100?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230323, 'SELECT COUNT(*) FROM bestellungen WHERE betrag > 100;', true, 'COUNT(*) zählt die Zeilen, die die WHERE-Bedingung erfüllen. Das Ergebnis ist eine einzelne Zahl, keine Liste.'),
  (230323, 'SELECT COUNT(betrag > 100) FROM bestellungen;', false, null),
  (230323, 'SELECT SUM(*) FROM bestellungen WHERE betrag > 100;', false, null),
  (230323, 'COUNT * FROM bestellungen WHERE betrag > 100;', false, null);

-- Linux CLI & Tools Basics: Was bewirkt der Befehl grep -i fehler /var/log/syslog?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230324, 9005, 9502, 'Was bewirkt der Befehl grep -i fehler /var/log/syslog?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230324, 'Er zeigt alle Zeilen der Datei, die „fehler“ enthalten – Groß-/Kleinschreibung wird ignoriert', true, '-i steht für ignore case: „Fehler“, „FEHLER“ und „fehler“ werden gefunden. Mit -n bekommt man zusätzlich die Zeilennummern, mit -r sucht grep rekursiv in Ordnern.'),
  (230324, 'Er löscht alle Zeilen mit „fehler“ aus der Datei', false, null),
  (230324, 'Er zeigt nur die erste Zeile mit „Fehler“ in exakter Schreibweise', false, null),
  (230324, 'Er zählt, wie oft „fehler“ vorkommt', false, null);

-- Linux CLI & Tools Basics: Was ist der Unterschied zwischen > und >> bei der Ausgabeumleitung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230325, 9005, 9502, 'Was ist der Unterschied zwischen > und >> bei der Ausgabeumleitung?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230325, '> überschreibt die Zieldatei, >> hängt die Ausgabe am Ende an', true, '„echo Test > log.txt“ ersetzt den Inhalt komplett, „echo Test >> log.txt“ fügt eine Zeile hinzu. Bei Logdateien nimmt man deshalb >>.'),
  (230325, '> hängt an, >> überschreibt', false, null),
  (230325, '> leitet in eine Datei, >> in ein Programm', false, null),
  (230325, 'Es gibt keinen Unterschied', false, null);

-- Linux CLI & Tools Basics: Was macht die Befehlskette cat zugriffe.log | grep 404 | wc -l?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230326, 9005, 9502, 'Was macht die Befehlskette cat zugriffe.log | grep 404 | wc -l?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230326, 'Sie zählt, wie viele Zeilen der Logdatei „404“ enthalten', true, 'cat gibt die Datei aus, grep filtert die Zeilen mit 404, wc -l zählt die Zeilen. Die Pipe | reicht die Ausgabe jeweils an den nächsten Befehl weiter.'),
  (230326, 'Sie löscht alle Zeilen mit 404', false, null),
  (230326, 'Sie zeigt die 404 längsten Zeilen', false, null),
  (230326, 'Sie speichert die Zeilen mit 404 in einer neuen Datei', false, null);

-- Linux CLI & Tools Basics: Mit welchem Befehl installiert man unter Ubuntu das Paket nginx?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230327, 9005, 9502, 'Mit welchem Befehl installiert man unter Ubuntu das Paket nginx?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230327, 'sudo apt install nginx', true, 'apt ist der Paketmanager von Debian/Ubuntu, install der Unterbefehl, sudo liefert die nötigen Rechte. Vorher aktualisiert „sudo apt update“ die Paketlisten.'),
  (230327, 'apt get nginx', false, null),
  (230327, 'sudo install nginx', false, null),
  (230327, 'yum install nginx', false, null);

-- Linux CLI & Tools Basics: Was zeigt der Befehl tail -f /var/log/nginx/error.log?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230328, 9005, 9502, 'Was zeigt der Befehl tail -f /var/log/nginx/error.log?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230328, 'Die letzten Zeilen der Datei und danach live jede neue Zeile, die hinzukommt', true, 'tail zeigt das Dateiende, -f (follow) bleibt geöffnet und zeigt neue Einträge sofort. So beobachtet man Logs, während man einen Fehler nachstellt. Beenden mit Strg+C.'),
  (230328, 'Die ersten zehn Zeilen der Datei', false, null),
  (230328, 'Die Datei komplett in einem Editor', false, null),
  (230328, 'Die Dateigröße in Byte', false, null);

-- Netz- & Web-Basics: Ein Mitarbeiter erhält eine E-Mail von „support@paypa1.com“ mit der Bitte, sein 
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230329, 9008, 9802, 'Ein Mitarbeiter erhält eine E-Mail von „support@paypa1.com“ mit der Bitte, sein Konto über einen Link zu bestätigen. Was ist die richtige Reaktion?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230329, 'Nicht klicken, die E-Mail als Phishing an die IT melden und PayPal nur über die selbst eingetippte Adresse aufrufen', true, 'Die Domain ist gefälscht (Ziffer 1 statt Buchstabe l), es wird Dringlichkeit erzeugt und ein Link vorgegeben – drei typische Phishing-Merkmale. Echte Anbieter fordern nie per Link zur Bestätigung von Zugangsdaten auf.'),
  (230329, 'Den Link öffnen und prüfen, ob die Seite echt aussieht', false, null),
  (230329, 'Auf die E-Mail antworten und nach Details fragen', false, null),
  (230329, 'Die E-Mail an Kollegen weiterleiten, damit alle Bescheid wissen', false, null);

-- Netz- & Web-Basics: Welche Firewall-Regel sollte für einen Webserver im Internet gelten?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230330, 9008, 9802, 'Welche Firewall-Regel sollte für einen Webserver im Internet gelten?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230330, 'Nur die benötigten Ports (80 und 443) von außen erlauben, alles andere blockieren', true, 'Prinzip „Deny by default“: Alles ist zu, nur was gebraucht wird, wird geöffnet. SSH (Port 22) sollte zusätzlich auf bestimmte Quell-IPs oder ein VPN beschränkt werden.'),
  (230330, 'Alle Ports öffnen, damit alle Dienste erreichbar sind', false, null),
  (230330, 'Nur Port 22 öffnen, damit der Admin arbeiten kann', false, null),
  (230330, 'Alle Ports blockieren, auch 80 und 443', false, null);

-- Netz- & Web-Basics: Warum ist ein öffentliches WLAN im Café ohne VPN riskant?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230331, 9008, 9802, 'Warum ist ein öffentliches WLAN im Café ohne VPN riskant?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230331, 'Andere Nutzer im selben Netz können unverschlüsselten Datenverkehr mitlesen oder sich als Zugangspunkt ausgeben', true, 'Im offenen WLAN teilen sich alle dasselbe Netz. Ein VPN verschlüsselt den gesamten Verkehr bis zum VPN-Server, sodass Mitlesen nichts bringt. HTTPS schützt nur die jeweilige Webseite.'),
  (230331, 'Das WLAN ist immer zu langsam für sichere Verbindungen', false, null),
  (230331, 'Der Laptop-Akku entlädt sich schneller', false, null),
  (230331, 'Öffentliche WLANs erlauben keine HTTPS-Seiten', false, null);

-- Netz- & Web-Basics: Ein Portscan zeigt auf einem Server die offenen Ports 22, 80, 443 und 3306. Welc
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230332, 9008, 9802, 'Ein Portscan zeigt auf einem Server die offenen Ports 22, 80, 443 und 3306. Welcher Port sollte am dringendsten geprüft werden?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230332, '3306 – die MySQL-Datenbank sollte nicht direkt aus dem Internet erreichbar sein', true, '22 (SSH), 80 und 443 (Web) sind bei einem Webserver erwartbar. Eine Datenbank auf 3306 gehört hinter die Firewall und ist nur für die Anwendung selbst gedacht – offen im Internet ist sie ein beliebtes Angriffsziel.'),
  (230332, '443 – HTTPS ist ein Sicherheitsrisiko', false, null),
  (230332, '80 – HTTP sollte nie offen sein', false, null),
  (230332, '22 – SSH ist immer unsicher', false, null);

-- Netz- & Web-Basics: Was ist der Unterschied zwischen HTTP und HTTPS in Bezug auf ein Login-Formular?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230333, 9008, 9802, 'Was ist der Unterschied zwischen HTTP und HTTPS in Bezug auf ein Login-Formular?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230333, 'Bei HTTP wird das Passwort im Klartext übertragen, bei HTTPS verschlüsselt', true, 'Ohne TLS kann jeder im Übertragungsweg (WLAN, Provider) die Formulardaten lesen. Browser warnen deshalb bei Passwortfeldern auf HTTP-Seiten mit „Nicht sicher“.'),
  (230333, 'HTTPS speichert das Passwort auf dem Server verschlüsselt, HTTP nicht', false, null),
  (230333, 'HTTP ist schneller und deshalb für Logins besser', false, null),
  (230333, 'Es gibt keinen Unterschied, beides ist unverschlüsselt', false, null);

-- Syntax & Grundlagen: Was gibt dieser Code aus? int a = 7; int b = 2; System.out.println(a / b);
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230334, 9007, 9701, 'Was gibt dieser Code aus? int a = 7; int b = 2; System.out.println(a / b);', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230334, '3', true, 'Bei der Division zweier Ganzzahlen (int) wird der Rest abgeschnitten: 7 / 2 = 3, nicht 3.5. Für 3.5 müsste mindestens ein Operand ein double sein, z. B. 7.0 / 2.'),
  (230334, '3.5', false, null),
  (230334, '4', false, null),
  (230334, '3,5', false, null);

-- Syntax & Grundlagen: Was ist das Ergebnis von 10 % 3 in den meisten Programmiersprachen?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230335, 9007, 9701, 'Was ist das Ergebnis von 10 % 3 in den meisten Programmiersprachen?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230335, '1', true, '% ist der Modulo-Operator und liefert den Rest der Division: 10 geteilt durch 3 ist 3 Rest 1. Modulo wird z. B. genutzt, um gerade Zahlen zu erkennen (x % 2 == 0).'),
  (230335, '3', false, null),
  (230335, '0.33', false, null),
  (230335, '3.33', false, null);

-- Syntax & Grundlagen: Welche Zeile enthält einen Fehler? (1) int zahl = 5; (2) String name = "Anna"; (
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230336, 9007, 9701, 'Welche Zeile enthält einen Fehler? (1) int zahl = 5; (2) String name = "Anna"; (3) boolean ok = "true"; (4) double preis = 9.99;', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230336, 'Zeile 3 – ein boolean bekommt true ohne Anführungszeichen, "true" ist ein String', true, 'Anführungszeichen machen aus einem Wert einen Text. boolean ok = true; ist richtig. Solche Typfehler meldet der Compiler vor dem Start.'),
  (230336, 'Zeile 1 – int darf keine kleinen Zahlen speichern', false, null),
  (230336, 'Zeile 2 – Strings brauchen einfache Anführungszeichen', false, null),
  (230336, 'Zeile 4 – double braucht ein Komma statt Punkt', false, null);

-- Hardware-Basics: Ein PC startet nicht, die Lüfter drehen kurz an und gehen wieder aus. Welche Kom
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230337, 9006, 9601, 'Ein PC startet nicht, die Lüfter drehen kurz an und gehen wieder aus. Welche Komponente ist als Erstes verdächtig?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230337, 'Das Netzteil oder die Stromversorgung des Mainboards', true, 'Kurzes Anlaufen und Abschalten deutet auf zu wenig oder instabile Spannung hin. Reihenfolge der Fehlersuche: Netzteil-Schalter und Kabel prüfen, dann Netzteil testen, erst danach Mainboard und RAM.'),
  (230337, 'Die Festplatte, weil das Betriebssystem fehlt', false, null),
  (230337, 'Der Monitor, weil kein Bild kommt', false, null),
  (230337, 'Die Tastatur, weil sie nicht reagiert', false, null);

-- Hardware-Basics: Ein Nutzer will seinen Büro-PC für Videoschnitt nachrüsten. Welche Aufrüstung br
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230338, 9006, 9601, 'Ein Nutzer will seinen Büro-PC für Videoschnitt nachrüsten. Welche Aufrüstung bringt dafür am meisten?', 'mittel', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230338, 'Mehr Arbeitsspeicher und eine leistungsfähige Grafikkarte', true, 'Videoschnitt braucht viel RAM für die Vorschau und nutzt die GPU zum Rendern. Eine größere Festplatte hilft beim Speichern, beschleunigt aber die Arbeit kaum; ein neues Netzteil nur, wenn die Leistung nicht reicht.'),
  (230338, 'Eine größere Festplatte und ein neues Gehäuse', false, null),
  (230338, 'Ein neues Netzteil und mehr USB-Anschlüsse', false, null),
  (230338, 'Ein zweiter Monitor und eine neue Tastatur', false, null);

select public.refresh_themen_schwierigkeit() as themen_aktualisiert;
commit;

-- Kontrolle: select thema_id, count(*) from fragen where id between 230319 and 230338 group by 1 order by 1;