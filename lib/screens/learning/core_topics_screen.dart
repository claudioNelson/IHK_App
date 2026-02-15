import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'network_practice_screen.dart';
import 'raid_practice_screen.dart';
import 'dns_port_practice_screen.dart';

class CoreTopicsScreen extends StatefulWidget {
  const CoreTopicsScreen({super.key});

  @override
  State<CoreTopicsScreen> createState() => _CoreTopicsScreenState();
}

class _CoreTopicsScreenState extends State<CoreTopicsScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _coreTopics = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCoreTopics();
  }

  Future<void> _loadCoreTopics() async {
    try {
      final data = await _supabase
          .from('module')
          .select('id, name, beschreibung')
          .eq('kategorie', 'kernthema')
          .order('id');

      if (!mounted) return;
      setState(() {
        _coreTopics = List<Map<String, dynamic>>.from(data);
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
      default:
        icon = Icons.lightbulb;
        color = Colors.amber;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: () {
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
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${topic['name']} öffnen - Coming Soon!'),
                ),
              );
              return;
          }

          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
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
}
