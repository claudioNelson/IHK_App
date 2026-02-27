import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'certificate_practice_screen.dart';

class CertificatePracticeSelectionScreen extends StatefulWidget {
  const CertificatePracticeSelectionScreen({super.key});

  @override
  State<CertificatePracticeSelectionScreen> createState() =>
      _CertificatePracticeSelectionScreenState();
}

class _CertificatePracticeSelectionScreenState
    extends State<CertificatePracticeSelectionScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> zertifikate = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadZertifikate();
  }

  Future<void> _loadZertifikate() async {
    try {
      final data = await supabase
          .from('zertifikate')
          .select('id, name, beschreibung, anzahl_fragen')
          .order('id');

      if (!mounted) return;

      setState(() {
        zertifikate = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Zertifikate üben',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : zertifikate.isEmpty
          ? const Center(child: Text('Keine Zertifikate verfügbar'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: zertifikate.length,
              itemBuilder: (context, index) {
                return _buildCertificateCard(zertifikate[index]);
              },
            ),
    );
  }

  Widget _buildCertificateCard(Map<String, dynamic> cert) {
    final color = Colors.purple; // Einheitliche Farbe für alle Zertifikate

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 3,
        shadowColor: color.withValues(alpha: 0.3),
child: InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CertificatePracticeScreen(
          zertifikatId: cert['id'],
          zertifikatName: cert['name'],
          anzahlFragen: cert['anzahl_fragen'] ?? 50,
        ),
      ),
    );
  },
  borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withValues(alpha: 0.1), Colors.white],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withValues(alpha: 0.7)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (cert['beschreibung'] != null &&
                    cert['beschreibung'].toString().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    cert['beschreibung'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Info Chips
                Wrap(
                  spacing: 8,
                  children: [
                    _buildInfoChip(
                      Icons.quiz_outlined,
                      '${cert['anzahl_fragen'] ?? 0} Fragen',
                      Colors.blue,
                    ),
                    _buildInfoChip(
                      Icons.lightbulb_outline,
                      'Mit Erklärungen',
                      Colors.amber,
                    ),
                    _buildInfoChip(
                      Icons.timer_off,
                      'Kein Zeitlimit',
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
