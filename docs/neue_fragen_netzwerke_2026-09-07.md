# Neue Einstiegsfragen: Netzwerke (07.09.2026)

25 Fragen, Stufe **einfach**, 5 je Thema. Richtige Antwort ist fett, darunter die Erklärung.


## Netzwerk-Grundlagen

**230001 – Wofür steht die Abkürzung LAN?**

- **Local Area Network – ein lokales Netzwerk, z. B. in einem Gebäude** ✅
- Large Access Node – ein großer Zugangsknoten
- Long Area Network – ein weltweites Netzwerk
- Link Address Number – die Nummer einer Netzwerkkarte

> Ein LAN (Local Area Network) verbindet Geräte auf begrenztem Raum, etwa in einem Büro, einer Schule oder zu Hause. Das Gegenstück für große Entfernungen ist das WAN (Wide Area Network).

**230002 – Welches Gerät verbindet mehrere Computer in einem lokalen Netzwerk miteinander und leitet Daten gezielt an den richtigen Anschluss weiter?**

- **Switch** ✅
- Drucker
- Monitor
- Netzteil

> Ein Switch verbindet Geräte im LAN und merkt sich, an welchem Port welches Gerät hängt (MAC-Tabelle). So schickt er Daten nur dorthin, wo sie hingehören.

**230003 – Welches Gerät verbindet ein lokales Netzwerk mit dem Internet oder einem anderen Netz?**

- **Router** ✅
- Hub
- Switch
- Repeater

> Ein Router leitet Datenpakete zwischen verschiedenen Netzen weiter, zum Beispiel vom Heimnetz ins Internet. Zu Hause steckt der Router meist in der „Fritzbox“.

**230004 – Wie heißt das Kabel, das in den meisten Büros und Wohnungen die Computer per Stecker mit dem Netzwerk verbindet?**

- **Netzwerkkabel (Ethernet-Kabel, RJ45)** ✅
- HDMI-Kabel
- USB-Kabel
- Stromkabel

> Das klassische Netzwerkkabel ist ein Twisted-Pair-Kabel mit RJ45-Stecker. Es überträgt Daten per Ethernet, meist mit 1 Gbit/s.

**230005 – Wofür steht die Abkürzung WLAN?**

- **Wireless Local Area Network – ein kabelloses lokales Netzwerk** ✅
- Wide Local Access Network
- World LAN – ein weltweites Netzwerk
- Wired LAN – ein kabelgebundenes Netzwerk

> WLAN ist ein LAN ohne Kabel: Die Geräte verbinden sich per Funk mit einem Access Point oder Router. Der internationale Begriff dafür ist Wi-Fi.


## IP & Subnetze Basics

**230006 – Was ist eine IP-Adresse?**

- **Eine eindeutige Adresse, mit der ein Gerät in einem Netzwerk erreichbar ist** ✅
- Der Name des Herstellers der Netzwerkkarte
- Das Passwort für das WLAN
- Die Seriennummer des Computers

> Jedes Gerät im Netzwerk braucht eine IP-Adresse, damit Daten den Weg zu ihm finden – ähnlich wie eine Postanschrift. IPv4-Adressen bestehen aus vier Zahlen, z. B. 192.168.1.10.

**230007 – Welche der folgenden Angaben ist eine gültige IPv4-Adresse?**

- **192.168.1.10** ✅
- 192.168.1.256
- 192.168.1
- www.beispiel.de

> Eine IPv4-Adresse besteht aus vier Zahlen zwischen 0 und 255, getrennt durch Punkte. 192.168.1.10 erfüllt das; 256 ist zu groß, und die anderen Formate passen nicht.

**230008 – Aus wie vielen Zahlenblöcken (Oktetten) besteht eine IPv4-Adresse?**

- **4** ✅
- 2
- 6
- 8

> Eine IPv4-Adresse hat 32 Bit, aufgeteilt in vier Oktette zu je 8 Bit. Jedes Oktett wird als Zahl von 0 bis 255 geschrieben, z. B. 10.0.0.1.

