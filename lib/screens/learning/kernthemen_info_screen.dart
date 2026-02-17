import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';

class KernthemenInfoScreen extends StatefulWidget {
  const KernthemenInfoScreen({super.key});

  @override
  State<KernthemenInfoScreen> createState() => _KernthemenInfoScreenState();
}

class _KernthemenInfoScreenState extends State<KernthemenInfoScreen> {
  bool _nichtMehrAnzeigen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade700, Colors.teal.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kernthemen',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Deine Prüfungsvorbereitung',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Wichtigkeit
              _buildInfoCard(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.orange,
                title: 'Warum sind Kernthemen so wichtig?',
                content:
                    'Die IHK-Abschlussprüfung besteht aus mehreren Teilen – und in fast jedem davon tauchen diese Kernthemen auf. Themen wie IP-Subnetting, RAID-Systeme, das OSI-Modell oder IT-Sicherheit sind keine Zufallsfragen: Sie gehören zum absoluten Pflichtprogramm jedes IT-Fachinformatikers.\n\nWer diese Themen sicher beherrscht, legt ein starkes Fundament für die gesamte Prüfung.',
              ),

              const SizedBox(height: 16),

              // Was dich erwartet
              _buildInfoCard(
                icon: Icons.quiz,
                iconColor: Colors.blue,
                title: 'Was dich hier erwartet',
                content:
                    'Jedes Kernthema enthält eine Mischung aus verschiedenen Aufgabentypen – genau wie in der echten Prüfung:\n\n• Berechnungsaufgaben (z. B. Subnetzmasken, RAID-Kapazitäten)\n• Multiple-Choice-Fragen zum schnellen Wiederholen\n• Freitext-Aufgaben, bei denen du Konzepte erklärst\n\nDie Fragen werden jedes Mal in zufälliger Reihenfolge angezeigt, damit du wirklich lernst – und nicht nur die Reihenfolge auswendig kennst.',
              ),

              const SizedBox(height: 16),

              // Ada vorstellen
              _buildAdaCard(context),

              const SizedBox(height: 16),

              // Tipps
              _buildInfoCard(
                icon: Icons.tips_and_updates,
                iconColor: Colors.green,
                title: 'Tipps für deine Vorbereitung',
                content:
                    '📝 Nutze das Scratch Pad bei Rechenaufgaben – genau wie in der echten Prüfung hast du dort Platz für deine Zwischenrechnungen.\n\n🔁 Wiederhole jedes Thema mehrmals – beim ersten Durchgang geht es ums Verstehen, danach ums Festigen.\n\n💬 Scheue dich nicht, Ada zu fragen – sie erklärt Konzepte geduldig und geht auf deine Fragen ein.\n\n🎯 Fokussiere dich besonders auf Themen, bei denen dein Fortschritt noch niedrig ist.',
              ),

              const SizedBox(height: 24),

              // Nicht mehr anzeigen
              Row(
                children: [
                  Checkbox(
                    value: _nichtMehrAnzeigen,
                    onChanged: (value) {
                      setState(() {
                        _nichtMehrAnzeigen = value ?? false;
                      });
                    },
                    activeColor: Colors.teal,
                  ),
                  const Text(
                    'Diesen Hinweis nicht mehr anzeigen',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Los geht's Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_nichtMehrAnzeigen) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('kernthemen_info_shown', true);
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(
                    'Los geht\'s!',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Ada fragen Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AiTutorChatScreen(
                          currentQuestion: null,
                          topic: 'Kernthemen Allgemein',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.psychology),
                  label: const Text(
                    'Ada fragen bevor ich starte',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.teal.shade300),
                    foregroundColor: Colors.teal.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ada – Deine KI-Tutorin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Immer für dich da',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Bei jeder Aufgabe steht dir Ada zur Seite. Sie ist benannt nach Ada Lovelace – der ersten Programmiererin der Geschichte.\n\nAda kann dir:\n\n💡 Einen gezielten Tipp geben, ohne die Lösung zu verraten\n💬 Im Chat ausführlich erklären, was du noch nicht verstehst\n✅ Deine Freitext-Antworten bewerten und Feedback geben\n📚 Gemeinsam mit dir ein Thema von Grund auf durcharbeiten\n\nNutze Ada nicht nur wenn du feststeckst – sondern auch um dein Wissen zu vertiefen und Lücken zu schließen.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
