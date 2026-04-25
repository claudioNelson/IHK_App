import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/sound_service.dart';
import '../../services/gemini_service.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';
import '../../services/progress_service.dart';
import '../../services/flashcard_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class NetworkCalculationWidget extends StatefulWidget {
  final String questionText;
  final Map<String, String> correctAnswers;
  final String? explanation;
  final void Function(bool isCorrect)? onAnswered;
  final int? questionId;
  final int? moduleId;
  final String? moduleName;

  const NetworkCalculationWidget({
    super.key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
    this.questionId,
    this.moduleId,
    this.moduleName,
  });

  @override
  State<NetworkCalculationWidget> createState() =>
      _NetworkCalculationWidgetState();
}

class _NetworkCalculationWidgetState extends State<NetworkCalculationWidget> {
  final scratchPadController = TextEditingController();
  final List<TextEditingController> networkControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> broadcastControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> subnetControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final hostsController = TextEditingController();

  bool isChecked = false;
  Map<String, bool> fieldResults = {};
  final _soundService = SoundService();
  final _aiService = GeminiService();
  final _progressService = ProgressService();
  final _flashcardService = FlashcardService();
  bool _loadingHint = false;
  String? _hintText;

  @override
  void initState() {
    super.initState();
    _soundService.init();
  }

