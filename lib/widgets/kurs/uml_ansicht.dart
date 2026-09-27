// lib/widgets/kurs/uml_ansicht.dart
//
// Zeichnet ein UML-Diagramm aus dem Datenformat in lib/models/uml.dart.
//
// Optik wie der Web-Kurs (web/app/uml-kurs/uml.css): Linien in Textfarbe,
// Flächen in Kartenfarbe, Klassenköpfe leicht abgesetzt, Namen fett,
// Attribute, Methoden und Beschriftungen in JetBrains Mono.
//
// Größe: Die Zeichenfläche wird auf die verfügbare Breite verkleinert, aber
// nie unter 75 % (sonst wird die Schrift zu klein). Ist sie dann noch zu
// breit, lässt sie sich seitlich schieben. Antippen öffnet das Diagramm im
// Vollbild, dort kann man mit zwei Fingern zoomen und verschieben.
//
// Die Farben kommen aus dem umgebenden Theme (kursTheme), dadurch passt es
// in Hell und Dunkel.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/uml.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'struktogramm_ansicht.dart' show SeitlichSchiebbar;

class UmlAnsicht extends StatelessWidget {
  final UmlDiagramm diagramm;
  final String? unterschrift;

  const UmlAnsicht({super.key, required this.diagramm, this.unterschrift});

  static const double _minMassstab = 0.75;

