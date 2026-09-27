// lib/widgets/kurs/struktogramm_ansicht.dart
//
// Zeichnet ein Struktogramm (Nassi-Shneiderman, DIN 66261) aus dem
// Datenformat in lib/models/struktogramm.dart.
//
// Optik wie im Web-Kurs (web/app/struktogramm-kurs/struktogramm.css):
// Linien in Textfarbe, Inhalte in JetBrains Mono, Schleifenzeile und
// Schleifenbalken in zartem Akzent, Lücken schraffiert mit Marke.
//
// Aufbau: Jede Blockliste ist eine Spalte, alle Blöcke darin gleich breit.
// Die Gesamtbreite ergibt sich aus dem Inhalt (IntrinsicWidth), mindestens
// aber die verfügbare Breite. Reicht die Breite nicht (Handy), brechen
// Anweisungen zuerst um. Erst wenn die Spalten dadurch schmaler als ihre
// Mindestbreite würden (tief verschachtelt), lässt sich das Struktogramm
// seitlich schieben. Zweige und Fälle nebeneinander sind gleich breit
// (wie im Web: Spalten zu je 1fr).
//
// Keine Interaktion, keine eigenen Zustände. Die Farben kommen aus dem
// umgebenden Theme (kursTheme), dadurch passt es in Hell und Dunkel.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/struktogramm.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class StruktogrammAnsicht extends StatelessWidget {
  final List<SgBlock> bloecke;

  /// Überschrift im Kopf, bei Unterprogrammen die Signatur.
  final String? titel;

  /// Bildunterschrift unter dem Struktogramm.
  final String? unterschrift;

  /// Mindestbreite in Pixeln (Standard 460), höchstens die verfügbare
  /// Breite. Auf dem Handy füllt ein Struktogramm damit immer die Zeile.
  final double? breite;

  /// Kompakte Darstellung für Übersichten.
  final bool klein;

  const StruktogrammAnsicht({
    super.key,
    required this.bloecke,
    this.titel,
    this.unterschrift,
    this.breite,
    this.klein = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = _SgStil.von(context, klein: klein);

    final rahmen = Container(
      decoration: BoxDecoration(
        color: s.flaeche,
        border: Border.all(color: s.linie, width: s.dicke),
      ),
      child: _spalte([
        if (titel != null) _titel(titel!, s),
        if (bloecke.isEmpty) _leer(s) else ..._bauen(bloecke, s),
      ], s),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, grenzen) {
              final minBreite = math.min(grenzen.maxWidth, breite ?? 460);
              // Höchstens die verfügbare Breite, damit Text umbricht, statt
              // dass schon ein einfaches Struktogramm seitlich scrollt. Nur
              // wenn die Spalten sonst zu schmal würden, darf es breiter sein.
              var strukturMin = _minListe(bloecke, s);
              if (titel != null) {
                strukturMin = math.max(strukturMin, s.wortMin(titel!, 13) + 24);
              }
              final maxBreite = math.max(
                grenzen.maxWidth,
                strukturMin + 2 * s.dicke,
              );
              final inhalt = ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: minBreite,
                  maxWidth: maxBreite,
                ),
                child: IntrinsicWidth(child: rahmen),
              );
              // Breiter als der Bildschirm: sichtbare Leiste darunter, damit
              // man sieht, dass es rechts weitergeht.
              if (maxBreite > grenzen.maxWidth + 0.5) {
                return SeitlichSchiebbar(child: inhalt);
              }
              return inhalt;
            },
          ),
          if (unterschrift != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                unterschrift!,
                style: AppTextStyles.interTight(
                  size: 13.5,
                  color: s.textMid,
                  height: 1.45,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Seitlich schiebbarer Bereich mit dauerhaft sichtbarer Leiste, sobald der
/// Inhalt breiter ist als der Platz. Auch von der Schreibtischtest-Tabelle
/// genutzt.
class SeitlichSchiebbar extends StatefulWidget {
  final Widget child;

  const SeitlichSchiebbar({super.key, required this.child});

  @override
  State<SeitlichSchiebbar> createState() => _SeitlichSchiebbarState();
}

class _SeitlichSchiebbarState extends State<SeitlichSchiebbar> {
  final _steuerung = ScrollController();

  @override
  void dispose() {
    _steuerung.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _steuerung,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _steuerung,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 12),
        child: widget.child,
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Stil: Farben und Maße an einer Stelle
// ───────────────────────────────────────────────────────────────────────────

class _SgStil {
  final bool klein;
  final Color linie;
  final Color flaeche;
  final Color titelFlaeche;
  final Color zart;
  final Color schraffur;
  final Color text;
  final Color textMid;
  final Color textDim;
  final Color akzent;

  const _SgStil({
    required this.klein,
    required this.linie,
    required this.flaeche,
    required this.titelFlaeche,
    required this.zart,
    required this.schraffur,
    required this.text,
    required this.textMid,
    required this.textDim,
    required this.akzent,
  });

  factory _SgStil.von(BuildContext context, {required bool klein}) {
    final dunkel = Theme.of(context).brightness == Brightness.dark;
    return _SgStil(
      klein: klein,
      linie: dunkel ? AppColors.darkText : AppColors.lightText,
      flaeche: dunkel ? AppColors.darkSurface : AppColors.lightSurface,
      titelFlaeche: dunkel ? AppColors.darkBgMuted : AppColors.lightBgMuted,
      zart: AppColors.accent.withValues(alpha: dunkel ? 0.16 : 0.12),
      schraffur: AppColors.accent.withValues(alpha: dunkel ? 0.34 : 0.28),
      text: dunkel ? AppColors.darkText : AppColors.lightText,
      textMid: dunkel ? AppColors.darkTextMid : AppColors.lightTextMid,
      textDim: dunkel ? AppColors.darkTextDim : AppColors.lightTextDim,
      akzent: dunkel ? AppColors.accent : AppColors.lightAccentInk,
    );
  }

  double get dicke => 1.5;
  double get zeile => klein ? 32 : 38;
  double get balken => 26;

  /// Ab dieser Breite brechen Anweisungen um, statt das ganze
  /// Struktogramm breiter zu machen.
  double get textMax => klein ? 240 : 300;

  /// Schmaler als das wird ein Kasten mit Text auch auf dem Handy nicht.
  double get textMin => klein ? 80 : 100;

  /// Mindestbreite je Zweig einer Verzweigung.
  double get zweigMin => klein ? 90 : 120;

  /// Mindestbreite je Fall einer Mehrfachauswahl.
  double get fallMin => klein ? 70 : 100;

  EdgeInsets get innen => klein
      ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
      : const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  BorderSide get seite => BorderSide(color: linie, width: dicke);

  double get codeGroesse => klein ? 12.5 : 13.5;

  /// Breite des längsten Worts, damit Wörter wie `neuesSpiel()` nie
  /// mitten im Wort umbrechen. JetBrains Mono: jedes Zeichen 0,6 em breit.
  /// Für die Überschrift (Inter Tight) ist das eine großzügige Schätzung.
  double wortMin(String text, [double? groesse]) {
    var laengste = 0;
    for (final wort in text.split(RegExp(r'\s+'))) {
      laengste = math.max(laengste, wort.length);
    }
    return laengste * (groesse ?? codeGroesse) * 0.6 + 2;
  }

  /// Inhalt der Kästen: Anweisungen, Bedingungen, Ausdrücke.
  TextStyle get code => AppTextStyles.mono(
        size: codeGroesse,
        weight: FontWeight.w400,
        color: text,
        letterSpacing: 0,
      ).copyWith(height: 1.4);

  /// Beschriftungen: ja, nein, Fallwerte.
  TextStyle get marke => AppTextStyles.interTight(
        size: 12,
        weight: FontWeight.w600,
        color: textMid,
      );

  /// Schlüsselwort in der Schleifenzeile: solange, bis.
  TextStyle get wort => AppTextStyles.interTight(
        size: klein ? 12 : 12.5,
        weight: FontWeight.w600,
        color: textMid,
      );
}

// ───────────────────────────────────────────────────────────────────────────
// Spalten und Blöcke
// ───────────────────────────────────────────────────────────────────────────

List<Widget> _bauen(List<SgBlock> bloecke, _SgStil s) =>
    [for (final b in bloecke) _block(b, s)];

// ───────────────────────────────────────────────────────────────────────────
// Mindestbreiten: wie schmal darf ein Block werden, wenn Text umbricht?
// Spiegelt den Aufbau unten (gleich breite Spalten, Schleifenbalken).
// ───────────────────────────────────────────────────────────────────────────

double _minListe(List<SgBlock> bloecke, _SgStil s) {
  var breite = s.textMin;
  for (final b in bloecke) {
    breite = math.max(breite, _minBlock(b, s));
  }
  return breite;
}

/// Gleich breite Spalten nebeneinander: die breiteste bestimmt alle.
double _minSpalten(List<List<SgBlock>> spalten, double spalteMin, _SgStil s) {
  var je = spalteMin;
  for (final sp in spalten) {
    je = math.max(je, _minListe(sp, s));
  }
  return spalten.length * je + (spalten.length - 1) * s.dicke;
}

double _minBlock(SgBlock b, _SgStil s) {
  final innen = s.innen.horizontal;
  // Schleifenzeile: „solange “/„bis “ plus längstes Wort der Bedingung.
  double zeile(String t) => s.wortMin(t) + innen + 60;
  double rumpf(List<SgBlock> r) => s.balken + s.dicke + _minListe(r, s);
  return switch (b) {
    SgAnw a => math.max(s.textMin, s.wortMin(a.text) + innen),
    SgAufruf a => math.max(s.textMin, s.wortMin(a.text) + 36),
    SgLuecke _ => 60,
    SgWenn w => math.max(
        _minSpalten([w.ja, w.nein], s.zweigMin, s),
        s.wortMin(w.bedingung) + 36,
      ),
    SgFalls f => math.max(
        _minSpalten(
          [
            for (final fall in f.faelle) fall.bloecke,
            if (f.sonst != null) f.sonst!,
          ],
          s.fallMin,
          s,
        ),
        s.wortMin(f.ausdruck) + 30,
      ),
    SgSolange sch => math.max(rumpf(sch.rumpf), zeile(sch.bedingung)),
    SgFuer f => math.max(rumpf(f.rumpf), s.wortMin(f.kopf) + innen),
    SgWiederhole w => math.max(rumpf(w.rumpf), zeile(w.bedingung)),
  };
}

/// Eine Spalte gleich breiter Kästen, getrennt durch waagerechte Linien.
Widget _spalte(List<Widget> kinder, _SgStil s) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < kinder.length; i++)
        if (i == 0)
          kinder[i]
        else
          Container(
            decoration: BoxDecoration(border: Border(top: s.seite)),
            child: kinder[i],
          ),
    ],
  );
}

