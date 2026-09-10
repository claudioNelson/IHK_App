# Neue Einstiegsfragen: Programmierung, IT-Sicherheit, Web, Cloud & DevOps, Algorithmen (08.09.2026)

110 Fragen, Stufe **einfach**, 5 je Thema. Richtige Antwort ist fett, darunter die Erklärung.


## Programmierung · Kontroll- & Datenstrukturen

**230209 – Was ist eine Schleife in der Programmierung?**

- **Eine Anweisung, die einen Codeblock mehrfach wiederholt** ✅
- Ein Fehler, der das Programm zum Absturz bringt
- Eine Variable, die Text speichert
- Ein Kommentar im Code

> Schleifen wie for und while führen denselben Code so oft aus, wie eine Bedingung erfüllt ist – z. B. für jedes Element einer Liste.

**230210 – Was ist ein Array?**

- **Eine Sammlung mehrerer Werte gleichen Typs unter einem Namen, die über einen Index angesprochen werden** ✅
- Eine Funktion ohne Rückgabewert
- Eine Textdatei mit Code
- Ein Vergleichsoperator

> Statt zehn Variablen zahl1 bis zahl10 legt man ein Array zahlen[10] an. Der erste Eintrag hat in den meisten Sprachen den Index 0.

**230211 – Welchen Index hat das erste Element eines Arrays in Sprachen wie Java, C oder Python?**

- **0** ✅
- 1
- -1
- Das hängt von der Länge ab

> Arrays sind nullbasiert: Das erste Element ist arr[0], das letzte arr[länge − 1]. Wer arr[länge] liest, bekommt einen Fehler.

**230212 – Welche Werte kann eine Variable vom Typ boolean annehmen?**

- **true oder false** ✅
- 0 bis 255
- Beliebigen Text
- Ganze Zahlen

> Der boolesche Typ kennt nur wahr und falsch. Er wird in Bedingungen wie if (istFertig) verwendet.

**230213 – Welcher Vergleichsoperator prüft in den meisten Programmiersprachen, ob zwei Werte gleich sind?**

- **==** ✅
- =
- =>
- !=

> Ein einzelnes = weist einen Wert zu, == vergleicht. Die Verwechslung ist ein klassischer Anfängerfehler.


## Programmierung · OOP & Fehlerbehandlung

**230214 – Was ist eine Klasse in der objektorientierten Programmierung?**

- **Ein Bauplan, der beschreibt, welche Eigenschaften und Methoden Objekte haben** ✅
- Eine Schleife, die Objekte zählt
- Eine Datei mit Konfigurationen
- Ein Fehler zur Laufzeit

> Die Klasse „Auto“ legt fest, dass jedes Auto eine Farbe hat und fahren kann. Ein konkretes Auto ist dann ein Objekt dieser Klasse.

**230215 – Was ist ein Objekt in der OOP?**

- **Eine konkrete Instanz einer Klasse, z. B. ein bestimmtes Auto** ✅
- Der Bauplan für Instanzen
- Eine Methode ohne Parameter
- Ein Kommentar im Quellcode

> Aus dem Bauplan „Klasse“ entstehen mit new beliebig viele Objekte, jedes mit eigenen Werten: ein rotes Auto, ein blaues Auto.

**230216 – Was ist eine Methode?**

- **Eine Funktion, die zu einer Klasse gehört und beschreibt, was ihre Objekte tun können** ✅
- Eine Variable in einer Klasse
- Ein Datentyp für Text
- Ein Vergleich zweier Objekte

> Methoden sind das Verhalten eines Objekts: auto.fahren(), konto.einzahlen(50). Sie können auf die Attribute des Objekts zugreifen.

**230217 – Was bedeutet Vererbung in der OOP?**

- **Eine Klasse übernimmt Eigenschaften und Methoden einer anderen Klasse** ✅
- Ein Objekt wird beim Programmende gelöscht
- Eine Variable wird an eine Methode übergeben
- Zwei Klassen haben denselben Namen

> Die Klasse „Lkw“ erbt von „Fahrzeug“ und bekommt automatisch alles, was Fahrzeug kann, plus eigene Ergänzungen. Das spart doppelten Code.

**230218 – Was ist ein Attribut einer Klasse?**

- **Eine Eigenschaft, die als Variable in der Klasse gespeichert wird, z. B. die Farbe eines Autos** ✅
- Eine Funktion der Klasse
- Der Name der Datei
- Ein Fehler beim Kompilieren

> Attribute (auch Felder oder Membervariablen) speichern den Zustand eines Objekts. Methoden arbeiten mit diesen Werten.


## Programmierung · Build, Git & Tests

**230219 – Was ist Git?**

- **Ein Versionskontrollsystem, das Änderungen am Code nachvollziehbar speichert** ✅
- Ein Programm zum Kompilieren von Java
- Ein Texteditor
- Ein Betriebssystem für Server

> Git merkt sich jeden Stand des Projekts als Commit. Man kann zurückspringen, parallel an Branches arbeiten und Änderungen im Team zusammenführen.

**230220 – Was ist ein Commit in Git?**

- **Ein gespeicherter Stand der Änderungen mit einer Beschreibung** ✅
- Das Löschen eines Branches
- Der Download eines fremden Projekts
- Ein Fehler beim Zusammenführen

> Mit „git commit -m 'Login-Fehler behoben'“ wird ein Schnappschuss der Änderungen dauerhaft in der Historie festgehalten.

**230221 – Was ist ein Repository?**

- **Der Speicherort eines Projekts inklusive seiner gesamten Versionsgeschichte** ✅
- Eine einzelne Quellcodedatei
- Ein Programm zum Testen
- Die Fehlerliste eines Projekts

> Das Repository (kurz Repo) enthält alle Dateien und alle Commits. Es liegt lokal auf dem Rechner und oft zusätzlich auf einem Server wie GitHub.

**230222 – Was ist ein Unit-Test?**

- **Ein automatischer Test, der eine einzelne kleine Einheit des Codes, z. B. eine Funktion, prüft** ✅
- Ein Test der gesamten Anwendung durch Nutzer
- Die Messung der Ladezeit einer Webseite
- Ein Test des Netzwerks

> Ein Unit-Test ruft eine Funktion mit Beispielwerten auf und prüft, ob das erwartete Ergebnis herauskommt. Läuft er automatisch, fallen Fehler sofort auf.

**230223 – Was ist ein Bug?**