  @override
  Widget build(BuildContext context) {
    final stil = _UmlStil.von(context);
    final d = diagramm;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, grenzen) {
              final verfuegbar = grenzen.maxWidth.isFinite
                  ? grenzen.maxWidth
                  : d.breite;
              var massstab = math.min(1.0, verfuegbar / d.breite);
              if (massstab < _minMassstab) massstab = _minMassstab;
              final bild = Semantics(
                label: d.beschreibung,
                image: true,
                child: GestureDetector(
                  onTap: () => _vollbild(context, stil),
                  child: Container(
                    decoration: BoxDecoration(
                      color: stil.flaeche,
                      border: Border.all(color: stil.rahmen),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: CustomPaint(
                      size: Size(d.breite * massstab, d.hoehe * massstab),
                      painter: _UmlMaler(d, stil, massstab),
                    ),
                  ),
                ),
              );
              if (d.breite * massstab + 18 > verfuegbar) {
                return SeitlichSchiebbar(child: bild);
              }
              return bild;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Icon(Icons.zoom_in, size: 15, color: stil.textDim),
                const SizedBox(width: 4),
                Text(
                  'Zum Vergrößern antippen',
                  style: AppTextStyles.interTight(size: 12, color: stil.textDim),
                ),
              ],
            ),
          ),
          if (unterschrift != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                unterschrift!,
                style: AppTextStyles.interTight(
                  size: 13.5,
                  color: stil.textMid,
                  height: 1.45,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _vollbild(BuildContext context, _UmlStil stil) {
    final theme = Theme.of(context);
    final d = diagramm;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) => Theme(
        data: theme,
        child: Dialog.fullscreen(
          backgroundColor: stil.flaeche,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  boundaryMargin: const EdgeInsets.all(200),
                  constrained: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
                    child: CustomPaint(
                      size: Size(d.breite, d.hoehe),
                      painter: _UmlMaler(d, stil, 1),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: SafeArea(
                  child: IconButton.filledTonal(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Schließen',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Stil
// ───────────────────────────────────────────────────────────────────────────

class _UmlStil {
  final Color linie;
  final Color flaeche;
  final Color kopf;
  final Color rahmen;
  final Color text;
  final Color textMid;
  final Color textDim;
  final Color notiz;

  const _UmlStil({
    required this.linie,
    required this.flaeche,
    required this.kopf,
    required this.rahmen,
    required this.text,
    required this.textMid,
    required this.textDim,
    required this.notiz,
  });

  factory _UmlStil.von(BuildContext context) {
    final dunkel = Theme.of(context).brightness == Brightness.dark;
    return _UmlStil(
      linie: dunkel ? AppColors.darkText : AppColors.lightText,
      flaeche: dunkel ? AppColors.darkSurface : AppColors.lightSurface,
      kopf: dunkel ? AppColors.darkBgMuted : AppColors.lightBgMuted,
      rahmen: (dunkel ? AppColors.darkTextDim : AppColors.lightTextDim)
          .withValues(alpha: 0.35),
      text: dunkel ? AppColors.darkText : AppColors.lightText,
      textMid: dunkel ? AppColors.darkTextMid : AppColors.lightTextMid,
      textDim: dunkel ? AppColors.darkTextDim : AppColors.lightTextDim,
      notiz: AppColors.accent.withValues(alpha: dunkel ? 0.14 : 0.10),
    );
  }

  TextStyle get name => AppTextStyles.interTight(
        size: 13.5,
        weight: FontWeight.w700,
        color: text,
      );

  TextStyle get normal => AppTextStyles.interTight(
        size: 12.5,
        weight: FontWeight.w500,
        color: text,
      );

  TextStyle get klein => AppTextStyles.interTight(
        size: 11.5,
        weight: FontWeight.w500,
        color: textMid,
      );

  TextStyle get code => AppTextStyles.mono(
        size: 11.5,
        weight: FontWeight.w400,
        color: text,
        letterSpacing: 0,
      );
}

// ───────────────────────────────────────────────────────────────────────────
// Maler
// ───────────────────────────────────────────────────────────────────────────

class _UmlMaler extends CustomPainter {
  final UmlDiagramm d;
  final _UmlStil s;
  final double massstab;

  _UmlMaler(this.d, this.s, this.massstab);

  late final Paint _strich = Paint()
    ..color = s.linie
    ..strokeWidth = 1.4
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  late final Paint _voll = Paint()
    ..color = s.linie
    ..style = PaintingStyle.fill;

  late final Paint _flaeche = Paint()
    ..color = s.flaeche
    ..style = PaintingStyle.fill;

  late final Paint _kopf = Paint()
    ..color = s.kopf
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(massstab);
    for (final e in d.elemente) {
      switch (e) {
        case UmlKlasse k:
          _klasse(canvas, k);
        case UmlKante k:
          _kante(canvas, k);
        case UmlAkteur a:
          _akteur(canvas, a);
        case UmlUseCase u:
          _useCase(canvas, u);
        case UmlRahmen r:
          _rahmen(canvas, r);
        case UmlStart st:
          canvas.drawCircle(Offset(st.x, st.y), 9, _voll);
        case UmlEnde en:
          canvas.drawCircle(Offset(en.x, en.y), 11, _flaeche);
          canvas.drawCircle(Offset(en.x, en.y), 11, _strich);
          canvas.drawCircle(Offset(en.x, en.y), 6.5, _voll);
        case UmlAblaufende ae:
          final m = Offset(ae.x, ae.y);
          canvas.drawCircle(m, 10, _flaeche);
          canvas.drawCircle(m, 10, _strich);
          const r = 7.0;
          canvas.drawLine(m + const Offset(-r, -r) * 0.72,
              m + const Offset(r, r) * 0.72, _strich);
          canvas.drawLine(m + const Offset(-r, r) * 0.72,
              m + const Offset(r, -r) * 0.72, _strich);
        case UmlAktion a:
          _aktion(canvas, a);
        case UmlRaute r:
          final p = Path()
            ..moveTo(r.x, r.y - 16)
            ..lineTo(r.x + 16, r.y)
            ..lineTo(r.x, r.y + 16)
            ..lineTo(r.x - 16, r.y)
            ..close();
          canvas.drawPath(p, _flaeche);
          canvas.drawPath(p, _strich);
        case UmlBalken b:
          canvas.drawRRect(
            RRect.fromLTRBR(b.x1, b.y - 3, b.x2, b.y + 3,
                const Radius.circular(1.5)),
            _voll,
          );
        case UmlPfeil p:
          _pfeil(canvas, p);
        case UmlLebenslinie l:
          _lebenslinie(canvas, l);
        case UmlAktivierung a:
          final r = Rect.fromLTRB(a.x - 6, a.von, a.x + 6, a.bis);
          canvas.drawRect(r, _kopf);
          canvas.drawRect(r, _strich);
        case UmlText t:
          _textElement(canvas, t);
        case UmlNotiz n:
          _notiz(canvas, n);
      }
    }
    canvas.restore();
  }

  // ── Text ─────────────────────────────────────────────────────────────

  TextPainter _tp(String text, TextStyle stil,
      {double maxBreite = double.infinity, TextAlign align = TextAlign.left}) {
    return TextPainter(
      text: TextSpan(text: text, style: stil),
      textDirection: TextDirection.ltr,
      textAlign: align,
      textScaler: TextScaler.noScaling,
    )..layout(maxWidth: maxBreite);
  }

  /// Zeichnet Text. [ausrichtung]: -1 links ab x, 0 zentriert um x, 1 rechts
  /// bis x. [y] ist die Oberkante.
  Size _text(Canvas c, String text, TextStyle stil, double x, double y,
      {int ausrichtung = -1, double maxBreite = double.infinity}) {
    final align = switch (ausrichtung) {
      0 => TextAlign.center,
      1 => TextAlign.right,
      _ => TextAlign.left,
    };
    final tp = _tp(text, stil, maxBreite: maxBreite, align: align);
    final dx = switch (ausrichtung) {
      0 => x - tp.width / 2,
      1 => x - tp.width,
      _ => x,
    };
    tp.paint(c, Offset(dx, y));
    return tp.size;
  }

  // ── Linien ───────────────────────────────────────────────────────────

  Path _zug(List<Offset> punkte) {
    final p = Path()..moveTo(punkte.first.dx, punkte.first.dy);
    for (final q in punkte.skip(1)) {
      p.lineTo(q.dx, q.dy);
    }
    return p;
  }

  void _gestrichelt(Canvas c, List<Offset> punkte) {
    const strich = 6.0;
    const luecke = 4.0;
    for (var i = 0; i < punkte.length - 1; i++) {
      final a = punkte[i];
      final b = punkte[i + 1];
      final laenge = (b - a).distance;
      if (laenge == 0) continue;
      final u = (b - a) / laenge;
      var pos = 0.0;
      while (pos < laenge) {
        final ende = math.min(pos + strich, laenge);
        c.drawLine(a + u * pos, a + u * ende, _strich);
        pos += strich + luecke;
      }
    }
  }

  void _linie(Canvas c, List<Offset> punkte, bool gestrichelt) {
    if (gestrichelt) {
      _gestrichelt(c, punkte);
    } else {
      c.drawPath(_zug(punkte), _strich);
    }
  }

  Offset _einheit(Offset a, Offset b) {
    final l = (b - a).distance;
    return l == 0 ? Offset.zero : (b - a) / l;
  }

  /// Offene Pfeilspitze an [ende], aus Richtung [von].
  void _spitzeOffen(Canvas c, Offset ende, Offset von) {
    final u = _einheit(von, ende);
    final n = Offset(-u.dy, u.dx);
    final p = Path()
      ..moveTo((ende - u * 11 + n * 6).dx, (ende - u * 11 + n * 6).dy)
      ..lineTo(ende.dx, ende.dy)
      ..lineTo((ende - u * 11 - n * 6).dx, (ende - u * 11 - n * 6).dy);
    c.drawPath(p, _strich);
  }

  /// Gefüllte Pfeilspitze an [ende].
  void _spitzeVoll(Canvas c, Offset ende, Offset von) {
    final u = _einheit(von, ende);
    final n = Offset(-u.dy, u.dx);
    final a = ende - u * 12 + n * 5;
    final b = ende - u * 12 - n * 5;
    final p = Path()
      ..moveTo(ende.dx, ende.dy)
      ..lineTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..close();
    c.drawPath(p, _voll);
  }

  // ── Klasse ───────────────────────────────────────────────────────────

  void _klasse(Canvas c, UmlKlasse k) {
    final h = k.hoehe;
    final aussen = Rect.fromLTWH(k.x, k.y, k.b, h);
    c.drawRect(aussen, _flaeche);
    c.drawRect(Rect.fromLTWH(k.x, k.y, k.b, k.kopfHoehe), _kopf);

    final mitte = k.x + k.b / 2;
    var nameY = k.y + 7;
    final zusatz = k.stereotyp ?? (k.abstrakt ? '{abstract}' : null);
    if (zusatz != null) {
      _text(c, zusatz, s.klein, mitte, k.y + 5, ausrichtung: 0);
      nameY = k.y + 21;
    }
    var nameStil = s.name;
    if (k.abstrakt) nameStil = nameStil.copyWith(fontStyle: FontStyle.italic);
    if (k.objekt) {
      nameStil = nameStil.copyWith(
        decoration: TextDecoration.underline,
        decorationColor: s.text,
      );
    }
    _text(c, k.name, nameStil, mitte, nameY, ausrichtung: 0);

    var top = k.y + k.kopfHoehe;
    for (final fach in [k.attribute, k.methoden]) {
      if (fach == null) continue;
      c.drawLine(Offset(k.x, top), Offset(k.x + k.b, top), _strich);
      for (var i = 0; i < fach.length; i++) {
        _text(c, fach[i], s.code, k.x + 10, top + 6 + i * UmlKlasse.zeile);
      }
      top += UmlKlasse.fachHoehe(fach.length);
    }
    c.drawRect(aussen, _strich);
  }

  // ── Kante ────────────────────────────────────────────────────────────

  void _kante(Canvas c, UmlKante k) {
    final pts = k.punkte;
    final start = pts.first;
    final ende = pts.last;
    final gestrichelt = k.art == UmlKantenArt.abhaengigkeit ||
        k.art == UmlKantenArt.realisierung;

    // Linie so kürzen, dass sie nicht in Raute oder Dreieck hineinläuft.
    final linie = List<Offset>.of(pts);
    final d = _einheit(start, pts[1]);
    final u = _einheit(pts[pts.length - 2], ende);
    if (k.art == UmlKantenArt.aggregation ||
        k.art == UmlKantenArt.komposition) {
      linie[0] = start + d * 20;
    }
    if (k.art == UmlKantenArt.vererbung ||
        k.art == UmlKantenArt.realisierung) {
      linie[linie.length - 1] = ende - u * 15;
    }
    _linie(c, linie, gestrichelt);

    // Raute am Start
    var startAbstand = 8.0;
    if (k.art == UmlKantenArt.aggregation ||
        k.art == UmlKantenArt.komposition) {
      final nd = Offset(-d.dy, d.dx);
      final raute = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo((start + d * 10 + nd * 6).dx, (start + d * 10 + nd * 6).dy)
        ..lineTo((start + d * 20).dx, (start + d * 20).dy)
        ..lineTo((start + d * 10 - nd * 6).dx, (start + d * 10 - nd * 6).dy)
        ..close();
      c.drawPath(
          raute, k.art == UmlKantenArt.komposition ? _voll : _flaeche);
      c.drawPath(raute, _strich);
      startAbstand = 24;
    }

    // Spitze oder Dreieck am Ende
    var endAbstand = 8.0;
    if (k.art == UmlKantenArt.gerichtet ||
        k.art == UmlKantenArt.abhaengigkeit) {
      _spitzeOffen(c, ende, pts[pts.length - 2]);
      endAbstand = 16;
    } else if (k.art == UmlKantenArt.vererbung ||
        k.art == UmlKantenArt.realisierung) {
      final nu = Offset(-u.dy, u.dx);
      final dreieck = Path()
        ..moveTo(ende.dx, ende.dy)
        ..lineTo((ende - u * 15 + nu * 8).dx, (ende - u * 15 + nu * 8).dy)
        ..lineTo((ende - u * 15 - nu * 8).dx, (ende - u * 15 - nu * 8).dy)
        ..close();
      c.drawPath(dreieck, _flaeche);
      c.drawPath(dreieck, _strich);
      endAbstand = 20;
    }

    _endLabels(c, start, pts[1], k.von, k.rolleVon, startAbstand);
    _endLabels(c, ende, pts[pts.length - 2], k.nach, k.rolleNach, endAbstand);

    if (k.name != null) {
      final i = (pts.length - 1) ~/ 2;
      final a = pts[i];
      final b = pts[i + 1];
      final m = (a + b) / 2;
      final waagerecht = (a.dy - b.dy).abs() < 0.5;
      if (waagerecht) {
        final tp = _tp(k.name!, s.klein);
        tp.paint(c, Offset(m.dx - tp.width / 2, m.dy - tp.height - 3));
      } else {
        final tp = _tp(k.name!, s.klein);
        tp.paint(c, Offset(m.dx + 7, m.dy - tp.height / 2));
      }
    }
  }

  /// Multiplizität und Rolle an einem Kantenende, wie im Web-Kurs:
  /// waagerecht Multiplizität oben, Rolle unten; senkrecht Multiplizität
  /// rechts, Rolle links.
  void _endLabels(Canvas c, Offset ende, Offset nachbar, String? mult,
      String? rolle, double abstand) {
    if (mult == null && rolle == null) return;
    final r = _einheit(ende, nachbar);
    final waagerecht = r.dx.abs() > r.dy.abs();
    if (waagerecht) {
      final x = ende.dx + r.dx * abstand;
      final ausrichtung = r.dx > 0 ? -1 : 1;
      if (mult != null) {
        final tp = _tp(mult, s.code);
        _text(c, mult, s.code, x, ende.dy - tp.height - 2,
            ausrichtung: ausrichtung);
      }
      if (rolle != null) {
        _text(c, rolle, s.klein, x, ende.dy + 3, ausrichtung: ausrichtung);
      }
    } else {
      final nachUnten = r.dy > 0;
      final tpM = mult == null ? null : _tp(mult, s.code);
      final hoch = tpM?.height ?? 14;
      final y = nachUnten
          ? ende.dy + abstand - 4
          : ende.dy - abstand - hoch + 4;
      if (mult != null) _text(c, mult, s.code, ende.dx + 6, y);
      if (rolle != null) {
        _text(c, rolle, s.klein, ende.dx - 6, y, ausrichtung: 1);
      }
    }
  }

  // ── Use-Case-Elemente ────────────────────────────────────────────────

  void _akteur(Canvas c, UmlAkteur a) {
    final x = a.x;
    final y = a.y;
    c.drawCircle(Offset(x, y + 8), 8, _flaeche);
    c.drawCircle(Offset(x, y + 8), 8, _strich);
    c.drawLine(Offset(x, y + 16), Offset(x, y + 34), _strich);
    c.drawLine(Offset(x - 14, y + 22), Offset(x + 14, y + 22), _strich);
    c.drawLine(Offset(x, y + 34), Offset(x - 12, y + 50), _strich);
    c.drawLine(Offset(x, y + 34), Offset(x + 12, y + 50), _strich);
    _text(c, a.name, s.normal, x, y + 54, ausrichtung: 0, maxBreite: 120);
  }

  void _useCase(Canvas c, UmlUseCase u) {
    final r = Rect.fromCenter(
        center: Offset(u.cx, u.cy), width: u.rx * 2, height: u.ry * 2);
    c.drawOval(r, _flaeche);
    c.drawOval(r, _strich);
    final tp = _tp(u.text, s.normal,
        maxBreite: u.rx * 2 - 20, align: TextAlign.center);
    tp.paint(c, Offset(u.cx - tp.width / 2, u.cy - tp.height / 2));
  }

  void _rahmen(Canvas c, UmlRahmen r) {
    final rect = Rect.fromLTWH(r.x, r.y, r.b, r.h);
    c.drawRect(rect, _strich);
    if (r.titel.isEmpty) return;
    if (r.fragment) {
      final tp = _tp(r.titel, s.name.copyWith(fontSize: 12.5));
      final b = tp.width + 16;
      const h = 22.0;
      final p = Path()
        ..moveTo(r.x, r.y)
        ..lineTo(r.x + b, r.y)
        ..lineTo(r.x + b, r.y + h - 7)
        ..lineTo(r.x + b - 7, r.y + h)
        ..lineTo(r.x, r.y + h)
        ..close();
      c.drawPath(p, _flaeche);
      c.drawPath(p, _strich);
      tp.paint(c, Offset(r.x + 8, r.y + (h - tp.height) / 2));
    } else {
      _text(c, r.titel, s.name, r.x + 10, r.y + 7);
    }
  }

  // ── Aktivität und Zustand ────────────────────────────────────────────

  void _aktion(Canvas c, UmlAktion a) {
    final rr = RRect.fromRectAndRadius(
      Rect.fromLTWH(a.x, a.y, a.b, a.h),
      Radius.circular(a.zustand ? 12 : 10),
    );
    c.drawRRect(rr, _flaeche);
    c.drawRRect(rr, _strich);
    if (a.zustand && a.zusatz.isNotEmpty) {
      _text(c, a.text, s.name.copyWith(fontSize: 12.5), a.x + a.b / 2,
          a.y + 6, ausrichtung: 0);
      final trenn = a.y + 28;
      c.drawLine(Offset(a.x, trenn), Offset(a.x + a.b, trenn), _strich);
      for (var i = 0; i < a.zusatz.length; i++) {
        _text(c, a.zusatz[i], s.code, a.x + 8, trenn + 5 + i * 16);
      }
      return;
    }
    final stil = a.zustand ? s.name.copyWith(fontSize: 12.5) : s.normal;
    final tp = _tp(a.text, stil, maxBreite: a.b - 12, align: TextAlign.center);
    tp.paint(c,
        Offset(a.x + (a.b - tp.width) / 2, a.y + (a.h - tp.height) / 2));
  }

  void _pfeil(Canvas c, UmlPfeil p) {
    final pts = p.punkte;
    _linie(c, pts, p.gestrichelt);
    final ende = pts.last;
    final vor = pts[pts.length - 2];
    switch (p.spitze) {
      case UmlSpitze.offen:
        _spitzeOffen(c, ende, vor);
      case UmlSpitze.voll:
        _spitzeVoll(c, ende, vor);
      case UmlSpitze.keine:
        break;
    }
    if (p.text == null) return;
    final i = math.max(0, math.min(p.textSegment, pts.length - 2));
    final a = pts[i];
    final b = pts[i + 1];
    final m = (a + b) / 2;
    final tp = _tp(p.text!, s.code);
    final waagerecht = (a.dy - b.dy).abs() < 0.5;
    double x;
    double y;
    if (waagerecht) {
      y = m.dy - tp.height - 3;
      x = switch (p.textAusrichtung) {
        -1 => m.dx - tp.width,
        1 => m.dx,
        _ => m.dx - tp.width / 2,
      };
    } else {
      y = m.dy - tp.height / 2;
      x = p.textAusrichtung == -1 ? m.dx - 8 - tp.width : m.dx + 8;
    }
    // Hintergrund, damit Text über Linien lesbar bleibt
    final pos = Offset(x, y) + p.textVersatz;
    c.drawRect(
      Rect.fromLTWH(pos.dx - 2, pos.dy, tp.width + 4, tp.height),
      _flaeche,
    );
    tp.paint(c, pos);
  }

  // ── Sequenzdiagramm ──────────────────────────────────────────────────

  void _lebenslinie(Canvas c, UmlLebenslinie l) {
    _gestrichelt(c, [Offset(l.x, l.y + 36), Offset(l.x, l.bis)]);
    final r = Rect.fromLTWH(l.x - l.b / 2, l.y, l.b, 36);
    c.drawRect(r, _flaeche);
    c.drawRect(r, _strich);
    final stil = s.name.copyWith(
      fontSize: 12.5,
      decoration: TextDecoration.underline,
      decorationColor: s.text,
    );
    final tp = _tp(l.name, stil);
    tp.paint(c, Offset(l.x - tp.width / 2, l.y + (36 - tp.height) / 2));
  }

  // ── Allgemein ────────────────────────────────────────────────────────

  void _textElement(Canvas c, UmlText t) {
    var stil = t.code ? s.code : s.normal;
    if (t.kursiv) stil = stil.copyWith(fontStyle: FontStyle.italic);
    if (t.fett) stil = stil.copyWith(fontWeight: FontWeight.w700);
    _text(c, t.text, stil, t.x, t.y, ausrichtung: t.ausrichtung);
  }

  void _notiz(Canvas c, UmlNotiz n) {
    final tp = _tp(n.text, s.code, maxBreite: n.b - 16);
    final h = tp.height + 14;
    const e = 10.0;
    if (n.anker != null) {
      final von = n.ankerVon ?? Offset(n.x, n.y + h / 2);
      _gestrichelt(c, [von, n.anker!]);
    }
    final p = Path()
      ..moveTo(n.x, n.y)
      ..lineTo(n.x + n.b - e, n.y)
      ..lineTo(n.x + n.b, n.y + e)
      ..lineTo(n.x + n.b, n.y + h)
      ..lineTo(n.x, n.y + h)
      ..close();
    c.drawPath(p, _flaeche);
    c.drawPath(p, Paint()..color = s.notiz);
    c.drawPath(p, _strich);
    c.drawPath(
      Path()
        ..moveTo(n.x + n.b - e, n.y)
        ..lineTo(n.x + n.b - e, n.y + e)
        ..lineTo(n.x + n.b, n.y + e),
      _strich,
    );
    tp.paint(c, Offset(n.x + 8, n.y + 7));
  }

  @override
  bool shouldRepaint(_UmlMaler oldDelegate) =>
      oldDelegate.d != d ||
      oldDelegate.massstab != massstab ||
      oldDelegate.s.linie != s.linie;
}
