-- 2026-09-08: 110 Einstiegsfragen (einfach) fuer Programmierung (9007),
-- IT-Sicherheit (9008), Webentwicklung (9009), Cloud & DevOps (9010),
-- Datenstrukturen & Algorithmen (9011).
--
-- Befund: Cloud & DevOps hatte in keinem der 5 Themen eine einzige einfache
-- Frage, Algorithmen nur in Thema 1; Web/Sicherheit/Programmierung fehlen
-- sie in den hinteren Themen. Uebersprungen, weil schon voll: Syntax &
-- Grundlagen, Sicherheits-Grundlagen, Netz- & Web-Basics.
-- Ziel: jedes Thema startet mit 5 reinen Faktfragen (docs/schwierigkeit_regel.md).
-- Fragetexte zum Gegenlesen: docs/neue_fragen_neue_module_b_2026-09-08.md
--
-- IDs 230209-230318 explizit (Bereich 230000+ fuer handgeschriebene Fragen).
-- Antworten ueber die Sequenz. Erklaerung nur bei der richtigen Antwort;
-- Trigger trg_didactic_expl_aiu erzeugt die "Nicht korrekt ..."-Texte.
-- Am Ende Themen-Badges neu berechnen.

begin;

-- Kontroll- & Datenstrukturen: Was ist eine Schleife in der Programmierung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230209, 9007, 9702, 'Was ist eine Schleife in der Programmierung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230209, 'Eine Anweisung, die einen Codeblock mehrfach wiederholt', true, 'Schleifen wie for und while führen denselben Code so oft aus, wie eine Bedingung erfüllt ist – z. B. für jedes Element einer Liste.'),
  (230209, 'Ein Fehler, der das Programm zum Absturz bringt', false, null),
  (230209, 'Eine Variable, die Text speichert', false, null),
  (230209, 'Ein Kommentar im Code', false, null);

-- Kontroll- & Datenstrukturen: Was ist ein Array?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230210, 9007, 9702, 'Was ist ein Array?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230210, 'Eine Sammlung mehrerer Werte gleichen Typs unter einem Namen, die über einen Index angesprochen werden', true, 'Statt zehn Variablen zahl1 bis zahl10 legt man ein Array zahlen[10] an. Der erste Eintrag hat in den meisten Sprachen den Index 0.'),
  (230210, 'Eine Funktion ohne Rückgabewert', false, null),
  (230210, 'Eine Textdatei mit Code', false, null),
  (230210, 'Ein Vergleichsoperator', false, null);

-- Kontroll- & Datenstrukturen: Welchen Index hat das erste Element eines Arrays in Sprachen wie Java, C oder Py
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230211, 9007, 9702, 'Welchen Index hat das erste Element eines Arrays in Sprachen wie Java, C oder Python?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230211, '0', true, 'Arrays sind nullbasiert: Das erste Element ist arr[0], das letzte arr[länge − 1]. Wer arr[länge] liest, bekommt einen Fehler.'),
  (230211, '1', false, null),
  (230211, '-1', false, null),
  (230211, 'Das hängt von der Länge ab', false, null);

-- Kontroll- & Datenstrukturen: Welche Werte kann eine Variable vom Typ boolean annehmen?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230212, 9007, 9702, 'Welche Werte kann eine Variable vom Typ boolean annehmen?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230212, 'true oder false', true, 'Der boolesche Typ kennt nur wahr und falsch. Er wird in Bedingungen wie if (istFertig) verwendet.'),
  (230212, '0 bis 255', false, null),
  (230212, 'Beliebigen Text', false, null),
  (230212, 'Ganze Zahlen', false, null);

-- Kontroll- & Datenstrukturen: Welcher Vergleichsoperator prüft in den meisten Programmiersprachen, ob zwei Wer
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230213, 9007, 9702, 'Welcher Vergleichsoperator prüft in den meisten Programmiersprachen, ob zwei Werte gleich sind?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230213, '==', true, 'Ein einzelnes = weist einen Wert zu, == vergleicht. Die Verwechslung ist ein klassischer Anfängerfehler.'),
  (230213, '=', false, null),
  (230213, '=>', false, null),
  (230213, '!=', false, null);

-- OOP & Fehlerbehandlung: Was ist eine Klasse in der objektorientierten Programmierung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230214, 9007, 9703, 'Was ist eine Klasse in der objektorientierten Programmierung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230214, 'Ein Bauplan, der beschreibt, welche Eigenschaften und Methoden Objekte haben', true, 'Die Klasse „Auto“ legt fest, dass jedes Auto eine Farbe hat und fahren kann. Ein konkretes Auto ist dann ein Objekt dieser Klasse.'),
  (230214, 'Eine Schleife, die Objekte zählt', false, null),
  (230214, 'Eine Datei mit Konfigurationen', false, null),
  (230214, 'Ein Fehler zur Laufzeit', false, null);

-- OOP & Fehlerbehandlung: Was ist ein Objekt in der OOP?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230215, 9007, 9703, 'Was ist ein Objekt in der OOP?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230215, 'Eine konkrete Instanz einer Klasse, z. B. ein bestimmtes Auto', true, 'Aus dem Bauplan „Klasse“ entstehen mit new beliebig viele Objekte, jedes mit eigenen Werten: ein rotes Auto, ein blaues Auto.'),
  (230215, 'Der Bauplan für Instanzen', false, null),
  (230215, 'Eine Methode ohne Parameter', false, null),
  (230215, 'Ein Kommentar im Quellcode', false, null);

-- OOP & Fehlerbehandlung: Was ist eine Methode?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230216, 9007, 9703, 'Was ist eine Methode?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230216, 'Eine Funktion, die zu einer Klasse gehört und beschreibt, was ihre Objekte tun können', true, 'Methoden sind das Verhalten eines Objekts: auto.fahren(), konto.einzahlen(50). Sie können auf die Attribute des Objekts zugreifen.'),
  (230216, 'Eine Variable in einer Klasse', false, null),
  (230216, 'Ein Datentyp für Text', false, null),
  (230216, 'Ein Vergleich zweier Objekte', false, null);

-- OOP & Fehlerbehandlung: Was bedeutet Vererbung in der OOP?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230217, 9007, 9703, 'Was bedeutet Vererbung in der OOP?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230217, 'Eine Klasse übernimmt Eigenschaften und Methoden einer anderen Klasse', true, 'Die Klasse „Lkw“ erbt von „Fahrzeug“ und bekommt automatisch alles, was Fahrzeug kann, plus eigene Ergänzungen. Das spart doppelten Code.'),
  (230217, 'Ein Objekt wird beim Programmende gelöscht', false, null),
  (230217, 'Eine Variable wird an eine Methode übergeben', false, null),
  (230217, 'Zwei Klassen haben denselben Namen', false, null);

-- OOP & Fehlerbehandlung: Was ist ein Attribut einer Klasse?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230218, 9007, 9703, 'Was ist ein Attribut einer Klasse?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230218, 'Eine Eigenschaft, die als Variable in der Klasse gespeichert wird, z. B. die Farbe eines Autos', true, 'Attribute (auch Felder oder Membervariablen) speichern den Zustand eines Objekts. Methoden arbeiten mit diesen Werten.'),
  (230218, 'Eine Funktion der Klasse', false, null),
  (230218, 'Der Name der Datei', false, null),
  (230218, 'Ein Fehler beim Kompilieren', false, null);

-- Build, Git & Tests: Was ist Git?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230219, 9007, 9704, 'Was ist Git?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230219, 'Ein Versionskontrollsystem, das Änderungen am Code nachvollziehbar speichert', true, 'Git merkt sich jeden Stand des Projekts als Commit. Man kann zurückspringen, parallel an Branches arbeiten und Änderungen im Team zusammenführen.'),
  (230219, 'Ein Programm zum Kompilieren von Java', false, null),
  (230219, 'Ein Texteditor', false, null),
  (230219, 'Ein Betriebssystem für Server', false, null);

-- Build, Git & Tests: Was ist ein Commit in Git?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230220, 9007, 9704, 'Was ist ein Commit in Git?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230220, 'Ein gespeicherter Stand der Änderungen mit einer Beschreibung', true, 'Mit „git commit -m ''Login-Fehler behoben''“ wird ein Schnappschuss der Änderungen dauerhaft in der Historie festgehalten.'),
  (230220, 'Das Löschen eines Branches', false, null),
  (230220, 'Der Download eines fremden Projekts', false, null),
  (230220, 'Ein Fehler beim Zusammenführen', false, null);

-- Build, Git & Tests: Was ist ein Repository?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230221, 9007, 9704, 'Was ist ein Repository?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230221, 'Der Speicherort eines Projekts inklusive seiner gesamten Versionsgeschichte', true, 'Das Repository (kurz Repo) enthält alle Dateien und alle Commits. Es liegt lokal auf dem Rechner und oft zusätzlich auf einem Server wie GitHub.'),
  (230221, 'Eine einzelne Quellcodedatei', false, null),
  (230221, 'Ein Programm zum Testen', false, null),
  (230221, 'Die Fehlerliste eines Projekts', false, null);

