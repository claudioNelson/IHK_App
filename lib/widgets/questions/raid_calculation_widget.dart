import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/sound_service.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';
import '../../services/gemini_service.dart';
import '../../services/progress_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class RaidCalculationWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final void Function(bool)? onAnswered;
  final int? questionId;
  final int? moduleId;

  const RaidCalculationWidget({
    super.key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
    this.questionId,
    this.moduleId,
  });

  @override
  State<RaidCalculationWidget> createState() => _RaidCalculationWidgetState();
}

class _RaidCalculationWidgetState extends State<RaidCalculationWidget> {
  final scratchPadController = TextEditingController();
  final capacityController = TextEditingController();
  final faultToleranceController = TextEditingController();
  final minDrivesController = TextEditingController();

  bool isChecked = false;
  Map<String, bool> fieldResults = {};
  final _soundService = SoundService();
  final _aiService = GeminiService();
  final _progressService = ProgressService();
  bool _loadingHint = false;
  String? _hintText;

  @override
  void initState() {
    super.initState();
    _soundService.init();
  }

  @override
  void dispose() {
    scratchPadController.dispose();
    capacityController.dispose();
    faultToleranceController.dispose();
    minDrivesController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RaidCalculationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionText != widget.questionText) {
      scratchPadController.clear();
      capacityController.clear();
      faultToleranceController.clear();
      minDrivesController.clear();
      setState(() {
        isChecked = false;
        fieldResults = {};
        _hintText = null;
      });
    }
  }

  Future<void> _checkAnswers() async {
    final capacity = capacityController.text.trim();
    final faultTolerance = faultToleranceController.text.trim();
    final minDrives = minDrivesController.text.trim();

    final correctCapacity = widget.correctAnswers['usable_capacity'].toString();
    final correctFT = widget.correctAnswers['fault_tolerance'].toString();
    final correctMin = widget.correctAnswers['min_drives'].toString();

    setState(() {
      isChecked = true;
      fieldResults = {
        'usable_capacity': capacity == correctCapacity,
        'fault_tolerance': faultTolerance == correctFT,
        'min_drives': minDrives == correctMin,
      };
    });

    bool allCorrect = fieldResults.values.every((v) => v == true);

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
    }
  }

  Future<void> _getHint() async {
    setState(() {
      _loadingHint = true;
      _hintText = null;
    });
    try {
      final raidLevel = widget.correctAnswers['raid_level'] ?? 'RAID';
      final hint = await _aiService.getHint(
        question: widget.questionText,
        topic: 'RAID & Storage',
        currentAttempt:
            '''
${widget.correctAnswers['drives']} × ${widget.correctAnswers['drive_size']} ${widget.correctAnswers['unit'] ?? 'TB'} in $raidLevel
Kapazität: ${capacityController.text.trim()}
Ausfalltoleranz: ${faultToleranceController.text.trim()}
Mindestanzahl: ${minDrivesController.text.trim()}
''',
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
          topic: 'RAID & Storage',
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

    final raidLevel = widget.correctAnswers['raid_level'] ?? 'RAID';
    final drives = widget.correctAnswers['drives'] ?? 0;
    final driveSize = widget.correctAnswers['drive_size'] ?? 0;
    final unit = widget.correctAnswers['unit'] ?? 'TB';

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
                'RAID & STORAGE',
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

          // RAID Info Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KONFIGURATION',
                        style: AppTextStyles.monoLabel(AppColors.accentCyan),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        raidLevel,
                        style: AppTextStyles.instrumentSerif(
                          size: 32,
                          color: text,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$drives × $driveSize $unit Festplatten',
                        style: AppTextStyles.mono(
                          size: 12,
                          color: textMid,
                          weight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.storage_rounded,
                  color: AppColors.accentCyan,
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Scratch Pad
          _buildScratchPad(surface, border, text, textMid, textDim),
          const SizedBox(height: 20),

          // Fields
          _buildField(
            'NUTZBARE KAPAZITÄT',
            '($unit)',
            capacityController,
            'usable_capacity',
            surface,
            border,
            text,
            textMid,
            textDim,
          ),
          const SizedBox(height: 14),
          _buildField(
            'AUSFALLTOLERANZ',
            '(Platten)',
            faultToleranceController,
            'fault_tolerance',
            surface,
            border,
            text,
            textMid,
            textDim,
          ),
          const SizedBox(height: 14),
          _buildField(
            'MINDESTANZAHL PLATTEN',
            '',
            minDrivesController,
            'min_drives',
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
                Text('NOTIZEN', style: AppTextStyles.monoSmall(textMid)),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          TextField(
            controller: scratchPadController,
            maxLines: 4,
            style: AppTextStyles.mono(
              size: 13,
              color: text,
              weight: FontWeight.w500,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              hintText: 'z.B. RAID 5: (n-1) × Plattengröße = ...',
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

  Widget _buildField(
    String label,
    String suffix,
    TextEditingController controller,
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
        Row(
          children: [
            Text(label, style: AppTextStyles.monoSmall(textDim)),
            if (suffix.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(suffix, style: AppTextStyles.monoSmall(textDim)),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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
            hintText: 'Zahl',
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
                allCorrect ? 'ALLES RICHTIG' : 'ERKLÄRUNG',
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
