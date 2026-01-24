import 'package:flutter/material.dart';

class ZertifikatInfoScreen extends StatelessWidget {
  const ZertifikatInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Zertifikate Info'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(Icons.workspace_premium, size: 64, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Cloud-Zertifizierungen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Erweitere deine Karriere mit anerkannten IT-Zertifikaten',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Verfügbare Zertifikate
            _buildCertSection(
              'AWS (Amazon Web Services)',
              '☁️',
              Colors.orange,
              [
                'AWS Certified Cloud Practitioner',
                'AWS Solutions Architect Associate',
                'AWS Developer Associate',
              ],
              'Der weltweit führende Cloud-Anbieter mit über 200 Services.',
            ),

            const SizedBox(height: 16),

            _buildCertSection(
              'Microsoft Azure',
              '🔷',
              Colors.blue,
              [
                'Azure Fundamentals (AZ-900)',
                'Azure Administrator (AZ-104)',
                'Azure Developer (AZ-204)',
              ],
              'Microsofts Cloud-Plattform mit starker Enterprise-Integration.',
            ),

            const SizedBox(height: 16),

            _buildCertSection(
              'Google Cloud',
              '🌐',
              Colors.green,
              [
                'Google Cloud Digital Leader',
                'Associate Cloud Engineer',
                'Professional Cloud Architect',
              ],
              'Googles Cloud-Infrastruktur mit KI und Big Data Fokus.',
            ),

            const SizedBox(height: 16),

            _buildCertSection(
              'SAP',
              '💼',
              Colors.deepPurple,
              [
                'SAP Certified Application Associate',
                'SAP S/4HANA',
                'SAP ABAP Programming',
              ],
              'Marktführer für Enterprise Resource Planning (ERP) Software.',
            ),

            const SizedBox(height: 24),

            // Warum Zertifizierungen?
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.amber.shade700,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Warum Zertifizierungen?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildBenefit(
                    '💰',
                    'Höheres Gehalt',
                    'Bis zu 20% mehr Verdienst',
                  ),
                  const SizedBox(height: 12),
                  _buildBenefit('🎯', 'Bessere Jobs', 'Mehr Karrierechancen'),
                  const SizedBox(height: 12),
                  _buildBenefit(
                    '📈',
                    'Wettbewerbsvorteil',
                    'Hebe dich von anderen ab',
                  ),
                  const SizedBox(height: 12),
                  _buildBenefit(
                    '🌍',
                    'Weltweit anerkannt',
                    'International gültig',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Lernmodus
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.blue.shade700, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Unser Lernansatz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFeature(
                    Icons.quiz,
                    'Praxisnahe Fragen',
                    'Echte Prüfungsfragen-Simulationen',
                  ),
                  const SizedBox(height: 12),
                  _buildFeature(
                    Icons.timer,
                    'Zeitbasiertes Training',
                    'Übe unter realen Bedingungen',
                  ),
                  const SizedBox(height: 12),
                  _buildFeature(
                    Icons.analytics,
                    'Fortschritts-Tracking',
                    'Behalte deine Entwicklung im Blick',
                  ),
                  const SizedBox(height: 12),
                  _buildFeature(
                    Icons.emoji_events,
                    'Elo-Rating System',
                    'Vergleiche dich mit anderen',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Call-to-Action
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Zurück zu den Zertifikaten'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertSection(
    String title,
    String emoji,
    Color color,
    List<String> certs,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          ...certs.map(
            (cert) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(cert, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue.shade900,
                ),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
