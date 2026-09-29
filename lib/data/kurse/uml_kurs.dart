// lib/data/kurse/uml_kurs.dart
//
// Der UML-Kurs der App: 11 Lektionen, Start bei null (Plan und
// Schreibregeln in PROJECT_STATE.md, Eintrag „UML-Kurs in der App“). Jede
// Lektion liegt in einer eigenen Datei unter lib/data/kurse/uml/, reine
// Daten. Die Diagramme stehen als Konstanten oben in jeder Lektionsdatei
// (Format: models/uml.dart) und werden von widgets/kurs/uml_ansicht.dart
// gezeichnet.
//
// Stand 29.09.2026: Lektionen 1 bis 11 geschrieben (Autor Opus 5.5),
// Gutachten Sonnet (vorläufig) und Fable (29.09.) eingearbeitet. Ab
// Release 1.8.0 im Lern-Tab für alle sichtbar.

import '../../models/kurs_aufgabe.dart';
import 'uml/lektion_01.dart';
import 'uml/lektion_02.dart';
import 'uml/lektion_03.dart';
import 'uml/lektion_04.dart';
import 'uml/lektion_05.dart';
import 'uml/lektion_06.dart';
import 'uml/lektion_07.dart';
import 'uml/lektion_08.dart';
import 'uml/lektion_09.dart';
import 'uml/lektion_10.dart';
import 'uml/lektion_11.dart';

const umlKurs = Kurs(
  slug: 'uml',
  titel: 'UML von Grund auf',
  beschreibung:
      'Use-Case-, Klassen-, Aktivitäts-, Sequenz- und Zustandsdiagramm '
      'lesen und entwerfen, wie in der Prüfung. Mit Code und '
      'Prüfungstraining.',
  lektionenGeplant: 11,
  lektionen: [
    umlLektion1,
    umlLektion2,
    umlLektion3,
    umlLektion4,
    umlLektion5,
    umlLektion6,
    umlLektion7,
    umlLektion8,
    umlLektion9,
    umlLektion10,
    umlLektion11,
  ],
);
