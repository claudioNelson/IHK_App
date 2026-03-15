import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/async_duel_service.dart';
import '../simulation/async_match_play_screen.dart';
import '../../services/badge_service.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);
const _purple = Color(0xFF7C3AED);
const _purpleLight = Color(0xFF8B5CF6);

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
  final _badgeSvc = BadgeService();

  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _stats;
  List<Map<String, dynamic>> _matchHistory = [];
  Map<String, Map<String, dynamic>> _matchScores = {};
  List<Map<String, dynamic>> _userBadges = [];
  bool _loading = true;
  bool _challenging = false;

  String get _myId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final client = Supabase.instance.client;
      final profile = await client
          .from('profiles')
          .select('id, username, avatar_url, created_at')
          .eq('id', widget.oderId)
          .maybeSingle();
      final stats = await client
          .from('player_stats')
          .select('elo_rating, wins, losses, draws, matches_played, highest_elo')
          .eq('user_id', widget.oderId)
          .maybeSingle();
      final matches = await _svc.getMatchesWithPlayer(widget.oderId);
      final matchIds = matches.map((m) => m['id'] as String).toList();
      final scores = await _svc.getMatchScores(matchIds);
      final badges = await _badgeSvc.getUserBadges(widget.oderId);

      if (!mounted) return;
      setState(() {
        _profile = profile;
        _stats = stats;
        _matchHistory = matches;
        _matchScores = scores;
        _userBadges = badges;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return 'Unbekannt';
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day}.${date.month}.${date.year}';
    } catch (_) {
      return 'Unbekannt';
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

  Future<void> _challengePlayer() async {
    setState(() => _challenging = true);
    try {
      final matchId = await _svc.createMatch(count: 10);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AsyncMatchPlayPage(matchId: matchId)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => _challenging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _profile?['username'] ?? widget.username;
    final avatarUrl = _profile?['avatar_url'] as String?;
    final elo = _stats?['elo_rating'] ?? 1000;
    final wins = _stats?['wins'] ?? 0;
    final losses = _stats?['losses'] ?? 0;
    final draws = _stats?['draws'] ?? 0;
    final highestElo = _stats?['highest_elo'] ?? 1000;
    final matches = _stats?['matches_played'] ?? 0;
    final winRate =
        matches > 0 ? ((wins / matches) * 100).toStringAsFixed(1) : '0.0';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _indigo))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ── HEADER ──────────────────────────────────────
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_indigoDark, _indigo, _purple],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        child: Column(
                          children: [
                            // Back Button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
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
                            ),
                            const SizedBox(height: 16),

                            // Avatar
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: avatarUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(avatarUrl),
                                        fit: BoxFit.cover)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: avatarUrl == null
                                  ? Center(
                                      child: Text(
                                        username.isNotEmpty
                                            ? username[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontSize: 32,
                                          color: _indigo,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              username,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Dabei seit ${_formatDate(_profile?['created_at'])}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 12),
                            // Tier chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getEloTier(elo),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── ELO BOX ───────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [_indigoDark, _indigo]),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _indigo.withOpacity(0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _eloStat('$elo', 'Aktuell'),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white24),
                              _eloStat('$highestElo', 'Höchstes'),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white24),
                              _eloStat('$matches', 'Spiele'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── STATS GRID ─────────────────────────────
                        Row(children: [
                          Expanded(
                              child: _statCard('$wins', 'Siege', Colors.green)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _statCard(
                                  '$draws', 'Remis', Colors.orange)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _statCard(
                                  '$losses', 'Niederl.', Colors.red)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _statCard(
                                  '$winRate%', 'Winrate', _purple)),
                        ]),

                        const SizedBox(height: 20),

                        // ── BADGES ────────────────────────────────
                        if (_userBadges.isNotEmpty) ...[
                          _sectionTitle('Badges',
                              Icons.military_tech_rounded, Colors.amber),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.amber.withOpacity(0.2),
                                  width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: _userBadges.map((ub) {
                                final badge =
                                    ub['badges'] as Map<String, dynamic>;
                                return Tooltip(
                                  message:
                                      '${badge['name']}\n${badge['description']}',
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade50,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.amber.shade200),
                                    ),
                                    child: Text(badge['icon'] ?? '🏆',
                                        style: const TextStyle(
                                            fontSize: 24)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ── MATCH HISTORY ─────────────────────────
                        _sectionTitle(
                          'Gemeinsame Matches (${_matchHistory.length})',
                          Icons.history_rounded,
                          _purple,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _purple.withOpacity(0.1),
                                width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: _purple.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: _matchHistory.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(Icons.sports_esports_outlined,
                                            size: 44,
                                            color: Colors.grey.shade300),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Noch keine Matches zusammen',
                                          style: TextStyle(
                                              color: Colors.grey.shade500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: _matchHistory
                                      .asMap()
                                      .entries
                                      .map((e) => Column(
                                            children: [
                                              _buildMatchTile(e.value),
                                              if (e.key <
                                                  _matchHistory.length - 1)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 70),
                                                  child: Divider(
                                                      height: 1,
                                                      color: Colors
                                                          .grey.shade100),
                                                ),
                                            ],
                                          ))
                                      .toList(),
                                ),
                        ),

                        const SizedBox(height: 24),

                        // ── CHALLENGE BUTTON ──────────────────────
                        GestureDetector(
                          onTap: _challenging ? null : _challengePlayer,
                          child: Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [_purple, _purpleLight]),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _purple.withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: _challenging
                                ? const Center(
                                    child: SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                          Icons.sports_kabaddi_rounded,
                                          color: Colors.white,
                                          size: 22),
                                      const SizedBox(width: 10),
                                      Text(
                                        '$username herausfordern',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _eloStat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style:
                const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: Colors.grey.shade500),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 10),
        Icon(icon, color: color, size: 17),
        const SizedBox(width: 6),
        Text(title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMatchTile(Map<String, dynamic> match) {
    final matchId = match['id'] as String;
    final status = match['status'] as String;
    final createdAt = match['created_at'] as String?;
    final isFinished = status == 'completed' ||
        status == 'finalized' ||
        status == 'finished';

    bool? didWin;
    int? myScore;
    int? opponentScore;

    if (isFinished && _matchScores.containsKey(matchId)) {
      final score = _matchScores[matchId]!;
      final isP1 = score['player1_id'] == _myId;
      myScore = isP1 ? score['player1_score'] : score['player2_score'];
      opponentScore =
          isP1 ? score['player2_score'] : score['player1_score'];
      didWin = myScore! > opponentScore!;
    }

    final resultColor = didWin == null
        ? Colors.grey
        : didWin
            ? Colors.green
            : Colors.red;
    final resultIcon = didWin == null
        ? Icons.pending_rounded
        : didWin
            ? Icons.emoji_events_rounded
            : Icons.close_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(resultIcon, color: resultColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${matchId.substring(0, 6).toUpperCase()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  _formatDate(createdAt),
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ),
          if (didWin != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: resultColor.withOpacity(0.25)),
              ),
              child: Text(
                '$myScore : $opponentScore',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: resultColor,
                    fontSize: 13),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status == 'active' ? 'Aktiv' : 'Offen',
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}