- **Ein Fehler im Programm, der zu falschem Verhalten oder einem Absturz führt** ✅
- Ein Kommentar im Quellcode
- Eine Funktion ohne Rückgabewert
- Ein Werkzeug zum Kompilieren

> Bugs entstehen durch Tipp-, Denk- oder Logikfehler. Sie werden in einem Bugtracker erfasst und mit Tests, Debugger und Logs gesucht.


## Programmierung · Algorithmen & Secure Coding

**230224 – Was ist ein Algorithmus?**

- **Eine eindeutige Schritt-für-Schritt-Anleitung zur Lösung eines Problems** ✅
- Eine Programmiersprache
- Ein Fehler im Programm
- Eine Datenbanktabelle

> Ein Kochrezept ist ein Algorithmus: klare Schritte in fester Reihenfolge mit einem Ergebnis. In der Informatik z. B. „Sortiere diese Liste“.

**230225 – Was macht ein Sortieralgorithmus?**

- **Er bringt eine Liste von Elementen in eine bestimmte Reihenfolge, z. B. aufsteigend** ✅
- Er löscht doppelte Elemente
- Er verschlüsselt eine Liste
- Er zählt die Elemente einer Liste

> Bekannte Sortierverfahren sind Bubble Sort, Quick Sort und Merge Sort. Sie unterscheiden sich in Geschwindigkeit und Speicherbedarf.

**230226 – Was bedeutet Rekursion?**

- **Eine Funktion ruft sich selbst auf, bis eine Abbruchbedingung erreicht ist** ✅
- Eine Schleife, die rückwärts zählt
- Das Löschen einer Variablen
- Ein Kommentar, der sich wiederholt

> Beispiel Fakultät: fak(5) = 5 · fak(4), fak(4) = 4 · fak(3) … bis fak(1) = 1. Ohne Abbruchbedingung läuft die Rekursion endlos.

**230227 – Was bedeutet Secure Coding?**

- **Programmieren so, dass Sicherheitslücken von vornherein vermieden werden** ✅
- Den Quellcode mit einem Passwort schützen
- Nur mit verschlüsselten Dateien arbeiten
- Code ohne Kommentare schreiben

> Dazu gehören z. B. Eingaben prüfen, Passwörter nie im Klartext speichern und Bibliotheken aktuell halten. Sicherheit wird beim Schreiben mitgedacht, nicht erst danach.

**230228 – Warum sollte man Benutzereingaben in einem Programm immer prüfen?**

- **Weil fehlerhafte oder böswillige Eingaben zu Abstürzen oder Sicherheitslücken führen können** ✅
- Weil der Compiler es sonst nicht übersetzt
- Weil Eingaben sonst zu langsam sind
- Weil Nutzer sonst keine Rückmeldung bekommen

> Ein Angreifer kann in ein Eingabefeld SQL-Befehle oder Skripte schreiben. Wer Eingaben validiert und filtert, schließt diese Tür.


## IT-Sicherheit · Auth & Kryptografie

**230229 – Was bedeutet Authentifizierung?**

- **Der Nachweis, dass jemand wirklich die Person ist, die er vorgibt zu sein, z. B. per Passwort** ✅
- Die Verschlüsselung von Dateien
- Das Sichern von Daten auf einer externen Platte
- Das Löschen alter Benutzerkonten

> Authentifizierung beantwortet die Frage „Bist du wirklich du?“ – durch Wissen (Passwort), Besitz (Handy) oder Merkmal (Fingerabdruck). Autorisierung klärt danach, was man darf.

**230230 – Wofür steht die Abkürzung 2FA?**

- **Zwei-Faktor-Authentifizierung – Anmeldung mit zwei verschiedenen Nachweisen** ✅
- Zwei-Firewall-Architektur
- Fast Access Authentication
- Zweifache Datenarchivierung

> Neben dem Passwort braucht man einen zweiten Faktor, z. B. einen Code aus einer App oder per SMS. Selbst ein gestohlenes Passwort reicht dann nicht.

**230231 – Was bedeutet Verschlüsselung?**

- **Daten werden so umgewandelt, dass nur jemand mit dem passenden Schlüssel sie lesen kann** ✅
- Daten werden komprimiert, um Platz zu sparen
- Daten werden dauerhaft gelöscht
- Daten werden auf einen anderen Server kopiert

> Verschlüsselte Daten sehen für Unbefugte wie Zeichensalat aus. Erst mit dem richtigen Schlüssel werden sie wieder lesbar – z. B. bei HTTPS oder Messenger-Chats.

**230232 – Was ist ein Hash-Wert?**

- **Eine feste Zeichenfolge, die aus beliebigen Daten berechnet wird und sich nicht zurückrechnen lässt** ✅
- Ein verschlüsseltes Passwort, das entschlüsselt werden kann
- Eine Sicherheitskopie einer Datei
- Der Name eines Benutzerkontos

> Ein Hash wie SHA-256 macht aus jeder Eingabe einen Fingerabdruck. Passwörter werden als Hash gespeichert, damit sie bei einem Datendiebstahl nicht im Klartext vorliegen.

**230233 – Wofür sorgt ein Passwort-Manager?**

- **Er speichert für jeden Dienst ein eigenes starkes Passwort sicher verschlüsselt** ✅
- Er schaltet Passwörter für alle Dienste ab
- Er sendet Passwörter per E-Mail an den Administrator
- Er macht Passwörter für alle sichtbar

> Mit einem Passwort-Manager muss man sich nur ein Master-Passwort merken. Er erzeugt lange, zufällige Passwörter und füllt sie automatisch ein.


## IT-Sicherheit · Betrieb & Incident Response

**230234 – Was ist ein Sicherheitsvorfall (Security Incident)?**

- **Ein Ereignis, das die Sicherheit von IT-Systemen oder Daten gefährdet, z. B. ein Virenbefall** ✅
- Ein geplantes Software-Update
- Ein Stromausfall im Privathaushalt
- Ein neues Benutzerkonto

> Ein Incident kann ein gehackter Account, ein verlorener Laptop oder eine Ransomware-Infektion sein. Wichtig ist, dass er sofort gemeldet und dokumentiert wird.

**230235 – Was sollte ein Mitarbeiter als Erstes tun, wenn er einen Sicherheitsvorfall bemerkt?**

- **Den Vorfall sofort der IT-Abteilung oder dem Sicherheitsbeauftragten melden** ✅
- Den Computer selbst neu installieren
- Abwarten, ob das Problem von allein verschwindet
- Den Vorfall in sozialen Medien posten