**230009 – Wozu dient die Subnetzmaske?**

- **Sie legt fest, welcher Teil der IP-Adresse das Netz und welcher Teil das Gerät bezeichnet** ✅
- Sie verschlüsselt die Datenübertragung
- Sie speichert das WLAN-Passwort
- Sie bestimmt die Geschwindigkeit der Verbindung

> Die Subnetzmaske (z. B. 255.255.255.0) trennt den Netzanteil vom Hostanteil einer IP-Adresse. So weiß ein Gerät, ob ein Ziel im eigenen Netz liegt oder über den Router erreichbar ist.

**230010 – Welche IP-Adresse ist die typische „Localhost“-Adresse, mit der ein Computer sich selbst anspricht?**

- **127.0.0.1** ✅
- 192.168.0.1
- 0.0.0.0
- 255.255.255.255

> 127.0.0.1 ist die Loopback-Adresse: Datenpakete an diese Adresse verlassen den Rechner nicht, sondern gehen an ihn selbst zurück. Der Name dafür ist „localhost“.


## Switching & VLANs

**230011 – Was ist ein Switch?**

- **Ein Netzwerkgerät, das mehrere Geräte im LAN verbindet und Daten gezielt an den passenden Port weiterleitet** ✅
- Ein Programm zum Ein- und Ausschalten des Computers
- Ein Gerät, das Netzwerke mit dem Internet verbindet
- Ein Kabeltyp für Glasfaser

> Der Switch ist das zentrale Verteilgerät im lokalen Netz. Er arbeitet auf Schicht 2 (Data Link) und nutzt MAC-Adressen, um Daten nur an den richtigen Anschluss zu schicken.

**230012 – Wie nennt man die Anschlüsse an einem Switch, in die die Netzwerkkabel gesteckt werden?**

- **Ports** ✅
- Slots
- Bays
- Tunnel

> Die Buchsen am Switch heißen Ports. Ein kleiner Switch hat 5 oder 8 Ports, große Modelle im Rechenzentrum 24 oder 48.

**230013 – Wofür steht die Abkürzung VLAN?**

- **Virtual LAN – ein logisch getrenntes Netz innerhalb eines physischen Netzwerks** ✅
- Very Large Area Network
- Verified LAN – ein geprüftes Netzwerk
- Video LAN – ein Netz für Videoübertragung

> Mit VLANs kann man ein Switch-Netz in mehrere voneinander getrennte Netze aufteilen, ohne extra Kabel oder Switches – zum Beispiel ein VLAN für Büro-PCs und eines für Gäste.

**230014 – Was ist eine MAC-Adresse?**

- **Die eindeutige Hardware-Adresse einer Netzwerkkarte** ✅
- Die Adresse eines Apple-Computers
- Die IP-Adresse des Routers
- Der Name des WLAN-Netzes

> Jede Netzwerkkarte hat vom Hersteller eine feste MAC-Adresse, z. B. 00:1A:2B:3C:4D:5E. Switches nutzen sie, um Geräte im LAN zu unterscheiden.

**230015 – Was macht ein Hub mit einem Datenpaket, das er auf einem Port empfängt?**

- **Er sendet es an alle anderen Ports weiter** ✅
- Er sendet es nur an den Zielport
- Er speichert es dauerhaft
- Er verschlüsselt es

> Ein Hub kennt keine Adressen und schickt jedes Paket einfach überall hin. Deshalb sind Hubs heute durch Switches ersetzt, die gezielt weiterleiten.


## Routing & Dienste

**230016 – Wofür steht die Abkürzung DNS?**

- **Domain Name System – es übersetzt Namen wie www.beispiel.de in IP-Adressen** ✅
- Data Network Service
- Digital Number Storage
- Direct Network Switch

> Menschen merken sich Namen, Computer brauchen IP-Adressen. DNS ist das „Telefonbuch des Internets“, das beides verbindet.

