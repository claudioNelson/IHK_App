import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../module/themen_liste_screen.dart';

class ModulListe extends StatefulWidget {
  const ModulListe({super.key});

  @override
  State<ModulListe> createState() => _ModulListeState();
}

class _ModulListeState extends State<ModulListe> {
  final supabase = Supabase.instance.client;

  List<dynamic> module = [];
  Map<int, int> anzahlFragen = {};
  Map<int, int> beantworteteFragen = {};
  Map<int, int> letzteThemaId = {};
  bool loading = true;

  // false = Grid, true = Liste
  bool _showAsList = false;

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
    ladeModule();
  }

  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showAsList = prefs.getBool('module_view_as_list') ?? false;
    });
  }

  Future<void> ladeModule() async {
    try {
      final response = await supabase.from('module').select().order('id');

      for (var modul in response) {
        final fragen = await supabase
            .from('fragen')
            .select('id')
            .eq('modul_id', modul['id']);
        anzahlFragen[modul['id']] = fragen.length;
        beantworteteFragen[modul['id']] = await _ladeModulFortschritt(
          modul['id'],
        );
        letzteThemaId[modul['id']] = await _ladeLetzteThemaId(modul['id']);
      }

      if (!mounted) return;
      setState(() {
        module = response;
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

  Future<int> _ladeModulFortschritt(int modulId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'fortschritt_modul_$modulId';
      final value = prefs.getStringList(key);
      return value?.length ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> _ladeLetzteThemaId(int modulId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('letztes_thema_modul_$modulId') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Color _getModulColor(int index) {
    final colors = [
      Colors.indigo,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.blue,
      Colors.green,
      Colors.deepOrange,
    ];
    return colors[index % colors.length];
  }

  IconData _getModulIcon(int modulId) {
    switch (modulId) {
      case 1:
        return Icons.business_center; // Betriebswirtschaft
      case 2:
        return Icons.gavel; // Recht
      case 15:
        return Icons.assignment; // Projektmanagement
      case 16:
        return Icons.verified; // Qualitätsmanagement
      case 17:
        return Icons.account_tree; // Geschäftsprozesse & Organisation
      case 9001:
        return Icons.calculate; // Rechnungswesen
      case 9002:
        return Icons.public; // WISO
      case 9003:
        return Icons.storage; // Datenbanken
      case 9004:
        return Icons.lan; // Netzwerke
      case 9005:
        return Icons.terminal; // Betriebssysteme & Linux
      case 9006:
        return Icons.memory; // IT-Grundlagen & Hardware
      case 9007:
        return Icons.code; // Programmierung
      case 9008:
        return Icons.security; // IT-Sicherheit
      case 9009:
        return Icons.web; // Webentwicklung
      case 9010:
        return Icons.cloud; // Cloud & DevOps
      case 9011:
        return Icons.data_array; // Datenstrukturen & Algorithmen
      default:
        return Icons.school;
    }
  }

  void _openModul(Map<String, dynamic> modul) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThemenListe(
          modulId: modul['id'],
          modulName: modul['name'],
          onThemaSelected: (themaId) async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('letztes_thema_modul_${modul['id']}', themaId);
          },
        ),
      ),
    ).then((_) => ladeModule());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.indigo.shade700, Colors.purple.shade600],
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '📚 Lernmodule',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _showAsList ? Icons.list : Icons.grid_view,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.indigo),
                  )
                : module.isEmpty
                ? const Center(child: Text('Keine Module gefunden'))
                : RefreshIndicator(
                    onRefresh: ladeModule,
                    child: _showAsList ? _buildListView() : _buildGridView(),
                  ),
          ),
        ],
      ),
    );
  }

  // ========== GRID VIEW ==========
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: module.length,
      itemBuilder: (ctx, i) {
        final modul = module[i];
        final modulId = modul['id'] as int;
        final total = anzahlFragen[modulId] ?? 0;
        final answered = beantworteteFragen[modulId] ?? 0;
        final progress = total > 0 ? answered / total : 0.0;
        final color = _getModulColor(i);

        // Rest bleibt wie vorher...

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          elevation: 3,
          shadowColor: color.withOpacity(0.3),
          child: InkWell(
            onTap: () => _openModul(modul),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getModulIcon(modulId),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  // Title
                  Text(
                    modul['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Stats
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.quiz,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$answered/$total',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ========== LIST VIEW ==========
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        100,
      ), // ← Diese Zeile ändern
      itemCount: module.length,
      itemBuilder: (ctx, i) {
        final modul = module[i];
        final modulId = modul['id'] as int;
        final total = anzahlFragen[modulId] ?? 0;
        final answered = beantworteteFragen[modulId] ?? 0;
        final progress = total > 0 ? answered / total : 0.0;
        final color = _getModulColor(i);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            child: InkWell(
              onTap: () => _openModul(modul),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getModulIcon(modulId),
                        color: color,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            modul['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                '$answered/$total Fragen',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      color,
                                    ),
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Arrow
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade400,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