  @override
  void didUpdateWidget(NetworkCalculationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionText != widget.questionText) {
      scratchPadController.clear();
      for (var c in networkControllers) c.clear();
      for (var c in broadcastControllers) c.clear();
      for (var c in subnetControllers) c.clear();
      hostsController.clear();
      setState(() {
        isChecked = false;
        fieldResults = {};
        _hintText = null;
      });
    }
  }

  @override
  void dispose() {
    scratchPadController.dispose();
    for (var c in networkControllers) c.dispose();
    for (var c in broadcastControllers) c.dispose();
    for (var c in subnetControllers) c.dispose();
    hostsController.dispose();
    super.dispose();
  }

  Future<void> _checkAnswers() async {
    String network = networkControllers.map((c) => c.text.trim()).join('.');
    String broadcast = broadcastControllers.map((c) => c.text.trim()).join('.');
    String subnet = subnetControllers.map((c) => c.text.trim()).join('.');
    String hosts = hostsController.text.trim();

    bool networkCorrect = network == widget.correctAnswers['network_address'];
    bool broadcastCorrect =
        broadcast == widget.correctAnswers['broadcast_address'];
    bool subnetCorrect = subnet == widget.correctAnswers['subnet_mask'];
    bool hostsCorrect = hosts == widget.correctAnswers['usable_hosts'];

    setState(() {
      isChecked = true;
      fieldResults = {
        'network_address': networkCorrect,
        'broadcast_address': broadcastCorrect,
        'subnet_mask': subnetCorrect,
        'usable_hosts': hostsCorrect,
      };
    });

    bool allCorrect =
        networkCorrect && broadcastCorrect && subnetCorrect && hostsCorrect;

    if (allCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
    }

    if (widget.questionId != null && widget.moduleId != null) {
      await _progressService.saveKernthemaAnswer(
        modulId: widget.moduleId!,
        frageId: widget.questionId!,
        isCorrect: allCorrect,
      );

      if (!allCorrect) {
        final richtigeAntwort = widget.correctAnswers.entries
            .map((e) => '${e.key}: ${e.value}')
            .join('\n');
        await _flashcardService.createFromWrongAnswer(
          frageId: widget.questionId!,
          frageText: widget.questionText,
          richtigeAntwort: richtigeAntwort,
          modulName: widget.moduleName ?? 'Kernthemen',
          themaName: null,
        );
      }
    }
  }

  Future<void> _getHint() async {
    setState(() {
      _loadingHint = true;
      _hintText = null;
    });
    try {
      final currentAttempt =
          '''
Netzadresse: ${networkControllers.map((c) => c.text.trim()).join('.')}
Broadcast: ${broadcastControllers.map((c) => c.text.trim()).join('.')}
Subnetzmaske: ${subnetControllers.map((c) => c.text.trim()).join('.')}
Nutzbare Hosts: ${hostsController.text.trim()}
''';
      final hint = await _aiService.getHint(
        question: widget.questionText,
        topic: 'IP-Subnetting',
        currentAttempt: currentAttempt,
      );
      setState(() {
        _hintText = hint;
        _loadingHint = false;
      });
    } catch (e) {
      setState(() {
        _hintText = 'Fehler: $e';
        _loadingHint = false;
      });
    }
  }

  void _openAiChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiTutorChatScreen(
          currentQuestion: widget.questionText,
          topic: 'IP-Subnetting',
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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'SUBNETTING',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Frage
          Text(
            widget.questionText,
            style: AppTextStyles.instrumentSerif(
              size: 22,
              color: text,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 20),

          // Scratch Pad
          _buildScratchPad(surface, border, text, textMid, textDim),
          const SizedBox(height: 20),

          // Fields
          _buildIPField(
            'NETZADRESSE',
            networkControllers,
            'network_address',
            surface,
            border,
            text,
            textMid,
            textDim,
          ),
          const SizedBox(height: 16),
          _buildIPField(
            'BROADCAST',
            broadcastControllers,
            'broadcast_address',
            surface,
            border,
            text,
            textMid,
            textDim,
          ),
          const SizedBox(height: 16),
          _buildHostsField(surface, border, text, textMid, textDim),
          const SizedBox(height: 16),
          _buildIPField(
            'SUBNETZMASKE',
            subnetControllers,
            'subnet_mask',
            surface,
            border,
            text,
            textMid,
            textDim,
          ),

          const SizedBox(height: 20),

          // Check Button
          if (!isChecked)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _checkAnswers,
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('Prüfen'),
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

          // Hint
          if (_hintText != null) ...[
            const SizedBox(height: 16),
            _buildHintBox(surface, textMid),
          ],

          // Feedback
          if (isChecked) ...[
            const SizedBox(height: 16),
            _buildFeedback(surface, text, textMid, bg),
          ],

          // Ada Buttons
          const SizedBox(height: 16),
          _buildAdaButtons(textMid, border),
        ],
      ),
    );
  }

  Widget _buildScratchPad(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Icon(Icons.edit_note_rounded, size: 14, color: textMid),
                const SizedBox(width: 6),
                Text(
                  'NOTIZEN & BERECHNUNGEN',
                  style: AppTextStyles.monoSmall(textMid),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          TextField(
            controller: scratchPadController,
            maxLines: 5,
            style: AppTextStyles.mono(
              size: 13,
              color: text,
              weight: FontWeight.w500,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              hintText: 'Zwischenrechnungen, IP-Bereiche...',
              hintStyle: AppTextStyles.mono(
                size: 12,
                color: textDim,
                weight: FontWeight.w400,
                letterSpacing: 0,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIPField(
    String label,
    List<TextEditingController> controllers,
    String fieldKey,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    Color fieldColor = surface;
    Color fieldBorder = border;
    if (isChecked) {
      fieldColor = fieldResults[fieldKey] == true
          ? AppColors.success.withOpacity(0.08)
          : AppColors.error.withOpacity(0.08);
      fieldBorder = fieldResults[fieldKey] == true
          ? AppColors.success.withOpacity(0.5)
          : AppColors.error.withOpacity(0.5);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.monoSmall(textDim)),
        const SizedBox(height: 8),
        Row(
          children: [
            for (int i = 0; i < 4; i++) ...[
              Expanded(
                child: TextField(
                  controller: controllers[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  style: AppTextStyles.mono(
                    size: 14,
                    color: text,
                    weight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: fieldBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: fieldBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.accent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              if (i < 3)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '.',
                    style: AppTextStyles.mono(
                      size: 18,
                      color: textMid,
                      weight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildHostsField(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    Color fieldColor = surface;
    Color fieldBorder = border;
    if (isChecked) {
      fieldColor = fieldResults['usable_hosts'] == true
          ? AppColors.success.withOpacity(0.08)
          : AppColors.error.withOpacity(0.08);
      fieldBorder = fieldResults['usable_hosts'] == true
          ? AppColors.success.withOpacity(0.5)
          : AppColors.error.withOpacity(0.5);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NUTZBARE HOSTS', style: AppTextStyles.monoSmall(textDim)),
        const SizedBox(height: 8),
        TextField(
          controller: hostsController,
          keyboardType: TextInputType.number,
          style: AppTextStyles.mono(
            size: 14,
            color: text,
            weight: FontWeight.w600,
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            hintText: 'z.B. 254',
            hintStyle: AppTextStyles.mono(
              size: 13,
              color: textDim,
              weight: FontWeight.w400,
              letterSpacing: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.accent),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }

  Widget _buildHintBox(Color surface, Color textMid) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.accent, AppColors.accent, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_outlined,
                color: AppColors.accent,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'TIPP VON ADA',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(_hintText!, style: AppTextStyles.bodyMedium(textMid)),
        ],
      ),
    );
  }

  Widget _buildFeedback(Color surface, Color text, Color textMid, Color bg) {
    final allCorrect = fieldResults.values.every((v) => v == true);
    final accentColor = allCorrect ? AppColors.success : AppColors.warning;

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
                allCorrect
                    ? Icons.check_circle_outline_rounded
                    : Icons.lightbulb_outline_rounded,
                color: accentColor,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                allCorrect ? 'ALLES RICHTIG' : 'PRÜFE DEINE EINGABEN',
                style: AppTextStyles.monoLabel(accentColor),
              ),
            ],
          ),
          if (widget.explanation != null) ...[
            const SizedBox(height: 10),
            Text(widget.explanation!, style: AppTextStyles.bodyMedium(textMid)),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: widget.onAnswered != null
                  ? () => widget.onAnswered!(allCorrect)
                  : null,
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('Weiter'),
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
    );
  }

  Widget _buildAdaButtons(Color textMid, Color border) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _loadingHint ? null : _getHint,
              icon: _loadingHint
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    )
                  : Icon(
                      Icons.tips_and_updates_outlined,
                      size: 14,
                      color: AppColors.accent,
                    ),
              label: Text(
                _loadingHint ? 'Lädt...' : 'Tipp',
                style: AppTextStyles.mono(
                  size: 11,
                  color: AppColors.accent,
                  weight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.accent.withOpacity(0.3)),
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
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _openAiChat,
              icon: Icon(Icons.auto_awesome_outlined, size: 14, color: textMid),
              label: Text(
                'Ada Chat',
                style: AppTextStyles.mono(
                  size: 11,
                  color: textMid,
                  weight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
