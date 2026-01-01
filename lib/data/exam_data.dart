// data/exam_data.dart - KOMPLETTE VERSION

import '../models/question_model.dart';

class ExamData {
  // Haupt-Methode: Lade Prüfung nach ID
  static List<ExamSection> getExamById(String examId) {
    switch (examId) {
      // ANWENDUNGSENTWICKLUNG (AE)
      case 'ae_exam_1':
        return getAE_Exam1();
      case 'ae_exam_2':
        return getAE_Exam2();
      case 'ae_exam_3':
        return getAE_Exam3();
      case 'ae_exam_4':
        return getAE_Exam4();
      case 'ae_exam_5':
        return getAE_Exam5();
      case 'ae_exam_6':
        return getAE_Exam6();

      // SYSTEMINTEGRATION (SI)
      case 'si_exam_1':
        return getSI_Exam1();
      case 'si_exam_2':
        return getSI_Exam2();
      case 'si_exam_3':
        return getSI_Exam3();
      case 'si_exam_4':
        return getSI_Exam4();
      case 'si_exam_5':
        return getSI_Exam5();
      case 'si_exam_6':
        return getSI_Exam6();

      default:
        return getAE_Exam1();
    }
  }

  static List<ExamSection> getAllSections() {
    return getAE_Exam1();
  }

  // ========== AE PRÜFUNG 1: Winter 2016/17 - CargoTech GmbH ==========
  // KOMPLETT mit allen Unteraufgaben!

  static List<ExamSection> getAE_Exam1() {
    return [
      // ==========================================
      // HANDLUNGSSCHRITT 1: UML-Aktivitätsdiagramm (25 Punkte)
      // ==========================================
      ExamSection(
        id: 'ae_exam_1_s1',
        title: 'Handlungsschritt 1: UML-Aktivitätsdiagramm (25 Punkte)',
        totalPoints: 25,
        questions: [
          // ========== AUFGABE 1: CargoTech - Handlungsschritt 1 ==========
          // UML-Aktivitätsdiagramm - LKW-Wartung
          // 25 Punkte
          Question(
            id: 'ae_exam_1_q1',
            title:
                'Aufgabe 1: UML-Aktivitätsdiagramm - LKW-Wartung (25 Punkte)',
            description:
                '''Die Wartung der LKWs der CargoTech GmbH erfolgt in vorgeschriebenen Wartungsintervallen.

**Wartungsablauf:**
- Nach 50.000 km: Basis-Inspektion (Service A) in der eigenen Werkstatt
- Nach 150.000 km: Haupt-Inspektion (Service B) beim Vertragspartner

**Ablauf einer Wartung:**
- Die Werkstatt prüft anhand des Kilometerstands, welcher LKW zur Wartung ansteht
- Die Werkstatt plant einen Termin ein, an dem der LKW nicht für Lieferungen benötigt wird
- Der Disponent der CargoTech GmbH genehmigt oder lehnt den Termin ab
- Bei Ablehnung schlägt die Werkstatt einen alternativen Termin vor
- Nach Genehmigung führt die Werkstatt die Wartung durch
- Bei Service B wird der LKW zusätzlich zum Vertragspartner überführt
- Werden bei der Inspektion Mängel festgestellt, erstellt die Werkstatt ein Reparatur-Angebot und unterbricht die Wartung
- Nach Abschluss der Wartung erstellt die Werkstatt eine Rechnung
- Bei Service B erfolgt die Rückführung des LKWs parallel zur Rechnungsstellung

**Erstellen Sie ein UML-Aktivitätsdiagramm für diesen Wartungsprozess.**

Verwenden Sie:
- Schwimmbahnen für Werkstatt und Disponent
- Entscheidungsknoten für Terminprüfung
- Zusammenführung für genehmigte Termine
- Parallele Aktivitäten für Service B (Fork/Join)''',
            type: QuestionType.diagram,
            points: 25,
            hint:
                'Nutzen Sie zwei Schwimmbahnen. Zeigen Sie Entscheidungen, Schleifen für Terminvorschläge und parallele Abläufe bei Service B.',
          ),
        ],
      ),

      // ==================== HANDLUNGSSCHRITT 2 (25 Punkte) ====================
      // Original: Wings GmbH Frachtflüge → Neu: TransLogic GmbH Spedition
      ExamSection(
        id: 'ae_exam_3_hs2',
        title: 'Handlungsschritt 2: Algorithmus Routenoptimierung (25 Punkte)',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_3_hs2_q1',
            title: 'Aufgabe: Algorithmus - Kostengünstigste Route ermitteln',
            description: '''**2. Handlungsschritt (25 Punkte)**

Die TransLogic GmbH führt Frachttransporte zwischen mehreren Standorten durch.

So können beispielsweise Routen von A nach B (ggf. unter Einbeziehung von Zwischenstopps) auf unterschiedliche Weise durchgeführt werden:

```
        ┌───┐
        │ A │
        └─┬─┘
       ╱  │  ╲
      ╱   │   ╲
   ┌───┐ ┌───┐
   │ C │ │ D │
   └─┬─┘ └─┬─┘
     │     │
     │   ┌───┐
     │   │ E │
     │   └─┬─┘
      ╲   │  ╱
       ╲  │ ╱
        ┌───┐
        │ B │
        └───┘
```

Die TransLogic GmbH benötigt nun eine Funktion, mit der die kostengünstigste Route zu vorgegebenen Start- und Zielorten unter Berücksichtigung von freien Ladekapazitäten ermittelt werden kann.

Die möglichen Routen zwischen Ausgangsort (A) und Zielort (B) liegen stets in einer zweidimensionalen Tabelle *Routen* vor (Inhalt beispielhaft für die obige Grafik).

**Routen für einen Transport von A nach B:**

| A | B |   | direkt über die Strecke A-B |
| A | C | B | über die Strecken A-C und C-B |
| A | D | E | B | über die Strecken A-D, D-E und E-B |

Der Ausgangsort steht immer in Spalte 0, der Zielort ist immer der letzte nicht leere Eintrag einer Zeile.

**Folgende Funktionen stehen zur Verfügung:**

| Funktion | Beschreibung |
|----------|--------------|
| holeStreckeKapazitaet(SB:String, SE:String) : Integer | Holt für eine Strecke die freie Ladekapazität in kg |
| holeStreckePreis(SB:String, SE:String) : Double | Holt für eine Strecke die Transportkosten EUR/kg |

SB = Strecken-Beginn
SE = Strecken-Ende

**Erstellen Sie einen Algorithmus für eine Funktion *findeRoute(ladung: Integer) : Integer*, die für eine Fracht mit dem Gewicht *ladung* die kostengünstigste Route unter Berücksichtigung von freien Ladekapazitäten ermittelt.**

Die Funktion soll den Index der Tabellenzeile zurückgeben, in der die günstigste Route gefunden wurde.

**Stellen Sie auf der Folgeseite den Algorithmus in Pseudocode oder einem Struktogramm oder einem PAP dar.**''',
            type: QuestionType.code,
            points: 25,
            hint: '''Algorithmus-Struktur:
1. Initialisierung: guenstigsteRoute = -1, guenstigsterPreis = MAX_VALUE
2. Äußere Schleife: Für jede Zeile (Route) in der Tabelle
3. Innere Schleife: Für jede Strecke in der Route
   - Prüfe Kapazität >= ladung
   - Summiere Preise auf
4. Wenn Route gültig UND Preis < guenstigsterPreis:
   - guenstigsteRoute = aktuelle Zeile
   - guenstigsterPreis = aktueller Preis
5. Rückgabe: guenstigsteRoute''',
          ),
        ],
      ),

