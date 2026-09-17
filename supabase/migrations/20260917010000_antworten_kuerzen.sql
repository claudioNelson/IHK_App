-- 2026-09-17: Antworten der neuen Fragen (IDs ab 230000) kuerzen.
--
-- Befund (User, Arena-Match): Die 338 Fragen vom 07.-09.09. hatten im Schnitt
-- 73 Zeichen je Antwort (Altbestand: 38), 120 davon ueber 80 - alle vier
-- Antworten gleich lang und lang. Ursache: Der Antwortlaengen-Fix vom 09.09.
-- hat die falschen Antworten an die lange richtige angeglichen statt alle
-- zu kuerzen. Hier werden 330 Fragen (1.320 Antworten) neu geschrieben:
-- Ziel 25-55 Zeichen, max. 70, Laengenband <= 1,4, richtige Antwort nie die
-- laengste. Ergebnis: Schnitt 48 Zeichen. 8 Fragen mit Code-Antworten
-- (Backticks) bleiben unveraendert. Vier Agenten, Endkontrolle per Skript.
--
-- Einzeilige UPDATEs je Antwort-ID: der BEFORE-Trigger trg_didactic_expl_aiu
-- bleibt aktiv (nur bei mehrzeiligen Updates derselben Frage kollidiert er).

begin;
-- 230001: Wofür steht die Abkürzung LAN?
update public.antworten set text = 'Local Area Network, ein lokales Netz' where id = 1005284;
update public.antworten set text = 'Large Access Node, ein Zugangsknoten' where id = 1005285;
update public.antworten set text = 'Long Area Network, ein weltweites Netz' where id = 1005286;
update public.antworten set text = 'Link Address Number, Nummer der Netzkarte' where id = 1005287;
-- 230002: Welches Gerät verbindet mehrere Computer in einem lokalen Netzwerk miteinander u
update public.antworten set text = 'Switch' where id = 1005288;
update public.antworten set text = 'Drucker' where id = 1005289;
update public.antworten set text = 'Monitor' where id = 1005290;
update public.antworten set text = 'Netzteil' where id = 1005291;
-- 230003: Welches Gerät verbindet ein lokales Netzwerk mit dem Internet oder einem anderen
update public.antworten set text = 'Router zur Verbindung von Netzen' where id = 1005292;
update public.antworten set text = 'Hub zur Verteilung an alle Ports' where id = 1005293;
update public.antworten set text = 'Switch zur Verteilung im LAN' where id = 1005294;
update public.antworten set text = 'Repeater zur Signalverstärkung' where id = 1005295;
-- 230004: Wie heißt das Kabel, das in den meisten Büros und Wohnungen die Computer per Ste
update public.antworten set text = 'Netzwerkkabel (Ethernet, RJ45)' where id = 1005296;
update public.antworten set text = 'HDMI-Kabel (Monitoranschluss)' where id = 1005297;
update public.antworten set text = 'USB-Kabel (Typ A oder Typ C)' where id = 1005298;
update public.antworten set text = 'Stromkabel (Kaltgerätestecker)' where id = 1005299;
-- 230005: Wofür steht die Abkürzung WLAN?
update public.antworten set text = 'Wireless Local Area Network, kabelloses LAN' where id = 1005300;
update public.antworten set text = 'Wide Local Access Network, großes Zugangsnetz' where id = 1005301;
update public.antworten set text = 'World LAN, weltweit verteiltes Netzwerk' where id = 1005302;
update public.antworten set text = 'Wired LAN, kabelgebundenes Ethernet-Netz' where id = 1005303;
-- 230006: Was ist eine IP-Adresse?
update public.antworten set text = 'Eindeutige Adresse eines Geräts im Netzwerk' where id = 1005304;
update public.antworten set text = 'Feste Herstellerkennung der Netzwerkkarte' where id = 1005305;
update public.antworten set text = 'Passwort zur Anmeldung am WLAN-Router' where id = 1005306;
update public.antworten set text = 'Seriennummer zur Registrierung beim Hersteller' where id = 1005307;
-- 230007: Welche der folgenden Angaben ist eine gültige IPv4-Adresse?
update public.antworten set text = 'Die Angabe 192.168.1.10' where id = 1005308;
update public.antworten set text = 'Die Angabe 192.168.1.256' where id = 1005309;
update public.antworten set text = 'Die Angabe 192.168.1' where id = 1005310;
update public.antworten set text = 'Die Angabe www.beispiel.de' where id = 1005311;
-- 230008: Aus wie vielen Zahlenblöcken (Oktetten) besteht eine IPv4-Adresse?
update public.antworten set text = '4' where id = 1005312;
update public.antworten set text = '2' where id = 1005313;
update public.antworten set text = '6' where id = 1005314;
update public.antworten set text = '8' where id = 1005315;
-- 230009: Wozu dient die Subnetzmaske?
update public.antworten set text = 'Aufteilung der IP-Adresse in Netz- und Hostteil' where id = 1005316;
update public.antworten set text = 'Verschlüsselung der Datenübertragung im Netz' where id = 1005317;
update public.antworten set text = 'Speicherung des WLAN-Passworts für alle Geräte' where id = 1005318;
update public.antworten set text = 'Festlegung der maximalen Geschwindigkeit in Gbit/s' where id = 1005319;
-- 230010: Welche IP-Adresse ist die typische „Localhost“-Adresse, mit der ein Computer sic
update public.antworten set text = 'Die IPv4-Adresse 127.0.0.1' where id = 1005320;
update public.antworten set text = 'Die IPv4-Adresse 192.168.0.1' where id = 1005321;
update public.antworten set text = 'Die IPv4-Adresse 0.0.0.0' where id = 1005322;
update public.antworten set text = 'Die IPv4-Adresse 255.255.255.255' where id = 1005323;
-- 230011: Was ist ein Switch?
update public.antworten set text = 'Verbindet Geräte im LAN und sendet gezielt an den Zielport' where id = 1005324;
update public.antworten set text = 'Programm, das den Rechner nach Zeitplan ein- und ausschaltet' where id = 1005325;
update public.antworten set text = 'Gerät, das das LAN mit dem Internet und anderen Netzen verbindet' where id = 1005326;
update public.antworten set text = 'Glasfaserkabel für Lichtsignale über große Entfernungen' where id = 1005327;
-- 230012: Wie nennt man die Anschlüsse an einem Switch, in die die Netzwerkkabel gesteckt 
update public.antworten set text = 'Die Ports' where id = 1005328;
update public.antworten set text = 'Die Slots' where id = 1005329;
update public.antworten set text = 'Die Bays' where id = 1005330;
update public.antworten set text = 'Die Tunnel' where id = 1005331;
-- 230013: Wofür steht die Abkürzung VLAN?
update public.antworten set text = 'Virtual LAN, logisch getrenntes Netz im physischen Netz' where id = 1005332;
update public.antworten set text = 'Very Large Area Network, Netz für sehr große Flächen' where id = 1005333;
update public.antworten set text = 'Verified LAN, Netz nur für geprüfte Geräte per MAC-Filter' where id = 1005334;
update public.antworten set text = 'Video LAN, eigenes Netz nur für Videoübertragung' where id = 1005335;
-- 230014: Was ist eine MAC-Adresse?
update public.antworten set text = 'Eindeutige Hardware-Adresse einer Netzwerkkarte' where id = 1005336;
update public.antworten set text = 'Adresse, die nur Apple-Computer im Netz nutzen' where id = 1005337;
update public.antworten set text = 'Vom Router automatisch vergebene IP-Adresse im Heimnetz' where id = 1005338;
update public.antworten set text = 'Name, unter dem ein WLAN-Netz sichtbar ist' where id = 1005339;
-- 230015: Was macht ein Hub mit einem Datenpaket, das er auf einem Port empfängt?
update public.antworten set text = 'Er sendet es an alle anderen Ports weiter' where id = 1005340;
update public.antworten set text = 'Er sendet es nur an den passenden Zielport' where id = 1005341;
update public.antworten set text = 'Er speichert es dauerhaft im eigenen Puffer' where id = 1005342;
update public.antworten set text = 'Er verschlüsselt es vor dem Weitersenden' where id = 1005343;
-- 230016: Wofür steht die Abkürzung DNS?
update public.antworten set text = 'Domain Name System, übersetzt Namen in IP-Adressen' where id = 1005344;
update public.antworten set text = 'Data Network Service, stellt DHCP und NTP bereit' where id = 1005345;
update public.antworten set text = 'Digital Number Storage, speichert Rufnummern' where id = 1005346;
update public.antworten set text = 'Direct Network Switch, leitet Pakete an Ports weiter' where id = 1005347;
-- 230017: Wofür steht die Abkürzung DHCP?
update public.antworten set text = 'Dynamic Host Configuration Protocol, vergibt IP-Adressen' where id = 1005348;
update public.antworten set text = 'Direct Hardware Control Protocol, steuert Hardware im Netz' where id = 1005349;
update public.antworten set text = 'Data Host Copy Program, kopiert Daten zwischen Hosts' where id = 1005350;
update public.antworten set text = 'Dynamic Home Computer Port, öffnet Ports für Heimrechner' where id = 1005351;
-- 230018: Welches Gerät übernimmt zu Hause meist gleichzeitig Router, Switch, WLAN-Access-
update public.antworten set text = 'Der Internet-Router (z. B. eine Fritzbox)' where id = 1005352;
update public.antworten set text = 'Der Netzwerkdrucker (z. B. ein Laserdrucker)' where id = 1005353;
update public.antworten set text = 'Das Smartphone (z. B. ein Android-Handy)' where id = 1005354;
update public.antworten set text = 'Der Smart-TV (z. B. mit WLAN-Empfang)' where id = 1005355;
-- 230019: Welche Aufgabe hat das Default Gateway in einem Netzwerk?
update public.antworten set text = 'Adresse des Routers für den Weg aus dem eigenen Netz' where id = 1005356;
update public.antworten set text = 'Zwischenspeicher für Webseiten, damit sie schneller laden' where id = 1005357;
update public.antworten set text = 'Vergabe von Benutzernamen und Passwörtern im Netz' where id = 1005358;
update public.antworten set text = 'Verschlüsselung der WLAN-Daten zum Access Point' where id = 1005359;
-- 230020: Was ist ein Server?
update public.antworten set text = 'Computer, der anderen Geräten Dienste bereitstellt' where id = 1005360;
update public.antworten set text = 'Stromkabel, das Geräte im Serverschrank versorgt' where id = 1005361;
update public.antworten set text = 'Programm zum Surfen im Internet, z. B. Firefox' where id = 1005362;
update public.antworten set text = 'Speicherchip im Router für Konfiguration und Firmware' where id = 1005363;
-- 230021: Wofür wird eine Firewall eingesetzt?
update public.antworten set text = 'Kontrolle des Datenverkehrs, Sperrung unerwünschter Zugriffe' where id = 1005364;
update public.antworten set text = 'Beschleunigung der Internetverbindung durch Paketkomprimierung' where id = 1005365;
update public.antworten set text = 'Zentrale Speicherung von Passwörtern für alle Benutzer' where id = 1005366;
update public.antworten set text = 'Kühlung des Servers gegen Überhitzung der Hardware' where id = 1005367;
-- 230022: Welcher Port wird standardmäßig für verschlüsselte Webseiten (HTTPS) verwendet?
update public.antworten set text = 'Port 443' where id = 1005368;
update public.antworten set text = 'Port 80' where id = 1005369;
update public.antworten set text = 'Port 21' where id = 1005370;
update public.antworten set text = 'Port 8080' where id = 1005371;
-- 230023: Mit welchem Befehl prüft man in der Eingabeaufforderung, ob ein anderer Rechner 
update public.antworten set text = 'Der Befehl ping' where id = 1005372;
update public.antworten set text = 'Der Befehl print' where id = 1005373;
update public.antworten set text = 'Der Befehl copy' where id = 1005374;
update public.antworten set text = 'Der Befehl dir' where id = 1005375;
-- 230024: Mit welchem Windows-Befehl zeigt man die eigene IP-Adresse an?
update public.antworten set text = 'Der Befehl ipconfig' where id = 1005376;
update public.antworten set text = 'Der Befehl ipshow' where id = 1005377;
update public.antworten set text = 'Der Befehl ip address' where id = 1005378;
update public.antworten set text = 'Der Befehl netstat' where id = 1005379;
-- 230025: Was bedeutet das „S“ in HTTPS?
update public.antworten set text = 'Secure, die Verbindung ist verschlüsselt' where id = 1005380;
update public.antworten set text = 'Server, die Seite liegt auf einem Server' where id = 1005381;
update public.antworten set text = 'Standard, das Protokoll ist genormt' where id = 1005382;
update public.antworten set text = 'Speed, die Verbindung ist beschleunigt' where id = 1005383;
-- 230026: Was versteht man in der Betriebswirtschaft unter „Kosten“?
update public.antworten set text = 'In Geld bewerteter Güterverbrauch für die Leistungserstellung' where id = 1005384;
update public.antworten set text = 'Nur die Ausgaben für Werbung und Marketing zur Kundengewinnung' where id = 1005385;
update public.antworten set text = 'Das Geld, das Kunden für Produkte an das Unternehmen zahlen' where id = 1005386;
update public.antworten set text = 'Der Gewinn nach Steuern am Ende des Geschäftsjahres' where id = 1005387;
-- 230027: Welche der folgenden Kosten sind typischerweise fixe Kosten?
update public.antworten set text = 'Die monatliche Miete für das Bürogebäude' where id = 1005388;
update public.antworten set text = 'Das Material für jedes produzierte Stück' where id = 1005389;
update public.antworten set text = 'Die Versandkosten pro verschicktem Paket' where id = 1005390;
update public.antworten set text = 'Der Stromverbrauch der Maschinen pro Stück' where id = 1005391;
-- 230028: Wie berechnet man den Gewinn eines Unternehmens ganz grundsätzlich?
update public.antworten set text = 'Erlöse minus Kosten' where id = 1005392;
update public.antworten set text = 'Kosten minus Erlöse' where id = 1005393;
update public.antworten set text = 'Erlöse plus Kosten' where id = 1005394;
update public.antworten set text = 'Umsatz durch Kosten' where id = 1005395;
-- 230029: Was ist der Umsatz eines Unternehmens?
update public.antworten set text = 'Summe aller Verkaufserlöse in einem Zeitraum' where id = 1005396;
update public.antworten set text = 'Gewinn, der nach Abzug aller Kosten übrig bleibt' where id = 1005397;
update public.antworten set text = 'Guthaben, das auf dem Firmenkonto liegt' where id = 1005398;
update public.antworten set text = 'Anzahl der in einem Zeitraum verkauften Produkte' where id = 1005399;
-- 230030: Wie nennt man die Kosten, die einem einzelnen Produkt direkt zugeordnet werden k
update public.antworten set text = 'Einzelkosten' where id = 1005400;
update public.antworten set text = 'Gemeinkosten' where id = 1005401;
update public.antworten set text = 'Fixkosten' where id = 1005402;
update public.antworten set text = 'Gesamtkosten' where id = 1005403;
-- 230031: Was ist die Hauptaufgabe des Controllings in einem Unternehmen?
update public.antworten set text = 'Zahlen sammeln, Soll und Ist vergleichen, Leitung beraten' where id = 1005404;
update public.antworten set text = 'Mitarbeiter überwachen und Verstöße an den Chef melden' where id = 1005405;
update public.antworten set text = 'Produkte verkaufen, Kunden beraten, Aufträge gewinnen' where id = 1005406;
update public.antworten set text = 'Computer und Netzwerke warten, Mitarbeiter bei IT-Problemen helfen' where id = 1005407;
-- 230032: Was ist ein Soll-Ist-Vergleich?
update public.antworten set text = 'Vergleich von Planwerten mit tatsächlich erreichten Werten' where id = 1005408;
update public.antworten set text = 'Vergleich zweier Konkurrenzfirmen anhand von Umsatz und Kosten' where id = 1005409;
update public.antworten set text = 'Vergleich von Einkaufs- und Verkaufspreis (Handelsspanne)' where id = 1005410;
update public.antworten set text = 'Vergleich der Gehälter verschiedener Abteilungen' where id = 1005411;
-- 230033: Was ist eine Kennzahl?
update public.antworten set text = 'Zahl, die einen wichtigen Sachverhalt knapp zusammenfasst' where id = 1005412;
update public.antworten set text = 'Telefonnummer der Zentrale für Anrufe von Kunden' where id = 1005413;
update public.antworten set text = 'Kundennummer in der Datenbank zur Zuordnung von Aufträgen' where id = 1005414;
update public.antworten set text = 'Passwort für das Buchhaltungsprogramm zur Buchungsfreigabe' where id = 1005415;
-- 230034: Was bedeutet „Rentabilität“?
update public.antworten set text = 'Verhältnis von Gewinn zu eingesetztem Kapital' where id = 1005416;
update public.antworten set text = 'Anzahl der Produkte, die im Jahr verkauft wurden' where id = 1005417;
update public.antworten set text = 'Zahl der Jahre, die ein Unternehmen schon besteht' where id = 1005418;
update public.antworten set text = 'Höhe der Miete, die für Büroräume zu zahlen ist' where id = 1005419;
-- 230035: Was ist ein Plan-Wert (Soll-Wert) im Controlling?
update public.antworten set text = 'Vorher festgelegter Wert, der erreicht werden soll' where id = 1005420;
update public.antworten set text = 'Am Ende tatsächlich erreichter und erfasster Wert' where id = 1005421;
update public.antworten set text = 'Marktpreis, der alle Kosten deckt und Gewinn bringt' where id = 1005422;
update public.antworten set text = 'Kontostand des Unternehmens zu Beginn des Zeitraums' where id = 1005423;
-- 230036: Was ist der Unterschied zwischen kurzfristiger und langfristiger Planung?
update public.antworten set text = 'Kurzfristig meist bis zu ein Jahr, langfristig mehrere Jahre' where id = 1005424;
update public.antworten set text = 'Kurzfristig betrifft nur Mitarbeiter, langfristig nur die Kunden' where id = 1005425;
update public.antworten set text = 'Kein Unterschied, beide Begriffe meinen denselben Zeitraum' where id = 1005426;
update public.antworten set text = 'Kurzfristig ist immer teurer, weil weniger Zeit bleibt' where id = 1005427;
-- 230037: Was ist eine Abweichungsanalyse?
update public.antworten set text = 'Untersuchung, warum Ist-Werte von Planwerten abweichen' where id = 1005428;
update public.antworten set text = 'Suche nach Fehlern im Quellcode, die vom Sollverhalten abweichen' where id = 1005429;
update public.antworten set text = 'Prüfung, ob Mitarbeiter von ihren Arbeitszeiten abweichen' where id = 1005430;
update public.antworten set text = 'Vergleich von zwei Angeboten verschiedener Lieferanten' where id = 1005431;
-- 230038: Was ist ein Ist-Wert im Controlling?
update public.antworten set text = 'Der tatsächlich erreichte Wert, z. B. der erzielte Umsatz' where id = 1005432;
update public.antworten set text = 'Der im Voraus geplante Wert, z. B. der Budgetumsatz' where id = 1005433;
update public.antworten set text = 'Der Wert der Konkurrenz, z. B. deren erzielter Umsatz' where id = 1005434;
update public.antworten set text = 'Die Schätzung für das nächste Jahr, z. B. der erwartete Umsatz' where id = 1005435;
-- 230039: Was ist ein Vertrag?
update public.antworten set text = 'Verbindliche Vereinbarung zwischen mindestens zwei Parteien' where id = 1005436;
update public.antworten set text = 'Schreiben des Finanzamts, das die Steuer verbindlich festsetzt' where id = 1005437;
update public.antworten set text = 'Rechnung, mit der ein Verkäufer den Lieferbetrag einfordert' where id = 1005438;
update public.antworten set text = 'Gesetz des Bundestags, das für alle Bürger verbindlich gilt' where id = 1005439;
-- 230040: Wie kommt ein Vertrag zustande?
update public.antworten set text = 'Durch Angebot und Annahme' where id = 1005440;
update public.antworten set text = 'Nur durch notarielle Beurkundung' where id = 1005441;
update public.antworten set text = 'Durch die Bezahlung des Preises' where id = 1005442;
update public.antworten set text = 'Nur durch ein Schriftstück' where id = 1005443;
-- 230041: Muss ein Kaufvertrag im Supermarkt schriftlich geschlossen werden?
update public.antworten set text = 'Nein, auch mündlich oder durch schlüssiges Handeln möglich' where id = 1005444;
update public.antworten set text = 'Ja, jeder Kaufvertrag braucht die Unterschrift beider Parteien' where id = 1005445;
update public.antworten set text = 'Ja, sonst ist der Kauf ungültig und die Ware geht zurück' where id = 1005446;
update public.antworten set text = 'Nur bei Beträgen über 50 Euro ist Schriftform vorgeschrieben' where id = 1005447;
-- 230042: Wofür steht die Abkürzung BGB?
update public.antworten set text = 'Bürgerliches Gesetzbuch' where id = 1005448;
update public.antworten set text = 'Bundesgesetzesbuch' where id = 1005449;
update public.antworten set text = 'Betriebliches Gesetzbuch' where id = 1005450;
update public.antworten set text = 'Bundesgerichtsbarkeit' where id = 1005451;
-- 230043: Welche Pflicht hat der Käufer bei einem Kaufvertrag?
update public.antworten set text = 'Den Kaufpreis zahlen und die Ware abnehmen' where id = 1005452;
update public.antworten set text = 'Die Ware liefern und dem Käufer übergeben' where id = 1005453;
update public.antworten set text = 'Eine Garantie auf die gelieferte Ware geben' where id = 1005454;
update public.antworten set text = 'Die Ware bei Mängeln reparieren oder ersetzen' where id = 1005455;
-- 230044: Was ist ein Sprint in Scrum?
update public.antworten set text = 'Fester Zeitraum (1 bis 4 Wochen) mit fertigem Teilergebnis' where id = 1005456;
update public.antworten set text = 'Wettlauf zweier Entwickler um die schnellere Fertigstellung' where id = 1005457;
update public.antworten set text = 'Letzte Woche vor der Abgabe zum Abschluss aller offenen Aufgaben' where id = 1005458;
update public.antworten set text = 'Kundenmeeting zu Beginn zur Festlegung der Anforderungen' where id = 1005459;
-- 230045: Welche drei Rollen gibt es in Scrum?
update public.antworten set text = 'Product Owner, Scrum Master und Entwicklungsteam' where id = 1005460;
update public.antworten set text = 'Projektleiter, Teamleiter und das Entwicklungsteam' where id = 1005461;
update public.antworten set text = 'Auftraggeber, Product Manager und Tester' where id = 1005462;
update public.antworten set text = 'Product Manager, Controller und Designer' where id = 1005463;
-- 230046: Was ist das Product Backlog?
update public.antworten set text = 'Geordnete Liste aller noch offenen Anforderungen ans Produkt' where id = 1005464;
update public.antworten set text = 'Fehlerbericht, in dem alle gemeldeten Bugs priorisiert werden' where id = 1005465;
update public.antworten set text = 'Fertiges Produkt, das am Ende des Sprints ausgeliefert wird' where id = 1005466;
update public.antworten set text = 'Liste aller Mitarbeiter, die am Produkt beteiligt sind' where id = 1005467;
-- 230047: Was ist das Daily Scrum?
update public.antworten set text = 'Kurzes tägliches Teamtreffen zum Abgleich des Stands' where id = 1005468;
update public.antworten set text = 'Wöchentlicher Bericht des Teams an den Kunden zum Stand' where id = 1005469;
update public.antworten set text = 'Abschlussfeier eines Projekts nach dem letzten Sprint' where id = 1005470;
update public.antworten set text = 'Mehrtägiges Training für neue Mitarbeiter im Team' where id = 1005471;
-- 230048: Was bedeutet „agil“ in der Softwareentwicklung?
update public.antworten set text = 'Flexibel in kurzen Schritten und mit regelmäßigem Feedback' where id = 1005472;
update public.antworten set text = 'Schnell programmieren ohne Planung, Tests und Dokumentation' where id = 1005473;
update public.antworten set text = 'Alle Anforderungen anfangs festlegen und nie mehr ändern' where id = 1005474;
update public.antworten set text = 'Allein am Projekt arbeiten, um Abstimmungen zu vermeiden' where id = 1005475;
-- 230049: Was kennzeichnet das Wasserfallmodell?
update public.antworten set text = 'Phasen laufen nacheinander ab, jede wird komplett abgeschlossen' where id = 1005476;
update public.antworten set text = 'Alle Phasen laufen gleichzeitig, damit Fehler sofort erkannt werden' where id = 1005477;
update public.antworten set text = 'Keine festen Phasen, das Team entscheidet täglich neu' where id = 1005478;
update public.antworten set text = 'Arbeit in kurzen Sprints mit fertigem Teilprodukt am Ende' where id = 1005479;
-- 230050: Welche Phase steht im Wasserfallmodell ganz am Anfang?
update public.antworten set text = 'Die Anforderungsanalyse' where id = 1005480;
update public.antworten set text = 'Der Integrationstest' where id = 1005481;
update public.antworten set text = 'Die Wartung im Betrieb' where id = 1005482;
update public.antworten set text = 'Die Implementierung im Code' where id = 1005483;
-- 230051: Was ist ein Lastenheft?
update public.antworten set text = 'Dokument des Auftraggebers mit seinen Erwartungen ans Produkt' where id = 1005484;
update public.antworten set text = 'Dokument mit den Gehältern und Stundensätzen des Teams' where id = 1005485;
update public.antworten set text = 'Liste aller gefundenen Fehler, die der Auftragnehmer beheben muss' where id = 1005486;
update public.antworten set text = 'Quellcode, den der Auftragnehmer dem Kunden übergibt' where id = 1005487;
-- 230052: Wer schreibt normalerweise das Pflichtenheft?
update public.antworten set text = 'Der Auftragnehmer' where id = 1005488;
update public.antworten set text = 'Der Auftraggeber' where id = 1005489;
update public.antworten set text = 'Die zuständige IHK' where id = 1005490;
update public.antworten set text = 'Der Endnutzer' where id = 1005491;
-- 230053: In welcher Phase des Wasserfallmodells wird der Programmcode geschrieben?
update public.antworten set text = 'In der Implementierung' where id = 1005492;
update public.antworten set text = 'In der Anforderungsanalyse' where id = 1005493;
update public.antworten set text = 'In der Testdurchführung' where id = 1005494;
update public.antworten set text = 'In der Wartungsphase' where id = 1005495;
-- 230054: Was zeigt ein Gantt-Diagramm?
update public.antworten set text = 'Die Aufgaben eines Projekts als Balken auf einer Zeitachse' where id = 1005496;
update public.antworten set text = 'Die Kosten jeder Abteilung als Balken in einem Diagramm' where id = 1005497;
update public.antworten set text = 'Die Hierarchie der Mitarbeiter als Baum von oben nach unten' where id = 1005498;
update public.antworten set text = 'Den Gewinn pro Monat als Linie auf einer Zeitachse' where id = 1005499;
-- 230055: Was ist ein Netzplan im Projektmanagement?
update public.antworten set text = 'Darstellung der Projektvorgänge und ihrer Abhängigkeiten' where id = 1005500;
update public.antworten set text = 'Darstellung des Computernetzwerks mit Routern und Switches' where id = 1005501;
update public.antworten set text = 'Organigramm aller Abteilungen und Stellen des Unternehmens' where id = 1005502;
update public.antworten set text = 'Plan für Kabelverlegung und Netzwerkdosen im Gebäude' where id = 1005503;
-- 230056: Was ist ein Meilenstein?
update public.antworten set text = 'Wichtiges Zwischenziel, oft mit festem Termin' where id = 1005504;
update public.antworten set text = 'Fehler im Projektplan, der den Endtermin verschiebt' where id = 1005505;
update public.antworten set text = 'Gesamtdauer des Projekts von Start bis zur Abnahme' where id = 1005506;
update public.antworten set text = 'Mitarbeiter mit besonderer Verantwortung im Projekt' where id = 1005507;
-- 230057: Was bedeutet „Vorgang“ in der Netzplantechnik?
update public.antworten set text = 'Eine einzelne Aufgabe mit einer bestimmten Dauer' where id = 1005508;
update public.antworten set text = 'Der Projektleiter, der den Netzplan erstellt' where id = 1005509;
update public.antworten set text = 'Das gesamte Projekt von Anfang bis Ende inklusive Planung' where id = 1005510;
update public.antworten set text = 'Ein Meeting mit allen Beteiligten des Projekts' where id = 1005511;
-- 230058: Was bedeutet es, wenn ein Vorgang auf dem kritischen Pfad liegt?
update public.antworten set text = 'Verzögert er sich, verzögert sich das ganze Projekt' where id = 1005512;
update public.antworten set text = 'Er verursacht die höchsten Kosten im gesamten Projekt' where id = 1005513;
update public.antworten set text = 'Er ist besonders gefährlich für die Mitarbeiter' where id = 1005514;
update public.antworten set text = 'Er kann jederzeit ohne Folgen verschoben werden' where id = 1005515;
-- 230059: Was ist ein Projekt?
update public.antworten set text = 'Einmaliges Vorhaben mit Ziel, Zeitrahmen und begrenzten Mitteln' where id = 1005516;
update public.antworten set text = 'Jede Aufgabe über eine Stunde, an der mehrere Personen arbeiten' where id = 1005517;
update public.antworten set text = 'Tägliche Supportarbeit mit immer ähnlichen Anfragen' where id = 1005518;
update public.antworten set text = 'Abteilung mit festem Personal und dauerhaften Aufgaben' where id = 1005519;
-- 230060: Wer ist ein Stakeholder?
update public.antworten set text = 'Person oder Gruppe mit Interesse am Projekt oder davon betroffen' where id = 1005520;
update public.antworten set text = 'Nur der Projektleiter, der das Projekt plant und verantwortet' where id = 1005521;
update public.antworten set text = 'Nur der Kunde, der das Projekt bezahlt und Anforderungen festlegt' where id = 1005522;
update public.antworten set text = 'Aktionär, der Anteile an der Firma hält und am Gewinn beteiligt ist' where id = 1005523;
-- 230061: Was ist ein Projektziel?
update public.antworten set text = 'Das Ergebnis, das am Ende des Projekts erreicht sein soll' where id = 1005524;
update public.antworten set text = 'Die Liste aller Teammitglieder mit ihren Rollen' where id = 1005525;
update public.antworten set text = 'Der Zeitplan mit allen Terminen, Meilensteinen und Puffern' where id = 1005526;
update public.antworten set text = 'Das Budget, das für das Projekt freigegeben wurde' where id = 1005527;
-- 230062: Was ist ein Risiko im Projekt?
update public.antworten set text = 'Mögliches Ereignis mit negativen Folgen für das Projekt' where id = 1005528;
update public.antworten set text = 'Bereits eingetretener Fehler, der das Projekt verzögert hat' where id = 1005529;
update public.antworten set text = 'Teammitglied, das für die Qualitätssicherung zuständig ist' where id = 1005530;
update public.antworten set text = 'Kosten des Projekts, die im Budget eingeplant werden müssen' where id = 1005531;
-- 230063: Was ist der Projektabschluss?
update public.antworten set text = 'Letzte Phase mit Übergabe des Ergebnisses und Auswertung' where id = 1005532;
update public.antworten set text = 'Erster Projekttag, an dem Team und Ziel festgelegt werden' where id = 1005533;
update public.antworten set text = 'Budgetplanung mit Kostenschätzung und Freigabe der Mittel' where id = 1005534;
update public.antworten set text = 'Meeting in der Projektmitte zum Vergleich mit dem Zeitplan' where id = 1005535;
-- 230064: Was bedeutet Qualität im Qualitätsmanagement?
update public.antworten set text = 'Grad der Erfüllung der Anforderungen durch ein Produkt' where id = 1005536;
update public.antworten set text = 'Möglichst hoher Preis, denn teure Produkte gelten als hochwertig' where id = 1005537;
update public.antworten set text = 'Möglichst schönes Design, damit das Produkt sofort gefällt' where id = 1005538;
update public.antworten set text = 'Anzahl der Funktionen, die ein Produkt dem Kunden bietet' where id = 1005539;
-- 230065: Wofür steht die Abkürzung QM?
update public.antworten set text = 'Qualitätsmanagement' where id = 1005540;
update public.antworten set text = 'Quartalsmeeting' where id = 1005541;
update public.antworten set text = 'Quellcode-Management' where id = 1005542;
update public.antworten set text = 'Qualitätsmitarbeiter' where id = 1005543;
-- 230066: Wofür stehen die vier Buchstaben im PDCA-Zyklus?
update public.antworten set text = 'Plan, Do, Check, Act' where id = 1005544;
update public.antworten set text = 'Plan, Do, Code, Act' where id = 1005545;
update public.antworten set text = 'Plan, Do, Check, Ask' where id = 1005546;
update public.antworten set text = 'Projekt, Daten, Chef, Amt' where id = 1005547;
-- 230067: Was ist das Ziel der kontinuierlichen Verbesserung (KVP)?
update public.antworten set text = 'Stetige Verbesserung in vielen kleinen Schritten' where id = 1005548;
update public.antworten set text = 'Alle Prozesse einmal im Jahr komplett neu gestalten' where id = 1005549;
update public.antworten set text = 'Nur die Kosten senken, ohne die Qualität zu betrachten' where id = 1005550;
update public.antworten set text = 'Mitarbeiter kontrollieren und jeden Fehler sanktionieren' where id = 1005551;
-- 230068: Was bedeutet Kundenorientierung im Qualitätsmanagement?
update public.antworten set text = 'Bedürfnisse und Erwartungen der Kunden stehen im Mittelpunkt' where id = 1005552;
update public.antworten set text = 'Der Kunde wird über alle internen Abläufe informiert' where id = 1005553;
update public.antworten set text = 'Der Kunde wählt die Mitarbeiter für seinen Auftrag selbst aus' where id = 1005554;
update public.antworten set text = 'Kunden werden nur nach dem gezahlten Preis bedient' where id = 1005555;
-- 230069: Was bedeutet es, wenn eine Software „zuverlässig“ ist?
update public.antworten set text = 'Sie läuft über längere Zeit stabil und stürzt nicht ab' where id = 1005556;
update public.antworten set text = 'Sie bietet viele Funktionen und deckt alle Anwendungsfälle ab' where id = 1005557;
update public.antworten set text = 'Sie ist kostenlos und kann ohne Lizenz genutzt werden' where id = 1005558;
update public.antworten set text = 'Sie sieht modern aus und folgt aktuellen Design-Trends' where id = 1005559;
-- 230070: Was versteht man unter der Benutzbarkeit (Usability) einer Software?
update public.antworten set text = 'Wie leicht Nutzer die Software erlernen und bedienen können' where id = 1005560;
update public.antworten set text = 'Wie schnell die Software startet und auf Klicks der Nutzer reagiert' where id = 1005561;
update public.antworten set text = 'Wie viel Speicherplatz die Software auf dem Gerät belegt' where id = 1005562;
update public.antworten set text = 'Wie teuer die Lizenz ist und wie viele Nutzer sie erlaubt' where id = 1005563;
-- 230071: Was bedeutet „Wartbarkeit“ bei Software?
update public.antworten set text = 'Wie leicht sich die Software ändern und erweitern lässt' where id = 1005564;
update public.antworten set text = 'Wie oft die Software für stabilen Betrieb neu starten muss' where id = 1005565;
update public.antworten set text = 'Wie lange der Hersteller Garantie und Support gewährt' where id = 1005566;
update public.antworten set text = 'Ob es eine Hotline für Fragen zur Bedienung gibt' where id = 1005567;
-- 230072: Was bedeutet „Funktionalität“ als Qualitätsmerkmal?
update public.antworten set text = 'Alle geforderten Funktionen sind vorhanden und arbeiten korrekt' where id = 1005568;
update public.antworten set text = 'Die Software läuft ohne Anpassung auf vielen Geräten und Systemen' where id = 1005569;
update public.antworten set text = 'Die Software reagiert schnell und braucht wenig Speicher' where id = 1005570;
update public.antworten set text = 'Die Software ist hübsch gestaltet und wirkt ansprechend' where id = 1005571;
-- 230073: Was bedeutet „Effizienz“ bei Software?
update public.antworten set text = 'Erledigt Aufgaben mit wenig Zeit, Speicher und Rechenleistung' where id = 1005572;
update public.antworten set text = 'Wenige Fehler und korrekte Ergebnisse auch bei ungültigen Eingaben' where id = 1005573;
update public.antworten set text = 'Leicht zu bedienen und auch ohne Schulung schnell verständlich' where id = 1005574;
update public.antworten set text = 'Häufige Aktualisierungen und regelmäßig neue Funktionen' where id = 1005575;
-- 230074: Warum wird Software getestet?
update public.antworten set text = 'Um Fehler zu finden, bevor die Software beim Kunden läuft' where id = 1005576;
update public.antworten set text = 'Um den Quellcode zu verschlüsseln, bevor er zum Kunden geht' where id = 1005577;
update public.antworten set text = 'Um die Software schneller zu machen, bevor sie zum Kunden geht' where id = 1005578;
update public.antworten set text = 'Weil es vor dem Verkauf gesetzlich vorgeschrieben ist' where id = 1005579;
-- 230075: Was ist ein Testfall?
update public.antworten set text = 'Beschreibung von Eingabe, Ablauf und erwartetem Ergebnis' where id = 1005580;
update public.antworten set text = 'Fehler, der beim Testen gefunden und im Bugtracker erfasst wird' where id = 1005581;
update public.antworten set text = 'Ordner mit Testdaten, die für die Tests bereitgestellt werden' where id = 1005582;
update public.antworten set text = 'Name des Testers, der für den Test verantwortlich ist' where id = 1005583;
-- 230076: Was ist ein Modultest (Unit-Test)?
update public.antworten set text = 'Test eines einzelnen Bausteins isoliert, z. B. einer Funktion' where id = 1005584;
update public.antworten set text = 'Test des Gesamtsystems durch den Kunden, z. B. eine Bestellung' where id = 1005585;
update public.antworten set text = 'Test der Netzwerkgeschwindigkeit, z. B. mit einem Speedtest' where id = 1005586;
update public.antworten set text = 'Umfrage zur Nutzerzufriedenheit, z. B. per Fragebogen' where id = 1005587;
-- 230077: Was ist der Abnahmetest?
update public.antworten set text = 'Prüfung durch den Auftraggeber, ob die Anforderungen erfüllt sind' where id = 1005588;
update public.antworten set text = 'Erster Test eines neuen Entwicklers zur Einarbeitung in den Code' where id = 1005589;
update public.antworten set text = 'Automatischer Test beim Programmstart, ob alle Dateien vorhanden sind' where id = 1005590;
update public.antworten set text = 'Test der Hardware, ob der Rechner die Software ausführen kann' where id = 1005591;
-- 230078: Was bedeutet „Black-Box-Test“?
update public.antworten set text = 'Test nur über Ein- und Ausgaben, ohne Kenntnis des Codes' where id = 1005592;
update public.antworten set text = 'Test in einem abgedunkelten Raum, damit niemand abgelenkt wird' where id = 1005593;
update public.antworten set text = 'Prüfung des Quellcodes Zeile für Zeile auf Fehler in der Logik' where id = 1005594;
update public.antworten set text = 'Test, der nachts automatisch ohne anwesenden Tester läuft' where id = 1005595;
-- 230079: Was ist eine Norm (z. B. eine DIN-Norm)?
update public.antworten set text = 'Anerkannte Regel, wie etwas beschaffen sein oder ablaufen soll' where id = 1005596;
update public.antworten set text = 'Gesetz des Bundestags, das technische Produkte verbindlich regelt' where id = 1005597;
update public.antworten set text = 'Anweisung des Vorgesetzten, wie Aufgaben zu erledigen sind' where id = 1005598;
update public.antworten set text = 'Passwort-Standard mit Vorgaben zu Mindestlänge und Zeichenarten' where id = 1005599;
-- 230080: Wofür steht die Abkürzung ISO?
update public.antworten set text = 'Internationale Organisation für Normung' where id = 1005600;
update public.antworten set text = 'Internationale Internet-Service-Organisation' where id = 1005601;
update public.antworten set text = 'Institut für Software-Optimierung' where id = 1005602;
update public.antworten set text = 'Internationale Sicherheits-Ordnung' where id = 1005603;
-- 230081: Was bedeutet Barrierefreiheit bei Software und Webseiten?
update public.antworten set text = 'Auch Menschen mit Einschränkungen können sie ohne Hilfe nutzen' where id = 1005604;
update public.antworten set text = 'Die Software ist kostenlos, auch für Menschen mit wenig Geld' where id = 1005605;
update public.antworten set text = 'Die Software läuft ohne Internet und ist auch unterwegs nutzbar' where id = 1005606;
update public.antworten set text = 'Die Software zeigt keine Werbung und keine Pop-ups' where id = 1005607;
-- 230082: Was ist ein Alternativtext (Alt-Text) bei einem Bild auf einer Webseite?
update public.antworten set text = 'Textbeschreibung des Bildes, die vorgelesen wird, wenn es fehlt' where id = 1005608;
update public.antworten set text = 'Dateiname des Bildes, der bei Ladefehlern angezeigt wird' where id = 1005609;
update public.antworten set text = 'Wasserzeichen im Bild, das den Urheber nennt und vor Kopien schützt' where id = 1005610;
update public.antworten set text = 'Bildgröße in Pixeln, damit der Browser den Platz reserviert' where id = 1005611;
-- 230083: Warum sind Standards in der IT wichtig?
update public.antworten set text = 'Damit Produkte verschiedener Hersteller zusammenpassen' where id = 1005612;
update public.antworten set text = 'Damit alle Produkte gleich aussehen und austauschbar wirken' where id = 1005613;
update public.antworten set text = 'Damit Software mit Prüfsiegel teurer verkauft werden kann' where id = 1005614;
update public.antworten set text = 'Damit ein einziger Hersteller den Markt beherrscht' where id = 1005615;
-- 230084: Was ist ein Markt in der Wirtschaft?
update public.antworten set text = 'Treffpunkt von Angebot und Nachfrage' where id = 1005616;
update public.antworten set text = 'Nur ein Wochenmarkt mit Verkaufsständen' where id = 1005617;
update public.antworten set text = 'Die Abteilung für Werbung und Vertrieb' where id = 1005618;
update public.antworten set text = 'Ein Lager für Waren bis zum Verkauf' where id = 1005619;
-- 230085: Was bedeutet „Nachfrage“?
update public.antworten set text = 'Menge, die Käufer zu einem Preis kaufen wollen' where id = 1005620;
update public.antworten set text = 'Menge, die Hersteller zu einem Preis anbieten wollen' where id = 1005621;
update public.antworten set text = 'Frage eines Kunden an den Kundenservice' where id = 1005622;
update public.antworten set text = 'Lagerbestand eines Unternehmens zum Stichtag' where id = 1005623;
-- 230086: Was bedeutet „Angebot“ in der Wirtschaft?
update public.antworten set text = 'Menge, die Anbieter zu einem Preis verkaufen wollen' where id = 1005624;
update public.antworten set text = 'Zeitlich begrenzter Rabatt zur Kaufanregung' where id = 1005625;
update public.antworten set text = 'Anzahl der Kunden, die zu einem Preis kaufen wollen' where id = 1005626;
update public.antworten set text = 'Werbeanzeige eines Anbieters für seine Waren' where id = 1005627;
-- 230087: Was ist ein Monopol?
update public.antworten set text = 'Marktform mit nur einem einzigen Anbieter' where id = 1005628;
update public.antworten set text = 'Marktform mit vielen kleinen Anbietern und Nachfragern' where id = 1005629;
update public.antworten set text = 'Brettspiel, bei dem Straßen und Häuser gekauft werden' where id = 1005630;
update public.antworten set text = 'Marktform mit genau zwei Anbietern am Markt' where id = 1005631;
-- 230088: Was ist Wettbewerb (Konkurrenz)?
update public.antworten set text = 'Mehrere Anbieter kämpfen um dieselben Kunden' where id = 1005632;
update public.antworten set text = 'Vertrag zweier Firmen über Preise und Lieferbedingungen' where id = 1005633;
update public.antworten set text = 'Zusammenarbeit mehrerer Firmen zur Kostensenkung' where id = 1005634;
update public.antworten set text = 'Sportveranstaltung der Firma zwischen Abteilungen' where id = 1005635;
-- 230089: Was zeigt ein Organigramm?
update public.antworten set text = 'Aufbau der Firma mit Abteilungen und Hierarchie' where id = 1005636;
update public.antworten set text = 'Lageplan des Gebäudes mit Räumen, Etagen und Sitzplätzen' where id = 1005637;
update public.antworten set text = 'Umsätze pro Monat mit Erlösen, Kosten und Gewinn' where id = 1005638;
update public.antworten set text = 'Urlaubstage der Mitarbeiter und ihre Vertretungen' where id = 1005639;
-- 230090: Was ist eine Stelle in der Organisation?
update public.antworten set text = 'Kleinste organisatorische Einheit für eine Person' where id = 1005640;
update public.antworten set text = 'Fester Arbeitsplatz mit Schreibtisch und Computer' where id = 1005641;
update public.antworten set text = 'Gruppe mehrerer Personen unter einer gemeinsamen Leitung' where id = 1005642;
update public.antworten set text = 'Standort des Unternehmens, z. B. eine Filiale' where id = 1005643;
-- 230091: Was ist eine Abteilung?
update public.antworten set text = 'Mehrere Stellen mit ähnlichen Aufgaben unter einer Leitung' where id = 1005644;
update public.antworten set text = 'Einzelner Arbeitsplatz mit klar definierten Aufgaben und Rechten' where id = 1005645;
update public.antworten set text = 'Vorstand, der das Unternehmen leitet und nach außen vertritt' where id = 1005646;
update public.antworten set text = 'Kunde, der regelmäßig Leistungen vom Unternehmen bezieht' where id = 1005647;
-- 230092: Was bedeutet „Weisungsbefugnis“?
update public.antworten set text = 'Recht, anderen Mitarbeitern Anweisungen zu geben' where id = 1005648;
update public.antworten set text = 'Recht, den eigenen Urlaub jederzeit frei zu nehmen' where id = 1005649;
update public.antworten set text = 'Pflicht, regelmäßig Berichte zu schreiben' where id = 1005650;
update public.antworten set text = 'Erlaubnis, das Firmenauto privat zu nutzen' where id = 1005651;
-- 230093: Was versteht man unter „Führungsstil“?
update public.antworten set text = 'Art, wie ein Vorgesetzter führt und entscheidet' where id = 1005652;
update public.antworten set text = 'Kleidung, mit der ein Vorgesetzter im Betrieb auftritt' where id = 1005653;
update public.antworten set text = 'Größe des Büros als Zeichen der Stellung im Betrieb' where id = 1005654;
update public.antworten set text = 'Anzahl der Mitarbeiter, die ein Vorgesetzter leitet' where id = 1005655;
-- 230094: Was bedeutet Wirtschaftlichkeit?
update public.antworten set text = 'Verhältnis von Ertrag zu Aufwand, viel Nutzen für wenig Kosten' where id = 1005656;
update public.antworten set text = 'Möglichst viel Geld ausgeben, damit die Firma schnell wächst' where id = 1005657;
update public.antworten set text = 'Möglichst viele Mitarbeiter beschäftigen, damit alles schnell geht' where id = 1005658;
update public.antworten set text = 'Immer das teuerste Produkt kaufen, weil es am längsten hält' where id = 1005659;
-- 230095: Was ist eine Investition?
update public.antworten set text = 'Geldeinsatz für langfristigen Nutzen, z. B. neue Server' where id = 1005660;
update public.antworten set text = 'Laufende Zahlung der Monatsgehälter an die Mitarbeiter' where id = 1005661;
update public.antworten set text = 'Kauf von kurzfristig verbrauchtem Büromaterial' where id = 1005662;
update public.antworten set text = 'Monatliche Bezahlung der Stromrechnung als laufende Kosten' where id = 1005663;
-- 230096: Was bedeutet „Leasing“?
update public.antworten set text = 'Nutzung gegen Raten, Eigentum bleibt beim Leasinggeber' where id = 1005664;
update public.antworten set text = 'Ratenkauf, Eigentum geht mit der letzten Rate über' where id = 1005665;
update public.antworten set text = 'Bankkredit, der Gegenstand wird sofort Eigentum des Käufers' where id = 1005666;
update public.antworten set text = 'Verkauf gebrauchter Geräte aus dem Unternehmen' where id = 1005667;
-- 230097: Was ist ein Angebotsvergleich?
update public.antworten set text = 'Vergleich mehrerer Angebote nach Preis und Bedingungen' where id = 1005668;
update public.antworten set text = 'Vergleich zweier Mitarbeiter nach Leistung und Gehalt' where id = 1005669;
update public.antworten set text = 'Prüfung der eigenen Preise auf Kostendeckung und Gewinn' where id = 1005670;
update public.antworten set text = 'Qualitätstest eines Produkts vor der Auslieferung' where id = 1005671;
-- 230098: Was ist der Unterschied zwischen Kauf und Miete?
update public.antworten set text = 'Kauf macht zum Eigentümer, Miete erlaubt nur die Nutzung' where id = 1005672;
update public.antworten set text = 'Miete ist immer günstiger, weil man nur kleine Raten zahlt' where id = 1005673;
update public.antworten set text = 'Kein Unterschied, in beiden Fällen wird man Eigentümer' where id = 1005674;
update public.antworten set text = 'Beim Kauf zahlt man monatlich, bei der Miete einmalig' where id = 1005675;
-- 230099: Was ist Beschaffung im Unternehmen?
update public.antworten set text = 'Versorgung des Betriebs mit Waren und Leistungen' where id = 1005676;
update public.antworten set text = 'Verkauf der eigenen Produkte, z. B. im Onlineshop' where id = 1005677;
update public.antworten set text = 'Ausbildung neuer Mitarbeiter für ihre Aufgaben' where id = 1005678;
update public.antworten set text = 'Buchhaltung aller Einnahmen und Ausgaben auf Konten' where id = 1005679;
-- 230100: Was ist ein Lieferant?
update public.antworten set text = 'Unternehmen, das Waren oder Leistungen an andere liefert' where id = 1005680;
update public.antworten set text = 'Kunde, der Waren oder Leistungen von einem Betrieb bezieht' where id = 1005681;
update public.antworten set text = 'Mitarbeiter der Poststelle, der Pakete im Haus verteilt' where id = 1005682;
update public.antworten set text = 'Geschäftsführer, der die Einkaufsverträge unterschreibt' where id = 1005683;
-- 230101: Was ist ein Angebot im Geschäftsverkehr?
update public.antworten set text = 'Verbindliche Erklärung des Anbieters zu seinen Bedingungen' where id = 1005684;
update public.antworten set text = 'Unverbindliche Werbebroschüre eines Anbieters für seine Produkte' where id = 1005685;
update public.antworten set text = 'Mahnung des Anbieters wegen einer offenen Zahlung' where id = 1005686;
update public.antworten set text = 'Lieferschein des Anbieters über die übergebene Ware' where id = 1005687;
-- 230102: Was ist eine Bestellung?
update public.antworten set text = 'Aufforderung des Kunden an den Lieferanten zur Lieferung' where id = 1005688;
update public.antworten set text = 'Rechnung des Lieferanten an den Kunden nach der Lieferung' where id = 1005689;
update public.antworten set text = 'Unverbindlicher Preisvergleich mehrerer Lieferanten' where id = 1005690;
update public.antworten set text = 'Zahlungserinnerung des Lieferanten bei offener Rechnung' where id = 1005691;
-- 230103: Was bedeutet Kommunikation im beruflichen Zusammenhang?
update public.antworten set text = 'Austausch von Informationen, z. B. per Gespräch oder E-Mail' where id = 1005692;
update public.antworten set text = 'Nur das Telefonieren mit Kunden bei Aufträgen und Beschwerden' where id = 1005693;
update public.antworten set text = 'Versand von Werbung, z. B. per Newsletter oder Flyer' where id = 1005694;
update public.antworten set text = 'Schreiben von Programmcode für andere Entwickler' where id = 1005695;
-- 230104: Was ist ein Beleg in der Buchführung?
update public.antworten set text = 'Nachweis eines Geschäftsvorfalls, z. B. Rechnung oder Bon' where id = 1005696;
update public.antworten set text = 'Bankkonto, über das alle Zahlungen des Unternehmens laufen' where id = 1005697;
update public.antworten set text = 'Jahresabschluss des Unternehmens, z. B. Bilanz oder GuV' where id = 1005698;
update public.antworten set text = 'Liste aller Mitarbeiter mit ihren Gehältern, z. B. die Lohnliste' where id = 1005699;
-- 230105: Wie heißen die beiden Seiten eines Kontos in der doppelten Buchführung?
update public.antworten set text = 'Soll und Haben' where id = 1005700;
update public.antworten set text = 'Plus und Minus' where id = 1005701;
update public.antworten set text = 'Ertrag und Aufwand' where id = 1005702;
update public.antworten set text = 'Aktiv und Passiv' where id = 1005703;
-- 230106: Was ist eine Inventur?
update public.antworten set text = 'Bestandsaufnahme von Vermögen und Schulden zum Stichtag' where id = 1005704;
update public.antworten set text = 'Überweisung der Gehälter zu einem festen Termin im Monat' where id = 1005705;
update public.antworten set text = 'Verkauf alter Geräte, die nicht mehr gebraucht werden' where id = 1005706;
update public.antworten set text = 'Jährliche Steuererklärung des Unternehmens beim Finanzamt' where id = 1005707;
-- 230107: Was ist ein Geschäftsvorfall?
update public.antworten set text = 'Ereignis, das Vermögen oder Schulden ändert, z. B. Verkauf' where id = 1005708;
update public.antworten set text = 'Termin im Kalender des Chefs, z. B. eine wichtige Kundenverhandlung' where id = 1005709;
update public.antworten set text = 'Interne Besprechung ohne Kosten, z. B. ein Team-Meeting' where id = 1005710;
update public.antworten set text = 'Name eines Buchhaltungsprogramms zur Belegerfassung' where id = 1005711;
-- 230108: Wozu dient die Buchführung in erster Linie?
update public.antworten set text = 'Alle Geschäftsvorfälle lückenlos aufzuzeichnen' where id = 1005712;
update public.antworten set text = 'Werbung zu machen und neue Kunden zu gewinnen' where id = 1005713;
update public.antworten set text = 'Arbeitspläne und Schichten der Mitarbeiter zu planen' where id = 1005714;
update public.antworten set text = 'Software für automatische Rechnungen zu entwickeln' where id = 1005715;
-- 230109: Was zeigt eine Bilanz?
update public.antworten set text = 'Vermögen (Aktiva) und Kapital (Passiva) zum Stichtag' where id = 1005716;
update public.antworten set text = 'Gehälter und gesamte Personalkosten im Geschäftsjahr' where id = 1005717;
update public.antworten set text = 'Kundenliste mit allen offenen Aufträgen zum Stichtag' where id = 1005718;
update public.antworten set text = 'Umsatz eines Tages, aufgeteilt nach Produkten und Kunden' where id = 1005719;
-- 230110: Wofür steht die Abkürzung GuV?
update public.antworten set text = 'Gewinn- und Verlustrechnung' where id = 1005720;
update public.antworten set text = 'Geld- und Vermögensrechnung' where id = 1005721;
update public.antworten set text = 'Gesamtumsatz und Vorsteuer' where id = 1005722;
update public.antworten set text = 'Guthaben und Verbindlichkeit' where id = 1005723;
-- 230111: Auf welcher Seite der Bilanz steht das Vermögen, z. B. Maschinen und Bankguthabe
update public.antworten set text = 'Auf der Aktivseite (links)' where id = 1005724;
update public.antworten set text = 'Rechts auf der Passivseite' where id = 1005725;
update public.antworten set text = 'In der GuV, nicht in der Bilanz' where id = 1005726;
update public.antworten set text = 'Auf beiden Seiten zugleich' where id = 1005727;
-- 230112: Was bedeutet Eigenkapital?
update public.antworten set text = 'Von den Eigentümern eingebrachtes oder einbehaltenes Geld' where id = 1005728;
update public.antworten set text = 'Bankkredit, der mit Zinsen zurückgezahlt werden muss' where id = 1005729;
update public.antworten set text = 'Monatliches Gehalt des Geschäftsführers inklusive Bonuszahlung' where id = 1005730;
update public.antworten set text = 'Wert aller Computer und Maschinen des Unternehmens' where id = 1005731;
-- 230113: Was ist Fremdkapital?
update public.antworten set text = 'Geliehenes Geld, das zurückgezahlt werden muss, z. B. Kredit' where id = 1005732;
update public.antworten set text = 'Von den Eigentümern eingebrachtes Geld, z. B. Stammkapital' where id = 1005733;
update public.antworten set text = 'Einbehaltener Gewinn des Vorjahres, z. B. als Rücklage' where id = 1005734;
update public.antworten set text = 'Wert der Lagerbestände, z. B. eingekaufte Waren und Rohstoffe' where id = 1005735;
-- 230114: Was sind Fixkosten?
update public.antworten set text = 'Kosten unabhängig von der Menge, z. B. Miete' where id = 1005736;
update public.antworten set text = 'Kosten, die pro Einheit steigen, z. B. Material' where id = 1005737;
update public.antworten set text = 'Kosten nur einmal im Jahr, z. B. Weihnachtsfeier' where id = 1005738;
update public.antworten set text = 'Werbekosten je nach Kampagne, Kanal und Laufzeit' where id = 1005739;
-- 230115: Welche Kosten steigen, wenn ein Unternehmen mehr Stück produziert?
update public.antworten set text = 'Die variablen Kosten, z. B. Material und Verpackung' where id = 1005740;
update public.antworten set text = 'Die Fixkosten, z. B. Miete und Gehälter der Angestellten' where id = 1005741;
update public.antworten set text = 'Die Kosten für die Steuerberatung, z. B. Honorare' where id = 1005742;
update public.antworten set text = 'Keine, alle Kosten bleiben unabhängig von der Stückzahl' where id = 1005743;
-- 230116: Was bedeutet der Begriff Selbstkosten?
update public.antworten set text = 'Alle Kosten für Herstellung und Vertrieb eines Produkts' where id = 1005744;
update public.antworten set text = 'Nur die Materialkosten für die Herstellung eines Produkts' where id = 1005745;
update public.antworten set text = 'Kosten, die der Inhaber aus seinem Privatvermögen zahlt' where id = 1005746;
update public.antworten set text = 'Verkaufspreis eines Produkts inklusive Mehrwertsteuer' where id = 1005747;
-- 230117: Was ist der Gewinn?
update public.antworten set text = 'Erlöse abzüglich aller Kosten eines Unternehmens' where id = 1005748;
update public.antworten set text = 'Gesamter Jahresumsatz eines Unternehmens aus Verkäufen' where id = 1005749;
update public.antworten set text = 'Kontostand am Jahresende auf dem Firmenkonto' where id = 1005750;
update public.antworten set text = 'Summe aller Herstellungskosten der Produkte' where id = 1005751;
-- 230118: Was versteht man unter Umsatz (Erlös)?
update public.antworten set text = 'Summe aller Verkaufserlöse, also Menge mal Preis' where id = 1005752;
update public.antworten set text = 'Der Gewinn, der nach Abzug aller Kosten übrig bleibt' where id = 1005753;
update public.antworten set text = 'Kosten für Material, Personal und Miete zusammen' where id = 1005754;
update public.antworten set text = 'Von den Inhabern eingebrachtes Eigenkapital' where id = 1005755;
-- 230119: Was ist der Unterschied zwischen Netto- und Bruttopreis?
update public.antworten set text = 'Brutto enthält die Umsatzsteuer, netto nicht' where id = 1005756;
update public.antworten set text = 'Netto enthält die Umsatzsteuer, brutto nicht' where id = 1005757;
update public.antworten set text = 'Netto ist der Preis mit Rabatt, brutto ohne Rabatt' where id = 1005758;
update public.antworten set text = 'Brutto ist der Einkaufspreis, netto der Verkaufspreis' where id = 1005759;
-- 230120: Wie hoch ist der ermäßigte Umsatzsteuersatz in Deutschland, z. B. für Bücher und
update public.antworten set text = '7 %' where id = 1005760;
update public.antworten set text = '19 %' where id = 1005761;
update public.antworten set text = '10 %' where id = 1005762;
update public.antworten set text = '3 %' where id = 1005763;
-- 230121: Wer zahlt die Umsatzsteuer am Ende wirtschaftlich?
update public.antworten set text = 'Der Endverbraucher' where id = 1005764;
update public.antworten set text = 'Der Warenhersteller' where id = 1005765;
update public.antworten set text = 'Die Finanzbehörde' where id = 1005766;
update public.antworten set text = 'Die Bank des Kunden' where id = 1005767;
-- 230122: Welche Steuer wird direkt vom Gehalt eines Arbeitnehmers einbehalten?
update public.antworten set text = 'Die Lohnsteuer' where id = 1005768;
update public.antworten set text = 'Die Umsatzsteuer' where id = 1005769;
update public.antworten set text = 'Die Gewerbesteuer' where id = 1005770;
update public.antworten set text = 'Die Grundsteuer' where id = 1005771;
-- 230123: Was ist eine Rechnung?
update public.antworten set text = 'Zahlungsforderung des Verkäufers für eine Lieferung' where id = 1005772;
update public.antworten set text = 'Vertrag über die Lieferung einer Ware, z. B. Kaufvertrag' where id = 1005773;
update public.antworten set text = 'Quittung des Verkäufers über erhaltenes Bargeld' where id = 1005774;
update public.antworten set text = 'Angebot des Verkäufers mit seinen Bedingungen vor dem Kauf' where id = 1005775;
-- 230124: Was ist eine Investition?
update public.antworten set text = 'Geldausgabe für langfristigen Nutzen, z. B. ein Server' where id = 1005776;
update public.antworten set text = 'Monatliche Gehaltszahlung an die Mitarbeiter im laufenden Betrieb' where id = 1005777;
update public.antworten set text = 'Kauf von Büromaterial für den Verbrauch, z. B. Papier' where id = 1005778;
update public.antworten set text = 'Zahlung der Miete für dauerhaft genutzte Büroräume' where id = 1005779;
-- 230125: Wofür steht die Abkürzung TCO?
update public.antworten set text = 'Total Cost of Ownership, Gesamtkosten der Nutzungsdauer' where id = 1005780;
update public.antworten set text = 'Technical Cost Overview, Übersicht der Anschaffungskosten' where id = 1005781;
update public.antworten set text = 'Total Company Output, Gesamtleistung eines Unternehmens' where id = 1005782;
update public.antworten set text = 'Time Cost Optimization, Optimierung von Zeit und Kosten' where id = 1005783;
-- 230126: Was bedeutet Amortisation?
update public.antworten set text = 'Zeitpunkt, an dem eine Investition ihre Kosten eingespielt hat' where id = 1005784;
update public.antworten set text = 'Jährliche Wertminderung eines Geräts als Abschreibung' where id = 1005785;
update public.antworten set text = 'Kündigung eines Wartungsvertrags bei zu hohen laufenden Kosten' where id = 1005786;
update public.antworten set text = 'Rabatt des Händlers auf den Listenpreis bei großen Investitionen' where id = 1005787;
-- 230127: Ein Server für 3.000 € wird 3 Jahre genutzt. Wie nennt man die 1.000 € Wertverlu
update public.antworten set text = 'Abschreibung' where id = 1005788;
update public.antworten set text = 'Mengenrabatt' where id = 1005789;
update public.antworten set text = 'Amortisation' where id = 1005790;
update public.antworten set text = 'Skontoabzug' where id = 1005791;
-- 230128: Was ist ein Stundensatz?
update public.antworten set text = 'Preis, der für eine Arbeitsstunde berechnet wird' where id = 1005792;
update public.antworten set text = 'Anzahl der Stunden, die pro Woche gearbeitet wird' where id = 1005793;
update public.antworten set text = 'Zinssatz, der für einen Kredit berechnet wird' where id = 1005794;
update public.antworten set text = 'Wartezeit auf die Antwort zu einem Support-Ticket' where id = 1005795;
-- 230129: Was ist ein Vertrag?
update public.antworten set text = 'Vereinbarung mit gegenseitigen Verpflichtungen' where id = 1005796;
update public.antworten set text = 'Gesetz des Bundestags, das für alle verbindlich gilt' where id = 1005797;
update public.antworten set text = 'Einseitiges Versprechen ohne Gegenleistung' where id = 1005798;
update public.antworten set text = 'Rechnung, mit der jemand Geld für eine Lieferung verlangt' where id = 1005799;
-- 230130: Wofür steht die Abkürzung BGB?
update public.antworten set text = 'Bürgerliches Gesetzbuch' where id = 1005800;
update public.antworten set text = 'Bundesgerichtsbarkeit' where id = 1005801;
update public.antworten set text = 'Bundesgesetz für Beschäftigte' where id = 1005802;
update public.antworten set text = 'Bürgerliche Grundordnung' where id = 1005803;
-- 230131: Ab welchem Alter ist man in Deutschland volljährig und damit voll geschäftsfähig
update public.antworten set text = '18 Jahre' where id = 1005804;
update public.antworten set text = '16 Jahre' where id = 1005805;
update public.antworten set text = '21 Jahre' where id = 1005806;
update public.antworten set text = '14 Jahre' where id = 1005807;
-- 230132: Wie nennt man die Äußerung „Ich nehme das Angebot an“ im Vertragsrecht?
update public.antworten set text = 'Eine Willenserklärung (Annahme)' where id = 1005808;
update public.antworten set text = 'Eine Mahnung (Zahlungserinnerung)' where id = 1005809;
update public.antworten set text = 'Eine Kündigung (Vertragsende)' where id = 1005810;
update public.antworten set text = 'Eine Rechnung (Zahlungsbeleg)' where id = 1005811;
-- 230133: Was ist der Unterschied zwischen einer natürlichen und einer juristischen Person
update public.antworten set text = 'Natürliche Person ist ein Mensch, juristische z. B. GmbH' where id = 1005812;
update public.antworten set text = 'Natürliche Person ist ein Kind, juristische ein Volljähriger' where id = 1005813;
update public.antworten set text = 'Juristische Person ist ein Anwalt, natürliche ein Laie' where id = 1005814;
update public.antworten set text = 'Kein Unterschied, beide Begriffe meinen denselben Menschen' where id = 1005815;
-- 230134: Wie lange dauert die gesetzliche Probezeit in einem Arbeitsverhältnis höchstens?
update public.antworten set text = '6 Monate' where id = 1005816;
update public.antworten set text = '3 Monate' where id = 1005817;
update public.antworten set text = '12 Monate' where id = 1005818;
update public.antworten set text = '1 Monat' where id = 1005819;
-- 230135: Was ist ein Tarifvertrag?
update public.antworten set text = 'Vereinbarung von Gewerkschaft und Arbeitgebern zu Löhnen' where id = 1005820;
update public.antworten set text = 'Vertrag zweier Unternehmen über Lieferungen, Preise und Zahlung' where id = 1005821;
update public.antworten set text = 'Arbeitsvertrag eines Mitarbeiters über Gehalt und Urlaub' where id = 1005822;
update public.antworten set text = 'Mietvertrag über Büroräume, Nebenkosten und Laufzeit' where id = 1005823;
-- 230136: Wie viele Tage Urlaub stehen einem Vollzeit-Arbeitnehmer bei einer 5-Tage-Woche 
update public.antworten set text = '20 Arbeitstage' where id = 1005824;
update public.antworten set text = '30 Arbeitstage' where id = 1005825;
update public.antworten set text = '10 Arbeitstage' where id = 1005826;
update public.antworten set text = '15 Arbeitstage' where id = 1005827;
-- 230137: Was regelt der Arbeitsvertrag?
update public.antworten set text = 'Rechte und Pflichten von Arbeitgeber und Arbeitnehmer' where id = 1005828;
update public.antworten set text = 'Preise der verkauften Produkte, z. B. Rabatte und Zahlungsziele' where id = 1005829;
update public.antworten set text = 'Regeln für Kunden im Laden, z. B. Öffnungszeiten und Umtausch' where id = 1005830;
update public.antworten set text = 'Ausbildungsplan der IHK, z. B. Lerninhalte und Prüfungstermine' where id = 1005831;
-- 230138: Was ist ein Betriebsrat?
update public.antworten set text = 'Gewählte Vertretung der Arbeitnehmer im Betrieb' where id = 1005832;
update public.antworten set text = 'Geschäftsleitung, die den Betrieb führt und vertritt' where id = 1005833;
update public.antworten set text = 'Externe Beratungsfirma, die Betriebe berät und unterstützt' where id = 1005834;
update public.antworten set text = 'Behörde zur Überwachung von Betrieben, z. B. Gewerbeamt' where id = 1005835;
-- 230139: Was ist der Unterschied zwischen Brutto- und Nettogehalt?
update public.antworten set text = 'Brutto vor Abzügen, netto der ausgezahlte Betrag' where id = 1005836;
update public.antworten set text = 'Netto vor Abzügen, brutto der ausgezahlte Betrag' where id = 1005837;
update public.antworten set text = 'Brutto mit Urlaubsgeld, netto ohne Urlaubsgeld' where id = 1005838;
update public.antworten set text = 'Kein Unterschied, beide Beträge sind gleich hoch' where id = 1005839;
-- 230140: Wer zahlt die Beiträge zur gesetzlichen Kranken-, Renten- und Arbeitslosenversic
update public.antworten set text = 'Arbeitnehmer und Arbeitgeber je etwa zur Hälfte' where id = 1005840;
update public.antworten set text = 'Nur der Arbeitnehmer aus seinem Bruttogehalt' where id = 1005841;
update public.antworten set text = 'Nur der Arbeitgeber zusätzlich zum Gehalt' where id = 1005842;
update public.antworten set text = 'Der Staat aus den allgemeinen Steuereinnahmen des Bundes' where id = 1005843;
-- 230141: Wofür ist die gesetzliche Krankenversicherung zuständig?
update public.antworten set text = 'Kosten für Arztbesuche, Medikamente und Krankenhaus' where id = 1005844;
update public.antworten set text = 'Rente im Alter und Absicherung bei Erwerbsminderung' where id = 1005845;
update public.antworten set text = 'Arbeitslosengeld und Vermittlung neuer Arbeitsstellen' where id = 1005846;
update public.antworten set text = 'Unfälle auf dem Arbeitsweg und Berufskrankheiten' where id = 1005847;
-- 230142: Was ist eine Gehaltsabrechnung?
update public.antworten set text = 'Dokument mit Brutto, Abzügen und Netto des Gehalts' where id = 1005848;
update public.antworten set text = 'Arbeitsvertrag mit Gehalt, Arbeitszeit und Urlaub' where id = 1005849;
update public.antworten set text = 'Steuererklärung zur Rückholung zu viel gezahlter Steuern' where id = 1005850;
update public.antworten set text = 'Kontoauszug der Bank mit dem monatlichen Gehaltseingang' where id = 1005851;
-- 230143: Welche Versicherung zahlt, wenn jemand nach Verlust der Arbeit vorübergehend kei
update public.antworten set text = 'Arbeitslosenversicherung' where id = 1005852;
update public.antworten set text = 'Gesetzliche Krankenkasse' where id = 1005853;
update public.antworten set text = 'Rentenversicherung' where id = 1005854;
update public.antworten set text = 'Haftpflichtversicherung' where id = 1005855;
-- 230144: Wofür steht die Abkürzung GmbH?
update public.antworten set text = 'Gesellschaft mit beschränkter Haftung' where id = 1005856;
update public.antworten set text = 'Gemeinschaft mit beschränkter Handlung' where id = 1005857;
update public.antworten set text = 'Gesellschaft mit besonderer Haftung' where id = 1005858;
update public.antworten set text = 'Großes mittelständisches Betriebshaus' where id = 1005859;
-- 230145: Wofür steht die Abkürzung AG?
update public.antworten set text = 'Aktiengesellschaft' where id = 1005860;
update public.antworten set text = 'Arbeitsgemeinschaft' where id = 1005861;
update public.antworten set text = 'Allgemeine Gesellschaft' where id = 1005862;
update public.antworten set text = 'Angestellten-Gruppe' where id = 1005863;
-- 230146: Wie haftet ein Einzelunternehmer für die Schulden seines Unternehmens?
update public.antworten set text = 'Unbeschränkt, auch mit seinem Privatvermögen' where id = 1005864;
update public.antworten set text = 'Nur mit dem Geschäftsvermögen der Firma, nicht privat' where id = 1005865;
update public.antworten set text = 'Gar nicht, allein das Unternehmen haftet' where id = 1005866;
update public.antworten set text = 'Nur bis 25.000 € seines Privatvermögens' where id = 1005867;
-- 230147: Welche zwei Pflichten hat der Käufer bei einem Kaufvertrag?
update public.antworten set text = 'Kaufpreis zahlen und Ware abnehmen' where id = 1005868;
update public.antworten set text = 'Ware rechtzeitig liefern und Garantie gewähren' where id = 1005869;
update public.antworten set text = 'Ware bewerben und gegen Schäden versichern' where id = 1005870;
update public.antworten set text = 'Rechnung schreiben und an den Verkäufer senden' where id = 1005871;
-- 230148: Was ist das Handelsregister?
update public.antworten set text = 'Öffentliches Verzeichnis von Kaufleuten und Unternehmen' where id = 1005872;
update public.antworten set text = 'Liste aller Produkte einer Firma mit Preisen und Lagerbeständen' where id = 1005873;
update public.antworten set text = 'Kassenbuch eines Händlers mit Einnahmen und Ausgaben' where id = 1005874;
update public.antworten set text = 'Verzeichnis der Mitarbeiter mit Gehalt und Position' where id = 1005875;
-- 230149: Wofür steht die Abkürzung DSGVO?
update public.antworten set text = 'Datenschutz-Grundverordnung' where id = 1005876;
update public.antworten set text = 'Datensicherheitsverordnung' where id = 1005877;
update public.antworten set text = 'Deutsche Softwareverordnung' where id = 1005878;
update public.antworten set text = 'Digitale Grundversorgung' where id = 1005879;
-- 230150: Was sind personenbezogene Daten?
update public.antworten set text = 'Alle Infos zu einer bestimmbaren Person, z. B. Name oder E-Mail' where id = 1005880;
update public.antworten set text = 'Nur Passwörter und Zugangsdaten für die Anmeldung, z. B. PIN' where id = 1005881;
update public.antworten set text = 'Daten über Firmen und Geschäftszahlen, z. B. Umsatz oder Gewinn' where id = 1005882;
update public.antworten set text = 'Anonyme Statistiken ohne Personenbezug, z. B. Besucherzahlen' where id = 1005883;
-- 230151: Wer ist in einem Unternehmen Ansprechpartner für Datenschutzfragen?
update public.antworten set text = 'Der Datenschutzbeauftragte' where id = 1005884;
update public.antworten set text = 'Der Betriebsratsvorsitzende' where id = 1005885;
update public.antworten set text = 'Der externe Steuerberater' where id = 1005886;
update public.antworten set text = 'Die Personalabteilung' where id = 1005887;
-- 230152: Was regelt das Urheberrecht?
update public.antworten set text = 'Wem ein geistiges Werk gehört, z. B. Software oder Musik' where id = 1005888;
update public.antworten set text = 'Schutz personenbezogener Daten, z. B. Name oder Adresse' where id = 1005889;
update public.antworten set text = 'Haftung bei Unfällen, z. B. im Betrieb oder im Homeoffice' where id = 1005890;
update public.antworten set text = 'Preise für Software, z. B. Lizenzen, Updates oder Support' where id = 1005891;
-- 230153: Was ist eine Software-Lizenz?
update public.antworten set text = 'Erlaubnis des Rechteinhabers zur Nutzung der Software' where id = 1005892;
update public.antworten set text = 'Quellcode, den der Käufer nach dem Kauf frei verändern darf' where id = 1005893;
update public.antworten set text = 'Zertifikat über die fachliche Qualifikation des Programmierers' where id = 1005894;
update public.antworten set text = 'Herstellergarantie für fehlerfreie Software und Fehlerbehebung' where id = 1005895;
-- 230154: Wie nennt man das Programm, das eine Datenbank verwaltet, z. B. MySQL oder Postg
update public.antworten set text = 'Datenbankmanagementsystem (DBMS)' where id = 1005896;
update public.antworten set text = 'Betriebssystem (z. B. Windows)' where id = 1005897;
update public.antworten set text = 'Webbrowser (z. B. Firefox oder Chrome)' where id = 1005898;
update public.antworten set text = 'Compiler (z. B. GCC oder javac)' where id = 1005899;
-- 230155: Woraus besteht eine Tabelle in einer relationalen Datenbank?
update public.antworten set text = 'Aus Zeilen (Datensätzen) und Spalten (Attributen)' where id = 1005900;
update public.antworten set text = 'Aus Dateien (Datensätzen) und Ordnern (Kategorien)' where id = 1005901;
update public.antworten set text = 'Aus Bildern (Objekten) und Texten (Beschreibungen)' where id = 1005902;
update public.antworten set text = 'Aus Servern (Speicher) und Clients (Abfragen)' where id = 1005903;
-- 230156: Wofür steht die Abkürzung SQL?
update public.antworten set text = 'Structured Query Language, Abfragesprache für Datenbanken' where id = 1005904;
update public.antworten set text = 'Simple Question Language, Sprache für einfache Datenbankfragen' where id = 1005905;
update public.antworten set text = 'System Query Log, Protokoll aller Abfragen an ein System' where id = 1005906;
update public.antworten set text = 'Secure Quick Login, Verfahren zur sicheren Datenbankanmeldung' where id = 1005907;
-- 230157: Was ist ein Fremdschlüssel?
update public.antworten set text = 'Spalte, die auf den Primärschlüssel einer anderen Tabelle zeigt' where id = 1005908;
update public.antworten set text = 'Passwort, mit dem sich ein externer Nutzer an der Datenbank anmeldet' where id = 1005909;
update public.antworten set text = 'Schlüssel, der aus einem anderen Datenbanksystem importiert wurde' where id = 1005910;
update public.antworten set text = 'Erste Spalte jeder Tabelle, die jede Zeile eindeutig kennzeichnet' where id = 1005911;
-- 230158: Welche der folgenden Datenbanken ist ein bekanntes relationales Datenbanksystem?
update public.antworten set text = 'MySQL' where id = 1005912;
update public.antworten set text = 'Excel' where id = 1005913;
update public.antworten set text = 'Apache' where id = 1005914;
update public.antworten set text = 'Linux' where id = 1005915;
-- 230159: Was macht ein JOIN in SQL?
update public.antworten set text = 'Verknüpft Zeilen mehrerer Tabellen über eine gemeinsame Spalte' where id = 1005916;
update public.antworten set text = 'Löscht doppelte Zeilen automatisch aus dem Abfrageergebnis' where id = 1005917;
update public.antworten set text = 'Sortiert das Ergebnis nach einer oder mehreren Spalten' where id = 1005918;
update public.antworten set text = 'Erstellt eine neue Tabelle und speichert das Ergebnis dauerhaft' where id = 1005919;
-- 230160: Welche SQL-Funktion berechnet die Summe einer Spalte?
update public.antworten set text = 'SUM(spalte)' where id = 1005920;
update public.antworten set text = 'ADD(spalte)' where id = 1005921;
update public.antworten set text = 'TOTAL(spalte)' where id = 1005922;
update public.antworten set text = 'PLUS(spalte)' where id = 1005923;
-- 230161: Welche SQL-Funktion berechnet den Durchschnitt einer Spalte?
update public.antworten set text = 'AVG(spalte)' where id = 1005924;
update public.antworten set text = 'MEAN(spalte)' where id = 1005925;
update public.antworten set text = 'MID(spalte)' where id = 1005926;
update public.antworten set text = 'MEDIAN(spalte)' where id = 1005927;
-- 230162: Welche SQL-Klausel fasst Zeilen mit gleichem Wert zu Gruppen zusammen, z. B. all
update public.antworten set text = 'GROUP BY kunde' where id = 1005928;
update public.antworten set text = 'ORDER BY kunde' where id = 1005929;
update public.antworten set text = 'WHERE kunde' where id = 1005930;
update public.antworten set text = 'JOIN kunden' where id = 1005931;
-- 230163: Was liefert die SQL-Funktion MAX(preis)?
update public.antworten set text = 'Den höchsten Wert in der Spalte preis' where id = 1005932;
update public.antworten set text = 'Die Anzahl der Zeilen in der Tabelle' where id = 1005933;
update public.antworten set text = 'Die Summe aller Werte der Spalte preis' where id = 1005934;
update public.antworten set text = 'Den zuletzt eingefügten Wert in preis' where id = 1005935;
-- 230164: Was ist das Ziel eines Datenbankentwurfs?
update public.antworten set text = 'Daten ohne Widersprüche und Doppelungen in Tabellen aufteilen' where id = 1005936;
update public.antworten set text = 'Alle Daten in eine einzige Tabelle ohne Verknüpfungen packen' where id = 1005937;
update public.antworten set text = 'Die Datenbank möglichst groß für alle künftigen Daten anlegen' where id = 1005938;
update public.antworten set text = 'Jede Spalte in einer eigenen Tabelle getrennt speichern' where id = 1005939;
-- 230165: Was bedeutet Redundanz in einer Datenbank?
update public.antworten set text = 'Dieselbe Information ist mehrfach gespeichert' where id = 1005940;
update public.antworten set text = 'Die Datenbank enthält gar keine Datensätze mehr' where id = 1005941;
update public.antworten set text = 'Eine Tabelle hat keinen Primärschlüssel' where id = 1005942;
update public.antworten set text = 'Die Daten sind verschlüsselt gespeichert' where id = 1005943;
-- 230166: Wofür steht die Abkürzung ERM bzw. ER-Modell?
update public.antworten set text = 'Entity-Relationship-Modell, zeigt Objekte und Beziehungen' where id = 1005944;
update public.antworten set text = 'Error-Report-Modell, zeigt Programmfehler und deren Ursachen' where id = 1005945;
update public.antworten set text = 'Einfaches Relationales Modell, eine Tabelle mit allen Daten' where id = 1005946;
update public.antworten set text = 'Extern-Remote-Modell, zeigt entfernte Server und Zugriffe' where id = 1005947;
-- 230167: Was ist eine Entität im Datenbankentwurf?
update public.antworten set text = 'Ein reales Objekt mit gespeicherten Daten, z. B. Kunde' where id = 1005948;
update public.antworten set text = 'Eine SQL-Abfrage über mehrere Tabellen, z. B. ein JOIN' where id = 1005949;
update public.antworten set text = 'Der Name der Datenbank mit allen Tabellen, z. B. shopdb' where id = 1005950;
update public.antworten set text = 'Ein Passwort für die Anmeldung an der Datenbank' where id = 1005951;
-- 230168: Was beschreibt eine 1:n-Beziehung?
update public.antworten set text = 'Ein Datensatz gehört zu vielen der anderen Tabelle' where id = 1005952;
update public.antworten set text = 'Jeder Datensatz gehört zu genau einem der anderen Tabelle' where id = 1005953;
update public.antworten set text = 'Viele Datensätze gehören zu vielen der anderen Tabelle' where id = 1005954;
update public.antworten set text = 'Eine Tabelle hat nur eine Spalte, z. B. Kundennummern' where id = 1005955;
-- 230169: Was ist eine Transaktion in einer Datenbank?
update public.antworten set text = 'Operationen, die ganz oder gar nicht ausgeführt werden' where id = 1005956;
update public.antworten set text = 'Eine einzelne SELECT-Abfrage, die Daten nur liest' where id = 1005957;
update public.antworten set text = 'Die regelmäßige Sicherung der Datenbank auf einen Datenträger' where id = 1005958;
update public.antworten set text = 'Der Wechsel zu einer anderen Datenbank mit allen Tabellen' where id = 1005959;
-- 230170: Mit welchem SQL-Befehl wird eine Transaktion erfolgreich abgeschlossen?
update public.antworten set text = 'COMMIT' where id = 1005960;
update public.antworten set text = 'ROLLBACK' where id = 1005961;
update public.antworten set text = 'SAVE ALL' where id = 1005962;
update public.antworten set text = 'FINISH' where id = 1005963;
-- 230171: Mit welchem SQL-Befehl macht man die Änderungen einer Transaktion rückgängig?
update public.antworten set text = 'ROLLBACK' where id = 1005964;
update public.antworten set text = 'COMMIT' where id = 1005965;
update public.antworten set text = 'UNDO ALL' where id = 1005966;
update public.antworten set text = 'DELETE' where id = 1005967;
-- 230172: Wofür ist ein Index in einer Datenbank gut?
update public.antworten set text = 'Er beschleunigt die Suche nach Werten in einer Spalte' where id = 1005968;
update public.antworten set text = 'Er verschlüsselt die Werte in einer Spalte der Tabelle' where id = 1005969;
update public.antworten set text = 'Er löscht doppelte Zeilen automatisch aus einer Tabelle' where id = 1005970;
update public.antworten set text = 'Er sichert die Datenbank regelmäßig als Backup auf Band' where id = 1005971;
-- 230173: Wofür steht die Abkürzung ACID bei Datenbanken?
update public.antworten set text = 'Atomicity, Consistency, Isolation, Durability bei Transaktionen' where id = 1005972;
update public.antworten set text = 'Access, Control, Insert, Delete als Grundoperationen für Tabellen' where id = 1005973;
update public.antworten set text = 'Automatic Cache Index Data als Bereiche des Zwischenspeichers' where id = 1005974;
update public.antworten set text = 'Advanced Column Integrity Design als Regeln für Tabellenspalten' where id = 1005975;
-- 230174: Welche drei Grundrechte gibt es für Dateien unter Linux?
update public.antworten set text = 'Lesen (r), Schreiben (w) und Ausführen (x)' where id = 1005976;
update public.antworten set text = 'Öffnen (o), Speichern (s) und Drucken (p)' where id = 1005977;
update public.antworten set text = 'Kopieren (c), Verschieben (m) und Löschen (d)' where id = 1005978;
update public.antworten set text = 'Anzeigen (v), Bearbeiten (e) und Teilen (s)' where id = 1005979;
-- 230175: Mit welchem Befehl ändert man unter Linux die Zugriffsrechte einer Datei?
update public.antworten set text = 'chmod' where id = 1005980;
update public.antworten set text = 'chown' where id = 1005981;
update public.antworten set text = 'rights' where id = 1005982;
update public.antworten set text = 'chperm' where id = 1005983;
-- 230176: Mit welchem Befehl kopiert man unter Linux eine Datei?
update public.antworten set text = 'cp a.txt b.txt' where id = 1005984;
update public.antworten set text = 'mv a.txt b.txt' where id = 1005985;
update public.antworten set text = 'copy a.txt b.txt' where id = 1005986;
update public.antworten set text = 'cat a.txt b.txt' where id = 1005987;
-- 230177: Was ist unter Linux das Root-Verzeichnis?
update public.antworten set text = 'Das oberste Verzeichnis des Dateisystems, kurz /' where id = 1005988;
update public.antworten set text = 'Das Home-Verzeichnis des Nutzers unter /home' where id = 1005989;
update public.antworten set text = 'Der Papierkorb für gelöschte Dateien bis zum Leeren' where id = 1005990;
update public.antworten set text = 'Das Verzeichnis für installierte Programme unter /usr' where id = 1005991;
-- 230178: Mit welchem Befehl erstellt man unter Linux ein neues Verzeichnis?
update public.antworten set text = 'mkdir' where id = 1005992;
update public.antworten set text = 'newdir' where id = 1005993;
update public.antworten set text = 'touch' where id = 1005994;
update public.antworten set text = 'makedir' where id = 1005995;
-- 230179: Was ist ein Prozess?
update public.antworten set text = 'Ein Programm, das gerade ausgeführt wird' where id = 1005996;
update public.antworten set text = 'Eine Datei, die auf der Festplatte liegt' where id = 1005997;
update public.antworten set text = 'Ein Benutzerkonto, das gerade angemeldet ist' where id = 1005998;
update public.antworten set text = 'Ein Netzwerkkabel, das Daten überträgt' where id = 1005999;
-- 230180: Wofür steht die Abkürzung PID?
update public.antworten set text = 'Process ID, die eindeutige Nummer eines laufenden Prozesses' where id = 1006000;
update public.antworten set text = 'Program Install Directory, der Ordner eines Programms' where id = 1006001;
update public.antworten set text = 'Personal Identification Data, die Personendaten eines Nutzers' where id = 1006002;
update public.antworten set text = 'Primary Interface Device, das Hauptgerät für Eingaben am PC' where id = 1006003;
-- 230181: Mit welchem Befehl beendet man unter Linux einen Prozess über seine PID?
update public.antworten set text = 'kill' where id = 1006004;
update public.antworten set text = 'stop' where id = 1006005;
update public.antworten set text = 'end' where id = 1006006;
update public.antworten set text = 'exit' where id = 1006007;
-- 230182: Was ist ein Dienst (Service oder Daemon) unter Linux?
update public.antworten set text = 'Ein dauerhaft im Hintergrund laufendes Programm, z. B. Webserver' where id = 1006008;
update public.antworten set text = 'Ein Programm mit grafischer Oberfläche, z. B. ein Texteditor' where id = 1006009;
update public.antworten set text = 'Ein Benutzer mit besonderen Rechten, z. B. der Administrator root' where id = 1006010;
update public.antworten set text = 'Eine beim Start gelesene Konfigurationsdatei, z. B. in /etc' where id = 1006011;
-- 230183: Mit welchem Befehl zeigt man unter Linux eine Liste der laufenden Prozesse an?
update public.antworten set text = 'ps aux' where id = 1006012;
update public.antworten set text = 'ls -la' where id = 1006013;
update public.antworten set text = 'dir -la' where id = 1006014;
update public.antworten set text = 'proc -a' where id = 1006015;
-- 230184: Wie heißt der Benutzer mit uneingeschränkten Rechten unter Linux?
update public.antworten set text = 'Benutzer root' where id = 1006016;
update public.antworten set text = 'Benutzer admin' where id = 1006017;
update public.antworten set text = 'Benutzer superuser' where id = 1006018;
update public.antworten set text = 'Benutzer master' where id = 1006019;
-- 230185: Wozu dient der Befehl sudo?
update public.antworten set text = 'Er führt einen einzelnen Befehl mit Administratorrechten aus' where id = 1006020;
update public.antworten set text = 'Er wechselt in ein anderes Verzeichnis des Dateisystems' where id = 1006021;
update public.antworten set text = 'Er zeigt die aktuelle Systemzeit und das Datum des Systems an' where id = 1006022;
update public.antworten set text = 'Er startet das System mit Administratorrechten komplett neu' where id = 1006023;
-- 230186: Wofür wird SSH verwendet?
update public.antworten set text = 'Für verschlüsselten Fernzugriff auf die Kommandozeile eines Rechners' where id = 1006024;
update public.antworten set text = 'Für die verschlüsselte Anzeige von Webseiten im Browser' where id = 1006025;
update public.antworten set text = 'Für den verschlüsselten Versand von E-Mails an einen anderen Rechner' where id = 1006026;
update public.antworten set text = 'Für das Drucken im Netzwerk über den Druckerserver eines Rechners' where id = 1006027;
-- 230187: Was ist ein Shell-Skript?
update public.antworten set text = 'Textdatei mit Befehlen, die die Shell nacheinander ausführt' where id = 1006028;
update public.antworten set text = 'Grafisches Programm, das Befehle per Klick an die Shell schickt' where id = 1006029;
update public.antworten set text = 'Konfigurationsdatei des Kernels mit den Startoptionen' where id = 1006030;
update public.antworten set text = 'Passwort-Manager, der Zugangsdaten für die Shell speichert' where id = 1006031;
-- 230188: Mit welchem Befehl ändert man unter Linux das eigene Passwort?
update public.antworten set text = 'passwd' where id = 1006032;
update public.antworten set text = 'password' where id = 1006033;
update public.antworten set text = 'chpass' where id = 1006034;
update public.antworten set text = 'setpass' where id = 1006035;
-- 230189: Wofür steht die Abkürzung SSD?
update public.antworten set text = 'Solid State Drive, ein Speicherlaufwerk ohne bewegliche Teile' where id = 1006036;
update public.antworten set text = 'Super Speed Disk, eine besonders schnelle Festplatte mit Cache' where id = 1006037;
update public.antworten set text = 'Secure Storage Device, ein verschlüsselter Speicher für Daten' where id = 1006038;
update public.antworten set text = 'System Software Drive, ein Laufwerk nur für das Betriebssystem' where id = 1006039;
-- 230190: Wofür steht die Abkürzung HDD?
update public.antworten set text = 'Hard Disk Drive, eine Festplatte mit rotierenden Magnetscheiben' where id = 1006040;
update public.antworten set text = 'High Density Data, ein Speichermedium mit sehr hoher Datendichte' where id = 1006041;
update public.antworten set text = 'Hardware Disk Device, ein Controller, der Festplatten anspricht' where id = 1006042;
update public.antworten set text = 'Home Data Drive, ein Netzlaufwerk für private Daten im Heimnetz' where id = 1006043;
-- 230191: Was bedeutet es, einen Datenträger zu formatieren?
update public.antworten set text = 'Ihn mit einem Dateisystem zum Speichern vorbereiten' where id = 1006044;
update public.antworten set text = 'Ihn physisch reinigen, damit Daten wieder lesbar werden' where id = 1006045;
update public.antworten set text = 'Seine Größe verdoppeln, damit mehr Daten darauf passen' where id = 1006046;
update public.antworten set text = 'Ihn mit einem Passwort gegen unbefugtes Lesen schützen' where id = 1006047;
-- 230192: Welches Dateisystem verwendet Windows standardmäßig für die Systemfestplatte?
update public.antworten set text = 'NTFS' where id = 1006048;
update public.antworten set text = 'ext4' where id = 1006049;
update public.antworten set text = 'FAT16' where id = 1006050;
update public.antworten set text = 'HFS+' where id = 1006051;
-- 230193: Welcher RAID-Level verteilt Daten nur auf mehrere Platten für mehr Geschwindigke
update public.antworten set text = 'RAID 0' where id = 1006052;
update public.antworten set text = 'RAID 1' where id = 1006053;
update public.antworten set text = 'RAID 5' where id = 1006054;
update public.antworten set text = 'RAID 10' where id = 1006055;
-- 230194: Wofür steht die Abkürzung RAM?
update public.antworten set text = 'Random Access Memory, der Arbeitsspeicher des Computers' where id = 1006056;
update public.antworten set text = 'Read And Modify, der Lese- und Schreibmodus einer Datei' where id = 1006057;
update public.antworten set text = 'Rapid Application Module, ein schnelles Programmmodul' where id = 1006058;
update public.antworten set text = 'Remote Access Memory, der Speicher eines entfernten Servers' where id = 1006059;
-- 230195: Was passiert mit den Daten im Arbeitsspeicher, wenn der Computer ausgeschaltet w
update public.antworten set text = 'Sie gehen verloren, weil RAM flüchtig ist' where id = 1006060;
update public.antworten set text = 'Sie bleiben dauerhaft im RAM erhalten' where id = 1006061;
update public.antworten set text = 'Sie werden automatisch auf die Festplatte kopiert' where id = 1006062;
update public.antworten set text = 'Sie werden automatisch verschlüsselt abgelegt' where id = 1006063;
-- 230196: Welche Einheit ist größer: 1 Gigabyte oder 1 Megabyte?
update public.antworten set text = '1 Gigabyte, denn 1 GB sind 1.024 MB' where id = 1006064;
update public.antworten set text = '1 Megabyte, denn 1 MB sind 1.024 GB' where id = 1006065;
update public.antworten set text = 'Beide sind gleich groß, nur anders geschrieben' where id = 1006066;
update public.antworten set text = 'Das hängt vom Betriebssystem des Computers ab' where id = 1006067;
-- 230197: Was ist der Cache eines Prozessors?
update public.antworten set text = 'Ein sehr schneller, kleiner Zwischenspeicher im Prozessor' where id = 1006068;
update public.antworten set text = 'Der Lüfter, der den Prozessor vor Überhitzung schützt' where id = 1006069;
update public.antworten set text = 'Der Speicher auf der Festplatte, der als Auslagerung dient' where id = 1006070;
update public.antworten set text = 'Ein Programm, das temporäre Dateien vom System entfernt' where id = 1006071;
-- 230198: Was bedeutet es, wenn ein Prozessor 4 Kerne hat?
update public.antworten set text = 'Er kann vier Aufgaben gleichzeitig bearbeiten' where id = 1006072;
update public.antworten set text = 'Er hat vier Lüfter zur Kühlung, einen je Kern' where id = 1006073;
update public.antworten set text = 'Er ist viermal so schnell wie ein Einkernprozessor' where id = 1006074;
update public.antworten set text = 'Er braucht vier Netzteile für den Betrieb' where id = 1006075;
-- 230199: Was ist eine virtuelle Maschine (VM)?
update public.antworten set text = 'Ein per Software nachgebildeter Computer auf einem echten Rechner' where id = 1006076;
update public.antworten set text = 'Ein Computer ohne Festplatte, der sein System aus dem Netz lädt' where id = 1006077;
update public.antworten set text = 'Ein Computer, der über das Internet von außen gesteuert wird' where id = 1006078;
update public.antworten set text = 'Ein schneller Server, der mehrere Anwendungen gleichzeitig ausführt' where id = 1006079;
-- 230200: Wie heißt die Software, die virtuelle Maschinen erstellt und verwaltet?
update public.antworten set text = 'Hypervisor' where id = 1006080;
update public.antworten set text = 'Compiler' where id = 1006081;
update public.antworten set text = 'Firewall' where id = 1006082;
update public.antworten set text = 'Webbrowser' where id = 1006083;
-- 230201: Was bedeutet Cloud Computing?
update public.antworten set text = 'Nutzung von Rechenleistung oder Software über das Internet' where id = 1006084;
update public.antworten set text = 'Speichern von Daten auf einem USB-Stick für den Transport' where id = 1006085;
update public.antworten set text = 'Berechnung von Wetterdaten mit verteilten Rechnern in Rechenzentren' where id = 1006086;
update public.antworten set text = 'Ein Netzwerk ohne Kabel, in dem Geräte per Funk verbunden sind' where id = 1006087;
-- 230202: Wofür steht die Abkürzung SaaS?
update public.antworten set text = 'Software as a Service, Software aus dem Netz, z. B. Microsoft 365' where id = 1006088;
update public.antworten set text = 'Storage as a Service, gemieteter Speicher im Netz, z. B. Dropbox' where id = 1006089;
update public.antworten set text = 'System and Application Security, ein Sicherheitskonzept für Server' where id = 1006090;
update public.antworten set text = 'Server as a Standard, ein Standard für den Aufbau von Serversystemen' where id = 1006091;
-- 230203: Was ist ein Container, z. B. bei Docker?
update public.antworten set text = 'Leichte Verpackung einer Anwendung mit allen Abhängigkeiten' where id = 1006092;
update public.antworten set text = 'Gehäuse im Rechenzentrum, das mehrere Server platzsparend aufnimmt' where id = 1006093;
update public.antworten set text = 'Backup-Ordner, in dem alle Dateien einer Anwendung gesichert werden' where id = 1006094;
update public.antworten set text = 'Netzwerkgerät, das Anwendungen auf verschiedene Server verteilt' where id = 1006095;
-- 230204: Wo sollte ein Backup aufbewahrt werden?
update public.antworten set text = 'Getrennt vom Original, z. B. extern oder in der Cloud' where id = 1006096;
update public.antworten set text = 'Auf derselben Festplatte wie das Original, schnell erreichbar' where id = 1006097;
update public.antworten set text = 'Im Papierkorb, damit gelöschte Daten wiederherstellbar sind' where id = 1006098;
update public.antworten set text = 'Im Arbeitsspeicher, weil er Daten am schnellsten liefert' where id = 1006099;
-- 230205: Wofür steht die Abkürzung BIOS bzw. UEFI?
update public.antworten set text = 'Firmware, die beim Start die Hardware prüft und das System lädt' where id = 1006100;
update public.antworten set text = 'Bildbearbeitungsprogramm, das beim Systemstart im Hintergrund lädt' where id = 1006101;
update public.antworten set text = 'Virenscanner, der beim Einschalten die Festplatte auf Viren prüft' where id = 1006102;
update public.antworten set text = 'Netzwerkprotokoll, das beim Einschalten die IP-Adresse festlegt' where id = 1006103;
-- 230206: Was macht ein Virenscanner?
update public.antworten set text = 'Er sucht nach Schadsoftware auf dem Computer und blockiert sie' where id = 1006104;
update public.antworten set text = 'Er beschleunigt den Internetzugang durch Filtern des Datenverkehrs' where id = 1006105;
update public.antworten set text = 'Er sichert Daten regelmäßig auf externen Festplatten als Backup' where id = 1006106;
update public.antworten set text = 'Er kühlt den Prozessor und schützt ihn so vor Überhitzung' where id = 1006107;
-- 230207: Warum sollte man Software-Updates zeitnah installieren?
update public.antworten set text = 'Weil sie oft Sicherheitslücken schließen, die Angreifer nutzen' where id = 1006108;
update public.antworten set text = 'Weil der Computer sonst nach einiger Zeit nicht mehr startet' where id = 1006109;
update public.antworten set text = 'Weil Updates die Festplatte vergrößern und Speicherplatz schaffen' where id = 1006110;
update public.antworten set text = 'Weil man sonst die Garantie des Herstellers für das Gerät verliert' where id = 1006111;
-- 230208: Was ist der erste sinnvolle Schritt, wenn ein Computer gar nicht mehr angeht?
update public.antworten set text = 'Prüfen, ob Stromkabel und Netzteil angeschlossen und an sind' where id = 1006112;
update public.antworten set text = 'Das Betriebssystem neu installieren wegen möglicher Systemfehler' where id = 1006113;
update public.antworten set text = 'Die Festplatte austauschen, weil sie das Starten verhindern könnte' where id = 1006114;
update public.antworten set text = 'Den Arbeitsspeicher verdoppeln für genug Ressourcen beim Start' where id = 1006115;
-- 230209: Was ist eine Schleife in der Programmierung?
update public.antworten set text = 'Eine Anweisung, die einen Codeblock mehrfach wiederholt' where id = 1006116;
update public.antworten set text = 'Ein Fehler, der das Programm zum Absturz bringt' where id = 1006117;
update public.antworten set text = 'Eine Variable, die mehrere Werte gleichzeitig speichert' where id = 1006118;
update public.antworten set text = 'Ein Kommentar, der den Code für andere Entwickler erklärt' where id = 1006119;
-- 230210: Was ist ein Array?
update public.antworten set text = 'Werte gleichen Typs unter einem Namen, angesprochen per Index' where id = 1006120;
update public.antworten set text = 'Funktion ohne Rückgabewert, die mehrere Werte nacheinander verarbeitet' where id = 1006121;
update public.antworten set text = 'Textdatei mit Code, in der Werte gleichen Typs zeilenweise stehen' where id = 1006122;
update public.antworten set text = 'Vergleichsoperator, der prüft, ob mehrere Werte identisch sind' where id = 1006123;
-- 230211: Welchen Index hat das erste Element eines Arrays in Sprachen wie Java, C oder Py
update public.antworten set text = 'Index 0' where id = 1006124;
update public.antworten set text = 'Index 1' where id = 1006125;
update public.antworten set text = 'Index -1' where id = 1006126;
update public.antworten set text = 'Index n-1' where id = 1006127;
-- 230212: Welche Werte kann eine Variable vom Typ boolean annehmen?
update public.antworten set text = 'true oder false' where id = 1006128;
update public.antworten set text = 'Werte 0 bis 255' where id = 1006129;
update public.antworten set text = 'Beliebiger Text' where id = 1006130;
update public.antworten set text = 'Ganze Zahlen' where id = 1006131;
-- 230213: Welcher Vergleichsoperator prüft in den meisten Programmiersprachen, ob zwei Wer
update public.antworten set text = 'Operator ==' where id = 1006132;
update public.antworten set text = 'Operator =' where id = 1006133;
update public.antworten set text = 'Operator =>' where id = 1006134;
update public.antworten set text = 'Operator !=' where id = 1006135;
-- 230214: Was ist eine Klasse in der objektorientierten Programmierung?
update public.antworten set text = 'Ein Bauplan mit den Eigenschaften und Methoden der Objekte' where id = 1006136;
update public.antworten set text = 'Eine Schleife, die alle im Programm erzeugten Objekte zählt' where id = 1006137;
update public.antworten set text = 'Eine Konfigurationsdatei mit den Einstellungen des Programms' where id = 1006138;
update public.antworten set text = 'Ein Laufzeitfehler, wenn ein Objekt nicht gefunden wird' where id = 1006139;
-- 230215: Was ist ein Objekt in der OOP?
update public.antworten set text = 'Eine konkrete Instanz einer Klasse, z. B. ein bestimmtes Auto' where id = 1006140;
update public.antworten set text = 'Der Bauplan für Instanzen, z. B. die Klasse Auto selbst' where id = 1006141;
update public.antworten set text = 'Eine Methode ohne Parameter, z. B. eine Methode zum Starten' where id = 1006142;
update public.antworten set text = 'Ein Kommentar im Quellcode, z. B. eine Beschreibung der Klasse' where id = 1006143;
-- 230216: Was ist eine Methode?
update public.antworten set text = 'Eine Funktion einer Klasse, die beschreibt, was Objekte tun können' where id = 1006144;
update public.antworten set text = 'Eine Variable in einer Klasse, die den Zustand eines Objekts speichert' where id = 1006145;
update public.antworten set text = 'Ein Datentyp für Text, der in einer Klasse als Attribut verwendet wird' where id = 1006146;
update public.antworten set text = 'Ein Vergleich zweier Objekte, der prüft, ob sie gleichen Inhalt haben' where id = 1006147;
-- 230217: Was bedeutet Vererbung in der OOP?
update public.antworten set text = 'Eine Klasse übernimmt Eigenschaften und Methoden einer anderen' where id = 1006148;
update public.antworten set text = 'Ein Objekt wird beim Programmende gelöscht und gibt Speicher frei' where id = 1006149;
update public.antworten set text = 'Eine Variable wird an eine Methode übergeben und dort kopiert' where id = 1006150;
update public.antworten set text = 'Zwei Klassen haben denselben Namen, aber unterschiedliche Methoden' where id = 1006151;
-- 230218: Was ist ein Attribut einer Klasse?
update public.antworten set text = 'Eine als Variable gespeicherte Eigenschaft, z. B. die Farbe' where id = 1006152;
update public.antworten set text = 'Eine Funktion der Klasse für ein Verhalten, z. B. das Fahren' where id = 1006153;
update public.antworten set text = 'Der Name der Quellcodedatei der Klasse, z. B. Auto.java' where id = 1006154;
update public.antworten set text = 'Ein Kompilierfehler, z. B. weil eine Variable nicht deklariert ist' where id = 1006155;
-- 230219: Was ist Git?
update public.antworten set text = 'Versionskontrollsystem für nachvollziehbare Codeänderungen' where id = 1006156;
update public.antworten set text = 'Programm, das Java-Quellcode in Bytecode für die JVM übersetzt' where id = 1006157;
update public.antworten set text = 'Texteditor, mit dem Quellcode geschrieben und formatiert wird' where id = 1006158;
update public.antworten set text = 'Betriebssystem für Server, auf dem Webanwendungen laufen' where id = 1006159;
-- 230220: Was ist ein Commit in Git?
update public.antworten set text = 'Ein gespeicherter Stand der Änderungen mit einer Beschreibung' where id = 1006160;
update public.antworten set text = 'Das Löschen eines Branches aus dem Repository, lokal und remote' where id = 1006161;
update public.antworten set text = 'Der Download eines fremden Projekts auf den eigenen Rechner' where id = 1006162;
update public.antworten set text = 'Ein Fehler beim Zusammenführen zweier Branches im Projekt' where id = 1006163;
-- 230221: Was ist ein Repository?
update public.antworten set text = 'Der Speicherort eines Projekts mit seiner Versionsgeschichte' where id = 1006164;
update public.antworten set text = 'Eine einzelne Quellcodedatei mit allen Funktionen des Projekts' where id = 1006165;
update public.antworten set text = 'Ein Programm zum Testen des Quellcodes vor jeder neuen Version' where id = 1006166;
update public.antworten set text = 'Die Fehlerliste eines Projekts mit allen bekannten Bugs' where id = 1006167;
-- 230222: Was ist ein Unit-Test?
update public.antworten set text = 'Automatischer Test einer kleinen Codeeinheit, z. B. Funktion' where id = 1006168;
update public.antworten set text = 'Test der gesamten Anwendung durch echte Nutzer vor der Freigabe' where id = 1006169;
update public.antworten set text = 'Messung der Ladezeit einer Webseite bis zur vollständigen Anzeige' where id = 1006170;
update public.antworten set text = 'Test des Netzwerks, ob alle Server und Dienste erreichbar sind' where id = 1006171;
-- 230223: Was ist ein Bug?
update public.antworten set text = 'Ein Programmfehler, der zu falschem Verhalten oder Absturz führt' where id = 1006172;
update public.antworten set text = 'Ein Kommentar im Quellcode, der eine fehlerhafte Stelle markiert' where id = 1006173;
update public.antworten set text = 'Eine Funktion ohne Rückgabewert, die deshalb kein Ergebnis liefert' where id = 1006174;
update public.antworten set text = 'Ein Werkzeug, das Quellcode in ein ausführbares Programm übersetzt' where id = 1006175;
-- 230224: Was ist ein Algorithmus?
update public.antworten set text = 'Eine eindeutige Schritt-für-Schritt-Anleitung zur Problemlösung' where id = 1006176;
update public.antworten set text = 'Eine Programmiersprache, mit der Probleme gelöst werden können' where id = 1006177;
update public.antworten set text = 'Ein Fehler im Programm, der zu falschen Ergebnissen oder Absturz führt' where id = 1006178;
update public.antworten set text = 'Eine Datenbanktabelle, in der fertige Lösungen gespeichert werden' where id = 1006179;
-- 230225: Was macht ein Sortieralgorithmus?
update public.antworten set text = 'Er bringt eine Liste in eine Reihenfolge, z. B. aufsteigend' where id = 1006180;
update public.antworten set text = 'Er löscht doppelte Elemente aus einer Liste, z. B. doppelte Namen' where id = 1006181;
update public.antworten set text = 'Er verschlüsselt eine Liste, z. B. mit einem AES-Schlüssel' where id = 1006182;
update public.antworten set text = 'Er zählt die Elemente einer Liste und gibt die Anzahl zurück' where id = 1006183;
-- 230226: Was bedeutet Rekursion?
update public.antworten set text = 'Eine Funktion ruft sich selbst auf, bis eine Abbruchbedingung greift' where id = 1006184;
update public.antworten set text = 'Eine Schleife zählt rückwärts, bis der Startwert wieder erreicht ist' where id = 1006185;
update public.antworten set text = 'Eine Variable wird gelöscht, sobald sie nicht mehr benötigt wird' where id = 1006186;
update public.antworten set text = 'Ein Kommentar wiederholt sich an mehreren Stellen im Quellcode' where id = 1006187;
-- 230227: Was bedeutet Secure Coding?
update public.antworten set text = 'Programmieren so, dass Sicherheitslücken vermieden werden' where id = 1006188;
update public.antworten set text = 'Den Quellcode mit einem Passwort vor unbefugtem Lesen schützen' where id = 1006189;
update public.antworten set text = 'Nur mit verschlüsselten Dateien arbeiten gegen Abfangen' where id = 1006190;
update public.antworten set text = 'Code ohne Kommentare schreiben, damit Angreifer ihn kaum verstehen' where id = 1006191;
-- 230228: Warum sollte man Benutzereingaben in einem Programm immer prüfen?
update public.antworten set text = 'Weil falsche oder böswillige Eingaben Abstürze oder Lücken auslösen' where id = 1006192;
update public.antworten set text = 'Weil der Compiler das Programm sonst nicht übersetzt und Fehler meldet' where id = 1006193;
update public.antworten set text = 'Weil ungeprüfte Eingaben die Verarbeitung im Programm verlangsamen' where id = 1006194;
update public.antworten set text = 'Weil Nutzer sonst keine Rückmeldung zum Erfolg ihrer Eingabe bekommen' where id = 1006195;
-- 230229: Was bedeutet Authentifizierung?
update public.antworten set text = 'Nachweis der eigenen Identität, z. B. per Passwort' where id = 1006196;
update public.antworten set text = 'Verschlüsselung von Dateien für Berechtigte, z. B. per AES' where id = 1006197;
update public.antworten set text = 'Sicherung von Daten auf externer Platte gegen Verlust' where id = 1006198;
update public.antworten set text = 'Löschen ungenutzter Benutzerkonten, z. B. nach 90 Tagen' where id = 1006199;
-- 230230: Wofür steht die Abkürzung 2FA?
update public.antworten set text = 'Zwei-Faktor-Authentifizierung, Anmeldung mit zwei Nachweisen' where id = 1006200;
update public.antworten set text = 'Zwei-Firewall-Architektur, Schutz durch zwei Firewalls in Reihe' where id = 1006201;
update public.antworten set text = 'Fast Access Authentication, schnelle Anmeldung ohne Passworteingabe' where id = 1006202;
update public.antworten set text = 'Zweifache Datenarchivierung, Speicherung jeder Datei an zwei Orten' where id = 1006203;
-- 230231: Was bedeutet Verschlüsselung?
update public.antworten set text = 'Daten werden so verändert, dass nur der passende Schlüssel sie öffnet' where id = 1006204;
update public.antworten set text = 'Daten werden komprimiert, damit sie weniger Speicherplatz brauchen' where id = 1006205;
update public.antworten set text = 'Daten werden so überschrieben, dass niemand sie wiederherstellen kann' where id = 1006206;
update public.antworten set text = 'Daten werden auf einen anderen Server kopiert für den Ausfallschutz' where id = 1006207;
-- 230232: Was ist ein Hash-Wert?
update public.antworten set text = 'Feste Zeichenfolge aus beliebigen Daten, nicht zurückrechenbar' where id = 1006208;
update public.antworten set text = 'Verschlüsseltes Passwort, mit dem Schlüssel wieder entschlüsselbar' where id = 1006209;
update public.antworten set text = 'Sicherheitskopie einer Datei, bei Datenverlust wiederherstellbar' where id = 1006210;
update public.antworten set text = 'Name eines Benutzerkontos, der mit dem Passwort zur Anmeldung dient' where id = 1006211;
-- 230233: Wofür sorgt ein Passwort-Manager?
update public.antworten set text = 'Er speichert je Dienst ein eigenes starkes Passwort verschlüsselt' where id = 1006212;
update public.antworten set text = 'Er ersetzt alle Passwörter durch einen Fingerabdruck als Login' where id = 1006213;
update public.antworten set text = 'Er sendet Passwörter per E-Mail an den Administrator zur Verwahrung' where id = 1006214;
update public.antworten set text = 'Er macht Passwörter für alle Mitarbeiter sichtbar gegen Vergessen' where id = 1006215;
-- 230234: Was ist ein Sicherheitsvorfall (Security Incident)?
update public.antworten set text = 'Ereignis, das IT-Systeme oder Daten gefährdet, z. B. Virenbefall' where id = 1006216;
update public.antworten set text = 'Geplantes Update, das Sicherheitslücken schließt, z. B. ein Patch' where id = 1006217;
update public.antworten set text = 'Stromausfall zu Hause, bei dem der PC ausgeht, z. B. bei Gewitter' where id = 1006218;
update public.antworten set text = 'Neues Benutzerkonto vom Administrator, z. B. für einen neuen Azubi' where id = 1006219;
-- 230235: Was sollte ein Mitarbeiter als Erstes tun, wenn er einen Sicherheitsvorfall beme
update public.antworten set text = 'Den Vorfall sofort der IT oder dem Sicherheitsbeauftragten melden' where id = 1006220;
update public.antworten set text = 'Den Computer selbst neu installieren, um die Malware zu entfernen' where id = 1006221;
update public.antworten set text = 'Abwarten, ob es von selbst verschwindet, ohne andere zu beunruhigen' where id = 1006222;
update public.antworten set text = 'Den Vorfall in sozialen Medien posten, um andere Nutzer zu warnen' where id = 1006223;
-- 230236: Was ist eine Logdatei?
update public.antworten set text = 'Datei, in der ein System Ereignisse mit Zeitstempel protokolliert' where id = 1006224;
update public.antworten set text = 'Sicherungskopie der Datenbank, die regelmäßig automatisch entsteht' where id = 1006225;
update public.antworten set text = 'Passwortspeicher, in dem Zugangsdaten verschlüsselt abgelegt werden' where id = 1006226;
update public.antworten set text = 'Konfigurationsdatei der Firewall, in der die Regeln festgelegt sind' where id = 1006227;
-- 230237: Was ist Schadsoftware (Malware)?
update public.antworten set text = 'Programme, die absichtlich Schaden anrichten, z. B. Viren' where id = 1006228;
update public.antworten set text = 'Fehlerhafte, aber harmlose Software, die abstürzt oder falsch rechnet' where id = 1006229;
update public.antworten set text = 'Software mit abgelaufener Lizenz, die nicht mehr legal nutzbar ist' where id = 1006230;
update public.antworten set text = 'Programme, die zu viel Speicher brauchen und den Rechner bremsen' where id = 1006231;
-- 230238: Warum sollte jeder Mitarbeiter ein eigenes Benutzerkonto haben?
update public.antworten set text = 'Damit klar ist, wer was tat, und Rechte einzeln vergeben werden' where id = 1006232;
update public.antworten set text = 'Weil Computer langsamer werden, wenn mehrere ein Konto teilen' where id = 1006233;
update public.antworten set text = 'Weil geteilte Konten mehr kosten, da pro Nutzer abgerechnet wird' where id = 1006234;
update public.antworten set text = 'Weil das Betriebssystem ein Konto nur einmal gleichzeitig anmeldet' where id = 1006235;
-- 230239: Was bedeutet SQL-Injection?
update public.antworten set text = 'Angriff, der über ein Eingabefeld eigene SQL-Befehle einschleust' where id = 1006236;
update public.antworten set text = 'Einspielen eines Backups, das alte Datensätze über aktuelle schreibt' where id = 1006237;
update public.antworten set text = 'Fehler beim Anlegen einer Tabelle mit Spalten falschen Datentyps' where id = 1006238;
update public.antworten set text = 'Verschlüsseln einer Datenbank mit einem geheimen Schlüssel' where id = 1006239;
-- 230240: Was ist ein Penetrationstest?
update public.antworten set text = 'Beauftragter, kontrollierter Angriff auf ein System zur Lückensuche' where id = 1006240;
update public.antworten set text = 'Test der Internetgeschwindigkeit, um Engpässe in der Leitung zu finden' where id = 1006241;
update public.antworten set text = 'Prüfung der Passwortstärke aller Mitarbeiter durch die IT-Abteilung' where id = 1006242;
update public.antworten set text = 'Belastungstest, bei dem Server mit Anfragen überlastet werden' where id = 1006243;
-- 230241: Was ist ein Sicherheitspatch?
update public.antworten set text = 'Ein Update, das eine bekannte Sicherheitslücke schließt' where id = 1006244;
update public.antworten set text = 'Ein Programm, das sichere Passwörter erzeugt und verwaltet' where id = 1006245;
update public.antworten set text = 'Ein Aufkleber auf dem Server mit Hinweis auf die Sicherheitsstufe' where id = 1006246;
update public.antworten set text = 'Eine Sicherungskopie der Festplatte, die vor Angriffen schützt' where id = 1006247;
-- 230242: Was ist ein Salt bei der Passwortspeicherung?
update public.antworten set text = 'Zufällige Zeichenfolge, die vor dem Hashen ans Passwort angehängt wird' where id = 1006248;
update public.antworten set text = 'Zweites Passwort, das nur der Admin kennt und beim Hashen nutzt' where id = 1006249;
update public.antworten set text = 'Verschlüsselung der Datenbank, in der alle Passwörter gespeichert sind' where id = 1006250;
update public.antworten set text = 'Passwort nur aus Zahlen, das deshalb schneller gehasht werden kann' where id = 1006251;
-- 230243: Was ist eine Sicherheitslücke (Schwachstelle) in Software?
update public.antworten set text = 'Fehler, den Angreifer für unerlaubten Zugriff ausnutzen können' where id = 1006252;
update public.antworten set text = 'Unfertige Funktion, die beim Kunden zu Abstürzen führen kann' where id = 1006253;
update public.antworten set text = 'Rechtschreibfehler in der Oberfläche, der Nutzer verunsichert' where id = 1006254;
update public.antworten set text = 'Zu langsame Ladezeit, durch die Nutzer die Anwendung verlassen' where id = 1006255;
-- 230244: Wofür steht die Abkürzung HTML?
update public.antworten set text = 'Hypertext Markup Language, Struktur und Inhalt von Webseiten' where id = 1006256;
update public.antworten set text = 'High Tech Modern Language, Sprache für moderne Web-Apps' where id = 1006257;
update public.antworten set text = 'Hyper Transfer Markup Link, Format für Links zwischen Seiten' where id = 1006258;
update public.antworten set text = 'Home Tool Management Language, Sprache für Webserver-Konfiguration' where id = 1006259;
-- 230245: Wofür wird CSS auf einer Webseite verwendet?
update public.antworten set text = 'Für die Gestaltung, also Farben, Schriften, Abstände und Layout' where id = 1006260;
update public.antworten set text = 'Für die Speicherung von Daten in einer Datenbank auf dem Server' where id = 1006261;
update public.antworten set text = 'Für die Programmierung von Berechnungen und Logik im Browser' where id = 1006262;
update public.antworten set text = 'Für die Übertragung von E-Mails zwischen Webseite und Nutzer' where id = 1006263;
-- 230246: Welches HTML-Tag erzeugt einen Link zu einer anderen Seite?
update public.antworten set text = 'Das Tag <a>' where id = 1006264;
update public.antworten set text = 'Das Tag <link>' where id = 1006265;
update public.antworten set text = 'Das Tag <url>' where id = 1006266;
update public.antworten set text = 'Das Tag <href>' where id = 1006267;
-- 230247: Wofür steht die Abkürzung HTTP?
update public.antworten set text = 'Hypertext Transfer Protocol, Datenaustausch von Browser und Webserver' where id = 1006268;
update public.antworten set text = 'Home Text Transfer Program, Programm zur Textübertragung nach Hause' where id = 1006269;
update public.antworten set text = 'High Throughput Transmission Port, Port für schnelle Datenübertragung' where id = 1006270;
update public.antworten set text = 'Hyperlink Tracking Protocol, Protokoll zur Nachverfolgung von Klicks' where id = 1006271;
-- 230248: Was bedeutet der HTTP-Statuscode 404?
update public.antworten set text = 'Angeforderte Seite wurde nicht gefunden' where id = 1006272;
update public.antworten set text = 'Anfrage wurde erfolgreich verarbeitet' where id = 1006273;
update public.antworten set text = 'Server ist überlastet oder gestört' where id = 1006274;
update public.antworten set text = 'Nutzer ist nicht angemeldet oder gesperrt' where id = 1006275;
-- 230249: Wofür wird JavaScript auf einer Webseite eingesetzt?
update public.antworten set text = 'Seite interaktiv machen, z. B. auf Klicks reagieren' where id = 1006276;
update public.antworten set text = 'Struktur der Seite festlegen, z. B. Überschriften und Absätze' where id = 1006277;
update public.antworten set text = 'Schriftarten, Farben und Abstände der Seite definieren' where id = 1006278;
update public.antworten set text = 'Seite auf dem Server speichern und an Browser ausliefern' where id = 1006279;
-- 230250: Wofür steht die Abkürzung DOM?
update public.antworten set text = 'Document Object Model, Baumstruktur der HTML-Seite im Browser' where id = 1006280;
update public.antworten set text = 'Data Output Method, Verfahren zur Datenausgabe des Servers' where id = 1006281;
update public.antworten set text = 'Dynamic Online Module, Baustein zum Nachladen von Inhalten' where id = 1006282;
update public.antworten set text = 'Document Order Manager, Dienst zum Sortieren der HTML-Elemente' where id = 1006283;
-- 230251: Mit welchem Schlüsselwort deklariert man in modernem JavaScript eine Variable, d
update public.antworten set text = 'Schlüsselwort let' where id = 1006284;
update public.antworten set text = 'Schlüsselwort const' where id = 1006285;
update public.antworten set text = 'Schlüsselwort int' where id = 1006286;
update public.antworten set text = 'Schlüsselwort define' where id = 1006287;
-- 230252: Mit welcher Funktion gibt man in JavaScript eine Meldung in der Browser-Konsole 
update public.antworten set text = 'Die Meldung als Argument an console.log() übergeben' where id = 1006288;
update public.antworten set text = 'Die Meldung als Argument an print() übergeben' where id = 1006289;
update public.antworten set text = 'Die Meldung als Argument an echo() übergeben' where id = 1006290;
update public.antworten set text = 'Die Meldung als Argument an System.out.println() übergeben' where id = 1006291;
-- 230253: Was ist ein Event in JavaScript?
update public.antworten set text = 'Ereignis wie ein Klick, auf das ein Skript reagieren kann' where id = 1006292;
update public.antworten set text = 'Fehler beim Laden der Seite, den die Konsole anzeigt' where id = 1006293;
update public.antworten set text = 'Variable, die Datum und Uhrzeit eines Termins speichert' where id = 1006294;
update public.antworten set text = 'Kommentar im Code, der das Verhalten bei einem Klick beschreibt' where id = 1006295;
-- 230254: Was ist das Backend einer Webanwendung?
update public.antworten set text = 'Serverseitiger Teil, der Daten verarbeitet und speichert' where id = 1006296;
update public.antworten set text = 'Oberfläche, die der Nutzer im Browser sieht und bedient' where id = 1006297;
update public.antworten set text = 'Design der Webseite mit Farben, Schriften und Layout' where id = 1006298;
update public.antworten set text = 'Domain, unter der die Webseite im Internet erreichbar ist' where id = 1006299;
-- 230255: Wofür steht die Abkürzung API?
update public.antworten set text = 'Application Programming Interface, Schnittstelle für Programme' where id = 1006300;
update public.antworten set text = 'Advanced Program Installer, Werkzeug zur automatischen Installation' where id = 1006301;
update public.antworten set text = 'Automatic Page Index, Verzeichnis für Suchmaschinen' where id = 1006302;
update public.antworten set text = 'Application Password Interface, Schnittstelle zur Passwortprüfung' where id = 1006303;
-- 230256: Wofür steht die Abkürzung JSON?
update public.antworten set text = 'JavaScript Object Notation, Textformat für strukturierte Daten' where id = 1006304;
update public.antworten set text = 'Java Standard Object Network, Netzwerkprotokoll für Java-Objekte' where id = 1006305;
update public.antworten set text = 'Joint Server Output Node, Serverknoten für die Datenausgabe' where id = 1006306;
update public.antworten set text = 'JavaScript Online Navigation, Bibliothek für Seitennavigation' where id = 1006307;
-- 230257: Welche HTTP-Methode wird verwendet, um Daten von einem Server abzurufen?
update public.antworten set text = 'HTTP-Methode GET' where id = 1006308;
update public.antworten set text = 'HTTP-Methode POST' where id = 1006309;
update public.antworten set text = 'HTTP-Methode SEND' where id = 1006310;
update public.antworten set text = 'HTTP-Methode FETCH' where id = 1006311;
-- 230258: Welche HTTP-Methode wird typischerweise verwendet, um neue Daten an den Server z
update public.antworten set text = 'HTTP-Methode POST' where id = 1006312;
update public.antworten set text = 'HTTP-Methode GET' where id = 1006313;
update public.antworten set text = 'HTTP-Methode READ' where id = 1006314;
update public.antworten set text = 'HTTP-Methode OPEN' where id = 1006315;
-- 230259: Was bedeutet Deployment bei einer Webanwendung?
update public.antworten set text = 'Anwendung auf einem Server für die Nutzer bereitstellen' where id = 1006316;
update public.antworten set text = 'Quellcode in Git ablegen, damit alle Entwickler zugreifen' where id = 1006317;
update public.antworten set text = 'Anwendung im Browser testen, bevor sie freigegeben wird' where id = 1006318;
update public.antworten set text = 'Datenbank sichern, damit bei Ausfall keine Daten verloren gehen' where id = 1006319;
-- 230260: Was ist ein Webserver?
update public.antworten set text = 'Programm, das Webseiten auf Anfrage an Browser ausliefert' where id = 1006320;
update public.antworten set text = 'Programm, mit dem Webseiten gestaltet und bearbeitet werden' where id = 1006321;
update public.antworten set text = 'Browser des Nutzers, der Webseiten anfordert und darstellt' where id = 1006322;
update public.antworten set text = 'Kabel, das den PC des Nutzers mit dem Internet verbindet' where id = 1006323;
-- 230261: Was ist eine Domain?
update public.antworten set text = 'Lesbarer Name einer Webseite wie lernarena.app' where id = 1006324;
update public.antworten set text = 'IP-Adresse des Webservers, z. B. 192.168.1.1' where id = 1006325;
update public.antworten set text = 'Passwort für den Zugang zum Webserver per FTP' where id = 1006326;
update public.antworten set text = 'Ordner mit allen HTML-Dateien der Seite auf dem Server' where id = 1006327;
-- 230262: Wofür steht die Abkürzung CI in CI/CD?
update public.antworten set text = 'Continuous Integration, Code laufend zusammenführen und testen' where id = 1006328;
update public.antworten set text = 'Computer Installation, automatisches Einrichten neuer Rechner' where id = 1006329;
update public.antworten set text = 'Code Inspection, regelmäßige manuelle Durchsicht des Quellcodes' where id = 1006330;
update public.antworten set text = 'Central Interface, zentrale Schnittstelle zwischen allen Systemen' where id = 1006331;
-- 230263: Was ist ein Hosting-Anbieter?
update public.antworten set text = 'Anbieter, der Server und Speicherplatz für Webseiten vermietet' where id = 1006332;
update public.antworten set text = 'Programm zum Bearbeiten und Hochladen von HTML-Seiten auf den Server' where id = 1006333;
update public.antworten set text = 'Firma, die Domains verkauft und im Register einträgt' where id = 1006334;
update public.antworten set text = 'Hersteller des Browsers, mit dem Nutzer Webseiten aufrufen' where id = 1006335;
-- 230264: Woran erkennt man im Browser, dass eine Webseite verschlüsselt übertragen wird?
update public.antworten set text = 'Am Schloss-Symbol und an https:// in der Adresszeile' where id = 1006336;
update public.antworten set text = 'An grünem Seitenhintergrund und einem Haken oben' where id = 1006337;
update public.antworten set text = 'Daran, dass die Seite deutlich schneller lädt als andere' where id = 1006338;
update public.antworten set text = 'An der Endung .de am Ende der Adresse in der Adresszeile' where id = 1006339;
-- 230265: Was ist ein Cookie?
update public.antworten set text = 'Kleine Textdatei, die der Browser für eine Webseite speichert' where id = 1006340;
update public.antworten set text = 'Virus, der über Webseiten und Werbebanner verbreitet wird' where id = 1006341;
update public.antworten set text = 'Bild, das der Browser für schnelleres Laden zwischenspeichert' where id = 1006342;
update public.antworten set text = 'Browser-Erweiterung zum Blockieren von Werbung' where id = 1006343;
-- 230266: Warum sollte eine Webseite möglichst schnell laden?
update public.antworten set text = 'Nutzer springen ab und Suchmaschinen bevorzugen schnelle Seiten' where id = 1006344;
update public.antworten set text = 'Der Server stürzt sonst ab und die Seite ist nicht erreichbar' where id = 1006345;
update public.antworten set text = 'Langsame Seiten verbrauchen mehr Strom und erhöhen die Hosting-Kosten' where id = 1006346;
update public.antworten set text = 'Der Browser zeigt sonst eine Fehlermeldung an und bricht ab' where id = 1006347;
-- 230267: Was ist ein Cache im Zusammenhang mit Webseiten?
update public.antworten set text = 'Zwischenspeicher für bereits geladene Inhalte' where id = 1006348;
update public.antworten set text = 'Passwortspeicher im Browser für Zugangsdaten' where id = 1006349;
update public.antworten set text = 'Liste blockierter Seiten, die der Browser nicht lädt' where id = 1006350;
update public.antworten set text = 'Verlauf besuchter Seiten mit Adresse und Uhrzeit' where id = 1006351;
-- 230268: Was bedeutet es, wenn eine Webseite „responsive“ ist?
update public.antworten set text = 'Sie passt ihr Layout automatisch an die Bildschirmgröße an' where id = 1006352;
update public.antworten set text = 'Sie antwortet automatisch auf E-Mails und Anfragen von Nutzern' where id = 1006353;
update public.antworten set text = 'Sie lädt besonders schnell, auch bei langsamer Verbindung' where id = 1006354;
update public.antworten set text = 'Sie ist gegen Angriffe geschützt und überträgt verschlüsselt' where id = 1006355;
-- 230269: Was bedeutet der Begriff Cloud in der IT?
update public.antworten set text = 'IT-Ressourcen, die ein Anbieter über das Internet bereitstellt' where id = 1006356;
update public.antworten set text = 'Temporärer Datenspeicher laufender Programme im Arbeitsspeicher' where id = 1006357;
update public.antworten set text = 'Kabelloses Funknetzwerk zwischen den Geräten im Büro' where id = 1006358;
update public.antworten set text = 'Sicherungskopie auf DVD, die außerhalb der Firma aufbewahrt wird' where id = 1006359;
-- 230270: Wofür steht die Abkürzung IaaS?
update public.antworten set text = 'Infrastructure as a Service, gemietete Server und Speicher' where id = 1006360;
update public.antworten set text = 'Internet as a Service, gemieteter Internetzugang aus der Cloud' where id = 1006361;
update public.antworten set text = 'Installation as a Standard, Standard für Server-Installation' where id = 1006362;
update public.antworten set text = 'Integration and Application Security, Sicherheitskonzept für die Cloud' where id = 1006363;
-- 230271: Wofür steht die Abkürzung PaaS?
update public.antworten set text = 'Platform as a Service, fertige Umgebung für die eigene Anwendung' where id = 1006364;
update public.antworten set text = 'Password as a Service, zentraler Dienst zur Passwortverwaltung' where id = 1006365;
update public.antworten set text = 'Program and Application Storage, Speicher für Programme in der Cloud' where id = 1006366;
update public.antworten set text = 'Public Access Server, öffentlich erreichbarer Server für alle' where id = 1006367;
-- 230272: Welche der folgenden Firmen ist ein großer Cloud-Anbieter?
update public.antworten set text = 'Amazon (AWS)' where id = 1006368;
update public.antworten set text = 'Adobe (ACS)' where id = 1006369;
update public.antworten set text = 'Intel (ICS)' where id = 1006370;
update public.antworten set text = 'Siemens (SCS)' where id = 1006371;
-- 230273: Was ist ein Vorteil der Cloud gegenüber eigenen Servern im Keller?
update public.antworten set text = 'Ressourcen lassen sich in Minuten vergrößern oder verkleinern' where id = 1006372;
update public.antworten set text = 'Die Daten liegen garantiert im eigenen Gebäude unter eigener Kontrolle' where id = 1006373;
update public.antworten set text = 'Es fallen keine laufenden Kosten für die Nutzung an' where id = 1006374;
update public.antworten set text = 'Es wird keine Internetverbindung für den Zugriff benötigt' where id = 1006375;
-- 230274: Was bedeutet DevOps?
update public.antworten set text = 'Enge, automatisierte Zusammenarbeit von Entwicklung und Betrieb' where id = 1006376;
update public.antworten set text = 'Programm zur Fehlersuche für Entwickler beim Debuggen im Betrieb' where id = 1006377;
update public.antworten set text = 'Programmiersprache für Server zur Automatisierung von Betriebsabläufen' where id = 1006378;
update public.antworten set text = 'Abteilung für Hardware-Einkauf, die neue Geräte bereitstellt' where id = 1006379;
-- 230275: Was ist eine Pipeline in CI/CD?
update public.antworten set text = 'Automatische Abfolge aus Bauen, Testen und Ausliefern von Code' where id = 1006380;
update public.antworten set text = 'Netzwerkkabel, über das fertiger Code auf den Produktivserver kommt' where id = 1006381;
update public.antworten set text = 'Liste offener Fehler, die das Team nach jeder Codeänderung abarbeitet' where id = 1006382;
update public.antworten set text = 'Backup-Ordner, in dem jede Codeänderung automatisch gesichert wird' where id = 1006383;
-- 230276: Wofür steht die Abkürzung CD in CI/CD?
update public.antworten set text = 'Continuous Delivery bzw. Deployment, automatisches Ausliefern' where id = 1006384;
update public.antworten set text = 'Continuous Documentation, automatisches Erstellen der Dokumentation' where id = 1006385;
update public.antworten set text = 'Code Distribution, automatisches Verteilen des Codes ans Team' where id = 1006386;
update public.antworten set text = 'Central Database, zentrale Datenbank für alle Codeversionen' where id = 1006387;
-- 230277: Was ist ein Build?
update public.antworten set text = 'Erzeugen eines ausführbaren Programms oder Pakets aus Quellcode' where id = 1006388;
update public.antworten set text = 'Schreiben von Quellcode durch Entwickler in einer IDE wie VS Code' where id = 1006389;
update public.antworten set text = 'Löschen alter Versionen aus dem Repository, um Platz zu sparen' where id = 1006390;
update public.antworten set text = 'Treffen des Entwicklerteams, bei dem der Fortschritt besprochen wird' where id = 1006391;
-- 230278: Was ist GitHub?
update public.antworten set text = 'Online-Plattform für gemeinsame Arbeit an Git-Repositories' where id = 1006392;
update public.antworten set text = 'Texteditor für Programmierer mit Syntaxhervorhebung' where id = 1006393;
update public.antworten set text = 'Betriebssystem für Server zum gemeinsamen Betrieb von Anwendungen' where id = 1006394;
update public.antworten set text = 'Programmiersprache zur gemeinsamen Entwicklung von Webanwendungen' where id = 1006395;
-- 230279: Was ist Docker?
update public.antworten set text = 'Software, die Anwendungen in Containern verpackt und ausführt' where id = 1006396;
update public.antworten set text = 'Programmiersprache für Cloud-Anwendungen, ähnlich wie Go' where id = 1006397;
update public.antworten set text = 'Cloud-Anbieter, der Server und Speicherplatz für Anwendungen vermietet' where id = 1006398;
update public.antworten set text = 'Texteditor zum Bearbeiten von Server-Konfigurationsdateien' where id = 1006399;
-- 230280: Was ist ein Docker-Image?
update public.antworten set text = 'Unveränderliche Vorlage, aus der Container gestartet werden' where id = 1006400;
update public.antworten set text = 'Abbild des laufenden Servers, das als Backup gespeichert wird' where id = 1006401;
update public.antworten set text = 'Backup der Datenbank, das in einem Container gespeichert wird' where id = 1006402;
update public.antworten set text = 'Laufender Container, in dem die Anwendung ausgeführt wird' where id = 1006403;
-- 230281: Wofür steht die Abkürzung K8s?
update public.antworten set text = 'Kubernetes, ein System zur Verwaltung vieler Container' where id = 1006404;
update public.antworten set text = 'Kernel 8 Standard, die achte Version des Linux-Kernels' where id = 1006405;
update public.antworten set text = 'Key Storage 8, ein System zur Verwaltung von Schlüsseln' where id = 1006406;
update public.antworten set text = 'Kompakt-Server 8, ein System aus acht kleinen Servern' where id = 1006407;
-- 230282: Was ist der Hauptzweck von Kubernetes?
update public.antworten set text = 'Container automatisch verteilen, überwachen und neu starten' where id = 1006408;
update public.antworten set text = 'Quellcode automatisch kompilieren und in Programme übersetzen' where id = 1006409;
update public.antworten set text = 'Webseiten gestalten und ihr Layout an Geräte anpassen' where id = 1006410;
update public.antworten set text = 'Passwörter zentral verwalten und automatisch erneuern' where id = 1006411;
-- 230283: Welche Datei beschreibt, wie ein Docker-Image gebaut wird?
update public.antworten set text = 'Dockerfile' where id = 1006412;
update public.antworten set text = 'docker.txt' where id = 1006413;
update public.antworten set text = 'image.yaml' where id = 1006414;
update public.antworten set text = 'container.cfg' where id = 1006415;
-- 230284: Wofür steht die Abkürzung IaC?
update public.antworten set text = 'Infrastructure as Code, Server und Netzwerke als Code beschrieben' where id = 1006416;
update public.antworten set text = 'Internet and Cloud, Server werden im Internet statt im Haus betrieben' where id = 1006417;
update public.antworten set text = 'Installation as Configuration, Installation über Konfigurationsdatei' where id = 1006418;
update public.antworten set text = 'Integrated Access Control, zentrale Verwaltung aller Zugriffsrechte' where id = 1006419;
-- 230285: Was ist Terraform?
update public.antworten set text = 'Werkzeug, das Cloud-Infrastruktur als Code beschreibt und anlegt' where id = 1006420;
update public.antworten set text = 'Programmiersprache für dynamische Webseiten und Web-Apps' where id = 1006421;
update public.antworten set text = 'Betriebssystem, speziell für den Betrieb von Containern in der Cloud' where id = 1006422;
update public.antworten set text = 'Programm zum Schneiden von Videos und Aufbereiten für das Web' where id = 1006423;
-- 230286: Was bedeutet Monitoring in der IT?
update public.antworten set text = 'Laufende Überwachung von Erreichbarkeit und Auslastung der Server' where id = 1006424;
update public.antworten set text = 'Erstellen von Backups, z. B. jede Nacht eine Kopie aller Serverdaten' where id = 1006425;
update public.antworten set text = 'Installation von Updates, z. B. monatliche Sicherheits-Patches' where id = 1006426;
update public.antworten set text = 'Schreiben von Dokumentation, z. B. welche Server es gibt' where id = 1006427;
-- 230287: Was ist eine Metrik im Monitoring?
update public.antworten set text = 'Messwert über die Zeit, z. B. die CPU-Auslastung in Prozent' where id = 1006428;
update public.antworten set text = 'Fehlermeldung im Logfile, z. B. ein Timeout beim Verbinden' where id = 1006429;
update public.antworten set text = 'Passwort für das Monitoring-Tool, z. B. für den Admin-Zugang' where id = 1006430;
update public.antworten set text = 'Name eines Servers im Monitoring, z. B. web01 oder db02' where id = 1006431;
-- 230288: Was ist ein Alert im Monitoring?
update public.antworten set text = 'Automatische Benachrichtigung bei Überschreiten eines Grenzwerts' where id = 1006432;
update public.antworten set text = 'Wöchentlicher Bericht mit allen Messwerten der letzten Tage' where id = 1006433;
update public.antworten set text = 'Backup aller Metriken, das Messwerte für spätere Auswertungen sichert' where id = 1006434;
update public.antworten set text = 'Automatischer Neustart eines Servers, der nicht mehr reagiert' where id = 1006435;
-- 230289: Was bedeutet Hochverfügbarkeit (High Availability)?
update public.antworten set text = 'System bleibt auch bei Ausfall einzelner Komponenten erreichbar' where id = 1006436;
update public.antworten set text = 'System antwortet besonders schnell, z. B. in unter einer Sekunde' where id = 1006437;
update public.antworten set text = 'System bietet besonders viel Speicherplatz für Daten' where id = 1006438;
update public.antworten set text = 'System ist nur zu den Geschäftszeiten erreichbar' where id = 1006439;
-- 230290: Was bedeutet Skalierung?
update public.antworten set text = 'Leistung an die Last anpassen, z. B. mehr Server bei Bedarf' where id = 1006440;
update public.antworten set text = 'Daten verschlüsseln, z. B. beim Übertragen über das Internet' where id = 1006441;
update public.antworten set text = 'Darstellung an die Bildschirmgröße anpassen, z. B. auf dem Handy' where id = 1006442;
update public.antworten set text = 'Alte Logdateien löschen, damit die Festplatte nicht voll läuft' where id = 1006443;
-- 230291: Was bedeutet Redundanz in der IT?
update public.antworten set text = 'Wichtige Komponenten sind mehrfach vorhanden, um Ausfälle abzufangen' where id = 1006444;
update public.antworten set text = 'Daten sind doppelt gespeichert und verschwenden Speicherplatz' where id = 1006445;
update public.antworten set text = 'Ein Server läuft ohne Backup, damit keine doppelten Daten entstehen' where id = 1006446;
update public.antworten set text = 'Ein Programm läuft langsamer, weil es Berechnungen mehrfach ausführt' where id = 1006447;
-- 230292: Was bedeutet das Abrechnungsmodell „Pay as you go“ in der Cloud?
update public.antworten set text = 'Man zahlt nur für die tatsächlich genutzten Ressourcen' where id = 1006448;
update public.antworten set text = 'Man zahlt einen festen Jahresbetrag, egal wie viel man nutzt' where id = 1006449;
update public.antworten set text = 'Man zahlt einmalig beim Kauf und nutzt dann unbegrenzt' where id = 1006450;
update public.antworten set text = 'Die Nutzung ist kostenlos, bezahlt wird nur der Support' where id = 1006451;
-- 230293: Was bedeutet Ausfallzeit (Downtime)?
update public.antworten set text = 'Die Zeit, in der ein System nicht verfügbar ist' where id = 1006452;
update public.antworten set text = 'Die Zeit, die ein vollständiges Backup dauert' where id = 1006453;
update public.antworten set text = 'Die Zeit, bis eine Webseite vollständig geladen ist' where id = 1006454;
update public.antworten set text = 'Die Zeit bis zum nächsten geplanten Update' where id = 1006455;
-- 230294: Was ist eine Datenstruktur?
update public.antworten set text = 'Art, Daten im Speicher zu organisieren, z. B. Liste oder Stack' where id = 1006456;
update public.antworten set text = 'Diagramm für Datenbanken mit Tabellen und Beziehungen' where id = 1006457;
update public.antworten set text = 'Programmiersprache zur Datenverarbeitung, z. B. Python oder Java' where id = 1006458;
update public.antworten set text = 'Datei auf der Festplatte, in der Daten gespeichert werden' where id = 1006459;
-- 230295: Wofür steht die Abkürzung LIFO bei einem Stack?
update public.antworten set text = 'Last In, First Out, zuletzt abgelegtes Element wird zuerst entnommen' where id = 1006460;
update public.antworten set text = 'Last In, First Ordered, zuletzt abgelegtes Element wird sortiert' where id = 1006461;
update public.antworten set text = 'List In, File Out, Elemente als Liste eingelesen, als Datei ausgegeben' where id = 1006462;
update public.antworten set text = 'Low Input, Fast Output, kleine Eingaben werden schnell ausgegeben' where id = 1006463;
-- 230296: Wofür steht die Abkürzung FIFO bei einer Queue?
update public.antworten set text = 'First In, First Out, das erste Element wird zuerst bearbeitet' where id = 1006464;
update public.antworten set text = 'Fast In, Fast Out, jedes Element wird möglichst schnell bearbeitet' where id = 1006465;
update public.antworten set text = 'First In, Final Output, das erste Element wird zuletzt bearbeitet' where id = 1006466;
update public.antworten set text = 'File Input, File Output, Elemente aus Datei lesen und schreiben' where id = 1006467;
-- 230297: Wie nennt man die Operation, mit der ein Element oben auf einen Stack gelegt wir
update public.antworten set text = 'Operation push' where id = 1006468;
update public.antworten set text = 'Operation pop' where id = 1006469;
update public.antworten set text = 'Operation add' where id = 1006470;
update public.antworten set text = 'Operation insert' where id = 1006471;
-- 230298: Was beschreibt die Laufzeit eines Algorithmus?
update public.antworten set text = 'Wie viele Schritte oder wie viel Zeit er je nach Datenmenge braucht' where id = 1006472;
update public.antworten set text = 'Wie viele Codezeilen er hat und wie viele Funktionen er aufruft' where id = 1006473;
update public.antworten set text = 'Wie lange die Entwicklung von der Idee bis zur Umsetzung gedauert hat' where id = 1006474;
update public.antworten set text = 'Wie viele Programmierer ihn geschrieben und getestet haben' where id = 1006475;
-- 230299: Was ist eine verkettete Liste?
update public.antworten set text = 'Datenstruktur, bei der jedes Element auf das nächste zeigt' where id = 1006476;
update public.antworten set text = 'Array mit fester Größe, dessen Elemente direkt hintereinander liegen' where id = 1006477;
update public.antworten set text = 'Datenbanktabelle, deren Zeilen über Schlüssel verknüpft sind' where id = 1006478;
update public.antworten set text = 'Sortierte Zahlenliste, bei der jedes Element größer als das vorige ist' where id = 1006479;
-- 230300: Wie nennt man ein einzelnes Element einer verketteten Liste?
update public.antworten set text = 'Knoten (Node)' where id = 1006480;
update public.antworten set text = 'Zelle (Cell)' where id = 1006481;
update public.antworten set text = 'Blatt (Leaf)' where id = 1006482;
update public.antworten set text = 'Feld (Datenfeld)' where id = 1006483;
-- 230301: Was ist der Unterschied zwischen einem Array und einer verketteten Liste beim Zu
update public.antworten set text = 'Array greift per Index direkt zu, Liste wird von vorne durchlaufen' where id = 1006484;
update public.antworten set text = 'Kein Unterschied, beide erreichen jedes Element direkt per Index' where id = 1006485;
update public.antworten set text = 'Die Liste ist immer schneller, da sie jedes Element per Zeiger findet' where id = 1006486;
update public.antworten set text = 'Arrays lassen sich nicht durchlaufen, Listen greifen per Index zu' where id = 1006487;
-- 230302: Was bedeutet es, wenn eine verkettete Liste „doppelt verkettet“ ist?
update public.antworten set text = 'Jeder Knoten zeigt auf den nächsten und den vorherigen Knoten' where id = 1006488;
update public.antworten set text = 'Jeder Wert ist zweimal gespeichert, damit er nicht verloren geht' where id = 1006489;
update public.antworten set text = 'Die Liste ist mit einer zweiten Liste mit denselben Werten verbunden' where id = 1006490;
update public.antworten set text = 'Die Liste hat doppelt so viele Elemente, jeder Knoten hat zwei Werte' where id = 1006491;
-- 230303: Worauf zeigt der Zeiger des letzten Knotens in einer einfach verketteten Liste?
update public.antworten set text = 'Auf null, damit ist das Ende der Liste markiert' where id = 1006492;
update public.antworten set text = 'Auf den ersten Knoten, so entsteht ein Ring' where id = 1006493;
update public.antworten set text = 'Auf sich selbst, so ist das Ende markiert' where id = 1006494;
update public.antworten set text = 'Auf den Head der Liste, so beginnt sie wieder von vorn' where id = 1006495;
-- 230304: Was ist ein Baum als Datenstruktur?
update public.antworten set text = 'Hierarchische Struktur aus Knoten, die von einer Wurzel verzweigt' where id = 1006496;
update public.antworten set text = 'Sortierte Liste, deren Elemente von der Wurzel aus verkettet sind' where id = 1006497;
update public.antworten set text = 'Tabelle mit Zeilen und Spalten, in der Daten hierarchisch liegen' where id = 1006498;
update public.antworten set text = 'Netzwerk aus Servern, die sternförmig von einem Knoten ausgehen' where id = 1006499;
-- 230305: Wie heißt der oberste Knoten eines Baums?
update public.antworten set text = 'Wurzel (Root)' where id = 1006500;
update public.antworten set text = 'Blatt (Leaf)' where id = 1006501;
update public.antworten set text = 'Stamm (Trunk)' where id = 1006502;
update public.antworten set text = 'Kopf (Head)' where id = 1006503;
-- 230306: Wie nennt man einen Knoten in einem Baum, der keine Kinder hat?
update public.antworten set text = 'Blatt (Leaf)' where id = 1006504;
update public.antworten set text = 'Wurzel (Root)' where id = 1006505;
update public.antworten set text = 'Ast (Branch)' where id = 1006506;
update public.antworten set text = 'Eltern (Parent)' where id = 1006507;
-- 230307: Wie viele Kinder darf ein Knoten in einem binären Baum höchstens haben?
update public.antworten set text = 'Höchstens 2 Kinder' where id = 1006508;
update public.antworten set text = 'Höchstens 1 Kind' where id = 1006509;
update public.antworten set text = 'Höchstens 3 Kinder' where id = 1006510;
update public.antworten set text = 'Beliebig viele Kinder' where id = 1006511;
-- 230308: Was ist ein Heap?
update public.antworten set text = 'Binärer Baum, Eltern sind stets größer oder kleiner als ihre Kinder' where id = 1006512;
update public.antworten set text = 'Binärer Baum, in dem alle Knoten denselben Wert haben' where id = 1006513;
update public.antworten set text = 'Liste ohne feste Reihenfolge mit beliebig einfügbaren Elementen' where id = 1006514;
update public.antworten set text = 'Speicherbereich für lokale Variablen, der nach dem Aufruf frei wird' where id = 1006515;
-- 230309: Was ist ein Graph als Datenstruktur?
update public.antworten set text = 'Menge von Knoten, die durch Kanten miteinander verbunden sind' where id = 1006516;
update public.antworten set text = 'Diagramm mit Balken und Linien zur Darstellung von Messreihen' where id = 1006517;
update public.antworten set text = 'Sortierte Liste von Zahlen ohne Verbindungen untereinander' where id = 1006518;
update public.antworten set text = 'Bild, das ein Programm auf dem Bildschirm anzeigt' where id = 1006519;
-- 230310: Was ist eine Kante in einem Graphen?
update public.antworten set text = 'Die Verbindung zwischen zwei Knoten' where id = 1006520;
update public.antworten set text = 'Der äußerste Knoten des Graphen' where id = 1006521;
update public.antworten set text = 'Ein Knoten ohne Verbindung zu Nachbarn' where id = 1006522;
update public.antworten set text = 'Der Startknoten einer Suche im Graphen' where id = 1006523;
-- 230311: Was macht der Sortieralgorithmus Bubble Sort?
update public.antworten set text = 'Vergleicht Nachbarn und vertauscht sie bei falscher Reihenfolge' where id = 1006524;
update public.antworten set text = 'Teilt die Liste in Hälften, sortiert beide und fügt sie zusammen' where id = 1006525;
update public.antworten set text = 'Sucht je Durchlauf das kleinste Element und setzt es nach vorne' where id = 1006526;
update public.antworten set text = 'Baut aus den Elementen einen Baum und liest sie sortiert wieder aus' where id = 1006527;
-- 230312: Was ist der Vorteil einer sortierten Liste gegenüber einer unsortierten?
update public.antworten set text = 'Man kann viel schneller suchen, z. B. mit der binären Suche' where id = 1006528;
update public.antworten set text = 'Sie braucht weniger Speicher, weil doppelte Werte entfallen' where id = 1006529;
update public.antworten set text = 'Sie kann mehr Elemente aufnehmen, z. B. bei großen Datenmengen' where id = 1006530;
update public.antworten set text = 'Sie kann nicht mehr verändert werden, z. B. durch Einfügen' where id = 1006531;
-- 230313: Was bedeutet es, einen Graphen zu durchlaufen (Traversierung)?
update public.antworten set text = 'Alle Knoten systematisch besuchen, in Breite oder Tiefe' where id = 1006532;
update public.antworten set text = 'Alle Kanten löschen, sodass nur die Knoten übrig bleiben' where id = 1006533;
update public.antworten set text = 'Den Graphen zeichnen, z. B. auf Papier oder am Bildschirm' where id = 1006534;
update public.antworten set text = 'Die Knoten nach ihrem Wert sortieren, z. B. aufsteigend' where id = 1006535;
-- 230314: Was bedeutet O(1) in der Big-O-Notation?
update public.antworten set text = 'Die Laufzeit ist konstant, unabhängig von der Datenmenge' where id = 1006536;
update public.antworten set text = 'Die Laufzeit verdoppelt sich mit jedem zusätzlichen Element' where id = 1006537;
update public.antworten set text = 'Der Algorithmus braucht genau eine Sekunde pro Durchlauf' where id = 1006538;
update public.antworten set text = 'Der Algorithmus hat einen Fehler und liefert nur ein Ergebnis' where id = 1006539;
-- 230315: Was bedeutet O(n) in der Big-O-Notation?
update public.antworten set text = 'Die Laufzeit wächst linear mit der Anzahl n der Elemente' where id = 1006540;
update public.antworten set text = 'Die Laufzeit bleibt immer gleich, egal wie groß n ist' where id = 1006541;
update public.antworten set text = 'Die Laufzeit wächst quadratisch mit der Anzahl n der Elemente' where id = 1006542;
update public.antworten set text = 'Der Algorithmus braucht genau n Sekunden pro Durchlauf' where id = 1006543;
-- 230316: Welcher Algorithmus ist bei großen Datenmengen schneller: einer mit O(n) oder ei
update public.antworten set text = 'Der Algorithmus mit O(n)' where id = 1006544;
update public.antworten set text = 'Der Algorithmus mit O(n²)' where id = 1006545;
update public.antworten set text = 'Beide sind gleich schnell' where id = 1006546;
update public.antworten set text = 'Das hängt vom Computer ab' where id = 1006547;
-- 230317: Was bedeutet Optimierung eines Algorithmus?
update public.antworten set text = 'Ihn so verändern, dass er weniger Zeit oder Speicher braucht' where id = 1006548;
update public.antworten set text = 'Ihn in eine andere Programmiersprache übersetzen, z. B. Java' where id = 1006549;
update public.antworten set text = 'Mehr Kommentare hinzufügen, damit er verständlicher wird' where id = 1006550;
update public.antworten set text = 'Ihn auf einem größeren Server mit mehr Speicher laufen lassen' where id = 1006551;
-- 230318: Was ist der Unterschied zwischen Zeitkomplexität und Speicherkomplexität?
update public.antworten set text = 'Zeitkomplexität misst Rechenzeit, Speicherkomplexität Speicherplatz' where id = 1006552;
update public.antworten set text = 'Kein Unterschied, beide beschreiben den gleichen Aufwand' where id = 1006553;
update public.antworten set text = 'Zeitkomplexität nur für Datenbanken, Speicherkomplexität nur für RAM' where id = 1006554;
update public.antworten set text = 'Zeitkomplexität misst Entwicklungszeit, Speicherkomplexität Codegröße' where id = 1006555;
-- 230320: Was ist der Unterschied zwischen `DELETE FROM kunden WHERE id = 5;` und `DELETE 
update public.antworten set text = 'Die erste löscht nur den Kunden mit id 5, die zweite alle Zeilen' where id = 1006560;
update public.antworten set text = 'Die zweite löscht die Tabelle samt Struktur, die erste eine Zeile' where id = 1006561;
update public.antworten set text = 'Die erste löscht die Spalte id, die zweite löscht alle Spalten' where id = 1006562;
update public.antworten set text = 'Beide löschen nur eine Zeile, die zweite jedoch ohne Rückfrage' where id = 1006563;
-- 230324: Was bewirkt der Befehl `grep -i fehler /var/log/syslog`?
update public.antworten set text = 'Zeigt alle Zeilen mit fehler, Groß-/Kleinschreibung wird ignoriert' where id = 1006576;
update public.antworten set text = 'Löscht alle Zeilen mit fehler, Groß-/Kleinschreibung wird ignoriert' where id = 1006577;
update public.antworten set text = 'Zeigt nur die erste Zeile mit Fehler, Schreibweise muss genau passen' where id = 1006578;
update public.antworten set text = 'Zählt, wie oft fehler vorkommt, Groß-/Kleinschreibung wird ignoriert' where id = 1006579;
-- 230326: Was macht die Befehlskette `cat zugriffe.log | grep 404 | wc -l`?
update public.antworten set text = 'Zählt, wie viele Zeilen der Logdatei 404 enthalten' where id = 1006584;
update public.antworten set text = 'Löscht alle Zeilen mit 404 aus der Logdatei' where id = 1006585;
update public.antworten set text = 'Zeigt die 404 längsten Zeilen der Logdatei an' where id = 1006586;
update public.antworten set text = 'Speichert alle Zeilen mit 404 in einer neuen Datei' where id = 1006587;
-- 230329: Ein Mitarbeiter erhält eine E-Mail von „support@paypa1.com“ mit der Bitte, sein 
update public.antworten set text = 'Nicht klicken, als Phishing an die IT melden, PayPal selbst eintippen' where id = 1006596;
update public.antworten set text = 'Link öffnen, Seite auf Echtheit prüfen und dann Zugangsdaten eingeben' where id = 1006597;
update public.antworten set text = 'Auf die Mail antworten und Details erfragen, um den Absender zu prüfen' where id = 1006598;
update public.antworten set text = 'An alle Kollegen weiterleiten, damit jeder den Absender selbst prüft' where id = 1006599;
-- 230330: Welche Firewall-Regel sollte für einen Webserver im Internet gelten?
update public.antworten set text = 'Nur die nötigen Ports 80 und 443 erlauben, alles andere blockieren' where id = 1006600;
update public.antworten set text = 'Alle Ports öffnen, damit alle Dienste jederzeit erreichbar sind' where id = 1006601;
update public.antworten set text = 'Nur Port 22 erlauben, damit der Administrator arbeiten kann' where id = 1006602;
update public.antworten set text = 'Alle Ports blockieren, auch 80 und 443, damit nichts angreifbar ist' where id = 1006603;
-- 230331: Warum ist ein öffentliches WLAN im Café ohne VPN riskant?
update public.antworten set text = 'Andere im Netz können mitlesen oder sich als Zugangspunkt ausgeben' where id = 1006604;
update public.antworten set text = 'Das WLAN ist zu langsam, sodass Daten dann im Klartext gesendet werden' where id = 1006605;
update public.antworten set text = 'Der Laptop-Akku entlädt sich schneller durch volle Sendeleistung' where id = 1006606;
update public.antworten set text = 'Öffentliche WLANs erlauben kein HTTPS, alle Daten gehen im Klartext' where id = 1006607;
-- 230332: Ein Portscan zeigt auf einem Server die offenen Ports 22, 80, 443 und 3306. Welc
update public.antworten set text = '3306, MySQL sollte nicht direkt aus dem Internet erreichbar sein' where id = 1006608;
update public.antworten set text = '443, HTTPS ist riskant, da der Datenverkehr nicht prüfbar ist' where id = 1006609;
update public.antworten set text = '80, HTTP sollte nie offen sein, Webseiten dürfen nur über HTTPS laufen' where id = 1006610;
update public.antworten set text = '22, SSH ist immer unsicher, weil die Anmeldung unverschlüsselt erfolgt' where id = 1006611;
-- 230333: Was ist der Unterschied zwischen HTTP und HTTPS in Bezug auf ein Login-Formular?
update public.antworten set text = 'HTTP überträgt das Passwort im Klartext, HTTPS verschlüsselt' where id = 1006612;
update public.antworten set text = 'HTTPS speichert das Passwort auf dem Server verschlüsselt, HTTP nicht' where id = 1006613;
update public.antworten set text = 'HTTP ist schneller und daher für Logins besser geeignet als HTTPS' where id = 1006614;
update public.antworten set text = 'Kein Unterschied, beides ist unverschlüsselt und unsicher' where id = 1006615;
-- 230334: Was gibt dieser Code aus? ``` int a = 7; int b = 2; System.out.println(a / b); `
update public.antworten set text = 'Die Ausgabe ist 3' where id = 1006616;
update public.antworten set text = 'Die Ausgabe ist 3.5' where id = 1006617;
update public.antworten set text = 'Die Ausgabe ist 4' where id = 1006618;
update public.antworten set text = 'Die Ausgabe ist 3,5' where id = 1006619;
-- 230335: Was ist das Ergebnis von `10 % 3` in den meisten Programmiersprachen?
update public.antworten set text = 'Das Ergebnis ist 1' where id = 1006620;
update public.antworten set text = 'Das Ergebnis ist 3' where id = 1006621;
update public.antworten set text = 'Das Ergebnis ist 0.33' where id = 1006622;
update public.antworten set text = 'Das Ergebnis ist 3.33' where id = 1006623;
-- 230337: Ein PC startet nicht, die Lüfter drehen kurz an und gehen wieder aus. Welche Kom
update public.antworten set text = 'Das Netzteil oder die Stromversorgung des Mainboards' where id = 1006628;
update public.antworten set text = 'Die Festplatte, weil das Betriebssystem nicht startet' where id = 1006629;
update public.antworten set text = 'Der Monitor, weil kein Bild angezeigt wird' where id = 1006630;
update public.antworten set text = 'Die Tastatur, weil sie beim Start nicht reagiert' where id = 1006631;
-- 230338: Ein Nutzer will seinen Büro-PC für Videoschnitt nachrüsten. Welche Aufrüstung br
update public.antworten set text = 'Mehr Arbeitsspeicher und eine leistungsfähige Grafikkarte' where id = 1006632;
update public.antworten set text = 'Eine größere Festplatte und ein neues Gehäuse mit Lüftern' where id = 1006633;
update public.antworten set text = 'Ein neues Netzteil und zusätzliche USB-Anschlüsse' where id = 1006634;
update public.antworten set text = 'Ein zweiter Monitor und eine neue ergonomische Tastatur' where id = 1006635;

commit;

-- Kontrolle:
-- select count(*) filter (where avg_len > 70) as noch_lang, avg(avg_len)::int as schnitt
--   from (select frage_id, avg(length(text)) avg_len from antworten where frage_id >= 230000 group by 1) a;
-- Erwartet: noch_lang 0, schnitt ~48.
