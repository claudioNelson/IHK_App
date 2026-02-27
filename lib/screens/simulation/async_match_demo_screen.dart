import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/async_duel_service.dart';
import 'leaderboard_screen.dart';
import 'async_match_play_screen.dart';
import '../profile/player_profile_screen.dart';
import '../../../services/app_cache_service.dart';

const _orange = Color(0xFF3949AB); // Indigo
const _orangeDark = Color(0xFF283593); // Indigo Dark
const _gold = Color(0xFFFFD700);

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
  Map<String, Map<String, dynamic>> _matchScores = {};
  List<Map<String, dynamic>> _openMatches = [];

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'local';

  @override
  void initState() {
    super.initState();
    final cacheService = AppCacheService();
    if (cacheService.matchesLoaded) {
      _activeMatches = List.from(cacheService.cachedActiveMatches);
      _historyMatches = List.from(cacheService.cachedHistoryMatches);
      _myStats = cacheService.cachedMyStats;
      _matchScores = Map.from(cacheService.cachedMatchScores);
    } else {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _busy = true);
    try {
      final matches = await _svc.getMyMatches();
      final stats = await _svc.getMyStats();
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
      final historyIds = history.map((m) => m['id'] as String).toList();
      final scores = await _svc.getMatchScores(historyIds);
      if (!mounted) return;
      setState(() {
        _activeMatches = active;
        _historyMatches = history;
        _myStats = stats;
        _matchScores = scores;
      });
    } catch (e) {
      print('❌ Fehler: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createMatch() async {
    setState(() => _busy = true);
    try {
      final id = await _svc.createMatch(count: 10);
      await _loadData();
      if (!mounted) return;
      _playMatch(id);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Fehler: $e', Colors.red);
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
        _showSnack('😕 Kein offenes Match gefunden', Colors.orange);
        return;
      }
      await _loadData();
      if (!mounted) return;
      _playMatch(id);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Fehler: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showOpenMatches() async {
    setState(() => _busy = true);
    try {
      final matches = await _svc.getOpenMatches();
      setState(() => _openMatches = matches);
      if (!mounted) return;
      _showOpenMatchesSheet();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Fehler: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _playMatch(String matchId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AsyncMatchPlayPage(matchId: matchId)),
    ).then((_) => _loadData());
  }

  void _showOpenMatchesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.people, color: _orange),
                  const SizedBox(width: 12),
                  const Text(
                    'Offene Matches',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _joinRandom();
                    },
                    icon: Icon(Icons.shuffle, size: 18, color: _orange),
                    label: Text('Zufällig', style: TextStyle(color: _orange)),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: _openMatches.isEmpty
                  ? Center(
                      child: Text(
                        'Keine offenen Matches',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _openMatches.length,
                      itemBuilder: (_, i) =>
                          _buildOpenMatchTile(_openMatches[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenMatchTile(Map<String, dynamic> match) {
    final matchId = match['id'] as String;
    final questions = match['total_questions'] ?? 10;
    final createdAt = match['created_at'] as String?;
    final creator = match['creator'] as Map<String, dynamic>?;
    final creatorName = creator?['username'] ?? 'Unbekannt';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: _orange.withOpacity(0.1),
              child: Text(
                creatorName.isNotEmpty ? creatorName[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: _orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    creatorName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$questions Fragen • ${_formatDate(createdAt)}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _joinMatch(matchId),
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Beitreten'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinMatch(String matchId) async {
    Navigator.pop(context);
    setState(() => _busy = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('Nicht eingeloggt');
      await Supabase.instance.client
          .from('matches')
          .update({
            'player2_id': userId,
            'status': 'active',
            'started_at': DateTime.now().toIso8601String(),
          })
          .eq('id', matchId)
          .eq('status', 'open');
      await _loadData();
      if (!mounted) return;
      _playMatch(matchId);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Fehler: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 1) return 'Gerade eben';
      if (diff.inMinutes < 60) return 'vor ${diff.inMinutes} Min';
      if (diff.inHours < 24) return 'vor ${diff.inHours}h';
      if (diff.inDays == 1) return 'Gestern';
      if (diff.inDays < 7) return 'vor ${diff.inDays} Tagen';
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return '';
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'open':
        return 'Offen';
      case 'active':
        return 'Aktiv';
      case 'waiting':
        return 'Wartet';
      default:
        return 'Beendet';
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
      default:
        return Colors.purple;
    }
  }

  String _getTier(int elo) {
    if (elo >= 1500) return '🔥 Meister';
    if (elo >= 1300) return '💎 Diamant';
    if (elo >= 1150) return '🥇 Gold';
    if (elo >= 1000) return '🥈 Silber';
    return '🥉 Bronze';
  }

  @override
  Widget build(BuildContext context) {
    final elo = _myStats?['elo_rating'] ?? 1000;
    final wins = _myStats?['wins'] ?? 0;
    final losses = _myStats?['losses'] ?? 0;
    final draws = _myStats?['draws'] ?? 0;
    final total = wins + losses + draws;
    final winRate = total > 0 ? ((wins / total) * 100).toInt() : 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: _orange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER ─────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_orange, _orangeDark],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _orange.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titel Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Match Arena',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Fordere andere heraus',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LeaderboardScreen(),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.emoji_events,
                                  color: _gold,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Stats Row
                        Row(
                          children: [
                            _buildHeaderStat('$elo', 'ELO', Colors.white),
                            _buildHeaderDivider(),
                            _buildHeaderStat('$wins', 'Siege', Colors.white),
                            _buildHeaderDivider(),
                            _buildHeaderStat(
                              '$losses',
                              'Niederl.',
                              Colors.white,
                            ),
                            _buildHeaderDivider(),
                            _buildHeaderStat(
                              '$winRate%',
                              'Winrate',
                              Colors.white,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Tier
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getTier(elo),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── 3 ACTION BUTTONS ───────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionBtn(
                        icon: Icons.add_rounded,
                        label: 'Erstellen',
                        color: Color(0xFF3949AB),
                        onTap: _busy ? null : _createMatch,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionBtn(
                        icon: Icons.search_rounded,
                        label: 'Beitreten',
                        color: Color(0xFF3949AB),
                        onTap: _busy ? null : _showOpenMatches,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionBtn(
                        icon: Icons.shuffle_rounded,
                        label: 'Zufällig',
                        color: Color(0xFF3949AB),
                        onTap: _busy ? null : _joinRandom,
                      ),
                    ),
                  ],
                ),
              ),

              if (_busy)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      color: _orange,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // ── AKTIVE MATCHES ─────────────────────────────
              _buildSectionHeader(
                'Aktive Matches',
                _activeMatches.length,
                Colors.green,
              ),
              const SizedBox(height: 10),

              if (_activeMatches.isEmpty)
                _buildEmptyState(
                  icon: Icons.sports_esports_outlined,
                  title: 'Keine aktiven Matches',
                  sub: 'Erstelle ein Match oder tritt einem bei!',
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _activeMatches.length,
                  itemBuilder: (_, i) =>
                      _buildMatchCard(_activeMatches[i], false),
                ),

              const SizedBox(height: 20),

              // ── HISTORY ────────────────────────────────────
              if (_historyMatches.isNotEmpty) ...[
                GestureDetector(
                  onTap: () =>
                      setState(() => _historyExpanded = !_historyExpanded),
                  child: _buildSectionHeader(
                    'Match History',
                    _historyMatches.length,
                    Colors.purple,
                    trailing: Icon(
                      _historyExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_historyExpanded)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _historyMatches.length,
                    itemBuilder: (_, i) =>
                        _buildMatchCard(_historyMatches[i], true),
                  ),
              ],

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderDivider() {
    return Container(width: 1, height: 32, color: Colors.white30);
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    int count,
    Color color, {
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String sub,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
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
    final statusColor = _getStatusColor(status);

    bool? didWin;
    int? myScore;
    int? opponentScore;

    if (isHistory && _matchScores.containsKey(matchId)) {
      final score = _matchScores[matchId]!;
      final isPlayer1 = score['player1_id'] == _userId;
      myScore = isPlayer1 ? score['player1_score'] : score['player2_score'];
      opponentScore = isPlayer1
          ? score['player2_score']
          : score['player1_score'];
      didWin = myScore! > opponentScore!;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: isHistory ? null : () => _playMatch(matchId),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  canPlay ? Icons.play_arrow_rounded : Icons.check_rounded,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
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
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getStatusText(status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$questions Fragen  •  ${_formatDate(createdAt)}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              if (isHistory && didWin != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: (didWin ? Colors.green : Colors.red).withOpacity(
                      0.08,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: (didWin ? Colors.green : Colors.red).withOpacity(
                        0.3,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        didWin ? 'Sieg' : 'Niederlage',
                        style: TextStyle(
                          color: didWin ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$myScore:$opponentScore',
                        style: TextStyle(
                          color: didWin ? Colors.green : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else if (canPlay)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _orange,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Spielen',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
}
