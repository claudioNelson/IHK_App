import { Exam } from "../exam-types";

export const ap1_1: Exam = {
    id: "ap1-1",
    title: "AP1 Übungsprüfung 1 - Frühjahr 2024 (Stil)",
    year: 2024,
    season: "Sommer",
    company: "Zahnarztpraxis Dr. Berger",
    duration: 90,
    totalPoints: 100,
    level: "ap1",
    fachrichtung: "shared",
    difficulty: "mittel",
    tags: ["projektmanagement", "netzplan", "energieeffizienz", "raid", "datenschutz"],
    scenario: `Sie sind Mitarbeiter/-in der PixelForge Solutions GmbH, einem IT-Systemhaus, das mittelständische Betriebe bei IT-Modernisierung und Digitalisierung unterstützt.

Ein Kunde der PixelForge Solutions GmbH ist die Zahnarztpraxis Dr. Berger. Die Praxis renoviert in den kommenden Monaten ihre Räumlichkeiten und plant in diesem Zuge eine grundlegende Erneuerung der IT-Ausstattung. Die PixelForge Solutions GmbH wurde mit der Planung und Umsetzung des Vorhabens beauftragt.

Sie arbeiten an diesem Projekt mit und sollen die folgenden vier Aufgaben bearbeiten:
- Das Projekt zur Modernisierung der IT planen und einen Netzplan vervollständigen
- Die Energiebilanz der neuen Hardware bewerten und Fehler in einem Wartungsskript korrigieren
- Den Auftraggeber bei der Auswahl von Hardware- und Softwarekomponenten beraten
- Maßnahmen zum Datenschutz und zur Datensicherung umsetzen und die Praxis-Inhaberin beraten`,
    sections: [
        {
            id: "ap1-1-a1",
            title: "Aufgabe 1: Projektmanagement (25 Punkte)",
            totalPoints: 25,
            description: "Sie wirken bei der Vorbereitung der IT-Modernisierung in der Zahnarztpraxis Dr. Berger mit und bearbeiten verschiedene Aspekte der Projektplanung.",
            questions: [
                {
                    id: "ap1-1-a1-a",
                    title: "a) Merkmale eines Projekts (4 Punkte)",
                    description: `Ihre Kollegin weist Sie darauf hin, dass es sich bei der IT-Modernisierung der Zahnarztpraxis um ein Projekt im Sinne der DIN 69901 handelt.

Nennen Sie vier typische Merkmale eines Projekts.`,
                    type: "freeText",
                    points: 4,
                    hint: "Denken Sie an Zeit, Ziel, Ressourcen und Einmaligkeit.",
                    tags: ["projektmanagement", "din-69901"],
                },
                {
                    id: "ap1-1-a1-b",
                    title: "b) SMART-Kriterien (4 Punkte)",
                    description: `Projektziele sollen nach den SMART-Kriterien formuliert werden.

Ergänzen Sie die folgende Auflistung. Geben Sie die Bedeutung der Buchstaben M, A, R und T auf Deutsch oder Englisch an.

S — specific / spezifisch
M — _______________
A — _______________
R — _______________
T — _______________`,
                    type: "freeText",
                    points: 4,
                    hint: "M wie messen, A wie akzeptiert, R wie realistisch, T wie zeitlich.",
                    tags: ["projektmanagement", "smart"],
                },
                {
                    id: "ap1-1-a1-c",
                    title: "c) Netzplan vervollständigen (14 Punkte)",
                    description: `Für das Projekt wurde der folgende Netzplan vorbereitet. Ihre Kollegin hat bereits begonnen und bittet Sie, ihn zu vervollständigen.

VORGANGSLISTE:

┌─────────┬─────────────────────────────────┬───────┬───────────┐
│ Vorgang │ Beschreibung                    │ Dauer │ Vorgänger │
├─────────┼─────────────────────────────────┼───────┼───────────┤
│   A     │ Ist-Analyse                     │   3   │    –      │
│   B     │ Soll-Konzept                    │   5   │    A      │
│   C     │ Beschaffung neuer Geräte        │   4   │    B      │
│   D     │ Verkabelung erneuern            │   6   │    B      │
│   E     │ Datensicherung der Altsysteme   │   3   │    B      │
│   F     │ Installation Praxis-Server      │   4   │   C, D    │
│   G     │ Installation Arbeitsplatz-PCs   │   5   │   C, D    │
│   H     │ Abbau Altgeräte                 │   2   │    E      │
│   I     │ Funktionstest                   │   2   │   F, G    │
│   J     │ Mitarbeiter-Schulung            │   3   │   I, H    │
└─────────┴─────────────────────────────────┴───────┴───────────┘

ABLAUF DER VORGÄNGE:

                                  ┌───→ F ──┐
                ┌──→ C ──┐         │         │
                │         │         │         │
   A ──→ B ─────┼──→ D ──┼─────────┘         ├──→ I ──→ J
                │         │                   │           ↑
                │         └───→ G ────────────┘           │
                │                                          │
                └──→ E ──→ H ─────────────────────────────┘

AUFBAU EINER VORGANGSBOX:

┌─────┬───────┬─────┐
│ FAZ │ Dauer │ FEZ │     FAZ = Frühester Anfangszeitpunkt
├─────┼───────┼─────┤     FEZ = Frühestes Ende
│     │   X   │     │     X   = Vorgangsname
├─────┼───────┼─────┤     SAZ = Spätester Anfang
│ SAZ │  GP   │ SEZ │     SEZ = Spätestes Ende
└─────┴───────┴─────┘     GP  = Gesamtpuffer (= SAZ - FAZ)

AUFGABE:
Tragen Sie für JEDEN Vorgang (A bis J) die Werte FAZ, FEZ, SAZ, SEZ und GP ein.

Format pro Vorgang:
A: FAZ=__, FEZ=__, SAZ=__, SEZ=__, GP=__
B: FAZ=__, FEZ=__, SAZ=__, SEZ=__, GP=__
...

Hinweis: Beginnen Sie bei A mit FAZ=0 und rechnen Sie sich vorwärts durch (FEZ = FAZ + Dauer). Anschließend ermitteln Sie SEZ und SAZ durch Rückwärtsrechnung vom letzten Vorgang.`,
                    type: "tableInput",
                    points: 14,
                    hint: "Vorwärtsrechnung für FAZ/FEZ, Rückwärtsrechnung für SAZ/SEZ. Bei Vorgängen mit mehreren Vorgängern gilt: FAZ = maximaler FEZ der Vorgänger.",
                    tags: ["projektmanagement", "netzplan"],
                },
                {
                    id: "ap1-1-a1-d",
                    title: "d) Kritischen Pfad bestimmen (1 Punkt)",
                    description: `Markieren bzw. benennen Sie den kritischen Pfad im Netzplan.

Geben Sie ihn als Folge der Vorgangs-Buchstaben an, z. B.:
A → B → ...`,
                    type: "freeText",
                    points: 1,
                    hint: "Der kritische Pfad verbindet alle Vorgänge mit Gesamtpuffer GP = 0.",
                    tags: ["projektmanagement", "netzplan", "kritischer-pfad"],
                },
                {
                    id: "ap1-1-a1-e",
                    title: "e) Auswirkung einer Verzögerung (2 Punkte)",
                    description: `Der Vorgang **G (Installation Arbeitsplatz-PCs)** verzögert sich aufgrund einer verspäteten Hardware-Lieferung um zwei Stunden.

Beschreiben Sie kurz die Auswirkung auf das Projektende.`,
                    type: "freeText",
                    points: 2,
                    hint: "Liegt der verzögerte Vorgang auf dem kritischen Pfad? Wie groß ist sein Gesamtpuffer?",
                    tags: ["projektmanagement", "netzplan", "puffer"],
                },
            ],
        },
        {
            id: "ap1-1-a2",
            title: "Aufgabe 2: Energieeffizienz & Skript (25 Punkte)",
            totalPoints: 25,
            description: "Für die Zahnarztpraxis sollen neue Arbeitsplatz-PCs angeschafft werden. Außerdem prüfen Sie ein Skript zur Datensicherung.",
            questions: [
                {
                    id: "ap1-1-a2-a",
                    title: "a) Stromverbrauch und Energiekosten (6 Punkte)",
                    description: `Es stehen zwei nahezu baugleiche PC-Varianten zur Auswahl. Sie unterscheiden sich nur im verbauten Netzteil.

BETRIEBSDATEN:
- 8 Betriebsstunden pro Arbeitstag
- 22 Arbeitstage pro Monat
- Strompreis: 0,32 EUR pro kWh

VERGLEICH DER NETZTEILE:

┌────────────────────────────────────────────────────────┬───────┬───────┐
│                                                        │ PC-1  │ PC-2  │
├────────────────────────────────────────────────────────┼───────┼───────┤
│ Wirkungsgrad des Netzteils bei 70 W in Prozent         │ 50 %  │ 80 %  │
│ Durchschnittliche Leistung der PC-Komponenten          │ 70 W  │ 70 W  │
│ Vom Netzteil bezogene Leistung aus dem Stromnetz       │  ?    │  ?    │
│ Energiekosten pro Monat in EUR                         │  ?    │  ?    │
└────────────────────────────────────────────────────────┴───────┴───────┘

FORMEL AUS DEM NETZTEIL-DATENBLATT (englisch):
Efficiency = Useful power output / Total power input

AUFGABE:
Berechnen Sie für beide PC-Varianten:
1) Die vom Netzteil aus dem Stromnetz bezogene Leistung (in Watt)
2) Die monatlichen Energiekosten in EUR

Der Rechenweg ist anzugeben.`,
                    type: "calculation",
                    points: 6,
                    hint: "Aus Efficiency = Useful / Total folgt: Total = Useful / Efficiency. Dann: kWh = Watt × Stunden / 1000.",
                    tags: ["energieeffizienz", "berechnung"],
                },
                {
                    id: "ap1-1-a2-b",
                    title: "b) Amortisation berechnen (4 Punkte)",
                    description: `Der PC-2 mit dem effizienteren Netzteil ist in der Anschaffung 80 EUR teurer als der PC-1.

Berechnen Sie, nach wie vielen Monaten sich diese Mehrausgabe durch die geringeren Energiekosten amortisiert hat.

Hinweis: Falls Sie Aufgabe a) nicht lösen konnten, rechnen Sie mit folgenden Monatskosten:
- PC-1: 9,86 EUR
- PC-2: 6,16 EUR

Der Rechenweg ist anzugeben.`,
                    type: "calculation",
                    points: 4,
                    hint: "Amortisationsdauer = Mehrkosten / Einsparung pro Monat",
                    tags: ["energieeffizienz", "amortisation", "berechnung"],
                },
                {
                    id: "ap1-1-a2-c",
                    title: "c) Maßnahmen zur Energie-Reduktion (3 Punkte)",
                    description: `Nennen Sie drei weitere Maßnahmen, die unabhängig vom Netzteil den Energieverbrauch eines IT-Arbeitsplatzes senken können.`,
                    type: "freeText",
                    points: 3,
                    hint: "Denken Sie an Monitore, Energiesparmodus, Nutzungszeiten, Peripheriegeräte.",
                    tags: ["energieeffizienz"],
                },
                {
                    id: "ap1-1-a2-d",
                    title: "d) Mehrfachsteckdose - Strombelastung prüfen (4 Punkte)",
                    description: `Bei der Installation der neuen Arbeitsplätze sollen die folgenden Geräte an einer einzigen Mehrfachsteckdose mit der Aufschrift **"maximal 16 A"** angeschlossen werden:

- 2 PCs mit jeweils maximal 200 W Leistungsaufnahme
- Ein Laserdrucker mit maximal 800 W
- Ein Wasserkocher mit maximal 2.000 W
- Eine Schreibtischlampe mit maximal 60 W

Annahme: Netzspannung 230 V.

Weisen Sie durch eine Rechnung nach, ob diese Geräte gleichzeitig betrieben werden können oder nicht.

Der Rechenweg ist anzugeben.`,
                    type: "calculation",
                    points: 4,
                    hint: "Maximale zulässige Leistung = Spannung × Stromstärke (P = U × I). Vergleichen Sie mit der Summe der Leistungsaufnahmen.",
                    tags: ["energie", "berechnung", "elektrotechnik"],
                },
                {
                    id: "ap1-1-a2-e",
                    title: "e) Fehler im Backup-Skript korrigieren (8 Punkte)",
                    description: `Für die Praxis-Server-Sicherung wurde folgendes Bash-Skript auf einem Linux-Server geschrieben. Es soll eine Warnung ausgeben, wenn der freie Speicherplatz auf dem Backup-Laufwerk unter 20 % fällt.

Das Skript funktioniert nicht wie gewünscht: Obwohl das Laufwerk zu 95 % belegt ist (also nur noch 5 % frei), wird die Meldung "Genügend Speicherplatz verfügbar" ausgegeben.

ERSTELLTES SKRIPT (mit zwei Fehlern):

┌──────────────────────────────────────────────────────────────────────┐
│ #!/bin/bash                                                          │
│ FREI_PROZENT=$(df /backup | tail -1 | awk '{print $5}' | tr -d '%')  │
│                                                                      │
│ if [ "$FREI_PROZENT" -gt 20 ]                                        │
│ then                                                                 │
│     echo "Es sind weniger als 20% Speicherplatz frei."               │
│ else                                                                 │
│     echo "Genügend Speicherplatz verfügbar."                         │
│ fi                                                                   │
└──────────────────────────────────────────────────────────────────────┘

MANUAL-AUSZUG zu df:
- df zeigt Speicherplatz-Informationen
- Spalte 5 ("$5") = "Use%" — der BELEGTE Anteil in Prozent (nicht der freie!)
- Spalte 4 ("$4") = "Available" — verfügbarer Speicher in Blöcken
- "tr -d '%'" entfernt das Prozentzeichen

VERGLEICHS-OPERATOREN in Bash:
| Operator | Bedeutung           |
|----------|---------------------|
| -eq      | gleich              |
| -ne      | ungleich            |
| -gt      | größer als          |
| -ge      | größer oder gleich  |
| -lt      | kleiner als         |
| -le      | kleiner oder gleich |

AUFGABE:
Identifizieren Sie die **zwei Fehler** und geben Sie jeweils die korrigierte Zeile an.

Format Ihrer Antwort:
Fehler 1: [Originalzeile] → korrigiert zu: [neue Zeile] (Begründung)
Fehler 2: [Originalzeile] → korrigiert zu: [neue Zeile] (Begründung)`,
                    type: "codeCorrection",
                    points: 8,
                    hint: "Lesen Sie den Manual-Auszug genau: Welche Spalte enthält den belegten Anteil, welche den freien? Und was soll mit -gt verglichen werden, wenn nur 5% FREI sind?",
                    tags: ["scripting", "bash", "debugging", "linux"],
                },
            ],
        },
        {
            id: "ap1-1-a3",
            title: "Aufgabe 3: Beratung & Hardware-Auswahl (26 Punkte)",
            totalPoints: 26,
            description: "Die Praxisinhaberin Dr. Berger bittet Sie um Beratung bei der Auswahl der neuen Hardware und Software.",
            questions: [
                {
                    id: "ap1-1-a3-a",
                    title: "a) Inhalte eines Lastenhefts (5 Punkte)",
                    description: `Vor Beginn des Projekts soll von der Zahnarztpraxis ein Lastenheft erstellt werden, das die Anforderungen der Praxis an die PixelForge Solutions GmbH beschreibt.

Nennen Sie fünf inhaltliche Aspekte, die in einem Lastenheft typischerweise enthalten sind.`,
                    type: "freeText",
                    points: 5,
                    hint: "Denken Sie an: Ausgangslage, Ziele, Anforderungen, Rahmenbedingungen, Abnahmekriterien.",
                    tags: ["projektmanagement", "lastenheft"],
                },
                {
                    id: "ap1-1-a3-ba",
                    title: "b-a) Migrations-Kosten berechnen (2 Punkte)",
                    description: `Im Zuge der Modernisierung sollen alle Patientenakten von einem veralteten System auf das neue Praxis-Informationssystem migriert werden.

Aus organisatorischen Gründen darf die Migration nur außerhalb der Öffnungszeiten erfolgen. Die Praxis ist wochentags von 8:00 bis 18:00 Uhr geöffnet.

Die PixelForge Solutions GmbH beauftragt einen Subdienstleister mit der Migration, der **140 EUR pro Stunde** verlangt. Die Migration einer Akte dauert wegen umfangreicher manueller Prüfung im Schnitt **15 Minuten**. In Summe sind **240 Akten** zu migrieren.

Berechnen Sie die Gesamtkosten der Migration, die der PixelForge Solutions GmbH entstehen.

Der Rechenweg ist anzugeben.`,
                    type: "calculation",
                    points: 2,
                    hint: "Gesamtdauer in Stunden = (Anzahl Akten × Minuten pro Akte) / 60. Gesamtkosten = Stunden × Stundensatz.",
                    tags: ["projektmanagement", "berechnung", "kalkulation"],
                },
                {
                    id: "ap1-1-a3-bb",
                    title: "b-b) Dauer der Migration ermitteln (2 Punkte)",
                    description: `Der Subdienstleister setzt für die Migration **zwei Mitarbeiter** ein, die jeweils **6 Stunden pro Nacht** arbeiten können.

Ermitteln Sie, nach wie vielen Arbeitsnächten die Migration frühestens abgeschlossen sein kann.

Der Rechenweg ist anzugeben.`,
                    type: "calculation",
                    points: 2,
                    hint: "Verfügbare Stunden pro Nacht = Anzahl Mitarbeiter × Stunden pro Person. Aufrunden nicht vergessen!",
                    tags: ["projektmanagement", "berechnung", "kalkulation"],
                },
                {
                    id: "ap1-1-a3-c",
                    title: "c) Remote- vs. Vor-Ort-Wartung (4 Punkte)",
                    description: `Mit Frau Dr. Berger wird diskutiert, ob künftig bestimmte Wartungsaufgaben der PixelForge Solutions GmbH **remote** statt vor Ort durchgeführt werden sollen.

Nennen Sie **zwei Vorteile** und **zwei Nachteile** der Remote-Wartung gegenüber einer Vor-Ort-Wartung.

Format Ihrer Antwort:
Vorteile:
1. _______________
2. _______________

Nachteile:
1. _______________
2. _______________`,
                    type: "freeText",
                    points: 4,
                    hint: "Denken Sie an Reaktionszeit, Kosten, Datenschutz, eingeschränkte Hardware-Eingriffe.",
                    tags: ["wartung", "support"],
                },
                {
                    id: "ap1-1-a3-d",
                    title: "d) Schulungsformen beschreiben (6 Punkte)",
                    description: `Die Mitarbeiterinnen und Mitarbeiter der Zahnarztpraxis sollen in die neue Praxis-Software eingewiesen werden. Es stehen vier Schulungsformen zur Auswahl.

Beschreiben Sie **drei der folgenden vier** Möglichkeiten und nennen Sie jeweils einen Vorteil:

(1) Präsenz-Schulung in der Praxis:

(2) Online-Live-Schulung (Webinar):

(3) Selbstlern-Videos:

(4) Train-the-Trainer (eine Mitarbeiterin wird intensiv geschult und gibt das Wissen weiter):`,
                    type: "freeText",
                    points: 6,
                    hint: "Berücksichtigen Sie Zeitaufwand, Kosten, Wiederholbarkeit und Praxisbezug.",
                    tags: ["schulung", "personalentwicklung"],
                },
                {
                    id: "ap1-1-a3-e",
                    title: "e) RAID-Level vergleichen und empfehlen (7 Punkte)",
                    description: `Frau Dr. Berger fragt nach, wie der neue Praxis-Server gegen Datenverlust geschützt werden kann. Sie hat von einem Bekannten gehört, dass durch den Verbund mehrerer Festplatten verschiedene RAID-Level gebildet werden können.

ANFORDERUNGEN DER PRAXIS:
- Ein Ausfall einer einzelnen Festplatte soll kompensiert werden können (Verfügbarkeit der Patientendaten)
- Die nutzbare Speicherkapazität soll möglichst hoch bleiben
- Die Kosten sollen verhältnismäßig sein

Stellen Sie Frau Dr. Berger die **RAID-Level 0, 1 und 5** vor:

AUFGABE:
1) Erklären Sie kurz die Grundfunktion jedes der drei RAID-Level (je 1-2 Sätze)
2) Begründen Sie, für welches RAID-Level sich die Praxis unter Berücksichtigung der Anforderungen entscheiden sollte`,
                    type: "freeText",
                    points: 7,
                    hint: "RAID 0 = Striping (keine Ausfallsicherheit). RAID 1 = Spiegelung (halbe Kapazität). RAID 5 = Striping mit Parität (1 Platte 'Verlust' für Parität).",
                    tags: ["raid", "speichersysteme", "hardware"],
                },
            ],
        },
        {
            id: "ap1-1-a4",
            title: "Aufgabe 4: Datenschutz & IT-Sicherheit (24 Punkte)",
            totalPoints: 24,
            description: "Die PixelForge Solutions GmbH soll auch den Datenschutz und die Datensicherung in der Zahnarztpraxis verbessern.",
            questions: [
                {
                    id: "ap1-1-a4-a",
                    title: "a) Schutzziele zuordnen (6 Punkte)",
                    description: `Die drei klassischen Schutzziele der Informationssicherheit lauten:
- **Vertraulichkeit** (Daten sind nur für Berechtigte zugänglich)
- **Integrität** (Daten sind unverfälscht)
- **Verfügbarkeit** (Daten sind bei Bedarf erreichbar)

Ordnen Sie jeder der folgenden Sicherheitsmaßnahmen das primär unterstützte Schutzziel zu und begründen Sie kurz Ihre Wahl.

┌────────────────────────────────────────────┬──────────────┬───────────┬────────────────┐
│ Sicherheitsmaßnahme                        │ Vertraulich- │ Integri-  │ Verfügbar-     │
│                                            │ keit         │ tät       │ keit           │
├────────────────────────────────────────────┼──────────────┼───────────┼────────────────┤
│ Beispiel: Sichere Passwörter wählen        │      X       │           │                │
│ → Begründung: Schutz vor unbefugtem Zugriff auf Konten                                  │
├────────────────────────────────────────────┼──────────────┼───────────┼────────────────┤
│ 1) Tägliches Backup der Patientendaten     │              │           │                │
│ → Begründung:                                                                           │
├────────────────────────────────────────────┼──────────────┼───────────┼────────────────┤
│ 2) Festplattenverschlüsselung der Praxis-  │              │           │                │
│    PCs                                                                                  │
│ → Begründung:                                                                           │
├────────────────────────────────────────────┼──────────────┼───────────┼────────────────┤
│ 3) Digitale Signatur auf Arztbriefen       │              │           │                │
│ → Begründung:                                                                           │
├────────────────────────────────────────────┼──────────────┼───────────┼────────────────┤
│ 4) Redundante Internet-Anbindung           │              │           │                │
│ → Begründung:                                                                           │
├────────────────────────────────────────────┼──────────────┼───────────┼────────────────┤
│ 5) Prüfsummen-Check bei Software-Updates   │              │           │                │
│ → Begründung:                                                                           │
└────────────────────────────────────────────┴──────────────┴───────────┴────────────────┘

AUFGABE:
Setzen Sie in jeder Zeile **ein Kreuz** und schreiben Sie zu jedem Kreuz eine kurze Begründung.`,
                    type: "decisionMatrix",
                    points: 6,
                    hint: "Backup → Daten sind wieder verfügbar nach Verlust. Verschlüsselung → Schutz vor Mitlesen. Signatur → Nachweis, dass nicht geändert wurde. Redundanz → Ausfallsicherheit. Prüfsumme → Erkennt Manipulation.",
                    tags: ["datenschutz", "it-sicherheit", "schutzziele"],
                },
                {
                    id: "ap1-1-a4-b",
                    title: "b) BSI-Grundschutz Maßnahmen (2 Punkte)",
                    description: `Im IT-Grundschutz-Kompendium des **Bundesamtes für Sicherheit in der Informationstechnik (BSI)** finden Sie Basis-Anforderungen zur Absicherung von Client-Systemen.

Nennen Sie je eine konkrete Maßnahme, mit der die folgenden Anforderungen umgesetzt werden können:

- **Schutz vor Schadsoftware:**

- **Geregelte Außerbetriebnahme von Geräten:**`,
                    type: "freeText",
                    points: 2,
                    hint: "Schadsoftware → Antivirus / EDR / Application-Whitelisting. Außerbetriebnahme → sichere Datenträger-Löschung / Festplatten-Shredder.",
                    tags: ["bsi", "it-sicherheit", "grundschutz"],
                },
                {
                    id: "ap1-1-a4-c",
                    title: "c) Schutzbedarf begründen (6 Punkte)",
                    description: `Im Rahmen einer Schutzbedarfsanalyse wurde der Schutzbedarf verschiedener IT-Anwendungen der Zahnarztpraxis bereits zugeordnet.

Folgende Kategorien werden verwendet:

┌──────────────────┬──────────────────────────────────────────────────────────────┐
│ Kategorie        │ Beschreibung                                                 │
├──────────────────┼──────────────────────────────────────────────────────────────┤
│ Niedrig / mittel │ Die Schadensauswirkungen sind begrenzt und überschaubar      │
│ Hoch             │ Die Schadensauswirkungen können beträchtlich sein            │
│ Sehr hoch        │ Schadensauswirkungen können existenziell bedrohliche oder    │
│                  │ katastrophale Ausmaße erreichen                              │
└──────────────────┴──────────────────────────────────────────────────────────────┘

Fügen Sie für jede IT-Anwendung eine **passende Begründung** für den angegebenen Schutzbedarf hinzu:

┌────────────────────────────────────┬────────────────┬──────────┬─────────────────────┐
│ IT-Anwendung                       │ Schutzziel     │ Kategorie│ Begründung          │
├────────────────────────────────────┼────────────────┼──────────┼─────────────────────┤
│ Beispiel: Online-Terminvergabe     │ Verfügbarkeit  │ Hoch     │ Ausfall führt zu    │
│                                    │                │          │ Buchungsstau und    │
│                                    │                │          │ Patientenverlust    │
├────────────────────────────────────┼────────────────┼──────────┼─────────────────────┤
│ 1) E-Rezept-System                 │ Integrität     │ Sehr hoch│                     │
├────────────────────────────────────┼────────────────┼──────────┼─────────────────────┤
│ 2) Praxis-Buchhaltung              │ Vertraulichkeit│ Hoch     │                     │
├────────────────────────────────────┼────────────────┼──────────┼─────────────────────┤
│ 3) Patientenakten (digital)        │ Vertraulichkeit│ Sehr hoch│                     │
├────────────────────────────────────┼────────────────┼──────────┼─────────────────────┤
│ 4) Internes Wiki / Anleitungen     │ Integrität     │ Niedrig  │                     │
└────────────────────────────────────┴────────────────┴──────────┴─────────────────────┘

Schreiben Sie zu jeder der vier Zeilen eine kurze, treffende Begründung (1-2 Sätze).`,
                    type: "freeText",
                    points: 6,
                    hint: "Denken Sie an: Folgen einer Manipulation (Integrität), Folgen einer Offenlegung (Vertraulichkeit), gesetzliche Vorgaben (Patientenakten = §203 StGB).",
                    tags: ["datenschutz", "schutzbedarfsanalyse"],
                },
                {
                    id: "ap1-1-a4-d",
                    title: "d) Besonderer Datenschutz (2 Punkte)",
                    description: `Eine Mitarbeiterin der Zahnarztpraxis fragt Sie, für welche Art von Daten ein besonderer gesetzlicher Schutz vorgeschrieben ist.

Geben Sie ihr Auskunft und nennen Sie hierzu eine **rechtliche Grundlage**.`,
                    type: "freeText",
                    points: 2,
                    hint: "Gesundheitsdaten gehören zu den besonderen Kategorien personenbezogener Daten. Relevante Gesetze: DSGVO Art. 9, BDSG, ärztliche Schweigepflicht (§203 StGB).",
                    tags: ["datenschutz", "dsgvo", "recht"],
                },
                {
                    id: "ap1-1-a4-e",
                    title: "e) Sichere Passwörter (4 Punkte)",
                    description: `Nennen Sie **zwei Kriterien**, die ein sicheres Passwort erfüllen sollte. Beschreiben Sie für jedes Kriterium, **warum** es zu einer höheren Sicherheit führt.

Format:
Kriterium 1: _______________
Begründung: _______________

Kriterium 2: _______________
Begründung: _______________`,
                    type: "freeText",
                    points: 4,
                    hint: "Länge erschwert Brute-Force, Komplexität (Sonderzeichen, Groß-/Kleinschreibung) vergrößert den Zeichenraum, Eindeutigkeit pro Dienst verhindert Credential-Stuffing.",
                    tags: ["it-sicherheit", "passwoerter"],
                },
                {
                    id: "ap1-1-a4-fa",
                    title: "f-a) Risiken einer Backup-Strategie (2 Punkte)",
                    description: `Die Buchhaltungssoftware der Praxis ist so eingerichtet, dass der Datenbestand jeden Freitagabend beim Herunterfahren der PCs auf einer speziell eingerichteten **Partition derselben Festplatte** gesichert wird.

Ihr Teamleiter beauftragt Sie, der Praxisinhaberin die Risiken dieses Vorgehens aufzuzeigen.

Beschreiben Sie **zwei** der Risiken.`,
                    type: "freeText",
                    points: 2,
                    hint: "Was passiert bei einem Festplatten-Defekt? Was bei einem Ransomware-Angriff, der auch die Partition verschlüsselt? Was bei Diebstahl oder Brand?",
                    tags: ["backup", "datensicherung", "it-sicherheit"],
                },
                {
                    id: "ap1-1-a4-fb",
                    title: "f-b) Verbesserungsvorschlag Backup (2 Punkte)",
                    description: `Unterbreiten Sie der Praxisinhaberin einen **konkreten Verbesserungsvorschlag** zur Backup-Strategie.

Begründen Sie Ihren Vorschlag.`,
                    type: "freeText",
                    points: 2,
                    hint: "Stichworte: 3-2-1-Regel, externes Medium, Offsite-Backup, Versionierung. Wichtig: räumliche und logische Trennung vom Original.",
                    tags: ["backup", "datensicherung", "best-practices"],
                },
            ],
        },
    ],
};