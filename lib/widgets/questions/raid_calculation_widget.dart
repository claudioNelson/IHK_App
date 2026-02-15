import 'package:flutter/material.dart';
import '../../services/sound_service.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';
import '../../services/gemini_service.dart';

class RaidCalculationWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final VoidCallback? onAnswered;

  const RaidCalculationWidget({
    Key? key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
  }) : super(key: key);

  @override
  State<RaidCalculationWidget> createState() => _RaidCalculationWidgetState();
}

class _RaidCalculationWidgetState extends State<RaidCalculationWidget> {
  final TextEditingController scratchPadController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController faultToleranceController =
      TextEditingController();
  final TextEditingController minDrivesController = TextEditingController();

  bool isChecked = false;
  Map<String, bool> fieldResults = {};
  final _soundService = SoundService();
  final _aiService = GeminiService(); // ← NEU
  bool _loadingAiHelp = false; // ← NEU
  String? _aiResponse; // ← NEU

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

    // Reset wenn neue Frage geladen wird
    if (oldWidget.questionText != widget.questionText) {
      scratchPadController.clear();
      capacityController.clear();
      faultToleranceController.clear();
      minDrivesController.clear();

      setState(() {
        isChecked = false;
        fieldResults = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final raidLevel = widget.correctAnswers['raid_level'] ?? 'RAID';
    final drives = widget.correctAnswers['drives'] ?? 0;
    final driveSize = widget.correctAnswers['drive_size'] ?? 0;
    final unit = widget.correctAnswers['unit'] ?? 'TB';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fragetext
            Text(
              widget.questionText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // RAID Info-Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade300, width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.storage, size: 32, color: Colors.blue),
                      const SizedBox(width: 12),
                      Text(
                        raidLevel,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$drives × $driveSize $unit Festplatten',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Scratch Pad
            _buildScratchPad(),
            const SizedBox(height: 24),

            // Input-Felder
            _buildInputField(
              label: 'Nutzbare Kapazität ($unit):',
              controller: capacityController,
              fieldKey: 'usable_capacity',
              icon: Icons.storage,
              color: Colors.green,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Ausfalltoleranz (Anzahl Platten):',
              controller: faultToleranceController,
              fieldKey: 'fault_tolerance',
              icon: Icons.shield,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Mindestanzahl Platten:',
              controller: minDrivesController,
              fieldKey: 'min_drives',
              icon: Icons.settings,
              color: Colors.purple,
            ),

            const SizedBox(height: 24),

            // Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildScratchPad() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.edit_note, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Notizen & Berechnungen',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          TextField(
            controller: scratchPadController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText:
                  'Hier kannst du rechnen...\n\nZ.B. für RAID 5:\n(n-1) × Plattengröße\n= (5-1) × 3TB = 12TB',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String fieldKey,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: isChecked
                ? (fieldResults[fieldKey] == true
                      ? Colors.green[50]
                      : Colors.red[50])
                : Colors.white,
            prefixIcon: Icon(icon, color: color, size: 22),
            hintText: 'Zahl eingeben',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Ada Buttons
        Row(
          children: [
            // Quick-Hint Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _loadingAiHelp ? null : _getAiHint,
                icon: _loadingAiHelp
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.tips_and_updates, size: 20),
                label: Text(
                  _loadingAiHelp ? 'Lädt...' : 'Tipp',
                  style: const TextStyle(fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.blue.shade300),
                  foregroundColor: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Ada Chat Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _openAiChat,
                icon: const Icon(Icons.chat, size: 20),
                label: const Text('Ada Chat', style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Prüfen & Lösung Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _checkAnswers,
                icon: const Icon(Icons.check),
                label: const Text('Prüfen'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _showSolution,
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Lösung'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _checkAnswers() {
    final capacity = capacityController.text.trim();
    final faultTolerance = faultToleranceController.text.trim();
    final minDrives = minDrivesController.text.trim();

    final correctCapacity = widget.correctAnswers['usable_capacity'].toString();
    final correctFaultTolerance = widget.correctAnswers['fault_tolerance']
        .toString();
    final correctMinDrives = widget.correctAnswers['min_drives'].toString();

    setState(() {
      isChecked = true;
      fieldResults = {
        'usable_capacity': capacity == correctCapacity,
        'fault_tolerance': faultTolerance == correctFaultTolerance,
        'min_drives': minDrives == correctMinDrives,
      };
    });

    bool allCorrect = fieldResults.values.every((result) => result == true);

    if (allCorrect) {
      SoundService().playSound(SoundType.correct);
      _showFeedbackDialog(
        title: 'Richtig! 🎉',
        message: 'Alle Berechnungen sind korrekt!',
        isCorrect: true,
      );
    } else {
      SoundService().playSound(SoundType.wrong);
      _showFeedbackDialog(
        title: 'Nicht ganz richtig',
        message: 'Prüfe die rot markierten Felder nochmal.',
        isCorrect: false,
      );
    }
  }

  void _showSolution() {
    setState(() {
      capacityController.text = widget.correctAnswers['usable_capacity']
          .toString();
      faultToleranceController.text = widget.correctAnswers['fault_tolerance']
          .toString();
      minDrivesController.text = widget.correctAnswers['min_drives'].toString();

      isChecked = true;
      fieldResults = {
        'usable_capacity': true,
        'fault_tolerance': true,
        'min_drives': true,
      };
    });

    if (widget.explanation != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lösung & Erklärung'),
          content: SingleChildScrollView(child: Text(widget.explanation!)),
          actions: [
            if (widget.onAnswered != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onAnswered!();
                },
                child: const Text('Nächste Frage'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _getAiHint() async {
    setState(() {
      _loadingAiHelp = true;
      _aiResponse = null;
    });

    try {
      final raidLevel = widget.correctAnswers['raid_level'] ?? 'RAID';
      final currentAttempt =
          '''
${widget.correctAnswers['drives']} × ${widget.correctAnswers['drive_size']} ${widget.correctAnswers['unit'] ?? 'TB'} in $raidLevel

Meine Antworten:
- Nutzbare Kapazität: ${capacityController.text.trim()}
- Ausfalltoleranz: ${faultToleranceController.text.trim()} Platten
- Mindestanzahl: ${minDrivesController.text.trim()} Platten
''';

      final hint = await _aiService.getHint(
        question: widget.questionText,
        topic: 'RAID & Storage',
        currentAttempt: currentAttempt,
      );

      setState(() {
        _aiResponse = hint;
        _loadingAiHelp = false;
      });

      _showAiDialog();
    } catch (e) {
      setState(() {
        _aiResponse = 'Fehler: $e';
        _loadingAiHelp = false;
      });
      _showAiDialog();
    }
  }

  void _showAiDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.psychology, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            const Text('Ada - Tipp'),
          ],
        ),
        content: SingleChildScrollView(child: Text(_aiResponse ?? 'Lädt...')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
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

  void _showFeedbackDialog({
    required String title,
    required String message,
    required bool isCorrect,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            if (widget.explanation != null && isCorrect) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Erklärung:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.explanation!),
            ],
          ],
        ),
        actions: [
          if (isCorrect && widget.onAnswered != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onAnswered!();
              },
              child: const Text('Weiter'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isCorrect ? 'OK' : 'Nochmal versuchen'),
          ),
        ],
      ),
    );
  }
}
