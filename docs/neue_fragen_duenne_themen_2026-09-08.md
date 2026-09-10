# Neue Fragen für dünne Themen (08.09.2026)

20 Fragen, Stufe **mittel**. Richtige Antwort ist fett, darunter die Erklärung.


## Datenbanken · SQL Basics

**230319 – Welche Abfrage liefert alle Kunden aus Köln, sortiert nach Nachname aufsteigend?**

- **SELECT * FROM kunden WHERE ort = 'Köln' ORDER BY nachname ASC;** ✅
- SELECT * FROM kunden ORDER BY nachname WHERE ort = 'Köln';
- SELECT * FROM kunden WHERE ort = Köln SORT BY nachname;
- SELECT kunden WHERE ort = 'Köln' ORDER nachname ASC;

> Reihenfolge der Klauseln: SELECT, FROM, WHERE (filtern), ORDER BY (sortieren). Textwerte stehen in einfachen Anführungszeichen, ASC ist aufsteigend und Standard.

**230320 – Was ist der Unterschied zwischen DELETE FROM kunden WHERE id = 5; und DELETE FROM kunden;?**

- **Die erste Anweisung löscht nur den Kunden mit id 5, die zweite löscht alle Zeilen der Tabelle** ✅
- Die zweite Anweisung löscht die ganze Tabelle inklusive Struktur
- Die erste löscht die Spalte id
- Beide löschen nur eine Zeile

> Ohne WHERE gilt DELETE für jede Zeile. Deshalb: WHERE-Bedingung immer zuerst mit SELECT testen, bevor man DELETE oder UPDATE ausführt.

**230321 – Mit welcher Anweisung setzt man den Preis des Produkts mit id 7 auf 19.99?**

- **UPDATE produkte SET preis = 19.99 WHERE id = 7;** ✅
- UPDATE produkte preis = 19.99 WHERE id = 7;
- SET produkte.preis = 19.99 WHERE id = 7;
- CHANGE produkte SET preis = 19.99 FOR id = 7;

> UPDATE braucht die Tabelle, SET mit dem neuen Wert und WHERE, um die Zeile einzugrenzen. Ohne WHERE bekämen alle Produkte den Preis 19.99.

**230322 – Welche Abfrage findet alle Produkte, deren Name mit „USB“ beginnt?**

- **SELECT * FROM produkte WHERE name LIKE 'USB%';** ✅
- SELECT * FROM produkte WHERE name = 'USB%';
- SELECT * FROM produkte WHERE name LIKE '%USB';
- SELECT * FROM produkte WHERE name STARTS 'USB';

> LIKE vergleicht Muster: % steht für beliebig viele Zeichen, _ für genau eines. 'USB%' trifft also „USB-Stick“ und „USB-Kabel“, aber nicht „Mini-USB“.

**230323 – Welche Abfrage liefert die Anzahl der Bestellungen mit einem Betrag über 100?**

- **SELECT COUNT(*) FROM bestellungen WHERE betrag > 100;** ✅
- SELECT COUNT(betrag > 100) FROM bestellungen;
- SELECT SUM(*) FROM bestellungen WHERE betrag > 100;
- COUNT * FROM bestellungen WHERE betrag > 100;

> COUNT(*) zählt die Zeilen, die die WHERE-Bedingung erfüllen. Das Ergebnis ist eine einzelne Zahl, keine Liste.


## Betriebssysteme & Linux · Linux CLI & Tools Basics

**230324 – Was bewirkt der Befehl grep -i fehler /var/log/syslog?**

- **Er zeigt alle Zeilen der Datei, die „fehler“ enthalten – Groß-/Kleinschreibung wird ignoriert** ✅
- Er löscht alle Zeilen mit „fehler“ aus der Datei
- Er zeigt nur die erste Zeile mit „Fehler“ in exakter Schreibweise
- Er zählt, wie oft „fehler“ vorkommt

> -i steht für ignore case: „Fehler“, „FEHLER“ und „fehler“ werden gefunden. Mit -n bekommt man zusätzlich die Zeilennummern, mit -r sucht grep rekursiv in Ordnern.

**230325 – Was ist der Unterschied zwischen > und >> bei der Ausgabeumleitung?**