> Schnelles Melden begrenzt den Schaden. Eigenmächtige Versuche, den Vorfall zu beheben, können Spuren vernichten oder die Lage verschlimmern.

**230236 – Was ist eine Logdatei?**

- **Eine Datei, in der ein System oder Programm Ereignisse mit Zeitstempel protokolliert** ✅
- Eine Sicherungskopie der Datenbank
- Ein Passwortspeicher
- Die Konfigurationsdatei der Firewall

> Logs zeigen, wer sich wann angemeldet hat, welche Fehler auftraten und was ein Server getan hat. Bei einem Sicherheitsvorfall sind sie die wichtigste Spur.

**230237 – Was ist Schadsoftware (Malware)?**

- **Programme, die absichtlich Schaden anrichten, z. B. Viren, Trojaner oder Ransomware** ✅
- Fehlerhafte, aber harmlose Software
- Software mit abgelaufener Lizenz
- Programme, die zu viel Speicher brauchen

> Malware ist der Oberbegriff für alle bösartigen Programme: Viren verbreiten sich, Trojaner tarnen sich, Ransomware verschlüsselt und erpresst.

**230238 – Warum sollte jeder Mitarbeiter ein eigenes Benutzerkonto haben?**

- **Damit nachvollziehbar ist, wer was getan hat, und Rechte einzeln vergeben werden können** ✅
- Weil Computer sonst langsamer werden
- Weil geteilte Konten mehr kosten
- Weil das Betriebssystem es so verlangt

> Bei geteilten Konten weiß man nach einem Vorfall nicht, wer verantwortlich war. Einzelkonten erlauben außerdem, Rechte gezielt zu vergeben und beim Ausscheiden zu sperren.


## IT-Sicherheit · Secure Dev & Advanced

**230239 – Was bedeutet SQL-Injection?**

- **Ein Angriff, bei dem über ein Eingabefeld eigene SQL-Befehle in die Datenbankabfrage eingeschleust werden** ✅
- Das Einspielen eines Datenbank-Backups
- Ein Fehler beim Anlegen einer Tabelle
- Das Verschlüsseln einer Datenbank

> Tippt ein Angreifer in ein Login-Feld ' OR 1=1 -- und die Anwendung setzt das ungeprüft in die SQL-Abfrage ein, kann er sich ohne Passwort anmelden oder Daten auslesen.

**230240 – Was ist ein Penetrationstest?**

- **Ein beauftragter, kontrollierter Angriff auf ein System, um Sicherheitslücken zu finden** ✅
- Ein Test der Internetgeschwindigkeit
- Die Prüfung der Passwortstärke aller Mitarbeiter
- Ein Belastungstest für Server

> Beim Pentest versuchen Sicherheitsexperten mit Erlaubnis, in ein System einzudringen. Die gefundenen Lücken werden dokumentiert und behoben, bevor echte Angreifer sie nutzen.

**230241 – Was ist ein Sicherheitspatch?**

- **Ein Update, das eine bekannte Sicherheitslücke in einer Software schließt** ✅
- Ein Programm, das Passwörter erzeugt
- Ein Aufkleber auf dem Server
- Eine Sicherungskopie der Festplatte

> Hersteller veröffentlichen Patches, sobald eine Lücke bekannt wird. Wer sie nicht einspielt, bleibt angreifbar – viele große Angriffe nutzten längst gepatchte Lücken.

**230242 – Was ist ein Salt bei der Passwortspeicherung?**

- **Eine zufällige Zeichenfolge, die vor dem Hashen an das Passwort angehängt wird** ✅
- Ein zweites Passwort für den Administrator
- Die Verschlüsselung der Datenbank
- Ein Passwort, das nur aus Zahlen besteht

> Durch den Salt ergeben gleiche Passwörter unterschiedliche Hashes. Vorberechnete Tabellen (Rainbow Tables) werden dadurch nutzlos.

**230243 – Was ist eine Sicherheitslücke (Schwachstelle) in Software?**

- **Ein Fehler, den Angreifer ausnutzen können, um unerlaubt Zugriff zu erhalten oder Schaden anzurichten** ✅
- Eine Funktion, die noch nicht fertig ist
- Ein Rechtschreibfehler in der Oberfläche
- Eine zu langsame Ladezeit

> Schwachstellen entstehen z. B. durch ungeprüfte Eingaben, veraltete Bibliotheken oder Standardpasswörter. Sie werden in Datenbanken wie CVE erfasst.


## Webentwicklung · HTML/CSS/HTTP Basics

**230244 – Wofür steht die Abkürzung HTML?**

- **Hypertext Markup Language – die Sprache, mit der der Inhalt und die Struktur von Webseiten beschrieben werden** ✅
- High Tech Modern Language
- Hyper Transfer Markup Link
- Home Tool Management Language

> HTML legt fest, was auf einer Seite steht: Überschriften, Absätze, Links, Bilder. Das Aussehen übernimmt CSS, das Verhalten JavaScript.

**230245 – Wofür wird CSS auf einer Webseite verwendet?**

- **Für die Gestaltung, also Farben, Schriften, Abstände und Layout** ✅
- Für die Speicherung von Daten in einer Datenbank
- Für die Programmierung von Berechnungen
- Für die Übertragung von E-Mails

> CSS (Cascading Style Sheets) trennt Aussehen von Inhalt. Eine CSS-Regel wie h1 { color: blue; } färbt alle Überschriften blau.

**230246 – Welches HTML-Tag erzeugt einen Link zu einer anderen Seite?**

- **<a>** ✅
- <link>
- <url>
- <href>

> Der Anker-Tag <a href="https://beispiel.de">Text</a> erzeugt einen klickbaren Link. Das Attribut href enthält das Ziel.

**230247 – Wofür steht die Abkürzung HTTP?**

- **Hypertext Transfer Protocol – das Protokoll, mit dem Browser und Webserver Daten austauschen** ✅
- Home Text Transfer Program
- High Throughput Transmission Port
- Hyperlink Tracking Protocol

> Der Browser schickt eine HTTP-Anfrage (Request), der Server antwortet mit einer HTTP-Antwort (Response), z. B. der HTML-Seite. HTTPS ist die verschlüsselte Variante.

**230248 – Was bedeutet der HTTP-Statuscode 404?**

