// lib/screens/learning/flashcard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/flashcard_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  final _service = FlashcardService();
  List<Map<String, dynamic>> _cards = [];
  int _currentIndex = 0;
  bool _loading = true;
  bool _showAnswer = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _loadCards();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    final cards = await _service.getFlashcards();
    if (!mounted) return;
    setState(() {
      _cards = cards..shuffle();
      _loading = false;
    });
  }

  void _flipCard() {
    if (_showAnswer) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _showAnswer = !_showAnswer);
  }

  Future<void> _markKnown() async {
    await _service.markAsKnown(_cards[_currentIndex]['id']);
    setState(() => _cards.removeAt(_currentIndex));
    if (_cards.isEmpty) {
      _showDoneDialog();
      return;
    }
    if (_currentIndex >= _cards.length) {
      setState(() => _currentIndex = _cards.length - 1);
    }
    setState(() => _showAnswer = false);
    _flipController.reverse(from: 1);
  }

  Future<void> _markRepeat() async {
    await _service.markForRepeat(_cards[_currentIndex]['id']);
    // Karte ans Ende verschieben
    final card = _cards.removeAt(_currentIndex);
    _cards.add(card);
    if (_currentIndex >= _cards.length) {
      setState(() => _currentIndex = 0);
    }
    setState(() => _showAnswer = false);
    _flipController.reverse(from: 1);
  }

  void _showDoneDialog() {
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    showDialog(
      context: context,
      barrierDismissible: false,
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
                  Container(width: 16, height: 1, color: AppColors.success),
                  const SizedBox(width: 10),
                  Text(
                    'ABGESCHLOSSEN',
                    style: AppTextStyles.monoLabel(AppColors.success),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Alle Karten geschafft.',
                style: AppTextStyles.instrumentSerif(
                  size: 28,
                  color: text,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Du hast alle Flashcards durchgearbeitet. Gut gemacht.',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textMid,
                        side: BorderSide(color: border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Zurück'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentIndex = 0;
                          _showAnswer = false;
                          _loading = true;
                        });
                        _loadCards();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: text,
                        foregroundColor: bg,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: AppTextStyles.labelLarge(bg),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Nochmal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
      body: Column(
        children: [
          _buildAppBar(text, textMid, textDim),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : _cards.isEmpty
                ? _buildEmpty(text, textMid, textDim, bg, surface, border)
                : _buildContent(
                    bg,
                    surface,
                    border,
                    text,
                    textMid,
                    textDim,
                    isDark,
                  ),
          ),
        ],
      ),
    );
  }

  // ─── APPBAR ─────────────────────────────
  Widget _buildAppBar(Color text, Color textMid, Color textDim) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_rounded, color: text, size: 22),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flashcards',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (_cards.isNotEmpty)
                    Text(
                      'KARTE ${(_currentIndex + 1).toString().padLeft(2, '0')} / ${_cards.length.toString().padLeft(2, '0')}',
                      style: AppTextStyles.monoSmall(textDim),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── EMPTY ──────────────────────────────
  Widget _buildEmpty(
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
    Color surface,
    Color border,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ALLES SAUBER',
                style: AppTextStyles.mono(
                  size: 11,
                  color: AppColors.success,
                  weight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Flashcards.',
              style: AppTextStyles.instrumentSerif(
                size: 32,
                color: text,
                letterSpacing: -1.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Falsch beantwortete Fragen werden automatisch als Flashcards gespeichert.',
              style: AppTextStyles.bodyMedium(textMid),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('Jetzt lernen'),
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
        ),
      ),
    );
  }

  // ─── CONTENT ────────────────────────────
  Widget _buildContent(
    Color bg,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    bool isDark,
  ) {
    final card = _cards[_currentIndex];

    return Column(
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _cards.length,
          backgroundColor: border,
          valueColor: const AlwaysStoppedAnimation(AppColors.accent),
          minHeight: 2,
        ),

        // Modul/Thema Tags
        if (card['modul_name'] != null || card['thema_name'] != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Wrap(
              spacing: 6,
              children: [
                if (card['modul_name'] != null)
                  _buildTag(card['modul_name'], AppColors.accent),
                if (card['thema_name'] != null)
                  _buildTag(card['thema_name'], textMid),
              ],
            ),
          ),

        // Flip Card
        Expanded(
          child: GestureDetector(
            onTap: _flipCard,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final isBack = _flipAnimation.value > 0.5;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(3.14159 * _flipAnimation.value),
                    child: isBack
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(3.14159),
                            child: _buildCardBack(
                              card,
                              surface,
                              border,
                              text,
                              textMid,
                            ),
                          )
                        : _buildCardFront(card, surface, border, text, textMid),
                  );
                },
              ),
            ),
          ),
        ),

        // Hint Text
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            _showAnswer ? 'WUSSTEST DU ES?' : 'TIPPE ZUM UMDREHEN',
            style: AppTextStyles.monoSmall(textDim),
          ),
        ),

        // Action Bar
        Container(
          decoration: BoxDecoration(
            color: surface,
            border: Border(top: BorderSide(color: border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _showAnswer
                  ? Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: _markRepeat,
                              icon: const Icon(Icons.replay_rounded, size: 16),
                              label: const Text('Nochmal'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.warning,
                                side: BorderSide(
                                  color: AppColors.warning.withOpacity(0.5),
                                ),
                                textStyle: AppTextStyles.labelLarge(
                                  AppColors.warning,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: _markKnown,
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Gewusst'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                textStyle: AppTextStyles.labelLarge(
                                  Colors.white,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _flipCard,
                        icon: const Icon(Icons.autorenew_rounded, size: 18),
                        label: const Text('Antwort zeigen'),
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
            ),
          ),
        ),
      ],
    );
  }

  // ─── CARD FRONT ─────────────────────────
  Widget _buildCardFront(
    Map<String, dynamic> card,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.accent, AppColors.accent, surface, surface],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text('FRAGE', style: AppTextStyles.monoLabel(AppColors.accent)),
            ],
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                card['frage_text'] ?? '',
                style: AppTextStyles.instrumentSerif(
                  size: 26,
                  color: text,
                  letterSpacing: -0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CARD BACK ──────────────────────────
  Widget _buildCardBack(
    Map<String, dynamic> card,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.4)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.success, AppColors.success, surface, surface],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.success),
              const SizedBox(width: 10),
              Text(
                'ANTWORT',
                style: AppTextStyles.monoLabel(AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                card['antwort_text'] ?? '',
                style: AppTextStyles.instrumentSerif(
                  size: 26,
                  color: text,
                  letterSpacing: -0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── TAG ────────────────────────────────
  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.mono(
          size: 10,
          color: color,
          weight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