      // ==========================================
      // HANDLUNGSSCHRITT 3: Prozedurale Programmierung (25 Punkte)
      // ==========================================
      ExamSection(
        id: 'ae_exam_1_s3',
        title: 'Handlungsschritt 3: Prozedurale Programmierung (25 Punkte)',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_1_q3',
            title: 'Aufgabe 3: Funktion filtereLieferungen() (25 Punkte)',
            description:
                '''Ein Softwarehaus soll für CargoTech eine Funktion entwickeln, die Lieferungen nach Kriterien filtert:
- Lieferungen an einem bestimmten Tag
- Mit mindestens einer gewünschten Anzahl freier Palettenplätze

**Klasse Lieferung:**
```
Lieferung
- id : String
- lieferDatum : Date
- abfahrtZeit : Date
- ankunftZeit : Date
- kosten : Double
- freiePlaetze : Integer
- zielOrt : String
```

Für alle Attribute existieren public getter-Methoden wie `getLieferDatum()`, `getKosten()`, `getFreiePlaetze()` usw.

**Das Array `StandardLieferungen` enthält alle regelmäßigen Lieferungen** auf einer bestimmten Route.

Datum und benötigte Palettenplätze werden als Parameter übergeben.

**Die Funktion soll:**
1. Aus `StandardLieferungen` alle Lieferungen am gewünschten Datum mit genügend freien Plätzen auswählen
2. Die gefilterten Lieferungen in einem neuen Array `GefiltarteLieferungen` speichern
3. Die Lieferungen nach Kosten aufsteigend sortieren
4. Eine Referenz auf das Array `GefiltarteLieferungen` zurückgeben

**Funktionssignatur:**

`filtereLieferungen(Datum : Date, Plaetze : Integer) : Lieferung[ ]`

**Stellen Sie den Algorithmus in Pseudocode, Struktogramm oder PAP dar.**''',
            type: QuestionType.code,
            points: 25,
            hint:
                'Filtern → Sortieren → Rückgabe. (1) Schleife durch StandardLieferungen, (2) Bedingung: Datum gleich UND freiePlaetze >= Plaetze, (3) Sortieralgorithmus nach Kosten aufsteigend.',
          ),
        ],
      ),

      // ==========================================
      // HANDLUNGSSCHRITT 4: ER-Diagramm (25 Punkte)
      // ==========================================
      ExamSection(
        id: 'ae_exam_1_s4',
        title: 'Handlungsschritt 4: ER-Diagramm (25 Punkte)',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_1_q4',
            title: 'Aufgabe 4: ER-Diagramm - Lieferdatenbank (25 Punkte)',
            description:
                '''Die durchgeführten Lieferungen sollen in einer relationalen Datenbank erfasst werden.

**Anforderungen:**

- Eine Lieferfahrt transportiert mehrere Sendungen von einem oder mehreren Kunden
- Die Sendungen eines Kunden können auf mehrere Lieferfahrten verteilt werden
- Eine Lieferfahrt wird mit einem LKW durchgeführt
- Ein LKW wird für viele Lieferfahrten eingesetzt
- Ein LKW wird von verschiedenen Fahrern gefahren
- Fahrer können verschiedene LKWs fahren
- Ein Fahrer führt viele Lieferfahrten durch
- Eine Lieferfahrt wird von einem Hauptfahrer und einem Beifahrer durchgeführt

**Erstellen Sie ein ER-Diagramm ohne Attribute.**

Zeigen Sie die Entitäten und ihre Beziehungen mit den Kardinalitäten.

**Hinweis:** Beachten Sie m:n-Beziehungen!''',
            type: QuestionType.diagram,
            points: 25,
            hint:
                'Entitäten: Sendung, Kunde, Lieferfahrt, LKW, Fahrer. m:n-Beziehungen: Sendung↔Lieferfahrt, LKW↔Fahrer. Für Hauptfahrer/Beifahrer: Zwei separate 1:n-Beziehungen von Fahrer zu Lieferfahrt.',
          ),
        ],
      ),

      // ==========================================
      // HANDLUNGSSCHRITT 5: SQL-Abfragen (25 Punkte)
      // ==========================================
      ExamSection(
        id: 'ae_exam_1_s5',
        title: 'Handlungsschritt 5: SQL-Abfragen (25 Punkte)',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_1_q5a',
            title:
                'Aufgabe 5a) Sendungsliste nach Lagerplatz sortiert (8 Punkte)',
            description:
                '''Die CargoTech GmbH wurde beauftragt, verschiedene SQL-Abfragen zu erstellen.

**Beispiel zur Datenbankstruktur:**

Die Lieferfahrt mit ID 42 am 15.11.2024 hat folgende Sendungen geladen:

**Tabelle LKW_Ladeplan:**
| Lager_ID | LKW_ID | Platz |
|----------|--------|-------|
| 1        | 7      | A1    |
| 2        | 7      | A2    |
| 3        | 7      | B1    |

**Tabelle Sendung:**
| Sendung_ID | Kunde_ID | Gewicht | Ziel     |
|------------|----------|---------|----------|
| 501        | 123      | 25.5    | Berlin   |
| 502        | 124      | 18.0    | Hamburg  |
| 503        | 123      | 42.3    | München  |

**Tabelle Kunde:**
| Kunde_ID | Firma          | Anrede | Name   |
|----------|----------------|--------|--------|
| 123      | Möbel Schmidt  | Herr   | Schmidt|
| 124      | TechShop GmbH  | Frau   | Wagner |

**Aufgabe a) Sendungsliste nach Lagerplatz sortiert**

Für die Lieferfahrt mit ID 42 am 15.11.2024:

Erstellen Sie eine SQL-Abfrage, die alle Sendungen nach Lagerplatz aufsteigend sortiert anzeigt.

**Erwartetes Ergebnis:**
| Platz | Firma         | Ziel    |
|-------|---------------|---------|
| A1    | Möbel Schmidt | Berlin  |
| A2    | TechShop GmbH | Hamburg |
| B1    | Möbel Schmidt | München |

**Hinweise:**
- Feld Datum ist vom Typ String
- Verwenden Sie JOINs zwischen den Tabellen
- Sortieren Sie nach Platz aufsteigend''',
            type: QuestionType.code,
            points: 8,
            hint:
                'JOIN zwischen Lieferfahrt_Datum, LKW_Ladeplan, Sendung und Kunde. WHERE Lieferfahrt_ID = 42 AND Datum = "15.11.2024". ORDER BY Platz.',
          ),

          Question(
            id: 'ae_exam_1_q5b',
            title: 'Aufgabe 5b) Anteil Firmenkunden (5 Punkte)',
            description: '''**Aufgabe b) Prozentualer Anteil der Firmenkunden**

Berechnen Sie den prozentualen Anteil der Firmenkunden (Anrede = "Firma") an allen Kunden.

**Hinweis:** Der Divisor ist immer > 0.

**Beispiel-Ergebnis:**
| AnteilFirmen |
|--------------|
| 35           |

Erstellen Sie die entsprechende SQL-Anweisung.''',
            type: QuestionType.code,
            points: 5,
            hint:
                'COUNT mit WHERE Anrede = "Firma" geteilt durch COUNT(*) aller Kunden, multipliziert mit 100.',
          ),

          Question(
            id: 'ae_exam_1_q5c',
            title: 'Aufgabe 5c) Tagesumsatz Berlin-Hamburg (5 Punkte)',
            description: '''**Aufgabe c) Tagesumsatz einer Route**

Berechnen Sie den Umsatz eines Tages für die Route Berlin → Hamburg unter der Annahme, dass jede Lieferfahrt durchschnittlich 8 Sendungen transportiert.

**Beispiel-Ergebnis:**
| Tagesumsatz |
|-------------|
| 1.920,00 EUR|

Erstellen Sie die entsprechende SQL-Anweisung.''',
            type: QuestionType.code,
            points: 5,
            hint:
                'SUM(Kosten) der Lieferfahrten WHERE von = "Berlin" AND nach = "Hamburg" AND Datum = [heute], multipliziert mit 8.',
          ),

          Question(
            id: 'ae_exam_1_q5d',
            title: 'Aufgabe 5d) Freie Lagerplätze (7 Punkte)',
            description: '''**Aufgabe d) Liste freier Lagerplätze**

Zeigen Sie alle freien Lagerplätze für die Lieferfahrt mit Lieferfahrt_Datum_ID 234 im LKW mit ID 7 an.

**Beispiel-Ergebnis:**
| Platz |
|-------|
| A3    |
| B2    |
| C1    |

**Vervollständigen Sie folgende SQL-Anweisung:**
```sql
SELECT ___________________

FROM _____________________

WHERE LKW_Ladeplan.LKW_ID = 7

    AND NOT EXISTS

        (SELECT *

        FROM _________________________

        WHERE ____________________________ = 234

        AND __________________________ = LKW_Ladeplan.Platz)
```

**Hinweise:**
- Verwenden Sie nur die Tabellen LKW_Ladeplan und Sendung_Zuordnung
- NOT EXISTS ist erfüllt, wenn die WHERE-Bedingungen der Unterabfrage nicht zutreffen

Erstellen Sie die vollständige SQL-Anweisung.''',
            type: QuestionType.code,
            points: 7,
            hint:
                'SELECT Platz FROM LKW_Ladeplan, dann NOT EXISTS Unterabfrage auf Sendung_Zuordnung mit Lieferfahrt_Datum_ID und Platz.',
          ),
        ],
      ),
    ];
  }

  // ========== AE PRÜFUNG 2: Sommer 2017 - VisionSec GmbH ==========
  // KOMPLETT mit allen Unteraufgaben!

  static List<ExamSection> getAE_Exam2() {
    return [
      // ==========================================
      // HANDLUNGSSCHRITT 1: UML-Klassendiagramm (25 Punkte)
      // ==========================================
      ExamSection(
        id: 'ae_exam_2_s1',
        title: 'Handlungsschritt 1: UML-Klassendiagramm (25 Punkte)',
        totalPoints: 25,
        questions: [
          // Aufgabe a) - Beziehungen (6 Punkte total)
          Question(
            id: 'ae_exam_2_q1_aa',
            title: 'Aufgabe aa) Assoziation (2 Punkte)',
            description:
                '''Die VisionSec GmbH soll eine Software zur Erkennung und Speicherung von Gesichtsprofilen und Iris-Scans erstellen.

Zur Vorbereitung der Programmierung soll ein UML-Klassendiagramm erstellt werden.

**a) In einem UML-Klassendiagramm können die folgenden Beziehungen vorkommen.**

**Beschreiben Sie jeweils kurz:**

**aa) Assoziation**''',
            type: QuestionType.freeText,
            points: 2,
          ),

          Question(
            id: 'ae_exam_2_q1_ab',
            title: 'Aufgabe ab) Vererbung (2 Punkte)',
            description: '''**ab) Vererbung**''',
            type: QuestionType.freeText,
            points: 2,
          ),

          Question(
            id: 'ae_exam_2_q1_ac',
            title: 'Aufgabe ac) Komposition (2 Punkte)',
            description: '''**ac) Komposition**''',
            type: QuestionType.freeText,
            points: 2,
          ),

          // Aufgabe b) - UML-Diagramm (19 Punkte)
          Question(
            id: 'ae_exam_2_q1_b',
            title: 'Aufgabe b) UML-Klassendiagramm erstellen (19 Punkte)',
            description:
                '''**b) Für eine Person sollen von der linken und rechten Gesichtshälfte jeweils folgende Merkmale gespeichert werden:**

- M1 bis M5: Merkmale der fünf Gesichtsregionen
- L1 und L2: Merkmale der Iris (links und rechts)

Zu jedem Merkmal sollen ein Bild und ein String gespeichert werden.

Die Zeichenkette enthält Beschreibungen derjenigen Merkmale des Merkmals, die beim Vergleich von Gesichtsprofilen verwendet werden.

Die Zeichenkette wird von der Methode berechneZeichenkette() anhand des Bildes berechnet.

Die Algorithmen zur Berechnung der Zeichenketten sind für Gesichtsprofil und Iris-Scan unterschiedlich.

**Es existiert bereits folgende Klasse Merkmal, die für das Klassendiagramm verwendet werden soll:**

```
Merkmal
- Bild
- String
+ berechneZeichenkette()
```

**Erstellen Sie auf der Folgeseite ein UML-Klassendiagramm, das:**
- die Klassen Person, Gesicht, Region, Iris, Merkmal, MerkmalGesicht, MerkmalIris darstellt
- die Beziehungen zwischen den Klassen mit ihren Kardinalitäten angibt
- Geben Sie an, in welchen Klassen die Methode berechneZeichenkette() überschrieben werden muss

Hinweis: Notation zum UML-Klassendiagramm, siehe Belegsatz, Seite 2''',
            type: QuestionType.diagram,
            points: 19,
            hint:
                'Verwenden Sie Vererbung für MerkmalGesicht und MerkmalIris. Die Methode muss in beiden Unterklassen überschrieben werden.',
          ),
        ],
      ),

      // ==========================================
      // HANDLUNGSSCHRITT 2: Algorithmus (25 Punkte)
      // ==========================================
      ExamSection(
        id: 'ae_exam_2_s2',
        title: 'Handlungsschritt 2: Algorithmus (25 Punkte)',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_2_q2',
            title: 'Aufgabe 2: Algorithmus auswertung() (25 Punkte)',
            description:
                '''Um herauszufinden, von welcher Person ein Gesichtsprofil stammt, soll dieser mit Gesichtsprofilen in einer Datenbank verglichen werden.

Zu jedem in der Datenbank gefundenen Gesichtsprofil wird ein Score ermittelt, der den Prozentsatz der Übereinstimmung angibt. Bei vollständiger Übereinstimmung beträgt der Score 100 %.

Die vorhandene Funktion suche(merkmal) gibt ein Array matches aus, das zu jedem gefundenen Gesichtsprofil einen Score, eine Personen-ID und eine Region-ID enthält.

Die VisionSec GmbH soll nun die Prozedur auswertung erstellen, die eine Gesichtsprofilsuche durchführt und nur Daten der Gesichtsprofile ausgibt, deren Scores oberhalb eines bestimmten Schwellenwertes liegen.

**Der Prozedur werden die folgenden drei Parameter übergeben:**

| Parameter | Typ | Werte | Beschreibung |
|-----------|-----|-------|--------------|
| merkmal | Zeichenkette | - | Werte des Gesichtsprofilbildes als Zeichenkette |
| schwelle | ganzzahliger Wert | 1 bis 100 | Gibt einen Score an, ab dem Gesichtsprofile aufgelistet werden sollen |
| region | ganzzahliger Wert | 0 = Unbekannte Region; 1 = Region 1 ... 10 = Region 10 | Identifiziert die Gesichtsregion |

**Folgende Funktionen und Prozeduren sollen verwendet werden:**

| Funktion | Beschreibung |
|----------|--------------|
| suche(merkmal) | Durchsucht die Datenbank nach Gesichtsprofilen. Rückgabe: Array vom Datentyp Match: {score: Integer; idPerson: Integer; idRegion: Integer} |
| laenge(array) | Liefert die Länge des Arrays |
| loesche(array, position) | Löscht das Array-Element an der entsprechenden Position (0-basiert) |

**Zurückgegeben werden soll ein Array vom Datentyp Match:**
- Das Array soll nur die Daten derjenigen Gesichtsprofile enthalten, deren Scores oberhalb des mit dem Übergabeparameter schwelle übergebenen Wertes liegen
- Ist der Region-Typ bekannt (Übergabewert region = 1 bis 10), dann sollen nur Daten zu diesem Region-Typ in das zurückzugebende Array übernommen werden
- Ist der Region-Typ nicht bekannt (Übergabewert region = 0), dann sollen die Daten zu allen Region-Typen (idRegion = 1 bis 10) übernommen werden
- Das Array soll nach Score absteigend sortiert sein. Der Sortieralgorithmus muss selbst erstellt werden

**Beispiel:**

Array matches vom Typ Match, das von der Funktion suche(merkmal) erstellt wird:

| score | idPerson | idRegion |
|-------|----------|----------|
| 85 | 93334 | 2 |
| 80 | 48774 | 1 |
| 98 | 56446 | 2 |
| 71 | 33961 | 10 |
| 21 | 73447 | 2 |
| 81 | 49982 | 2 |

Array, das von der Prozedur auswertung zurückgegeben werden soll.
Übergabewerte: schwelle = 80 und region = 2

| score | idPerson | idRegion |
|-------|----------|----------|
| 98 | 56446 | 2 |
| 85 | 93334 | 2 |
| 81 | 49982 | 2 |

**Stellen Sie auf der Folgeseite den Algorithmus der Prozedur auswertung in Pseudocode oder in einem Struktogramm oder als Programmablaufplan dar.**''',
            type: QuestionType.code,
            points: 25,
            hint:
                'Filtern Sie zuerst nach Score und Region, dann sortieren Sie absteigend mit eigenem Sortieralgorithmus (z.B. Bubble Sort).',
          ),
        ],
      ),

      // ==========================================
      // HANDLUNGSSCHRITT 3: UML-Aktivitätsdiagramm (25 Punkte)
      // ==========================================
      ExamSection(
        id: 'ae_exam_2_s3',
        title: 'Handlungsschritt 3: UML-Aktivitätsdiagramm (25 Punkte)',
        totalPoints: 25,
        questions: [
          // Aufgabe a) - Aktivitätsdiagramm (20 Punkte)
          Question(
            id: 'ae_exam_2_q3_a',
            title: 'Aufgabe a) UML-Aktivitätsdiagramm erstellen (20 Punkte)',
            description:
                '''Die VisionSec GmbH soll ein System zur Gesichtsprofilrecherche erstellen.

**a) Zur Vorbereitung der Programmierung des Systems zur Recherche soll ein UML-Aktivitätsdiagramm erstellt werden.**

Die Recherche im System soll wie folgt organisiert werden:

- Ein Auftraggeber schickt ein Gesichtsprofil (GP) zur Identifizierung an den Operator
- Der Operator prüft, ob die Qualität des GP in Ordnung ist
- Ist die Qualität nicht ok, dann schickt der Operator eine entsprechende Information an den Auftraggeber und die Auftragsbearbeitung ist beendet
- Ist die Qualität ok, dann führt der Operator eine Suche nach entsprechenden GPs durch
- Werden keine GPs mit Übereinstimmungen gefunden, schickt der Operator eine entsprechende Info an den Auftraggeber und die Auftragsbearbeitung ist beendet
- War die Suche erfolgreich, werden vom Operator parallel ein Report erstellt und die Auftragsdaten an den Supervisor verschickt
- Der Supervisor protokolliert die Auftragsdaten und schickt eine Info an den Operator, dass die Daten protokolliert wurden
- Nachdem der Report erstellt und die Info vom Supervisor verschickt wurden, versendet der Operator den Report an den Auftraggeber und die Auftragsbearbeitung ist beendet

**Stellen Sie auf der Folgeseite den geschilderten Ablauf in einem UML-Aktivitätsdiagramm dar.**

Hinweis: Notation zum UML-Aktivitätsdiagramm, siehe Seite 3 im Belegsatz.''',
            type: QuestionType.diagram,
            points: 20,
            hint:
                'Verwenden Sie 3 Schwimmbahnen (Auftraggeber, Operator, Supervisor). Zeigen Sie parallele Aktivitäten (Fork/Join) und Synchronisation.',
          ),

          // Aufgabe b) - Minimaler Score (5 Punkte)
          Question(
            id: 'ae_exam_2_q3_b',
            title: 'Aufgabe b) Algorithmus minimaler Score (5 Punkte)',
            description:
                '''**b) Das Suchergebnis liegt im Array matches vor.** Zu jedem im System gefundenen Gesichtsprofil wird ein Score angegeben.

Array matches:

| score | idPerson |
|-------|----------|
| 21 | 73447 |
| 85 | 93334 |
| 80 | 48774 |
| 98 | 56446 |
| 81 | 49982 |

Im Report soll eine Auswertung des Suchergebnisses ausgegeben werden. Dazu soll der minimale Score-Wert im Array matches ermittelt werden.

**Beispiel:**
```
Auswertung:
minimaler Score = 21
```

**Stellen Sie den Algorithmus als Teil einer Prozedur in Pseudocode, in einem Struktogramm oder Programmablaufplan dar.**''',
            type: QuestionType.code,
            points: 5,
            hint:
                'Initialisieren Sie minScore mit dem ersten Element, durchlaufen Sie das Array und vergleichen Sie.',
          ),
        ],
      ),

      // ==========================================
      // HANDLUNGSSCHRITT 4: ER-Diagramm (25 Punkte)
      // ==========================================
      ExamSection(
        id: 'ae_exam_2_s4',
        title: 'Handlungsschritt 4: ER-Diagramm (25 Punkte)',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_2_q4',
            title: 'Aufgabe 4: Relationales Datenmodell (25 Punkte)',
            description:
                '''Die VisionSec GmbH soll für eine Sicherheitsbehörde eine Datenbank erstellen, in der die Daten von Vorgängen erfasst werden, die bislang in folgender Excel-Tabelle gespeichert wurden. Die Namen der Beschuldigten sind geschwärzt.

**Erfassung von Vorgängen:**

| Vorgangs-ID | Verdächtigen-ID | Anrede | Verdächtiger | Geburtsdatum | Adresse | Delikt | Datum | Dokument | Bearbeiter |
|-------------|----------------|--------|--------------|--------------|---------|--------|-------|----------|------------|
| 301 | 5645 | Herr | [geschwärzt] | 28.02.1970 | 01234 AStadt, Kernweg 12 | Raub | 02.04.2017 | Personalausweis, Führerschein | Hansen, Klaus |
| 302 | 1213 | Herr | [geschwärzt] | 06.06.2000 | 02566 BStadt, Müller-Str. 1 | Drogenmissbrauch | 02.02.2014 | Personalausweis | Müller, Marcel |
| 303 | 7887 | Herr | [geschwärzt] | 01.07.1988 | 03669 AStadt, Franzgasse 3 | Fahrerflucht, Drogenmissbrauch | 30.3.2017 | Reisepass, Führerschein | Hansen, Klaus |
| 304 | 4545 | Frau | [geschwärzt] | 16.08.1991 | 02566 BStadt, Burgplatz 16 | Drogenmissbrauch | 12.4.2017 | Personalausweis | Wagner, Wolfram |
| 305 | 1213 | Herr | [geschwärzt] | 06.06.2000 | 02566 BStadt, Müller-Str. 1 | Körperverletzung | 08.03.2015 | Personalausweis | Hansen, Klaus |

**Erstellen Sie auf der Folgeseite für die geforderte Datenbank ein relationales Datenmodell in der dritten Normalform.**

- Geben Sie den Tabellen und Attributen selbsterklärende Namen
- Nennen Sie je Tabelle alle erforderlichen Attribute
- Kennzeichnen Sie Primärschlüssel mit PK und Fremdschlüssel mit FK
- Zeichnen Sie die Beziehungen mit deren Kardinalitäten ein

**Hinweis:** Die Adresse des Verdächtigen soll in diesem ersten Entwurf noch nicht normalisiert werden.''',
            type: QuestionType.diagram,
            points: 25,
            hint:
                'Tabellen: Vorgang, Verdaechtiger, Bearbeiter, Dokument. Beachten Sie 1:n-Beziehungen und m:n zwischen Vorgang und Dokument.',
          ),
        ],
      ),

      // ==========================================
      // HANDLUNGSSCHRITT 5: SQL-Abfragen (25 Punkte)
      // ==========================================
      ExamSection(
        id: 'ae_exam_2_s5',
        title: 'Handlungsschritt 5: SQL-Abfragen (25 Punkte)',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_2_q5_a',
            title: 'Aufgabe a) SQL - Gebäude mit Räumen (5 Punkte)',
            description:
                '''Die VisionSec GmbH entwickelt ein System zur Zugangskontrolle. Dazu wurde bereits folgende Datenbank entwickelt und mit Testdaten gefüllt.

**Hinweis:** SQL-Syntax, siehe Seiten 4 und 5 im Belegsatz

**Tabelle Person:**
| PersID | Nachname | Vorname | Strasse | Plz | Ort |
|--------|----------|---------|---------|-----|-----|
| 101 | Müller | Max | Müllerweg 1 | 52335 | Köln |
| 202 | Meier | Willi | Testweg 12 | 43333 | Dortmund |
| 404 | Wester | Klaus | Hauptstr. 13 | 55667 | Köln |

**Tabelle Zugang:**
| RaumID | PersID | ZeitVon | ZeitBis |
|--------|--------|---------|---------|
| 1 | 101 | 08:00 | 10:00 |
| 1 | 202 | 10:00 | 14:00 |
| 2 | 101 | 14:00 | 18:00 |
| 5 | 202 | 08:00 | 18:00 |

**Tabelle Raum:**
| RaumID | RaumTyp | GebID | MerkID |
|--------|---------|-------|--------|
| 1 | Besprechungsraum | 2 | 1 |
| 2 | Labor | 2 | 2 |
| 3 | Labor | 1 | 2 |
| 4 | Labor | 1 | 2 |
| 5 | Besprechungsraum | 1 | 1 |

**Tabelle Gebaeude:**
| GebID | Bezeichnung | Strasse | Plz | Ort |
|-------|-------------|---------|-----|-----|
| 1 | Forschung H | Heinrich-Hertz-Str. 12 | 50501 | Köln |
| 2 | Forschung U | Heinrich-Hertz-Str. 14 | 50501 | Köln |
| 3 | Forschung I | Heinrich-Hertz-Str. 16 | 50501 | Köln |
| 4 | Verwaltung | Transalee 22 | 50555 | Köln |

**Tabelle Merkmal:**
| MerkID | Merkmal |
|--------|---------|
| 1 | Gesichtsprofil |
| 2 | Iris |

**Erstellen Sie die SQL-Anweisungen für folgende Ausgaben:**

**a) Liste aller Gebäude mit deren Räumen jeweils aufsteigend sortiert nach Gebäudebezeichnung und Raumtyp.**''',
            type: QuestionType.code,
            points: 5,
            hint:
                'LEFT OUTER JOIN zwischen Gebaeude und Raum, ORDER BY Bezeichnung ASC, RaumTyp ASC',
          ),

          Question(
            id: 'ae_exam_2_q5_b',
            title: 'Aufgabe b) SQL - Zugangsdaten mit Personendaten (5 Punkte)',
            description:
                '''**b) Liste aller Daten, die in der Tabelle Zugang gespeichert sind und die dazugehörigen Personendaten**''',
            type: QuestionType.code,
            points: 5,
            hint: 'RIGHT JOIN zwischen Person und Zugang auf PersID',
          ),

          Question(
            id: 'ae_exam_2_q5_c',
            title: 'Aufgabe c) SQL - Anzahl Räume pro Merkmal (6 Punkte)',
            description:
                '''**c) Anzahl der Räume, die bei der Zugangskontrolle das Merkmal Gesichtsprofil beziehungsweise das Merkmal Iris prüfen**''',
            type: QuestionType.code,
            points: 6,
            hint:
                'INNER JOIN Merkmal mit Raum, GROUP BY Merkmal.Merkmal, COUNT(Raum.RaumID)',
          ),

          Question(
            id: 'ae_exam_2_q5_d',
            title: 'Aufgabe d) SQL - Zugangsdaten von Max Müller (6 Punkte)',
            description: '''**d) Liste der Zugangsdaten von Max Müller**

Hinweis: Es ist nur der Name, nicht die PersID bekannt.''',
            type: QuestionType.code,
            points: 6,
            hint:
                'INNER JOIN Person mit Zugang, WHERE Vorname = "Max" AND Nachname = "Müller"',
          ),

          Question(
            id: 'ae_exam_2_q5_e',
            title: 'Aufgabe e) SQL - Personen aus PLZ-Gebiet (3 Punkte)',
            description:
                '''**e) Liste mit allen Personen aus dem PLZ-Gebiet 50000 bis 59999**''',
            type: QuestionType.code,
            points: 3,
            hint: 'SELECT * FROM Person WHERE Plz >= 50000 AND Plz <= 59999',
          ),
        ],
      ),
    ];
  }

  // ========== AE PRÜFUNG 3: 2020-2021 OOP ==========
  static List<ExamSection> getAE_Exam3() {
    return [
      ExamSection(
        id: 'ae_exam_3_s1',
        title: 'Handlungsschritt 1: Objektorientierte Modellierung',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_3_q1',
            title: 'Aufgabe 1: OOP-Konzepte (8 Punkte)',
            description:
                'Erklären Sie die Grundprinzipien der OOP: Kapselung, Vererbung und Polymorphismus.',
            type: QuestionType.freeText,
            points: 8,
            hint: 'Denken Sie an Bücher, Medien, Ausleihe als Klassen.',
          ),
          Question(
            id: 'ae_exam_3_q2',
            title: 'Aufgabe 2: UML-Diagramm (10 Punkte)',
            description:
                'Erstellen Sie ein UML-Klassendiagramm für Buch und Zeitschrift mit gemeinsamer Oberklasse.',
            type: QuestionType.diagram,
            points: 10,
          ),
        ],
      ),
    ];
  }

  // ========== AE PRÜFUNG 4: 2022-2023 Algorithmen ==========
  static List<ExamSection> getAE_Exam4() {
    return [
      ExamSection(
        id: 'ae_exam_4_s1',
        title: 'Handlungsschritt 1: Algorithmen',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_4_q1',
            title: 'Aufgabe 1: Sortieralgorithmen (12 Punkte)',
            description:
                'Beschreiben Sie den Bubble-Sort-Algorithmus und seine Komplexität.',
            type: QuestionType.freeText,
            points: 12,
          ),
        ],
      ),
    ];
  }

  // ========== AE PRÜFUNG 5: 2024-2025 Vollständig ==========
  static List<ExamSection> getAE_Exam5() {
    return [
      ExamSection(
        id: 'ae_exam_5_s1',
        title: 'Handlungsschritt 1: Objektorientierte Modellierung',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_5_q1',
            title: 'Aufgabe a) Grundkonzept der OOP (4 Punkte)',
            description:
                '''Ein Fahrradverleih-System soll mit objektorientierter Programmierung entwickelt werden.

Nennen Sie ein zentrales Ziel, das bei der objektorientierten Programmierung (OOP) mit dem Konzept der Kapselung erreicht werden kann.''',
            type: QuestionType.freeText,
            points: 4,
            hint:
                'Denken Sie an die Trennung von Implementierung und Schnittstelle.',
          ),
          Question(
            id: 'ae_exam_5_q2',
            title: 'Aufgabe b) UML-Klassendiagramm (10 Punkte)',
            description:
                'Entwickeln Sie ein UML-Klassendiagramm für Privatkunde und Firmenkunde mit Generalisierung.',
            type: QuestionType.diagram,
            points: 10,
          ),
        ],
      ),

      ExamSection(
        id: 'ae_exam_5_s2',
        title: 'Handlungsschritt 2: Vererbung & Polymorphismus',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_5_q3',
            title: 'Aufgabe a) Vererbung (8 Punkte)',
            description: 'Erklären Sie Vererbung und Polymorphismus.',
            type: QuestionType.freeText,
            points: 8,
          ),
        ],
      ),

      ExamSection(
        id: 'ae_exam_5_s3',
        title: 'Handlungsschritt 3: Algorithmen',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_5_q4',
            title: 'Aufgabe a) Prüfziffer-Algorithmus (15 Punkte)',
            description:
                'Implementieren Sie einen Algorithmus zur Berechnung von Prüfziffern.',
            type: QuestionType.code,
            points: 15,
          ),
        ],
      ),

      ExamSection(
        id: 'ae_exam_5_s4',
        title: 'Handlungsschritt 4: Datenmodellierung',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_5_q5',
            title: 'Aufgabe a) ER-Diagramm (10 Punkte)',
            description:
                'Erstellen Sie ein ER-Diagramm für das Fahrradverleih-System.',
            type: QuestionType.diagram,
            points: 10,
          ),
        ],
      ),

      ExamSection(
        id: 'ae_exam_5_s5',
        title: 'Handlungsschritt 5: SQL-Abfragen',
        totalPoints: 25,
        questions: [
          Question(
            id: 'ae_exam_5_q6',
            title: 'Aufgabe a) SQL UPDATE (8 Punkte)',
            description:
                'Schreiben Sie eine SQL-Abfrage zum Aktualisieren von Kundendaten.',
            type: QuestionType.code,
            points: 8,
          ),
        ],
      ),
    ];
  }

  // ========== AE PRÜFUNG 6: Placeholder ==========
  static List<ExamSection> getAE_Exam6() {
    return [
      ExamSection(
        id: 'ae_exam_6_s1',
        title: 'Handlungsschritt 1: Placeholder',
        totalPoints: 50,
        questions: [
          Question(
            id: 'ae_exam_6_q1',
            title: 'Abschlussprüfung 6 - Noch nicht verfügbar',
            description: 'Diese Prüfung wird später hinzugefügt.',
            type: QuestionType.freeText,
            points: 50,
          ),
        ],
      ),
    ];
  }

  // ========== SI PRÜFUNG 1: 2020-2021 Netzwerktechnik ==========
  static List<ExamSection> getSI_Exam1() {
    return [
      ExamSection(
        id: 'si_exam_1_s1',
        title: 'Handlungsschritt 1: Netzwerktechnik',
        totalPoints: 25,
        questions: [
          Question(
            id: 'si_exam_1_q1',
            title: 'Aufgabe 1: OSI-Modell (10 Punkte)',
            description:
                'Beschreiben Sie die 7 Schichten des OSI-Modells und ordnen Sie Protokolle zu.',
            type: QuestionType.freeText,
            points: 10,
          ),
          Question(
            id: 'si_exam_1_q2',
            title: 'Aufgabe 2: TCP/IP (15 Punkte)',
            description: 'Erklären Sie den Unterschied zwischen TCP und UDP.',
            type: QuestionType.freeText,
            points: 15,
          ),
        ],
      ),
    ];
  }

  // ========== SI PRÜFUNG 2: 2022-2023 Netzwerkplanung ==========
  static List<ExamSection> getSI_Exam2() {
    return [
      ExamSection(
        id: 'si_exam_2_s1',
        title: 'Handlungsschritt 1: Netzwerkplanung',
        totalPoints: 25,
        questions: [
          Question(
            id: 'si_exam_2_q1',
            title: 'Aufgabe 1: IP-Subnetting (12 Punkte)',
            description:
                'Berechnen Sie Subnetze für ein Firmennetzwerk mit 4 Abteilungen.',
            type: QuestionType.freeText,
            points: 12,
          ),
          Question(
            id: 'si_exam_2_q2',
            title: 'Aufgabe 2: VLAN-Konfiguration (13 Punkte)',
            description: 'Erklären Sie VLANs und deren Einsatzzweck.',
            type: QuestionType.freeText,
            points: 13,
          ),
        ],
      ),
    ];
  }

  // ========== SI PRÜFUNG 3: 2024-2025 IT-Sicherheit ==========
  static List<ExamSection> getSI_Exam3() {
    return [
      ExamSection(
        id: 'si_exam_3_s1',
        title: 'Handlungsschrift 1: IT-Sicherheit',
        totalPoints: 25,
        questions: [
          Question(
            id: 'si_exam_3_q1',
            title: 'Aufgabe 1: Firewall-Konzepte (10 Punkte)',
            description:
                'Beschreiben Sie verschiedene Firewall-Typen (Paketfilter, Stateful, Application).',
            type: QuestionType.freeText,
            points: 10,
          ),
          Question(
            id: 'si_exam_3_q2',
            title: 'Aufgabe 2: VPN-Technologien (15 Punkte)',
            description: 'Erklären Sie Site-to-Site und Remote-Access VPN.',
            type: QuestionType.freeText,
            points: 15,
          ),
        ],
      ),
    ];
  }

  // ========== SI PRÜFUNGEN 4-6: Placeholder ==========
  static List<ExamSection> getSI_Exam4() {
    return [
      ExamSection(
        id: 'si_exam_4_s1',
        title: 'Handlungsschritt 1: Placeholder',
        totalPoints: 50,
        questions: [
          Question(
            id: 'si_exam_4_q1',
            title: 'SI Prüfung 4 - Noch nicht verfügbar',
            description: 'Diese Prüfung wird später hinzugefügt.',
            type: QuestionType.freeText,
            points: 50,
          ),
        ],
      ),
    ];
  }

  static List<ExamSection> getSI_Exam5() {
    return [
      ExamSection(
        id: 'si_exam_5_s1',
        title: 'Handlungsschritt 1: Placeholder',
        totalPoints: 50,
        questions: [
          Question(
            id: 'si_exam_5_q1',
            title: 'SI Prüfung 5 - Noch nicht verfügbar',
            description: 'Diese Prüfung wird später hinzugefügt.',
            type: QuestionType.freeText,
            points: 50,
          ),
        ],
      ),
    ];
  }

  static List<ExamSection> getSI_Exam6() {
    return [
      ExamSection(
        id: 'si_exam_6_s1',
        title: 'Handlungsschritt 1: Placeholder',
        totalPoints: 50,
        questions: [
          Question(
            id: 'si_exam_6_q1',
            title: 'SI Prüfung 6 - Noch nicht verfügbar',
            description: 'Diese Prüfung wird später hinzugefügt.',
            type: QuestionType.freeText,
            points: 50,
          ),
        ],
      ),
    ];
  }
}