- **Die angeforderte Seite wurde nicht gefunden** ✅
- Die Anfrage war erfolgreich
- Der Server ist überlastet
- Der Nutzer ist nicht angemeldet

> 404 Not Found ist der bekannteste Fehlercode: Die Adresse existiert nicht (mehr). 200 bedeutet OK, 500 ein Fehler auf dem Server.


## Webentwicklung · JavaScript & DOM

**230249 – Wofür wird JavaScript auf einer Webseite eingesetzt?**

- **Um die Seite interaktiv zu machen, z. B. auf Klicks zu reagieren oder Inhalte nachzuladen** ✅
- Um die Struktur der Seite festzulegen
- Um Schriftarten und Farben zu definieren
- Um die Seite auf dem Server zu speichern

> JavaScript läuft im Browser und verändert die Seite, ohne sie neu zu laden: Formulare prüfen, Menüs öffnen, Daten von einem Server holen.

**230250 – Wofür steht die Abkürzung DOM?**

- **Document Object Model – die Baumstruktur, mit der der Browser die HTML-Seite im Speicher darstellt** ✅
- Data Output Method
- Dynamic Online Module
- Document Order Manager

> Über das DOM kann JavaScript jedes Element ansprechen und ändern, z. B. den Text einer Überschrift austauschen oder ein Element ausblenden.

**230251 – Mit welchem Schlüsselwort deklariert man in modernem JavaScript eine Variable, deren Wert sich ändern darf?**

- **let** ✅
- const
- int
- define

> let erzeugt eine veränderbare Variable, const eine Konstante. Das alte var sollte man in neuem Code vermeiden, weil es weniger strenge Regeln hat.

**230252 – Mit welcher Funktion gibt man in JavaScript eine Meldung in der Browser-Konsole aus?**

- **console.log()** ✅
- print()
- echo()
- System.out.println()

> console.log("Hallo") schreibt in die Entwicklerkonsole des Browsers (F12). Das ist das wichtigste Werkzeug zum Nachvollziehen, was ein Skript tut.

**230253 – Was ist ein Event in JavaScript?**

- **Ein Ereignis wie ein Klick oder eine Tastatureingabe, auf das ein Skript reagieren kann** ✅
- Ein Fehler beim Laden der Seite
- Eine Variable mit Datum und Uhrzeit
- Ein Kommentar im Code

> Mit button.addEventListener("click", funktion) wird eine Funktion ausgeführt, sobald der Nutzer klickt. Weitere Events: keydown, submit, load.


## Webentwicklung · Backend & REST

**230254 – Was ist das Backend einer Webanwendung?**

- **Der Teil, der auf dem Server läuft und Daten verarbeitet und speichert** ✅
- Die Oberfläche, die der Nutzer im Browser sieht
- Das Design der Webseite
- Die Domain der Webseite

> Das Backend nimmt Anfragen entgegen, prüft Logins, liest und schreibt in die Datenbank und schickt Ergebnisse zurück. Das Frontend im Browser zeigt sie an.

**230255 – Wofür steht die Abkürzung API?**

- **Application Programming Interface – eine Schnittstelle, über die Programme miteinander kommunizieren** ✅
- Advanced Program Installer
- Automatic Page Index
- Application Password Interface

> Eine Web-API stellt Funktionen über URLs bereit: Die App fragt /api/kunden ab und bekommt die Kundenliste als JSON zurück.

**230256 – Wofür steht die Abkürzung JSON?**

- **JavaScript Object Notation – ein Textformat zum Austausch strukturierter Daten** ✅
- Java Standard Object Network
- Joint Server Output Node
- JavaScript Online Navigation

> JSON sieht so aus: {"name": "Anna", "alter": 25}. Fast alle Web-APIs liefern ihre Daten in diesem Format, weil es leicht lesbar und von jeder Sprache verarbeitbar ist.

**230257 – Welche HTTP-Methode wird verwendet, um Daten von einem Server abzurufen?**

- **GET** ✅
- POST
- SEND
- FETCH

> GET holt Daten (z. B. eine Seite oder eine Liste), POST sendet neue Daten an den Server, PUT ändert, DELETE löscht.

**230258 – Welche HTTP-Methode wird typischerweise verwendet, um neue Daten an den Server zu schicken, z. B. ein ausgefülltes Formular?**

- **POST** ✅
- GET
- READ
- OPEN

> POST überträgt Daten im Body der Anfrage an den Server, etwa beim Absenden einer Registrierung. GET dagegen ruft nur ab.


## Webentwicklung · Deployment & CI/CD

**230259 – Was bedeutet Deployment bei einer Webanwendung?**

- **Die Anwendung auf einem Server bereitstellen, damit Nutzer sie erreichen können** ✅
- Den Quellcode in Git speichern
- Die Anwendung im Browser testen
- Die Datenbank sichern

> Nach dem Entwickeln wird der Code gebaut, auf den Server kopiert und dort gestartet. Das kann manuell oder automatisch über eine Pipeline geschehen.

**230260 – Was ist ein Webserver?**

- **Ein Programm, das Webseiten und Dateien auf Anfrage an Browser ausliefert** ✅
- Ein Programm zum Erstellen von Webseiten
- Der Browser des Nutzers
- Ein Kabel zwischen Computer und Internet

> Bekannte Webserver sind Apache und Nginx. Sie nehmen HTTP-Anfragen entgegen und schicken HTML, Bilder oder API-Antworten zurück.

**230261 – Was ist eine Domain?**

- **Der lesbare Name einer Webseite, z. B. lernarena.app** ✅
- Die IP-Adresse des Servers
- Das Passwort für den Webserver
- Der Ordner mit den HTML-Dateien

> Die Domain wird per DNS in die IP-Adresse des Servers übersetzt. Man registriert sie bei einem Anbieter und zahlt meist jährlich dafür.

**230262 – Wofür steht die Abkürzung CI in CI/CD?**

- **Continuous Integration – Codeänderungen werden laufend automatisch zusammengeführt und getestet** ✅
- Computer Installation
- Code Inspection
- Central Interface

> Bei CI startet nach jedem Push automatisch ein Build mit Tests. Fehler fallen sofort auf, nicht erst Wochen später beim Zusammenführen.

**230263 – Was ist ein Hosting-Anbieter?**

- **Ein Unternehmen, das Server und Speicherplatz für Webseiten und Anwendungen vermietet** ✅
- Ein Programm zum Bearbeiten von HTML
- Eine Firma, die Domains verkauft
- Der Hersteller des Browsers

