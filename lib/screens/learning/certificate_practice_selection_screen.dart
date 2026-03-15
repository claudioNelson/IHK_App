import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'certificate_practice_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class CertificatePracticeSelectionScreen extends StatefulWidget {
  const CertificatePracticeSelectionScreen({super.key});

  @override
  State<CertificatePracticeSelectionScreen> createState() =>
      _CertificatePracticeSelectionScreenState();
}

class _CertificatePracticeSelectionScreenState
    extends State<CertificatePracticeSelectionScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> zertifikate = [];
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
          .select('id, name, beschreibung, anzahl_fragen, anbieter, dauer_minuten, mindest_prozent')
          .order('id');
      if (!mounted) return;
      setState(() {
        zertifikate = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
      setState(() => loading = false);
    }
  }

  List<Color> _getVendorGradient(String? anbieter) {
    if (anbieter == null) return [_indigoLight, _indigoDark];
    if (anbieter.contains('AWS'))
      return [const Color(0xFFFF9900), const Color(0xFFE67E00)];
    if (anbieter.contains('Microsoft'))
      return [const Color(0xFF0078D4), const Color(0xFF005A9E)];
    if (anbieter.contains('Google'))
      return [const Color(0xFF4285F4), const Color(0xFF1A56DB)];
    if (anbieter.contains('SAP'))
      return [const Color(0xFF0070F2), const Color(0xFF0050B3)];
    return [_indigoLight, _indigoDark];
  }

  IconData _getVendorIcon(String? anbieter) {
    if (anbieter == null) return Icons.workspace_premium_rounded;
    if (anbieter.contains('AWS')) return Icons.cloud_rounded;
    if (anbieter.contains('Microsoft')) return Icons.window_rounded;
    if (anbieter.contains('Google')) return Icons.language_rounded;
    if (anbieter.contains('SAP')) return Icons.business_center_rounded;
    return Icons.workspace_premium_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────
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
                padding: const EdgeInsets.fromLTRB(8, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Zertifikate üben',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'Mit Erklärungen & ohne Zeitlimit',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── LIST ────────────────────────────────────────
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: _indigo))
                : zertifikate.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('Keine Zertifikate verfügbar',
                                style: TextStyle(
                                    color: Colors.grey.shade500)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding:
                            const EdgeInsets.fromLTRB(16, 20, 16, 32),
                        itemCount: zertifikate.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) =>
                            _buildCard(zertifikate[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> cert) {
    final anzahl = (cert['anzahl_fragen'] ?? 0) as int;
    final hatFragen = anzahl > 0;
    final gradient = _getVendorGradient(cert['anbieter']);
    final icon = _getVendorIcon(cert['anbieter']);
    final color = gradient[0];
    final dauer = cert['dauer_minuten'];
    final mindest = cert['mindest_prozent'];

    return GestureDetector(
      onTap: hatFragen
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CertificatePracticeScreen(
                    zertifikatId: cert['id'],
                    zertifikatName: cert['name'],
                    anzahlFragen: anzahl,
                  ),
                ),
              )
          : () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Für dieses Zertifikat sind noch keine Fragen verfügbar.')),
              ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hatFragen
                ? color.withOpacity(0.15)
                : Colors.grey.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: hatFragen
                  ? color.withOpacity(0.08)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Box
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: hatFragen
                    ? LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(colors: [
                        Colors.grey.shade400,
                        Colors.grey.shade500
                      ]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (hatFragen ? color : Colors.grey).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                hatFragen ? icon : Icons.lock_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Text + Chips
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cert['anbieter'] != null)
                    Text(
                      cert['anbieter'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: hatFragen ? color : Colors.grey.shade400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    cert['name'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: hatFragen
                          ? const Color(0xFF1A1A2E)
                          : Colors.grey.shade400,
                    ),
                  ),
                  if (!hatFragen) ...[
                    const SizedBox(height: 4),
                    Text('Bald verfügbar',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade400)),
                  ] else ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _chip(Icons.quiz_outlined, '$anzahl Fragen', color),
                        if (dauer != null)
                          _chip(Icons.timer_outlined, '$dauer Min', Colors.orange),
                        if (mindest != null)
                          _chip(Icons.flag_outlined, 'Mind. $mindest%', Colors.green),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hatFragen
                    ? color.withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: hatFragen ? color : Colors.grey.shade400,
                size: 18,
              ),
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