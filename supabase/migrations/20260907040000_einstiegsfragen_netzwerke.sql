-- 2026-09-07: 25 Einstiegsfragen (einfach) fuer Modul Netzwerke (9004), 5 je Thema.
--
-- Befund: Nach der Neu-Einstufung hat "Netzwerk-Grundlagen" nur 3 einfache
-- Fragen, die hinteren Themen gar keine. Ziel: jedes Thema beginnt mit
-- reinen Faktfragen (Regel: docs/schwierigkeit_regel.md, 1. Lehrjahr).
-- Fragetexte zum Gegenlesen: docs/neue_fragen_netzwerke_2026-09-07.md
--
-- IDs 230001-230025 explizit (fragen_id_seq steht bei 211283, vorhandene
-- Fragen reichen bis 220116 -> neuer Bereich 230000+ fuer handgeschriebene
-- Einstiegsfragen). Antworten ueber die Sequenz. Erklaerung nur bei der
-- richtigen Antwort; Trigger trg_didactic_expl_aiu erzeugt die
-- "Nicht korrekt ..."-Texte der falschen Antworten automatisch.
-- Am Ende Themen-Badges neu berechnen.

begin;

-- Netzwerk-Grundlagen: Wofür steht die Abkürzung LAN?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230001, 9004, 9401, 'Wofür steht die Abkürzung LAN?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230001, 'Local Area Network – ein lokales Netzwerk, z. B. in einem Gebäude', true, 'Ein LAN (Local Area Network) verbindet Geräte auf begrenztem Raum, etwa in einem Büro, einer Schule oder zu Hause. Das Gegenstück für große Entfernungen ist das WAN (Wide Area Network).'),
  (230001, 'Large Access Node – ein großer Zugangsknoten', false, null),
  (230001, 'Long Area Network – ein weltweites Netzwerk', false, null),
  (230001, 'Link Address Number – die Nummer einer Netzwerkkarte', false, null);

-- Netzwerk-Grundlagen: Welches Gerät verbindet mehrere Computer in einem lokalen Netzwerk mit
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230002, 9004, 9401, 'Welches Gerät verbindet mehrere Computer in einem lokalen Netzwerk miteinander und leitet Daten gezielt an den richtigen Anschluss weiter?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230002, 'Switch', true, 'Ein Switch verbindet Geräte im LAN und merkt sich, an welchem Port welches Gerät hängt (MAC-Tabelle). So schickt er Daten nur dorthin, wo sie hingehören.'),
  (230002, 'Drucker', false, null),
  (230002, 'Monitor', false, null),
  (230002, 'Netzteil', false, null);

-- Netzwerk-Grundlagen: Welches Gerät verbindet ein lokales Netzwerk mit dem Internet oder ein
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230003, 9004, 9401, 'Welches Gerät verbindet ein lokales Netzwerk mit dem Internet oder einem anderen Netz?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230003, 'Router', true, 'Ein Router leitet Datenpakete zwischen verschiedenen Netzen weiter, zum Beispiel vom Heimnetz ins Internet. Zu Hause steckt der Router meist in der „Fritzbox“.'),
  (230003, 'Hub', false, null),
  (230003, 'Switch', false, null),
  (230003, 'Repeater', false, null);

-- Netzwerk-Grundlagen: Wie heißt das Kabel, das in den meisten Büros und Wohnungen die Comput
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230004, 9004, 9401, 'Wie heißt das Kabel, das in den meisten Büros und Wohnungen die Computer per Stecker mit dem Netzwerk verbindet?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230004, 'Netzwerkkabel (Ethernet-Kabel, RJ45)', true, 'Das klassische Netzwerkkabel ist ein Twisted-Pair-Kabel mit RJ45-Stecker. Es überträgt Daten per Ethernet, meist mit 1 Gbit/s.'),
  (230004, 'HDMI-Kabel', false, null),
  (230004, 'USB-Kabel', false, null),
  (230004, 'Stromkabel', false, null);

-- Netzwerk-Grundlagen: Wofür steht die Abkürzung WLAN?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230005, 9004, 9401, 'Wofür steht die Abkürzung WLAN?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230005, 'Wireless Local Area Network – ein kabelloses lokales Netzwerk', true, 'WLAN ist ein LAN ohne Kabel: Die Geräte verbinden sich per Funk mit einem Access Point oder Router. Der internationale Begriff dafür ist Wi-Fi.'),
  (230005, 'Wide Local Access Network', false, null),
  (230005, 'World LAN – ein weltweites Netzwerk', false, null),
  (230005, 'Wired LAN – ein kabelgebundenes Netzwerk', false, null);