**230017 – Wofür steht die Abkürzung DHCP?**

- **Dynamic Host Configuration Protocol – es vergibt IP-Adressen automatisch an Geräte** ✅
- Direct Hardware Control Protocol
- Data Host Copy Program
- Dynamic Home Computer Port

> Statt jede IP-Adresse von Hand einzutragen, bekommt ein Gerät sie vom DHCP-Server, meist dem Router. Dazu gehören auch Subnetzmaske, Gateway und DNS-Server.

**230018 – Welches Gerät übernimmt zu Hause meist gleichzeitig Router, Switch, WLAN-Access-Point und DHCP-Server?**

- **Der Internet-Router (z. B. eine Fritzbox)** ✅
- Der Drucker
- Das Smartphone
- Der Fernseher

> Heimrouter sind Kombigeräte: Sie verbinden mit dem Internet, verteilen IP-Adressen per DHCP, bieten LAN-Ports und WLAN in einem Gehäuse.

**230019 – Welche Aufgabe hat das Default Gateway in einem Netzwerk?**

- **Es ist die Adresse des Routers, über den Daten das eigene Netz verlassen** ✅
- Es speichert alle Webseiten zwischen
- Es vergibt Benutzernamen
- Es verschlüsselt WLAN-Daten

> Will ein Gerät ein Ziel außerhalb des eigenen Netzes erreichen, schickt es die Daten an das Default Gateway – normalerweise den Router, z. B. 192.168.1.1.

**230020 – Was ist ein Server?**

- **Ein Computer, der anderen Geräten Dienste bereitstellt, z. B. Webseiten oder Dateien** ✅
- Ein Kabel zur Stromversorgung
- Ein Programm zum Surfen im Internet
- Ein Speicherchip im Router

> Server „bedienen“ Clients: Ein Webserver liefert Webseiten, ein Dateiserver Dateien, ein Mailserver E-Mails. Das Gegenstück ist der Client, der die Dienste nutzt.


## Security & Troubleshooting

**230021 – Wofür wird eine Firewall eingesetzt?**

- **Sie kontrolliert den Datenverkehr und blockiert unerwünschte Verbindungen** ✅
- Sie beschleunigt die Internetverbindung
- Sie speichert Passwörter
- Sie kühlt den Server

> Eine Firewall entscheidet anhand von Regeln, welche Verbindungen ins Netz oder auf einen Rechner dürfen und welche nicht. Sie ist ein Grundbaustein der IT-Sicherheit.

**230022 – Welcher Port wird standardmäßig für verschlüsselte Webseiten (HTTPS) verwendet?**

- **443** ✅
- 80
- 21
- 25

> HTTPS läuft über Port 443, unverschlüsseltes HTTP über Port 80. Diese beiden Ports sollte jeder Fachinformatiker kennen.

**230023 – Mit welchem Befehl prüft man in der Eingabeaufforderung, ob ein anderer Rechner im Netzwerk erreichbar ist?**

- **ping** ✅
- print
- copy
- dir

> „ping 192.168.1.1“ schickt kleine Testpakete an das Ziel und zeigt, ob und wie schnell eine Antwort kommt. Das ist der erste Schritt bei fast jeder Netzwerk-Fehlersuche.

**230024 – Mit welchem Windows-Befehl zeigt man die eigene IP-Adresse an?**

- **ipconfig** ✅
- ipshow
- netview
- ping

> „ipconfig“ zeigt unter Windows IP-Adresse, Subnetzmaske und Gateway aller Netzwerkkarten. Unter Linux heißt der Befehl „ip a“ (früher „ifconfig“).

**230025 – Was bedeutet das „S“ in HTTPS?**

- **Secure – die Verbindung ist verschlüsselt** ✅
- Server
- Standard
- Speed

> HTTPS ist HTTP mit Verschlüsselung (TLS). Man erkennt es am Schloss-Symbol im Browser. Passwörter und Bankdaten sollten nur über HTTPS übertragen werden.