-- Build, Git & Tests: Was ist ein Unit-Test?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230222, 9007, 9704, 'Was ist ein Unit-Test?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230222, 'Ein automatischer Test, der eine einzelne kleine Einheit des Codes, z. B. eine Funktion, prüft', true, 'Ein Unit-Test ruft eine Funktion mit Beispielwerten auf und prüft, ob das erwartete Ergebnis herauskommt. Läuft er automatisch, fallen Fehler sofort auf.'),
  (230222, 'Ein Test der gesamten Anwendung durch Nutzer', false, null),
  (230222, 'Die Messung der Ladezeit einer Webseite', false, null),
  (230222, 'Ein Test des Netzwerks', false, null);

-- Build, Git & Tests: Was ist ein Bug?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230223, 9007, 9704, 'Was ist ein Bug?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230223, 'Ein Fehler im Programm, der zu falschem Verhalten oder einem Absturz führt', true, 'Bugs entstehen durch Tipp-, Denk- oder Logikfehler. Sie werden in einem Bugtracker erfasst und mit Tests, Debugger und Logs gesucht.'),
  (230223, 'Ein Kommentar im Quellcode', false, null),
  (230223, 'Eine Funktion ohne Rückgabewert', false, null),
  (230223, 'Ein Werkzeug zum Kompilieren', false, null);

-- Algorithmen & Secure Coding: Was ist ein Algorithmus?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230224, 9007, 9705, 'Was ist ein Algorithmus?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230224, 'Eine eindeutige Schritt-für-Schritt-Anleitung zur Lösung eines Problems', true, 'Ein Kochrezept ist ein Algorithmus: klare Schritte in fester Reihenfolge mit einem Ergebnis. In der Informatik z. B. „Sortiere diese Liste“.'),
  (230224, 'Eine Programmiersprache', false, null),
  (230224, 'Ein Fehler im Programm', false, null),
  (230224, 'Eine Datenbanktabelle', false, null);

-- Algorithmen & Secure Coding: Was macht ein Sortieralgorithmus?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230225, 9007, 9705, 'Was macht ein Sortieralgorithmus?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230225, 'Er bringt eine Liste von Elementen in eine bestimmte Reihenfolge, z. B. aufsteigend', true, 'Bekannte Sortierverfahren sind Bubble Sort, Quick Sort und Merge Sort. Sie unterscheiden sich in Geschwindigkeit und Speicherbedarf.'),
  (230225, 'Er löscht doppelte Elemente', false, null),
  (230225, 'Er verschlüsselt eine Liste', false, null),
  (230225, 'Er zählt die Elemente einer Liste', false, null);

-- Algorithmen & Secure Coding: Was bedeutet Rekursion?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230226, 9007, 9705, 'Was bedeutet Rekursion?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230226, 'Eine Funktion ruft sich selbst auf, bis eine Abbruchbedingung erreicht ist', true, 'Beispiel Fakultät: fak(5) = 5 · fak(4), fak(4) = 4 · fak(3) … bis fak(1) = 1. Ohne Abbruchbedingung läuft die Rekursion endlos.'),
  (230226, 'Eine Schleife, die rückwärts zählt', false, null),
  (230226, 'Das Löschen einer Variablen', false, null),
  (230226, 'Ein Kommentar, der sich wiederholt', false, null);

-- Algorithmen & Secure Coding: Was bedeutet Secure Coding?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230227, 9007, 9705, 'Was bedeutet Secure Coding?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230227, 'Programmieren so, dass Sicherheitslücken von vornherein vermieden werden', true, 'Dazu gehören z. B. Eingaben prüfen, Passwörter nie im Klartext speichern und Bibliotheken aktuell halten. Sicherheit wird beim Schreiben mitgedacht, nicht erst danach.'),
  (230227, 'Den Quellcode mit einem Passwort schützen', false, null),
  (230227, 'Nur mit verschlüsselten Dateien arbeiten', false, null),
  (230227, 'Code ohne Kommentare schreiben', false, null);

-- Algorithmen & Secure Coding: Warum sollte man Benutzereingaben in einem Programm immer prüfen?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230228, 9007, 9705, 'Warum sollte man Benutzereingaben in einem Programm immer prüfen?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230228, 'Weil fehlerhafte oder böswillige Eingaben zu Abstürzen oder Sicherheitslücken führen können', true, 'Ein Angreifer kann in ein Eingabefeld SQL-Befehle oder Skripte schreiben. Wer Eingaben validiert und filtert, schließt diese Tür.'),
  (230228, 'Weil der Compiler es sonst nicht übersetzt', false, null),
  (230228, 'Weil Eingaben sonst zu langsam sind', false, null),
  (230228, 'Weil Nutzer sonst keine Rückmeldung bekommen', false, null);

-- Auth & Kryptografie: Was bedeutet Authentifizierung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230229, 9008, 9803, 'Was bedeutet Authentifizierung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230229, 'Der Nachweis, dass jemand wirklich die Person ist, die er vorgibt zu sein, z. B. per Passwort', true, 'Authentifizierung beantwortet die Frage „Bist du wirklich du?“ – durch Wissen (Passwort), Besitz (Handy) oder Merkmal (Fingerabdruck). Autorisierung klärt danach, was man darf.'),
  (230229, 'Die Verschlüsselung von Dateien', false, null),
  (230229, 'Das Sichern von Daten auf einer externen Platte', false, null),
  (230229, 'Das Löschen alter Benutzerkonten', false, null);

-- Auth & Kryptografie: Wofür steht die Abkürzung 2FA?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230230, 9008, 9803, 'Wofür steht die Abkürzung 2FA?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230230, 'Zwei-Faktor-Authentifizierung – Anmeldung mit zwei verschiedenen Nachweisen', true, 'Neben dem Passwort braucht man einen zweiten Faktor, z. B. einen Code aus einer App oder per SMS. Selbst ein gestohlenes Passwort reicht dann nicht.'),
  (230230, 'Zwei-Firewall-Architektur', false, null),
  (230230, 'Fast Access Authentication', false, null),
  (230230, 'Zweifache Datenarchivierung', false, null);

-- Auth & Kryptografie: Was bedeutet Verschlüsselung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230231, 9008, 9803, 'Was bedeutet Verschlüsselung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230231, 'Daten werden so umgewandelt, dass nur jemand mit dem passenden Schlüssel sie lesen kann', true, 'Verschlüsselte Daten sehen für Unbefugte wie Zeichensalat aus. Erst mit dem richtigen Schlüssel werden sie wieder lesbar – z. B. bei HTTPS oder Messenger-Chats.'),
  (230231, 'Daten werden komprimiert, um Platz zu sparen', false, null),
  (230231, 'Daten werden dauerhaft gelöscht', false, null),
  (230231, 'Daten werden auf einen anderen Server kopiert', false, null);

-- Auth & Kryptografie: Was ist ein Hash-Wert?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230232, 9008, 9803, 'Was ist ein Hash-Wert?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230232, 'Eine feste Zeichenfolge, die aus beliebigen Daten berechnet wird und sich nicht zurückrechnen lässt', true, 'Ein Hash wie SHA-256 macht aus jeder Eingabe einen Fingerabdruck. Passwörter werden als Hash gespeichert, damit sie bei einem Datendiebstahl nicht im Klartext vorliegen.'),
  (230232, 'Ein verschlüsseltes Passwort, das entschlüsselt werden kann', false, null),
  (230232, 'Eine Sicherheitskopie einer Datei', false, null),
  (230232, 'Der Name eines Benutzerkontos', false, null);

-- Auth & Kryptografie: Wofür sorgt ein Passwort-Manager?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230233, 9008, 9803, 'Wofür sorgt ein Passwort-Manager?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230233, 'Er speichert für jeden Dienst ein eigenes starkes Passwort sicher verschlüsselt', true, 'Mit einem Passwort-Manager muss man sich nur ein Master-Passwort merken. Er erzeugt lange, zufällige Passwörter und füllt sie automatisch ein.'),
  (230233, 'Er schaltet Passwörter für alle Dienste ab', false, null),
  (230233, 'Er sendet Passwörter per E-Mail an den Administrator', false, null),
  (230233, 'Er macht Passwörter für alle sichtbar', false, null);

-- Betrieb & Incident Response: Was ist ein Sicherheitsvorfall (Security Incident)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230234, 9008, 9804, 'Was ist ein Sicherheitsvorfall (Security Incident)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230234, 'Ein Ereignis, das die Sicherheit von IT-Systemen oder Daten gefährdet, z. B. ein Virenbefall', true, 'Ein Incident kann ein gehackter Account, ein verlorener Laptop oder eine Ransomware-Infektion sein. Wichtig ist, dass er sofort gemeldet und dokumentiert wird.'),
  (230234, 'Ein geplantes Software-Update', false, null),
  (230234, 'Ein Stromausfall im Privathaushalt', false, null),
  (230234, 'Ein neues Benutzerkonto', false, null);