-- IP & Subnetze Basics: Was ist eine IP-Adresse?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230006, 9004, 9402, 'Was ist eine IP-Adresse?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230006, 'Eine eindeutige Adresse, mit der ein Gerät in einem Netzwerk erreichbar ist', true, 'Jedes Gerät im Netzwerk braucht eine IP-Adresse, damit Daten den Weg zu ihm finden – ähnlich wie eine Postanschrift. IPv4-Adressen bestehen aus vier Zahlen, z. B. 192.168.1.10.'),
  (230006, 'Der Name des Herstellers der Netzwerkkarte', false, null),
  (230006, 'Das Passwort für das WLAN', false, null),
  (230006, 'Die Seriennummer des Computers', false, null);

-- IP & Subnetze Basics: Welche der folgenden Angaben ist eine gültige IPv4-Adresse?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230007, 9004, 9402, 'Welche der folgenden Angaben ist eine gültige IPv4-Adresse?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230007, '192.168.1.10', true, 'Eine IPv4-Adresse besteht aus vier Zahlen zwischen 0 und 255, getrennt durch Punkte. 192.168.1.10 erfüllt das; 256 ist zu groß, und die anderen Formate passen nicht.'),
  (230007, '192.168.1.256', false, null),
  (230007, '192.168.1', false, null),
  (230007, 'www.beispiel.de', false, null);

-- IP & Subnetze Basics: Aus wie vielen Zahlenblöcken (Oktetten) besteht eine IPv4-Adresse?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230008, 9004, 9402, 'Aus wie vielen Zahlenblöcken (Oktetten) besteht eine IPv4-Adresse?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230008, '4', true, 'Eine IPv4-Adresse hat 32 Bit, aufgeteilt in vier Oktette zu je 8 Bit. Jedes Oktett wird als Zahl von 0 bis 255 geschrieben, z. B. 10.0.0.1.'),
  (230008, '2', false, null),
  (230008, '6', false, null),
  (230008, '8', false, null);

-- IP & Subnetze Basics: Wozu dient die Subnetzmaske?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230009, 9004, 9402, 'Wozu dient die Subnetzmaske?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230009, 'Sie legt fest, welcher Teil der IP-Adresse das Netz und welcher Teil das Gerät bezeichnet', true, 'Die Subnetzmaske (z. B. 255.255.255.0) trennt den Netzanteil vom Hostanteil einer IP-Adresse. So weiß ein Gerät, ob ein Ziel im eigenen Netz liegt oder über den Router erreichbar ist.'),
  (230009, 'Sie verschlüsselt die Datenübertragung', false, null),
  (230009, 'Sie speichert das WLAN-Passwort', false, null),
  (230009, 'Sie bestimmt die Geschwindigkeit der Verbindung', false, null);

-- IP & Subnetze Basics: Welche IP-Adresse ist die typische „Localhost“-Adresse, mit der ein Co
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230010, 9004, 9402, 'Welche IP-Adresse ist die typische „Localhost“-Adresse, mit der ein Computer sich selbst anspricht?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230010, '127.0.0.1', true, '127.0.0.1 ist die Loopback-Adresse: Datenpakete an diese Adresse verlassen den Rechner nicht, sondern gehen an ihn selbst zurück. Der Name dafür ist „localhost“.'),
  (230010, '192.168.0.1', false, null),
  (230010, '0.0.0.0', false, null),
  (230010, '255.255.255.255', false, null);

-- Switching & VLANs: Was ist ein Switch?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230011, 9004, 9403, 'Was ist ein Switch?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230011, 'Ein Netzwerkgerät, das mehrere Geräte im LAN verbindet und Daten gezielt an den passenden Port weiterleitet', true, 'Der Switch ist das zentrale Verteilgerät im lokalen Netz. Er arbeitet auf Schicht 2 (Data Link) und nutzt MAC-Adressen, um Daten nur an den richtigen Anschluss zu schicken.'),
  (230011, 'Ein Programm zum Ein- und Ausschalten des Computers', false, null),
  (230011, 'Ein Gerät, das Netzwerke mit dem Internet verbindet', false, null),
  (230011, 'Ein Kabeltyp für Glasfaser', false, null);

