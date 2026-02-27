import 'package:flutter/material.dart';
import '../../services/sound_service.dart';
import '../../services/gemini_service.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';
import '../../services/progress_service.dart';

class NetworkCalculationWidget extends StatefulWidget {
  final String questionText;
  final Map<String, String> correctAnswers;
  final String? explanation;
  final VoidCallback? onAnswered;
  final int? questionId;
  final int? moduleId;

  const NetworkCalculationWidget({
    super.key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
    this.questionId,
    this.moduleId,
  });

  @override
  State<NetworkCalculationWidget> createState() =>
      _NetworkCalculationWidgetState();
}

class _NetworkCalculationWidgetState extends State<NetworkCalculationWidget> {
  // Scratch Pad Controller
  final TextEditingController scratchPadController = TextEditingController();

  // IP Address Controllers (Netzadresse)
  final List<TextEditingController> networkControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  // IP Address Controllers (Broadcast)
  final List<TextEditingController> broadcastControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  // Subnet Mask Controllers
  final List<TextEditingController> subnetControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  // Usable Hosts Controller
  final TextEditingController hostsController = TextEditingController();

  bool isChecked = false;
  Map<String, bool> fieldResults = {};
  final _soundService = SoundService();
  final _aiService = GeminiService();
  final _progressService = ProgressService();
  bool _loadingAiHelp = false;
  String? _aiResponse;

  @override
  void initState() {
    super.initState();
    _soundService.init();
  }

  @override
  void didUpdateWidget(NetworkCalculationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset wenn neue Frage geladen wird
    if (oldWidget.questionText != widget.questionText) {
      scratchPadController.clear();
      for (var controller in networkControllers) { controller.clear(); }
      for (var controller in broadcastControllers) { controller.clear(); }
      for (var controller in subnetControllers) { controller.clear(); }
      hostsController.clear();

      setState(() {
        isChecked = false;
        fieldResults = {};
      });
    }
  }