-- Betrieb & Incident Response: Was sollte ein Mitarbeiter als Erstes tun, wenn er einen Sicherheitsvorfall beme
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230235, 9008, 9804, 'Was sollte ein Mitarbeiter als Erstes tun, wenn er einen Sicherheitsvorfall bemerkt?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230235, 'Den Vorfall sofort der IT-Abteilung oder dem Sicherheitsbeauftragten melden', true, 'Schnelles Melden begrenzt den Schaden. Eigenmächtige Versuche, den Vorfall zu beheben, können Spuren vernichten oder die Lage verschlimmern.'),
  (230235, 'Den Computer selbst neu installieren', false, null),
  (230235, 'Abwarten, ob das Problem von allein verschwindet', false, null),
  (230235, 'Den Vorfall in sozialen Medien posten', false, null);

-- Betrieb & Incident Response: Was ist eine Logdatei?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230236, 9008, 9804, 'Was ist eine Logdatei?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230236, 'Eine Datei, in der ein System oder Programm Ereignisse mit Zeitstempel protokolliert', true, 'Logs zeigen, wer sich wann angemeldet hat, welche Fehler auftraten und was ein Server getan hat. Bei einem Sicherheitsvorfall sind sie die wichtigste Spur.'),
  (230236, 'Eine Sicherungskopie der Datenbank', false, null),
  (230236, 'Ein Passwortspeicher', false, null),
  (230236, 'Die Konfigurationsdatei der Firewall', false, null);

-- Betrieb & Incident Response: Was ist Schadsoftware (Malware)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230237, 9008, 9804, 'Was ist Schadsoftware (Malware)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230237, 'Programme, die absichtlich Schaden anrichten, z. B. Viren, Trojaner oder Ransomware', true, 'Malware ist der Oberbegriff für alle bösartigen Programme: Viren verbreiten sich, Trojaner tarnen sich, Ransomware verschlüsselt und erpresst.'),
  (230237, 'Fehlerhafte, aber harmlose Software', false, null),
  (230237, 'Software mit abgelaufener Lizenz', false, null),
  (230237, 'Programme, die zu viel Speicher brauchen', false, null);

-- Betrieb & Incident Response: Warum sollte jeder Mitarbeiter ein eigenes Benutzerkonto haben?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230238, 9008, 9804, 'Warum sollte jeder Mitarbeiter ein eigenes Benutzerkonto haben?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230238, 'Damit nachvollziehbar ist, wer was getan hat, und Rechte einzeln vergeben werden können', true, 'Bei geteilten Konten weiß man nach einem Vorfall nicht, wer verantwortlich war. Einzelkonten erlauben außerdem, Rechte gezielt zu vergeben und beim Ausscheiden zu sperren.'),
  (230238, 'Weil Computer sonst langsamer werden', false, null),
  (230238, 'Weil geteilte Konten mehr kosten', false, null),
  (230238, 'Weil das Betriebssystem es so verlangt', false, null);

-- Secure Dev & Advanced: Was bedeutet SQL-Injection?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230239, 9008, 9805, 'Was bedeutet SQL-Injection?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230239, 'Ein Angriff, bei dem über ein Eingabefeld eigene SQL-Befehle in die Datenbankabfrage eingeschleust werden', true, 'Tippt ein Angreifer in ein Login-Feld '' OR 1=1 -- und die Anwendung setzt das ungeprüft in die SQL-Abfrage ein, kann er sich ohne Passwort anmelden oder Daten auslesen.'),
  (230239, 'Das Einspielen eines Datenbank-Backups', false, null),
  (230239, 'Ein Fehler beim Anlegen einer Tabelle', false, null),
  (230239, 'Das Verschlüsseln einer Datenbank', false, null);

-- Secure Dev & Advanced: Was ist ein Penetrationstest?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230240, 9008, 9805, 'Was ist ein Penetrationstest?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230240, 'Ein beauftragter, kontrollierter Angriff auf ein System, um Sicherheitslücken zu finden', true, 'Beim Pentest versuchen Sicherheitsexperten mit Erlaubnis, in ein System einzudringen. Die gefundenen Lücken werden dokumentiert und behoben, bevor echte Angreifer sie nutzen.'),
  (230240, 'Ein Test der Internetgeschwindigkeit', false, null),
  (230240, 'Die Prüfung der Passwortstärke aller Mitarbeiter', false, null),
  (230240, 'Ein Belastungstest für Server', false, null);

-- Secure Dev & Advanced: Was ist ein Sicherheitspatch?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230241, 9008, 9805, 'Was ist ein Sicherheitspatch?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230241, 'Ein Update, das eine bekannte Sicherheitslücke in einer Software schließt', true, 'Hersteller veröffentlichen Patches, sobald eine Lücke bekannt wird. Wer sie nicht einspielt, bleibt angreifbar – viele große Angriffe nutzten längst gepatchte Lücken.'),
  (230241, 'Ein Programm, das Passwörter erzeugt', false, null),
  (230241, 'Ein Aufkleber auf dem Server', false, null),
  (230241, 'Eine Sicherungskopie der Festplatte', false, null);

-- Secure Dev & Advanced: Was ist ein Salt bei der Passwortspeicherung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230242, 9008, 9805, 'Was ist ein Salt bei der Passwortspeicherung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230242, 'Eine zufällige Zeichenfolge, die vor dem Hashen an das Passwort angehängt wird', true, 'Durch den Salt ergeben gleiche Passwörter unterschiedliche Hashes. Vorberechnete Tabellen (Rainbow Tables) werden dadurch nutzlos.'),
  (230242, 'Ein zweites Passwort für den Administrator', false, null),
  (230242, 'Die Verschlüsselung der Datenbank', false, null),
  (230242, 'Ein Passwort, das nur aus Zahlen besteht', false, null);

-- Secure Dev & Advanced: Was ist eine Sicherheitslücke (Schwachstelle) in Software?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230243, 9008, 9805, 'Was ist eine Sicherheitslücke (Schwachstelle) in Software?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230243, 'Ein Fehler, den Angreifer ausnutzen können, um unerlaubt Zugriff zu erhalten oder Schaden anzurichten', true, 'Schwachstellen entstehen z. B. durch ungeprüfte Eingaben, veraltete Bibliotheken oder Standardpasswörter. Sie werden in Datenbanken wie CVE erfasst.'),
  (230243, 'Eine Funktion, die noch nicht fertig ist', false, null),
  (230243, 'Ein Rechtschreibfehler in der Oberfläche', false, null),
  (230243, 'Eine zu langsame Ladezeit', false, null);

-- HTML/CSS/HTTP Basics: Wofür steht die Abkürzung HTML?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230244, 9009, 9901, 'Wofür steht die Abkürzung HTML?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230244, 'Hypertext Markup Language – die Sprache, mit der der Inhalt und die Struktur von Webseiten beschrieben werden', true, 'HTML legt fest, was auf einer Seite steht: Überschriften, Absätze, Links, Bilder. Das Aussehen übernimmt CSS, das Verhalten JavaScript.'),
  (230244, 'High Tech Modern Language', false, null),
  (230244, 'Hyper Transfer Markup Link', false, null),
  (230244, 'Home Tool Management Language', false, null);

-- HTML/CSS/HTTP Basics: Wofür wird CSS auf einer Webseite verwendet?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230245, 9009, 9901, 'Wofür wird CSS auf einer Webseite verwendet?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230245, 'Für die Gestaltung, also Farben, Schriften, Abstände und Layout', true, 'CSS (Cascading Style Sheets) trennt Aussehen von Inhalt. Eine CSS-Regel wie h1 { color: blue; } färbt alle Überschriften blau.'),
  (230245, 'Für die Speicherung von Daten in einer Datenbank', false, null),
  (230245, 'Für die Programmierung von Berechnungen', false, null),
  (230245, 'Für die Übertragung von E-Mails', false, null);

-- HTML/CSS/HTTP Basics: Welches HTML-Tag erzeugt einen Link zu einer anderen Seite?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230246, 9009, 9901, 'Welches HTML-Tag erzeugt einen Link zu einer anderen Seite?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230246, '<a>', true, 'Der Anker-Tag <a href="https://beispiel.de">Text</a> erzeugt einen klickbaren Link. Das Attribut href enthält das Ziel.'),
  (230246, '<link>', false, null),
  (230246, '<url>', false, null),
  (230246, '<href>', false, null);

-- HTML/CSS/HTTP Basics: Wofür steht die Abkürzung HTTP?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230247, 9009, 9901, 'Wofür steht die Abkürzung HTTP?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230247, 'Hypertext Transfer Protocol – das Protokoll, mit dem Browser und Webserver Daten austauschen', true, 'Der Browser schickt eine HTTP-Anfrage (Request), der Server antwortet mit einer HTTP-Antwort (Response), z. B. der HTML-Seite. HTTPS ist die verschlüsselte Variante.'),
  (230247, 'Home Text Transfer Program', false, null),
  (230247, 'High Throughput Transmission Port', false, null),
  (230247, 'Hyperlink Tracking Protocol', false, null);