-- Switching & VLANs: Wie nennt man die Anschlüsse an einem Switch, in die die Netzwerkkabel
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230012, 9004, 9403, 'Wie nennt man die Anschlüsse an einem Switch, in die die Netzwerkkabel gesteckt werden?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230012, 'Ports', true, 'Die Buchsen am Switch heißen Ports. Ein kleiner Switch hat 5 oder 8 Ports, große Modelle im Rechenzentrum 24 oder 48.'),
  (230012, 'Slots', false, null),
  (230012, 'Bays', false, null),
  (230012, 'Tunnel', false, null);

-- Switching & VLANs: Wofür steht die Abkürzung VLAN?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230013, 9004, 9403, 'Wofür steht die Abkürzung VLAN?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230013, 'Virtual LAN – ein logisch getrenntes Netz innerhalb eines physischen Netzwerks', true, 'Mit VLANs kann man ein Switch-Netz in mehrere voneinander getrennte Netze aufteilen, ohne extra Kabel oder Switches – zum Beispiel ein VLAN für Büro-PCs und eines für Gäste.'),
  (230013, 'Very Large Area Network', false, null),
  (230013, 'Verified LAN – ein geprüftes Netzwerk', false, null),
  (230013, 'Video LAN – ein Netz für Videoübertragung', false, null);

-- Switching & VLANs: Was ist eine MAC-Adresse?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230014, 9004, 9403, 'Was ist eine MAC-Adresse?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230014, 'Die eindeutige Hardware-Adresse einer Netzwerkkarte', true, 'Jede Netzwerkkarte hat vom Hersteller eine feste MAC-Adresse, z. B. 00:1A:2B:3C:4D:5E. Switches nutzen sie, um Geräte im LAN zu unterscheiden.'),
  (230014, 'Die Adresse eines Apple-Computers', false, null),
  (230014, 'Die IP-Adresse des Routers', false, null),
  (230014, 'Der Name des WLAN-Netzes', false, null);

-- Switching & VLANs: Was macht ein Hub mit einem Datenpaket, das er auf einem Port empfängt
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230015, 9004, 9403, 'Was macht ein Hub mit einem Datenpaket, das er auf einem Port empfängt?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230015, 'Er sendet es an alle anderen Ports weiter', true, 'Ein Hub kennt keine Adressen und schickt jedes Paket einfach überall hin. Deshalb sind Hubs heute durch Switches ersetzt, die gezielt weiterleiten.'),
  (230015, 'Er sendet es nur an den Zielport', false, null),
  (230015, 'Er speichert es dauerhaft', false, null),
  (230015, 'Er verschlüsselt es', false, null);

-- Routing & Dienste: Wofür steht die Abkürzung DNS?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230016, 9004, 9404, 'Wofür steht die Abkürzung DNS?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230016, 'Domain Name System – es übersetzt Namen wie www.beispiel.de in IP-Adressen', true, 'Menschen merken sich Namen, Computer brauchen IP-Adressen. DNS ist das „Telefonbuch des Internets“, das beides verbindet.'),
  (230016, 'Data Network Service', false, null),
  (230016, 'Digital Number Storage', false, null),
  (230016, 'Direct Network Switch', false, null);

-- Routing & Dienste: Wofür steht die Abkürzung DHCP?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230017, 9004, 9404, 'Wofür steht die Abkürzung DHCP?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230017, 'Dynamic Host Configuration Protocol – es vergibt IP-Adressen automatisch an Geräte', true, 'Statt jede IP-Adresse von Hand einzutragen, bekommt ein Gerät sie vom DHCP-Server, meist dem Router. Dazu gehören auch Subnetzmaske, Gateway und DNS-Server.'),
  (230017, 'Direct Hardware Control Protocol', false, null),
  (230017, 'Data Host Copy Program', false, null),
  (230017, 'Dynamic Home Computer Port', false, null);

-- Routing & Dienste: Welches Gerät übernimmt zu Hause meist gleichzeitig Router, Switch, WL
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230018, 9004, 9404, 'Welches Gerät übernimmt zu Hause meist gleichzeitig Router, Switch, WLAN-Access-Point und DHCP-Server?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230018, 'Der Internet-Router (z. B. eine Fritzbox)', true, 'Heimrouter sind Kombigeräte: Sie verbinden mit dem Internet, verteilen IP-Adressen per DHCP, bieten LAN-Ports und WLAN in einem Gehäuse.'),
  (230018, 'Der Drucker', false, null),
  (230018, 'Das Smartphone', false, null),
  (230018, 'Der Fernseher', false, null);

