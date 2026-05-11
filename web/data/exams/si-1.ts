import { Exam } from "../exam-types";

export const si1: Exam = {
    id: "si-1",
    title: "SI Prüfung 1 - Sommer 2017",
    year: 2017,
    season: "Sommer",
    company: "MediTech Solutions GmbH",
    duration: 90,
    totalPoints: 100,
    level: "ap2",
    fachrichtung: "si",
    sectionsToChoose: 4,
    scenario: `Sie sind Mitarbeiter/-in der MediTech Solutions GmbH in Hannover, einem mittelständischen Unternehmen für Medizintechnik-Software.

Das Unternehmen ist in ein neues Bürogebäude umgezogen und Sie sollen die IT-Infrastruktur aufbauen und optimieren.

Sie sollen vier der folgenden fünf Handlungsschritte bearbeiten:
1. Das Netzwerk segmentieren und absichern
2. Eine WLAN-Infrastruktur für Mitarbeiter und Besucher einrichten
3. Die Benutzerverwaltung im Active Directory automatisieren
4. Ein IT-Sicherheitskonzept umsetzen
5. Ein zentrales Storage-System planen und konfigurieren`,
    sections: [
        {
            id: "hs1",
            title: "Handlungsschritt 1: Netzwerksegmentierung (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs1-intro",
                    title: "Ausgangssituation - Netzwerkplanung",
                    description: `Für das neue Gebäude soll das Netzwerk in verschiedene Segmente aufgeteilt werden. 

Die geplante VLAN-Struktur und der Netzwerkaufbau sind im folgenden Diagramm dargestellt:`,
                    type: "info",
                    points: 0,
                    image: "/images/si1-netzwerk.png",
                },
                {
                    id: "hs1-a",
                    title: "Aufgabe a) Verfügbare Hosts im Server-VLAN (3 Punkte)",
                    description: `Berechnen Sie, wie viele Hosts im VLAN 30 (Server) adressiert werden können.

Gegeben: 10.10.30.0/27

Geben Sie den Rechenweg an.`,
                    type: "freeText",
                    points: 3,
                    hint: "Wie viele Bits bleiben für den Hostanteil? Welche Adressen sind reserviert?",
                },
                {
                    id: "hs1-b",
                    title: "Aufgabe b) Trunk-Verbindungen erklären (4 Punkte)",
                    description: `Die Access-Switches sind über Uplinks mit dem Core-Switch verbunden. Auf diesen Verbindungen müssen die Ethernet-Frames mit VLAN-Tags versehen werden.

Erklären Sie, warum das Tagging auf den Uplink-Verbindungen notwendig ist und welcher Standard dafür verwendet wird.`,
                    type: "freeText",
                    points: 4,
                    hint: "Was passiert, wenn Frames aus verschiedenen VLANs über eine gemeinsame Leitung transportiert werden?",
                },
                {
                    id: "hs1-ca",
                    title: "Aufgabe c-a) DHCP-Problem analysieren (2 Punkte)",
                    description: `Der DHCP-Server befindet sich im VLAN 30. Bei einem Test-PC im VLAN 20 (Entwicklung) zeigt die IP-Konfiguration:

IPv4-Adresse: 169.254.178.55
Subnetzmaske: 255.255.0.0

Die PCs in VLAN 30 erhalten ihre IP-Konfiguration problemlos per DHCP.

Erklären Sie die Ursache für die angezeigte IP-Adresse.`,
                    type: "freeText",
                    points: 2,
                    hint: "Was bedeutet eine 169.254.x.x Adresse? Was passiert mit Broadcasts an VLAN-Grenzen?",
                },
                {
                    id: "hs1-cb",
                    title: "Aufgabe c-b) Lösungsvorschlag DHCP (2 Punkte)",
                    description: `Beschreiben Sie eine Lösung, damit PCs im VLAN 20 ihre IP-Konfiguration vom zentralen DHCP-Server erhalten können.`,
                    type: "freeText",
                    points: 2,
                    hint: "Wie können Broadcasts über VLAN-Grenzen hinweg weitergeleitet werden?",
                },
                {
                    id: "hs1-da",
                    title: "Aufgabe d-a) Routing-Tabelle vervollständigen (3 Punkte)",
                    description: `Auf dem Core-Switch wurde folgende Routing-Tabelle eingerichtet:

ROUTING-TABELLE CORE-SWITCH:
- 10.10.10.0/24 → Interface VLAN10
- 10.10.20.0/24 → Interface VLAN20
- 10.10.30.0/27 → Interface VLAN30
- 10.10.40.0/24 → Interface VLAN40

Für den Internetzugang fehlt noch ein Eintrag.

Ergänzen Sie die Default-Route mit:
- Zielnetzwerk
- Subnetzmaske
- Next-Hop-Adresse`,
                    type: "freeText",
                    points: 3,
                    hint: "Welche Route fängt alle Pakete auf, die nicht explizit geroutet werden können?",
                },
                {
                    id: "hs1-db",
                    title: "Aufgabe d-b) Routing-Problem beheben (4 Punkte)",
                    description: `Ein PC im Büro-VLAN (10.10.10.50) kann den Webserver in der DMZ (10.20.2.2) nicht erreichen. Ein Ping zur Firewall (10.20.1.1) funktioniert.

Die Routing-Tabelle der Firewall zeigt:
- 10.20.1.0/30 → LAN-Interface
- 10.20.2.0/29 → DMZ-Interface
- 10.10.20.0/24 → Gateway 10.20.1.2
- 10.10.30.0/27 → Gateway 10.20.1.2
- 10.10.40.0/24 → Gateway 10.20.1.2
- 0.0.0.0/0 → WAN-Interface

Analysieren Sie das Problem und beschreiben Sie die Lösung.`,
                    type: "freeText",
                    points: 4,
                    hint: "Vergleichen Sie die vorhandenen Routen mit allen VLANs. Kann die Antwort zurück zum Absender finden?",
                },
                {
                    id: "hs1-e",
                    title: "Aufgabe e) Firewall-Regeln interpretieren (7 Punkte)",
                    description: `Auf der Firewall wurden folgende Regeln für ausgehenden Traffic aus dem Büro-VLAN konfiguriert:

FIREWALL-REGELN (VLAN 10 → Internet):
Nr | Aktion | Proto | Quelle         | Ziel | Quell-Port | Ziel-Port
---|--------|-------|----------------|------|------------|----------
1  | ALLOW  | TCP   | 10.10.10.0/24  | any  | >1023      | 443
2  | ALLOW  | TCP   | 10.10.10.0/24  | any  | >1023      | 80
3  | ALLOW  | UDP   | 10.10.10.0/24  | any  | >1023      | 53
4  | ALLOW  | TCP   | 10.10.10.0/24  | any  | >1023      | 587
5  | ALLOW  | TCP   | 10.10.10.0/24  | any  | >1023      | 993
99 | DENY   | any   | any            | any  | any        | any

Erläutern Sie jede Regel (1-5 und 99) mit eigenen Worten. Nennen Sie bei den Regeln 1-5 auch den typischen Anwendungsfall.`,
                    type: "freeText",
                    points: 7,
                    hint: "Welche Dienste nutzen diese Standard-Ports? Was bedeutet die letzte Regel für nicht aufgeführte Verbindungen?",
                },
            ],
        },
        {
            id: "hs2",
            title: "Handlungsschritt 2: WLAN-Infrastruktur (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs2-a",
                    title: "Aufgabe a) WLAN-Betriebsmodi unterscheiden (3 Punkte)",
                    description: `Für das Unternehmen sollen mehrere WLAN-Access-Points installiert werden.

Erklären Sie den Unterschied zwischen dem Infrastruktur-Modus und dem Ad-hoc-Modus bei WLAN-Netzwerken.`,
                    type: "freeText",
                    points: 3,
                    hint: "Welche Rolle spielt der Access Point bei den beiden Modi?",
                },
                {
                    id: "hs2-b",
                    title: "Aufgabe b) RADIUS-Authentifizierung - AAA (3 Punkte)",
                    description: `Die Mitarbeiter sollen sich am WLAN mit ihren Active-Directory-Zugangsdaten anmelden. Dafür wird ein RADIUS-Server eingesetzt.

RADIUS implementiert das AAA-Prinzip. Nennen Sie die drei Komponenten, für die AAA steht, und erklären Sie diese kurz.`,
                    type: "freeText",
                    points: 3,
                    hint: "AAA beschreibt drei zentrale Sicherheitsfunktionen: Wer bist du? Was darfst du? Was hast du getan?",
                },
                {
                    id: "hs2-c",
                    title: "Aufgabe c) Versteckte SSID bewerten (3 Punkte)",
                    description: `Ein Kollege schlägt vor, die SSID des Mitarbeiter-WLANs zu verstecken, um die Sicherheit zu erhöhen.

Bewerten Sie diesen Vorschlag und begründen Sie Ihre Einschätzung.`,
                    type: "freeText",
                    points: 3,
                    hint: "Wird die SSID wirklich komplett versteckt? Was passiert bei der Verbindungsaufnahme?",
                },
                {
                    id: "hs2-d",
                    title: "Aufgabe d) 802.1X-Komponenten zuordnen (7 Punkte)",
                    description: `Bei der WLAN-Authentifizierung nach IEEE 802.1X sind drei Rollen beteiligt:

- Supplicant - Das Gerät, das Zugang zum Netzwerk möchte
- Authenticator - Das Gerät, das den Zugang kontrolliert
- Authentication Server - Der Server, der die Anmeldedaten prüft

Der Ablauf ist wie folgt:
1. Der Supplicant sendet seine Anmeldedaten an den Authenticator
2. Der Authenticator leitet die Daten an den Authentication Server weiter
3. Der Authentication Server prüft die Daten und sendet das Ergebnis zurück
4. Bei Erfolg schaltet der Authenticator den Port frei

AUFGABE:
Ordnen Sie die drei Rollen den Geräten in Ihrem Netzwerk zu und beschreiben Sie den Kommunikationsablauf mit den verwendeten Protokollen.

Verfügbare Geräte:
- Notebook des Mitarbeiters
- WLAN-Access-Point
- RADIUS-Server`,
                    type: "freeText",
                    points: 7,
                    hint: "Welches Gerät möchte Zugang, welches kontrolliert und welches entscheidet? Welches Protokoll wird zwischen AP und RADIUS verwendet?",
                },
                {
                    id: "hs2-ea",
                    title: "Aufgabe e-a) WLAN-Störquellen identifizieren (4 Punkte)",
                    description: `In einem Besprechungsraum ist der WLAN-Empfang trotz nahem Access Point schlecht. 

Nennen Sie vier mögliche Ursachen, die den WLAN-Empfang negativ beeinflussen können.`,
                    type: "freeText",
                    points: 4,
                    hint: "Denken Sie an bauliche, elektronische und funktechnische Störquellen.",
                },
                {
                    id: "hs2-eb",
                    title: "Aufgabe e-b) WLAN-Optimierung vorschlagen (3 Punkte)",
                    description: `Nennen Sie drei Maßnahmen, um den WLAN-Empfang im Besprechungsraum zu verbessern.`,
                    type: "freeText",
                    points: 3,
                    hint: "Welche Hardware-Lösungen und Konfigurationsänderungen könnten helfen?",
                },
                {
                    id: "hs2-ec",
                    title: "Aufgabe e-c) Optimale AP-Position bestimmen (2 Punkte)",
                    description: `Sie haben einen Grundriss mit drei Bereichen:
- Bereich A: Guter Empfang (nähe zum Router)
- Bereich B: Mäßiger Empfang (durch eine Trockenbauwand)
- Bereich C: Schlechter Empfang (durch zwei Wände)

Beschreiben Sie, wo Sie einen WLAN-Repeater oder zusätzlichen Access Point positionieren würden, um Bereich C optimal zu versorgen.`,
                    type: "freeText",
                    points: 2,
                    hint: "Ein Repeater benötigt selbst ein gutes Signal. Wo ist der beste Kompromiss?",
                },
            ],
        },
        {
            id: "hs3",
            title: "Handlungsschritt 3: Benutzerverwaltung (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs3-intro",
                    title: "Ausgangssituation - Active Directory Automatisierung",
                    description: `Bei der MediTech Solutions GmbH sollen neue Mitarbeiter automatisiert im Active Directory angelegt werden. Die Personalabteilung stellt eine Excel-Datei mit den Mitarbeiterdaten bereit.

ANFORDERUNGEN AN DAS SKRIPT:
- Aus Vor- und Nachname wird der Benutzername gebildet: erster Buchstabe Vorname + Nachname (kleingeschrieben)
- Die E-Mail-Adresse folgt dem gleichen Schema: benutzername@meditech-solutions.de
- Umlaute werden ersetzt: ä→ae, ö→oe, ü→ue, ß→ss
- Initiales Passwort: "Willkommen2024!"
- Benutzer wird der Abteilungsgruppe zugeordnet
- Passwortänderung bei erster Anmeldung erzwingen

BEISPIEL:
Eingabe: Thomas Müller, Abteilung: Entwicklung
→ Benutzername: tmueller
→ E-Mail: tmueller@meditech-solutions.de
→ Gruppe: GRP_Entwicklung`,
                    type: "info",
                    points: 0,
                    hint: "Dies ist die Ausgangssituation für die folgenden Aufgaben.",
                },
                {
                    id: "hs3-a",
                    title: "Aufgabe a) Algorithmus für Benutzeranlage (14 Punkte)",
                    description: `Entwickeln Sie einen Algorithmus (Pseudocode, Struktogramm oder Flussdiagramm) für das Skript zur automatischen Benutzeranlage.

Berücksichtigen Sie:
1. Einlesen der Mitarbeiterdaten aus der Datei
2. Umwandlung der Umlaute
3. Generierung von Benutzername und E-Mail
4. Anlegen des Benutzers mit Passwort
5. Hinzufügen zur Abteilungsgruppe
6. Fehlerbehandlung bei doppelten Benutzernamen`,
                    type: "code",
                    points: 14,
                    hint: "Verwenden Sie eine Schleife über alle Zeilen. Was passiert bei Namenskollisionen (z.B. zwei Max Müller)?",
                },
                {
                    id: "hs3-b",
                    title: "Aufgabe b) Umlaute in Benutzernamen (4 Punkte)",
                    description: `Erklären Sie, warum Umlaute und Sonderzeichen in Benutzernamen und E-Mail-Adressen vermieden werden sollten.`,
                    type: "freeText",
                    points: 4,
                    hint: "Denken Sie an Kompatibilität, internationale Tastaturen und technische Standards.",
                },
                {
                    id: "hs3-c",
                    title: "Aufgabe c) Vorteile von Sicherheitsgruppen (4 Punkte)",
                    description: `Im Active Directory sollen die Benutzer abteilungsspezifischen Sicherheitsgruppen zugeordnet werden (z.B. GRP_Entwicklung, GRP_Vertrieb).

Erläutern Sie vier Vorteile dieser Gruppenstruktur für die Administration.`,
                    type: "freeText",
                    points: 4,
                    hint: "Vergleichen Sie: Rechte pro Benutzer vs. Rechte pro Gruppe. Was passiert bei Abteilungswechsel?",
                },
                {
                    id: "hs3-d",
                    title: "Aufgabe d) Passwortrichtlinien definieren (3 Punkte)",
                    description: `Für das Active Directory sollen Passwortrichtlinien definiert werden.

Nennen Sie drei sinnvolle Regeln für sichere Passwörter und begründen Sie diese kurz.`,
                    type: "freeText",
                    points: 3,
                    hint: "Welche Faktoren machen ein Passwort schwer zu erraten oder zu knacken?",
                },
            ],
        },
        {
            id: "hs4",
            title: "Handlungsschritt 4: IT-Sicherheitskonzept (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs4-a",
                    title: "Aufgabe a) Schutzmaßnahmen kategorisieren (8 Punkte)",
                    description: `IT-Sicherheitsmaßnahmen lassen sich in vier Kategorien einteilen:

- Technisch-logisch (Software, Konfiguration)
- Technisch-physisch (Hardware, Gebäude)
- Organisatorisch (Prozesse, Richtlinien)
- Personell (Schulung, Awareness)

Für jede Kategorie ist bereits ein Beispiel gegeben. Ergänzen Sie jeweils eine weitere Maßnahme mit Erläuterung.

BEISPIELE:
Technisch-logisch: Firewall
→ Kontrolliert Netzwerkverkehr nach definierten Regeln

Technisch-physisch: USV (Unterbrechungsfreie Stromversorgung)
→ Überbrückt Stromausfälle, ermöglicht sicheres Herunterfahren

Organisatorisch: Backup-Konzept
→ Regelmäßige Datensicherung nach definiertem Plan

Personell: Security-Awareness-Training
→ Mitarbeiter erkennen Phishing und Social Engineering`,
                    type: "freeText",
                    points: 8,
                    hint: "Überlegen Sie für jede Kategorie: Welche anderen Bedrohungen gibt es und wie schützt man sich davor?",
                },
                {
                    id: "hs4-b",
                    title: "Aufgabe b) Datenschutzschulung planen (5 Punkte)",
                    description: `Sie sollen eine Schulung zum Thema "Umgang mit personenbezogenen Daten" für alle Mitarbeiter vorbereiten.

Nennen Sie fünf Aspekte, die Sie bei Planung und Durchführung berücksichtigen sollten.`,
                    type: "freeText",
                    points: 5,
                    hint: "Denken Sie an Zielgruppe, Inhalte, Format, Materialien und Erfolgskontrolle.",
                },
                {
                    id: "hs4-c",
                    title: "Aufgabe c) USV-Dimensionierung berechnen (6 Punkte)",
                    description: `Ein Server wird mit einer USV abgesichert. Die USV kann den Ladestand des Akkus auslesen.

GEGEBENE WERTE:
- USV-Kapazität: 1000 VA bei vollem Akku für 30 Minuten
- Server-Leistungsaufnahme: 400 W
- Zeit für sauberes Herunterfahren: 8 Minuten
- Minimaler Akku-Ladestand zum Schutz des Akkus: 30%

Berechnen Sie, bei welchem Akku-Ladestand (in Prozent) der Shutdown automatisch eingeleitet werden muss.

Hinweis: Rechnen Sie mit 1 VA = 1 W. Geben Sie den Rechenweg an.`,
                    type: "freeText",
                    points: 6,
                    hint: "Berechnen Sie zuerst die Gesamtkapazität in Wh, dann den Energiebedarf für den Shutdown.",
                },
                {
                    id: "hs4-da",
                    title: "Aufgabe d-a) Snapshot-Limitierung erklären (2 Punkte)",
                    description: `Für die Datensicherung wird vorgeschlagen, täglich einen Snapshot des Dateiservers zu erstellen.

Erklären Sie, warum Snapshots allein keine vollwertige Backup-Strategie darstellen.`,
                    type: "freeText",
                    points: 2,
                    hint: "Wo wird ein Snapshot gespeichert? Was passiert bei einem Hardware-Defekt des Storage-Systems?",
                },
                {
                    id: "hs4-db",
                    title: "Aufgabe d-b) Backup-Strategie mit Snapshots (4 Punkte)",
                    description: `Es wird vorgeschlagen, Snapshots mit einer anschließenden Sicherung auf ein separates System zu kombinieren.

Erläutern Sie die Vorteile dieser kombinierten Strategie.`,
                    type: "freeText",
                    points: 4,
                    hint: "Welche Vorteile bietet der Snapshot während des Backups? Was erreicht man durch die räumliche Trennung?",
                },
            ],
        },
        {
            id: "hs5",
            title: "Handlungsschritt 5: Storage-System (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs5-intro",
                    title: "Ausgangssituation - NAS-Systeme",
                    description: `Für die MediTech Solutions GmbH sollen zwei NAS-Systeme beschafft werden:

- NAS-A: Hochperformanter Speicher für aktive Projektdaten
- NAS-B: Kosteneffizienter Speicher für Archivierung und Backup`,
                    type: "info",
                    points: 0,
                    hint: "Dies ist die Ausgangssituation für die folgenden Aufgaben.",
                },
                {
                    id: "hs5-aa",
                    title: "Aufgabe a-a) RAID-10 Kosten berechnen (4 Punkte)",
                    description: `NAS-A soll als RAID-10-Verbund mit einer Nettokapazität von 8 TiB konfiguriert werden. Dafür sind vier identische Festplatten vorgesehen.

Das Budget für die Festplatten beträgt maximal 25 Cent pro GiB Nettokapazität.

Berechnen Sie den maximalen Preis pro Festplatte.
Der Rechenweg ist anzugeben.`,
                    type: "freeText",
                    points: 4,
                    hint: "Wie viel Prozent der Bruttokapazität steht bei RAID-10 als Nettokapazität zur Verfügung?",
                },
                {
                    id: "hs5-ab",
                    title: "Aufgabe a-b) RAID-6 Kosten berechnen (4 Punkte)",
                    description: `NAS-B soll als RAID-6-Verbund mit einer Nettokapazität von 32 TiB konfiguriert werden. Dafür sind acht identische Festplatten vorgesehen.

Das Budget für die Festplatten beträgt maximal 8 Cent pro GiB Nettokapazität.

Berechnen Sie den maximalen Preis pro Festplatte.
Der Rechenweg ist anzugeben.`,
                    type: "freeText",
                    points: 4,
                    hint: "Bei RAID-6 gehen zwei Festplatten für Parität verloren. Wie groß muss jede Festplatte sein?",
                },
                {
                    id: "hs5-b",
                    title: "Aufgabe b) Energieeffizienz bei NAS-Systemen (4 Punkte)",
                    description: `NAS-B soll besonders energieeffizient betrieben werden, da es primär als Archivspeicher dient.

Nennen Sie zwei technische Maßnahmen, um den Energieverbrauch des NAS-Systems zu reduzieren, und erläutern Sie diese.`,
                    type: "freeText",
                    points: 4,
                    hint: "Was verbraucht bei einem NAS am meisten Strom? Wie kann man das bei seltenen Zugriffen optimieren?",
                },
                {
                    id: "hs5-c",
                    title: "Aufgabe c) Deduplizierung erklären (5 Punkte)",
                    description: `Auf NAS-B soll zur Speicherplatzoptimierung Deduplizierung aktiviert werden.

Erklären Sie das Prinzip der Datendeduplizierung und nennen Sie einen typischen Anwendungsfall, bei dem besonders hohe Einsparungen erzielt werden.`,
                    type: "freeText",
                    points: 5,
                    hint: "Wie werden identische Datenblöcke erkannt? Bei welchen Daten gibt es viele Duplikate?",
                },
                {
                    id: "hs5-d",
                    title: "Aufgabe d) Speicheroptimierungs-Algorithmus (8 Punkte)",
                    description: `Um den Speicherplatz auf NAS-A (Hochleistung) zu optimieren, sollen selten genutzte Daten automatisch auf NAS-B (Archiv) verschoben werden.

REGELN:
- Bei weniger als 40% Belegung auf NAS-A:
  → Dateien verschieben, auf die seit 180 Tagen nicht zugegriffen wurde

- Bei Belegung zwischen 40% und 70% auf NAS-A:
  → Dateien verschieben, auf die seit 60 Tagen nicht zugegriffen wurde

- Bei mehr als 70% Belegung auf NAS-A:
  → Dateien verschieben, auf die seit 14 Tagen nicht zugegriffen wurde

Entwickeln Sie einen Algorithmus (Pseudocode oder Struktogramm), der diese Regeln umsetzt.

Verwenden Sie diese vordefinierten Anweisungen:
1. ErmittleBelegung(NAS-A)
2. VerschiebeDateien(Quelle, Ziel, MaxAlterInTagen)`,
                    type: "code",
                    points: 8,
                    hint: "Nutzen Sie verschachtelte Wenn-Dann-Bedingungen basierend auf dem Belegungswert.",
                },
            ],
        },
    ],
};