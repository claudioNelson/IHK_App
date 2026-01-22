import '../../models/ihk_exam_model.dart';

final ae2Exam = IHKExam(
  id: 'ae-2',
  title: 'AE Prüfung 2 - Sommer 2017',
  year: 2017,
  season: 'Sommer',
  duration: 90,
  totalPoints: 100,
  company: 'SecureID GmbH',
  scenario:
      '''Sie sind Mitarbeiter/-in der SecureID GmbH, Darmstadt, einem Softwaredienstleister im Bereich biometrische Sicherheitssysteme. Die SecureID GmbH erstellt Software zur Erfassung und Auswertung verschiedener biometrischer Daten.

Sie sollen vier der folgenden fünf Aufgaben erledigen:
1. Ein UML-Klassendiagramm erstellen
2. Eine Funktion zur Auswertung von Iris-Scans erstellen
3. Ein UML-Aktivitätsdiagramm erstellen
4. Ein relationales Datenmodell erstellen
5. SQL-Anweisungen für eine Datenbank erstellen''',
  sections: [
    ExamSection(
      id: 'hs1',
      title: 'Handlungsschritt 1: UML-Klassendiagramm (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs1-q1',
          title: 'UML-Klassendiagramm - Biometrische Scans',
          description:
              '''Die SecureID GmbH soll eine Software zur Erkennung und Speicherung von Iris-Scans und Netzhaut-Scans erstellen.

Für eine Person sollen vom linken und rechten Auge jeweils folgende Scans gespeichert werden:
- Iris-Scan
- Netzhaut-Scan

Zu jedem Scan sollen ein Bild und ein String gespeichert werden.

Die Zeichenkette enthält Beschreibungen derjenigen Merkmale des Scans, die beim Vergleich von Scans verwendet werden.

Die Zeichenkette wird von der Methode berechneMerkmal() anhand des Bildes berechnet.

Die Algorithmen zur Berechnung der Zeichenketten sind für Iris-Scan und Netzhaut-Scan unterschiedlich.

Es existiert bereits folgende Klasse Scan:

┌─────────────────────────────┐
│ Scan                        │
├─────────────────────────────┤
│ - bild: Bild                │
│ - merkmal: String           │
├─────────────────────────────┤
│ + berechneMerkmal()         │
└─────────────────────────────┘

AUFGABE:
Erstellen Sie ein vollständiges UML-Klassendiagramm mit:
- Klasse Person
- Klasse Scan (gegeben)
- Klassen IrisScan und NetzhautScan (erben von Scan)
- Alle notwendigen Beziehungen und Kardinalitäten''',
          type: QuestionType.diagram,
          points: 25,
          hint:
              'Nutzen Sie Vererbung für IrisScan und NetzhautScan. Eine Person hat 4 Scans (2 pro Auge).',
        ),
      ],
    ),
    ExamSection(
      id: 'hs2',
      title: 'Handlungsschritt 2: Algorithmus Iris-Scan (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs2-q1',
          title: 'Algorithmus - Iris-Scan Auswertung',
          description:
              '''Die SecureID GmbH benötigt einen Algorithmus zur Auswertung von Iris-Scans.

Ein Iris-Scan wird als Array von Grauwerten gespeichert (0-255).

AUFGABE:
Entwickeln Sie einen Algorithmus (Pseudocode oder Struktogramm), der:

1. Das Array durchläuft
2. Die Anzahl der hellen Pixel (Wert > 200) zählt
3. Die Anzahl der dunklen Pixel (Wert < 50) zählt
4. Das Verhältnis hell/dunkel berechnet
5. Wenn Verhältnis > 2.0: "Guter Scan"
6. Wenn Verhältnis < 0.5: "Schlechter Scan"
7. Sonst: "Normaler Scan"

BEISPIEL:
Array: [230, 45, 210, 30, 240, 20]
Hell (>200): 3 Pixel
Dunkel (<50): 3 Pixel
Verhältnis: 3/3 = 1.0
Ergebnis: "Normaler Scan"''',
          type: QuestionType.code,
          points: 25,
          hint: 'Nutzen Sie Zählvariablen und eine Schleife.',
        ),
      ],
    ),
    ExamSection(
      id: 'hs3',
      title: 'Handlungsschritt 3: UML-Aktivitätsdiagramm (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs3-q1',
          title: 'UML-Aktivitätsdiagramm - Authentifizierung',
          description:
              '''Modellieren Sie den Authentifizierungsprozess mit biometrischen Daten.

ABLAUF:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Benutzer startet Login
2. System fordert biometrischen Scan an
3. Benutzer wählt: Iris-Scan ODER Fingerabdruck
4. Bei Iris-Scan:
   - Kamera aktivieren
   - Scan durchführen
   - Qualität prüfen (wenn schlecht → zurück zu Schritt 2)
5. Bei Fingerabdruck:
   - Scanner aktivieren
   - Scan durchführen
6. System vergleicht mit Datenbank
7. Bei Übereinstimmung > 95%: Zugang gewähren
8. Sonst: Zugang verweigern
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUFGABE:
Erstellen Sie ein UML-Aktivitätsdiagramm mit:
- Start/Endknoten
- Entscheidungen
- Aktivitäten
- Schleifen (für Qualitätsprüfung)''',
          type: QuestionType.diagram,
          points: 25,
          hint:
              'Nutzen Sie eine Raute für die Scan-Auswahl und eine weitere für die Qualitätsprüfung.',
        ),
      ],
    ),
    ExamSection(
      id: 'hs4',
      title: 'Handlungsschritt 4: Datenmodell (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs4-q1',
          title: 'ER-Diagramm - Zutrittskontrolle',
          description:
              '''Die SecureID GmbH möchte ein System zur Zutrittskontrolle entwickeln.

ANFORDERUNGEN:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ENTITÄTEN:
- Mitarbeiter (MA_ID, Name, Abteilung)
- Raum (Raum_ID, Bezeichnung, Gebäude, Sicherheitsstufe)
- Zutritt (Zutritt_ID, Zeitpunkt, Erfolg)
- Zutrittsberechtigung (von_Datum, bis_Datum)

BEZIEHUNGEN:
- Ein Mitarbeiter kann viele Zutrittsversuche machen
- Ein Raum hat viele Zutrittsversuche
- Ein Mitarbeiter hat Berechtigungen für mehrere Räume
- Ein Raum kann von mehreren Mitarbeitern betreten werden
- Eine Berechtigung ist zeitlich befristet (von-bis)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUFGABE:
Erstellen Sie ein ER-Diagramm mit allen Entitäten, Beziehungen und Kardinalitäten.''',
          type: QuestionType.diagram,
          points: 25,
          hint:
              'Die Berechtigung ist eine Beziehungsentität zwischen Mitarbeiter und Raum.',
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
          title: 'Datenbankschema - SecureID System',
          description: '''TABELLE: Mitarbeiter
| MA_ID | Name      | Abteilung |
|-------|-----------|-----------|
| 1     | Müller    | IT        |
| 2     | Schmidt   | HR        |
| 3     | Weber     | IT        |

TABELLE: Raum
| Raum_ID | Bezeichnung | Sicherheitsstufe |
|---------|-------------|------------------|
| 101     | Server      | 3                |
| 102     | Büro        | 1                |
| 103     | Labor       | 2                |

TABELLE: Zutritt
| Zutritt_ID | MA_ID | Raum_ID | Zeitpunkt           | Erfolg |
|------------|-------|---------|---------------------|--------|
| 1          | 1     | 101     | 2024-01-20 08:00:00 | true   |
| 2          | 2     | 102     | 2024-01-20 09:00:00 | true   |
| 3          | 1     | 103     | 2024-01-20 10:00:00 | false  |''',
          type: QuestionType.info,
          points: 0,
        ),
        ExamQuestion(
          id: 'hs5-a',
          title: 'Aufgabe a) Erfolgreiche Zutritte pro Mitarbeiter (8 Punkte)',
          description:
              '''Erstellen Sie eine SQL-Abfrage, die für jeden Mitarbeiter die Anzahl der erfolgreichen Zutritte ausgibt.

ERWARTETE AUSGABE:
| Name    | AnzahlZutritte |
|---------|----------------|
| Müller  | 1              |
| Schmidt | 1              |
| Weber   | 0              |''',
          type: QuestionType.code,
          points: 8,
          hint: 'Nutzen Sie COUNT() und GROUP BY. Denken Sie an LEFT JOIN.',
        ),
        ExamQuestion(
          id: 'hs5-b',
          title: 'Aufgabe b) Räume mit höchster Sicherheitsstufe (5 Punkte)',
          description:
              '''Geben Sie alle Räume aus, die die höchste Sicherheitsstufe haben.''',
          type: QuestionType.code,
          points: 5,
          hint: 'Nutzen Sie eine Unterabfrage mit MAX().',
        ),
        ExamQuestion(
          id: 'hs5-c',
          title:
              'Aufgabe c) Fehlgeschlagene Zutritte der IT-Abteilung (7 Punkte)',
          description:
              '''Listen Sie alle fehlgeschlagenen Zutrittsversuche von Mitarbeitern der IT-Abteilung auf.

Sortiert nach Zeitpunkt (neueste zuerst).''',
          type: QuestionType.code,
          points: 7,
          hint:
              'JOIN Mitarbeiter und Zutritt, filtern nach Abteilung und Erfolg.',
        ),
        ExamQuestion(
          id: 'hs5-d',
          title:
              'Aufgabe d) Durchschnittliche Sicherheitsstufe pro Abteilung (5 Punkte)',
          description:
              '''Berechnen Sie die durchschnittliche Sicherheitsstufe der Räume, die von jeder Abteilung betreten wurden (nur erfolgreiche Zutritte).''',
          type: QuestionType.code,
          points: 5,
          hint: 'Nutzen Sie AVG() mit mehreren JOINs.',
        ),
      ],
    ),
  ],
);
