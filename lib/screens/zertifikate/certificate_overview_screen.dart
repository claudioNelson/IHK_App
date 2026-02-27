import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'certificate_practice_screen.dart';

class CertificateOverviewScreen extends StatefulWidget {
  const CertificateOverviewScreen({super.key});

  @override
  _CertificateOverviewScreenState createState() =>
      _CertificateOverviewScreenState();
}

class _CertificateOverviewScreenState extends State<CertificateOverviewScreen> {
  List<Map<String, dynamic>> certificates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  Future<void> _loadCertificates() async {
    try {
      final result = await Supabase.instance.client
          .from('zertifikate')
          .select()
          .order('created_at');

      setState(() {
        certificates = List<Map<String, dynamic>>.from(result);
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e')));
      }
      setState(() => isLoading = false);
    }
  }

  Color _getVendorColor(String anbieter) {
    if (anbieter.contains('AWS')) return const Color(0xFFFF9900);
    if (anbieter.contains('Microsoft')) return const Color(0xFF0078D4);
    if (anbieter.contains('Google')) return const Color(0xFF4285F4);
    if (anbieter.contains('SAP')) return const Color(0xFF0070F2);
    return Colors.indigo;
  }

  List<Color> _getVendorGradient(String anbieter) {
    if (anbieter.contains('AWS'))
      return [const Color(0xFFFF9900), const Color(0xFFE67E00)];
    if (anbieter.contains('Microsoft'))
      return [const Color(0xFF0078D4), const Color(0xFF005A9E)];
    if (anbieter.contains('Google'))
      return [const Color(0xFF4285F4), const Color(0xFF1A56DB)];
    if (anbieter.contains('SAP'))
      return [const Color(0xFF0070F2), const Color(0xFF0050B3)];
    return [Colors.indigo.shade400, Colors.indigo.shade700];
  }

  IconData _getVendorIcon(String anbieter) {
    if (anbieter.contains('AWS')) return Icons.cloud_rounded;
    if (anbieter.contains('Microsoft')) return Icons.window_rounded;
    if (anbieter.contains('Google')) return Icons.language_rounded;
    if (anbieter.contains('SAP')) return Icons.business_center_rounded;
    return Icons.workspace_premium_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── HEADER ─────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.indigo.shade600, Colors.indigo.shade900],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Zertifikate',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Bereite dich auf deine Prüfung vor',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    if (!isLoading && certificates.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${certificates.length} Zertifikate verfügbar',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // ── CONTENT ────────────────────────────────────
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.indigo.shade400,
                    ),
                  )
                : certificates.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Keine Zertifikate verfügbar',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600
                          ? 3
                          : 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: certificates.length,
                    itemBuilder: (context, index) {
                      return _buildCertCard(certificates[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertCard(Map<String, dynamic> cert) {
    final gradient = _getVendorGradient(cert['anbieter']);
    final IconData icon = _getVendorIcon(cert['anbieter']);
    final color = gradient[0];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CertificatePracticeScreen(
            zertifikatId: cert['id'],
            certName: cert['name'],
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Oberer farbiger Bereich
            Container(
              height: 85,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(child: Icon(icon, size: 36, color: Colors.white)),
            ),

            // Unterer weißer Bereich
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cert['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${cert['anzahl_fragen']} Fragen',
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
