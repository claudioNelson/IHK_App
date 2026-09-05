import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import '../services/sound_service.dart';

class BadgeCelebrationDialog extends StatefulWidget {
  final List<String> badgeIds;
  final List<Map<String, dynamic>> badgeDetails;

  const BadgeCelebrationDialog({
    super.key,
    required this.badgeIds,
    required this.badgeDetails,
  });

  @override
  State<BadgeCelebrationDialog> createState() => _BadgeCelebrationDialogState();
}

class _BadgeCelebrationDialogState extends State<BadgeCelebrationDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    // Fanfare zum Konfetti, egal aus welchem Screen der Dialog kommt.
    SoundService().playSound(SoundType.victory);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dialog folgt dem App-Theme, statt im Dark Mode grell weiss zu sein.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hintergrund = isDark ? const Color(0xFF12121C) : Colors.white;
    final textFarbe = isDark ? const Color(0xFFF5F5F7) : Colors.black87;
    final nebentext = isDark ? const Color(0xFFA0A0B0) : Colors.grey.shade700;

    final badges = widget.badgeDetails;
    final mehrere = badges.length > 1;
    // Bei mehreren Badges (z. B. Nachholen alter Erfolge nach dem ersten
    // Ergebnis-Screen) kompakte Zeilen statt grosser Karten, sonst laeuft
    // der Dialog auf kleinen Displays unten ueber.
    final maxHoehe = MediaQuery.of(context).size.height * 0.7;

    final karteDeko = BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [
                Colors.amber.withValues(alpha: 0.18),
                Colors.amber.withValues(alpha: 0.06),
              ]
            : [Colors.amber.shade100, Colors.amber.shade50],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.amber, width: mehrere ? 1.5 : 2),
      boxShadow: [
        BoxShadow(
          color: Colors.amber.withValues(alpha: 0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

    Widget grosseKarte(Map<String, dynamic> badge) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: karteDeko,
          child: Column(
            children: [
              Text(badge['icon'] ?? '🏆', style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              Text(
                badge['name'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textFarbe,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                badge['description'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: nebentext),
              ),
            ],
          ),
        );

    Widget kompakteZeile(Map<String, dynamic> badge) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: karteDeko,
          child: Row(
            children: [
              Text(badge['icon'] ?? '🏆', style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge['name'] ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textFarbe,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      badge['description'] ?? '',
                      style: TextStyle(fontSize: 12.5, color: nebentext),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

    return Stack(
      children: [
        // Dialog
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: hintergrund,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // Titel
              Text(
                mehrere ? '🎉 ${badges.length} neue Badges!' : '🎉 Neues Badge!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),

              // Badges anzeigen (scrollbar, falls es doch mal viele sind)
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHoehe),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: badges
                          .map((b) => mehrere ? kompakteZeile(b) : grosseKarte(b))
                          .toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Super! 🎉',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Konfetti links
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -0.5,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 30,
            minBlastForce: 10,
            gravity: 0.2,
            colors: const [
              Colors.amber,
              Colors.orange,
              Colors.yellow,
              Colors.red,
              Colors.purple,
              Colors.blue,
            ],
          ),
        ),
        
        // Konfetti rechts
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -2.5,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 30,
            minBlastForce: 10,
            gravity: 0.2,
            colors: const [
              Colors.amber,
              Colors.orange,
              Colors.yellow,
              Colors.red,
              Colors.purple,
              Colors.blue,
            ],
          ),
        ),
      ],
    );
  }
}