/// Blockliste als Spalte, leere Liste als ∅.
Widget _liste(List<SgBlock> bloecke, _SgStil s) =>
    bloecke.isEmpty ? _leer(s) : _spalte(_bauen(bloecke, s), s);

Widget _block(SgBlock b, _SgStil s) => switch (b) {
      SgAnw a => _anweisung(a.text, s),
      SgAufruf a => _aufruf(a.text, s),
      SgLuecke l => _luecke(l.marke, s),
      SgWenn w => _verzweigung(w, s),
      SgFalls f => _auswahl(f, s),
      SgSolange sch => _kopfschleife(
          kopf: TextSpan(children: [
            TextSpan(text: 'solange ', style: s.wort),
            TextSpan(text: sch.bedingung),
          ]),
          rumpf: sch.rumpf,
          label: 'Schleife solange ${sch.bedingung}',
          s: s,
        ),
      SgFuer f => _kopfschleife(
          kopf: TextSpan(text: f.kopf),
          rumpf: f.rumpf,
          label: 'Zählschleife ${f.kopf}',
          s: s,
        ),
      SgWiederhole w => _fussschleife(w, s),
    };

Widget _titel(String titel, _SgStil s) => Container(
      color: s.titelFlaeche,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: s.textMax),
        child: Text(
          titel,
          style: AppTextStyles.interTight(
            size: 13,
            weight: FontWeight.w600,
            color: s.textMid,
          ),
        ),
      ),
    );