  @override
  void dispose() {
    scratchPadController.dispose();
    for (var controller in networkControllers) { controller.dispose(); }
    for (var controller in broadcastControllers) { controller.dispose(); }
    for (var controller in subnetControllers) { controller.dispose(); }
    hostsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

            // Scratch Pad
            _buildScratchPad(),
            const SizedBox(height: 24),

            // Netzadresse Input
            _buildIPAddressField(
              label: 'Netzadresse:',
              controllers: networkControllers,
              fieldKey: 'network_address',
            ),
            const SizedBox(height: 16),

            // Broadcast Input
            _buildIPAddressField(
              label: 'Broadcast-Adresse:',
              controllers: broadcastControllers,
              fieldKey: 'broadcast_address',
            ),
            const SizedBox(height: 16),

            // Nutzbare Hosts
            _buildHostsField(),
            const SizedBox(height: 16),

            // Subnetzmaske
            _buildIPAddressField(
              label: 'Subnetzmaske (dezimal):',
              controllers: subnetControllers,
              fieldKey: 'subnet_mask',
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
                  'Hier kannst du deine Berechnungen notieren...\n\nZ.B. Subnetzgröße berechnen, IP-Bereiche aufschreiben, etc.',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildIPAddressField({
    required String label,
    required List<TextEditingController> controllers,
    required String fieldKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
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
                  decoration: InputDecoration(
                    counterText: '',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: isChecked
                        ? (fieldResults[fieldKey] == true
                              ? Colors.green[50]
                              : Colors.red[50])
                        : Colors.white,
                  ),
                ),
              ),
              if (i < 3)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildHostsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutzbare Hosts:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: hostsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: isChecked
                ? (fieldResults['usable_hosts'] == true
                      ? Colors.green[50]
                      : Colors.red[50])
                : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // KI-Tutor Buttons in einer Reihe
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
            // Chat Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _openAiChat,
                icon: const Icon(Icons.chat, size: 20),
                label: const Text(
                  'Ada Chat', // ← GEÄNDERT
                  style: TextStyle(fontSize: 13),
                ),
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _checkAnswers() async {
    debugPrint('═══════════════════════════════'); // ← NEU - Auffällig!
    debugPrint('🔵 _checkAnswers GESTARTET!'); // ← NEU
    debugPrint('🔵 questionId: ${widget.questionId}'); // ← NEU
    debugPrint('🔵 moduleId: ${widget.moduleId}'); // ← NEU
    debugPrint('═══════════════════════════════'); // ← NEU
    // IP-Adressen zusammenbauen
    String enteredNetwork = networkControllers
        .map((c) => c.text.trim())
        .join('.');
    String enteredBroadcast = broadcastControllers
        .map((c) => c.text.trim())
        .join('.');
    String enteredSubnet = subnetControllers
        .map((c) => c.text.trim())
        .join('.');
    String enteredHosts = hostsController.text.trim();

    // Vergleichen
    bool networkCorrect =
        enteredNetwork == widget.correctAnswers['network_address'];
    bool broadcastCorrect =
        enteredBroadcast == widget.correctAnswers['broadcast_address'];
    bool subnetCorrect = enteredSubnet == widget.correctAnswers['subnet_mask'];
    bool hostsCorrect = enteredHosts == widget.correctAnswers['usable_hosts'];

    setState(() {
      isChecked = true;
      fieldResults = {
        'network_address': networkCorrect,
        'broadcast_address': broadcastCorrect,
        'subnet_mask': subnetCorrect,
        'usable_hosts': hostsCorrect,
      };
    });

    // Feedback + Sounds
    bool allCorrect =
        networkCorrect && broadcastCorrect && subnetCorrect && hostsCorrect;

    if (allCorrect) {
      _soundService.playSound(SoundType.correct);

      // Progress speichern
      if (widget.questionId != null && widget.moduleId != null) {
        await _progressService.saveKernthemaAnswer(
          modulId: widget.moduleId!,
          frageId: widget.questionId!,
          isCorrect: true,
        );
      }

      _showFeedbackDialog(
        title: 'Richtig! 🎉',
        message: 'Alle Antworten sind korrekt!',
        isCorrect: true,
      );
    } else {
      _soundService.playSound(SoundType.wrong);

      // Progress speichern
      if (widget.questionId != null && widget.moduleId != null) {
        await _progressService.saveKernthemaAnswer(
          modulId: widget.moduleId!,
          frageId: widget.questionId!,
          isCorrect: false,
        );
      }

      _showFeedbackDialog(
        title: 'Nicht ganz richtig',
        message: 'Prüfe die rot markierten Felder nochmal.',
        isCorrect: false,
      );
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isCorrect ? 'OK' : 'Verstanden'),
          ),
          if (widget.onAnswered != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onAnswered!();
              },
              child: Text(isCorrect ? 'Weiter' : 'Nächste Frage'),
            ),
        ],
      ),
    );
  }

  void _showSolution() {
    // Felder mit richtigen Antworten füllen
    final network = widget.correctAnswers['network_address']?.split('.') ?? [];
    final broadcast =
        widget.correctAnswers['broadcast_address']?.split('.') ?? [];
    final subnet = widget.correctAnswers['subnet_mask']?.split('.') ?? [];

    setState(() {
      // Netzadresse
      for (int i = 0; i < 4 && i < network.length; i++) {
        networkControllers[i].text = network[i];
      }
      // Broadcast
      for (int i = 0; i < 4 && i < broadcast.length; i++) {
        broadcastControllers[i].text = broadcast[i];
      }
      // Subnet
      for (int i = 0; i < 4 && i < subnet.length; i++) {
        subnetControllers[i].text = subnet[i];
      }
      // Hosts
      hostsController.text = widget.correctAnswers['usable_hosts'] ?? '';

      // Alle als richtig markieren
      isChecked = true;
      fieldResults = {
        'network_address': true,
        'broadcast_address': true,
        'subnet_mask': true,
        'usable_hosts': true,
      };
    });

    // Erklärung anzeigen
    if (widget.explanation != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lösung & Erklärung'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSolutionRow(
                  'Netzadresse',
                  widget.correctAnswers['network_address'],
                ),
                _buildSolutionRow(
                  'Broadcast',
                  widget.correctAnswers['broadcast_address'],
                ),
                _buildSolutionRow(
                  'Nutzbare Hosts',
                  widget.correctAnswers['usable_hosts'],
                ),
                _buildSolutionRow(
                  'Subnetzmaske',
                  widget.correctAnswers['subnet_mask'],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Erklärung:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(widget.explanation!),
              ],
            ),
          ),
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

  Future<void> _getAiHint() async {
    setState(() {
      _loadingAiHelp = true;
      _aiResponse = null;
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
            const Text('KI-Tutor'),
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

  Widget _buildSolutionRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '—',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
