// lib/data/kurse/kurs_config.dart
//
// Zentrale Schalter fuer die Kurse.

import 'package:flutter/foundation.dart' show kDebugMode;

/// Premium-Gate fuer Kurslektionen.
///
/// false: der komplette Kurs ist kostenlos, das premium-Flag der
///        Lektionen wird ignoriert (Start-/Wachstumsphase).
/// true:  Lektionen mit premium: true (aktuell 8 bis 14) brauchen ein
///        aktives Premium-Abo. Gesperrte Kacheln zeigen ein Schloss
///        und oeffnen das Kauf-Sheet.
///
/// Zum Umschalten nur diese Konstante aendern und ein Release bauen.
const bool kursPremiumAktiv = false;

/// Lektionen der Reihe nach freispielen.
///
/// true:  Lektion N oeffnet erst, wenn alle Aufgaben von Lektion N-1
///        geloest sind. Verriegelte Kacheln sind abgedunkelt und zeigen
///        ein graues Schloss.
/// false: alle Lektionen sind frei anwaehlbar (praktisch zum Testen).
///
/// Im Debug-Build aus, damit neue Lektionen ohne Durchspielen der
/// vorherigen testbar sind (27.09.2026). Store-Builds (Release) sind
/// davon nicht betroffen, dort gilt die Reihenfolge weiter.
const bool kursReihenfolgeAktiv = !kDebugMode;