Widget _anweisung(String text, _SgStil s) => Container(
      constraints: BoxConstraints(minHeight: s.zeile),
      padding: s.innen,
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: s.textMax),
        child: Text(text, style: s.code),
      ),
    );

Widget _leer(_SgStil s) => Semantics(
      label: 'leer',
      child: ExcludeSemantics(
        child: Container(
          constraints: BoxConstraints(minHeight: s.zeile),
          alignment: Alignment.center,
          child: Text(
            '∅',
            style: AppTextStyles.interTight(size: 15, color: s.textDim),
          ),
        ),
      ),
    );

/// Aufruf eines Unterprogramms: Rechteck mit doppelten Seitenlinien.
Widget _aufruf(String text, _SgStil s) => Semantics(
      container: true,
      label: 'Aufruf',
      child: CustomPaint(
        painter: _AufrufMaler(linie: s.linie, dicke: s.dicke),
        child: Container(
          constraints: BoxConstraints(minHeight: s.zeile),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: s.innen.top),
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: s.textMax),
            child: Text(text, style: s.code),
          ),
        ),
      ),
    );

/// Lücke für „Ergänzen Sie“: schraffiert, Marke in Akzentfarbe.
Widget _luecke(String marke, _SgStil s) => Semantics(
      label: 'Lücke $marke',
      child: ExcludeSemantics(
        child: CustomPaint(
          painter: _SchraffurMaler(farbe: s.schraffur),
          child: Container(
            constraints: BoxConstraints(minHeight: s.zeile, minWidth: 60),
            alignment: Alignment.center,
            child: Text(
              '($marke)',
              style: AppTextStyles.interTight(
                size: s.klein ? 12.5 : 13.5,
                weight: FontWeight.w700,
                color: s.akzent,
              ),
            ),
          ),
        ),
      ),
    );

