// lib/screens/learning/kernthemen_info_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

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
      backgroundColor: const Color(0xFFF5F5FF),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            elevation: 0,
            backgroundColor: _indigoDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_indigoDark, _indigo, _indigoLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.star_rounded,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Kernthemen',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              Text('Deine Prüfungsvorbereitung',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('Kernthemen',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Wichtigkeit
                _buildInfoCard(
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                  title: 'Warum sind Kernthemen so wichtig?',
                  content:
                      'Die IHK-Abschlussprüfung besteht aus mehreren Teilen – und in fast jedem davon tauchen diese Kernthemen auf. Themen wie IP-Subnetting, RAID-Systeme, das OSI-Modell oder IT-Sicherheit sind keine Zufallsfragen: Sie gehören zum absoluten Pflichtprogramm jedes IT-Fachinformatikers.\n\nWer diese Themen sicher beherrscht, legt ein starkes Fundament für die gesamte Prüfung.',
                ),
                const SizedBox(height: 14),

                // Was dich erwartet
                _buildInfoCard(
                  icon: Icons.quiz_rounded,
                  color: Colors.blue,
                  title: 'Was dich hier erwartet',
                  content:
                      'Jedes Kernthema enthält eine Mischung aus verschiedenen Aufgabentypen – genau wie in der echten Prüfung:\n\n• Berechnungsaufgaben (z. B. Subnetzmasken, RAID-Kapazitäten)\n• Multiple-Choice-Fragen zum schnellen Wiederholen\n• Freitext-Aufgaben, bei denen du Konzepte erklärst\n\nDie Fragen werden jedes Mal in zufälliger Reihenfolge angezeigt, damit du wirklich lernst – und nicht nur die Reihenfolge auswendig kennst.',
                ),
                const SizedBox(height: 14),

                // Ada Card
                _buildAdaCard(context),
                const SizedBox(height: 14),

                // Tipps
                _buildInfoCard(
                  icon: Icons.tips_and_updates_rounded,
                  color: Colors.green,
                  title: 'Tipps für deine Vorbereitung',
                  content:
                      '📝 Nutze das Scratch Pad bei Rechenaufgaben – genau wie in der echten Prüfung hast du dort Platz für deine Zwischenrechnungen.\n\n🔁 Wiederhole jedes Thema mehrmals – beim ersten Durchgang geht es ums Verstehen, danach ums Festigen.\n\n💬 Scheue dich nicht, Ada zu fragen – sie erklärt Konzepte geduldig und geht auf deine Fragen ein.\n\n🎯 Fokussiere dich besonders auf Themen, bei denen dein Fortschritt noch niedrig ist.',
                ),
                const SizedBox(height: 20),

                // Checkbox
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _nichtMehrAnzeigen,
                        onChanged: (v) =>
                            setState(() => _nichtMehrAnzeigen = v ?? false),
                        activeColor: _indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      const Text('Diesen Hinweis nicht mehr anzeigen',
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Los geht's Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_nichtMehrAnzeigen) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('kernthemen_info_shown', true);
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    label: const Text('Los geht\'s!',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Ada fragen Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AiTutorChatScreen(
                          currentQuestion: null,
                          topic: 'Kernthemen Allgemein',
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.psychology_rounded, size: 20),
                    label: const Text('Ada fragen bevor ich starte',
                        style: TextStyle(fontSize: 15)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: _indigoLight, width: 1.5),
                      foregroundColor: _indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content,
              style: TextStyle(
                  fontSize: 14, color: Colors.grey.shade700, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildAdaCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.purple.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.psychology_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ada – Deine KI-Tutorin',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Immer für dich da',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Ada ist benannt nach Ada Lovelace – der ersten Programmiererin der Geschichte.\n\nSie kann dir:\n\n💡 Einen gezielten Tipp geben, ohne die Lösung zu verraten\n💬 Im Chat ausführlich erklären, was du noch nicht verstehst\n✅ Deine Freitext-Antworten bewerten und Feedback geben\n📚 Gemeinsam mit dir ein Thema von Grund auf durcharbeiten',
            style: TextStyle(
                fontSize: 14, color: Colors.grey.shade700, height: 1.6),
          ),
        ],
      ),
    );
  }
}