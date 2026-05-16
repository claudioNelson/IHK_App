import { Exam } from "../exam-types";

export const ap1_2: Exam = {
    id: "ap1-2",
    title: "AP1 Übungsprüfung 2 - Frühjahr 2024",
    year: 2024,
    season: "Sommer",
    company: "Architekturbüro Hartmann & Partner",
    duration: 90,
    totalPoints: 100,
    level: "ap1",
    fachrichtung: "shared",
    difficulty: "mittel",
    tags: ["nutzwertanalyse", "netzwerk", "osi", "ipv6", "malware", "backup"],
    scenario: `Sie sind Mitarbeiter/-in der TechVisuell Studios GmbH, einem IT-Systemhaus mit Schwerpunkt auf Hardware-Lösungen für Medien-, Design- und Visualisierungsbetriebe.

Ein Kunde der TechVisuell Studios GmbH ist das Architekturbüro Hartmann & Partner, das anspruchsvolle 3D-Visualisierungen für Bauherren und Investoren erstellt. Das Büro wächst und benötigt eine neue Renderfarm-Workstation-Ausstattung sowie eine sichere Netzwerk- und Mobile-Working-Lösung für Mitarbeiter im Außendienst.

Sie arbeiten an diesem Projekt mit und sollen die folgenden vier Aufgaben bearbeiten:
- Hardware-Auswahl per Nutzwertanalyse und Vertragsabwicklung
- Analyse und Dokumentation des Netzwerks am neuen Arbeitsplatz
- Bewertung von 3D-Dateiformaten und Speicherberechnung
- Sicherheitskonzept für mobile Mitarbeiter und Malware-Schutz`,
    sections: [
        {
            id: "ap1-2-a1",
            title: "Aufgabe 1: Hardware-Beschaffung (26 Punkte)",
            totalPoints: 26,
            description: "Für das Architekturbüro Hartmann & Partner sollen vier neue Renderfarm-Workstations beschafft werden. Sie wirken im Projektteam mit, das die geeigneten Systeme auswählt.",
            questions: [
                {
                    id: "ap1-2-a1-aa",
                    title: "aa) Nutzwertanalyse vervollständigen (6 Punkte)",
                    description: `Nach der Auswertung von vier Angeboten ergibt sich die folgende Bewertungstabelle. **Anbieter C** bietet ausschließlich eine Cloud-Render-Lösung (SaaS) an, alle anderen sind On-Premise-Workstations.

Einige Werte sind bereits eingetragen, andere fehlen.

AUFGABE:
1) Ermitteln Sie die **fehlenden Werte** in der Tabelle (Punkte oder gewichtete Werte).
2) Bilden Sie am Ende die **Summe der gewichteten Werte** pro Anbieter (Spalte A Gew., B Gew., C Gew., D Gew.).

Punkte-Skala: 1 (schlecht) bis 4 (sehr gut)
Gewichtet = Punkte × Gewichtung.`,
                    type: "tableInput",
                    points: 6,
                    table: {
                        rowHeaderLabel: "Kriterium",
                        columns: [
                            { key: "gew", label: "Gew.", readonly: true, align: "center", width: "70px" },
                            { key: "a-p", label: "A Punkte", align: "center", width: "85px" },
                            { key: "a-g", label: "A Gew.", align: "center", width: "85px" },
                            { key: "b-p", label: "B Punkte", align: "center", width: "85px" },
                            { key: "b-g", label: "B Gew.", align: "center", width: "85px" },
                            { key: "c-p", label: "C Punkte", align: "center", width: "85px" },
                            { key: "c-g", label: "C Gew.", align: "center", width: "85px" },
                            { key: "d-p", label: "D Punkte", align: "center", width: "85px" },
                            { key: "d-g", label: "D Gew.", align: "center", width: "85px" },
                        ],
                        rows: [
                            {
                                id: "gpu",
                                label: "GPU-Leistung",
                                values: {
                                    gew: "30",
                                    "a-g": "90",         // vorgegeben
                                    "b-p": "2", "b-g": "60",
                                    "c-p": "4", "c-g": "120",
                                    "d-p": "3",
                                    // Lücken: a-p, d-g
                                },
                            },
                            {
                                id: "ram",
                                label: "Arbeitsspeicher",
                                values: {
                                    gew: "25",
                                    "a-p": "4",          // vorgegeben
                                    "b-p": "3", "b-g": "75",
                                    "c-p": "4", "c-g": "100",
                                    "d-p": "2", "d-g": "50",
                                    // Lücke: a-g
                                },
                            },
                            {
                                id: "ssd",
                                label: "SSD-Speicher",
                                values: {
                                    gew: "20",
                                    "a-p": "3", "a-g": "60",
                                    "b-g": "40",         // vorgegeben
                                    "c-p": "4", "c-g": "80",
                                    "d-p": "3", "d-g": "60",
                                    // Lücke: b-p
                                },
                            },
                            {
                                id: "preis",
                                label: "Preis",
                                values: {
                                    gew: "25",
                                    "a-p": "2", "a-g": "50",
                                    "b-p": "4", "b-g": "100",
                                    "c-p": "1",          // vorgegeben
                                    "d-p": "3",          // vorgegeben
                                    // Lücken: c-g, d-g
                                },
                            },
                            {
                                id: "summe",
                                label: "Summe",
                                sublabel: "Σ der gewichteten Werte",
                                values: {
                                    gew: "100",          // statisch
                                    // Alle a-g, b-g, c-g, d-g Lücken für die Gesamt-Summe
                                },
                            },
                        ],
                    },
                    hint: "Gewichtet = Punkte × Gewichtung. Beachten Sie, dass die Beispielzeile (GPU-Leistung) bereits vollständig ausgefüllt ist.",
                    tags: ["nutzwertanalyse", "hardware-auswahl"],
                },
                {
                    id: "ap1-2-a1-ab",
                    title: "ab) Empfehlung (2 Punkte)",
                    description: `In einem Folge-Meeting wurde festgelegt, dass für das Architekturbüro **nur eine On-Premise-Lösung** in Frage kommt (kein Cloud-Rendering).

Nennen Sie unter Berücksichtigung dieser Vorgabe das Unternehmen, das den Auftrag bekommen sollte.

Begründen Sie kurz Ihre Entscheidung.`,
                    type: "freeText",
                    points: 2,
                    hint: "Wer hat in Ihrer Tabelle die höchste Punktzahl OHNE Anbieter C? Cloud-Render ist out — also: wer von A, B, D ist Spitzenreiter?",
                    tags: ["nutzwertanalyse", "entscheidung"],
                },
                {
                    id: "ap1-2-a1-b",
                    title: "b) Laufende Monatskosten berechnen (7 Punkte)",
                    description: `Das ausgewählte Unternehmen legt folgendes Angebot vor:

- Monitor: 520 EUR pro Stück
- Workstation: 1.890 EUR pro Stück
- Softwareleasing: 65 EUR pro Monat und Arbeitsplatz
- Wartungspauschale: 1.560 EUR pro Jahr für alle Geräte zusammen
- Rabatt: 5 % auf Workstation und Monitor

Berechnen Sie die **laufenden Kosten pro Monat** für die gesamten 4 Renderfarm-Workstations unter der Voraussetzung, dass:
- die Nutzungsdauer der Monitore **4 Jahre** beträgt
- die Nutzungsdauer der Workstations **3 Jahre** beträgt

Geben Sie den Rechenweg an.`,
                    type: "calculation",
                    points: 7,
                    hint: "Berechnen Sie für Monitor und Workstation jeweils: rabattierter Preis × Anzahl ÷ Nutzungsdauer in Monaten. Dann Softwareleasing (× 4 Arbeitsplätze) + Wartung ÷ 12 Monate addieren.",
                    tags: ["kosten", "kalkulation", "wirtschaftlichkeit"],
                },
                {
                    id: "ap1-2-a1-c",
                    title: "c) Anschlüsse zuordnen (4 Punkte)",
                    description: `Nach der Beschaffung und Lieferung sollen die Workstations vor Ort eingerichtet werden. Die Monitore besitzen vier verschiedene Anschluss-Typen.

Beschreiben Sie für jeden der folgenden Anschluss-Typen kurz **sein Hauptmerkmal** (Verwendungszweck, Besonderheit oder typische Anwendung):

- **HDMI:** _______________

- **USB-C:** _______________

- **DVI:** _______________

- **DisplayPort (DP):** _______________`,
                    type: "freeText",
                    points: 4,
                    hint: "HDMI: Video + Audio, weit verbreitet. USB-C: vielseitig (Daten/Video/Power). DVI: älterer reiner Video-Standard. DP: hohe Auflösungen, oft für Profi-Monitore.",
                    tags: ["hardware", "anschluesse"],
                },
                {
                    id: "ap1-2-a1-d",
                    title: "d) Zeitpunkt des Kaufvertrags (2 Punkte)",
                    description: `Die Workstations wurden am **15. März 2024 bestellt**. Es gibt **keine Auftragsbestätigung** vom Anbieter. Geliefert wurden die Geräte am **2. April 2024**. Die Rechnung haben Sie am **5. April 2024** erhalten.

Erläutern Sie, zu welchem Zeitpunkt der Kaufvertrag zustande gekommen ist. Begründen Sie Ihre Entscheidung.`,
                    type: "freeText",
                    points: 2,
                    hint: "Ein Kaufvertrag entsteht durch zwei übereinstimmende Willenserklärungen (Angebot + Annahme). Eine Auftragsbestätigung fehlt — was bedeutet die Lieferung in diesem Kontext?",
                    tags: ["recht", "kaufvertrag", "willenserklaerung"],
                },
                {
                    id: "ap1-2-a1-e",
                    title: "e) Inhalte eines Kaufvertrags (3 Punkte)",
                    description: `Nennen Sie **drei mögliche Inhalte**, die durch einen Kaufvertrag geregelt sind.

(Hinweis: Es geht nicht um die juristischen Bestandteile wie Willenserklärungen, sondern um die konkreten Vertragsinhalte zwischen Verkäufer und Käufer.)`,
                    type: "freeText",
                    points: 3,
                    hint: "Denken Sie an: Kaufgegenstand, Preis, Zahlungsbedingungen, Lieferort/-zeit, Eigentumsübergang, Gewährleistung.",
                    tags: ["recht", "kaufvertrag"],
                },
                {
                    id: "ap1-2-a1-fa",
                    title: "f-a) Kaufvertragsstörungen (2 Punkte)",
                    description: `Die ordnungsgemäße Abwicklung des Kaufvertrags ist dem Architekturbüro sehr wichtig.

Nennen Sie **zwei mögliche Kaufvertragsstörungen**, die beim Kauf der Workstations auftreten könnten.`,
                    type: "freeText",
                    points: 2,
                    hint: "Klassische Störungen: Lieferverzug, Schlechtleistung (z. B. defekte Hardware), Annahmeverzug, Zahlungsverzug.",
                    tags: ["recht", "kaufvertrag", "stoerungen"],
                },
                {
                    id: "ap1-2-a1-fb",
                    title: "f-b) Vermeidungs-Maßnahmen (2 Punkte)",
                    description: `Geben Sie zu jeder der in Aufgabe f-a) genannten Kaufvertragsstörungen **je eine konkrete Maßnahme** an, die der Käufer ergreifen kann, um diese Störung zu vermeiden.`,
                    type: "freeText",
                    points: 2,
                    hint: "Zu Lieferverzug: schriftliche Liefertermin-Vereinbarung mit Vertragsstrafe. Zu Schlechtleistung: Wareneingangskontrolle, dokumentierte Abnahme.",
                    tags: ["recht", "kaufvertrag", "vorsorge"],
                },
  ],
        },
        {
            id: "ap1-2-a2",
            title: "Aufgabe 2: Netzwerk-Analyse (24 Punkte)",
            totalPoints: 24,
            description: "Nach der Einrichtung der neuen Workstations im Architekturbüro prüfen Sie die Netzwerkkonfiguration. Dazu führen Sie verschiedene Tests durch und interpretieren die Ergebnisse.",
            questions: [
                {
                    id: "ap1-2-a2-a",
                    title: "a) LED-Interpretation (4 Punkte)",
                    description: `Beim Blick auf die Buchse der Netzwerkkarte Ihres PCs erkennen Sie rechts oben eine grüne Leuchtdiode (LED).

Interpretieren Sie die folgenden zwei Zustände hinsichtlich der Netzwerkfunktionalität Ihres PCs:

- **LED leuchtet durchgehend (Dauerlicht):**

- **LED blinkt unregelmäßig:**`,
                    type: "freeText",
                    points: 4,
                    hint: "Dauerlicht zeigt eine bestehende Verbindung an (Link-Status). Blinken signalisiert Datenverkehr (Aktivität).",
                    tags: ["netzwerk", "hardware", "diagnose"],
                },
                {
                    id: "ap1-2-a2-b",
                    title: "b) OSI-Schichten zuordnen (4 Punkte)",
                    description: `Nach der Eingabe des Befehls \`ipconfig /all\` auf der Kommandozeile Ihrer Workstation erhalten Sie u. a. die folgenden Informationen:

\`\`\`
Physische Adresse  . . . . . . . : 4C-FB-8A-D2-19-3E
DHCP aktiviert . . . . . . . . . : Ja
Autokonfiguration aktiviert . . . : Ja
Verbindungslokale IPv6-Adresse . : fe80::3a1c:8eff:fed2:193e%7(Bevorzugt)
IPv4-Adresse . . . . . . . . . . : 192.168.10.74(Bevorzugt)
Subnetzmaske . . . . . . . . . . : 255.255.255.0
\`\`\`

Benennen Sie die in der folgenden Tabelle aufgeführten OSI-Schichten und ordnen Sie die vorliegenden Begriffe den richtigen Schichten zu:

- Physische Adresse
- DHCP
- Verbindungslokale IPv6-Adresse
- Buchse mit LED`,
                    type: "tableInput",
                    points: 4,
                    table: {
                        rowHeaderLabel: "OSI-Schicht",
                        columns: [
                            { key: "name", label: "Name der Schicht", align: "left", width: "260px" },
                            { key: "begriff", label: "Begriff", align: "left" },
                        ],
                        rows: [
                            {
                                id: "schicht-7",
                                label: "7",
                            },
                            {
                                id: "schicht-4",
                                label: "4",
                                values: { name: "Transport", begriff: "TCP" },
                                example: true,
                            },
                            {
                                id: "schicht-3",
                                label: "3",
                            },
                            {
                                id: "schicht-2",
                                label: "2",
                            },
                            {
                                id: "schicht-1",
                                label: "1",
                            },
                        ],
                    },
                    hint: "Schicht 7 = Anwendung (DHCP), Schicht 3 = Vermittlung (IP-Adresse), Schicht 2 = Sicherung (MAC-Adresse), Schicht 1 = Bitübertragung (Kabel, Buchse).",
                    tags: ["osi", "netzwerk", "modell"],
                },
                {
                    id: "ap1-2-a2-c",
                    title: "c) IPv6-Adresse analysieren (5 Punkte)",
                    description: `Sie analysieren nun die in Aufgabe b) angezeigte IPv6-Adresse:

**fe80::3a1c:8eff:fed2:193e**

Geben Sie die folgenden zugehörigen Werte an:

- **Länge der IPv6-Adresse in Bits:**

- **Ungekürzte Darstellung der IPv6-Adresse in Hexadezimalschreibweise:**

- **Präfixlänge:**

- **Interface-Identifier:**`,
                    type: "freeText",
                    points: 5,
                    hint: "IPv6 hat 128 Bit (32 Hex-Zeichen). Die '::' ist eine Kurzschreibweise für aufeinanderfolgende Nullblöcke. fe80::/10 = link-local, Präfix erkennbar daran. Die letzten 64 Bit sind der Interface-Identifier.",
                    tags: ["ipv6", "netzwerk", "adressierung"],
                },
                {
                    id: "ap1-2-a2-d",
                    title: "d) DHCP-Server Informationen (2 Punkte)",
                    description: `Nennen Sie unter Bezugnahme auf die ipconfig-Ausgabe aus Aufgabe b) **zwei Informationen**, die der DHCP-Server Ihrem Client zur Verfügung stellt.`,
                    type: "freeText",
                    points: 2,
                    hint: "DHCP weist nicht nur die IP-Adresse zu, sondern auch Subnetzmaske, Standardgateway, DNS-Server und Lease-Dauer.",
                    tags: ["dhcp", "netzwerk"],
                },
                {
                    id: "ap1-2-a2-e",
                    title: "e) ARP-Protokoll erklären (3 Punkte)",
                    description: `Zur weiteren Analyse Ihrer Netzwerkkonfiguration geben Sie den Befehl \`arp -a\` ein und erhalten die folgende Ausgabe:

\`\`\`
PS C:\\WINDOWS\\system32> arp -a

Schnittstelle: 192.168.10.74 --- 0x7
  Internetadresse       Physische Adresse      Typ
  192.168.10.1          a8-26-d9-7c-44-2f      dynamisch
\`\`\`

Erläutern Sie anhand des Beispiels die grundlegende Aufgabe des **Address Resolution Protocol (ARP)** bei der Netzwerkkommunikation in einem LAN.`,
                    type: "freeText",
                    points: 3,
                    hint: "ARP übersetzt IP-Adressen in MAC-Adressen. Im LAN braucht man die MAC-Adresse, um das Datenpaket an den richtigen Netzwerkadapter zu schicken.",
                    tags: ["arp", "netzwerk", "protokoll"],
                },
                {
                    id: "ap1-2-a2-f",
                    title: "f) Erreichbarkeit prüfen (2 Punkte)",
                    description: `Geben Sie einen **geeigneten Befehl** an, um von Ihrer Workstation aus die Erreichbarkeit der Internetadresse **192.168.10.1** zu prüfen.`,
                    type: "freeText",
                    points: 2,
                    hint: "Der Befehl heißt ping. Vollständig: ping 192.168.10.1.",
                    tags: ["netzwerk", "diagnose", "befehl"],
                },
                {
                    id: "ap1-2-a2-g",
                    title: "g) IP- und MAC-Zuordnung (4 Punkte)",
                    description: `Aus den vorherigen Ausgaben (ipconfig + arp) haben Sie Informationen zur Kommunikation zwischen Ihrer Workstation und einem weiteren Gerät im Netzwerk erhalten.

Ordnen Sie in der folgenden Übersicht die **IP-Adressen** und **physischen Adressen** den beiden Geräten korrekt zu:`,
                    type: "tableInput",
                    points: 4,
                    table: {
                        rowHeaderLabel: "Gerät",
                        columns: [
                            { key: "ip",  label: "IP-Adresse",       align: "left" },
                            { key: "mac", label: "Physische Adresse", align: "left" },
                        ],
                        rows: [
                            {
                                id: "eigene-ws",
                                label: "Eigene Workstation",
                            },
                            {
                                id: "anderes-geraet",
                                label: "Anderes Gerät im Netzwerk",
                            },
                        ],
                    },
                    hint: "Eigene Workstation ist die Quelle aus ipconfig. Das andere Gerät steht in der ARP-Tabelle als Ziel.",
                    tags: ["netzwerk", "ip", "mac"],
                },
            ],
        },
        {
            id: "ap1-2-a3",
            title: "Aufgabe 3: Dateiformate & Speicher (24 Punkte)",
            totalPoints: 24,
            description: "Ein Kunde des Architekturbüros sendet seine 3D-Modelle im OBJ-Format. Sie prüfen den Aufbau und die Speicheranforderungen.",
            questions: [
                {
                    id: "ap1-2-a3-a",
                    title: "a) Informationen zum Dateiformat (3 Punkte)",
                    description: `Ein Kunde sendet seine 3D-Bauteildaten im **OBJ-Format**. Da Ihnen das Format bisher nicht bekannt ist, müssen Sie sich darüber informieren.

Nennen Sie **drei Möglichkeiten**, um Informationen über ein unbekanntes Dateiformat zu erhalten.`,
                    type: "freeText",
                    points: 3,
                    hint: "Denken Sie an: Datei-Endung googeln, Hex-Editor (Datei-Header lesen), Hersteller-Dokumentation, fileformat.info, Fachliteratur, Tools wie 'file' unter Linux.",
                    tags: ["dateiformate", "recherche"],
                },
                {
                    id: "ap1-2-a3-b",
                    title: "b) Format-Konvertierung (2 Punkte)",
                    description: `Sie haben erfahren, dass es sich bei dem **OBJ-Format (Wavefront)** um ein Dateiformat zur Speicherung dreidimensionaler Daten handelt. Ihr Render-System im Architekturbüro benötigt die Daten jedoch im **FBX- oder GLTF-Format**.

Nennen Sie eine **konkrete Möglichkeit**, wie Sie die Kundendaten dennoch in Ihrem Render-System verwenden können.`,
                    type: "freeText",
                    points: 2,
                    hint: "Eine Konvertierung mit einem Tool wie Blender, MeshLab, oder Online-Konverter wie convert3D.io. Auch direkte Importer in der Render-Software prüfen.",
                    tags: ["dateiformate", "konvertierung"],
                },
                {
                    id: "ap1-2-a3-c",
                    title: "c) ASCII vs. Binärformat (4 Punkte)",
                    description: `Sie haben Informationen über den Aufbau einer OBJ-Datei erhalten. Eine OBJ-Datei kann im **ASCII-Format** oder als **Binärdatei** gespeichert sein.

Erläutern Sie den **Unterschied** zwischen einer Datei im ASCII-Format und einer Datei im Binärformat.

Format Ihrer Antwort:
**ASCII-Format:**

**Binärformat:**`,
                    type: "freeText",
                    points: 4,
                    hint: "ASCII: lesbarer Text, größere Dateien, leicht editierbar. Binär: kompakte 0/1-Codierung, kleinere Dateien, schneller einzulesen, nicht direkt menschlich lesbar.",
                    tags: ["dateiformate", "ascii", "binaer"],
                },
                {
                    id: "ap1-2-a3-da",
                    title: "d-a) Speicherbedarf berechnen (3 Punkte)",
                    description: `In einer OBJ-Datei sind **4.250 Punkte** (Vertices) gespeichert. Jeder Punkt wird durch x-, y- und z-Koordinaten bestimmt. Jede Koordinate wird durch einen **32-Bit-Float-Wert** codiert.

Berechnen Sie, wie viele **Kibibyte (KiB)** Sie benötigen, um die 4.250 Punkte zu speichern.

(Der Speicherbedarf des Datei-Headers und der Farbcodierungen soll nicht berücksichtigt werden.)

Geben Sie den Rechenweg an.`,
                    type: "calculation",
                    points: 3,
                    hint: "Pro Punkt: 3 Koordinaten × 32 Bit = 96 Bit = 12 Byte. Gesamt = 4.250 × 12 Byte = 51.000 Byte. KiB = Byte ÷ 1024.",
                    tags: ["speicher", "berechnung", "binaer-praefix"],
                },
                {
                    id: "ap1-2-a3-db",
                    title: "d-b) Anzahl darstellbarer Farben (2 Punkte)",
                    description: `Jeder Punkt soll jetzt zusätzlich im **RGB-Farbraum** mit je **8 Bit pro Farbkanal** codiert werden.

Berechnen Sie, wie viele **verschiedene Farben** sich damit darstellen lassen.

Geben Sie den Rechenweg an.`,
                    type: "calculation",
                    points: 2,
                    hint: "3 Kanäle × 8 Bit = 24 Bit insgesamt. Anzahl Farben = 2^24.",
                    tags: ["farben", "berechnung", "rgb"],
                },
                {
                    id: "ap1-2-a3-dc",
                    title: "d-c) Zusätzlicher Speicher in Prozent (3 Punkte)",
                    description: `Berechnen Sie, wie viel **Prozent** Speicher Sie pro Bildpunkt zusätzlich benötigen, um die Farbwerte zu speichern (verglichen mit dem ursprünglichen Speicherbedarf der reinen Punkt-Koordinaten aus Aufgabe d-a)).

Geben Sie den Rechenweg an.`,
                    type: "calculation",
                    points: 3,
                    hint: "Pro Punkt: 12 Byte (Koordinaten) + 3 Byte (RGB) = 15 Byte. Zusatz: 3/12 = 0,25 = 25 %.",
                    tags: ["speicher", "berechnung", "prozent"],
                },
                {
                    id: "ap1-2-a3-e",
                    title: "e) Netzteil-Auswahl (4 Punkte)",
                    description: `Sie werden beauftragt, das **Netzteil** für eine neue Render-Workstation auszuwählen. Es stehen Netzteile von **400 W in 50-W-Schritten bis 1200 W** zur Verfügung. Die folgenden Komponenten wurden bereits ausgewählt.

Zu der ermittelten Leistungsaufnahme ist ein **Puffer von 15 %** hinzuzurechnen.`,
                    type: "tableInput",
                    points: 4,
                    table: {
                        rowHeaderLabel: "Komponente",
                        columns: [
                            { key: "watt",   label: "Watt pro Stück",         readonly: true, align: "center", width: "150px" },
                            { key: "anzahl", label: "Anzahl",                 readonly: true, align: "center", width: "90px" },
                            { key: "summe",  label: "Gesamt-Watt",                            align: "center", width: "120px" },
                        ],
                        rows: [
                            { id: "mainboard",  label: "Mainboard",       values: { watt: "25",  anzahl: "1" } },
                            { id: "cpu",        label: "Prozessor (CPU)", values: { watt: "165", anzahl: "1" } },
                            { id: "cpu-luefter",label: "CPU-Lüfter",      values: { watt: "10",  anzahl: "1" } },
                            { id: "ram",        label: "Arbeitsspeicher", values: { watt: "5",   anzahl: "4" } },
                            { id: "gpu",        label: "Grafikkarte",     values: { watt: "350", anzahl: "1" } },
                            { id: "ssd",        label: "NVMe SSD",        values: { watt: "8",   anzahl: "2" } },
                            { id: "gehaeuse",   label: "Gehäuselüfter",   values: { watt: "6",   anzahl: "3" } },
                            {
                                id: "summe-gesamt",
                                label: "Summe (gesamt)",
                                sublabel: "Σ Gesamt-Watt aller Komponenten",
                            },
                            {
                                id: "mit-puffer",
                                label: "Inkl. 15 % Puffer",
                                sublabel: "Aufgerundet, gewähltes Netzteil",
                            },
                        ],
                    },
                    hint: "Pro Zeile: Watt × Anzahl = Gesamt-Watt. Summe aller Komponenten bilden, dann × 1,15 für den Puffer. Auf nächstgrößere 50-W-Stufe aufrunden.",
                    tags: ["hardware", "berechnung", "netzteil"],
                },
                {
                    id: "ap1-2-a3-f",
                    title: "f) Stromkosten berechnen (3 Punkte)",
                    description: `Die Render-Workstation läuft an **220 Arbeitstagen** je **10 Stunden**. Das Netzteil hat einen **Wirkungsgrad von 92 %** und wird im Schnitt zu **60 %** ausgelastet sein.

Berechnen Sie die **Stromkosten pro Jahr** bei einem Preis von **0,38 EUR pro kWh**.

Geben Sie den Rechenweg an.

Hinweis: Konnten Sie in e) kein Netzteil ermitteln, rechnen Sie mit **800 Watt** weiter.`,
                    type: "calculation",
                    points: 3,
                    hint: "Tatsächliche Leistungsaufnahme = (Netzteil-Watt × Auslastung) / Wirkungsgrad. Energie = Watt × Stunden × Tage / 1000 → kWh. Kosten = kWh × 0,38 EUR.",
                    tags: ["energie", "kosten", "berechnung", "wirkungsgrad"],
                },
],
        },
        {
            id: "ap1-2-a4",
            title: "Aufgabe 4: Mobiles Arbeiten & Sicherheit (26 Punkte)",
            totalPoints: 26,
            description: "Mit Herrn Sander wurde ein neuer Mitarbeiter eingestellt, der mit dem hausinternen Render-Programm der TechVisuell Studios GmbH die Realisierungsmöglichkeiten neuer Aufträge prüfen soll, um eine für alle Seiten optimale Lösung zu finden.\n\nIn einigen Fällen wird von ihm erwartet, dass er für wenige Tage beim Kunden vor Ort tätig wird. Zu diesen Terminen wird ihm ein leistungsfähiger Laptop zur Verfügung gestellt.\n\nDie Erstellung und das Bearbeiten einer 3D-Konstruktionszeichnung erfordert eine große Rechnerleistung und einen hohen Speicherbedarf, sodass bei Außenterminen dies auf der lokalen Festplatte des Laptops erfolgen muss.",
            questions: [
                {
                    id: "ap1-2-a4-a",
                    title: "a) Geheimhaltung im Außendienst (6 Punkte)",
                    description: `Herr Sander möchte seine berufsbedingten Fahrten mit Bus und Bahn und die Aufenthalte auf öffentlichen Plätzen zur Erledigung betrieblicher Arbeiten nutzen. Allerdings sind dabei zur Gewährleistung der Geheimhaltung besondere Vorsichtsmaßnahmen erforderlich.

Nennen Sie Herrn Sander **drei geeignete Maßnahmen oder Verhaltensweisen** zur Gewährleistung der Geheimhaltung. Weisen Sie dabei auf eine **mögliche Folge einer Nichtbeachtung** hin.`,
                    type: "tableInput",
                    points: 6,
                    table: {
                        rowHeaderLabel: "Nr.",
                        columns: [
                            { key: "massnahme", label: "Maßnahme / Verhaltensweise", align: "left" },
                            { key: "folge",     label: "Folge der Nichtbeachtung",   align: "left", belowRow: true },
                        ],
                        rows: [
                            {
                                id: "beispiel",
                                label: "Beispiel",
                                example: true,
                                values: {
                                    massnahme: "Nutzung einer Blickschutzfolie",
                                    folge: "Bildschirminhalt kann von Unberechtigten gelesen werden.",
                                },
                            },
                            { id: "massnahme-1", label: "1" },
                            { id: "massnahme-2", label: "2" },
                            { id: "massnahme-3", label: "3" },
                        ],
                    },
                    hint: "Mögliche Maßnahmen: Bildschirm-Sperre bei Abwesenheit, keine sensiblen Telefonate in öffentlichen Räumen, USB-Stick verschlüsseln, Laptop nie unbeaufsichtigt lassen, sichere WLAN-Wahl (kein Public-WLAN ohne VPN).",
                    tags: ["mobiles-arbeiten", "datenschutz", "geheimhaltung"],
                },
                {
                    id: "ap1-2-a4-b",
                    title: "b) VPN erklären (2 Punkte)",
                    description: `Herr Sander sichert seine Daten möglichst auf dem Server der TechVisuell Studios GmbH über **VPN**.

Erklären Sie die Funktionalität des Begriffs **VPN (Virtual Private Network)** in eigenen Worten.`,
                    type: "freeText",
                    points: 2,
                    hint: "VPN baut einen verschlüsselten 'Tunnel' über das Internet auf, sodass der Laptop sicher mit dem Firmennetz kommunizieren kann — als wäre er direkt im Büro.",
                    tags: ["vpn", "netzwerk", "verschluesselung"],
                },
                {
                    id: "ap1-2-a4-c",
                    title: "c) Backup auf externen Festplatten (3 Punkte)",
                    description: `Herr Sander kritisiert, dass im Außendienst nicht immer eine stabile Internetverbindung zur Verfügung steht.

Nach den Sicherheitsrichtlinien der TechVisuell Studios GmbH sind für lokal gespeicherte Daten **Tagesvollsicherungen auf mehreren (nummerierten) externen Festplatten** vorgesehen.

Nennen Sie Herrn Sander **drei Punkte**, die zu beachten sind, wenn die lokal gespeicherten Daten mithilfe von externen Festplatten möglichst zuverlässig gesichert werden sollen. Berücksichtigen Sie dabei die Datensicherheitsaspekte.`,
                    type: "freeText",
                    points: 3,
                    hint: "Wichtig: Verschlüsselung der externen Platten, sichere Aufbewahrung (nicht im selben Laptop-Rucksack), regelmäßige Wiederherstellungs-Tests, Rotation/Versionierung, getrennte Lagerorte.",
                    tags: ["backup", "datensicherung", "externe-festplatte"],
                },
                {
                    id: "ap1-2-a4-da",
                    title: "d-a) Drei Arten von Malware (3 Punkte)",
                    description: `Sie informieren Herrn Sander über **"Malware"** als Oberbegriff für Schadsoftware.

Nennen Sie **drei Arten** von Malware.`,
                    type: "freeText",
                    points: 3,
                    hint: "Klassiker: Virus, Wurm, Trojaner, Ransomware, Spyware, Adware, Rootkit, Keylogger.",
                    tags: ["malware", "it-sicherheit"],
                },
                {
                    id: "ap1-2-a4-db",
                    title: "d-b) Spezifische Merkmale der Malware-Arten (3 Punkte)",
                    description: `Weisen Sie den in Aufgabe d-a) genannten Arten jeweils ein **spezifisches Merkmal** zu (das diese Malware-Art von anderen unterscheidet).

Format Ihrer Antwort:
**Art 1 (z. B. Virus):** _______________

**Art 2 (z. B. Wurm):** _______________

**Art 3 (z. B. Ransomware):** _______________`,
                    type: "freeText",
                    points: 3,
                    hint: "Virus: benötigt Wirtsprogramm. Wurm: verbreitet sich selbst übers Netzwerk. Trojaner: tarnt sich als nützliches Programm. Ransomware: verschlüsselt Daten und fordert Lösegeld. Spyware: spioniert Nutzer aus.",
                    tags: ["malware", "it-sicherheit", "merkmale"],
                },
                {
                    id: "ap1-2-a4-e",
                    title: "e) Empfehlungen gegen Malware (3 Punkte)",
                    description: `Eine **Antivirensoftware** ist bereits auf dem Laptop von Herrn Sander installiert.

Erläutern Sie Herrn Sander **drei weitere organisatorische oder technische Empfehlungen**, wie man sich vor Malware schützen kann.`,
                    type: "freeText",
                    points: 3,
                    hint: "Technisch: Updates regelmäßig einspielen, Firewall aktiv, USB-Sticks nicht ungeprüft anschließen, sichere Browser-Konfiguration. Organisatorisch: Schulungen, keine Mail-Anhänge unbekannter Absender öffnen, Software nur aus offiziellen Quellen.",
                    tags: ["malware", "it-sicherheit", "praevention"],
                },
                {
                    id: "ap1-2-a4-test-er",
                    title: "TEST) ER-Diagramm zeichnen",
                    description: `Test-Aufgabe für den ER-Modus.

Skizzieren Sie ein einfaches ER-Diagramm:
1. Entity "Kunde" mit Attributen kundenID (PK), name, email
2. Entity "Bestellung" mit Attributen bestellID (PK), datum, betrag
3. Relationship "tätigt" zwischen Kunde und Bestellung
4. Kardinalität: 1:n (ein Kunde hat viele Bestellungen)

Tipp: Für einen Primärschlüssel im Edit-Modal als Beschreibung "pk" eintragen.`,
                    type: "diagram",
                    points: 0,
                    diagram: {
                        mode: "er",
                        hintText: "Entity = Rechteck · Beziehung = Raute · Attribut = Oval · Kardinalität = 1:n-Label",
                    },
                    tags: ["test", "diagramm", "er"],
                },
                {
                    id: "ap1-2-a4-test-table",
                    title: "TEST) DB-Tabellen zeichnen (Normalformen)",
                    description: `Test-Aufgabe für den Tabellen-Modus.

Skizzieren Sie die folgenden DB-Tabellen:

Tabelle "kunde":
- kundenID (PK)
- name
- email

Tabelle "bestellung":
- bestellID (PK)
- datum
- betrag
- kundenID (FK)

Tipp: Im Edit-Modal "(PK)" oder "(FK)" hinter dem Spaltennamen einfügen.`,
                    type: "diagram",
                    points: 0,
                    diagram: {
                        mode: "table",
                        hintText: "Tabelle hinzufügen → Doppelklick → Spalten eintragen, je eine pro Zeile",
                    },
                    tags: ["test", "diagramm", "table"],
                },
                {
                    id: "ap1-2-a4-test-network",
                    title: "TEST) Netzwerk-Diagramm zeichnen",
                    description: `Test-Aufgabe für den Netzwerk-Modus.

Skizzieren Sie eine typische DMZ-Architektur:

1. Internet (außen)
2. Perimeter-Firewall
3. DMZ-Zone mit Web-Server
4. Interne Firewall
5. LAN-Zone mit DB-Server

Verbinden Sie alle Komponenten in der richtigen Reihenfolge.`,
                    type: "diagram",
                    points: 0,
                    diagram: {
                        mode: "network",
                        hintText: "Internet → Firewall → DMZ-Zone → Firewall → LAN-Zone. Server in die Zonen platzieren.",
                    },
                    tags: ["test", "diagramm", "network"],
                },
            ],
        },
    ],
};