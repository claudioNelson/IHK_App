import '../../models/ihk_exam_model.dart';

final si1Exam = IHKExam(
  id: 'ae-3',
  title: 'AE Prüfung 3 - Winter 2019/20',
  year: 2019,
  season: 'Winter',
  duration: 90,
  totalPoints: 100,
  company: 'RadMobil GmbH',
  scenario:
      '''Sie arbeiten in der CodeWorks GmbH, die Softwarelösungen für Handel und Dienstleistungen zur Verfügung stellt und verwaltet.

Die Firma RadMobil GmbH betreibt einen E-Scooter-Verleih mit Werkstatt.

Sie sollen vier der folgenden fünf Aufgaben in diesem Projekt erledigen:
1. Beim Management für das Projekt Abrechnungssoftware mitwirken
2. Programm zur Auswertung der Arbeitszeiterfassung anfertigen
3. Objektorientierte Software für Ladegerät entwickeln
4. Tabelle Wartung normalisieren
5. SQL-Abfragen zur Verleihdatenbank formulieren''',
  sections: [
    ExamSection(
      id: 'hs1',
      title: 'Handlungsschritt 1: Projektmanagement (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs1-a',
          title: 'Aufgabe a) Methoden der Anforderungsanalyse (6 Punkte)',
          description:
              '''Für die Abrechnung der Servicemitarbeiter der RadMobil GmbH soll eine Abrechnungssoftware eingeführt werden.

Sie erhalten den Auftrag, eine Anforderungsanalyse für diese Software durchzuführen.

a) Nennen Sie zwei Methoden, die Sie für eine Anforderungsanalyse anwenden können.

b) Beschreiben Sie zwei Anforderungen an die neu einzuführende Software.''',
          type: QuestionType.freeText,
          points: 6,
          hint:
              'Methoden: z.B. Interview, Fragebogen, Workshop. Anforderungen: funktional und nicht-funktional.',
        ),
        ExamQuestion(
          id: 'hs1-b',
          title: 'Aufgabe b) Kick-off-Sitzung (8 Punkte)',
          description:
              '''Der Projektleiter Ihres Teams hat Ihnen mitgeteilt, dass das Projekt "Abrechnungssoftware" mit einer Kick-off-Sitzung begonnen wird.

Nennen Sie jeweils vier auf der Sachebene und der Beziehungsebene liegende Aufgabenstellungen dieser Kick-off-Sitzung.

SACHEBENE:
1.
2.
3.
4.

BEZIEHUNGSEBENE:
1.
2.
3.
4.''',
          type: QuestionType.freeText,
          points: 8,
          hint:
              'Sachebene: Was wird gemacht? Beziehungsebene: Wie arbeiten wir zusammen?',
        ),
        ExamQuestion(
          id: 'hs1-c',
          title: 'Aufgabe c) Nutzwertanalyse (11 Punkte)',
          description:
              '''Es stehen drei Softwarelösungen zur Auswahl. Führen Sie eine Nutzwertanalyse durch.

KRITERIEN UND GEWICHTUNG:
- Benutzerfreundlichkeit: 40%
- Kosten: 30%
- Schnittstellen: 30%

BEWERTUNG (1-10 Punkte):
| Kriterium           | Lösung A | Lösung B | Lösung C |
|---------------------|----------|----------|----------|
| Benutzerfreundlichk.| 8        | 6        | 9        |
| Kosten              | 5        | 9        | 6        |
| Schnittstellen      | 7        | 7        | 8        |

a) Berechnen Sie den Nutzwert für jede Lösung
b) Welche Lösung empfehlen Sie?
c) Nennen Sie einen Kritikpunkt an der Nutzwertanalyse''',
          type: QuestionType.code,
          points: 11,
          hint: 'Nutzwert = Summe (Bewertung × Gewichtung)',
        ),
      ],
    ),
    ExamSection(
      id: 'hs2',
      title: 'Handlungsschritt 2: Zeiterfassung (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs2-q1',
          title: 'Algorithmus - Zeiterfassungsliste erstellen',
          description:
              '''Die RadMobil GmbH möchte eine Auswertung der erfassten Arbeitszeiten eines Monats.

REGELN:
- Kommen- und Gehen-Buchungen vorhanden → Anwesenheit berechnen
- Nur Kommen-Zeit vorhanden → Anwesenheit 00:00, "Buchung fehlt"
- Keine Zeitbuchung → Anwesenheit 00:00, "nicht anwesend"
- Am Ende: Summe der Anwesenheitszeiten

ZEITERFASSUNGSTABELLE (Beispiel):
| Tag | Stunde | Minute |
|-----|--------|--------|
| 2   | 8      | 10     |
| 2   | 17     | 20     |
| 3   | 7      | 50     |
| 6   | 8      | 00     |
| 6   | 16     | 00     |

AUFGABE:
Entwickeln Sie einen Algorithmus (Pseudocode oder Struktogramm), der diese Zeiterfassungsliste erstellt.''',
          type: QuestionType.code,
          points: 25,
          hint:
              'Schleife über alle Tage, prüfe ob 0, 1 oder 2 Buchungen vorhanden sind.',
        ),
      ],
    ),
    ExamSection(
      id: 'hs3',
      title: 'Handlungsschritt 3: OOP Ladegerät (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs3-q1',
          title: 'UML-Klassendiagramm - Ladegerät',
          description:
              '''Die RadMobil GmbH benötigt Software für intelligente E-Scooter-Ladegeräte.

ANFORDERUNGEN:
- Klasse Ladegerät mit Attributen: ID, Standort, Leistung (Watt)
- Klasse Ladevorgang mit: Ladevorgang_ID, Startzeit, Endzeit, Energie (kWh)
- Ein Ladegerät hat viele Ladevorgänge
- Methode berechneLadekosten() berechnet Kosten = Energie × 0.30€

AUFGABE:
Erstellen Sie ein UML-Klassendiagramm mit:
- Beiden Klassen
- Allen Attributen und Datentypen
- Der Methode berechneLadekosten()
- Der Beziehung mit Kardinalität''',
          type: QuestionType.diagram,
          points: 25,
          hint: '1 Ladegerät : n Ladevorgänge',
        ),
      ],
    ),
    ExamSection(
      id: 'hs4',
      title: 'Handlungsschritt 4: Normalisierung (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs4-intro',
          title: 'Ausgangstabelle Wartung',
          description: '''TABELLE: Wartung (nicht normalisiert)
| Wartung_ID | Scooter_ID | Scooter_Typ | Werkstatt_Name | Werkstatt_PLZ | Datum      | Kosten |
|------------|------------|-------------|----------------|---------------|------------|--------|
| 1          | 100        | Cruiser     | Fix-Werk       | 10115         | 2024-01-10 | 50     |
| 2          | 101        | Sport       | Fix-Werk       | 10115         | 2024-01-15 | 80     |
| 3          | 100        | Cruiser     | Mobil-Service  | 20095         | 2024-02-01 | 40     |

Hinweis: Ein Scooter hat immer denselben Typ. Eine Werkstatt hat immer dieselbe PLZ.''',
          type: QuestionType.info,
          points: 0,
        ),
        ExamQuestion(
          id: 'hs4-a',
          title: 'Aufgabe a) Erste Normalform (5 Punkte)',
          description:
              '''Prüfen Sie, ob die Tabelle in der ersten Normalform ist. Wenn nein, überführen Sie sie.''',
          type: QuestionType.freeText,
          points: 5,
          hint: 'Sind alle Attribute atomar?',
        ),
        ExamQuestion(
          id: 'hs4-b',
          title: 'Aufgabe b) Zweite Normalform (10 Punkte)',
          description: '''Überführen Sie die Tabelle in die zweite Normalform.

Geben Sie die entstehenden Tabellen mit ihren Primärschlüsseln an.''',
          type: QuestionType.diagram,
          points: 10,
          hint: 'Entfernen Sie partielle Abhängigkeiten vom Primärschlüssel.',
        ),
        ExamQuestion(
          id: 'hs4-c',
          title: 'Aufgabe c) Dritte Normalform (10 Punkte)',
          description:
              '''Überführen Sie den Datenbestand abschließend in die dritte Normalform.

Geben Sie alle Tabellen mit Primärschlüsseln und Fremdschlüsseln an.''',
          type: QuestionType.diagram,
          points: 10,
          hint: 'Entfernen Sie transitive Abhängigkeiten.',
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
          title: 'Datenbankschema - Verleihdatenbank',
          description: '''TABELLEN:
- Kunde (KdID, KdName, KdOrt)
- VerleihScoot (VScootID, VScootFarbe, ScootTypID, StdID)
- ScootTyp (ScootTypID, ScootTypBez, ScootTypPreis)
- Standort (StdID, StdName, StdOrt)
- Buchung (KdID, VScootID, Datum, Tage)''',
          type: QuestionType.info,
          points: 0,
        ),
        ExamQuestion(
          id: 'hs5-a',
          title: 'Aufgabe a) CREATE TABLE DefektBuchung (3 Punkte)',
          description:
              '''Erstellen Sie die Tabelle "DefektBuchung", welche alle Attribute der Tabelle "Buchung" außer "Tage" enthält, plus eine DefektId.''',
          type: QuestionType.code,
          points: 3,
          hint: 'Nutzen Sie CREATE TABLE mit entsprechenden Attributen.',
        ),
        ExamQuestion(
          id: 'hs5-b',
          title: 'Aufgabe b) Buchungen pro ScootTyp ≥ 10 (5 Punkte)',
          description:
              '''Listen Sie alle Scooter-Typen auf, zu denen mindestens 10 Buchungen vorliegen.

AUSGABE: ScootTypID, Anzahl''',
          type: QuestionType.code,
          points: 5,
          hint: 'GROUP BY mit HAVING COUNT(*) >= 10',
        ),
        ExamQuestion(
          id: 'hs5-c',
          title: 'Aufgabe c) Kundenumsatz absteigend (5 Punkte)',
          description:
              '''Erstellen Sie eine Liste mit dem Gesamtumsatz pro Kunde (Tage × Preis).

Sortiert absteigend nach Umsatz.''',
          type: QuestionType.code,
          points: 5,
          hint: 'JOIN, SUM(Tage * Preis), ORDER BY DESC',
        ),
        ExamQuestion(
          id: 'hs5-d',
          title: 'Aufgabe d) Scooter teurer als Cruiser (5 Punkte)',
          description:
              '''Geben Sie alle Scooter-Typen aus, die teurer als der Typ "Cruiser" (ScootTypID = 1001) sind.''',
          type: QuestionType.code,
          points: 5,
          hint: 'Unterabfrage für Preis von Cruiser',
        ),
        ExamQuestion(
          id: 'hs5-e',
          title:
              'Aufgabe e) Prozentualer Anteil Buchungen pro Monat (7 Punkte)',
          description:
              '''Geben Sie für jeden Monat den prozentualen Anteil der Buchungen an der Gesamtanzahl für 2024 an.

Hinweis: Datumsfeld ist String im Format "YYYY-MM-DD"''',
          type: QuestionType.code,
          points: 7,
          hint: 'Nutzen Sie SUBSTRING() und Unterabfrage für Gesamtanzahl',
        ),
      ],
    ),
  ],
);
