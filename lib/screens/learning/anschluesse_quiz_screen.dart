// lib/screens/learning/anschluesse_quiz_screen.dart
//
// Anschlüsse lernen & erkennen (Schwerpunkt Systemintegration).
// Zwei Modi in einem Screen:
//   1. Lern-Modus: alle Anschlüsse als Karten durchblättern (beschriftete Bilder)
//   2. Quiz: Bild ohne Beschriftung → "Welcher Anschluss ist das?" mit 4 Optionen

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/anschluesse_data.dart';
import '../../services/sound_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

enum _Phase { lernen, quiz, ergebnis }

class AnschluesseQuizScreen extends StatefulWidget {
  const AnschluesseQuizScreen({super.key});

  @override
  State<AnschluesseQuizScreen> createState() => _AnschluesseQuizScreenState();
}

class _AnschluesseQuizScreenState extends State<AnschluesseQuizScreen> {
  _Phase _phase = _Phase.lernen;

  // Lern-Modus
  final PageController _pageController = PageController();
  int _lernIndex = 0;

  // Quiz
  late List<Anschluss> _fragen;
  late List<List<Anschluss>> _optionen;
  int _frageIndex = 0;
  int _richtig = 0;
  Anschluss? _gewaehlt; // null = noch nicht geantwortet

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    final rnd = Random();
    _fragen = List.of(anschluesse)..shuffle(rnd);
    _optionen = _fragen.map((frage) {
      final falsche = List.of(anschluesse)
        ..removeWhere((a) => a.id == frage.id)
        ..shuffle(rnd);
      final opts = [frage, ...falsche.take(3)]..shuffle(rnd);
      return opts;
    }).toList();
    setState(() {
      _phase = _Phase.quiz;
      _frageIndex = 0;
      _richtig = 0;
      _gewaehlt = null;
    });
  }

  void _antworten(Anschluss wahl) {
    if (_gewaehlt != null) return; // schon geantwortet
    final korrekt = wahl.id == _fragen[_frageIndex].id;
    SoundService().playSound(korrekt ? SoundType.correct : SoundType.wrong);
    setState(() {
      _gewaehlt = wahl;
      if (korrekt) _richtig++;
    });
  }

  void _weiter() {
    if (_frageIndex + 1 >= _fragen.length) {
      final prozent = _richtig / _fragen.length;
      SoundService().playSound(
        prozent >= 0.8 ? SoundType.victory : SoundType.click,
      );
      setState(() => _phase = _Phase.ergebnis);
    } else {
      setState(() {
        _frageIndex++;
        _gewaehlt = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Anschlüsse', style: AppTextStyles.h2(text)),
        actions: [
          if (_phase == _Phase.quiz)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_frageIndex + 1}/${_fragen.length}',
                  style: AppTextStyles.monoData(textMid),
                ),
              ),
            ),
        ],
      ),
      body: switch (_phase) {
        _Phase.lernen =>
          _buildLernen(surface, border, text, textMid, textDim),
        _Phase.quiz => _buildQuiz(surface, border, text, textMid, textDim),
        _Phase.ergebnis => _buildErgebnis(surface, border, text, textMid),
      },
    );
  }

  // ─── LERN-MODUS ─────────────────────────────────────────────
  Widget _buildLernen(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Text(
            'Präg dir die Anschlüsse ein — danach fragt dich das Quiz ohne Beschriftung ab.',
            style: AppTextStyles.bodyMedium(textMid),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: anschluesse.length,
            onPageChanged: (i) => setState(() => _lernIndex = i),
            itemBuilder: (context, i) {
              final a = anschluesse[i];
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: border),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(a.labeledAsset, fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        a.erklaerung,
                        style: AppTextStyles.bodySmall(textMid),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Fortschritts-Punkte
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(anschluesse.length, (i) {
            return Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _lernIndex ? AppColors.accent : textDim,
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _startQuiz,
              child: Text(
                'Quiz starten',
                style: AppTextStyles.labelLarge(Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── QUIZ ───────────────────────────────────────────────────
  Widget _buildQuiz(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final frage = _fragen[_frageIndex];
    final opts = _optionen[_frageIndex];
    final beantwortet = _gewaehlt != null;
    final korrekt = beantwortet && _gewaehlt!.id == frage.id;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcher Anschluss ist das?',
            style: AppTextStyles.h1(text),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(frage.quizAsset, fit: BoxFit.contain),
          ),
          const SizedBox(height: 20),
          ...opts.map((o) {
            Color optBorder = border;
            Color optBg = surface;
            IconData? icon;
            Color? iconColor;
            if (beantwortet) {
              if (o.id == frage.id) {
                optBorder = AppColors.success;
                optBg = AppColors.success.withOpacity(0.10);
                icon = Icons.check_circle_rounded;
                iconColor = AppColors.success;
              } else if (o.id == _gewaehlt!.id) {
                optBorder = AppColors.error;
                optBg = AppColors.error.withOpacity(0.10);
                icon = Icons.cancel_rounded;
                iconColor = AppColors.error;
              }
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => _antworten(o),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    color: optBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: optBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(o.name, style: AppTextStyles.labelLarge(text)),
                      ),
                      if (icon != null) Icon(icon, color: iconColor, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (beantwortet) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (korrekt ? AppColors.success : AppColors.info)
                    .withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (korrekt ? AppColors.success : AppColors.info)
                      .withOpacity(0.35),
                ),
              ),
              child: Text(
                frage.erklaerung,
                style: AppTextStyles.bodySmall(text),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _weiter,
              child: Text(
                _frageIndex + 1 >= _fragen.length ? 'Ergebnis' : 'Weiter',
                style: AppTextStyles.labelLarge(Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── ERGEBNIS ───────────────────────────────────────────────
  Widget _buildErgebnis(
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    final prozent = (_richtig / _fragen.length * 100).round();
    final stark = prozent >= 80;
    final ok = prozent >= 50;
    final farbe = stark
        ? AppColors.success
        : ok
            ? AppColors.warning
            : AppColors.error;
    final spruch = stark
        ? 'Stark! Die Anschlüsse sitzen.'
        : ok
            ? 'Solide Basis — noch eine Runde und es sitzt.'
            : 'Noch Luft nach oben. Geh nochmal durch den Lern-Modus.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: farbe.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Text('ERGEBNIS', style: AppTextStyles.monoLabel(farbe)),
                  const SizedBox(height: 12),
                  Text(
                    '$_richtig / ${_fragen.length}',
                    style: AppTextStyles.displayLarge(text),
                  ),
                  const SizedBox(height: 4),
                  Text('$prozent % richtig',
                      style: AppTextStyles.bodyMedium(textMid)),
                  const SizedBox(height: 12),
                  Text(
                    spruch,
                    style: AppTextStyles.bodyMedium(text),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _startQuiz,
              child: Text(
                'Nochmal spielen',
                style: AppTextStyles.labelLarge(Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => setState(() => _phase = _Phase.lernen),
              child: Text(
                'Zurück zum Lern-Modus',
                style: AppTextStyles.labelMedium(textMid),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
