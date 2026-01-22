import '../../models/ihk_exam_model.dart';

final ae1Exam = IHKExam(
  id: 'ae-1',
  title: 'AE Prüfung 1 - Winter 2016/17',
  year: 2016,
  season: 'Winter',
  duration: 90,
  totalPoints: 100,
  company: 'TransLogic GmbH',
  scenario:
      '''Sie sind Mitarbeiter/-in der DevSoft AG und werden beauftragt, für die TransLogic GmbH verschiedene Softwarelösungen zu entwickeln.

Die TransLogic GmbH ist ein Logistikunternehmen, das Frachttransporte zwischen verschiedenen Standorten durchführt.

Sie sollen vier der folgenden fünf Aufgaben erledigen:
1. Ein UML-Aktivitätsdiagramm erstellen
2. Einen Algorithmus zur Routenoptimierung entwickeln
3. Einen Algorithmus zur Transportauswahl entwickeln
4. Ein ER-Diagramm erstellen
5. SQL-Anweisungen erstellen''',
  sections: [
    ExamSection(
      id: 'hs1',
      title: 'Handlungsschritt 1: UML-Aktivitätsdiagramm (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs1-q1',
          title: 'UML-Aktivitätsdiagramm - Fahrzeugwartung',
          description:
              '''Die Wartung der LKW-Flotte der TransLogic GmbH soll in einem UML-Aktivitätsdiagramm modelliert werden.

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
- Aktivitäten, Entscheidungen, Parallelisierung (Fork/Join)''',
          type: QuestionType.diagram,
          points: 25,
          hint:
              'Welche Aktivitäten können parallel ablaufen? Wo gibt es eine Verzweigung zwischen Inspektion-A und B?',
        ),
      ],
    ),
    ExamSection(
      id: 'hs2',
      title: 'Handlungsschritt 2: Algorithmus Routenoptimierung (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs2-q1',
          title: 'Algorithmus - Günstigste Route finden',
          description:
              '''Die TransLogic GmbH möchte für Frachttransporte die günstigste Route ermitteln.

Ein Netzwerk von Strecken verbindet verschiedene Standorte. Jede Strecke hat unterschiedliche Kosten.

GEGEBEN:
- Standorte: A, B, C, D, E
- Strecken mit Kosten:
  A → B: 10 €
  A → C: 15 €
  B → C: 5 €
  B → D: 20 €
  C → D: 8 €
  C → E: 12 €
  D → E: 7 €

AUFGABE:
Entwickeln Sie einen Algorithmus (Pseudocode oder Struktogramm), der:
1. Alle möglichen Routen von einem Startort zum Zielort ermittelt
2. Die Gesamtkosten jeder Route berechnet
3. Die günstigste Route ausgibt

BEISPIEL:
Start: A, Ziel: E
Mögliche Routen:
- A → C → E (15 + 12 = 27 €)
- A → C → D → E (15 + 8 + 7 = 30 €)
- A → B → C → E (10 + 5 + 12 = 27 €)
usw.''',
          type: QuestionType.code,
          points: 25,
          hint:
              'Denken Sie an einen rekursiven Ansatz oder Dijkstra-Algorithmus.',
        ),
      ],
    ),
    ExamSection(
      id: 'hs3',
      title: 'Handlungsschritt 3: Algorithmus Transportauswahl (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs3-q1',
          title: 'Algorithmus - Optimale Transportverbindung',
          description:
              '''Ein Kunde möchte von Hamburg nach München reisen und sucht die beste Verbindung.

KRITERIEN:
- Abfahrtszeit möglichst früh am Tag
- Ankunftszeit möglichst vor 18:00 Uhr
- Preis möglichst günstig

VERFÜGBARE TRANSPORTE (aus Datenbank):
| Transport_ID | von     | nach    | Abfahrt | Ankunft | Preis |
|--------------|---------|---------|---------|---------|-------|
| 1            | Hamburg | München | 09:00   | 17:00   | 60.00 |
| 2            | Hamburg | München | 11:00   | 19:00   | 50.00 |
| 3            | Hamburg | München | 07:00   | 15:00   | 70.00 |
| 4            | Hamburg | München | 13:00   | 21:00   | 40.00 |

AUFGABE:
Entwickeln Sie einen Algorithmus, der:
1. Alle Transporte nach den Kriterien bewertet
2. Eine Rangliste erstellt
3. Die beste Verbindung vorschlägt

Gewichtung:
- Abfahrtszeit: 30%
- Ankunftszeit: 40%
- Preis: 30%''',
          type: QuestionType.code,
          points: 25,
          hint: 'Nutzen Sie eine Punktevergabe für jedes Kriterium.',
        ),
      ],
    ),
    ExamSection(
      id: 'hs4',
      title: 'Handlungsschritt 4: ER-Diagramm (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs4-q1',
          title: 'ER-Diagramm - Transportdatenbank',
          description: '''Die TransLogic GmbH möchte ihre Datenbank erweitern.

ANFORDERUNGEN:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ENTITÄTEN:
- Kunde (Kunde_ID, Name, Adresse)
- Transport (Transport_ID, von, nach, Datum)
- Fahrzeug (Fahrzeug_ID, Kennzeichen, Typ)
- Fahrer (Fahrer_ID, Name, Führerscheinklasse)

BEZIEHUNGEN:
- Ein Kunde kann viele Transporte buchen.
- Ein Transport wird mit einem Fahrzeug durchgeführt.
- Ein Transport wird von verschiedenen Fahrern gefahren.
- Fahrer können auf verschiedenen Fahrzeugen eingesetzt werden.
- Ein Fahrer führt viele Transporte durch.
- Ein Transport wird von zwei Fahrern ausgeführt.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUFGABE:
Erstellen Sie ein entsprechendes ER-Diagramm OHNE Attribute.

Hinweis: Verwenden Sie die Chen-Notation oder die Krähenfuß-Notation.''',
          type: QuestionType.diagram,
          points: 25,
          hint:
              'Achten Sie auf die n:m Beziehungen, die Zwischentabellen benötigen.',
        ),
      ],
    ),
    ExamSection(
      id: 'hs5',
      title: 'Handlungsschritt 5: SQL-Abfragen (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs5-intro',
          title: 'Datenbankschema - TransLogic Transportdatenbank',
          description:
              '''Die DevSoft AG wurde von der TransLogic GmbH beauftragt, verschiedene SQL-Anweisungen zur Auswertung folgender Datenbank zu erstellen.

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

Hinweis: Das Feld Datum ist vom Typ String.''',
          type: QuestionType.info,
          points: 0,
        ),
        ExamQuestion(
          id: 'hs5-a',
          title: 'Aufgabe a) Kundenliste für Transport (8 Punkte)',
          description: '''Für den Transport mit der ID 1 am 02.12.2024:

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
- Auswahlkriterien: Transport_ID = 1 UND Datum = '02.12.2024\'''',
          type: QuestionType.code,
          points: 8,
          hint:
              'Welche Tabellen müssen Sie verbinden, um von Kunde zu Transport_ID zu gelangen?',
        ),
        ExamQuestion(
          id: 'hs5-b',
          title: 'Aufgabe b) Prozentualer Anteil GmbH-Kunden (5 Punkte)',
          description:
              '''Ermitteln Sie den prozentualen Anteil der GmbH-Kunden an der Gesamtheit aller Kunden, die bisher mit der Spedition transportiert haben.

ERWARTETE AUSGABE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| AnteilGmbH |
|------------|
| 50         |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Hinweis: Es wird davon ausgegangen, dass der Divisor immer > 0 ist.''',
          type: QuestionType.code,
          points: 5,
          hint:
              'Wie können Sie die Anzahl der GmbH-Kunden durch die Gesamtanzahl teilen?',
        ),
        ExamQuestion(
          id: 'hs5-c',
          title: 'Aufgabe c) Tagesumsatz Hamburg-München (5 Punkte)',
          description:
              '''Ermitteln Sie den Umsatz eines Tages für Transporte von Hamburg nach München.

Hinweis: Der Umsatz ergibt sich aus Anzahl der Buchungen × Preis des Transports.''',
          type: QuestionType.code,
          points: 5,
          hint:
              'Zählen Sie die Buchungen und multiplizieren Sie mit dem Transport-Preis.',
        ),
        ExamQuestion(
          id: 'hs5-d',
          title: 'Aufgabe d) Durchschnittspreis pro Kunde (7 Punkte)',
          description:
              '''Erstellen Sie eine Liste mit dem durchschnittlichen Buchungspreis pro Kunde.

Sortieren Sie die Liste absteigend nach dem Durchschnittspreis.''',
          type: QuestionType.code,
          points: 7,
          hint: 'Nutzen Sie AVG() und GROUP BY.',
        ),
      ],
    ),
  ],
);