/// Text mit Hintergrund in Flächenfarbe, damit Diagonalen nicht
/// durch die Schrift laufen.
Widget _freigestellt(Widget kind, _SgStil s, {EdgeInsets? innen}) =>
    Container(
      color: s.flaeche,
      padding: innen ?? const EdgeInsets.symmetric(horizontal: 6),
      child: kind,
    );

/// Mehrere Spalten nebeneinander, gleich breit, gleich hoch,
/// getrennt durch senkrechte Linien.
Widget _spaltenReihe(
  List<List<SgBlock>> spalten,
  List<String> labels,
  _SgStil s, {
  required double minBreite,
}) {
  return Container(
    decoration: BoxDecoration(border: Border(top: s.seite)),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < spalten.length; i++) ...[
            if (i > 0) Container(width: s.dicke, color: s.linie),
            Expanded(
              child: Semantics(
                container: true,
                label: labels[i],
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: minBreite),
                  child: _liste(spalten[i], s),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Zweiseitige Auswahl: Kopf mit zwei Diagonalen, darunter ja | nein.
Widget _verzweigung(SgWenn w, _SgStil s) {
  final kopf = CustomPaint(
    painter: _KopfMaler(
      linie: s.linie,
      dicke: s.dicke,
      knick: 0.5,
      zurueck: true,
      untenFrei: 0,
    ),
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: s.klein ? 50 : 58),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 22),
            child: Align(
              alignment: Alignment.topCenter,
              child: _freigestellt(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: s.textMax),
                  child: Text(
                    w.bedingung,
                    style: s.code,
                    textAlign: TextAlign.center,
                  ),
                ),
                s,
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 4,
            child: Text(w.jaText, style: s.marke),
          ),
          Positioned(
            right: 10,
            bottom: 4,
            child: Text(w.neinText, style: s.marke),
          ),
        ],
      ),
    ),
  );

  return Semantics(
    container: true,
    label: 'Verzweigung: ${w.bedingung}',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        kopf,
        _spaltenReihe(
          [w.ja, w.nein],
          ['${w.jaText}-Zweig', '${w.neinText}-Zweig'],
          s,
          minBreite: s.zweigMin,
        ),
      ],
    ),
  );
}

/// Mehrfachauswahl nach DIN 66261: Ausdruck oben links, Diagonale, die
/// Fallwerte darunter, dann die Spalten. Mit „sonst“ knickt die Diagonale
/// über der Sonst-Spalte wieder nach oben.
Widget _auswahl(SgFalls f, _SgStil s) {
  const werteStreifen = 24.0;
  final hatSonst = f.sonst != null;
  final werte = [for (final fall in f.faelle) fall.wert, if (hatSonst) 'sonst'];
  final spalten = [
    for (final fall in f.faelle) fall.bloecke,
    if (hatSonst) f.sonst!,
  ];

  final kopf = CustomPaint(
    painter: _KopfMaler(
      linie: s.linie,
      dicke: s.dicke,
      knick: hatSonst ? f.faelle.length / werte.length : 1.0,
      zurueck: hatSonst,
      untenFrei: werteStreifen,
    ),
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: s.klein ? 58 : 66),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 12, werteStreifen + 2),
            child: Align(
              alignment: Alignment.topLeft,
              child: _freigestellt(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: s.textMax),
                  child: Text(f.ausdruck, style: s.code),
                ),
                s,
                innen: const EdgeInsets.only(left: 12, right: 6),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 4,
            child: Row(
              children: [
                for (var i = 0; i < werte.length; i++) ...[
                  if (i > 0) SizedBox(width: s.dicke),
                  Expanded(
                    child: Text(
                      werte[i],
                      style: s.marke,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );

  return Semantics(
    container: true,
    label: 'Mehrfachauswahl: ${f.ausdruck}',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        kopf,
        _spaltenReihe(
          spalten,
          [for (final w in werte) 'Fall $w'],
          s,
          minBreite: s.fallMin,
        ),
      ],
    ),
  );
}

/// Zeile mit Bedingung oder Zählkopf, zart hinterlegt.
Widget _schleifenZeile(InlineSpan inhalt, _SgStil s) => Container(
      constraints: BoxConstraints(minHeight: s.zeile),
      padding: s.innen,
      alignment: Alignment.centerLeft,
      color: s.zart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: s.textMax),
        child: Text.rich(inhalt, style: s.code),
      ),
    );

