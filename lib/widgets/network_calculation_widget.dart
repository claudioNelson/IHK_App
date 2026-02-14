// lib/widgets/questions/network_calculation_widget.dart

import 'package:flutter/material.dart';
import '../../services/sound_service.dart';

class NetworkCalculationWidget extends StatefulWidget {
  final String questionText;
  final Map<String, String> correctAnswers;
  final VoidCallback? onAnswered;

  final String? explanation;

  const NetworkCalculationWidget({
    Key? key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
  }) : super(key: key);

  @override
  State<NetworkCalculationWidget> createState() =>
      _NetworkCalculationWidgetState();
}

class _NetworkCalculationWidgetState extends State<NetworkCalculationWidget> {
  // Scratch Pad Controller
  final TextEditingController scratchPadController = TextEditingController();
  final _soundService = SoundService();

  @override
  void initState() {
    super.initState();
    _soundService.init();
  }

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

  @override
  void dispose() {
    scratchPadController.dispose();
    for (var controller in networkControllers) controller.dispose();
    for (var controller in broadcastControllers) controller.dispose();
    for (var controller in subnetControllers) controller.dispose();
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),

            // Scratch Pad
            _buildScratchPad(),
            SizedBox(height: 24),

            // Netzadresse Input
            _buildIPAddressField(
              label: 'Netzadresse:',
              controllers: networkControllers,
              fieldKey: 'network_address',
            ),
            SizedBox(height: 16),

            // Broadcast Input
            _buildIPAddressField(
              label: 'Broadcast-Adresse:',
              controllers: broadcastControllers,
              fieldKey: 'broadcast_address',
            ),
            SizedBox(height: 16),

            // Nutzbare Hosts
            _buildHostsField(),
            SizedBox(height: 16),

            // Subnetzmaske
            _buildIPAddressField(
              label: 'Subnetzmaske (dezimal):',
              controllers: subnetControllers,
              fieldKey: 'subnet_mask',
            ),
            SizedBox(height: 24),

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
                SizedBox(width: 8),
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
          Divider(height: 1),
          TextField(
            controller: scratchPadController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText:
                  'Hier kannst du deine Berechnungen notieren...\n\nBeispiel:\n/26 = 64er Netz\n50 ÷ 64 = 0 Rest 50',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
            style: TextStyle(fontFamily: 'monospace', fontSize: 14),
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
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
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
                    border: OutlineInputBorder(),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
        Text('Nutzbare Hosts:', style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        TextField(
          controller: hostsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
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
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _checkAnswers,
            icon: Icon(Icons.check),
            label: Text('Prüfen'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showSolution,
            icon: Icon(Icons.lightbulb_outline),
            label: Text('Lösung'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _checkAnswers() {
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

    // Feedback
    bool allCorrect =
        networkCorrect && broadcastCorrect && subnetCorrect && hostsCorrect;

    if (allCorrect) {
      SoundService().playSound(SoundType.correct);
      _showFeedbackDialog(
        title: 'Richtig! 🎉',
        message: 'Alle Antworten sind korrekt!',
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

  void _showSolution() {
    // TODO: Implementierung in Schritt 3.3
  }
}