-- HTML/CSS/HTTP Basics: Was bedeutet der HTTP-Statuscode 404?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230248, 9009, 9901, 'Was bedeutet der HTTP-Statuscode 404?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230248, 'Die angeforderte Seite wurde nicht gefunden', true, '404 Not Found ist der bekannteste Fehlercode: Die Adresse existiert nicht (mehr). 200 bedeutet OK, 500 ein Fehler auf dem Server.'),
  (230248, 'Die Anfrage war erfolgreich', false, null),
  (230248, 'Der Server ist überlastet', false, null),
  (230248, 'Der Nutzer ist nicht angemeldet', false, null);

-- JavaScript & DOM: Wofür wird JavaScript auf einer Webseite eingesetzt?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230249, 9009, 9902, 'Wofür wird JavaScript auf einer Webseite eingesetzt?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230249, 'Um die Seite interaktiv zu machen, z. B. auf Klicks zu reagieren oder Inhalte nachzuladen', true, 'JavaScript läuft im Browser und verändert die Seite, ohne sie neu zu laden: Formulare prüfen, Menüs öffnen, Daten von einem Server holen.'),
  (230249, 'Um die Struktur der Seite festzulegen', false, null),
  (230249, 'Um Schriftarten und Farben zu definieren', false, null),
  (230249, 'Um die Seite auf dem Server zu speichern', false, null);

-- JavaScript & DOM: Wofür steht die Abkürzung DOM?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230250, 9009, 9902, 'Wofür steht die Abkürzung DOM?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230250, 'Document Object Model – die Baumstruktur, mit der der Browser die HTML-Seite im Speicher darstellt', true, 'Über das DOM kann JavaScript jedes Element ansprechen und ändern, z. B. den Text einer Überschrift austauschen oder ein Element ausblenden.'),
  (230250, 'Data Output Method', false, null),
  (230250, 'Dynamic Online Module', false, null),
  (230250, 'Document Order Manager', false, null);

-- JavaScript & DOM: Mit welchem Schlüsselwort deklariert man in modernem JavaScript eine Variable, d
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230251, 9009, 9902, 'Mit welchem Schlüsselwort deklariert man in modernem JavaScript eine Variable, deren Wert sich ändern darf?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230251, 'let', true, 'let erzeugt eine veränderbare Variable, const eine Konstante. Das alte var sollte man in neuem Code vermeiden, weil es weniger strenge Regeln hat.'),
  (230251, 'const', false, null),
  (230251, 'int', false, null),
  (230251, 'define', false, null);

-- JavaScript & DOM: Mit welcher Funktion gibt man in JavaScript eine Meldung in der Browser-Konsole 
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230252, 9009, 9902, 'Mit welcher Funktion gibt man in JavaScript eine Meldung in der Browser-Konsole aus?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230252, 'console.log()', true, 'console.log("Hallo") schreibt in die Entwicklerkonsole des Browsers (F12). Das ist das wichtigste Werkzeug zum Nachvollziehen, was ein Skript tut.'),
  (230252, 'print()', false, null),
  (230252, 'echo()', false, null),
  (230252, 'System.out.println()', false, null);

-- JavaScript & DOM: Was ist ein Event in JavaScript?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230253, 9009, 9902, 'Was ist ein Event in JavaScript?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230253, 'Ein Ereignis wie ein Klick oder eine Tastatureingabe, auf das ein Skript reagieren kann', true, 'Mit button.addEventListener("click", funktion) wird eine Funktion ausgeführt, sobald der Nutzer klickt. Weitere Events: keydown, submit, load.'),
  (230253, 'Ein Fehler beim Laden der Seite', false, null),
  (230253, 'Eine Variable mit Datum und Uhrzeit', false, null),
  (230253, 'Ein Kommentar im Code', false, null);

-- Backend & REST: Was ist das Backend einer Webanwendung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230254, 9009, 9903, 'Was ist das Backend einer Webanwendung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230254, 'Der Teil, der auf dem Server läuft und Daten verarbeitet und speichert', true, 'Das Backend nimmt Anfragen entgegen, prüft Logins, liest und schreibt in die Datenbank und schickt Ergebnisse zurück. Das Frontend im Browser zeigt sie an.'),
  (230254, 'Die Oberfläche, die der Nutzer im Browser sieht', false, null),
  (230254, 'Das Design der Webseite', false, null),
  (230254, 'Die Domain der Webseite', false, null);

-- Backend & REST: Wofür steht die Abkürzung API?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230255, 9009, 9903, 'Wofür steht die Abkürzung API?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230255, 'Application Programming Interface – eine Schnittstelle, über die Programme miteinander kommunizieren', true, 'Eine Web-API stellt Funktionen über URLs bereit: Die App fragt /api/kunden ab und bekommt die Kundenliste als JSON zurück.'),
  (230255, 'Advanced Program Installer', false, null),
  (230255, 'Automatic Page Index', false, null),
  (230255, 'Application Password Interface', false, null);

-- Backend & REST: Wofür steht die Abkürzung JSON?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230256, 9009, 9903, 'Wofür steht die Abkürzung JSON?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230256, 'JavaScript Object Notation – ein Textformat zum Austausch strukturierter Daten', true, 'JSON sieht so aus: {"name": "Anna", "alter": 25}. Fast alle Web-APIs liefern ihre Daten in diesem Format, weil es leicht lesbar und von jeder Sprache verarbeitbar ist.'),
  (230256, 'Java Standard Object Network', false, null),
  (230256, 'Joint Server Output Node', false, null),
  (230256, 'JavaScript Online Navigation', false, null);

-- Backend & REST: Welche HTTP-Methode wird verwendet, um Daten von einem Server abzurufen?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230257, 9009, 9903, 'Welche HTTP-Methode wird verwendet, um Daten von einem Server abzurufen?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230257, 'GET', true, 'GET holt Daten (z. B. eine Seite oder eine Liste), POST sendet neue Daten an den Server, PUT ändert, DELETE löscht.'),
  (230257, 'POST', false, null),
  (230257, 'SEND', false, null),
  (230257, 'FETCH', false, null);

-- Backend & REST: Welche HTTP-Methode wird typischerweise verwendet, um neue Daten an den Server z
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230258, 9009, 9903, 'Welche HTTP-Methode wird typischerweise verwendet, um neue Daten an den Server zu schicken, z. B. ein ausgefülltes Formular?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230258, 'POST', true, 'POST überträgt Daten im Body der Anfrage an den Server, etwa beim Absenden einer Registrierung. GET dagegen ruft nur ab.'),
  (230258, 'GET', false, null),
  (230258, 'READ', false, null),
  (230258, 'OPEN', false, null);

-- Deployment & CI/CD: Was bedeutet Deployment bei einer Webanwendung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230259, 9009, 9904, 'Was bedeutet Deployment bei einer Webanwendung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230259, 'Die Anwendung auf einem Server bereitstellen, damit Nutzer sie erreichen können', true, 'Nach dem Entwickeln wird der Code gebaut, auf den Server kopiert und dort gestartet. Das kann manuell oder automatisch über eine Pipeline geschehen.'),
  (230259, 'Den Quellcode in Git speichern', false, null),
  (230259, 'Die Anwendung im Browser testen', false, null),
  (230259, 'Die Datenbank sichern', false, null);

-- Deployment & CI/CD: Was ist ein Webserver?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230260, 9009, 9904, 'Was ist ein Webserver?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230260, 'Ein Programm, das Webseiten und Dateien auf Anfrage an Browser ausliefert', true, 'Bekannte Webserver sind Apache und Nginx. Sie nehmen HTTP-Anfragen entgegen und schicken HTML, Bilder oder API-Antworten zurück.'),
  (230260, 'Ein Programm zum Erstellen von Webseiten', false, null),
  (230260, 'Der Browser des Nutzers', false, null),
  (230260, 'Ein Kabel zwischen Computer und Internet', false, null);

-- Deployment & CI/CD: Was ist eine Domain?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230261, 9009, 9904, 'Was ist eine Domain?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230261, 'Der lesbare Name einer Webseite, z. B. lernarena.app', true, 'Die Domain wird per DNS in die IP-Adresse des Servers übersetzt. Man registriert sie bei einem Anbieter und zahlt meist jährlich dafür.'),
  (230261, 'Die IP-Adresse des Servers', false, null),
  (230261, 'Das Passwort für den Webserver', false, null),
  (230261, 'Der Ordner mit den HTML-Dateien', false, null);

-- Deployment & CI/CD: Wofür steht die Abkürzung CI in CI/CD?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230262, 9009, 9904, 'Wofür steht die Abkürzung CI in CI/CD?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230262, 'Continuous Integration – Codeänderungen werden laufend automatisch zusammengeführt und getestet', true, 'Bei CI startet nach jedem Push automatisch ein Build mit Tests. Fehler fallen sofort auf, nicht erst Wochen später beim Zusammenführen.'),
  (230262, 'Computer Installation', false, null),
  (230262, 'Code Inspection', false, null),
  (230262, 'Central Interface', false, null);