> Statt einen eigenen Server zu betreiben, mietet man Platz beim Hoster. Angebote reichen vom einfachen Webspace bis zu Cloud-Servern.


## Webentwicklung · Security & Performance

**230264 – Woran erkennt man im Browser, dass eine Webseite verschlüsselt übertragen wird?**

- **Am Schloss-Symbol und an „https://“ in der Adresszeile** ✅
- An einem grünen Hintergrund der Seite
- Daran, dass die Seite schneller lädt
- An der Endung .de

> HTTPS verschlüsselt die Verbindung per TLS. Ohne Schloss können Passwörter und Formulardaten unterwegs mitgelesen werden.

**230265 – Was ist ein Cookie?**

- **Eine kleine Textdatei, die der Browser für eine Webseite speichert, z. B. um den Login zu merken** ✅
- Ein Virus, der über Webseiten verbreitet wird
- Ein Bild auf einer Webseite
- Ein Programm zum Blockieren von Werbung

> Cookies speichern Informationen wie Sitzungs-ID oder Spracheinstellung. Beim nächsten Besuch schickt der Browser sie automatisch mit.

**230266 – Warum sollte eine Webseite möglichst schnell laden?**

- **Weil Nutzer bei langen Ladezeiten abspringen und Suchmaschinen schnelle Seiten bevorzugen** ✅
- Weil der Server sonst abstürzt
- Weil langsame Seiten mehr Strom verbrauchen
- Weil der Browser sonst eine Fehlermeldung zeigt

> Schon wenige Sekunden Wartezeit kosten Besucher. Große Bilder verkleinern, Dateien komprimieren und Caching nutzen sind die ersten Maßnahmen.

**230267 – Was ist ein Cache im Zusammenhang mit Webseiten?**

- **Ein Zwischenspeicher, in dem Browser oder Server bereits geladene Inhalte aufbewahren, damit sie beim nächsten Mal schneller da sind** ✅
- Ein Passwortspeicher im Browser
- Eine Liste blockierter Webseiten
- Der Verlauf besuchter Seiten

> Bilder, CSS und Skripte werden im Browser-Cache abgelegt. Beim zweiten Besuch müssen sie nicht erneut heruntergeladen werden.

**230268 – Was bedeutet es, wenn eine Webseite „responsive“ ist?**

- **Sie passt ihr Layout automatisch an Bildschirmgröße und Gerät an** ✅
- Sie antwortet auf E-Mails
- Sie lädt besonders schnell
- Sie ist gegen Angriffe geschützt

> Eine responsive Seite sieht auf dem Handy, Tablet und Desktop jeweils gut aus. Technisch nutzt man dafür CSS Media Queries und flexible Layouts.


## Cloud & DevOps · Cloud-Grundlagen

**230269 – Was bedeutet der Begriff Cloud in der IT?**

- **Rechenleistung, Speicher und Software, die über das Internet von einem Anbieter bereitgestellt werden** ✅
- Ein Speicher im Arbeitsspeicher des PCs
- Ein kabelloses Netzwerk
- Eine Sicherungskopie auf DVD

> Statt eigene Server zu kaufen, nutzt man Ressourcen bei Anbietern wie AWS, Microsoft Azure oder Google Cloud und zahlt nach Verbrauch.

**230270 – Wofür steht die Abkürzung IaaS?**

- **Infrastructure as a Service – gemietete Server, Speicher und Netzwerk in der Cloud** ✅
- Internet as a Service
- Installation as a Standard
- Integration and Application Security

> Bei IaaS bekommt man virtuelle Maschinen und Speicher; Betriebssystem und Software installiert man selbst. Beispiel: eine EC2-Instanz bei AWS.

**230271 – Wofür steht die Abkürzung PaaS?**

- **Platform as a Service – eine fertige Umgebung, in der man nur noch die eigene Anwendung hochlädt** ✅
- Password as a Service
- Program and Application Storage
- Public Access Server

> Bei PaaS kümmert sich der Anbieter um Server, Betriebssystem und Laufzeit. Der Entwickler lädt seinen Code hoch, z. B. bei Heroku oder Azure App Service.

**230272 – Welche der folgenden Firmen ist ein großer Cloud-Anbieter?**

- **Amazon (AWS)** ✅
- Adobe
- Intel
- Siemens

> Die drei größten Cloud-Anbieter sind Amazon Web Services, Microsoft Azure und Google Cloud. In Europa gibt es zusätzlich Anbieter wie IONOS oder Hetzner.

**230273 – Was ist ein Vorteil der Cloud gegenüber eigenen Servern im Keller?**

- **Ressourcen lassen sich bei Bedarf in Minuten vergrößern oder verkleinern** ✅
- Die Daten liegen garantiert im eigenen Gebäude
- Es fallen nie Kosten an
- Es wird kein Internet benötigt

> In der Cloud zahlt man nur, was man nutzt, und kann bei Lastspitzen sofort mehr Leistung buchen. Eigene Hardware muss man im Voraus kaufen und selbst warten.


## Cloud & DevOps · CI/CD & GitOps Basics

**230274 – Was bedeutet DevOps?**

- **Die enge Zusammenarbeit von Entwicklung (Development) und IT-Betrieb (Operations) mit viel Automatisierung** ✅
- Ein Programm zur Fehlersuche
- Eine Programmiersprache für Server
- Die Abteilung für Hardware-Einkauf

> DevOps will Software schneller und zuverlässiger ausliefern: gemeinsame Verantwortung, automatische Tests, automatische Deployments statt Übergabe „über den Zaun“.

**230275 – Was ist eine Pipeline in CI/CD?**

- **Eine automatische Abfolge von Schritten wie Bauen, Testen und Ausliefern, die nach jeder Codeänderung läuft** ✅
- Ein Netzwerkkabel zwischen Servern
- Eine Liste offener Fehler
- Ein Ordner für Backups

> Nach einem git push startet die Pipeline: Code kompilieren, Tests ausführen, bei Erfolg auf den Server bringen. Alles ohne Handarbeit.

**230276 – Wofür steht die Abkürzung CD in CI/CD?**

- **Continuous Delivery bzw. Continuous Deployment – automatisches Ausliefern der Software** ✅
- Compact Disc
- Code Documentation
- Central Database

> Nach der Integration (CI) folgt die Auslieferung (CD): Die getestete Version wird automatisch auf Test- oder Produktionsserver gebracht.

**230277 – Was ist ein Build?**