- **> überschreibt die Zieldatei, >> hängt die Ausgabe am Ende an** ✅
- > hängt an, >> überschreibt
- > leitet in eine Datei, >> in ein Programm
- Es gibt keinen Unterschied

> „echo Test > log.txt“ ersetzt den Inhalt komplett, „echo Test >> log.txt“ fügt eine Zeile hinzu. Bei Logdateien nimmt man deshalb >>.

**230326 – Was macht die Befehlskette cat zugriffe.log | grep 404 | wc -l?**

- **Sie zählt, wie viele Zeilen der Logdatei „404“ enthalten** ✅
- Sie löscht alle Zeilen mit 404
- Sie zeigt die 404 längsten Zeilen
- Sie speichert die Zeilen mit 404 in einer neuen Datei

> cat gibt die Datei aus, grep filtert die Zeilen mit 404, wc -l zählt die Zeilen. Die Pipe | reicht die Ausgabe jeweils an den nächsten Befehl weiter.

**230327 – Mit welchem Befehl installiert man unter Ubuntu das Paket nginx?**

- **sudo apt install nginx** ✅
- apt get nginx
- sudo install nginx
- yum install nginx

> apt ist der Paketmanager von Debian/Ubuntu, install der Unterbefehl, sudo liefert die nötigen Rechte. Vorher aktualisiert „sudo apt update“ die Paketlisten.

**230328 – Was zeigt der Befehl tail -f /var/log/nginx/error.log?**

- **Die letzten Zeilen der Datei und danach live jede neue Zeile, die hinzukommt** ✅
- Die ersten zehn Zeilen der Datei
- Die Datei komplett in einem Editor
- Die Dateigröße in Byte

> tail zeigt das Dateiende, -f (follow) bleibt geöffnet und zeigt neue Einträge sofort. So beobachtet man Logs, während man einen Fehler nachstellt. Beenden mit Strg+C.


## IT-Sicherheit · Netz- & Web-Basics

**230329 – Ein Mitarbeiter erhält eine E-Mail von „support@paypa1.com“ mit der Bitte, sein Konto über einen Link zu bestätigen. Was ist die richtige Reaktion?**

- **Nicht klicken, die E-Mail als Phishing an die IT melden und PayPal nur über die selbst eingetippte Adresse aufrufen** ✅
- Den Link öffnen und prüfen, ob die Seite echt aussieht
- Auf die E-Mail antworten und nach Details fragen
- Die E-Mail an Kollegen weiterleiten, damit alle Bescheid wissen

> Die Domain ist gefälscht (Ziffer 1 statt Buchstabe l), es wird Dringlichkeit erzeugt und ein Link vorgegeben – drei typische Phishing-Merkmale. Echte Anbieter fordern nie per Link zur Bestätigung von Zugangsdaten auf.

**230330 – Welche Firewall-Regel sollte für einen Webserver im Internet gelten?**

- **Nur die benötigten Ports (80 und 443) von außen erlauben, alles andere blockieren** ✅
- Alle Ports öffnen, damit alle Dienste erreichbar sind
- Nur Port 22 öffnen, damit der Admin arbeiten kann
- Alle Ports blockieren, auch 80 und 443

> Prinzip „Deny by default“: Alles ist zu, nur was gebraucht wird, wird geöffnet. SSH (Port 22) sollte zusätzlich auf bestimmte Quell-IPs oder ein VPN beschränkt werden.

**230331 – Warum ist ein öffentliches WLAN im Café ohne VPN riskant?**

- **Andere Nutzer im selben Netz können unverschlüsselten Datenverkehr mitlesen oder sich als Zugangspunkt ausgeben** ✅
- Das WLAN ist immer zu langsam für sichere Verbindungen
- Der Laptop-Akku entlädt sich schneller
- Öffentliche WLANs erlauben keine HTTPS-Seiten

> Im offenen WLAN teilen sich alle dasselbe Netz. Ein VPN verschlüsselt den gesamten Verkehr bis zum VPN-Server, sodass Mitlesen nichts bringt. HTTPS schützt nur die jeweilige Webseite.

