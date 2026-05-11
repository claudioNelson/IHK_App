import { Exam } from "../exam-types";

export const si2: Exam = {
    id: "si-2",
    title: "SI Prüfung 2 - Winter 2016/17",
    year: 2016,
    season: "Winter",
    company: "DataCenter Solutions AG",
    duration: 90,
    totalPoints: 100,
    level: "ap2",
    fachrichtung: "si",
    sectionsToChoose: 4,
    scenario: `Sie sind Mitarbeiter/-in in der IT-Abteilung der DataCenter Solutions AG, einem mittelständischen Rechenzentrumsdienstleister.

Im Rahmen der Weiterentwicklung der IT-Infrastruktur sind Sie an verschiedenen Maßnahmen beteiligt.

Sie sollen vier der folgenden fünf Handlungsschritte bearbeiten:
1. Beschaffung und Konfiguration eines Servers
2. Einrichtung eines E-Mail-Servers und des DHCP-Dienstes
3. Einrichtung und Dokumentation einer Firewall
4. Rechtevergabe an Benutzer
5. Einführung von IPv6`,
    sections: [
        {
            id: "hs1",
            title: "Handlungsschritt 1: Server-Beschaffung (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs1-intro",
                    title: "Ausgangssituation - Virtualisierungsserver",
                    description: `In der DataCenter Solutions AG soll ein weiterer Server als Virtualisierungsplattform angeschafft werden.

Folgendes Angebot liegt vor (Ausschnitt):

SERVERKOMPONENTEN:
- Position 1: Dual-Socket-Rack-Server Intel Xeon E5-2620v4, 64 GiByte DDR4 ECC registered
- Position 2: LTO-Bandlaufwerk, 160 Mbit/s, 2.500 GiByte, SAS 6 Gbit/s
- Position 3: 2x SSD SATA, 6 Gbit/s, 480 GiByte, hot-plug-fähig, 2,5 Zoll
- Position 4: 6x HDD SAS, 12 Gbit/s, 900 GiByte, hot-plug-fähig, 2,5 Zoll
- Position 5: Hardware-RAID-Controller, SAS/SATA 12 Gbit/s, RAID-Level: 0, 1, 10, 5, 50, 6, 60
- Position 6: 2x hot-plug-Netzteil`,
                    type: "info",
                    points: 0,
                    hint: "Dies ist die Ausgangssituation für die folgenden Aufgaben.",
                },
                {
                    id: "hs1-a",
                    title: "Aufgabe a) Speichertypen erläutern (8 Punkte)",
                    description: `Im Angebot werden die folgenden Speicher genannt.

Erläutern Sie die vier genannten Speicher, indem Sie die Langform der Bezeichnung nennen und die Speichertechnik beschreiben.

Speichertypen:
- LTO
- SSD
- HDD
- DDR4`,
                    type: "freeText",
                    points: 8,
                    hint: "Wofür stehen die Abkürzungen? Welches physikalische Prinzip nutzt jeder Speichertyp?",
                },
                {
                    id: "hs1-b",
                    title: "Aufgabe b) RAID-Verbund konfigurieren (8 Punkte)",
                    description: `Das Speichersystem des Servers soll aus zwei RAID-Verbünden bestehen. Es stehen die Festplatten aus dem Angebot zur Verfügung.

ANFORDERUNGEN:
- Der RAID-Verbund für das Betriebssystem soll Ausfallsicherheit gewährleisten
- Der RAID-Verbund für die Datenspeicherung soll Ausfallsicherheit gewährleisten und zusätzlich größtmögliche Speicherkapazität bieten

Geben Sie zu jedem RAID-Verbund den entsprechenden RAID-Level und die dazugehörige Netto-Speicherkapazität an.

Der Rechenweg ist anzugeben.`,
                    type: "freeText",
                    points: 8,
                    hint: "Welche RAID-Level bieten Ausfallsicherheit? Welcher davon maximiert zusätzlich die Kapazität?",
                },
                {
                    id: "hs1-c",
                    title: "Aufgabe c) ECC-RAM erklären (3 Punkte)",
                    description: `Ein ECC-fähiger RAM kann Speicherfehler erkennen und korrigieren.

Nennen Sie die Speicherfehler, die erkannt werden können und die Speicherfehler, die erkannt und korrigiert werden können.`,
                    type: "freeText",
                    points: 3,
                    hint: "Unterscheiden Sie zwischen 1-Bit-Fehlern und Mehrbit-Fehlern.",
                },
                {
                    id: "hs1-d",
                    title: "Aufgabe d) Vorteile virtueller Server (6 Punkte)",
                    description: `Der Server dient als Virtualisierungsplattform für verschiedene Anwendungsserver.

Erläutern Sie drei Vorteile von virtuellen Servern gegenüber physischen Servern.`,
                    type: "freeText",
                    points: 6,
                    hint: "Denken Sie an Ressourcennutzung, Flexibilität und Wartung.",
                },
            ],
        },
        {
            id: "hs2",
            title: "Handlungsschritt 2: E-Mail und DHCP (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs2-a",
                    title: "Aufgabe a) IMAP vs. POP3 (4 Punkte)",
                    description: `Der E-Mailserver der DataCenter Solutions AG wird virtualisiert. Im Zuge dieser Konsolidierung sollen Dienste neu konfiguriert werden.

Der E-Mailserver soll von POP3 auf IMAP umgestellt werden.

Erläutern Sie zwei wesentliche Vorteile, die IMAP gegenüber POP3 bietet.`,
                    type: "freeText",
                    points: 4,
                    hint: "Wo werden die E-Mails gespeichert? Was passiert bei Zugriff von mehreren Geräten?",
                },
                {
                    id: "hs2-b",
                    title: "Aufgabe b) Sichere Übertragung (4 Punkte)",
                    description: `Es soll sichergestellt werden, dass Benutzername und Passwort nicht im Klartext übertragen werden.

Erläutern Sie eine entsprechende Möglichkeit unter Angabe des zu verwendenden Protokolls.`,
                    type: "freeText",
                    points: 4,
                    hint: "Welche Protokolle verschlüsseln die Verbindung? Welche Ports werden dann verwendet?",
                },
                {
                    id: "hs2-c",
                    title: "Aufgabe c) E-Mail-Versand beschreiben (6 Punkte)",
                    description: `Die folgende Grafik zeigt den Versand einer E-Mail von einem Mitarbeiter der DataCenter Solutions AG an einen Mitarbeiter der Kunde GmbH.

E-MAIL-VERSAND:
[Absender] → [Mailserver DataCenter] → [DNS-Server] → [Internet] → [Mailserver Kunde GmbH] → [Empfänger]
m.schmidt@datacenter.de                                                                      t.meyer@kunde.de

Nummerierung der Schritte:
1. Absender → Mailserver DataCenter
2. Mailserver DataCenter → DNS-Server
3. Mailserver DataCenter → Internet → Mailserver Kunde GmbH
4. Mailserver Kunde GmbH → Empfänger (bereits vorgegeben: "Push-Nachricht wird mit IMAP vom Mailserver an den Client übertragen")

Beschreiben Sie in folgender Tabelle die Schritte 1 bis 3 des E-Mail-Versands.`,
                    type: "freeText",
                    points: 6,
                    hint: "Welches Protokoll sendet E-Mails? Was fragt der Mailserver beim DNS-Server ab?",
                },
                {
                    id: "hs2-da",
                    title: "Aufgabe d-a) DHCP-Ablauf ergänzen (3 Punkte)",
                    description: `Im Netz der DataCenter Solutions AG ist ein DHCP-Server installiert.

Der Ablauf einer Anfrage eines DHCP-Clients an den DHCP-Server ist wie folgt:

1. DHCP-Discover
2. _______________
3. _______________
4. _______________

Ergänzen Sie die noch fehlenden Beschriftungen für die Schritte 2 bis 4.`,
                    type: "freeText",
                    points: 3,
                    hint: "DORA - wie lautet die Abkürzung ausgeschrieben?",
                },
                {
                    id: "hs2-db",
                    title: "Aufgabe d-b) DHCP-Parameter nennen (3 Punkte)",
                    description: `Nennen Sie drei Konfigurationsparameter, die der DHCP-Server den Clients anbietet.`,
                    type: "freeText",
                    points: 3,
                    hint: "Was benötigt ein Client außer der IP-Adresse für die Netzwerkkommunikation?",
                },
                {
                    id: "hs2-e",
                    title: "Aufgabe e) Honeypot erläutern (5 Punkte)",
                    description: `Die IT-Sicherheit im Netzwerk der DataCenter Solutions AG soll überwacht werden. Dies kann mit einem Honeypot realisiert werden.

Zu diesem Verfahren finden Sie folgenden Artikel:

"A honeypot is a computer system that is set up as a decoy to lure cyberattackers, and to detect, deflect or study attempts to gain unauthorized access to information systems. Generally, it consists of a computer, applications, and data that simulate the behavior of a real system that appears to be part of a network but is actually isolated and closely monitored. All communications with a honeypot are considered hostile, as there's no reason for legitimate users to access a honeypot. Viewing and logging this activity can provide an insight into the level and types of threat a network infrastructure faces while distracting attackers away from assets of real value."

Erläutern Sie die Funktionsweise eines Honeypots.`,
                    type: "freeText",
                    points: 5,
                    hint: "Was ist der Zweck eines Honeypots? Warum sind alle Zugriffe verdächtig?",
                },
            ],
        },
        {
            id: "hs3",
            title: "Handlungsschritt 3: Firewall-Konfiguration (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs3-a",
                    title: "Aufgabe a) UML-Sequenzdiagramm erstellen (10 Punkte)",
                    description: `In der DataCenter Solutions AG wird der Webserver durch eine Firewall in einer Demilitarisierten Zone (DMZ) geschützt.

Ergänzen Sie das Sequenzdiagramm für eine positiv gefilterte Anfrage an den Webserver von einem externen Client.

BETEILIGTE KOMPONENTEN:
- Client - Stellt Anfragen an Webserver
- Router des Providers - Leitet die Anfragen an die Firewall weiter, wenn ein Eintrag in der Routingtabelle existiert
- Firewall extern - Untersucht den Datenverkehr und verhindert nicht erwünschten Datenverkehr
- Webserver - Nimmt Anfragen an
- Firewall intern - (optional, falls vorhanden)

Zeichnen Sie die Nachrichten als Pfeile zwischen den Objektlebenslinien ein.`,
                    type: "diagram",
                    points: 10,
                    hint: "Welche Komponente prüft zuerst? In welcher Reihenfolge werden die Nachrichten weitergeleitet?",
                },
                {
                    id: "hs3-b",
                    title: "Aufgabe b) DMZ-Schutz erklären (3 Punkte)",
                    description: `Durch die DMZ ist das lokale Netzwerk der DataCenter Solutions AG gegenüber Angriffen aus dem Internet besser geschützt.

Beschreiben Sie die organisatorische Maßnahme, die diesen Schutz bewirkt.`,
                    type: "freeText",
                    points: 3,
                    hint: "Wie ist die DMZ im Netzwerk positioniert? Welche Trennung wird erreicht?",
                },
                {
                    id: "hs3-c",
                    title: "Aufgabe c) Firewall-Regeln erläutern (6 Punkte)",
                    description: `Für die externe Firewall der DataCenter Solutions AG wurden folgende Regeln aufgestellt:

FIREWALL-REGELN:
- Regel 1: Permit | TCP | ANY | Webserver DataCenter | >1023 | 80 | Internet | IN
- Regel 2: Permit | TCP | ANY | Webserver DataCenter | >1023 | 443 | Internet | IN
- Regel 99: Deny | IP | ANY | ANY | - | - | Internet | IN

Erläutern Sie die Regeln 1, 2 und 99.`,
                    type: "freeText",
                    points: 6,
                    hint: "Welche Dienste laufen auf Port 80 und 443? Was bedeutet die letzte Regel?",
                },
                {
                    id: "hs3-d",
                    title: "Aufgabe d) SPI-Firewall (2 Punkte)",
                    description: `Eine Stateful Packet Inspection Firewall (SPI-Firewall) hat gegenüber einem reinen Paketfilter weitere Sicherheitsmerkmale.

Nennen Sie die Bezeichnung eines Feldes im TCP-Header, welches nur von der SPI-Firewall analysiert wird.`,
                    type: "freeText",
                    points: 2,
                    hint: "Welche TCP-Flags zeigen den Verbindungsstatus an?",
                },
                {
                    id: "hs3-e",
                    title: "Aufgabe e) HTTP Proxy erklären (4 Punkte)",
                    description: `In der DataCenter Solutions AG wird diskutiert, einen HTTP Proxy einzusetzen.

Erläutern Sie eine grundsätzliche Funktion eines HTTP Proxy.`,
                    type: "freeText",
                    points: 4,
                    hint: "Was macht ein Proxy mit den Anfragen der Clients? Welche Vorteile bietet das?",
                },
            ],
        },
        {
            id: "hs4",
            title: "Handlungsschritt 4: Rechtevergabe (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs4-intro",
                    title: "Ausgangssituation - Benutzergruppen und Berechtigungen",
                    description: `Sie sollen für das lokale Netzwerk der DataCenter Solutions AG folgende Aufgaben erledigen:
- Zugriffsrechte für den Ordner "Projekte" ermitteln und festlegen
- Eine neue Passwortrichtlinie implementieren

Die Beschäftigten der DataCenter Solutions AG sind sechs Benutzergruppen zugeordnet:

BENUTZERGRUPPEN:
- Angestellte (MA01 bis MA99) - Festangestellte Mitarbeiter
- Auszubildende (AZ01 bis AZ19) - Mitarbeiter in Ausbildung
- Praktikanten (PR01 bis PR19) - Mitarbeiter im Praktikum
- OrdnerAdmins (MA15, MA25, MA35) - Administratoren für Ordnerberechtigungen
- ITAdmins (MA10, MA19, MA29) - IT-Administratoren
- Befristete (AZ01 bis AZ19, PR01 bis PR19) - Alle Mitarbeiter mit befristetem Vertrag

BERECHTIGUNGEN IM DATEISYSTEM:
- Read - Datei lesen und Attribute anzeigen
- Write - Datei überschreiben und Attribute ändern
- Read & Execute - Anwendung ausführen, zusätzlich alle Read-Rechte
- Modify - Datei löschen, zusätzlich alle Read-, Write- und Execute-Rechte
- Full Control - Berechtigungen ändern, zusätzlich alle anderen Rechte

VERGEBENE BERECHTIGUNGEN FÜR ORDNER "PROJEKTE":
- Angestellte: Ändern (Modify), Schreiben, Lesen
- Befristete: Lesen
- OrdnerAdmins: Ändern (Modify)
- ITAdmins: Vollzugriff`,
                    type: "info",
                    points: 0,
                    hint: "Dies ist die Ausgangssituation für die folgenden Aufgaben.",
                },
                {
                    id: "hs4-aa",
                    title: "Aufgabe a-a) Löschberechtigung ermitteln (4 Punkte)",
                    description: `Im Ordner "Projekte" werden auch ausführbare Programmdateien gespeichert.

Nennen Sie die Benutzergruppen, die berechtigt sind, Dateien zu löschen.`,
                    type: "freeText",
                    points: 4,
                    hint: "Welche Berechtigungsstufe erlaubt das Löschen von Dateien?",
                },
                {
                    id: "hs4-ab",
                    title: "Aufgabe a-b) Berechtigungen für Mitarbeiter MA44 (5 Punkte)",
                    description: `Ermitteln Sie die Aktionen, zu der der Mitarbeiter MA44 berechtigt ist.`,
                    type: "freeText",
                    points: 5,
                    hint: "Zu welcher Gruppe gehört MA44? Welche Berechtigungen hat diese Gruppe?",
                },
                {
                    id: "hs4-ac",
                    title: "Aufgabe a-c) Berechtigungen für Praktikant PR10 (5 Punkte)",
                    description: `Ermitteln Sie die Aktionen, zu denen der Praktikant PR10 berechtigt ist.`,
                    type: "freeText",
                    points: 5,
                    hint: "In welchen Gruppen ist PR10 Mitglied? Was ist die effektive Berechtigung?",
                },
                {
                    id: "hs4-ad",
                    title: "Aufgabe a-d) Berechtigung per Kommandozeile (3 Punkte)",
                    description: `Einem Benutzer können mit dem Kommandozeilenbefehl "dacl" Berechtigungen gewährt oder entzogen werden.

Syntax: dacl [/Pfad] [/Aktion] [/Benutzer oder Benutzergruppe] [/Berechtigung]

Parameter:
- Pfad: Dateiname oder Ordnername
- Aktion: grant = Gewähren, revoke = Entziehen
- Benutzer: Name des Benutzers oder der Benutzergruppe
- Berechtigung: F = Vollzugriff, M = Ändern, W = Schreiben, RX = Lesen und Ausführen, R = Lesen, N = Kein Zugriff

Mitarbeiter MA25 soll die Berechtigung zum Lesen und Ausführen von Dateien im Ordner "d:\\Projekte" erhalten.

Erstellen Sie die entsprechende Anweisung.`,
                    type: "code",
                    points: 3,
                    hint: "Welche Aktion und welcher Berechtigungsparameter sind erforderlich?",
                },
                {
                    id: "hs4-b",
                    title: "Aufgabe b) Passwort-Richtlinie implementieren (8 Punkte)",
                    description: `Sie arbeiten an der Umsetzung einer neuen Passwort-Richtlinie mit.

Demnach muss jedes Passwort drei der folgenden vier Bedingungen erfüllen:
- Enthält mindestens vier Großbuchstaben (GrBu)
- Enthält mindestens drei Kleinbuchstaben (KlBu)
- Enthält mindestens zwei Sonderzeichen (SoZe)
- Enthält mindestens eine Ziffer (Ziff)

Erstellen Sie eine if-Anweisung, mit der überprüft werden kann, ob ein Passwort der Richtlinie entspricht.

Hinweis:
Verwenden Sie dazu:
- die logischen Variablen GrBu, KlBu, SoZe und Ziff (true, wenn Bedingung erfüllt ist)
- die logischen Operatoren || für logisch ODER und && für logisch UND
- die Syntax der if-Anweisung: if (logische Bedingung) { ... } else { ... };`,
                    type: "code",
                    points: 8,
                    hint: "Wie formulieren Sie 'mindestens 3 von 4 Bedingungen müssen erfüllt sein'?",
                },
            ],
        },
        {
            id: "hs5",
            title: "Handlungsschritt 5: IPv6-Einführung (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs5-intro",
                    title: "Ausgangssituation - IPv6-Vorbereitung",
                    description: `Die DataCenter Solutions AG möchte ihr Netzwerk für IPv6 vorbereiten. Sie sollen bei der Vorbereitung mitwirken.

In einem Handbuch zu IPv6 werden folgende Fachbegriffe erläutert.`,
                    type: "info",
                    points: 0,
                    hint: "Dies ist die Ausgangssituation für die folgenden Aufgaben.",
                },
                {
                    id: "hs5-aa",
                    title: "Aufgabe a-a) Link Local Address erklären (2 Punkte)",
                    description: `Link Local Address (FE80::/10):

"This address is found on each IPv6 interface after stateless auto-configuration. Packets using link-local addressing will never pass a router."

Geben Sie die Erläuterung sinngemäß in Deutsch wieder.`,
                    type: "freeText",
                    points: 2,
                    hint: "Wann wird diese Adresse vergeben? Wie weit reicht ihre Gültigkeit?",
                },
                {
                    id: "hs5-ab",
                    title: "Aufgabe a-b) Unique Local Unicast erklären (2 Punkte)",
                    description: `Unique Local Unicast (FC00::/7):

"An identifier for a network or host. Can be used to build a private network, like the private network address space (10.x.x.x) in IPv4."

Geben Sie die Erläuterung sinngemäß in Deutsch wieder.`,
                    type: "freeText",
                    points: 2,
                    hint: "Mit welchem IPv4-Bereich ist diese Adresse vergleichbar?",
                },
                {
                    id: "hs5-ac",
                    title: "Aufgabe a-c) Global Unicast Address erklären (2 Punkte)",
                    description: `Global Unicast Address (2000::/3):

"This address is the analogue of the normal IPv4 Addresses. Identifies a unique interface."

Geben Sie die Erläuterung sinngemäß in Deutsch wieder.`,
                    type: "freeText",
                    points: 2,
                    hint: "Welche Funktion haben öffentliche IPv4-Adressen?",
                },
                {
                    id: "hs5-ad",
                    title: "Aufgabe a-d) Neighbor Discovery erklären (3 Punkte)",
                    description: `IPv6 Neighbor Discovery:

"Replaces the address resolution protocol (ARP) in IPv4. For example the Neighbor Discovery Protocol is responsible for stateless auto-configuration, duplicate address detection and finds the link layer address of another node. Using multicast, Neighbor Discovery Protocol avoids broadcasts."

Geben Sie die Erläuterung sinngemäß in Deutsch wieder.`,
                    type: "freeText",
                    points: 3,
                    hint: "Welches IPv4-Protokoll wird ersetzt? Welche Vorteile bietet NDP?",
                },
                {
                    id: "hs5-b",
                    title: "Aufgabe b) Unique Local Unicast Netzwerk-ID (4 Punkte)",
                    description: `Ermitteln Sie die letzte /64 Netzwerk-ID des Adressbereiches der Unique Local Unicast Adressen.`,
                    type: "freeText",
                    points: 4,
                    hint: "Wo endet der FC00::/7 Bereich? Was ist die letzte /64 darin?",
                },
                {
                    id: "hs5-c",
                    title: "Aufgabe c) IPv6-Adressen aus Trace ermitteln (6 Punkte)",
                    description: `In einem IPv6-Testnetzwerk mit dem Präfix /32 wurde der Datenverkehr mithilfe eines Protokollanalysators aufgezeichnet.

TRACE (Hexadezimal):
60 00 00 00 40 3A 40 FC 00 01 01 00 00 00 00
00 00 AF C1 00 B8 00 51 FC 00 00 03 00 00 00 00
00 00 00 BE FE 30 01 F0 81 00 A4 6B 0C 1C 00 41
52 0F 36 47 9F 89 0C 00 08 09 0A 0B 0E 0F 10 11

IPv6-HEADER-AUFBAU:
- Version (4 Bit)
- Traffic Class (8 Bit)
- Flow Label (20 Bit)
- Payload Length (16 Bit)
- Next Header (8 Bit)
- Hop Limit (8 Bit)
- Source Address (128 Bit)
- Destination Address (128 Bit)

c-a) Ermitteln Sie die IPv6-Senderadresse. (3 Punkte)
c-b) Ermitteln Sie die IPv6-Empfängeradresse. (3 Punkte)`,
                    type: "freeText",
                    points: 6,
                    hint: "Zählen Sie die Bytes im Header. Nach welchem Offset beginnen die Adressen?",
                },
                {
                    id: "hs5-d",
                    title: "Aufgabe d) IPv6-Adresse für neuen Rechner (6 Punkte)",
                    description: `Sie sollen einen weiteren Rechner manuell konfigurieren. Dieser soll mit dem Rechner im Testnetzwerk (siehe Trace) kommunizieren können.

Der Standardgateway hat die erste mögliche Adresse im Netzwerk.

d-a) Ermitteln Sie eine mögliche IPv6-Adresse für den Rechner. (3 Punkte)
d-b) Ermitteln Sie die IPv6-Adresse für den Standardgateway. (3 Punkte)`,
                    type: "freeText",
                    points: 6,
                    hint: "Welches Netzwerk verwenden die Rechner im Trace? Was ist die erste Host-Adresse?",
                },
            ],
        },
    ],
};