import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'certificate_practice_screen.dart';

class CertificateOverviewScreen extends StatefulWidget {
  const CertificateOverviewScreen({Key? key}) : super(key: key);

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
    if (anbieter.contains('AWS')) return Colors.orange;
    if (anbieter.contains('Microsoft')) return Colors.blue;
    if (anbieter.contains('Google')) return Colors.red;
    if (anbieter.contains('SAP')) return Colors.teal;
    return Colors.grey;
  }

  String _getVendorIcon(String anbieter) {
    if (anbieter.contains('AWS')) return '☁️';
    if (anbieter.contains('Microsoft')) return '🔷';
    if (anbieter.contains('Google')) return '🌐';
    if (anbieter.contains('SAP')) return '💼';
    return '📋';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zertifikate üben'),
        backgroundColor: Colors.deepOrange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : certificates.isEmpty
          ? const Center(child: Text('Keine Zertifikate verfügbar'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 3
                      : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: certificates.length,
                itemBuilder: (context, index) {
                  final cert = certificates[index];
                  return _buildCertCard(cert);
                },
              ),
            ),
    );
  }

  Widget _buildCertCard(Map<String, dynamic> cert) {
    final color = _getVendorColor(cert['anbieter']) as MaterialColor;
    final icon = _getVendorIcon(cert['anbieter']);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CertificatePracticeScreen(
                zertifikatId: cert['id'],
                certName: cert['name'],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color[300]!, color[700]!], // ← Sichere Variante
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                cert['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cert['anzahl_fragen']} Fragen',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cert['anbieter'],
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