**230332 – Ein Portscan zeigt auf einem Server die offenen Ports 22, 80, 443 und 3306. Welcher Port sollte am dringendsten geprüft werden?**

- **3306 – die MySQL-Datenbank sollte nicht direkt aus dem Internet erreichbar sein** ✅
- 443 – HTTPS ist ein Sicherheitsrisiko
- 80 – HTTP sollte nie offen sein
- 22 – SSH ist immer unsicher

> 22 (SSH), 80 und 443 (Web) sind bei einem Webserver erwartbar. Eine Datenbank auf 3306 gehört hinter die Firewall und ist nur für die Anwendung selbst gedacht – offen im Internet ist sie ein beliebtes Angriffsziel.

**230333 – Was ist der Unterschied zwischen HTTP und HTTPS in Bezug auf ein Login-Formular?**

- **Bei HTTP wird das Passwort im Klartext übertragen, bei HTTPS verschlüsselt** ✅
- HTTPS speichert das Passwort auf dem Server verschlüsselt, HTTP nicht
- HTTP ist schneller und deshalb für Logins besser
- Es gibt keinen Unterschied, beides ist unverschlüsselt

> Ohne TLS kann jeder im Übertragungsweg (WLAN, Provider) die Formulardaten lesen. Browser warnen deshalb bei Passwortfeldern auf HTTP-Seiten mit „Nicht sicher“.


## Programmierung · Syntax & Grundlagen

**230334 – Was gibt dieser Code aus? int a = 7; int b = 2; System.out.println(a / b);**

- **3** ✅
- 3.5
- 4
- 3,5

> Bei der Division zweier Ganzzahlen (int) wird der Rest abgeschnitten: 7 / 2 = 3, nicht 3.5. Für 3.5 müsste mindestens ein Operand ein double sein, z. B. 7.0 / 2.

**230335 – Was ist das Ergebnis von 10 % 3 in den meisten Programmiersprachen?**

- **1** ✅
- 3
- 0.33
- 3.33

> % ist der Modulo-Operator und liefert den Rest der Division: 10 geteilt durch 3 ist 3 Rest 1. Modulo wird z. B. genutzt, um gerade Zahlen zu erkennen (x % 2 == 0).

**230336 – Welche Zeile enthält einen Fehler? (1) int zahl = 5; (2) String name = "Anna"; (3) boolean ok = "true"; (4) double preis = 9.99;**

- **Zeile 3 – ein boolean bekommt true ohne Anführungszeichen, "true" ist ein String** ✅
- Zeile 1 – int darf keine kleinen Zahlen speichern
- Zeile 2 – Strings brauchen einfache Anführungszeichen
- Zeile 4 – double braucht ein Komma statt Punkt

> Anführungszeichen machen aus einem Wert einen Text. boolean ok = true; ist richtig. Solche Typfehler meldet der Compiler vor dem Start.


## IT-Grundlagen & Hardware · Hardware-Basics

**230337 – Ein PC startet nicht, die Lüfter drehen kurz an und gehen wieder aus. Welche Komponente ist als Erstes verdächtig?**

- **Das Netzteil oder die Stromversorgung des Mainboards** ✅
- Die Festplatte, weil das Betriebssystem fehlt
- Der Monitor, weil kein Bild kommt
- Die Tastatur, weil sie nicht reagiert

> Kurzes Anlaufen und Abschalten deutet auf zu wenig oder instabile Spannung hin. Reihenfolge der Fehlersuche: Netzteil-Schalter und Kabel prüfen, dann Netzteil testen, erst danach Mainboard und RAM.

**230338 – Ein Nutzer will seinen Büro-PC für Videoschnitt nachrüsten. Welche Aufrüstung bringt dafür am meisten?**

- **Mehr Arbeitsspeicher und eine leistungsfähige Grafikkarte** ✅
- Eine größere Festplatte und ein neues Gehäuse
- Ein neues Netzteil und mehr USB-Anschlüsse
- Ein zweiter Monitor und eine neue Tastatur

> Videoschnitt braucht viel RAM für die Vorschau und nutzt die GPU zum Rendern. Eine größere Festplatte hilft beim Speichern, beschleunigt aber die Arbeit kaum; ein neues Netzteil nur, wenn die Leistung nicht reicht.

