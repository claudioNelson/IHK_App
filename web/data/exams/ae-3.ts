import { Exam } from "../exam-types";

export const ae3: Exam = {
    id: "ae-3",
    title: "AE Prüfung 3 - Winter 2019/20",
    year: 2019,
    season: "Winter",
    company: "RadMobil GmbH",
    duration: 90,
    totalPoints: 100,
    level: "ap2",
    fachrichtung: "ae",
    difficulty: "schwer",
    tags: ["projektmanagement", "uml-zustand", "state-pattern", "normalisierung", "sql"],
    sectionsToChoose: 4,
    scenario: `Sie arbeiten in der CodeWorks GmbH, die Softwarelösungen für Handel und Dienstleistungen zur Verfügung stellt und verwaltet.

Die Firma RadMobil GmbH betreibt einen E-Scooter-Verleih mit Werkstatt.

Sie sollen vier der folgenden fünf Aufgaben in diesem Projekt erledigen:
1. Beim Management für das Projekt Abrechnungssoftware mitwirken
2. Programm zur Auswertung der Arbeitszeiterfassung anfertigen
3. Objektorientierte Software für Ladegerät entwickeln
4. Tabelle Wartung normalisieren
5. SQL-Abfragen zur Verleihdatenbank formulieren`,
    sections: [
        {
            id: "hs1",
            title: "Handlungsschritt 1: Projektmanagement (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs1-aa",
                    title: "Aufgabe a-aa) Methoden der Anforderungsanalyse (2 Punkte)",
                    description: `Für die Abrechnung der Servicemitarbeiter der RadMobil GmbH soll eine Abrechnungssoftware eingeführt werden.

Sie erhalten den Auftrag, eine Anforderungsanalyse für diese Software durchzuführen.

Nennen Sie zwei Methoden, die Sie für eine Anforderungsanalyse anwenden können.`,
                    type: "freeText",
                    points: 2,
                    hint: "Wie können Sie Informationen von Stakeholdern sammeln?",
                    tags: ["projektmanagement", "anforderungsanalyse"],
                },
                {
                    id: "hs1-ab",
                    title: "Aufgabe a-ab) Anforderungen an die Software (4 Punkte)",
                    description: `Beschreiben Sie zwei Anforderungen an die neu einzuführende Software.`,
                    type: "freeText",
                    points: 4,
                    hint: "Unterscheiden Sie funktionale und nicht-funktionale Anforderungen.",
                    tags: ["projektmanagement", "anforderungen", "funktional"],
                },
                {
                    id: "hs1-ba",
                    title: "Aufgabe b-a) Kick-off-Sitzung: Sach- und Beziehungsebene (8 Punkte)",
                    description: `Der Projektleiter Ihres Teams hat Ihnen mitgeteilt, dass das Projekt "Abrechnungssoftware" mit einer Kick-off-Sitzung begonnen wird.

Nennen Sie jeweils vier auf der Sachebene und der Beziehungsebene liegende Aufgabenstellungen dieser Kick-off-Sitzung.`,
                    type: "tableInput",
                    points: 8,
                    table: {
                        rowHeaderLabel: "Nr.",
                        columns: [
                            { key: "sach", label: "Sachebene", placeholder: "z.B. Projektziel festlegen", align: "left" },
                            { key: "bez",  label: "Beziehungsebene", placeholder: "z.B. Kennenlernen im Team", align: "left" },
                        ],
                        rows: [
                            { id: "row-1", label: "1" },
                            { id: "row-2", label: "2" },
                            { id: "row-3", label: "3" },
                            { id: "row-4", label: "4" },
                        ],
                    },
                    hint: "Sachebene = Was wird besprochen? Beziehungsebene = Wie arbeiten wir zusammen?",
                    tags: ["projektmanagement", "kommunikation", "kick-off"],
                },
                {
                    id: "hs1-bb",
                    title: "Aufgabe b-b) Befugnisse des Projektleiters (3 Punkte)",
                    description: `Nennen Sie drei Befugnisse, die der Projektleiter zur Wahrnehmung seiner Leitungsaufgaben haben muss.`,
                    type: "freeText",
                    points: 3,
                    hint: "Welche Rechte braucht ein Projektleiter, um Entscheidungen durchzusetzen?",
                    tags: ["projektmanagement", "projektleitung", "befugnisse"],
                },
                {
                    id: "hs1-ca",
                    title: "Aufgabe c-a) Nutzwertanalyse erweitern (6 Punkte)",
                    description: `Ihr Projektteam ist mit der Auswahl weiterer Softwarekomponenten beauftragt. Nach einer umfangreichen Marktanalyse haben Sie Ihre Auswahl auf zwei Softwarelösungen begrenzt. Um eine endgültige Entscheidung zu treffen, sollen Sie die Alternativen in einer Nutzwertanalyse vergleichen.

Ergänzen Sie die Nutzwertanalyse um weitere fünf Kriterien mit sinnvoller Gewichtung. Tragen Sie für jeden Anbieter den Erfüllungsgrad und den daraus berechneten Nutzwert ein.

Formel: Nutzwert (N) = Gewichtung (G) × Erfüllung (E)
Erfüllungsgrad: 1 = schlecht, 2 = mittel, 3 = gut
Summe der Gewichtungen muss 100 ergeben.`,
                    type: "tableInput",
                    points: 6,
                    table: {
                        rowHeaderLabel: "Kriterium",
                        columns: [
                            { key: "g",   label: "G",     placeholder: "Gew.", align: "center", width: "70px" },
                            { key: "e-a", label: "E (A)", placeholder: "1-3",  align: "center", width: "75px" },
                            { key: "n-a", label: "N (A)", placeholder: "G×E",  align: "center", width: "75px" },
                            { key: "e-b", label: "E (B)", placeholder: "1-3",  align: "center", width: "75px" },
                            { key: "n-b", label: "N (B)", placeholder: "G×E",  align: "center", width: "75px" },
                        ],
                        rows: [
                            {
                                id: "k1",
                                label: "Image des Softwareanbieters",
                                values: { g: "25", "e-a": "1", "n-a": "25", "e-b": "3", "n-b": "75" },
                            },
                            { id: "k2", label: "Kriterium 2" },
                            { id: "k3", label: "Kriterium 3" },
                            { id: "k4", label: "Kriterium 4" },
                            { id: "k5", label: "Kriterium 5" },
                            { id: "k6", label: "Kriterium 6" },
                            {
                                id: "summe",
                                label: "Σ Summe",
                                sublabel: "Σ G muss 100 ergeben",
                                values: { g: "100" },
                            },
                            {
                                id: "zuschlag",
                                label: "Zuschlag erhält",
                                sublabel: "Anbieter A oder B?",
                            },
                        ],
                    },
                    hint: "Welche Kriterien sind bei Softwareauswahl wichtig? Die Gewichtungen müssen 100 ergeben.",
                    tags: ["projektmanagement", "nutzwertanalyse", "entscheidung"],
                },
                {
                    id: "hs1-cb",
                    title: "Aufgabe c-b) Kritikpunkt Nutzwertanalyse (2 Punkte)",
                    description: `Nennen Sie einen möglichen Kritikpunkt an der Nutzwertanalyse.`,
                    type: "freeText",
                    points: 2,
                    hint: "Wie objektiv sind die Bewertungen in einer Nutzwertanalyse?",
                    tags: ["projektmanagement", "nutzwertanalyse", "kritik"],
                },
            ],
        },
        {
            id: "hs2",
            title: "Handlungsschritt 2: Algorithmus Zeiterfassung (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs2-q1",
                    title: "Algorithmus - Zeiterfassungsliste erstellen",
                    description: `Die RadMobil GmbH möchte ihren Mitarbeitern die Möglichkeit geben, jederzeit eine aktuelle Auswertung ihrer erfassten Arbeitszeiten eines Monats zu erhalten.

ANGABEN ZUR ZEITERFASSUNG:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Für jeden Tag werden maximal zwei Zeiten erfasst: Kommen- und Gehen-Zeit
- Pausen werden nicht berücksichtigt

REGELN FÜR DIE ZEITERFASSUNGSLISTE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Liegen Kommen- und Gehen-Buchungen vor → Zeiten und berechnete Anwesenheit ausgeben
- Liegt nur eine Kommen-Zeit vor → Anwesenheit 00:00 und "Buchung fehlt" ausgeben
- Liegt keine Zeitbuchung vor → Anwesenheit 00:00 und "nicht anwesend" ausgeben
- Am Ende: Summe der Anwesenheitszeiten ausgeben

BEISPIEL - Zeiterfassungsliste:
┌─────────────────────────────────────────────────────────────┐
│ Mitarbeiter: 12345                    Oktober 2024         │
│                                                             │
│ Tag  Kommen  Gehen   Anwesenheit  Bemerkung                │
│ ═══════════════════════════════════════════════════════════│
│ 1                    00:00        nicht anwesend           │
│ 2    08:10   17:20   09:10                                 │
│ 3    07:50           00:00        Buchung fehlt            │
│ 4                    00:00        nicht anwesend           │
│ 5                    00:00        nicht anwesend           │
│ 6    08:00   16:00   08:00                                 │
│ 7    16:30           00:00        Buchung fehlt            │
│ 8    08:20   16:40   08:20                                 │
│ ...                                                         │
│ 30   08:10           00:00        Buchung fehlt            │
│ 31                   00:00        nicht anwesend           │
│ ═══════════════════════════════════════════════════════════│
│ Summe Anwesenheit: 43:10                                   │
└─────────────────────────────────────────────────────────────┘

ZEITERFASSUNGSTABELLE (2D-Array "zeiten"):
| Tag | Stunde | Minute |
|-----|--------|--------|
| 2   | 8      | 10     |
| 2   | 17     | 20     |
| 3   | 7      | 50     |
| 6   | 8      | 00     |
| 6   | 16     | 00     |
| 7   | 16     | 30     |
| 8   | 8      | 20     |
| 8   | 16     | 40     |
| 30  | 8      | 10     |

VERFÜGBARE FUNKTIONEN:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Funktion | Beschreibung |
|----------|--------------|
| tageImMonat(monat, jahr) | Gibt Anzahl der Tage im Monat zurück |
| schreibeKopf(persnr, jahr, monat) | Gibt die Kopfzeilen der Liste aus |
| schreibeZeile(tag, std1, min1, std2, min2, anwTag, bemerkung) | Gibt eine Datenzeile aus. Für fehlende Zeiten ist -1 anzugeben. anwTag in Minuten, Ausgabe in Stunden:Minuten |
| schreibeFuss(anwMonat) | Gibt die Fußzeile aus. anwMonat in Minuten, Ausgabe in Stunden:Minuten |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUFGABE:
Erstellen Sie für die Methode 'erzeugeListe()' einen entsprechenden Algorithmus in Pseudocode, Struktogramm oder PAP.

Funktionssignatur:
    erzeugeListe(persnr: int, zeiten: int[][], jahr: int, monat: int)`,
                    type: "code",
                    points: 25,
                    hint: "Durchlaufen Sie jeden Tag des Monats und prüfen Sie, wie viele Buchungen vorliegen.",
                    tags: ["algorithmen", "pseudocode", "schleife", "zeiterfassung"],
                },
            ],
        },
        {
            id: "hs3",
            title: "Handlungsschritt 3: UML-Zustandsdiagramm & State Pattern (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs3-a",
                    title: "Aufgabe a) UML-Zustandsdiagramm Ladegerät (16 Punkte)",
                    description: `Bei der RadMobil GmbH werden programmierbare Ladegeräte für E-Scooter-Akkus eingesetzt.

Sie sollen als Mitarbeiter/-in der CodeWorks GmbH eine Software entwickeln, die folgendes leistet:

ZUSTANDSÜBERGÄNGE (Auslösung erfolgt minütlich):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Nach dem Einschalten befindet sich das Ladegerät im Zustand "nichtLadend"

- Ist der Ladestand des Akkus kleiner 20 Prozent → Akku ist defekt
  → Das Ladegerät bleibt im Zustand "nichtLadend"

- Ist der Ladestand größer gleich 20 und kleiner 100 Prozent
  → Das Gerät schaltet zunächst in den Zustand "normalLadend"

- Ist der Ladestand kleiner 80 Prozent
  → wird in den Zustand "schnellLadend" weitergeschaltet

- Sobald der Ladestand 80 Prozent erreicht
  → schaltet das Gerät in den Zustand "normalLadend" zurück

- Ist der Ladestand von 100 Prozent erreicht
  → wechselt das Gerät wieder in den Zustand "nichtLadend" und verbleibt dort
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Erstellen Sie ein UML-Zustandsdiagramm für den beschriebenen Ladevorgang.

Hinweis: Notation für UML-Zustandsdiagramm siehe Belegsatz.`,
                    type: "diagram",
                    points: 16,
                    hint: "Identifizieren Sie die drei Zustände und die Bedingungen für die Übergänge.",
                    diagram: { mode: "uml-state" },
                    tags: ["uml-zustand", "ladevorgang", "zustandsübergänge"],
                },
                {
                    id: "hs3-ba",
                    title: "Aufgabe b-a) Konstruktor Ladegerät (2 Punkte)",
                    description: `Die Software soll objektorientiert nach dem Zustand-Entwurfsmuster (State Pattern) programmiert werden.

UML-KLASSENDIAGRAMM (State Pattern):

ABSTRAKTE KLASSE ZUSTAND:
+---------------------------------+
| <<abstract>> Zustand            |
+---------------------------------+
| + bearbeiten(Ladegerät): void   |
|   {abstract}                    |
+---------------------------------+

KONTEXT-KLASSE LADEGERÄT:
+---------------------------------+
| Ladegerät                       |
+---------------------------------+
| - zustand: Zustand              |
| - ladestand: int                |
+---------------------------------+
| + Ladegerät()                   |
| + setZustand(Zustand): void     |
| + getLadestand(): int           |
| + ausloesen(): void             |
+---------------------------------+
  → ausloesen() ruft: zustand.bearbeiten(this)

KONKRETE ZUSTANDSKLASSEN (erben von Zustand):

+---------------------------------+
| NichtLadend                     |
+---------------------------------+
| - nichtLadend: NichtLadend      |
|   {static}                      |
+---------------------------------+
| - NichtLadend()                 |
| + getNichtLadend(): NichtLadend |
|   {static}                      |
| + bearbeiten(Ladegerät): void   |
+---------------------------------+

+---------------------------------+
| NormalLadend                    |
+---------------------------------+
| - normalLadend: NormalLadend    |
|   {static}                      |
+---------------------------------+
| - NormalLadend()                |
| + getNormalLadend(): NormalLadend|
|   {static}                      |
| + bearbeiten(Ladegerät): void   |
+---------------------------------+

+---------------------------------+
| SchnellLadend                   |
+---------------------------------+
| - schnellLadend: SchnellLadend  |
|   {static}                      |
+---------------------------------+
| - SchnellLadend()               |
| + getSchnellLadend(): SchnellLadend|
|   {static}                      |
| + bearbeiten(Ladegerät): void   |
+---------------------------------+

AUFGABE:
Im Konstruktor der Klasse Ladegerät wird der Anfangszustand durch Initialisierung von "zustand" mit einem NichtLadend-Objekt festgelegt.

Formulieren Sie die entsprechende Anweisung:

+ Ladegerät()`,
                    type: "code",
                    points: 2,
                    hint: "Wie greifen Sie auf das Singleton-Objekt der Klasse NichtLadend zu?",
                    tags: ["oop", "state-pattern", "singleton", "konstruktor"],
                },
                {
                    id: "hs3-bb",
                    title: "Aufgabe b-b) bearbeiten-Methode NichtLadend (3 Punkte)",
                    description: `In der bearbeiten-Methode der Klasse NichtLadend wird bei einem Akku-Ladestand größer gleich 20 und kleiner 100 der Referenz "zustand" des Ladegeräts ein NormalLadend-Objekt zugewiesen.

Formulieren Sie die Kontrollstruktur mit entsprechender Anweisung.

+ bearbeiten(ladegerät : Ladegerät) : void`,
                    type: "code",
                    points: 3,
                    hint: "Welche Bedingung prüft den Ladestand? Wie setzen Sie den neuen Zustand?",
                    tags: ["oop", "state-pattern", "methode", "kontrollstruktur"],
                },
                {
                    id: "hs3-bc",
                    title: "Aufgabe b-c) Polymorphie erklären (4 Punkte)",
                    description: `Erläutern Sie anhand des gegebenen Entwurfsmusters den Begriff Polymorphie. Nutzen Sie dazu die Instanzvariable "zustand".`,
                    type: "freeText",
                    points: 4,
                    hint: "Welchen Typ hat die Variable 'zustand'? Welche konkreten Objekte kann sie referenzieren?",
                    tags: ["oop", "polymorphie", "theorie", "state-pattern"],
                },
            ],
        },
        {
            id: "hs4",
            title: "Handlungsschritt 4: Normalisierung (25 Punkte)",
            totalPoints: 25,
            questions: [
                {
                    id: "hs4-intro",
                    title: "Ausgangstabelle - Wartungsdaten",
                    description: `Der nachfolgende Tabellenausschnitt zeigt, wie in der Werkstatt der RadMobil GmbH die Wartung (Wart) der E-Scooter (Scoot) durch Mitarbeiter (Ma) dokumentiert wird.

Sie sollen als Mitarbeiter/-in der CodeWorks GmbH diesen Datenbestand in drei Schritten in eine relationale Datenbank überführen.

AUSGANGSTABELLE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| ScootID | ScootTyp    | WartDatum  | WartArtID | WartArt   | Zeit | MaID | MaName           |
|---------|-------------|------------|-----------|-----------|------|------|------------------|
| E5      | Modell 400  | 2024-10-17 | 12,       | Bremse,   | 30   | 123, | Klaus Müller,    |
|         |             |            | 09,       | Batterie, | 12   | 345, | Beatrice Richter,|
|         |             |            | 05        | Reifen    | 15   | 456  | Kurt Helmig      |
| C2      | Cruiser 28  | 2024-10-20 | 03,       | Lager,    | 25   | 345, | Beatrice Richter |
|         |             |            | 12        | Bremse    | 10   | 123  | Klaus Müller     |
| E5      | Modell 400  | 2024-11-15 | 09        | Batterie  | 15   | 123  | Klaus Müller     |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NORMALFORMEN-DEFINITIONEN:
| Normalform | Definition |
|------------|------------|
| 1. Normalform | Tabelle enthält nur atomare Attributwerte |
| 2. Normalform | Alle Nicht-Schlüssel-Attribute hängen vom gesamten Primärschlüssel ab |
| 3. Normalform | Tabelle enthält nur Spalten, die nicht transitiv vom Primärschlüssel abhängen |`,
                    type: "info",
                    points: 0,
                },
                {
                    id: "hs4-a",
                    title: "Aufgabe a) Erste Normalform (9 Punkte)",
                    description: `Erstellen Sie aus der gegebenen Tabelle eine neue Tabelle, die der ersten Normalform entspricht.

- Tragen Sie alle Attributwerte ein
- Bilden Sie aus den bestehenden Attributen einen zusammengesetzten Primärschlüssel
- Kennzeichnen Sie die einzelnen Teilattribute des Primärschlüssels durch Unterstreichen`,
                    type: "diagram",
                    points: 9,
                    hint: "Atomare Werte: Jede Zelle enthält nur einen Wert. Welche Spalten haben mehrere Werte?",
                    diagram: { mode: "table" },
                    tags: ["normalisierung", "1nf", "primärschlüssel"],
                },
                {
                    id: "hs4-b",
                    title: "Aufgabe b) Zweite Normalform (11 Punkte)",
                    description: `Bringen Sie den Datenbestand durch Aufteilung in mehrere Tabellen in die zweite Normalform.

- Geben Sie den Tabellen sinnvolle Namen
- Kennzeichnen Sie die Primärschlüssel durch Unterstreichen
- Geben Sie die Beziehungen zwischen den Tabellen an`,
                    type: "diagram",
                    points: 11,
                    hint: "Welche Attribute hängen nur von einem Teil des Schlüssels ab?",
                    diagram: { mode: "table" },
                    tags: ["normalisierung", "2nf", "primärschlüssel", "abhängigkeiten"],
                },
                {
                    id: "hs4-c",
                    title: "Aufgabe c) Dritte Normalform (5 Punkte)",
                    description: `Überführen Sie den Datenbestand abschließend in die dritte Normalform.

- Geben Sie eventuell neu entstehende Tabellen sinnvolle Namen
- Kennzeichnen Sie die Primärschlüssel durch Unterstreichen
- Geben Sie die Beziehungen zwischen den Tabellen an`,
                    type: "diagram",
                    points: 5,
                    hint: "Gibt es Attribute, die von anderen Nicht-Schlüssel-Attributen abhängen?",
                    diagram: { mode: "table" },
                    tags: ["normalisierung", "3nf", "transitive-abhängigkeit"],
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
                    title: "Datenbankschema - Verleihdatenbank",
                    description: `Die RadMobil GmbH verwaltet ihre Kunden, Buchungen und E-Scooter in der folgenden Datenbank:

DATENBANKSCHEMA:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌────────────┐     ┌────────────┐     ┌────────────┐     ┌────────────┐
│ Kunde      │     │ Buchung    │     │ VerleihScoot│    │ ScootTyp   │
├────────────┤     ├────────────┤     ├────────────┤     ├────────────┤
│ KdID (PK)  │────<│ KdID (FK)  │     │ VScootID(PK)│───<│ ScootTypID │
│ KdName     │     │ VScootID(FK)│>───│ VScootFarbe │    │   (PK)     │
│ KdStrNr    │     │ Datum (PK) │     │ ScootTypID  │>───│ ScootTypBez│
│ KdPLZ      │     │ Tage       │     │   (FK)      │    │ ScootTyp-  │
│ KdOrt      │     │            │     │ StdID (FK)  │    │   Preis    │
└────────────┘     └────────────┘     └────────────┘     └────────────┘
                                             │
                                             │          ┌────────────┐
                                             │          │ Standort   │
                                             │          ├────────────┤
                                             └─────────>│ StdID (PK) │
                                                        │ StdName    │
                                                        │ StdStrNr   │
                                                        │ StdPLZ     │
                                                        │ StdOrt     │
                                                        └────────────┘
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`,
                    type: "info",
                    points: 0,
                },
                {
                    id: "hs5-aa",
                    title: "Aufgabe a-a) CREATE TABLE Defekt (2 Punkte)",
                    description: `Erstellen Sie die Tabelle "Defekt", welche als Attribut eine DefektID und eine Beschreibung enthält.`,
                    type: "code",
                    points: 2,
                    hint: "Welche Datentypen sind für ID und Beschreibung sinnvoll?",
                    tags: ["sql", "create-table", "ddl"],
                },
                {
                    id: "hs5-ab",
                    title: "Aufgabe a-b) CREATE TABLE DefektBuchung (3 Punkte)",
                    description: `Erstellen Sie die Tabelle "DefektBuchung", welche bis auf das Attribut "Tage" alle Attribute der Tabelle "Buchung" und eine DefektId aus der Tabelle "Defekt" enthält.`,
                    type: "code",
                    points: 3,
                    hint: "Welche Attribute übernehmen Sie aus Buchung? Wie definieren Sie den Fremdschlüssel?",
                    tags: ["sql", "create-table", "ddl", "fremdschlüssel"],
                },
                {
                    id: "hs5-b",
                    title: "Aufgabe b) Buchungen pro ScootTyp mit mindestens 10 (5 Punkte)",
                    description: `Erstellen Sie eine Liste aller Buchungen pro ScootTyp für alle Scooter-Typen, zu denen mindestens zehn Buchungen vorliegen.

ERWARTETE AUSGABE:
| ScootTypID | Anzahl |
|------------|--------|
| 1000       | 23     |
| 1001       | 12     |
| ...        |        |`,
                    type: "code",
                    points: 5,
                    hint: "Welche Tabellen müssen Sie verbinden? Wie filtern Sie nach Anzahl?",
                    tags: ["sql", "count", "group-by", "having"],
                },
                {
                    id: "hs5-c",
                    title: "Aufgabe c) Kundenumsatz absteigend sortiert (5 Punkte)",
                    description: `Erstellen Sie eine Liste, in der für jeden Kunden der Gesamtumsatz seiner Buchungen (jeweils Tage * ScootTypPreis) aufgelistet ist. Die Liste soll absteigend sortiert nach dem Umsatz sein.

ERWARTETE AUSGABE:
| KdID | Umsatz |
|------|--------|
| 2002 | 1400   |
| 2001 | 800    |
| ...  |        |`,
                    type: "code",
                    points: 5,
                    hint: "Wie berechnen Sie Tage × Preis? Welche JOINs sind nötig?",
                    tags: ["sql", "sum", "join", "order-by"],
                },
                {
                    id: "hs5-d",
                    title: "Aufgabe d) Scooter-Typen teurer als 'Cruiser' (5 Punkte)",
                    description: `Geben Sie alle ScootTyp-IDs, deren Scooter-Typ-Bezeichnung und Preis an, die einen höheren Preis als der ScootTyp 'Cruiser' haben (ScootTypID = 1001).

ERWARTETE AUSGABE:
| ScootTypID | ScootTypBez | ScootTypPreis |
|------------|-------------|---------------|
| 1002       | Premium 500 | 30            |
| ...        | ...         | ...           |`,
                    type: "code",
                    points: 5,
                    hint: "Verwenden Sie eine Unterabfrage, um den Preis des Cruisers zu ermitteln.",
                    tags: ["sql", "subquery", "where"],
                },
                {
                    id: "hs5-e",
                    title: "Aufgabe e) Prozentualer Anteil Buchungen pro Monat (5 Punkte)",
                    description: `Geben Sie für jeden Monat den prozentualen Anteil der Anzahl der Buchungen an der Gesamtanzahl der Buchungen für das Jahr 2024 an.

ERWARTETE AUSGABE:
| Monat | Anteil |
|-------|--------|
| 1     | 5      |
| 2     | 7      |
| ...   |        |`,
                    type: "code",
                    points: 5,
                    hint: "Wie extrahieren Sie den Monat? Wie berechnen Sie den prozentualen Anteil?",
                    tags: ["sql", "month", "group-by", "prozent"],
                },
            ],
        },
    ],
};