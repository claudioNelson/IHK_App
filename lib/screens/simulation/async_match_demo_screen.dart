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
  List<Map<String, dynamic>> _activeMatches = [];
  List<Map<String, dynamic>> _historyMatches = [];
  Map<String, dynamic>? _myStats;
  bool _historyExpanded = false;

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

      // Trennen: Aktive vs History
      final active = <Map<String, dynamic>>[];
      final history = <Map<String, dynamic>>[];

      for (var match in matches) {
        final status = match['status'] as String;
        if (status == 'completed' ||
            status == 'finalized' ||
            status == 'finished') {
          history.add(match);
        } else {
          active.add(match);
        }
      }

      if (!mounted) return;
      setState(() {
        _activeMatches = active;
        _historyMatches = history;
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
            content: Text('😕 Kein offenes Match gefunden'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      print('✅ Match beigetreten: $id');
      await _loadData();
      if (!mounted) return;
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
      MaterialPageRoute(builder: (_) => AsyncMatchPlayPage(matchId: matchId)),
    ).then((_) => _loadData());
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'open':
        return 'Offen';
      case 'active':
        return 'Aktiv';
      case 'waiting':
        return 'Wartet';
      case 'completed':
      case 'finalized':
      case 'finished':
        return 'Beendet';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'open':
        return Icons.hourglass_empty;
      case 'active':
        return Icons.play_circle_filled;
      case 'waiting':
        return Icons.pending;
      case 'completed':
      case 'finalized':
      case 'finished':
        return Icons.check_circle;
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

  String _formatDate(String? timestamp) {
    if (timestamp == null) return 'Unbekannt';
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) {
        return 'Gerade eben';
      } else if (diff.inMinutes < 60) {
        return 'vor ${diff.inMinutes} Min';
      } else if (diff.inHours < 24) {
        return 'vor ${diff.inHours}h';
      } else if (diff.inDays == 1) {
        return 'Gestern';
      } else if (diff.inDays < 7) {
        return 'vor ${diff.inDays} Tagen';
      } else {
        return '${date.day}.${date.month}.${date.year}';
      }
    } catch (e) {
      return 'Unbekannt';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            // Modern Header
            SliverAppBar(
              expandedHeight: 220, // ← Von 200 auf 220 erhöhen
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
                                  Icons.sports_esports,
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
                                      'Match Arena',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Fordere andere heraus',
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
                          const SizedBox(height: 20),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LeaderboardScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Action Buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.add_circle_outline,
                            title: 'Erstellen',
                            subtitle: 'Neues Match',
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400,
                                Colors.green.shade600,
                              ],
                            ),
                            onTap: _busy ? null : _createMatch,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.shuffle,
                            title: 'Beitreten',
                            subtitle: 'Zufälliges Match',
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade400,
                                Colors.orange.shade600,
                              ],
                            ),
                            onTap: _busy ? null : _joinRandom,
                          ),
                        ),
                      ],
                    ),
                    if (_busy)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),

            // Aktive Matches Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.play_circle,
                        size: 18,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Aktive Matches',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_activeMatches.length}',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Aktive Matches Liste
            _activeMatches.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.sports_esports_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Keine aktiven Matches',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Erstelle ein Match oder tritt einem bei!',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _buildMatchCard(_activeMatches[i], false),
                        childCount: _activeMatches.length,
                      ),
                    ),
                  ),

            // Match History Header (Ausklappbar)
            if (_historyMatches.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() => _historyExpanded = !_historyExpanded);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.history,
                                size: 18,
                                color: Colors.purple.shade700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Match History',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_historyMatches.length}',
                                style: TextStyle(
                                  color: Colors.purple.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _historyExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Match History Liste (wenn ausgeklappt)
            if (_historyExpanded && _historyMatches.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _buildMatchCard(_historyMatches[i], true),
                    childCount: _historyMatches.length,
                  ),
                ),
              )
            else
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final elo = _myStats?['elo_rating'] ?? 1000;
    final wins = _myStats?['wins'] ?? 0;
    final losses = _myStats?['losses'] ?? 0;
    final total = wins + losses;
    final winRate = total > 0 ? ((wins / total) * 100).toInt() : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.star,
              label: 'ELO',
              value: '$elo',
              color: Colors.amber,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.emoji_events,
              label: 'Siege',
              value: '$wins',
              color: Colors.green,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.trending_up,
              label: 'Winrate',
              value: '$winRate%',
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  icon,
                  size: 80,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 32),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match, bool isHistory) {
    final matchId = match['id'] as String;
    final status = match['status'] as String;
    final questions = match['total_questions'] ?? 10;
    final createdAt = match['created_at'] as String?;
    final canPlay = status == 'active' || status == 'open';
    final isFinished =
        status == 'completed' || status == 'finalized' || status == 'finished';
    final color = _getStatusColor(status);

    // History: Ergebnis laden (vereinfacht - müsste aus DB kommen)
    final didWin = isHistory ? (matchId.hashCode % 2 == 0) : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: color.withOpacity(0.2),
        child: InkWell(
          onTap: isHistory ? null : () => _playMatch(matchId),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Status Badge
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getStatusIcon(status),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '#${matchId.substring(0, 6).toUpperCase()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _getStatusText(status),
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.quiz_outlined,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$questions Fragen',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action/Result
                    if (isHistory)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: didWin!
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              didWin ? Icons.emoji_events : Icons.close,
                              color: didWin ? Colors.green : Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              didWin ? 'Sieg' : 'Niederlage',
                              style: TextStyle(
                                color: didWin ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (canPlay)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Spielen',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (isFinished)
                      Icon(
                        Icons.check_circle,
                        color: Colors.grey.shade400,
                        size: 28,
                      )
                    else
                      Icon(
                        Icons.pending,
                        color: Colors.grey.shade400,
                        size: 24,
                      ),
                  ],
                ),
                // Datum
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(createdAt),
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
        ),
      ),
    );
  }
}
