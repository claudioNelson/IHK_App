import { Exam } from "../exam-types";

export const ae1: Exam = {
    id: "ae-1",
    title: "AE Prüfung 1 - Winter 2016/17",
    year: 2016,
    season: "Winter",
    company: "TransLogic GmbH",
    duration: 90,
    totalPoints: 100,
    scenario: `Sie sind Mitarbeiter/-in der DevSoft AG und werden beauftragt, für die TransLogic GmbH verschiedene Softwarelösungen zu entwickeln.

Die TransLogic GmbH ist ein Logistikunternehmen, das Frachttransporte zwischen verschiedenen Standorten durchführt.

Sie sollen vier der folgenden fünf Aufgaben erledigen:
1. Ein UML-Aktivitätsdiagramm erstellen
2. Einen Algorithmus zur Routenoptimierung entwickeln
3. Einen Algorithmus zur Transportauswahl entwickeln
4. Ein ER-Diagramm erstellen
5. SQL-Anweisungen erstellen`,
    sections: [
        {
            id: "hs1",
            title: "Handlungsschritt 1: UML-Aktivitätsdiagramm (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs1-q1",
                    title: "UML-Aktivitätsdiagramm - Fahrzeugwartung",
                    description: `Die Wartung der LKW-Flotte der TransLogic GmbH soll in einem UML-Aktivitätsdiagramm modelliert werden.

Der Ablauf der Fahrzeugwartung ist wie folgt organisiert:

AKTEURE:
- Werkstatt
- Disponent

ABLAUF:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Die Werkstatt prüft, ob eine Inspektion-A oder Inspektion-B durchgeführt werden muss.

2. Bei Inspektion-A:
   - Ölwechsel durchführen
   - Bremsen prüfen
   - Beide Aktivitäten können parallel ausgeführt werden

3. Bei Inspektion-B:
   - Alle Aktivitäten von Inspektion-A durchführen
   - Zusätzlich: Reifen wechseln

4. Nach Abschluss der Inspektion:
   - Die Werkstatt erstellt einen Wartungsbericht
   - Der Disponent wird über den Abschluss informiert
   - Der Disponent aktualisiert den Fahrzeugstatus

5. Der Prozess endet nach der Statusaktualisierung.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUFGABE:
Erstellen Sie ein UML-Aktivitätsdiagramm für den beschriebenen Ablauf.

Verwenden Sie:
- Schwimmbahnen für die Akteure
- Start- und Endknoten
- Aktivitäten, Entscheidungen, Parallelisierung (Fork/Join)`,
                    type: "diagram",
                    points: 25,
                    hint: "Welche Aktivitäten können parallel ablaufen? Wo gibt es eine Verzweigung zwischen Inspektion-A und B?",
                },
            ],
        },
        {
            id: "hs2",
            title: "Handlungsschritt 2: Algorithmus Routenoptimierung (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs2-q1",
                    title: "Algorithmus - Günstigste Route finden",
                    description: `Die TransLogic GmbH möchte für Frachttransporte die günstigste Route ermitteln.

Ein Netzwerk von Strecken verbindet verschiedene Standorte. Jede Strecke hat:
- Eine maximale Kapazität (in Tonnen)
- Einen Preis pro Tonne

STRECKENNETZ:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         [10t, 5€]         [8t, 3€]
    A ─────────────► C ─────────────► B
    │                                 ▲
    │ [15t, 4€]              [12t, 6€]│
    │                                 │
    └──────────────► D ───────────────┘
                     │
                     │ [20t, 2€]
                     ▼
                     E ─────────────► B
                          [10t, 4€]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ROUTENTABELLE (von A nach B):
| Route | Strecke 1 | Strecke 2 | Strecke 3 |
|-------|-----------|-----------|-----------|
| 1     | A→C       | C→B       | -         |
| 2     | A→D       | D→B       | -         |
| 3     | A→D       | D→E       | E→B       |

HILFSFUNKTIONEN:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Funktion                    | Beschreibung                              |
|-----------------------------|-------------------------------------------|
| holeStreckeKapazitaet(s)    | Gibt die Kapazität der Strecke s zurück   |
| holeStreckePreis(s)         | Gibt den Preis pro Tonne der Strecke zurück|
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUFGABE:
Entwickeln Sie einen Algorithmus, der für eine gegebene Ladung (in Tonnen) die günstigste Route findet.

Funktionssignatur:
    findeRoute(ladung: Integer): Integer

Rückgabe: Routennummer (1, 2 oder 3) oder -1 wenn keine Route möglich

ANFORDERUNGEN:
- Eine Route ist nur gültig, wenn ALLE Teilstrecken genug Kapazität haben
- Der Gesamtpreis = Summe aller (Streckenpreis × Ladung)
- Bei gleichen Preisen: niedrigere Routennummer bevorzugen`,
                    type: "code",
                    points: 25,
                    image: "/images/hs2-graph.png",
                    hint: "Prüfen Sie zuerst, ob die Kapazität aller Teilstrecken ausreicht. Vergleichen Sie dann die Gesamtkosten der gültigen Routen.",
                },
            ],
        },
        {
            id: "hs3",
            title: "Handlungsschritt 3: Algorithmus Transportauswahl (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs3-q1",
                    title: "Algorithmus - Transporte filtern und sortieren",
                    description: `Die DevSoft AG soll für die TransLogic GmbH eine Funktion entwickeln, mit der Transporte ausgewählt werden können:
- die an einem bestimmten Tag durchgeführt werden
- und die mindestens eine gewünschte Anzahl freier Ladeplätze bieten.

Die Daten eines Transports sind in einem Transport-Objekt enthalten. Die entsprechende Klasse "Transport" wurde bereits entwickelt. Für jedes Attribut der Klasse Transport liegen öffentliche get-/set-Methoden vor.

KLASSE TRANSPORT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Transport                                      |
|------------------------------------------------|
| - id: String                                   |
| - transportDatum: Date                         |
| - abfahrtZeit: Date                            |
| - ankunftZeit: Date                            |
| - preis: Double                                |
| - freiePlaetze: Integer                        |
| ...                                            |
|------------------------------------------------|
| + getId(): String                              |
| + getTransportDatum(): Date                    |
| + getAbfahrtZeit(): Date                       |
| + getAnkunftZeit(): Date                       |
| + getPreis(): Double                           |
| + getFreiePlaetze(): Integer                   |
| ...                                            |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Das Array "Linien_Transporte" enthält die Transport-Objekte aller Transporte, die auf einer bestimmten Strecke nonstop durchgeführt werden.

Das gewünschte Transportdatum und die Anzahl der benötigten Plätze werden der neuen Funktion als Parameter übergeben.

ANFORDERUNGEN AN DIE FUNKTION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Aus dem Array "Linien_Transporte" die Transport-Objekte auswählen, welche:
   - am gewünschten Datum durchgeführt werden UND
   - die benötigten Plätze bieten

2. Die ausgewählten Transport-Objekte in einem neuen Array "Auswahl_Transporte" speichern

3. Die Transport-Objekte nach Preis AUFSTEIGEND sortieren

4. Eine Referenz auf das Array "Auswahl_Transporte" zurückgeben
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUFGABE:
Erstellen Sie die entsprechende Funktion:

    erstelleTransporte(datum: Date, plaetze: Integer): Transport[]

Stellen Sie den Algorithmus in Pseudocode, einem Struktogramm oder einem Programmablaufplan (PAP) dar.`,
                    type: "code",
                    points: 25,
                    hint: "Zuerst filtern (Datum UND Plätze), dann sortieren. Welches einfache Sortierverfahren kennen Sie?",
                },
            ],
        },
        {
            id: "hs4",
            title: "Handlungsschritt 4: ER-Diagramm (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs4-q1",
                    title: "ER-Diagramm - Transportdatenbank",
                    description: `Die durchgeführten Transporte sollen in einem relationalen Datenbanksystem erfasst werden.

Für die Entwicklung des Datenbanksystems liegt folgende Beschreibung vor:

FACHLICHE BESCHREIBUNG:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Auf einem Frachttransport werden Sendungen, die von einem oder mehreren Kunden stammen, transportiert.

- Die Sendung eines Kunden kann auf einen oder mehrere Transporte verteilt werden.

- Ein Transport wird mit einem Fahrzeug ausgeführt.

- Ein Fahrzeug wird für viele Transporte eingesetzt.

- Ein Transport wird von verschiedenen Fahrern gefahren.

- Fahrer können auf verschiedenen Fahrzeugen eingesetzt werden.

- Ein Fahrer führt viele Transporte durch.

- Ein Transport wird von zwei Fahrern ausgeführt.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUFGABE:
Erstellen Sie ein entsprechendes ER-Diagramm OHNE Attribute.

Hinweis: Verwenden Sie die Chen-Notation oder die Krähenfuß-Notation.`,
                    type: "diagram",
                    points: 25,
                    hint: "Welche Tabellen müssen Sie verbinden, um von Kunde zu Transport_ID zu gelangen?",
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
                    title: "Datenbankschema - TransLogic Transportdatenbank",
                    description: `Die DevSoft AG wurde von der TransLogic GmbH beauftragt, verschiedene SQL-Anweisungen zur Auswertung folgender Datenbank zu erstellen.

TABELLE: Fahrzeug_Ladeplan
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Platz_ID | Fahrzeug_ID | Platz |
|----------|-------------|-------|
| 1        | 14          | 1A    |
| 2        | 14          | 1B    |
| 3        | 14          | 2A    |
| 4        | 14          | 2B    |
| 5        | 14          | 3A    |
| 6        | 14          | 3B    |
| 7        | 15          | 1A    |
| ...      |             |       |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TABELLE: Transport
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Transport_ID | von     | nach    | Abfahrt | Ankunft | Preis |
|--------------|---------|---------|---------|---------|-------|
| 1            | Hamburg | München | 09:00   | 17:00   | 60.00 |
| 2            | München | Hamburg | 10:00   | 18:00   | 40.00 |
| 3            | Hamburg | München | 11:00   | 19:00   | 50.00 |
| ...          |         |         |         |         |       |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TABELLE: Transport_Datum
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Transport_Datum_ID | Transport_ID | Datum      | Fahrzeug_ID |
|--------------------|--------------|------------|-------------|
| 521                | 1            | 02.12.2024 | 14          |
| 522                | 2            | 02.12.2024 | 14          |
| 693                | 2            | 15.12.2024 | 15          |
| ...                |              |            |             |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Hinweis: Das Feld Datum ist vom Typ String.

TABELLE: Buchung
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Buchung_ID | Transport_Datum_ID | Kunde_ID | Platz |
|------------|-------------------|----------|-------|
| 1265       | 521               | 877      | 1B    |
| 1266       | 521               | 878      | 1A    |
| 1267       | 693               | 877      | 2A    |
| ...        |                   |          |       |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TABELLE: Kunde
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Kunde_ID | Typ  | Name    | Ansprechpartner |
|----------|------|---------|-----------------|
| 877      | GmbH | Müller  | Lisa            |
| 878      | AG   | Schmidt | Karl            |
| 1324     | KG   | Weber   | Paula           |
| ...      |      |         |                 |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Erstellen Sie für folgende Auswertungen jeweils die entsprechende SQL-Anweisung.`,
                    type: "info",
                    points: 0,
                    hint: "Dies ist die Einleitung mit dem Datenbankschema. Die SQL-Aufgaben folgen.",
                },
                {
                    id: "hs5-a",
                    title: "Aufgabe a) Kundenliste für Transport (8 Punkte)",
                    description: `Für den Transport mit der ID 1 am 02.12.2024:

Erstellen Sie eine aktuelle Kundenliste, nach Plätzen AUFSTEIGEND sortiert.

ERWARTETE AUSGABE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Platz | Name    | Ansprechpartner |
|-------|---------|-----------------|
| 1A    | Schmidt | Karl            |
| 1B    | Müller  | Lisa            |
| 3B    | Weber   | Paula           |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Hinweise:
- Das Feld Datum ist vom Typ String
- Auswahlkriterien: Transport_ID = 1 UND Datum = '02.12.2024'`,
                    type: "code",
                    points: 8,
                    hint: "Welche Tabellen müssen Sie verbinden, um von Kunde zu Transport_ID zu gelangen?",
                },
                {
                    id: "hs5-b",
                    title: "Aufgabe b) Prozentualer Anteil GmbH-Kunden (5 Punkte)",
                    description: `Ermitteln Sie den prozentualen Anteil der GmbH-Kunden an der Gesamtheit aller Kunden, die bisher mit der Spedition transportiert haben.

ERWARTETE AUSGABE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| AnteilGmbH |
|------------|
| 50         |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Hinweis: Es wird davon ausgegangen, dass der Divisor immer > 0 ist.`,
                    type: "code",
                    points: 5,
                    hint: "Wie können Sie die Anzahl der GmbH-Kunden durch die Gesamtanzahl teilen?",
                },
                {
                    id: "hs5-c",
                    title: "Aufgabe c) Tagesumsatz Hamburg-München (5 Punkte)",
                    description: `Ermitteln Sie den Umsatz eines Tages für Transporte von Hamburg nach München.

Annahme: Bei jedem Transport werden vier Sendungen transportiert.

ERWARTETE AUSGABE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Tagesumsatz |
|-------------|
| 840.00 EUR  |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`,
                    type: "code",
                    points: 5,
                    hint: "Welche Aggregatfunktion summiert Werte? Wie filtern Sie die Route Hamburg-München?",
                },
                {
                    id: "hs5-d",
                    title: "Aufgabe d) Freie Plätze mit NOT EXISTS (7 Punkte)",
                    description: `Erstellen Sie eine Liste der freien Plätze für den Transport mit der Transport_Datum_ID 521.

ERWARTETE AUSGABE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Platz |
|-------|
| 2A    |
| 2B    |
| 3A    |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ergänzen Sie den folgenden SQL-Entwurf.

Hinweise:
- Verwenden Sie nur die Tabellen Fahrzeug_Ladeplan und Buchung
- NOT EXISTS ist erfüllt, wenn die Unterabfrage KEINE Zeilen zurückgibt`,
                    type: "fillBlanks",
                    points: 7,
                    hint: "NOT EXISTS prüft, ob die Unterabfrage keine Ergebnisse liefert. Welche Bedingung verknüpft die beiden Tabellen?",
                },
            ],
        },
    ],
};