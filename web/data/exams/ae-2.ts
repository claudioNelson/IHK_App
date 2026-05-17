import { Exam } from "../exam-types";

export const ae2: Exam = {
    id: "ae-2",
    title: "AE Prüfung 2 - Sommer 2017",
    year: 2017,
    season: "Sommer",
    company: "SecureID GmbH",
    duration: 90,
    totalPoints: 100,
    level: "ap2",
    fachrichtung: "ae",
    difficulty: "mittel",
    tags: ["uml-klasse", "uml-aktivität", "normalisierung", "sql", "algorithmen"],
    sectionsToChoose: 4,
    scenario: `Sie sind Mitarbeiter/-in der SecureID GmbH, Darmstadt, einem Softwaredienstleister im Bereich biometrische Sicherheitssysteme. Die SecureID GmbH erstellt Software zur Erfassung und Auswertung verschiedener biometrischer Daten.

Sie sollen vier der folgenden fünf Aufgaben erledigen:
1. Ein UML-Klassendiagramm erstellen
2. Eine Funktion zur Auswertung von Iris-Scans erstellen
3. Ein UML-Aktivitätsdiagramm erstellen
4. Ein relationales Datenmodell erstellen
5. SQL-Anweisungen für eine Datenbank erstellen`,
    sections: [
        {
            id: "hs1",
            title: "Handlungsschritt 1: UML-Klassendiagramm (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs1-aa",
                    title: "Aufgabe a-aa) Assoziation beschreiben (2 Punkte)",
                    description: `Die SecureID GmbH soll eine Software zur Erkennung und Speicherung von Iris-Scans und Netzhaut-Scans erstellen. Zur Vorbereitung der Programmierung soll ein UML-Klassendiagramm erstellt werden.

Für eine Person sollen vom linken und rechten Auge jeweils folgende Scans gespeichert werden:

I1: Iris-Scan
N1: Netzhaut-Scan

Zu jedem Scan sollen ein Bild und ein String gespeichert werden.

Die Zeichenkette enthält Beschreibungen derjenigen Merkmale des Scans, die beim Vergleich von Scans verwendet werden.

Die Zeichenkette wird von der Methode berechneMerkmal() anhand des Bildes berechnet.

Die Algorithmen zur Berechnung der Zeichenketten sind für Iris-Scan und Netzhaut-Scan unterschiedlich.

Es existiert bereits folgende Klasse Scan, die für das Klassendiagramm verwendet werden soll:

┌─────────────────────────────┐
│ Scan                        │
├─────────────────────────────┤
│ - bild: Bild                │
│ - merkmal: String           │
├─────────────────────────────┤
│ + berechneMerkmal()         │
└─────────────────────────────┘

In einem UML-Klassendiagramm können die folgenden Beziehungen vorkommen.
Beschreiben Sie jeweils kurz:

aa) Assoziation`,
                    type: "freeText",
                    points: 2,
                    hint: `Assoziation: Eine allgemeine Beziehung zwischen zwei Klassen. Objekte der einen Klasse kennen Objekte der anderen Klasse.`,
                    tags: ["uml-klasse", "theorie", "assoziation"],
                },
                {
                    id: "hs1-ab",
                    title: "Aufgabe a-ab) Vererbung beschreiben (2 Punkte)",
                    description: `ab) Vererbung`,
                    type: "freeText",
                    points: 2,
                    hint: `Vererbung: Eine Klasse übernimmt Attribute und Methoden von einer anderen Klasse. "ist-ein"-Beziehung.`,
                    tags: ["uml-klasse", "theorie", "vererbung", "oop"],
                },
                {
                    id: "hs1-ac",
                    title: "Aufgabe a-ac) Komposition beschreiben (2 Punkte)",
                    description: `ac) Komposition`,
                    type: "freeText",
                    points: 2,
                    hint: `Komposition: Starke "Teil-von"-Beziehung. Das Teil kann ohne das Ganze nicht existieren.`,
                    tags: ["uml-klasse", "theorie", "komposition"],
                },
                {
                    id: "hs1-b",
                    title: "Aufgabe b) UML-Klassendiagramm erstellen (19 Punkte)",
                    description: `Erstellen Sie ein UML-Klassendiagramm, das ...

- die Klassen Person, Auge, IrisBereich, NetzhautBereich, Scan, IrisScan, NetzhautScan darstellt.
- die Beziehungen zwischen den Klassen mit ihren Kardinalitäten angibt.
- Geben Sie an, in welchen Klassen die Methode berechneMerkmal() überschrieben werden muss.`,
                    type: "diagram",
                    points: 19,
                    hint: `Struktur:
- Person hat 2 Augen (Komposition)
- Auge hat 1 IrisBereich und 1 NetzhautBereich (Komposition)
- IrisScan und NetzhautScan erben von Scan
- berechneMerkmal() muss in IrisScan und NetzhautScan überschrieben werden`,
                    diagram: { mode: "uml-class" },
                    tags: ["uml-klasse", "vererbung", "komposition", "kardinalitäten"],
                },
            ],
        },
        {
            id: "hs2",
            title: "Handlungsschritt 2: Algorithmus Iris-Auswertung (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs2-q1",
                    title: "Algorithmus - Prozedur auswertung",
                    description: `Um herauszufinden, von welcher Person ein Iris-Scan stammt, soll dieser mit Iris-Scans in einer Datenbank verglichen werden.

Die vorhandene Funktion suche(scan) gibt ein Array treffer aus, das zu jedem gefundenen Iris-Scan einen Score, eine Personen-ID und eine Auge-ID enthält.

PARAMETER DER PROZEDUR:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Parameter | Beschreibung                                        |
|-----------|-----------------------------------------------------|
| scan      | Zeichenkette; Werte des Iris-Scan-Bildes            |
| schwelle  | ganzzahliger Wert; 1 bis 100; Score-Schwellenwert   |
| auge      | 0 = Unbekannt; 1 = rechtes Auge; 2 = linkes Auge    |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

VERFÜGBARE FUNKTIONEN:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Funktion           | Beschreibung                                 |
|--------------------|----------------------------------------------|
| suche(scan)        | Gibt Array vom Typ Treffer zurück            |
| laenge(array)      | Liefert die Länge des Arrays                 |
| loesche(array,pos) | Löscht Element an Position pos               |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

BEISPIEL:

Array treffer von suche(scan):          Rückgabe bei schwelle=80, auge=1:
┌───────┬──────────┬────────┐           ┌───────┬──────────┬────────┐
│ score │ idPerson │ idAuge │           │ score │ idPerson │ idAuge │
├───────┼──────────┼────────┤           ├───────┼──────────┼────────┤
│ 85    │ 93334    │ 1      │           │ 98    │ 56446    │ 1      │
│ 80    │ 48774    │ 2      │           │ 85    │ 93334    │ 1      │
│ 98    │ 56446    │ 1      │           │ 81    │ 49982    │ 1      │
│ 71    │ 33961    │ 2      │           └───────┴──────────┴────────┘
│ 21    │ 73447    │ 1      │
│ 81    │ 49982    │ 1      │
└───────┴──────────┴────────┘

AUFGABE:
    auswertung(scan: String, schwelle: Integer, auge: Integer) : Treffer[]`,
                    type: "code",
                    points: 25,
                    hint: `1. treffer = suche(scan)
2. Filterphase (von hinten nach vorne):
   - score <= schwelle → löschen
   - auge != 0 UND idAuge != auge → löschen
3. Bubble Sort nach score ABSTEIGEND
4. Rückgabe: treffer`,
                    tags: ["algorithmen", "pseudocode", "bubble-sort", "filterung"],
                },
            ],
        },
        {
            id: "hs3",
            title: "Handlungsschritt 3: UML-Aktivitätsdiagramm & Minimum (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs3-a",
                    title: "Aufgabe a) UML-Aktivitätsdiagramm (20 Punkte)",
                    description: `Die SecureID GmbH soll ein System zur Iris-Scan-Recherche erstellen.

Die Recherche soll wie folgt organisiert werden:

- Ein Auftraggeber schickt einen Iris-Scan (IS) zur Identifizierung an den Operator.
- Der Operator prüft, ob die Qualität des IS in Ordnung ist.
- Ist die Qualität nicht ok → Info an Auftraggeber → Ende
- Ist die Qualität ok → Operator führt Suche durch
- Keine Treffer → Info an Auftraggeber → Ende
- Treffer gefunden → PARALLEL: Report erstellen UND Daten an Supervisor
- Supervisor protokolliert und schickt Info zurück
- Nach Report UND Info: Operator sendet Report an Auftraggeber → Ende

Erstellen Sie ein UML-Aktivitätsdiagramm mit Schwimmbahnen.`,
                    type: "diagram",
                    points: 20,
                    hint: `Schwimmbahnen: Auftraggeber | Operator | Supervisor

Wichtige Elemente:
- Fork für Parallelisierung
- Join für Synchronisation
- Zwei Entscheidungen (Qualität, Treffer)`,
                    diagram: { mode: "uml-activity" },
                    tags: ["uml-aktivität", "fork-join", "swimlanes"],
                },
                {
                    id: "hs3-b",
                    title: "Aufgabe b) Minimum ermitteln (5 Punkte)",
                    description: `Array treffer:
┌───────┬──────────┐
│ score │ idPerson │
├───────┼──────────┤
│ 21    │ 73447    │
│ 85    │ 93334    │
│ 80    │ 48774    │
│ 98    │ 56446    │
│ 81    │ 49982    │
└───────┴──────────┘

Ermitteln Sie den minimalen Score-Wert.

Beispiel-Ausgabe: minimaler Score = 21`,
                    type: "code",
                    points: 5,
                    hint: "Initialisieren Sie minimum mit dem ersten Element und durchlaufen Sie dann das Array.",
                    tags: ["algorithmen", "pseudocode", "minimum", "schleife"],
                },
            ],
        },
        {
            id: "hs4",
            title: "Handlungsschritt 4: Relationales Datenmodell (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs4-q1",
                    title: "Relationales Datenmodell in 3. Normalform",
                    description: `Die SecureID GmbH soll für eine Sicherheitsfirma eine Datenbank erstellen.

Erfassung von Vorfällen (Excel-Tabelle):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Vorfall | MA-ID | Anrede | MA-Name     | Geb.datum  | Adresse          |
|---------|-------|--------|-------------|------------|------------------|
| 501     | 7823  | Herr   | Schmidt, T. | 15.03.1985 | 60325 Frankfurt  |
| 502     | 4521  | Herr   | Müller, K.  | 22.07.1990 | 60489 Frankfurt  |
| 503     | 7823  | Herr   | Schmidt, T. | 15.03.1985 | 60325 Frankfurt  |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Vorfall-Typ    | Datum      | Dokument              | Bearbeiter    |
|----------------|------------|-----------------------|---------------|
| Einbruch       | 12.04.2024 | Personalausweis, FS   | Hansen, Klaus |
| Alarmauslösung | 18.04.2024 | Personalausweis       | Müller, Marcel|
| Sabotage       | 25.04.2024 | Reisepass, FS         | Hansen, Klaus |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Erstellen Sie ein relationales Datenmodell in der 3. Normalform.

- Selbsterklärende Namen für Tabellen und Attribute
- PK und FK kennzeichnen
- Beziehungen mit Kardinalitäten

Hinweis: Adresse muss nicht normalisiert werden.`,
                    type: "diagram",
                    points: 25,
                    hint: "Welche Daten wiederholen sich? Dokumente kommen mehrfach vor - wie lösen Sie das auf?",
                    tags: ["normalisierung", "3nf", "datenmodell"],
                },
            ],
        },
        {
            id: "hs5",
            title: "Handlungsschritt 5: SQL-Abfragen (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs5-intro",
                    title: "Datenbankschema - Zugangskontrolle",
                    description: `Datenbank für Zugangskontrolle mit Testdaten:

Person:
| PersID | Nachname | Vorname | Strasse      | Plz   | Ort      |
|--------|----------|---------|--------------|-------|----------|
| 101    | Müller   | Max     | Müllerweg 1  | 52335 | Köln     |
| 202    | Meier    | Willi   | Testweg 12   | 43333 | Dortmund |
| 404    | Wester   | Klaus   | Hauptstr. 13 | 55667 | Köln     |

Zugang:
| RaumID | PersID | ZeitVon | ZeitBis |
|--------|--------|---------|---------|
| 1      | 101    | 08:00   | 10:00   |
| 1      | 202    | 10:00   | 14:00   |
| 2      | 101    | 14:00   | 18:00   |
| 5      | 202    | 08:00   | 18:00   |

Raum:
| RaumID | RaumTyp          | GebID | MerkID |
|--------|------------------|-------|--------|
| 1      | Besprechungsraum | 2     | 1      |
| 2      | Labor            | 2     | 2      |
| 5      | Besprechungsraum | 1     | 1      |

Gebaeude:
| GebID | Bezeichnung | Strasse          | Plz   | Ort  |
|-------|-------------|------------------|-------|------|
| 1     | Forschung H | Heinrich-Str. 12 | 50501 | Köln |
| 2     | Forschung U | Heinrich-Str. 14 | 50501 | Köln |

Merkmal:
| MerkID | Merkmal       |
|--------|---------------|
| 1      | Iris-Scan     |
| 2      | Fingerabdruck |`,
                    type: "info",
                    points: 0,
                    hint: "Datenbankschema für die folgenden SQL-Aufgaben.",
                },
                {
                    id: "hs5-a",
                    title: "Aufgabe a) Gebäude mit Räumen (5 Punkte)",
                    description: `Liste aller Gebäude mit deren Räumen, sortiert nach Bezeichnung und RaumTyp.`,
                    type: "code",
                    points: 5,
                    hint: "Welche Tabellen müssen Sie JOINen? Wie sortieren Sie nach mehreren Spalten?",
                    tags: ["sql", "join", "order-by"],
                },
                {
                    id: "hs5-b",
                    title: "Aufgabe b) RIGHT JOIN Zugang (5 Punkte)",
                    description: `Liste aller Zugangsdaten mit dazugehörigen Personendaten.`,
                    type: "code",
                    points: 5,
                    hint: "Was ist der Unterschied zwischen LEFT JOIN und RIGHT JOIN?",
                    tags: ["sql", "right-join", "join"],
                },
                {
                    id: "hs5-c",
                    title: "Aufgabe c) Anzahl Räume pro Merkmal (6 Punkte)",
                    description: `Anzahl der Räume pro Zugangskontroll-Merkmal.

Erwartete Ausgabe:
| Merkmal       | AnzahlRaeume |
|---------------|--------------|
| Iris-Scan     | 2            |
| Fingerabdruck | 6            |`,
                    type: "code",
                    points: 6,
                    hint: "Welche Aggregatfunktion zählt Zeilen? Wie gruppieren Sie nach Merkmal?",
                    tags: ["sql", "count", "group-by", "aggregation"],
                },
                {
                    id: "hs5-d",
                    title: "Aufgabe d) Zugangsdaten Max Müller (6 Punkte)",
                    description: `Liste der Zugangsdaten von Max Müller (nur Name bekannt).`,
                    type: "code",
                    points: 6,
                    hint: "Wie filtern Sie nach einem bestimmten Namen? Welche Tabellen verknüpfen Person und Zugang?",
                    tags: ["sql", "where", "join"],
                },
                {
                    id: "hs5-e",
                    title: "Aufgabe e) PLZ-Bereich 50000-59999 (3 Punkte)",
                    description: `Liste aller Personen aus PLZ-Gebiet 50000-59999.`,
                    type: "code",
                    points: 3,
                    hint: "BETWEEN eignet sich gut für Bereichsabfragen.",
                    tags: ["sql", "between", "where"],
                },
            ],
        },
    ],
};