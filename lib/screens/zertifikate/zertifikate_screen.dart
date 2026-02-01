import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'zertifikat_test_screen.dart';
import 'zertifikat_info_screen.dart';
import '../../widgets/zertifikat_info_dialog.dart';
import '../../services/app_cache_service.dart';

class ZertifikatePage extends StatefulWidget {
  const ZertifikatePage({super.key});

  @override
  State<ZertifikatePage> createState() => _ZertifikatePageState();
}

class _ZertifikatePageState extends State<ZertifikatePage> {
  final supabase = Supabase.instance.client;
  Map<int, Map<String, dynamic>> _userResults = {};

  List<dynamic> zertifikate = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    final cacheService = AppCacheService();
    if (cacheService.certificatesLoaded &&
        cacheService.cachedZertifikate.isNotEmpty) {
      zertifikate = cacheService.cachedZertifikate;
      _userResults = Map.from(cacheService.cachedUserResults);
      loading = false;
    } else {
      _loadZertifikate();
    }
  }

  Future<void> _loadZertifikate() async {
    try {
      final data = await supabase
          .from('zertifikate')
          .select()
          .order('anbieter, name');

      // User-Ergebnisse laden
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final results = await supabase
            .from('user_certificates')
            .select()
            .eq('user_id', userId);

        for (var r in results) {
          _userResults[r['zertifikat_id']] = r;
        }
      }

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

  Color _getAnbieterColor(String anbieter) {
    switch (anbieter.toLowerCase()) {
      case 'aws':
        return Colors.orange;
      case 'sap':
        return Colors.blue;
      case 'microsoft':
        return Colors.lightBlue;
      case 'google cloud':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getAnbieterIcon(String anbieter) {
    switch (anbieter.toLowerCase()) {
      case 'aws':
        return Icons.cloud;
      case 'sap':
        return Icons.business;
      case 'microsoft':
        return Icons.window;
      case 'google cloud':
        return Icons.cloud_circle;
      default:
        return Icons.card_membership;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Zertifikatsprüfungen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ZertifikatInfoScreen()),
              );
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'Zertifikate Info',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : zertifikate.isEmpty
          ? const Center(
              child: Text(
                'Keine Zertifikate verfügbar',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: zertifikate.length,
              itemBuilder: (context, index) {
                final cert = zertifikate[index];
                final color = _getAnbieterColor(cert['anbieter']);
                final icon = _getAnbieterIcon(cert['anbieter']);

                return GestureDetector(
                  onTap: () async {
                    // Zeige Info-Dialog
                    final shouldStart = await showZertifikatInfoDialog(
                      context,
                      cert,
                    );

                    // Wenn User "Prüfung starten" klickt
                    if (shouldStart == true && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ZertifikatTestPage(
                            zertifikatId: cert['id'],
                            zertifikatName: cert['name'],
                            anzahlFragen: cert['anzahl_fragen'],
                            pruefungsdauer: cert['pruefungsdauer'],
                            mindestPunktzahl: cert['mindest_punktzahl'],
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(icon, color: color, size: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cert['anbieter'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      cert['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildInfoChip(
                                Icons.quiz,
                                '${cert['anzahl_fragen']} Fragen',
                                Colors.blue,
                              ),
                              _buildInfoChip(
                                Icons.timer,
                                '${cert['pruefungsdauer']} Min',
                                Colors.orange,
                              ),
                              _buildInfoChip(
                                Icons.flag,
                                'Mind. ${cert['mindest_punktzahl']}%',
                                Colors.green,
                              ),
                              // User-Ergebnisse anzeigen
                              if (_userResults.containsKey(cert['id'])) ...[
                                _buildInfoChip(
                                  Icons.refresh,
                                  '${_userResults[cert['id']]!['attempts']}x',
                                  Colors.purple,
                                ),
                                _buildInfoChip(
                                  Icons.trending_up,
                                  'Beste: ${_userResults[cert['id']]!['best_score']}%',
                                  Colors.teal,
                                ),
                                if (_userResults[cert['id']]!['passed'] == true)
                                  _buildInfoChip(
                                    Icons.verified,
                                    'Bestanden ✓',
                                    Colors.green,
                                  ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
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
