import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/async_duel_service.dart';
import '../../services/badge_service.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _svc = AsyncDuelService();
  List<Map<String, dynamic>> _leaderboard = [];
  Map<String, dynamic>? _myStats;
  bool _loading = true;
  int? _myRank;
  final _badgeSvc = BadgeService();

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final leaderboard = await _svc.getLeaderboard(limit: 100);
      final myStats = await _svc.getMyStats();
      int? myRank;
      for (int i = 0; i < leaderboard.length; i++) {
        if (leaderboard[i]['user_id'] == _userId) {
          myRank = i + 1;
          break;
        }
      }
      if (!mounted) return;
      setState(() {
        _leaderboard = leaderboard;
        _myStats = myStats;
        _myRank = myRank;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1: return const Color(0xFFFFD700);
      case 2: return const Color(0xFFC0C0C0);
      case 3: return const Color(0xFFCD7F32);
      default: return _indigo;
    }
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '#$rank';
    }
  }

  String _getEloTier(int elo) {
    if (elo >= 1500) return '🔥 Meister';
    if (elo >= 1300) return '💎 Diamant';
    if (elo >= 1150) return '🥇 Gold';
    if (elo >= 1000) return '🥈 Silber';
    if (elo >= 850) return '🥉 Bronze';
    return '🌱 Starter';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_indigoDark, _indigo, _indigoLight],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rangliste',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              Text('Top Spieler',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _loading ? null : _loadData,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.refresh_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),

                    // Meine Stats
                    if (_myStats != null && !_loading) ...[
                      const SizedBox(height: 16),
                      _buildMyStatsCard(),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // ── LIST ────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: _indigo))
                : _leaderboard.isEmpty
                    ? Center(
                        child: Text(
                          'Noch keine Spieler.\nSpiele ein Match!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding:
                            const EdgeInsets.fromLTRB(16, 16, 16, 32),
                        itemCount: _leaderboard.length,
                        itemBuilder: (ctx, i) {
                          final player = _leaderboard[i];
                          final rank = i + 1;
                          final isMe = player['user_id'] == _userId;
                          return _buildPlayerTile(player, rank, isMe);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyStatsCard() {
    final elo = _myStats?['elo_rating'] ?? 1000;
    final wins = _myStats?['wins'] ?? 0;
    final losses = _myStats?['losses'] ?? 0;
    final draws = _myStats?['draws'] ?? 0;
    final matches = _myStats?['matches_played'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dein Rang',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
                _myRank != null ? '#$_myRank' : '–',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(
              width: 1, height: 40, color: Colors.white30),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _headerStat('$elo', 'ELO'),
                _headerStat('$wins', 'Siege'),
                _headerStat('$draws', 'Remis'),
                _headerStat('$losses', 'Niederl.'),
                _headerStat('$matches', 'Spiele'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        Text(label,
            style:
                const TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }

  Widget _buildPlayerTile(
      Map<String, dynamic> player, int rank, bool isMe) {
    final username = player['username'] ?? 'Spieler';
    final elo = player['elo_rating'] ?? 1000;
    final wins = player['wins'] ?? 0;
    final losses = player['losses'] ?? 0;
    final draws = player['draws'] ?? 0;
    final rankColor = _getRankColor(rank);

    return GestureDetector(
      onTap: () => _showPlayerProfile(player, rank),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? _indigo.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isMe ? _indigo.withOpacity(0.3) : Colors.grey.shade100,
            width: isMe ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: rank <= 3
                    ? rankColor.withOpacity(0.15)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: rank <= 3
                    ? Text(_getRankEmoji(rank),
                        style: const TextStyle(fontSize: 20))
                    : Text('$rank',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
              ),
            ),
            const SizedBox(width: 12),

            // Name + tier
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMe ? '$username (Du)' : username,
                    style: TextStyle(
                        fontWeight: isMe
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${_getEloTier(elo)}  •  $wins S / $draws U / $losses N',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ),

            // ELO chip
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _indigo.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$elo',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _indigo,
                    fontSize: 14),
              ),
            ),

            if (rank <= 3) ...[
              const SizedBox(width: 8),
              Icon(Icons.emoji_events_rounded,
                  color: rankColor, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  void _showPlayerProfile(
      Map<String, dynamic> player, int rank) async {
    final oderId = player['user_id'] as String?;
    final username = player['username'] ?? 'Spieler';
    final elo = player['elo_rating'] ?? 1000;
    final highestElo = player['highest_elo'] ?? 1000;
    final wins = player['wins'] ?? 0;
    final losses = player['losses'] ?? 0;
    final draws = player['draws'] ?? 0;
    final matches = player['matches_played'] ?? 0;
    final correctAnswers = player['correct_answers'] ?? 0;
    final isMe = player['user_id'] == _userId;
    final winRate = matches > 0
        ? ((wins / matches) * 100).toStringAsFixed(1)
        : '0.0';

    List<Map<String, dynamic>> badges = [];
    if (oderId != null) {
      badges = await _badgeSvc.getUserBadges(oderId);
    }
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [_getRankColor(rank), _indigo]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _indigo.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  username.isNotEmpty
                      ? username[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (rank <= 3)
                  Text(_getRankEmoji(rank),
                      style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 6),
                Text(
                  isMe ? '$username (Du)' : username,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text('Rang #$rank  •  ${_getEloTier(elo)}',
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 14)),
            const SizedBox(height: 20),

            // Badges
            if (badges.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: badges.map((ub) {
                  final badge =
                      ub['badges'] as Map<String, dynamic>;
                  return Tooltip(
                    message:
                        '${badge['name']}\n${badge['description']}',
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.amber.shade200),
                      ),
                      child: Text(badge['icon'] ?? '🏆',
                          style:
                              const TextStyle(fontSize: 20)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ELO Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_indigoDark, _indigo]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    const Text('Aktuell',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    Text('$elo',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                  ]),
                  Container(
                      width: 1,
                      height: 36,
                      color: Colors.white24),
                  Column(children: [
                    const Text('Höchstes',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    Text('$highestElo',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats Grid
            Row(children: [
              Expanded(
                  child: _statCard('$wins', 'Siege', Colors.green)),
              const SizedBox(width: 8),
              Expanded(
                  child: _statCard(
                      '$draws', 'Remis', Colors.orange)),
              const SizedBox(width: 8),
              Expanded(
                  child:
                      _statCard('$losses', 'Niederl.', Colors.red)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                  child:
                      _statCard('$matches', 'Spiele', Colors.blue)),
              const SizedBox(width: 8),
              Expanded(
                  child: _statCard(
                      '$winRate%', 'Siegquote', Colors.purple)),
              const SizedBox(width: 8),
              Expanded(
                  child: _statCard(
                      '$correctAnswers', 'Richtige', Colors.teal)),
            ]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}