-- Deployment & CI/CD: Was ist ein Hosting-Anbieter?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230263, 9009, 9904, 'Was ist ein Hosting-Anbieter?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230263, 'Ein Unternehmen, das Server und Speicherplatz für Webseiten und Anwendungen vermietet', true, 'Statt einen eigenen Server zu betreiben, mietet man Platz beim Hoster. Angebote reichen vom einfachen Webspace bis zu Cloud-Servern.'),
  (230263, 'Ein Programm zum Bearbeiten von HTML', false, null),
  (230263, 'Eine Firma, die Domains verkauft', false, null),
  (230263, 'Der Hersteller des Browsers', false, null);

-- Security & Performance: Woran erkennt man im Browser, dass eine Webseite verschlüsselt übertragen wird?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230264, 9009, 9905, 'Woran erkennt man im Browser, dass eine Webseite verschlüsselt übertragen wird?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230264, 'Am Schloss-Symbol und an „https://“ in der Adresszeile', true, 'HTTPS verschlüsselt die Verbindung per TLS. Ohne Schloss können Passwörter und Formulardaten unterwegs mitgelesen werden.'),
  (230264, 'An einem grünen Hintergrund der Seite', false, null),
  (230264, 'Daran, dass die Seite schneller lädt', false, null),
  (230264, 'An der Endung .de', false, null);

-- Security & Performance: Was ist ein Cookie?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230265, 9009, 9905, 'Was ist ein Cookie?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230265, 'Eine kleine Textdatei, die der Browser für eine Webseite speichert, z. B. um den Login zu merken', true, 'Cookies speichern Informationen wie Sitzungs-ID oder Spracheinstellung. Beim nächsten Besuch schickt der Browser sie automatisch mit.'),
  (230265, 'Ein Virus, der über Webseiten verbreitet wird', false, null),
  (230265, 'Ein Bild auf einer Webseite', false, null),
  (230265, 'Ein Programm zum Blockieren von Werbung', false, null);

-- Security & Performance: Warum sollte eine Webseite möglichst schnell laden?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230266, 9009, 9905, 'Warum sollte eine Webseite möglichst schnell laden?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230266, 'Weil Nutzer bei langen Ladezeiten abspringen und Suchmaschinen schnelle Seiten bevorzugen', true, 'Schon wenige Sekunden Wartezeit kosten Besucher. Große Bilder verkleinern, Dateien komprimieren und Caching nutzen sind die ersten Maßnahmen.'),
  (230266, 'Weil der Server sonst abstürzt', false, null),
  (230266, 'Weil langsame Seiten mehr Strom verbrauchen', false, null),
  (230266, 'Weil der Browser sonst eine Fehlermeldung zeigt', false, null);

-- Security & Performance: Was ist ein Cache im Zusammenhang mit Webseiten?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230267, 9009, 9905, 'Was ist ein Cache im Zusammenhang mit Webseiten?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230267, 'Ein Zwischenspeicher, in dem Browser oder Server bereits geladene Inhalte aufbewahren, damit sie beim nächsten Mal schneller da sind', true, 'Bilder, CSS und Skripte werden im Browser-Cache abgelegt. Beim zweiten Besuch müssen sie nicht erneut heruntergeladen werden.'),
  (230267, 'Ein Passwortspeicher im Browser', false, null),
  (230267, 'Eine Liste blockierter Webseiten', false, null),
  (230267, 'Der Verlauf besuchter Seiten', false, null);

-- Security & Performance: Was bedeutet es, wenn eine Webseite „responsive“ ist?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230268, 9009, 9905, 'Was bedeutet es, wenn eine Webseite „responsive“ ist?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230268, 'Sie passt ihr Layout automatisch an Bildschirmgröße und Gerät an', true, 'Eine responsive Seite sieht auf dem Handy, Tablet und Desktop jeweils gut aus. Technisch nutzt man dafür CSS Media Queries und flexible Layouts.'),
  (230268, 'Sie antwortet auf E-Mails', false, null),
  (230268, 'Sie lädt besonders schnell', false, null),
  (230268, 'Sie ist gegen Angriffe geschützt', false, null);

-- Cloud-Grundlagen: Was bedeutet der Begriff Cloud in der IT?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230269, 9010, 10001, 'Was bedeutet der Begriff Cloud in der IT?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230269, 'Rechenleistung, Speicher und Software, die über das Internet von einem Anbieter bereitgestellt werden', true, 'Statt eigene Server zu kaufen, nutzt man Ressourcen bei Anbietern wie AWS, Microsoft Azure oder Google Cloud und zahlt nach Verbrauch.'),
  (230269, 'Ein Speicher im Arbeitsspeicher des PCs', false, null),
  (230269, 'Ein kabelloses Netzwerk', false, null),
  (230269, 'Eine Sicherungskopie auf DVD', false, null);

-- Cloud-Grundlagen: Wofür steht die Abkürzung IaaS?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230270, 9010, 10001, 'Wofür steht die Abkürzung IaaS?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230270, 'Infrastructure as a Service – gemietete Server, Speicher und Netzwerk in der Cloud', true, 'Bei IaaS bekommt man virtuelle Maschinen und Speicher; Betriebssystem und Software installiert man selbst. Beispiel: eine EC2-Instanz bei AWS.'),
  (230270, 'Internet as a Service', false, null),
  (230270, 'Installation as a Standard', false, null),
  (230270, 'Integration and Application Security', false, null);

-- Cloud-Grundlagen: Wofür steht die Abkürzung PaaS?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230271, 9010, 10001, 'Wofür steht die Abkürzung PaaS?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230271, 'Platform as a Service – eine fertige Umgebung, in der man nur noch die eigene Anwendung hochlädt', true, 'Bei PaaS kümmert sich der Anbieter um Server, Betriebssystem und Laufzeit. Der Entwickler lädt seinen Code hoch, z. B. bei Heroku oder Azure App Service.'),
  (230271, 'Password as a Service', false, null),
  (230271, 'Program and Application Storage', false, null),
  (230271, 'Public Access Server', false, null);

-- Cloud-Grundlagen: Welche der folgenden Firmen ist ein großer Cloud-Anbieter?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230272, 9010, 10001, 'Welche der folgenden Firmen ist ein großer Cloud-Anbieter?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230272, 'Amazon (AWS)', true, 'Die drei größten Cloud-Anbieter sind Amazon Web Services, Microsoft Azure und Google Cloud. In Europa gibt es zusätzlich Anbieter wie IONOS oder Hetzner.'),
  (230272, 'Adobe', false, null),
  (230272, 'Intel', false, null),
  (230272, 'Siemens', false, null);

-- Cloud-Grundlagen: Was ist ein Vorteil der Cloud gegenüber eigenen Servern im Keller?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230273, 9010, 10001, 'Was ist ein Vorteil der Cloud gegenüber eigenen Servern im Keller?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230273, 'Ressourcen lassen sich bei Bedarf in Minuten vergrößern oder verkleinern', true, 'In der Cloud zahlt man nur, was man nutzt, und kann bei Lastspitzen sofort mehr Leistung buchen. Eigene Hardware muss man im Voraus kaufen und selbst warten.'),
  (230273, 'Die Daten liegen garantiert im eigenen Gebäude', false, null),
  (230273, 'Es fallen nie Kosten an', false, null),
  (230273, 'Es wird kein Internet benötigt', false, null);

-- CI/CD & GitOps Basics: Was bedeutet DevOps?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230274, 9010, 10002, 'Was bedeutet DevOps?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230274, 'Die enge Zusammenarbeit von Entwicklung (Development) und IT-Betrieb (Operations) mit viel Automatisierung', true, 'DevOps will Software schneller und zuverlässiger ausliefern: gemeinsame Verantwortung, automatische Tests, automatische Deployments statt Übergabe „über den Zaun“.'),
  (230274, 'Ein Programm zur Fehlersuche', false, null),
  (230274, 'Eine Programmiersprache für Server', false, null),
  (230274, 'Die Abteilung für Hardware-Einkauf', false, null);

-- CI/CD & GitOps Basics: Was ist eine Pipeline in CI/CD?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230275, 9010, 10002, 'Was ist eine Pipeline in CI/CD?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230275, 'Eine automatische Abfolge von Schritten wie Bauen, Testen und Ausliefern, die nach jeder Codeänderung läuft', true, 'Nach einem git push startet die Pipeline: Code kompilieren, Tests ausführen, bei Erfolg auf den Server bringen. Alles ohne Handarbeit.'),
  (230275, 'Ein Netzwerkkabel zwischen Servern', false, null),
  (230275, 'Eine Liste offener Fehler', false, null),
  (230275, 'Ein Ordner für Backups', false, null);

-- CI/CD & GitOps Basics: Wofür steht die Abkürzung CD in CI/CD?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230276, 9010, 10002, 'Wofür steht die Abkürzung CD in CI/CD?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230276, 'Continuous Delivery bzw. Continuous Deployment – automatisches Ausliefern der Software', true, 'Nach der Integration (CI) folgt die Auslieferung (CD): Die getestete Version wird automatisch auf Test- oder Produktionsserver gebracht.'),
  (230276, 'Compact Disc', false, null),
  (230276, 'Code Documentation', false, null),
  (230276, 'Central Database', false, null);

