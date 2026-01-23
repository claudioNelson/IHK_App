import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/async_duel_service.dart';
import '../simulation/async_match_play_screen.dart';
import '../../services/badge_service.dart';

class PlayerProfileScreen extends StatefulWidget {
  final String oderId;
  final String username;

  const PlayerProfileScreen({
    super.key,
    required this.oderId,
    required this.username,
  });

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  final _svc = AsyncDuelService();
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _stats;
  List<Map<String, dynamic>> _matchHistory = [];
  Map<String, Map<String, dynamic>> _matchScores = {};
  bool _loading = true;

  final _badgeSvc = BadgeService();
  List<Map<String, dynamic>> _userBadges = [];

  String get _myId => Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final client = Supabase.instance.client;

      // Profil laden
      final profile = await client
          .from('profiles')
          .select('id, username, avatar_url, created_at')
          .eq('id', widget.oderId)
          .maybeSingle();

      // Stats laden
      final stats = await client
          .from('player_stats')
          .select('elo_rating, wins, losses')
          .eq('user_id', widget.oderId)
          .maybeSingle();

      // Gemeinsame Matches laden
      final matches = await _svc.getMatchesWithPlayer(widget.oderId);

      // Scores laden
      final matchIds = matches.map((m) => m['id'] as String).toList();
      final scores = await _svc.getMatchScores(matchIds);
      // Badges laden
      final badges = await _badgeSvc.getUserBadges(widget.oderId);

      if (!mounted) return;
      setState(() {
        _profile = profile;
        _stats = stats;
        _matchHistory = matches;
        _matchScores = scores;
        _loading = false;
        _userBadges = badges;
      });
    } catch (e) {
      print('❌ Fehler: $e');
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return 'Unbekannt';
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return 'Unbekannt';
    }
  }

  Future<void> _challengePlayer() async {
    print('🎯🎯🎯 CHALLENGE BUTTON GEKLICKT 🎯🎯🎯');
    setState(() => _loading = true);
    try {
      final client = Supabase.instance.client;
      final oderId = client.auth.currentUser?.id;
      if (oderId == null) throw Exception('Nicht eingeloggt');

      final matchId = await _svc.createMatch(count: 10);
      print('🎯 Match erstellt: $matchId');

      if (!mounted) return;

      // Direkt ins Match navigieren
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AsyncMatchPlayPage(matchId: matchId)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _profile?['username'] ?? widget.username;
    final avatarUrl = _profile?['avatar_url'] as String?;
    final elo = _stats?['elo_rating'] ?? 1000;
    final wins = _stats?['wins'] ?? 0;
    final losses = _stats?['losses'] ?? 0;
    final total = wins + losses;
    final winRate = total > 0 ? ((wins / total) * 100).toInt() : 0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Spieler-Profil'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.indigo.shade700,
                          Colors.purple.shade600,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl == null
                              ? Text(
                                  username.isNotEmpty
                                      ? username[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dabei seit ${_formatDate(_profile?['created_at'])}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Statistiken',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    icon: Icons.star,
                                    label: 'ELO',
                                    value: '$elo',
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    icon: Icons.emoji_events,
                                    label: 'Siege',
                                    value: '$wins',
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    icon: Icons.close,
                                    label: 'Niederlagen',
                                    value: '$losses',
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    icon: Icons.percent,
                                    label: 'Winrate',
                                    value: '$winRate%',
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Match History mit diesem Spieler
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.history, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Gemeinsame Matches',
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
                                    '${_matchHistory.length}',
                                    style: TextStyle(
                                      color: Colors.purple.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_matchHistory.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.sports_esports_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Noch keine Matches zusammen',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ...(_matchHistory.map((m) => _buildMatchTile(m))),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Badges
                  if (_userBadges.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.military_tech,
                                    size: 20,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Badges',
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
                                      color: Colors.amber.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${_userBadges.length}',
                                      style: TextStyle(
                                        color: Colors.amber.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: _userBadges.map((ub) {
                                  final badge =
                                      ub['badges'] as Map<String, dynamic>;
                                  return Tooltip(
                                    message:
                                        '${badge['name']}\n${badge['description']}',
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.amber.shade200,
                                        ),
                                      ),
                                      child: Text(
                                        badge['icon'] ?? '🏆',
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Challenge Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _challengePlayer,
                        icon: const Icon(Icons.sports_kabaddi),
                        label: Text('$username herausfordern'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchTile(Map<String, dynamic> match) {
    final matchId = match['id'] as String;
    final status = match['status'] as String;
    final createdAt = match['created_at'] as String?;
    final isFinished =
        status == 'completed' || status == 'finalized' || status == 'finished';

    bool? didWin;
    int? myScore;
    int? opponentScore;

    if (isFinished && _matchScores.containsKey(matchId)) {
      final score = _matchScores[matchId]!;
      final isPlayer1 = score['player1_id'] == _myId;
      myScore = isPlayer1 ? score['player1_score'] : score['player2_score'];
      opponentScore = isPlayer1
          ? score['player2_score']
          : score['player1_score'];
      didWin = myScore! > opponentScore!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: didWin == null
                  ? Colors.grey.shade200
                  : (didWin ? Colors.green.shade100 : Colors.red.shade100),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              didWin == null
                  ? Icons.pending
                  : (didWin ? Icons.emoji_events : Icons.close),
              color: didWin == null
                  ? Colors.grey
                  : (didWin ? Colors.green : Colors.red),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${matchId.substring(0, 6).toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _formatDate(createdAt),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          // Score
          if (didWin != null)
            Text(
              '$myScore : $opponentScore',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: didWin ? Colors.green : Colors.red,
              ),
            )
          else
            Text(
              status == 'active' ? 'Aktiv' : 'Offen',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
        ],
      ),
    );
  }
}
