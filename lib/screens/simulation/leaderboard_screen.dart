import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/async_duel_service.dart';
import '../../services/badge_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _svc = AsyncDuelService();
  final _badgeSvc = BadgeService();

  List<Map<String, dynamic>> _leaderboard = [];
  Map<String, dynamic>? _myStats;
  bool _loading = true;
  int? _myRank;
  Map<String, dynamic>? _meInLeaderboard;

  String get _userId => Supabase.instance.client.auth.currentUser?.id ?? '';

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
      Map<String, dynamic>? meInLb;
      for (int i = 0; i < leaderboard.length; i++) {
        if (leaderboard[i]['user_id'] == _userId) {
          myRank = i + 1;
          meInLb = leaderboard[i];
          break;
        }
      }
      if (!mounted) return;
      setState(() {
        _leaderboard = leaderboard;
        _myStats = myStats;
        _myRank = myRank;
        _meInLeaderboard = meInLb;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _getTier(int elo) {
    if (elo >= 1500) return 'MEISTER';
    if (elo >= 1300) return 'DIAMANT';
    if (elo >= 1150) return 'GOLD';
    if (elo >= 1000) return 'SILBER';
    if (elo >= 850) return 'BRONZE';
    return 'STARTER';
  }

  Color _getTierColor(int elo) {
    if (elo >= 1500) return const Color(0xFFEF4444);
    if (elo >= 1300) return const Color(0xFF22D3EE);
    if (elo >= 1150) return const Color(0xFFF59E0B);
    if (elo >= 1000) return const Color(0xFF94A3B8);
    if (elo >= 850) return const Color(0xFFB45309);
    return const Color(0xFF94A3B8);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    // Nur User anzeigen die tatsächlich Matches gespielt haben
    final activePlayers = _leaderboard
        .where((p) => (p['matches_played'] ?? 0) > 0)
        .toList();

    final top3 = activePlayers.take(3).toList();
    final rest = activePlayers.skip(3).toList();

    // Zeige sticky Row wenn User nicht in Top-100 ist oder weit unten
    final showStickyRow = _myRank != null && _myRank! > 10;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ─── APPBAR ────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: text, size: 22),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Leaderboard',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _loading ? null : _loadData,
                    icon: Icon(Icons.refresh_rounded, color: textMid, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // ─── CONTENT ──────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : activePlayers.isEmpty
                ? _buildEmptyState(textMid, textDim)
                : RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: _loadData,
                    child: ListView(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 8,
                        bottom: showStickyRow ? 120 : 32,
                      ),
                      children: [
                        // TOP 3 PODIUM
                        if (top3.isNotEmpty) ...[
                          _sectionLabel('TOP 3', textDim),
                          const SizedBox(height: 16),
                          _buildPodium(
                            top3,
                            surface,
                            border,
                            text,
                            textMid,
                            textDim,
                          ),
                          const SizedBox(height: 32),
                        ],

                        // RANGLISTE
                        if (rest.isNotEmpty) ...[
                          _sectionLabel(
                            'RANGLISTE · ${activePlayers.length} SPIELER',
                            textDim,
                          ),
                          const SizedBox(height: 12),
                          ...rest.asMap().entries.map((entry) {
                            final rank = entry.key + 4;
                            final player = entry.value;
                            final isMe = player['user_id'] == _userId;
                            return _buildPlayerRow(
                              player: player,
                              rank: rank,
                              isMe: isMe,
                              surface: surface,
                              border: border,
                              text: text,
                              textMid: textMid,
                              textDim: textDim,
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),

      // ─── STICKY USER ROW ──────────────────────────────
      bottomSheet: showStickyRow && _meInLeaderboard != null
          ? Container(
              decoration: BoxDecoration(
                color: surface,
                border: Border(
                  top: BorderSide(color: AppColors.accent.withOpacity(0.4)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'DU BIST HIER',
                        style: AppTextStyles.monoSmall(AppColors.accent),
                      ),
                      const SizedBox(height: 6),
                      _buildPlayerRow(
                        player: _meInLeaderboard!,
                        rank: _myRank!,
                        isMe: true,
                        surface: surface,
                        border: border,
                        text: text,
                        textMid: textMid,
                        textDim: textDim,
                        isSticky: true,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  // ─── SECTION LABEL ────────────────────────────────
  Widget _sectionLabel(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 1, color: AppColors.accent),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.monoLabel(AppColors.accent)),
      ],
    );
  }

  // ─── EMPTY STATE ──────────────────────────────────
  Widget _buildEmptyState(Color textMid, Color textDim) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events_outlined, size: 48, color: textDim),
          const SizedBox(height: 16),
          Text('Noch keine Ranglisten-Daten', style: AppTextStyles.h3(textMid)),
          const SizedBox(height: 4),
          Text(
            'Spiele Matches um hier zu erscheinen.',
            style: AppTextStyles.bodyMedium(textDim),
          ),
        ],
      ),
    );
  }

  // ─── PODIUM (Top 3) ───────────────────────────────
  Widget _buildPodium(
    List<Map<String, dynamic>> top3,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    // Order: [2., 1., 3.]
    final p1 = top3.isNotEmpty ? top3[0] : null;
    final p2 = top3.length > 1 ? top3[1] : null;
    final p3 = top3.length > 2 ? top3[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (p2 != null)
          Expanded(
            child: _podiumCard(
              player: p2,
              rank: 2,
              height: 140,
              surface: surface,
              border: border,
              text: text,
              textMid: textMid,
              textDim: textDim,
            ),
          )
        else
          const Expanded(child: SizedBox()),
        const SizedBox(width: 8),
        if (p1 != null)
          Expanded(
            child: _podiumCard(
              player: p1,
              rank: 1,
              height: 180,
              surface: surface,
              border: border,
              text: text,
              textMid: textMid,
              textDim: textDim,
              isFirst: true,
            ),
          )
        else
          const Expanded(child: SizedBox()),
        const SizedBox(width: 8),
        if (p3 != null)
          Expanded(
            child: _podiumCard(
              player: p3,
              rank: 3,
              height: 120,
              surface: surface,
              border: border,
              text: text,
              textMid: textMid,
              textDim: textDim,
            ),
          )
        else
          const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _podiumCard({
    required Map<String, dynamic> player,
    required int rank,
    required double height,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
    bool isFirst = false,
  }) {
    final username = player['username'] ?? 'Spieler';
    final elo = player['elo_rating'] ?? 0;
    final tierColor = _getTierColor(elo);
    final isMe = player['user_id'] == _userId;

    return GestureDetector(
      onTap: () => _showPlayerProfile(
        player,
        rank,
        surface,
        border,
        text,
        textMid,
        textDim,
      ),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMe
                ? AppColors.accent.withOpacity(0.5)
                : isFirst
                ? tierColor.withOpacity(0.5)
                : border,
            width: isFirst ? 1.5 : 1,
          ),
          // Top-Accent je Rang
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.02, 0.02, 1.0],
            colors: [tierColor, tierColor, surface, surface],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Rang
            Text(
              '#0$rank',
              style: AppTextStyles.mono(
                size: isFirst ? 14 : 12,
                color: tierColor,
                weight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            // Mid: Avatar-Initial in groß (nur bei #1)
            if (isFirst)
              Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: AppTextStyles.instrumentSerif(
                  size: 52,
                  color: tierColor,
                  letterSpacing: -2,
                ),
              ),
            // Bottom: Name + ELO + Tier
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMe ? '$username (Du)' : username,
                  style: AppTextStyles.labelLarge(text),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$elo',
                  style: AppTextStyles.instrumentSerif(
                    size: isFirst ? 22 : 18,
                    color: text,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  _getTier(elo),
                  style: AppTextStyles.mono(
                    size: 9,
                    color: tierColor,
                    weight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── PLAYER ROW ───────────────────────────────────
  Widget _buildPlayerRow({
    required Map<String, dynamic> player,
    required int rank,
    required bool isMe,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
    bool isSticky = false,
  }) {
    final username = player['username'] ?? 'Spieler';
    final elo = player['elo_rating'] ?? 0;
    final tierColor = _getTierColor(elo);

    return Padding(
      padding: EdgeInsets.only(bottom: isSticky ? 0 : 8),
      child: GestureDetector(
        onTap: () => _showPlayerProfile(
          player,
          rank,
          surface,
          border,
          text,
          textMid,
          textDim,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isMe ? AppColors.accent.withOpacity(0.06) : surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isMe ? AppColors.accent.withOpacity(0.4) : border,
            ),
          ),
          child: Row(
            children: [
              // Rank
              SizedBox(
                width: 44,
                child: Text(
                  '#${rank.toString().padLeft(2, '0')}',
                  style: AppTextStyles.mono(
                    size: 13,
                    color: isMe ? AppColors.accent : textDim,
                    weight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Name + Tier
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMe ? '$username (Du)' : username,
                      style: AppTextStyles.labelLarge(text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getTier(elo),
                      style: AppTextStyles.mono(
                        size: 9,
                        color: tierColor,
                        weight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // ELO
              Text(
                '$elo',
                style: AppTextStyles.instrumentSerif(
                  size: 18,
                  color: text,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── PLAYER PROFILE MODAL ─────────────────────────
  void _showPlayerProfile(
    Map<String, dynamic> player,
    int rank,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) async {
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;

    final oderId = player['user_id'] as String?;
    final username = player['username'] ?? 'Spieler';
    final elo = player['elo_rating'] ?? 0;
    final highestElo = player['highest_elo'] ?? elo;
    final wins = player['wins'] ?? 0;
    final losses = player['losses'] ?? 0;
    final draws = player['draws'] ?? 0;
    final matches = player['matches_played'] ?? 0;
    final correctAnswers = player['correct_answers'] ?? 0;
    final isMe = player['user_id'] == _userId;
    final winRate = matches > 0
        ? ((wins / matches) * 100).toStringAsFixed(0)
        : '0';
    final tierColor = _getTierColor(elo);

    List<Map<String, dynamic>> badges = [];
    if (oderId != null) {
      try {
        badges = await _badgeSvc.getUserBadges(oderId);
      } catch (_) {}
    }
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: border)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 3,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: textDim,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Rang + Premium Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tierColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'RANG #${rank.toString().padLeft(2, '0')}',
                    style: AppTextStyles.mono(
                      size: 11,
                      color: tierColor,
                      weight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                if (player['is_premium'] == true) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          color: AppColors.accent,
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'PREMIUM',
                          style: AppTextStyles.mono(
                            size: 11,
                            color: AppColors.accent,
                            weight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: surface,
                border: Border.all(color: tierColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: tierColor.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style: AppTextStyles.instrumentSerif(
                    size: 32,
                    color: tierColor,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Name
            Text(
              isMe ? '$username (Du)' : username,
              style: AppTextStyles.instrumentSerif(
                size: 26,
                color: text,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getTier(elo),
              style: AppTextStyles.mono(
                size: 11,
                color: tierColor,
                weight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Badges
            if (badges.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: badges.map((ub) {
                  final badge = ub['badges'] as Map<String, dynamic>;
                  return Tooltip(
                    message: '${badge['name']}\n${badge['description']}',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            badge['icon'] ?? '🏆',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            badge['name'] ?? '',
                            style: AppTextStyles.labelSmall(text),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // ELO Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'AKTUELL',
                          style: AppTextStyles.monoSmall(textDim),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$elo',
                          style: AppTextStyles.instrumentSerif(
                            size: 28,
                            color: text,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 40, color: border),
                  Expanded(
                    child: Column(
                      children: [
                        Text('PEAK', style: AppTextStyles.monoSmall(textDim)),
                        const SizedBox(height: 4),
                        Text(
                          '$highestElo',
                          style: AppTextStyles.instrumentSerif(
                            size: 28,
                            color: textMid,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _modalStat(
                    '$wins',
                    'SIEGE',
                    AppColors.success,
                    surface,
                    border,
                    textDim,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _modalStat(
                    '$draws',
                    'REMIS',
                    AppColors.warning,
                    surface,
                    border,
                    textDim,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _modalStat(
                    '$losses',
                    'NIEDERL.',
                    AppColors.error,
                    surface,
                    border,
                    textDim,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _modalStat(
                    '$matches',
                    'SPIELE',
                    text,
                    surface,
                    border,
                    textDim,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _modalStat(
                    '$winRate%',
                    'WINRATE',
                    AppColors.accent,
                    surface,
                    border,
                    textDim,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _modalStat(
                    '$correctAnswers',
                    'RICHTIGE',
                    AppColors.accentCyan,
                    surface,
                    border,
                    textDim,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _modalStat(
    String value,
    String label,
    Color color,
    Color surface,
    Color border,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.interTight(
              size: 17,
              weight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.monoSmall(textDim)),
        ],
      ),
    );
  }
}