/// Rumpf rechts neben dem Schleifenbalken.
Widget _rumpfMitBalken(List<SgBlock> rumpf, _SgStil s, {required bool linieOben}) {
  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(width: s.balken, color: s.zart),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: s.seite,
                top: linieOben ? s.seite : BorderSide.none,
              ),
            ),
            child: _liste(rumpf, s),
          ),
        ),
      ],
    ),
  );
}

/// Kopfgesteuerte Schleife und Zählschleife: Zeile oben, Rumpf darunter.
Widget _kopfschleife({
  required InlineSpan kopf,
  required List<SgBlock> rumpf,
  required String label,
  required _SgStil s,
}) {
  return Semantics(
    container: true,
    label: label,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _schleifenZeile(kopf, s),
        _rumpfMitBalken(rumpf, s, linieOben: true),
      ],
    ),
  );
}

/// Fußgesteuerte Schleife: Rumpf oben, Zeile mit „bis“ oder „solange“ unten.
Widget _fussschleife(SgWiederhole w, _SgStil s) {
  final wort = w.bis ? 'bis' : 'solange';
  return Semantics(
    container: true,
    label: 'Schleife, danach $wort ${w.bedingung}',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _rumpfMitBalken(w.rumpf, s, linieOben: false),
        Container(
          decoration: BoxDecoration(border: Border(top: s.seite)),
          child: _schleifenZeile(
            TextSpan(children: [
              TextSpan(text: '$wort ', style: s.wort),
              TextSpan(text: w.bedingung),
            ]),
            s,
          ),
        ),
      ],
    ),
  );
}

// ───────────────────────────────────────────────────────────────────────────
// Maler
// ───────────────────────────────────────────────────────────────────────────

/// Diagonalen im Kopf von Verzweigung und Mehrfachauswahl.
class _KopfMaler extends CustomPainter {
  final Color linie;
  final double dicke;

  /// Waagerechte Lage des Knicks, 0 bis 1.
  final double knick;

  /// Zweiter Schenkel zurück nach rechts oben (Verzweigung, Auswahl
  /// mit „sonst“). Ohne ihn endet die Diagonale unten rechts.
  final bool zurueck;

  /// Unten freigelassener Streifen, in dem die Fallwerte stehen.
  final double untenFrei;

  const _KopfMaler({
    required this.linie,
    required this.dicke,
    required this.knick,
    required this.zurueck,
    required this.untenFrei,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final hoehe = size.height - untenFrei;
    final stift = Paint()
      ..color = linie
      ..strokeWidth = dicke
      ..style = PaintingStyle.stroke;
    final pfad = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * knick, hoehe);
    if (zurueck) pfad.lineTo(size.width, 0);
    canvas.drawPath(pfad, stift);
  }

  @override
  bool shouldRepaint(_KopfMaler alt) =>
      alt.linie != linie ||
      alt.dicke != dicke ||
      alt.knick != knick ||
      alt.zurueck != zurueck ||
      alt.untenFrei != untenFrei;
}

/// Die zwei inneren Seitenlinien des Aufruf-Kastens.
class _AufrufMaler extends CustomPainter {
  final Color linie;
  final double dicke;

  const _AufrufMaler({required this.linie, required this.dicke});

  @override
  void paint(Canvas canvas, Size size) {
    final stift = Paint()
      ..color = linie
      ..strokeWidth = dicke;
    canvas.drawLine(const Offset(6, 0), Offset(6, size.height), stift);
    canvas.drawLine(
      Offset(size.width - 6, 0),
      Offset(size.width - 6, size.height),
      stift,
    );
  }

  @override
  bool shouldRepaint(_AufrufMaler alt) =>
      alt.linie != linie || alt.dicke != dicke;
}

/// Schräge Streifen für Lücken.
class _SchraffurMaler extends CustomPainter {
  final Color farbe;

  const _SchraffurMaler({required this.farbe});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final stift = Paint()
      ..color = farbe
      ..strokeWidth = 2;
    for (var x = -size.height; x < size.width; x += 8) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        stift,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SchraffurMaler alt) => alt.farbe != farbe;
}
