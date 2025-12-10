import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themen_liste_screen.dart';
import 'test_fragen_screen.dart';

class ModulListe extends StatefulWidget {
  const ModulListe({super.key});

  @override
  State<ModulListe> createState() => _ModulListeState();
}

class _ModulListeState extends State<ModulListe> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  List<dynamic> module = [];
  Map<int, int> anzahlFragen = {};
  Map<int, int> beantworteteFragen = {};
  Map<int, int> letzteThemaId = {};
  bool loading = true;

  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    ladeModule();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );
    
    _headerController.forward();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Module: $e')),
      );
      setState(() => loading = false);
    }
  }

  Future<int> _ladeModulFortschritt(int modulId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'fortschritt_modul_$modulId';
      final value = prefs.get(key);
      if (value is List<String>) return value.length;
      await prefs.remove(key);
      return 0;
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

  Future<void> _speichereLetzteThemaId(int modulId, int themaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('letztes_thema_modul_$modulId', themaId);
    } catch (e) {
      print('Fehler beim Speichern: $e');
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

  IconData _getModulIcon(int index) {
    final icons = [
      Icons.school,
      Icons.code,
      Icons.science,
      Icons.business,
      Icons.design_services,
      Icons.psychology,
      Icons.engineering,
      Icons.architecture,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: FadeTransition(
                opacity: _headerAnimation,
                child: const Text(
                  'Lernmodule',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigo.shade50,
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Statistiken',
                icon: const Icon(Icons.analytics_outlined, color: Colors.indigo),
                onPressed: _showStatisticsDialog,
              ),
            ],
          ),

          if (loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (module.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'Keine Module verfügbar',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: _buildModulCard(module[index], index),
                    );
                  },
                  childCount: module.length,
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildModulCard(Map<String, dynamic> modul, int index) {
    final modulId = modul['id'];
    final gesamt = anzahlFragen[modulId] ?? 1;
    final fertig = beantworteteFragen[modulId] ?? 0;
    final progress = (fertig / gesamt).clamp(0.0, 1.0);
    final color = _getModulColor(index);
    final icon = _getModulIcon(index);
    final letzteThema = letzteThemaId[modulId] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ThemenListe(
                  modulId: modul['id'],
                  modulName: modul['name'],
                  onThemaSelected: (themaId) {
                    _speichereLetzteThemaId(modulId, themaId);
                  },
                ),
              ),
            );
            ladeModule();
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  color.withOpacity(0.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
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
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color, color.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              modul['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              modul['beschreibung'] ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 6,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation(
                                  color.withOpacity(0.1),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 1000),
                                tween: Tween(begin: 0.0, end: progress),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation(color),
                                    strokeCap: StrokeCap.round,
                                  );
                                },
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatChip(
                        Icons.quiz_outlined,
                        '$fertig / $gesamt',
                        color,
                      ),
                      const SizedBox(width: 8),
                      if (progress >= 1.0)
                        _buildBadge(
                          Icons.emoji_events,
                          'Abgeschlossen',
                          Colors.amber,
                        ),
                    ],
                  ),
                  if (progress > 0 && progress < 1.0 && letzteThema > 0) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final themen = await supabase
                              .from('themen')
                              .select('id, name')
                              .eq('module_id', modulId)
                              .eq('id', letzteThema)
                              .maybeSingle();
                          
                          if (themen != null && mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TestFragen(
                                  modulId: modulId,
                                  modulName: '${modul['name']} • ${themen['name']}',
                                  themaId: letzteThema,
                                ),
                              ),
                            );
                            ladeModule();
                          }
                        },
                        icon: const Icon(Icons.play_arrow, size: 20),
                        label: const Text('Weitermachen'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog() {
    final totalFragen = anzahlFragen.values.fold(0, (a, b) => a + b);
    final totalRichtig = beantworteteFragen.values.fold(0, (a, b) => a + b);
    final avgProgress = totalFragen > 0 ? (totalRichtig / totalFragen * 100) : 0;
    final abgeschlossen = module.where((m) {
      final id = m['id'];
      final gesamt = anzahlFragen[id] ?? 1;
      final fertig = beantworteteFragen[id] ?? 0;
      return fertig >= gesamt;
    }).length;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.analytics, color: Colors.indigo),
            SizedBox(width: 12),
            Text('Deine Statistiken'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow(
              'Gesamtfortschritt',
              '${avgProgress.toStringAsFixed(1)}%',
              Icons.trending_up,
              Colors.indigo,
            ),
            const Divider(height: 24),
            _buildStatRow(
              'Richtig beantwortet',
              '$totalRichtig / $totalFragen',
              Icons.check_circle,
              Colors.green,
            ),
            const Divider(height: 24),
            _buildStatRow(
              'Module abgeschlossen',
              '$abgeschlossen / ${module.length}',
              Icons.emoji_events,
              Colors.amber,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}