// lib/data/kurse/struktogramm_kurs.dart
//
// Der Struktogramm-Kurs der App: 10 Lektionen, Start bei null (Plan und
// Schreibregeln in PROJECT_STATE.md, Eintrag „Struktogramm-Kurs in der
// App“). Jede Lektion liegt in einer eigenen Datei unter
// lib/data/kurse/struktogramm/, reine Daten, gezeichnet vom LektionScreen.
//
// Stand 29.09.2026: Lektionen 1 bis 10 geschrieben (Autor Opus 5.5),
// Gutachten Sonnet (vorläufig) und Fable (29.09.) eingearbeitet. Ab
// Release 1.8.0 im Lern-Tab für alle sichtbar.

import '../../models/kurs_aufgabe.dart';
import 'struktogramm/lektion_01.dart';
import 'struktogramm/lektion_02.dart';
import 'struktogramm/lektion_03.dart';
import 'struktogramm/lektion_04.dart';
import 'struktogramm/lektion_05.dart';
import 'struktogramm/lektion_06.dart';
import 'struktogramm/lektion_07.dart';
import 'struktogramm/lektion_08.dart';
import 'struktogramm/lektion_09.dart';
import 'struktogramm/lektion_10.dart';

const struktogrammKurs = Kurs(
  slug: 'struktogramm',
  titel: 'Struktogramm und Pseudocode',
  beschreibung:
      'Abläufe lesen, ergänzen und selbst entwerfen, wie in der AP1. '
      'Mit Schreibtischtest, Pseudocode und Prüfungstraining.',
  lektionenGeplant: 10,
  lektionen: [
    struktogrammLektion1,
    struktogrammLektion2,
    struktogrammLektion3,
    struktogrammLektion4,
    struktogrammLektion5,
    struktogrammLektion6,
    struktogrammLektion7,
    struktogrammLektion8,
    struktogrammLektion9,
    struktogrammLektion10,
  ],
);
