import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/async_duel_service.dart';

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
      
      // Finde meine Position
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
      print('❌ Fehler beim Laden: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.orange.shade700;
      default:
        return Colors.indigo;
    }
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
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
      appBar: AppBar(
        title: const Text('🏆 Rangliste'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _loadData,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Meine Stats oben
                if (_myStats != null) _buildMyStatsCard(),
                
                const Divider(height: 1),
                
                // Rangliste
                Expanded(
                  child: _leaderboard.isEmpty
                      ? const Center(
                          child: Text('Noch keine Spieler in der Rangliste.\nSpiele ein Match!'),
                        )
                      : ListView.builder(
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
    final highestElo = _myStats?['highest_elo'] ?? 1000;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.indigo.shade500],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dein Ranking',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    _myRank != null ? '#$_myRank' : 'Nicht gerankt',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _getEloTier(elo),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    '$elo Elo',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatBadge('$wins', 'Siege', Colors.green),
              _buildStatBadge('$draws', 'Remis', Colors.orange),
              _buildStatBadge('$losses', 'Niederl.', Colors.red),
              _buildStatBadge('$matches', 'Spiele', Colors.blue),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Höchstes Elo: $highestElo',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }

 Widget _buildPlayerTile(Map<String, dynamic> player, int rank, bool isMe) {
  final username = player['username'] ?? 'Spieler';
  final elo = player['elo_rating'] ?? 1000;
  final wins = player['wins'] ?? 0;
  final losses = player['losses'] ?? 0;
  final draws = player['draws'] ?? 0;
  final matches = player['matches_played'] ?? 0;

  return Container(
    color: isMe ? Colors.indigo.withOpacity(0.1) : null,
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: _getRankColor(rank),
        child: rank <= 3
            ? Text(_getRankEmoji(rank), style: const TextStyle(fontSize: 20))
            : Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              isMe ? '$username (Du)' : username,
              style: TextStyle(
                fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$elo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade700,
              ),
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Text('$wins', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          const Text(' S', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const Text(' / ', style: TextStyle(color: Colors.grey)),
          Text('$draws', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          const Text(' U', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const Text(' / ', style: TextStyle(color: Colors.grey)),
          Text('$losses', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const Text(' N', style: TextStyle(fontSize: 12, color: Colors.grey)),
          Text(' • $matches Spiele', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
      trailing: rank <= 3
          ? Icon(Icons.emoji_events, color: _getRankColor(rank))
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showPlayerProfile(player, rank),
    ),
  );
}

void _showPlayerProfile(Map<String, dynamic> player, int rank) {
  final username = player['username'] ?? 'Spieler';
  final elo = player['elo_rating'] ?? 1000;
  final highestElo = player['highest_elo'] ?? 1000;
  final wins = player['wins'] ?? 0;
  final losses = player['losses'] ?? 0;
  final draws = player['draws'] ?? 0;
  final matches = player['matches_played'] ?? 0;
  final correctAnswers = player['correct_answers'] ?? 0;
  final isMe = player['user_id'] == _userId;

  final winRate = matches > 0 ? ((wins / matches) * 100).toStringAsFixed(1) : '0.0';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Avatar & Name
          CircleAvatar(
            radius: 40,
            backgroundColor: _getRankColor(rank),
            child: Text(
              username.isNotEmpty ? username[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (rank <= 3) Text(_getRankEmoji(rank), style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                isMe ? '$username (Du)' : username,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            'Rang #$rank • ${_getEloTier(elo)}',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // Elo Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade600, Colors.indigo.shade400],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Aktuell', style: TextStyle(color: Colors.white70)),
                    Text('$elo', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(width: 1, height: 40, color: Colors.white24),
                Column(
                  children: [
                    const Text('Höchstes', style: TextStyle(color: Colors.white70)),
                    Text('$highestElo', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats Grid
          Row(
            children: [
              Expanded(child: _buildStatCard('$wins', 'Siege', Colors.green)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('$draws', 'Remis', Colors.orange)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('$losses', 'Niederl.', Colors.red)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('$matches', 'Spiele', Colors.blue)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('$winRate%', 'Siegquote', Colors.purple)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('$correctAnswers', 'Richtige', Colors.teal)),
            ],
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

Widget _buildStatCard(String value, String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}
}