// lib/screens/module/modul_liste_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../module/themen_liste_screen.dart';
import '../../services/app_cache_service.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

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
  bool _showAsList = false;

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
    final cacheService = AppCacheService();
    if (cacheService.modulesLoaded && cacheService.cachedModule.isNotEmpty) {
      module = cacheService.cachedModule;
      anzahlFragen = Map.from(cacheService.cachedAnzahlFragen);
      beantworteteFragen = Map.from(cacheService.cachedBeantworteteFragen);
      letzteThemaId = Map.from(cacheService.cachedLetzteThemaId);
      loading = false;
    } else {
      ladeModule();
    }
  }

  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showAsList = prefs.getBool('module_view_as_list') ?? false;
    });
  }

  Future<void> _toggleView() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _showAsList = !_showAsList);
    await prefs.setBool('module_view_as_list', _showAsList);
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
        beantworteteFragen[modul['id']] =
            await _ladeModulFortschritt(modul['id']);
        letzteThemaId[modul['id']] = await _ladeLetzteThemaId(modul['id']);
      }
      if (!mounted) return;
      setState(() {
        module = response;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
      setState(() => loading = false);
    }
  }

  Future<int> _ladeModulFortschritt(int modulId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('fortschritt_modul_$modulId')?.length ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<int> _ladeLetzteThemaId(int modulId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('letztes_thema_modul_$modulId') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Color _getModulColor(int index) {
    const colors = [
      Color(0xFF4F46E5),
      Color(0xFF7C3AED),
      Color(0xFF0D9488),
      Color(0xFFEA580C),
      Color(0xFFDB2777),
      Color(0xFF2563EB),
      Color(0xFF16A34A),
      Color(0xFFDC2626),
    ];
    return colors[index % colors.length];
  }

  IconData _getModulIcon(int modulId) {
    switch (modulId) {
      case 1: return Icons.business_center;
      case 2: return Icons.gavel;
      case 15: return Icons.assignment;
      case 16: return Icons.verified;
      case 17: return Icons.account_tree;
      case 9001: return Icons.calculate;
      case 9002: return Icons.public;
      case 9003: return Icons.storage;
      case 9004: return Icons.lan;
      case 9005: return Icons.terminal;
      case 9006: return Icons.memory;
      case 9007: return Icons.code;
      case 9008: return Icons.security;
      case 9009: return Icons.web;
      case 9010: return Icons.cloud;
      case 9011: return Icons.data_array;
      default: return Icons.school;
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

  double get _overallProgress {
    if (module.isEmpty) return 0;
    final total = anzahlFragen.values.fold(0, (a, b) => a + b);
    final done = beantworteteFragen.values.fold(0, (a, b) => a + b);
    return total > 0 ? done / total : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: _indigo))
                : module.isEmpty
                    ? _buildEmpty()
                    : RefreshIndicator(
                        color: _indigo,
                        onRefresh: ladeModule,
                        child: _showAsList ? _buildListView() : _buildGridView(),
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
                    child: const Icon(Icons.library_books_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lernmodule',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Wähle ein Modul zum Üben',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleView,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _showAsList
                            ? Icons.grid_view_rounded
                            : Icons.list_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              if (!loading && module.isNotEmpty) ...[
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
          const Text('Keine Module gefunden',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: module.length,
      itemBuilder: (ctx, i) {
        final modul = module[i] as Map<String, dynamic>;
        final modulId = modul['id'] as int;
        final total = anzahlFragen[modulId] ?? 0;
        final answered = beantworteteFragen[modulId] ?? 0;
        final progress = total > 0 ? answered / total : 0.0;
        final color = _getModulColor(i);

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 200 + (i * 40)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) => Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.15), width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => _openModul(modul),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.75)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Icon(_getModulIcon(modulId),
                            color: Colors.white, size: 26),
                      ),
                      const Spacer(),
                      Text(
                        modul['name'],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(Icons.quiz_outlined,
                                size: 13, color: Colors.grey.shade500),
                            const SizedBox(width: 3),
                            Text('$answered/$total',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500)),
                          ]),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${(progress * 100).toInt()}%',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: color)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: module.length,
      itemBuilder: (ctx, i) {
        final modul = module[i] as Map<String, dynamic>;
        final modulId = modul['id'] as int;
        final total = anzahlFragen[modulId] ?? 0;
        final answered = beantworteteFragen[modulId] ?? 0;
        final progress = total > 0 ? answered / total : 0.0;
        final color = _getModulColor(i);

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 150 + (i * 40)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) => Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: Opacity(opacity: value, child: child),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.12), width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: color.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: () => _openModul(modul),
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.75)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(_getModulIcon(modulId),
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(modul['name'],
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Row(children: [
                              Text('$answered/$total Fragen',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey.shade100,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(color),
                                    minHeight: 5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${(progress * 100).toInt()}%',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: color)),
                            ]),
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
      },
    );
  }
}