-- CI/CD & GitOps Basics: Was ist ein Build?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230277, 9010, 10002, 'Was ist ein Build?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230277, 'Der Vorgang, bei dem aus Quellcode ein ausführbares Programm oder Paket erzeugt wird', true, 'Beim Build wird kompiliert, Abhängigkeiten werden eingebunden und das Ergebnis verpackt, z. B. als APK, JAR oder Docker-Image.'),
  (230277, 'Das Schreiben von Quellcode', false, null),
  (230277, 'Das Löschen alter Versionen', false, null),
  (230277, 'Ein Treffen des Entwicklerteams', false, null);

-- CI/CD & GitOps Basics: Was ist GitHub?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230278, 9010, 10002, 'Was ist GitHub?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230278, 'Eine Plattform im Internet, auf der Git-Repositories gespeichert und gemeinsam bearbeitet werden', true, 'GitHub hostet Code, bietet Pull Requests für Code-Reviews und mit GitHub Actions eigene CI/CD-Pipelines. Alternativen sind GitLab und Bitbucket.'),
  (230278, 'Ein Texteditor für Programmierer', false, null),
  (230278, 'Ein Betriebssystem für Server', false, null),
  (230278, 'Eine Programmiersprache', false, null);

-- Container & K8s: Was ist Docker?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230279, 9010, 10003, 'Was ist Docker?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230279, 'Eine Software, mit der Anwendungen in Containern verpackt und ausgeführt werden', true, 'Mit Docker läuft eine Anwendung überall gleich, egal ob auf dem Laptop oder in der Cloud, weil alle Abhängigkeiten im Container stecken.'),
  (230279, 'Eine Programmiersprache', false, null),
  (230279, 'Ein Cloud-Anbieter', false, null),
  (230279, 'Ein Texteditor', false, null);

-- Container & K8s: Was ist ein Docker-Image?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230280, 9010, 10003, 'Was ist ein Docker-Image?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230280, 'Eine unveränderliche Vorlage, aus der Container gestartet werden', true, 'Das Image enthält Betriebssystem-Basis, Programm und Einstellungen. Ein laufender Container ist eine Instanz davon, wie ein Objekt aus einer Klasse.'),
  (230280, 'Ein Screenshot des Servers', false, null),
  (230280, 'Ein Backup der Datenbank', false, null),
  (230280, 'Ein Logo für die Anwendung', false, null);

-- Container & K8s: Wofür steht die Abkürzung K8s?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230281, 9010, 10003, 'Wofür steht die Abkürzung K8s?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230281, 'Kubernetes – ein System zur Verwaltung vieler Container', true, 'K8s ist die Kurzform von Kubernetes (K + 8 Buchstaben + s). Es startet, überwacht und skaliert Container automatisch auf vielen Servern.'),
  (230281, 'Kernel 8 Standard', false, null),
  (230281, 'Key Storage 8', false, null),
  (230281, 'Kompakt-Server 8', false, null);

-- Container & K8s: Was ist der Hauptzweck von Kubernetes?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230282, 9010, 10003, 'Was ist der Hauptzweck von Kubernetes?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230282, 'Viele Container automatisch zu verteilen, zu überwachen und bei Ausfall neu zu starten', true, 'Kubernetes sorgt dafür, dass immer die gewünschte Anzahl Container läuft, verteilt Last und ersetzt abgestürzte Container automatisch.'),
  (230282, 'Quellcode zu kompilieren', false, null),
  (230282, 'Webseiten zu gestalten', false, null),
  (230282, 'Passwörter zu verwalten', false, null);

-- Container & K8s: Welche Datei beschreibt, wie ein Docker-Image gebaut wird?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230283, 9010, 10003, 'Welche Datei beschreibt, wie ein Docker-Image gebaut wird?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230283, 'Dockerfile', true, 'Das Dockerfile enthält Anweisungen wie FROM (Basis-Image), COPY (Dateien) und CMD (Startbefehl). „docker build“ erzeugt daraus das Image.'),
  (230283, 'docker.txt', false, null),
  (230283, 'image.yaml', false, null),
  (230283, 'container.cfg', false, null);

-- IaC & Observability: Wofür steht die Abkürzung IaC?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230284, 9010, 10004, 'Wofür steht die Abkürzung IaC?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230284, 'Infrastructure as Code – Server und Netzwerke werden als Code beschrieben und automatisch erzeugt', true, 'Statt Server von Hand anzuklicken, beschreibt man sie in Dateien (z. B. Terraform). Das ist wiederholbar, versionierbar und dokumentiert sich selbst.'),
  (230284, 'Internet and Cloud', false, null),
  (230284, 'Installation as Configuration', false, null),
  (230284, 'Integrated Access Control', false, null);

-- IaC & Observability: Was ist Terraform?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230285, 9010, 10004, 'Was ist Terraform?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230285, 'Ein Werkzeug, mit dem Cloud-Infrastruktur als Code beschrieben und automatisch angelegt wird', true, 'In Terraform-Dateien steht z. B. „ein Server mit 4 GB RAM in Frankfurt“. „terraform apply“ legt ihn dann beim Cloud-Anbieter an.'),
  (230285, 'Eine Programmiersprache für Webseiten', false, null),
  (230285, 'Ein Betriebssystem für Container', false, null),
  (230285, 'Ein Programm zur Videobearbeitung', false, null);

-- IaC & Observability: Was bedeutet Monitoring in der IT?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230286, 9010, 10004, 'Was bedeutet Monitoring in der IT?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230286, 'Die laufende Überwachung von Systemen, z. B. ob Server erreichbar sind und wie ausgelastet sie sind', true, 'Monitoring-Tools wie Grafana oder Zabbix zeigen CPU-Last, Speicher und Antwortzeiten und schlagen Alarm, bevor Nutzer ein Problem bemerken.'),
  (230286, 'Das Erstellen von Backups', false, null),
  (230286, 'Die Installation von Updates', false, null),
  (230286, 'Das Schreiben von Dokumentation', false, null);

-- IaC & Observability: Was ist eine Metrik im Monitoring?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230287, 9010, 10004, 'Was ist eine Metrik im Monitoring?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230287, 'Ein Messwert über die Zeit, z. B. die CPU-Auslastung in Prozent', true, 'Metriken sind Zahlen mit Zeitstempel: Auslastung, Anfragen pro Sekunde, Antwortzeit. Logs dagegen sind Textmeldungen einzelner Ereignisse.'),
  (230287, 'Eine Fehlermeldung im Logfile', false, null),
  (230287, 'Ein Passwort für das Monitoring-Tool', false, null),
  (230287, 'Der Name eines Servers', false, null);

-- IaC & Observability: Was ist ein Alert im Monitoring?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230288, 9010, 10004, 'Was ist ein Alert im Monitoring?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230288, 'Eine automatische Benachrichtigung, wenn ein Messwert einen Grenzwert überschreitet', true, 'Beispiel: Ist die Festplatte zu 90 % voll, geht eine Nachricht per E-Mail oder Chat an das Team. So reagiert man, bevor der Server steht.'),
  (230288, 'Ein wöchentlicher Bericht', false, null),
  (230288, 'Ein Backup der Metriken', false, null),
  (230288, 'Das Neustarten eines Servers', false, null);

-- Reliability & Kosten: Was bedeutet Hochverfügbarkeit (High Availability)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230289, 9010, 10005, 'Was bedeutet Hochverfügbarkeit (High Availability)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230289, 'Ein System bleibt auch beim Ausfall einzelner Komponenten erreichbar', true, 'Hochverfügbarkeit erreicht man durch Redundanz: mehrere Server, mehrere Rechenzentren, automatische Umschaltung. Ziel sind z. B. 99,9 % Verfügbarkeit.'),
  (230289, 'Ein System, das sehr schnell antwortet', false, null),
  (230289, 'Ein System mit besonders viel Speicher', false, null),
  (230289, 'Ein System, das nur tagsüber läuft', false, null);

-- Reliability & Kosten: Was bedeutet Skalierung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230290, 9010, 10005, 'Was bedeutet Skalierung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230290, 'Die Leistung eines Systems an die Last anpassen, z. B. mehr Server bei mehr Nutzern', true, 'Skalierung kann vertikal sein (größerer Server) oder horizontal (mehr Server). In der Cloud geht das oft automatisch (Autoscaling).'),
  (230290, 'Die Verschlüsselung von Daten', false, null),
  (230290, 'Das Messen der Bildschirmgröße', false, null),
  (230290, 'Das Löschen alter Logs', false, null);

-- Reliability & Kosten: Was bedeutet Redundanz in der IT?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230291, 9010, 10005, 'Was bedeutet Redundanz in der IT?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230291, 'Wichtige Komponenten sind mehrfach vorhanden, damit ein Ausfall abgefangen wird', true, 'Zwei Netzteile, zwei Internetleitungen, Datenspiegelung: Fällt eines aus, übernimmt das andere. Redundanz ist die Grundlage von Hochverfügbarkeit.'),
  (230291, 'Daten sind doppelt gespeichert und verschwenden Platz', false, null),
  (230291, 'Ein Server läuft ohne Backup', false, null),
  (230291, 'Ein Programm läuft langsamer als nötig', false, null);

