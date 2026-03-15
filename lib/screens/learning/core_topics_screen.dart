// lib/screens/learning/core_topics_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'network_practice_screen.dart';
import 'raid_practice_screen.dart';
import 'dns_port_practice_screen.dart';
import '../../services/app_cache_service.dart';
import 'security_practice_screen.dart';
import 'osi_practice_screen.dart';
import 'backup_practice_screen.dart';
import 'binary_practice_screen.dart';
import 'kernthemen_info_screen.dart';
import 'database_practice_screen.dart';
import 'project_management_practice_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class CoreTopicsScreen extends StatefulWidget {
  const CoreTopicsScreen({super.key});

  @override
  State<CoreTopicsScreen> createState() => _CoreTopicsScreenState();
}

class _CoreTopicsScreenState extends State<CoreTopicsScreen> {
  List<Map<String, dynamic>> _coreTopics = [];
  bool _loading = true;
  Map<int, Map<String, dynamic>> _progress = {};

  @override
  void initState() {
    super.initState();
    _loadCoreTopics();
    _checkInfoScreen();
  }

  Future<void> _loadCoreTopics() async {
    try {
      final cache = AppCacheService();
      if (cache.kernthemenLoaded) {
        setState(() {
          _coreTopics = List<Map<String, dynamic>>.from(cache.cachedKernthemen);
          _progress = cache.cachedKernthemenProgress;
          _loading = false;
        });
        return;
      }
      await cache.preloadKernthemen();
      if (!mounted) return;
      setState(() {
        _coreTopics = List<Map<String, dynamic>>.from(cache.cachedKernthemen);
        _progress = cache.cachedKernthemenProgress;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  Future<void> _refreshProgress() async {
    final cache = AppCacheService();
    await cache.refreshKernthemenProgress();
    if (!mounted) return;
    setState(() => _progress = cache.cachedKernthemenProgress);
  }

  Future<void> _checkInfoScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('kernthemen_info_shown') ?? false;
    if (!shown && mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KernthemenInfoScreen()),
      );
    }
  }

  _TopicConfig _getConfig(int id) {
    switch (id) {
      case 18: return _TopicConfig(Icons.lan_rounded, const Color(0xFF2563EB));
      case 20: return _TopicConfig(Icons.storage_rounded, const Color(0xFF0D9488));
      case 21: return _TopicConfig(Icons.dns_rounded, const Color(0xFF7C3AED));
      case 22: return _TopicConfig(Icons.security_rounded, const Color(0xFFDC2626));
      case 23: return _TopicConfig(Icons.layers_rounded, const Color(0xFF4F46E5));
      case 24: return _TopicConfig(Icons.backup_rounded, const Color(0xFF0891B2));
      case 25: return _TopicConfig(Icons.calculate_rounded, const Color(0xFFEA580C));
      case 26: return _TopicConfig(Icons.table_chart_rounded, const Color(0xFF7C3AED));
      case 27: return _TopicConfig(Icons.account_tree_rounded, const Color(0xFF16A34A));
      default: return _TopicConfig(Icons.lightbulb_rounded, const Color(0xFFF59E0B));
    }
  }

  Future<void> _openTopic(Map<String, dynamic> topic) async {
    Widget? screen;
    switch (topic['id']) {
      case 18: screen = NetworkPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 20: screen = RaidPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 21: screen = DnsPortPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 22: screen = SecurityPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 23: screen = OsiPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 24: screen = BackupPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 25: screen = BinaryPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 26: screen = DatabasePracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 27: screen = ProjectManagementPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${topic['name']} — Coming Soon!')));
        return;
    }
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
    _refreshProgress();
  }

  double get _overallProgress {
    if (_progress.isEmpty) return 0;
    final total = _progress.values.fold(0, (a, b) => a + (b['total'] as int));
    final correct = _progress.values.fold(0, (a, b) => a + (b['correct'] as int));
    return total > 0 ? correct / total : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _indigo))
                : _coreTopics.isEmpty
                    ? _buildEmpty()
                    : RefreshIndicator(
                        color: _indigo,
                        onRefresh: _loadCoreTopics,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                          itemCount: _coreTopics.length,
                          itemBuilder: (ctx, i) => _buildCard(_coreTopics[i], i),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_indigoDark, _indigo, _indigoLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (Navigator.canPop(context)) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.star_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kernthemen',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Text('Kommen in JEDER IHK-Prüfung vor',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              if (!_loading && _coreTopics.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _overallProgress,
                          backgroundColor: Colors.white.withOpacity(0.25),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 7,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(_overallProgress * 100).toInt()}% gesamt',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: _indigo.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.inbox_outlined, size: 56, color: _indigo),
          ),
          const SizedBox(height: 16),
          const Text('Keine Kernthemen gefunden',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> topic, int index) {
    final config = _getConfig(topic['id'] as int);
    final progress = _progress[topic['id']];
    final percent = progress?['percent'] as double? ?? 0.0;
    final correct = progress?['correct'] as int? ?? 0;
    final total = progress?['total'] as int? ?? 0;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 150 + index * 40),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (ctx, val, child) => Transform.translate(
        offset: Offset(20 * (1 - val), 0),
        child: Opacity(opacity: val, child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: config.color.withOpacity(0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: config.color.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => _openTopic(topic),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [config.color, config.color.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: config.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Icon(config.icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic['name'] ?? '',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        if (progress != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text('$correct/$total',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: percent / 100,
                                    backgroundColor: Colors.grey.shade100,
                                    valueColor: AlwaysStoppedAnimation(
                                        percent >= 80
                                            ? Colors.green
                                            : config.color),
                                    minHeight: 5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${percent.toInt()}%',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: config.color)),
                            ],
                          ),
                        ] else if (topic['beschreibung'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            topic['beschreibung'],
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded,
                      color: Colors.grey.shade300, size: 26),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicConfig {
  final IconData icon;
  final Color color;
  const _TopicConfig(this.icon, this.color);
}