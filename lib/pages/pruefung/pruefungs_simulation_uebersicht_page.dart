// lib/pages/pruefung/pruefungs_simulation_uebersicht_page.dart
import 'package:flutter/material.dart';
import 'ap1_halbjahrespruefung_page.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class PruefungsSimulationUebersichtPage extends StatelessWidget {
  const PruefungsSimulationUebersichtPage({super.key});

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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_indigoDark, _indigo, _indigoLight],
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
                          child: const Icon(Icons.assignment_rounded,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Prüfungssimulationen',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Wähle eine Simulation',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text(
                'Prüfungssimulationen',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),

          // Inhalt
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // AP1 Halbjahresprüfung — aktiv
                _PruefungsCard(
                  emoji: '📝',
                  title: 'AP1 – Halbjahresprüfung',
                  subtitle:
                      'Rechenaufgaben + Entscheidungsmatrizen im Stil der IHK-AP1.',
                  badge: 'Fachinformatiker AE/SI',
                  color: _indigo,
                  enabled: true,
                  onStart: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const Ap1HalbjahrespruefungPage()),
                  ),
                ),

                const SizedBox(height: 16),

                // AP1 Komplettprüfung — coming soon
                const _PruefungsCard(
                  emoji: '🚀',
                  title: 'AP1 – Komplettprüfung',
                  subtitle:
                      'Komplette Simulation mit GA1, GA2 und WiSo (demnächst verfügbar).',
                  badge: 'Coming soon',
                  color: Colors.grey,
                  enabled: false,
                ),

                const SizedBox(height: 16),

                // AP2 — coming soon
                const _PruefungsCard(
                  emoji: '🎓',
                  title: 'AP2 – Abschlussprüfung',
                  subtitle:
                      'Realistische AP2-Simulation mit Fachrichtung AE oder SI.',
                  badge: 'Coming soon',
                  color: Colors.grey,
                  enabled: false,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PruefungsCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String badge;
  final Color color;
  final bool enabled;
  final VoidCallback? onStart;

  const _PruefungsCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color,
    this.enabled = true,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: enabled
                  ? color.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              width: 1.5),
          boxShadow: enabled
              ? [
                  BoxShadow(
                      color: color.withOpacity(0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge + Emoji Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: enabled
                          ? color.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(emoji,
                        style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: enabled
                                ? color.withOpacity(0.12)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: enabled ? color : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                title,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4),
              ),
              const SizedBox(height: 16),

              // Button
              Align(
                alignment: Alignment.centerRight,
                child: enabled
                    ? ElevatedButton.icon(
                        onPressed: onStart,
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: const Text('Simulation starten'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 2,
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: null,
                        icon:
                            const Icon(Icons.lock_outline_rounded, size: 16),
                        label: const Text('Demnächst'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          side: BorderSide(color: Colors.grey.shade300),
                          foregroundColor: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}