-- Routing & Dienste: Welche Aufgabe hat das Default Gateway in einem Netzwerk?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230019, 9004, 9404, 'Welche Aufgabe hat das Default Gateway in einem Netzwerk?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230019, 'Es ist die Adresse des Routers, über den Daten das eigene Netz verlassen', true, 'Will ein Gerät ein Ziel außerhalb des eigenen Netzes erreichen, schickt es die Daten an das Default Gateway – normalerweise den Router, z. B. 192.168.1.1.'),
  (230019, 'Es speichert alle Webseiten zwischen', false, null),
  (230019, 'Es vergibt Benutzernamen', false, null),
  (230019, 'Es verschlüsselt WLAN-Daten', false, null);

-- Routing & Dienste: Was ist ein Server?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230020, 9004, 9404, 'Was ist ein Server?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230020, 'Ein Computer, der anderen Geräten Dienste bereitstellt, z. B. Webseiten oder Dateien', true, 'Server „bedienen“ Clients: Ein Webserver liefert Webseiten, ein Dateiserver Dateien, ein Mailserver E-Mails. Das Gegenstück ist der Client, der die Dienste nutzt.'),
  (230020, 'Ein Kabel zur Stromversorgung', false, null),
  (230020, 'Ein Programm zum Surfen im Internet', false, null),
  (230020, 'Ein Speicherchip im Router', false, null);

-- Security & Troubleshooting: Wofür wird eine Firewall eingesetzt?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230021, 9004, 9405, 'Wofür wird eine Firewall eingesetzt?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230021, 'Sie kontrolliert den Datenverkehr und blockiert unerwünschte Verbindungen', true, 'Eine Firewall entscheidet anhand von Regeln, welche Verbindungen ins Netz oder auf einen Rechner dürfen und welche nicht. Sie ist ein Grundbaustein der IT-Sicherheit.'),
  (230021, 'Sie beschleunigt die Internetverbindung', false, null),
  (230021, 'Sie speichert Passwörter', false, null),
  (230021, 'Sie kühlt den Server', false, null);

-- Security & Troubleshooting: Welcher Port wird standardmäßig für verschlüsselte Webseiten (HTTPS) v
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230022, 9004, 9405, 'Welcher Port wird standardmäßig für verschlüsselte Webseiten (HTTPS) verwendet?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230022, '443', true, 'HTTPS läuft über Port 443, unverschlüsseltes HTTP über Port 80. Diese beiden Ports sollte jeder Fachinformatiker kennen.'),
  (230022, '80', false, null),
  (230022, '21', false, null),
  (230022, '25', false, null);

-- Security & Troubleshooting: Mit welchem Befehl prüft man in der Eingabeaufforderung, ob ein andere
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230023, 9004, 9405, 'Mit welchem Befehl prüft man in der Eingabeaufforderung, ob ein anderer Rechner im Netzwerk erreichbar ist?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230023, 'ping', true, '„ping 192.168.1.1“ schickt kleine Testpakete an das Ziel und zeigt, ob und wie schnell eine Antwort kommt. Das ist der erste Schritt bei fast jeder Netzwerk-Fehlersuche.'),
  (230023, 'print', false, null),
  (230023, 'copy', false, null),
  (230023, 'dir', false, null);

-- Security & Troubleshooting: Mit welchem Windows-Befehl zeigt man die eigene IP-Adresse an?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230024, 9004, 9405, 'Mit welchem Windows-Befehl zeigt man die eigene IP-Adresse an?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230024, 'ipconfig', true, '„ipconfig“ zeigt unter Windows IP-Adresse, Subnetzmaske und Gateway aller Netzwerkkarten. Unter Linux heißt der Befehl „ip a“ (früher „ifconfig“).'),
  (230024, 'ipshow', false, null),
  (230024, 'netview', false, null),
  (230024, 'ping', false, null);

-- Security & Troubleshooting: Was bedeutet das „S“ in HTTPS?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230025, 9004, 9405, 'Was bedeutet das „S“ in HTTPS?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230025, 'Secure – die Verbindung ist verschlüsselt', true, 'HTTPS ist HTTP mit Verschlüsselung (TLS). Man erkennt es am Schloss-Symbol im Browser. Passwörter und Bankdaten sollten nur über HTTPS übertragen werden.'),
  (230025, 'Server', false, null),
  (230025, 'Standard', false, null),
  (230025, 'Speed', false, null);

select public.refresh_themen_schwierigkeit() as themen_aktualisiert;
commit;

-- Kontrolle: select thema_id, count(*) from fragen where id between 230001 and 230025 group by 1;  -- 5 x 5