- **Der Vorgang, bei dem aus Quellcode ein ausführbares Programm oder Paket erzeugt wird** ✅
- Das Schreiben von Quellcode
- Das Löschen alter Versionen
- Ein Treffen des Entwicklerteams

> Beim Build wird kompiliert, Abhängigkeiten werden eingebunden und das Ergebnis verpackt, z. B. als APK, JAR oder Docker-Image.

**230278 – Was ist GitHub?**

- **Eine Plattform im Internet, auf der Git-Repositories gespeichert und gemeinsam bearbeitet werden** ✅
- Ein Texteditor für Programmierer
- Ein Betriebssystem für Server
- Eine Programmiersprache

> GitHub hostet Code, bietet Pull Requests für Code-Reviews und mit GitHub Actions eigene CI/CD-Pipelines. Alternativen sind GitLab und Bitbucket.


## Cloud & DevOps · Container & K8s

**230279 – Was ist Docker?**

- **Eine Software, mit der Anwendungen in Containern verpackt und ausgeführt werden** ✅
- Eine Programmiersprache
- Ein Cloud-Anbieter
- Ein Texteditor

> Mit Docker läuft eine Anwendung überall gleich, egal ob auf dem Laptop oder in der Cloud, weil alle Abhängigkeiten im Container stecken.

**230280 – Was ist ein Docker-Image?**

- **Eine unveränderliche Vorlage, aus der Container gestartet werden** ✅
- Ein Screenshot des Servers
- Ein Backup der Datenbank
- Ein Logo für die Anwendung

> Das Image enthält Betriebssystem-Basis, Programm und Einstellungen. Ein laufender Container ist eine Instanz davon, wie ein Objekt aus einer Klasse.

**230281 – Wofür steht die Abkürzung K8s?**

- **Kubernetes – ein System zur Verwaltung vieler Container** ✅
- Kernel 8 Standard
- Key Storage 8
- Kompakt-Server 8

> K8s ist die Kurzform von Kubernetes (K + 8 Buchstaben + s). Es startet, überwacht und skaliert Container automatisch auf vielen Servern.

**230282 – Was ist der Hauptzweck von Kubernetes?**

- **Viele Container automatisch zu verteilen, zu überwachen und bei Ausfall neu zu starten** ✅
- Quellcode zu kompilieren
- Webseiten zu gestalten
- Passwörter zu verwalten

> Kubernetes sorgt dafür, dass immer die gewünschte Anzahl Container läuft, verteilt Last und ersetzt abgestürzte Container automatisch.

**230283 – Welche Datei beschreibt, wie ein Docker-Image gebaut wird?**

- **Dockerfile** ✅
- docker.txt
- image.yaml
- container.cfg

> Das Dockerfile enthält Anweisungen wie FROM (Basis-Image), COPY (Dateien) und CMD (Startbefehl). „docker build“ erzeugt daraus das Image.


## Cloud & DevOps · IaC & Observability

**230284 – Wofür steht die Abkürzung IaC?**

- **Infrastructure as Code – Server und Netzwerke werden als Code beschrieben und automatisch erzeugt** ✅
- Internet and Cloud
- Installation as Configuration
- Integrated Access Control

> Statt Server von Hand anzuklicken, beschreibt man sie in Dateien (z. B. Terraform). Das ist wiederholbar, versionierbar und dokumentiert sich selbst.

**230285 – Was ist Terraform?**

- **Ein Werkzeug, mit dem Cloud-Infrastruktur als Code beschrieben und automatisch angelegt wird** ✅
- Eine Programmiersprache für Webseiten
- Ein Betriebssystem für Container
- Ein Programm zur Videobearbeitung

> In Terraform-Dateien steht z. B. „ein Server mit 4 GB RAM in Frankfurt“. „terraform apply“ legt ihn dann beim Cloud-Anbieter an.

**230286 – Was bedeutet Monitoring in der IT?**

- **Die laufende Überwachung von Systemen, z. B. ob Server erreichbar sind und wie ausgelastet sie sind** ✅
- Das Erstellen von Backups
- Die Installation von Updates
- Das Schreiben von Dokumentation

> Monitoring-Tools wie Grafana oder Zabbix zeigen CPU-Last, Speicher und Antwortzeiten und schlagen Alarm, bevor Nutzer ein Problem bemerken.

**230287 – Was ist eine Metrik im Monitoring?**

- **Ein Messwert über die Zeit, z. B. die CPU-Auslastung in Prozent** ✅
- Eine Fehlermeldung im Logfile
- Ein Passwort für das Monitoring-Tool
- Der Name eines Servers

> Metriken sind Zahlen mit Zeitstempel: Auslastung, Anfragen pro Sekunde, Antwortzeit. Logs dagegen sind Textmeldungen einzelner Ereignisse.

**230288 – Was ist ein Alert im Monitoring?**

- **Eine automatische Benachrichtigung, wenn ein Messwert einen Grenzwert überschreitet** ✅
- Ein wöchentlicher Bericht
- Ein Backup der Metriken
- Das Neustarten eines Servers

> Beispiel: Ist die Festplatte zu 90 % voll, geht eine Nachricht per E-Mail oder Chat an das Team. So reagiert man, bevor der Server steht.


## Cloud & DevOps · Reliability & Kosten

**230289 – Was bedeutet Hochverfügbarkeit (High Availability)?**

- **Ein System bleibt auch beim Ausfall einzelner Komponenten erreichbar** ✅
- Ein System, das sehr schnell antwortet
- Ein System mit besonders viel Speicher
- Ein System, das nur tagsüber läuft

> Hochverfügbarkeit erreicht man durch Redundanz: mehrere Server, mehrere Rechenzentren, automatische Umschaltung. Ziel sind z. B. 99,9 % Verfügbarkeit.

**230290 – Was bedeutet Skalierung?**

- **Die Leistung eines Systems an die Last anpassen, z. B. mehr Server bei mehr Nutzern** ✅
- Die Verschlüsselung von Daten
- Das Messen der Bildschirmgröße
- Das Löschen alter Logs

> Skalierung kann vertikal sein (größerer Server) oder horizontal (mehr Server). In der Cloud geht das oft automatisch (Autoscaling).

**230291 – Was bedeutet Redundanz in der IT?**

- **Wichtige Komponenten sind mehrfach vorhanden, damit ein Ausfall abgefangen wird** ✅
- Daten sind doppelt gespeichert und verschwenden Platz
- Ein Server läuft ohne Backup
- Ein Programm läuft langsamer als nötig