-- Reliability & Kosten: Was bedeutet das Abrechnungsmodell „Pay as you go“ in der Cloud?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230292, 9010, 10005, 'Was bedeutet das Abrechnungsmodell „Pay as you go“ in der Cloud?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230292, 'Man zahlt nur für die Ressourcen, die man tatsächlich nutzt', true, 'Läuft ein Server nur zwei Stunden, zahlt man zwei Stunden. Das ist flexibel, kann aber teuer werden, wenn man vergessene Ressourcen laufen lässt.'),
  (230292, 'Man zahlt einen festen Jahresbetrag', false, null),
  (230292, 'Man zahlt einmalig beim Kauf', false, null),
  (230292, 'Die Nutzung ist kostenlos', false, null);

-- Reliability & Kosten: Was bedeutet Ausfallzeit (Downtime)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230293, 9010, 10005, 'Was bedeutet Ausfallzeit (Downtime)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230293, 'Die Zeit, in der ein System nicht verfügbar ist', true, 'Downtime kostet Geld und Vertrauen. Sie wird geplant (Wartung) oder ungeplant (Störung) gemessen und ist Teil von Verfügbarkeitszusagen (SLA).'),
  (230293, 'Die Zeit, die ein Backup dauert', false, null),
  (230293, 'Die Ladezeit einer Webseite', false, null),
  (230293, 'Die Zeit bis zum nächsten Update', false, null);

-- Grundlagen & Notation: Was ist eine Datenstruktur?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230294, 9011, 10101, 'Was ist eine Datenstruktur?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230294, 'Eine Art, Daten im Speicher zu organisieren, z. B. als Liste, Stack oder Tabelle', true, 'Die Datenstruktur bestimmt, wie schnell man Daten findet, einfügt oder löscht. Für jede Aufgabe gibt es passende Strukturen: Array, Liste, Baum, Hash-Tabelle.'),
  (230294, 'Ein Diagramm für Datenbanken', false, null),
  (230294, 'Eine Programmiersprache', false, null),
  (230294, 'Eine Datei auf der Festplatte', false, null);

-- Grundlagen & Notation: Wofür steht die Abkürzung LIFO bei einem Stack?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230295, 9011, 10101, 'Wofür steht die Abkürzung LIFO bei einem Stack?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230295, 'Last In, First Out – das zuletzt abgelegte Element wird als Erstes wieder entnommen', true, 'Ein Stack ist wie ein Tellerstapel: Man legt oben auf und nimmt oben weg. Die Rückgängig-Funktion in Programmen arbeitet so.'),
  (230295, 'Last In, First Ordered', false, null),
  (230295, 'List In, File Out', false, null),
  (230295, 'Low Input, Fast Output', false, null);

-- Grundlagen & Notation: Wofür steht die Abkürzung FIFO bei einer Queue?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230296, 9011, 10101, 'Wofür steht die Abkürzung FIFO bei einer Queue?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230296, 'First In, First Out – das zuerst eingefügte Element wird als Erstes bearbeitet', true, 'Eine Queue ist eine Warteschlange wie an der Kasse: Wer zuerst kommt, ist zuerst dran. Druckaufträge werden so abgearbeitet.'),
  (230296, 'Fast In, Fast Out', false, null),
  (230296, 'First In, Final Output', false, null),
  (230296, 'File Input, File Output', false, null);

-- Grundlagen & Notation: Wie nennt man die Operation, mit der ein Element oben auf einen Stack gelegt wir
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230297, 9011, 10101, 'Wie nennt man die Operation, mit der ein Element oben auf einen Stack gelegt wird?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230297, 'push', true, 'push legt ein Element oben auf den Stack, pop nimmt das oberste wieder herunter. Mit peek schaut man nur nach, ohne es zu entfernen.'),
  (230297, 'pop', false, null),
  (230297, 'add', false, null),
  (230297, 'insert', false, null);

-- Grundlagen & Notation: Was beschreibt die Laufzeit eines Algorithmus?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230298, 9011, 10101, 'Was beschreibt die Laufzeit eines Algorithmus?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230298, 'Wie viele Schritte oder wie viel Zeit er in Abhängigkeit von der Datenmenge braucht', true, 'Die Laufzeit wird in Big-O-Notation angegeben: O(n) bedeutet, die Schritte wachsen linear mit der Anzahl n der Elemente.'),
  (230298, 'Wie viele Zeilen Code er hat', false, null),
  (230298, 'Wie lange die Entwicklung gedauert hat', false, null),
  (230298, 'Wie viele Programmierer ihn geschrieben haben', false, null);

-- Lineare & verkettete Strukturen: Was ist eine verkettete Liste?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230299, 9011, 10102, 'Was ist eine verkettete Liste?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230299, 'Eine Datenstruktur, bei der jedes Element auf das nächste Element zeigt', true, 'Jeder Knoten enthält einen Wert und einen Zeiger auf den Nachfolger. Elemente lassen sich leicht einfügen und entfernen, aber der Zugriff auf das fünfte Element erfordert vier Sprünge.'),
  (230299, 'Ein Array mit fester Größe', false, null),
  (230299, 'Eine Tabelle in einer Datenbank', false, null),
  (230299, 'Eine sortierte Liste von Zahlen', false, null);

-- Lineare & verkettete Strukturen: Wie nennt man ein einzelnes Element einer verketteten Liste?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230300, 9011, 10102, 'Wie nennt man ein einzelnes Element einer verketteten Liste?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230300, 'Knoten (Node)', true, 'Ein Knoten speichert die Daten und den Verweis auf den nächsten Knoten. Der erste Knoten heißt Head, der letzte zeigt auf null.'),
  (230300, 'Zelle', false, null),
  (230300, 'Index', false, null),
  (230300, 'Schlüssel', false, null);

-- Lineare & verkettete Strukturen: Was ist der Unterschied zwischen einem Array und einer verketteten Liste beim Zu
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230301, 9011, 10102, 'Was ist der Unterschied zwischen einem Array und einer verketteten Liste beim Zugriff auf ein Element?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230301, 'Im Array erreicht man jedes Element direkt über den Index, in der Liste muss man von vorne durchlaufen', true, 'Array: arr[7] ist ein Schritt. Liste: sieben Sprünge von Knoten zu Knoten. Dafür kann die Liste ohne Umkopieren wachsen.'),
  (230301, 'Es gibt keinen Unterschied', false, null),
  (230301, 'Die Liste ist beim Zugriff immer schneller', false, null),
  (230301, 'Arrays können nicht durchlaufen werden', false, null);

-- Lineare & verkettete Strukturen: Was bedeutet es, wenn eine verkettete Liste „doppelt verkettet“ ist?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230302, 9011, 10102, 'Was bedeutet es, wenn eine verkettete Liste „doppelt verkettet“ ist?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230302, 'Jeder Knoten zeigt sowohl auf den nächsten als auch auf den vorherigen Knoten', true, 'Mit Zeigern in beide Richtungen kann man die Liste vorwärts und rückwärts durchlaufen und ein Element ohne Suche des Vorgängers entfernen.'),
  (230302, 'Jeder Wert ist zweimal gespeichert', false, null),
  (230302, 'Die Liste ist mit einer zweiten Liste verbunden', false, null),
  (230302, 'Die Liste hat doppelt so viele Elemente', false, null);

-- Lineare & verkettete Strukturen: Worauf zeigt der Zeiger des letzten Knotens in einer einfach verketteten Liste?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230303, 9011, 10102, 'Worauf zeigt der Zeiger des letzten Knotens in einer einfach verketteten Liste?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230303, 'Auf null (nichts) – damit ist das Ende markiert', true, 'Beim Durchlaufen prüft man „solange knoten != null“. Zeigt der letzte Knoten stattdessen auf den ersten, ist es eine Ringliste.'),
  (230303, 'Auf den ersten Knoten', false, null),
  (230303, 'Auf sich selbst', false, null),
  (230303, 'Auf den Head der Liste', false, null);

-- Bäume & Heaps: Was ist ein Baum als Datenstruktur?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230304, 9011, 10103, 'Was ist ein Baum als Datenstruktur?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230304, 'Eine hierarchische Struktur aus Knoten, die von einer Wurzel ausgehend verzweigt', true, 'Ein Baum hat eine Wurzel, Knoten mit Kindern und Blätter ohne Kinder. Beispiele: Ordnerstruktur, Stammbaum, HTML-DOM.'),
  (230304, 'Eine Liste, die sortiert ist', false, null),
  (230304, 'Eine Tabelle mit Zeilen und Spalten', false, null),
  (230304, 'Ein Netzwerk aus Servern', false, null);

-- Bäume & Heaps: Wie heißt der oberste Knoten eines Baums?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230305, 9011, 10103, 'Wie heißt der oberste Knoten eines Baums?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230305, 'Wurzel (Root)', true, 'Die Wurzel ist der einzige Knoten ohne Elternknoten. Von ihr aus erreicht man alle anderen Knoten des Baums.'),
  (230305, 'Blatt', false, null),
  (230305, 'Stamm', false, null),
  (230305, 'Head', false, null);

