// lib/screens/levels/level_play_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/level_service.dart';
import '../../services/sound_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'level_result_screen.dart';
import 'level_ada_sheet.dart';

class LevelPlayScreen extends StatefulWidget {
  final Level level;
  final String modulName;

  const LevelPlayScreen({
    super.key,
    required this.level,
    required this.modulName,
  });

  @override
  State<LevelPlayScreen> createState() => _LevelPlayScreenState();
}

class _LevelPlayScreenState extends State<LevelPlayScreen> {
  final _service = LevelService();
  final _soundService = SoundService();

  List<Map<String, dynamic>> _fragen = [];
  bool _loading = true;
  int _currentIndex = 0;

  // State der aktuellen Frage
  int? _selectedAnswerId; // für MC / Wahr-Falsch
  bool _hasAnswered = false;
  bool _wasCorrect = false;

  // TextField-Controller für Lückentext + SQL-Tippen
  final TextEditingController _textController = TextEditingController();

  // Tracking
  int _correctCount = 0;
  final List<bool> _results = []; // pro Frage

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _loadFragen();
    // Rebuild bei Text-Änderungen, damit Buttons (en/disabled) korrekt updaten
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Nur rebuild wenn noch nicht beantwortet (sonst unnötig)
    if (!_hasAnswered && mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadFragen() async {
    try {
      final fragen = await _service.getFragenForLevel(
        widget.level.id,
        tier: widget.level.tier,
      );
      if (!mounted) return;
      setState(() {
        _fragen = fragen;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Laden: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  // ─── ANTWORT-LOGIK ──────────────────────────────────────────

  void _checkMCAnswer(int answerId) {
    if (_hasAnswered) return;
    final q = _fragen[_currentIndex];
    final antworten = q['antworten'] as List;
    final selected = antworten.firstWhere((a) => a['id'] == answerId);
    final isCorrect = selected['ist_richtig'] == true;

    setState(() {
      _selectedAnswerId = answerId;
      _hasAnswered = true;
      _wasCorrect = isCorrect;
    });
    _playSound(isCorrect);
  }

  void _checkTextAnswer() {
    if (_hasAnswered) return;
    final q = _fragen[_currentIndex];
    final calcData = q['calculation_data'] as Map<String, dynamic>?;
    if (calcData == null) return;

    final userInput = _textController.text;
    final isCorrect = _validateTextAnswer(calcData, userInput);

    setState(() {
      _hasAnswered = true;
      _wasCorrect = isCorrect;
    });
    _playSound(isCorrect);
  }

  bool _validateTextAnswer(Map<String, dynamic> calcData, String userInput) {
    final type = calcData['type'] as String?;
    final caseSensitive = calcData['case_sensitive'] as bool? ?? false;

    String normalize(String s) {
      var out = s.trim();
      if (!caseSensitive) out = out.toLowerCase();
      // Mehrfache Whitespaces zu einem
      out = out.replaceAll(RegExp(r'\s+'), ' ');
      // Trailing Semikolon entfernen
      out = out.replaceAll(RegExp(r';\s*$'), '');
      return out;
    }

    final normalizedInput = normalize(userInput);

    if (type == 'lueckentext') {
      final answer = calcData['answer'] as String? ?? '';
      return normalize(answer) == normalizedInput;
    }

    if (type == 'sql_tippen') {
      final expected = calcData['expected'] as String? ?? '';
      if (normalize(expected) == normalizedInput) return true;
      final alternatives =
          (calcData['alternatives'] as List?)?.cast<String>() ?? [];
      for (final alt in alternatives) {
        if (normalize(alt) == normalizedInput) return true;
      }
      return false;
    }
    return false;
  }

  void _playSound(bool isCorrect) {
    _soundService.playSound(isCorrect ? SoundType.correct : SoundType.wrong);
  }

  void _onWeiter() {
    _results.add(_wasCorrect);
    if (_wasCorrect) _correctCount++;

    if (_currentIndex < _fragen.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerId = null;
        _hasAnswered = false;
        _wasCorrect = false;
        _textController.clear();
      });
    } else {
      _finishLevel();
    }
  }

  Future<void> _finishLevel() async {
    // Lehr-Karten zählen nicht — Score nur über bewertbare Fragen
    final scorbareFragen = _fragen
        .where((f) => f['frage_typ'] != 'lehr_karte')
        .length;
    final score = scorbareFragen > 0
        ? ((_correctCount / scorbareFragen) * 100).round()
        : 100;

    Map<String, dynamic>? progress;
    try {
      progress = await _service.saveResult(
        levelId: widget.level.id,
        score: score,
        schwelle: widget.level.schwelle,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Speichern: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LevelResultScreen(
          level: widget.level,
          score: score,
          correctCount: _correctCount,
          totalCount: _fragen.length,
          newSterne: progress?['sterne'] as int? ?? 0,
        ),
      ),
    );
  }

  // ─── BUILD ──────────────────────────────────────────────────

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
      body: Column(
        children: [
          // ─── HEADER ───────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _confirmExit(),
                    icon: Icon(Icons.close_rounded, color: text, size: 22),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${widget.level.nummer.toString().padLeft(2, '0')} · ${widget.level.titel}',
                          style: AppTextStyles.labelMedium(textMid),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!_loading && _fragen.isNotEmpty)
                          Text(
                            'FRAGE ${(_currentIndex + 1).toString().padLeft(2, '0')} / ${_fragen.length.toString().padLeft(2, '0')}',
                            style: AppTextStyles.monoSmall(textDim),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Progress-Bar
          if (!_loading && _fragen.isNotEmpty)
            LinearProgressIndicator(
              value: (_currentIndex + (_hasAnswered ? 1 : 0)) / _fragen.length,
              backgroundColor: border,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              minHeight: 2,
            ),

          // ─── CONTENT ──────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : _fragen.isEmpty
                ? Center(
                    child: Text(
                      'Keine Fragen für dieses Level',
                      style: AppTextStyles.h3(textMid),
                    ),
                  )
                : _buildQuestion(surface, border, text, textMid, textDim, bg),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmExit() async {
    final isDark = context.read<ThemeProvider>().isDark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 16, height: 1, color: AppColors.warning),
                  const SizedBox(width: 10),
                  Text(
                    'LEVEL VERLASSEN?',
                    style: AppTextStyles.monoLabel(AppColors.warning),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Dein Fortschritt\ngeht verloren.',
                style: AppTextStyles.instrumentSerif(
                  size: 24,
                  color: text,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Beendet wirklich abbrechen? Es gibt keine Speicherung.',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Weitermachen'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: text,
                        foregroundColor: bg,
                      ),
                      child: const Text('Verlassen'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true && mounted) {
      Navigator.pop(context);
    }
  }

  // ─── FRAGE-RENDERING ───────────────────────────────────────
  Widget _buildQuestion(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final q = _fragen[_currentIndex];
    final frageTyp = q['frage_typ'] as String? ?? 'multiple_choice';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FRAGE-Pill
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                _typeLabel(frageTyp),
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            q['frage'] ?? '',
            style: AppTextStyles.instrumentSerif(
              size: 24,
              color: text,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 28),

          // Antwort-UI je nach Typ
          if (frageTyp == 'lehr_karte')
            _buildLehrKarte(q, surface, border, text, textMid, textDim, bg)
          else if (frageTyp == 'multiple_choice' || frageTyp == 'wahr_falsch')
            _buildMCAnswers(q, surface, border, text, textMid, textDim)
          else if (frageTyp == 'lueckentext')
            _buildLueckentextInput(q, surface, border, text, textMid, textDim)
          else if (frageTyp == 'sql_tippen')
            _buildSqlInput(q, surface, border, text, textMid, textDim)
          else
            Text(
              'Unbekannter Fragetyp: $frageTyp',
              style: AppTextStyles.bodyMedium(textMid),
            ),

          // Erklärung — nur bei echten Fragen, nicht bei Lehr-Karten
          if (_hasAnswered && frageTyp != 'lehr_karte') ...[
            const SizedBox(height: 12),
            _buildExplanation(q, surface, border, text, textMid),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _onWeiter,
                icon: Icon(
                  _currentIndex < _fragen.length - 1
                      ? Icons.arrow_forward_rounded
                      : Icons.flag_rounded,
                  size: 18,
                ),
                label: Text(
                  _currentIndex < _fragen.length - 1
                      ? 'Weiter'
                      : 'Level abschließen',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: text,
                  foregroundColor: bg,
                  elevation: 0,
                  textStyle: AppTextStyles.labelLarge(bg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _typeLabel(String typ) {
    switch (typ) {
      case 'lueckentext':
        return 'LÜCKENTEXT';
      case 'sql_tippen':
        return 'SQL SCHREIBEN';
      case 'wahr_falsch':
        return 'WAHR ODER FALSCH';
      case 'lehr_karte':
        return 'KONZEPT';
      default:
        return 'FRAGE';
    }
  }

  // ── MC + Wahr/Falsch
  Widget _buildMCAnswers(
    Map<String, dynamic> q,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final antworten = q['antworten'] as List? ?? [];
    return Column(
      children: antworten.asMap().entries.map((entry) {
        final index = entry.key;
        final antwort = entry.value;
        final answerId = antwort['id'] as int;
        final isSelected = _selectedAnswerId == answerId;
        final isCorrect = antwort['ist_richtig'] == true;
        final showResult = _hasAnswered && isSelected;
        final showCorrect = _hasAnswered && !isSelected && isCorrect;

        Color borderColor = border;
        Color bgColor = surface;
        Color letterColor = textMid;
        Color letterBg = border;

        if (showResult) {
          if (isCorrect) {
            borderColor = AppColors.success;
            bgColor = AppColors.success.withOpacity(0.05);
            letterColor = Colors.white;
            letterBg = AppColors.success;
          } else {
            borderColor = AppColors.error;
            bgColor = AppColors.error.withOpacity(0.05);
            letterColor = Colors.white;
            letterBg = AppColors.error;
          }
        } else if (showCorrect) {
          borderColor = AppColors.success.withOpacity(0.5);
          letterColor = AppColors.success;
          letterBg = AppColors.success.withOpacity(0.15);
        } else if (isSelected) {
          borderColor = AppColors.accent;
          letterColor = Colors.white;
          letterBg = AppColors.accent;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: _hasAnswered ? null : () => _checkMCAnswer(answerId),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: letterBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: showResult
                          ? Icon(
                              isCorrect
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              color: letterColor,
                              size: 16,
                            )
                          : showCorrect
                          ? Icon(
                              Icons.check_rounded,
                              color: letterColor,
                              size: 16,
                            )
                          : Text(
                              String.fromCharCode(65 + index),
                              style: AppTextStyles.mono(
                                size: 12,
                                color: letterColor,
                                weight: FontWeight.w700,
                                letterSpacing: 0,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        antwort['text'] ?? '',
                        style: AppTextStyles.interTight(
                          size: 15,
                          weight: isSelected || showCorrect
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: text,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Lückentext
  Widget _buildLueckentextInput(
    Map<String, dynamic> q,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final calcData = q['calculation_data'] as Map<String, dynamic>?;
    final template = calcData?['template'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template anzeigen
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
          ),
          child: Text(
            template,
            style: AppTextStyles.mono(
              size: 14,
              color: text,
              weight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('DEINE ANTWORT', style: AppTextStyles.monoLabel(textDim)),
        const SizedBox(height: 8),
        TextField(
          controller: _textController,
          enabled: !_hasAnswered,
          autofocus: true,
          style: AppTextStyles.mono(
            size: 15,
            color: text,
            weight: FontWeight.w500,
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            hintText: 'Hier tippen...',
            hintStyle: AppTextStyles.bodyMedium(textDim),
          ),
          onSubmitted: (_) => _checkTextAnswer(),
        ),
        const SizedBox(height: 12),
        if (!_hasAnswered)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _textController.text.trim().isEmpty
                  ? null
                  : _checkTextAnswer,
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Prüfen'),
            ),
          ),
      ],
    );
  }

  // ── SQL-Tippen (größeres Mono-TextField)
  Widget _buildSqlInput(
    Map<String, dynamic> q,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DEINE SQL-ABFRAGE', style: AppTextStyles.monoLabel(textDim)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hasAnswered
                  ? (_wasCorrect ? AppColors.success : AppColors.error)
                  : border,
            ),
          ),
          child: TextField(
            controller: _textController,
            enabled: !_hasAnswered,
            autofocus: true,
            maxLines: 4,
            minLines: 3,
            textCapitalization: TextCapitalization.none,
            style: AppTextStyles.mono(
              size: 14,
              color: text,
              weight: FontWeight.w500,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              hintText: 'SELECT ...',
              hintStyle: AppTextStyles.mono(
                size: 14,
                color: textDim,
                weight: FontWeight.w400,
                letterSpacing: 0,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tipp: Groß-/Kleinschreibung egal, Whitespace egal.',
          style: AppTextStyles.bodySmall(textDim),
        ),
        const SizedBox(height: 12),
        if (!_hasAnswered)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _textController.text.trim().isEmpty
                  ? null
                  : _checkTextAnswer,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text('Ausführen'),
            ),
          ),
      ],
    );
  }

  // ── Erklärung
  Widget _buildExplanation(
    Map<String, dynamic> q,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    String? erklaerung;

    // 1. MC: Erklärung der ausgewählten Antwort
    if (_selectedAnswerId != null) {
      final antworten = q['antworten'] as List? ?? [];
      final selected = antworten.firstWhere(
        (a) => a['id'] == _selectedAnswerId,
        orElse: () => null,
      );
      if (selected != null) {
        erklaerung = selected['erklaerung'] as String?;
      }
    }

    // 2. Fallback: allgemeine Erklärung der Frage
    if (erklaerung == null || erklaerung.trim().isEmpty) {
      erklaerung = q['erklaerung'] as String?;
    }

    final accentColor = _wasCorrect ? AppColors.success : AppColors.warning;

    if (erklaerung == null || erklaerung.trim().isEmpty) {
      // Auch ohne Erklärungstext: kurzes Status-Badge
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: accentColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              _wasCorrect
                  ? Icons.check_circle_outline_rounded
                  : Icons.close_rounded,
              color: accentColor,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              _wasCorrect ? 'RICHTIG' : 'LEIDER FALSCH',
              style: AppTextStyles.monoLabel(accentColor),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [accentColor, accentColor, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _wasCorrect
                    ? Icons.check_circle_outline_rounded
                    : Icons.lightbulb_outline_rounded,
                color: accentColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _wasCorrect ? 'RICHTIG' : 'ERKLÄRUNG',
                style: AppTextStyles.monoLabel(accentColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(erklaerung, style: AppTextStyles.bodyMedium(textMid)),
        ],
      ),
    );
  }

  // ── Lehr-Karte
  Widget _buildLehrKarte(
    Map<String, dynamic> q,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final inhalt = q['erklaerung'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inhalt-Box
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.015, 0.015, 1.0],
              colors: [
                AppColors.accentCyan,
                AppColors.accentCyan,
                surface,
                surface,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppColors.accentCyan,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LERN-MOMENT',
                    style: AppTextStyles.monoLabel(AppColors.accentCyan),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(inhalt, style: AppTextStyles.bodyLarge(text)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Ada-Buttons (Frag Ada / Anders erklärt)
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () => LevelAdaSheet.show(
                    context,
                    contextText: inhalt,
                    topic: '${widget.modulName} · ${widget.level.titel}',
                  ),
                  icon: const Icon(Icons.psychology_rounded, size: 16),
                  label: const Text('Frag Ada'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () => LevelAdaSheet.show(
                    context,
                    contextText: inhalt,
                    topic: '${widget.modulName} · ${widget.level.titel}',
                    initialPrompt:
                        'Erkläre mir das nochmal mit anderen Worten und einem '
                        'einfachen Beispiel — als ob ich es gerade zum ersten '
                        'Mal höre.',
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Anders erklärt'),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Verstanden-Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _onLehrKarteWeiter,
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Verstanden'),
            style: ElevatedButton.styleFrom(
              backgroundColor: text,
              foregroundColor: bg,
              elevation: 0,
              textStyle: AppTextStyles.labelLarge(bg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Lehr-Karten zählen NICHT in den Score — direkt zur nächsten Frage
  void _onLehrKarteWeiter() {
    if (_currentIndex < _fragen.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerId = null;
        _hasAnswered = false;
        _wasCorrect = false;
        _textController.clear();
      });
    } else {
      _finishLevel();
    }
  }
}