> Zwei Netzteile, zwei Internetleitungen, Datenspiegelung: Fällt eines aus, übernimmt das andere. Redundanz ist die Grundlage von Hochverfügbarkeit.

**230292 – Was bedeutet das Abrechnungsmodell „Pay as you go“ in der Cloud?**

- **Man zahlt nur für die Ressourcen, die man tatsächlich nutzt** ✅
- Man zahlt einen festen Jahresbetrag
- Man zahlt einmalig beim Kauf
- Die Nutzung ist kostenlos

> Läuft ein Server nur zwei Stunden, zahlt man zwei Stunden. Das ist flexibel, kann aber teuer werden, wenn man vergessene Ressourcen laufen lässt.

**230293 – Was bedeutet Ausfallzeit (Downtime)?**

- **Die Zeit, in der ein System nicht verfügbar ist** ✅
- Die Zeit, die ein Backup dauert
- Die Ladezeit einer Webseite
- Die Zeit bis zum nächsten Update

> Downtime kostet Geld und Vertrauen. Sie wird geplant (Wartung) oder ungeplant (Störung) gemessen und ist Teil von Verfügbarkeitszusagen (SLA).


## Datenstrukturen & Algorithmen · Grundlagen & Notation

**230294 – Was ist eine Datenstruktur?**

- **Eine Art, Daten im Speicher zu organisieren, z. B. als Liste, Stack oder Tabelle** ✅
- Ein Diagramm für Datenbanken
- Eine Programmiersprache
- Eine Datei auf der Festplatte

> Die Datenstruktur bestimmt, wie schnell man Daten findet, einfügt oder löscht. Für jede Aufgabe gibt es passende Strukturen: Array, Liste, Baum, Hash-Tabelle.

**230295 – Wofür steht die Abkürzung LIFO bei einem Stack?**

- **Last In, First Out – das zuletzt abgelegte Element wird als Erstes wieder entnommen** ✅
- Last In, First Ordered
- List In, File Out
- Low Input, Fast Output

> Ein Stack ist wie ein Tellerstapel: Man legt oben auf und nimmt oben weg. Die Rückgängig-Funktion in Programmen arbeitet so.

**230296 – Wofür steht die Abkürzung FIFO bei einer Queue?**

- **First In, First Out – das zuerst eingefügte Element wird als Erstes bearbeitet** ✅
- Fast In, Fast Out
- First In, Final Output
- File Input, File Output

> Eine Queue ist eine Warteschlange wie an der Kasse: Wer zuerst kommt, ist zuerst dran. Druckaufträge werden so abgearbeitet.

**230297 – Wie nennt man die Operation, mit der ein Element oben auf einen Stack gelegt wird?**

- **push** ✅
- pop
- add
- insert

> push legt ein Element oben auf den Stack, pop nimmt das oberste wieder herunter. Mit peek schaut man nur nach, ohne es zu entfernen.

**230298 – Was beschreibt die Laufzeit eines Algorithmus?**

- **Wie viele Schritte oder wie viel Zeit er in Abhängigkeit von der Datenmenge braucht** ✅
- Wie viele Zeilen Code er hat
- Wie lange die Entwicklung gedauert hat
- Wie viele Programmierer ihn geschrieben haben

> Die Laufzeit wird in Big-O-Notation angegeben: O(n) bedeutet, die Schritte wachsen linear mit der Anzahl n der Elemente.


## Datenstrukturen & Algorithmen · Lineare & verkettete Strukturen

**230299 – Was ist eine verkettete Liste?**

- **Eine Datenstruktur, bei der jedes Element auf das nächste Element zeigt** ✅
- Ein Array mit fester Größe
- Eine Tabelle in einer Datenbank
- Eine sortierte Liste von Zahlen

> Jeder Knoten enthält einen Wert und einen Zeiger auf den Nachfolger. Elemente lassen sich leicht einfügen und entfernen, aber der Zugriff auf das fünfte Element erfordert vier Sprünge.

**230300 – Wie nennt man ein einzelnes Element einer verketteten Liste?**

- **Knoten (Node)** ✅
- Zelle
- Index
- Schlüssel

> Ein Knoten speichert die Daten und den Verweis auf den nächsten Knoten. Der erste Knoten heißt Head, der letzte zeigt auf null.

**230301 – Was ist der Unterschied zwischen einem Array und einer verketteten Liste beim Zugriff auf ein Element?**

- **Im Array erreicht man jedes Element direkt über den Index, in der Liste muss man von vorne durchlaufen** ✅
- Es gibt keinen Unterschied
- Die Liste ist beim Zugriff immer schneller
- Arrays können nicht durchlaufen werden

> Array: arr[7] ist ein Schritt. Liste: sieben Sprünge von Knoten zu Knoten. Dafür kann die Liste ohne Umkopieren wachsen.

**230302 – Was bedeutet es, wenn eine verkettete Liste „doppelt verkettet“ ist?**

- **Jeder Knoten zeigt sowohl auf den nächsten als auch auf den vorherigen Knoten** ✅
- Jeder Wert ist zweimal gespeichert
- Die Liste ist mit einer zweiten Liste verbunden
- Die Liste hat doppelt so viele Elemente

> Mit Zeigern in beide Richtungen kann man die Liste vorwärts und rückwärts durchlaufen und ein Element ohne Suche des Vorgängers entfernen.

**230303 – Worauf zeigt der Zeiger des letzten Knotens in einer einfach verketteten Liste?**

- **Auf null (nichts) – damit ist das Ende markiert** ✅
- Auf den ersten Knoten
- Auf sich selbst
- Auf den Head der Liste

> Beim Durchlaufen prüft man „solange knoten != null“. Zeigt der letzte Knoten stattdessen auf den ersten, ist es eine Ringliste.


## Datenstrukturen & Algorithmen · Bäume & Heaps

**230304 – Was ist ein Baum als Datenstruktur?**

- **Eine hierarchische Struktur aus Knoten, die von einer Wurzel ausgehend verzweigt** ✅
- Eine Liste, die sortiert ist
- Eine Tabelle mit Zeilen und Spalten
- Ein Netzwerk aus Servern

> Ein Baum hat eine Wurzel, Knoten mit Kindern und Blätter ohne Kinder. Beispiele: Ordnerstruktur, Stammbaum, HTML-DOM.

**230305 – Wie heißt der oberste Knoten eines Baums?**

