import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'zertifikat_test_screen.dart';
import 'zertifikat_info_screen.dart';
import '../../widgets/zertifikat_info_dialog.dart';
import '../../services/app_cache_service.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

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
      // ✅ FIX: Nur existierende Spalten — kein dauer_minuten
      final data = await supabase
          .from('zertifikate')
          .select('id, name, anbieter, anzahl_fragen, pruefungsdauer, mindest_punktzahl')
          .order('anbieter');

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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
      setState(() => loading = false);
    }
  }

  List<Color> _getVendorGradient(String anbieter) {
    switch (anbieter.toLowerCase()) {
      case 'aws':
        return [const Color(0xFFFF9900), const Color(0xFFE67E00)];
      case 'microsoft':
        return [const Color(0xFF0078D4), const Color(0xFF005A9E)];
      case 'google cloud':
        return [const Color(0xFF4285F4), const Color(0xFF1A56DB)];
      case 'sap':
        return [const Color(0xFF0070F2), const Color(0xFF0050B3)];
      default:
        return [_indigoLight, _indigoDark];
    }
  }

  IconData _getVendorIcon(String anbieter) {
    switch (anbieter.toLowerCase()) {
      case 'aws': return Icons.cloud_rounded;
      case 'microsoft': return Icons.window_rounded;
      case 'google cloud': return Icons.language_rounded;
      case 'sap': return Icons.business_center_rounded;
      default: return Icons.workspace_premium_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          Container(
            width: double.infinity,
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
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Zertifikate üben',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Mit Erklärungen & ohne Zeitlimit',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ZertifikatInfoScreen()),
                      ),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.info_outline_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: _indigo))
                : zertifikate.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('Keine Zertifikate verfügbar',
                                style:
                                    TextStyle(color: Colors.grey.shade500)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: _indigo,
                        onRefresh: _loadZertifikate,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                          itemCount: zertifikate.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _buildCard(zertifikate[index]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(dynamic cert) {
    final gradient = _getVendorGradient(cert['anbieter'] ?? '');
    final icon = _getVendorIcon(cert['anbieter'] ?? '');
    final color = gradient[0];
    final result = _userResults[cert['id']];
    final passed = result?['passed'] == true;

    return GestureDetector(
      onTap: () async {
        final shouldStart = await showZertifikatInfoDialog(context, cert);
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: passed
                ? Colors.green.withOpacity(0.3)
                : color.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cert['anbieter'] ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cert['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _chip(Icons.quiz_outlined,
                          '${cert['anzahl_fragen']} Fragen', color),
                      // ✅ Kein Timer-Chip — Üben ist ohne Zeitlimit
                      if (cert['mindest_punktzahl'] != null)
                        _chip(Icons.flag_outlined,
                            'Mind. ${cert['mindest_punktzahl']}%',
                            Colors.green),
                      if (result != null) ...[
                        _chip(Icons.refresh_rounded,
                            '${result['attempts']}x', Colors.purple),
                        _chip(Icons.trending_up_rounded,
                            'Beste: ${result['best_score']}%', Colors.teal),
                        if (passed)
                          _chip(Icons.verified_rounded, 'Bestanden ✓',
                              Colors.green),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_forward_rounded, color: color, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}