-- Bäume & Heaps: Wie nennt man einen Knoten in einem Baum, der keine Kinder hat?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230306, 9011, 10103, 'Wie nennt man einen Knoten in einem Baum, der keine Kinder hat?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230306, 'Blatt (Leaf)', true, 'Blätter sind die Endpunkte eines Baums. In einem Dateisystem wären das die Dateien, während Ordner innere Knoten sind.'),
  (230306, 'Wurzel', false, null),
  (230306, 'Ast', false, null),
  (230306, 'Elternknoten', false, null);

-- Bäume & Heaps: Wie viele Kinder darf ein Knoten in einem binären Baum höchstens haben?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230307, 9011, 10103, 'Wie viele Kinder darf ein Knoten in einem binären Baum höchstens haben?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230307, '2', true, '„Binär“ bedeutet zwei: Jeder Knoten hat höchstens ein linkes und ein rechtes Kind. Das macht Suchen und Einfügen im binären Suchbaum effizient.'),
  (230307, '1', false, null),
  (230307, '3', false, null),
  (230307, 'Beliebig viele', false, null);

-- Bäume & Heaps: Was ist ein Heap?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230308, 9011, 10103, 'Was ist ein Heap?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230308, 'Ein binärer Baum, bei dem jeder Elternknoten größer (oder kleiner) als seine Kinder ist', true, 'Im Max-Heap steht das größte Element immer ganz oben. Deshalb eignen sich Heaps für Prioritätswarteschlangen und den Sortieralgorithmus Heapsort.'),
  (230308, 'Ein Baum, in dem alle Knoten gleich sind', false, null),
  (230308, 'Eine Liste ohne Reihenfolge', false, null),
  (230308, 'Ein Speicherbereich für Variablen', false, null);

-- Graphen & Sortieren: Was ist ein Graph als Datenstruktur?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230309, 9011, 10104, 'Was ist ein Graph als Datenstruktur?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230309, 'Eine Menge von Knoten, die durch Kanten miteinander verbunden sind', true, 'Straßennetze, soziale Netzwerke und Routenplaner sind Graphen: Orte oder Personen sind Knoten, Verbindungen sind Kanten.'),
  (230309, 'Ein Diagramm mit Balken und Linien', false, null),
  (230309, 'Eine sortierte Liste von Zahlen', false, null),
  (230309, 'Ein Bild in einem Programm', false, null);

-- Graphen & Sortieren: Was ist eine Kante in einem Graphen?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230310, 9011, 10104, 'Was ist eine Kante in einem Graphen?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230310, 'Die Verbindung zwischen zwei Knoten', true, 'Kanten können gerichtet sein (Einbahnstraße) oder ungerichtet (beide Richtungen) und ein Gewicht tragen, z. B. die Entfernung in Kilometern.'),
  (230310, 'Der äußerste Knoten des Graphen', false, null),
  (230310, 'Ein Knoten ohne Verbindungen', false, null),
  (230310, 'Der Startpunkt einer Suche', false, null);

-- Graphen & Sortieren: Was macht der Sortieralgorithmus Bubble Sort?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230311, 9011, 10104, 'Was macht der Sortieralgorithmus Bubble Sort?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230311, 'Er vergleicht immer zwei benachbarte Elemente und vertauscht sie, wenn sie in falscher Reihenfolge sind', true, 'Bubble Sort ist einfach zu verstehen, aber langsam (O(n²)). Große Elemente „steigen“ wie Blasen nach hinten. In der Praxis nutzt man schnellere Verfahren.'),
  (230311, 'Er teilt die Liste in zwei Hälften und sortiert sie getrennt', false, null),
  (230311, 'Er sucht das kleinste Element und setzt es nach vorne', false, null),
  (230311, 'Er sortiert mit Hilfe eines Baums', false, null);

-- Graphen & Sortieren: Was ist der Vorteil einer sortierten Liste gegenüber einer unsortierten?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230312, 9011, 10104, 'Was ist der Vorteil einer sortierten Liste gegenüber einer unsortierten?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230312, 'Man kann viel schneller suchen, z. B. mit der binären Suche', true, 'In einer sortierten Liste halbiert die binäre Suche bei jedem Schritt den Suchbereich: Bei 1.000 Elementen sind es nur etwa 10 Schritte statt bis zu 1.000.'),
  (230312, 'Sie braucht weniger Speicher', false, null),
  (230312, 'Sie kann mehr Elemente aufnehmen', false, null),
  (230312, 'Sie kann nicht verändert werden', false, null);

-- Graphen & Sortieren: Was bedeutet es, einen Graphen zu durchlaufen (Traversierung)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230313, 9011, 10104, 'Was bedeutet es, einen Graphen zu durchlaufen (Traversierung)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230313, 'Alle Knoten systematisch zu besuchen, z. B. in der Breite oder in der Tiefe', true, 'Breitensuche (BFS) besucht erst alle Nachbarn, dann deren Nachbarn. Tiefensuche (DFS) folgt einem Pfad so weit wie möglich, bevor sie umkehrt.'),
  (230313, 'Alle Kanten zu löschen', false, null),
  (230313, 'Den Graphen zu zeichnen', false, null),
  (230313, 'Die Knoten zu sortieren', false, null);

-- Komplexität & Optimierung (Adv.): Was bedeutet O(1) in der Big-O-Notation?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230314, 9011, 10105, 'Was bedeutet O(1) in der Big-O-Notation?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230314, 'Die Laufzeit ist konstant, unabhängig von der Datenmenge', true, 'Der Zugriff auf arr[5] dauert gleich lang, ob das Array 10 oder 10 Millionen Elemente hat. Das ist die bestmögliche Laufzeitklasse.'),
  (230314, 'Die Laufzeit verdoppelt sich mit jedem Element', false, null),
  (230314, 'Der Algorithmus braucht genau eine Sekunde', false, null),
  (230314, 'Der Algorithmus hat einen Fehler', false, null);

-- Komplexität & Optimierung (Adv.): Was bedeutet O(n) in der Big-O-Notation?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230315, 9011, 10105, 'Was bedeutet O(n) in der Big-O-Notation?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230315, 'Die Laufzeit wächst linear mit der Anzahl n der Elemente', true, 'Doppelt so viele Elemente, doppelt so lange: Eine Liste einmal komplett durchlaufen ist O(n), z. B. bei der linearen Suche.'),
  (230315, 'Die Laufzeit ist immer gleich', false, null),
  (230315, 'Die Laufzeit wächst quadratisch', false, null),
  (230315, 'Der Algorithmus braucht n Sekunden', false, null);

-- Komplexität & Optimierung (Adv.): Welcher Algorithmus ist bei großen Datenmengen schneller: einer mit O(n) oder ei
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230316, 9011, 10105, 'Welcher Algorithmus ist bei großen Datenmengen schneller: einer mit O(n) oder einer mit O(n²)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230316, 'Der mit O(n)', true, 'Bei n = 1.000 braucht O(n) rund 1.000 Schritte, O(n²) rund 1.000.000. Je größer n, desto deutlicher der Unterschied.'),
  (230316, 'Der mit O(n²)', false, null),
  (230316, 'Beide sind gleich schnell', false, null),
  (230316, 'Das hängt vom Computer ab', false, null);

-- Komplexität & Optimierung (Adv.): Was bedeutet Optimierung eines Algorithmus?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230317, 9011, 10105, 'Was bedeutet Optimierung eines Algorithmus?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230317, 'Ihn so zu verändern, dass er weniger Zeit oder weniger Speicher braucht', true, 'Typische Optimierungen: bessere Datenstruktur wählen, unnötige Schleifen vermeiden, Ergebnisse zwischenspeichern (Caching).'),
  (230317, 'Ihn in eine andere Programmiersprache übersetzen', false, null),
  (230317, 'Mehr Kommentare hinzuzufügen', false, null),
  (230317, 'Ihn auf einem größeren Server laufen zu lassen', false, null);

-- Komplexität & Optimierung (Adv.): Was ist der Unterschied zwischen Zeitkomplexität und Speicherkomplexität?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230318, 9011, 10105, 'Was ist der Unterschied zwischen Zeitkomplexität und Speicherkomplexität?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230318, 'Zeitkomplexität beschreibt die benötigte Rechenzeit, Speicherkomplexität den benötigten Speicherplatz', true, 'Beides wird in Big-O angegeben. Oft kann man Zeit gegen Speicher tauschen: Eine Hash-Tabelle sucht in O(1), braucht aber mehr Speicher als eine Liste.'),
  (230318, 'Es gibt keinen Unterschied', false, null),
  (230318, 'Zeitkomplexität gilt nur für Datenbanken', false, null),
  (230318, 'Speicherkomplexität misst die Größe des Quellcodes', false, null);

select public.refresh_themen_schwierigkeit() as themen_aktualisiert;
commit;

-- Kontrolle: select thema_id, count(*) from fragen where id between 230209 and 230318 group by 1 order by 1;  -- 22 Themen x 5