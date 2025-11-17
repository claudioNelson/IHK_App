import 'package:flutter/material.dart';
import 'ap1_halbjahrespruefung_page.dart'; // Pfad anpassen falls nötig

class PruefungsSimulationUebersichtPage extends StatelessWidget {
  const PruefungsSimulationUebersichtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prüfungssimulationen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Wähle eine Prüfungssimulation',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // === Karte: AP1 Halbjahresprüfung ===
          _PruefungsCard(
            title: 'AP1 – Halbjahresprüfung Simulation',
            subtitle:
                'Rechenaufgaben + Entscheidungsmatrizen im Stil der IHK-AP1.',
            badgeText: 'Fachinformatiker AE/SI',
            onStart: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const Ap1HalbjahrespruefungPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Platzhalter für weitere Simulationen
          _PruefungsCard(
            title: 'AP1 – Komplettprüfung (in Planung)',
            subtitle:
                'Komplette Simulation mit GA1, GA2 und WiSo (demnächst verfügbar).',
            badgeText: 'Coming soon',
            enabled: false,
            onStart: () {},
          ),
        ],
      ),
    );
  }
}

class _PruefungsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final VoidCallback onStart;
  final bool enabled;

  const _PruefungsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.onStart,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = enabled ? Colors.white : Colors.grey.shade200;

    return Card(
      elevation: enabled ? 2 : 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: enabled ? Colors.indigo.shade100 : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: enabled ? Colors.indigo.shade900 : Colors.grey.shade100,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Titel
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),

            // Beschreibung
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            // Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: enabled ? onStart : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Simulation starten'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
