import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'network_practice_screen.dart';
import 'raid_practice_screen.dart';
import 'dns_port_practice_screen.dart';
import '../../services/progress_service.dart';
import '../../services/app_cache_service.dart';
import 'security_practice_screen.dart';
import 'osi_practice_screen.dart';
import 'backup_practice_screen.dart';
import 'binary_practice_screen.dart';
import 'kernthemen_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreTopicsScreen extends StatefulWidget {
  const CoreTopicsScreen({super.key});

  @override
  State<CoreTopicsScreen> createState() => _CoreTopicsScreenState();
}

class _CoreTopicsScreenState extends State<CoreTopicsScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _coreTopics = [];
  bool _loading = true;
  Map<int, Map<String, dynamic>> _progress = {};
  final _progressService = ProgressService();

  @override
  void initState() {
    super.initState();
    _loadCoreTopics();
    _checkInfoScreen();
  }

  Future<void> _loadCoreTopics() async {
    try {
      final cache = AppCacheService();

      // Cache vorhanden? Nutzen!
      if (cache.kernthemenLoaded) {
        print('✅ Kernthemen aus Cache geladen');
        setState(() {
          _coreTopics = List<Map<String, dynamic>>.from(
            cache.cachedKernthemen,
          ); // ← Cast hinzufügen!
          _progress = cache.cachedKernthemenProgress;
          _loading = false;
        });
        return;
      }

      // Sonst: Frisch laden & cachen
      await cache.preloadKernthemen();

      if (!mounted) return;
      setState(() {
        _coreTopics = List<Map<String, dynamic>>.from(
          cache.cachedKernthemen,
        ); // ← Cast hinzufügen!
        _progress = cache.cachedKernthemenProgress;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  Future<void> _refreshProgress() async {
    final cache = AppCacheService();
    await cache.refreshKernthemenProgress();

    if (!mounted) return;
    setState(() {
      _progress = cache.cachedKernthemenProgress;
    });
  }

  Future<void> _checkInfoScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('kernthemen_info_shown') ?? false;

    if (!shown && mounted) {
      // Kurz warten damit Screen geladen ist
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KernthemenInfoScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Colors.teal,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.teal.shade700, Colors.teal.shade500],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.star_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kernthemen',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Diese Themen kommen in JEDER IHK-Prüfung vor',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_coreTopics.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Noch keine Kernthemen verfügbar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final topic = _coreTopics[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildTopicCard(topic),
                  );
                }, childCount: _coreTopics.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    // Icon basierend auf ID
    IconData icon;
    Color color;

    switch (topic['id']) {
      case 18: // Netzwerk
        icon = Icons.wifi;
        color = Colors.blue;
        break;
      case 20: // RAID
        icon = Icons.storage;
        color = Colors.blue;
        break;
      case 21: // DNS & Ports
        icon = Icons.dns;
        color = Colors.purple;
        break;
      case 22: // IT-Sicherheit
        icon = Icons.security;
        color = Colors.deepOrange;
        break;
      case 23: // OSI-Modell
        icon = Icons.layers;
        color = Colors.indigo;
        break;
      case 24: // Backup
        icon = Icons.backup;
        color = Colors.teal;
        break;
      case 25: // Binär & Hex
        icon = Icons.calculate;
        color = Colors.orange;
        break;
      default:
        icon = Icons.lightbulb;
        color = Colors.amber;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: () async {
          // Route basierend auf Modul-ID
          Widget screen;

          switch (topic['id']) {
            case 18: // Netzwerk
              screen = NetworkPracticeScreen(
                moduleId: topic['id'],
                moduleName: topic['name'],
              );
              break;
            case 20: // RAID
              screen = RaidPracticeScreen(
                moduleId: topic['id'],
                moduleName: topic['name'],
              );
              break;
            case 21: // DNS & Ports
              screen = DnsPortPracticeScreen(
                moduleId: topic['id'],
                moduleName: topic['name'],
              );
            case 22: // IT-Sicherheit
              screen = SecurityPracticeScreen(
                moduleId: topic['id'],
                moduleName: topic['name'],
              );
              break;
            case 23: // OSI-Modell
              screen = OsiPracticeScreen(
                moduleId: topic['id'],
                moduleName: topic['name'],
              );
              break;
            case 24: // Backup
              screen = BackupPracticeScreen(
                moduleId: topic['id'],
                moduleName: topic['name'],
              );
              break;
            case 25: // Binär & Hex
              screen = BinaryPracticeScreen(
                moduleId: topic['id'],
                moduleName: topic['name'],
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${topic['name']} öffnen - Coming Soon!'),
                ),
              );
              return;
          }

          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
          _refreshProgress();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic['name'] ?? 'Unbekanntes Thema',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8), // ← NEU
                    _buildProgressBar(topic['id']),
                    if (topic['beschreibung'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        topic['beschreibung'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int moduleId) {
    final progress = _progress[moduleId];

    if (progress == null) {
      return const SizedBox.shrink();
    }

    final percent = progress['percent'] as double;
    final correct = progress['correct'] as int;
    final total = progress['total'] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$correct/$total richtig',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${percent.toInt()}%',
              style: TextStyle(
                fontSize: 13,
                color: Colors.teal.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              percent >= 80 ? Colors.green : Colors.teal,
            ),
          ),
        ),
      ],
    );
  }
}