- **Wurzel (Root)** ✅
- Blatt
- Stamm
- Head

> Die Wurzel ist der einzige Knoten ohne Elternknoten. Von ihr aus erreicht man alle anderen Knoten des Baums.

**230306 – Wie nennt man einen Knoten in einem Baum, der keine Kinder hat?**

- **Blatt (Leaf)** ✅
- Wurzel
- Ast
- Elternknoten

> Blätter sind die Endpunkte eines Baums. In einem Dateisystem wären das die Dateien, während Ordner innere Knoten sind.

**230307 – Wie viele Kinder darf ein Knoten in einem binären Baum höchstens haben?**

- **2** ✅
- 1
- 3
- Beliebig viele

> „Binär“ bedeutet zwei: Jeder Knoten hat höchstens ein linkes und ein rechtes Kind. Das macht Suchen und Einfügen im binären Suchbaum effizient.

**230308 – Was ist ein Heap?**

- **Ein binärer Baum, bei dem jeder Elternknoten größer (oder kleiner) als seine Kinder ist** ✅
- Ein Baum, in dem alle Knoten gleich sind
- Eine Liste ohne Reihenfolge
- Ein Speicherbereich für Variablen

> Im Max-Heap steht das größte Element immer ganz oben. Deshalb eignen sich Heaps für Prioritätswarteschlangen und den Sortieralgorithmus Heapsort.


## Datenstrukturen & Algorithmen · Graphen & Sortieren

**230309 – Was ist ein Graph als Datenstruktur?**

- **Eine Menge von Knoten, die durch Kanten miteinander verbunden sind** ✅
- Ein Diagramm mit Balken und Linien
- Eine sortierte Liste von Zahlen
- Ein Bild in einem Programm

> Straßennetze, soziale Netzwerke und Routenplaner sind Graphen: Orte oder Personen sind Knoten, Verbindungen sind Kanten.

**230310 – Was ist eine Kante in einem Graphen?**

- **Die Verbindung zwischen zwei Knoten** ✅
- Der äußerste Knoten des Graphen
- Ein Knoten ohne Verbindungen
- Der Startpunkt einer Suche

> Kanten können gerichtet sein (Einbahnstraße) oder ungerichtet (beide Richtungen) und ein Gewicht tragen, z. B. die Entfernung in Kilometern.

**230311 – Was macht der Sortieralgorithmus Bubble Sort?**

- **Er vergleicht immer zwei benachbarte Elemente und vertauscht sie, wenn sie in falscher Reihenfolge sind** ✅
- Er teilt die Liste in zwei Hälften und sortiert sie getrennt
- Er sucht das kleinste Element und setzt es nach vorne
- Er sortiert mit Hilfe eines Baums

> Bubble Sort ist einfach zu verstehen, aber langsam (O(n²)). Große Elemente „steigen“ wie Blasen nach hinten. In der Praxis nutzt man schnellere Verfahren.

**230312 – Was ist der Vorteil einer sortierten Liste gegenüber einer unsortierten?**

- **Man kann viel schneller suchen, z. B. mit der binären Suche** ✅
- Sie braucht weniger Speicher
- Sie kann mehr Elemente aufnehmen
- Sie kann nicht verändert werden

> In einer sortierten Liste halbiert die binäre Suche bei jedem Schritt den Suchbereich: Bei 1.000 Elementen sind es nur etwa 10 Schritte statt bis zu 1.000.

**230313 – Was bedeutet es, einen Graphen zu durchlaufen (Traversierung)?**

- **Alle Knoten systematisch zu besuchen, z. B. in der Breite oder in der Tiefe** ✅
- Alle Kanten zu löschen
- Den Graphen zu zeichnen
- Die Knoten zu sortieren

> Breitensuche (BFS) besucht erst alle Nachbarn, dann deren Nachbarn. Tiefensuche (DFS) folgt einem Pfad so weit wie möglich, bevor sie umkehrt.


## Datenstrukturen & Algorithmen · Komplexität & Optimierung (Adv.)

**230314 – Was bedeutet O(1) in der Big-O-Notation?**

- **Die Laufzeit ist konstant, unabhängig von der Datenmenge** ✅
- Die Laufzeit verdoppelt sich mit jedem Element
- Der Algorithmus braucht genau eine Sekunde
- Der Algorithmus hat einen Fehler

> Der Zugriff auf arr[5] dauert gleich lang, ob das Array 10 oder 10 Millionen Elemente hat. Das ist die bestmögliche Laufzeitklasse.

**230315 – Was bedeutet O(n) in der Big-O-Notation?**

- **Die Laufzeit wächst linear mit der Anzahl n der Elemente** ✅
- Die Laufzeit ist immer gleich
- Die Laufzeit wächst quadratisch
- Der Algorithmus braucht n Sekunden

> Doppelt so viele Elemente, doppelt so lange: Eine Liste einmal komplett durchlaufen ist O(n), z. B. bei der linearen Suche.

**230316 – Welcher Algorithmus ist bei großen Datenmengen schneller: einer mit O(n) oder einer mit O(n²)?**

- **Der mit O(n)** ✅
- Der mit O(n²)
- Beide sind gleich schnell
- Das hängt vom Computer ab

> Bei n = 1.000 braucht O(n) rund 1.000 Schritte, O(n²) rund 1.000.000. Je größer n, desto deutlicher der Unterschied.

**230317 – Was bedeutet Optimierung eines Algorithmus?**

- **Ihn so zu verändern, dass er weniger Zeit oder weniger Speicher braucht** ✅
- Ihn in eine andere Programmiersprache übersetzen
- Mehr Kommentare hinzuzufügen
- Ihn auf einem größeren Server laufen zu lassen

> Typische Optimierungen: bessere Datenstruktur wählen, unnötige Schleifen vermeiden, Ergebnisse zwischenspeichern (Caching).

**230318 – Was ist der Unterschied zwischen Zeitkomplexität und Speicherkomplexität?**

- **Zeitkomplexität beschreibt die benötigte Rechenzeit, Speicherkomplexität den benötigten Speicherplatz** ✅
- Es gibt keinen Unterschied
- Zeitkomplexität gilt nur für Datenbanken
- Speicherkomplexität misst die Größe des Quellcodes

> Beides wird in Big-O angegeben. Oft kann man Zeit gegen Speicher tauschen: Eine Hash-Tabelle sucht in O(1), braucht aber mehr Speicher als eine Liste.

