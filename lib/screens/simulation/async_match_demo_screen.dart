import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/async_duel_service.dart';
import '../../../async_match_progress.dart';
import 'leaderboard_screen.dart';
import 'async_match_play_screen.dart';

class AsyncMatchDemoPage extends StatefulWidget {
  const AsyncMatchDemoPage({super.key});
  @override
  State<AsyncMatchDemoPage> createState() => _AsyncMatchDemoPageState();
}

class _AsyncMatchDemoPageState extends State<AsyncMatchDemoPage> {
  final _svc = AsyncDuelService();
  bool _busy = false;
  List<Map<String, dynamic>> _myMatches = [];
  Map<String, dynamic>? _myStats;

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'local';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _busy = true);
    try {
      final matches = await _svc.getMyMatches();
      final stats = await _svc.getMyStats();
      if (!mounted) return;
      setState(() {
        _myMatches = matches;
        _myStats = stats;
      });
    } catch (e) {
      print('❌ Fehler beim Laden: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createMatch() async {
    setState(() => _busy = true);
    try {
      final id = await _svc.createMatch(count: 10);
      print('✅ Match erstellt: $id');
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('🎮 Match erstellt! Warte auf Gegner...'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _joinRandom() async {
    setState(() => _busy = true);
    try {
      final id = await _svc.joinRandomMatch();
      if (id == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('😕 Kein offenes Match gefunden. Erstelle selbst eins!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      print('✅ Match beigetreten: $id');
      await _loadData();
      if (!mounted) return;
      // Direkt ins Match springen
      _playMatch(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _playMatch(String matchId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AsyncMatchPlayPage(matchId: matchId),
      ),
    ).then((_) => _loadData());
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'open':
        return 'Wartet auf Gegner';
      case 'active':
        return 'Bereit zum Spielen!';
      case 'waiting':
        return 'Warte auf Gegner';
      case 'completed':
      case 'finalized':
      case 'finished':
        return 'Abgeschlossen';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'open':
        return Icons.person_search;
      case 'active':
        return Icons.play_circle;
      case 'waiting':
        return Icons.hourglass_top;
      case 'completed':
      case 'finalized':
      case 'finished':
        return Icons.emoji_events;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.orange;
      case 'active':
        return Colors.green;
      case 'waiting':
        return Colors.blue;
      case 'completed':
      case 'finalized':
      case 'finished':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: Colors.indigo,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.indigo.shade700, Colors.purple.shade600],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          const Text(
                            '⚔️ Arena',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fordere andere Spieler heraus!',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          // Stats Row
                          if (_myStats != null) _buildStatsRow(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.emoji_events, color: Colors.amber),
                  tooltip: 'Rangliste',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _busy ? null : _loadData,
                ),
              ],
            ),

            // Action Buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(child: _buildActionButton(
                      icon: Icons.add_circle,
                      label: 'Erstellen',
                      color: Colors.green,
                      onTap: _busy ? null : _createMatch,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _buildActionButton(
                      icon: Icons.casino,
                      label: 'Beitreten',
                      color: Colors.orange,
                      onTap: _busy ? null : _joinRandom,
                    )),
                  ],
                ),
              ),
            ),

            // Loading indicator
            if (_busy)
              const SliverToBoxAdapter(
                child: LinearProgressIndicator(),
              ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text(
                      'Deine Matches',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_myMatches.length} Spiele',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ),

            // Matches Liste
            _myMatches.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sports_esports, size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            'Noch keine Matches',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Erstelle ein Match oder tritt einem bei!',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _buildMatchCard(_myMatches[i]),
                      childCount: _myMatches.length,
                    ),
                  ),

            // Bottom padding for navbar
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildStatsRow() {
  final elo = _myStats?['elo_rating'] ?? 1000;
  final wins = _myStats?['wins'] ?? 0;
  final losses = _myStats?['losses'] ?? 0;

  return Row(
    children: [
      Expanded(child: _buildStatBadge('$elo', 'Elo', Icons.star)),
      const SizedBox(width: 8),
      Expanded(child: _buildStatBadge('$wins', 'Siege', Icons.check_circle)),
      const SizedBox(width: 8),
      Expanded(child: _buildStatBadge('$losses', 'Ndlg.', Icons.cancel)),
    ],
  );
}

  Widget _buildStatBadge(String value, String label, IconData icon) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 4),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 9,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    final matchId = match['id'] as String;
    final status = match['status'] as String;
    final questions = match['total_questions'] ?? 10;
    final canPlay = status == 'active' || status == 'open';
    final isFinished = status == 'completed' || status == 'finalized' || status == 'finished';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          onTap: () => _playMatch(matchId),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Status Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getStatusIcon(status),
                    color: _getStatusColor(status),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Match #${matchId.substring(0, 6).toUpperCase()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getStatusText(status),
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$questions Fragen',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action
                if (canPlay)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Spielen',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (isFinished)
                  Icon(Icons.emoji_events, color: Colors.amber.shade600, size: 28)
                else
                  Icon(Icons.hourglass_top, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}