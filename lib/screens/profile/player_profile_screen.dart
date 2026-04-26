import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/async_duel_service.dart';
import '../simulation/async_match_play_screen.dart';
import '../../services/badge_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

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

  String get _myId => Supabase.instance.client.auth.currentUser?.id ?? '';

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
          .select(
            'id, username, avatar_url, created_at, is_premium, premium_tier',
          )
          .eq('id', widget.oderId)
          .maybeSingle();
      final stats = await client
          .from('player_stats')
          .select(
            'elo_rating, wins, losses, draws, matches_played, highest_elo',
          )
          .eq('user_id', widget.oderId)
          .maybeSingle();
      final matches = await _svc.getMatchesWithPlayer(widget.oderId);
      final matchIds = matches.map((m) => m['id'] as String).toList();
      final scores = await _svc.getMatchScores(matchIds);
      final badges = await _badgeSvc.getUserBadges(widget.oderId);

      if (!mounted) return;
      print('🔍 DEBUG Player Profile: $profile'); // ← NEU
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
    if (timestamp == null) return '—';
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (_) {
      return '—';
    }
  }

  String _getEloTier(int elo) {
    if (elo >= 1500) return 'MEISTER';
    if (elo >= 1300) return 'DIAMANT';
    if (elo >= 1150) return 'GOLD';
    if (elo >= 1000) return 'SILBER';
    if (elo >= 850) return 'BRONZE';
    return 'STARTER';
  }

  Color _getEloColor(int elo) {
    if (elo >= 1500) return AppColors.error;
    if (elo >= 1300) return AppColors.accentCyan;
    if (elo >= 1150) return AppColors.warning;
    if (elo >= 1000) return AppColors.accent;
    if (elo >= 850) return AppColors.success;
    return AppColors.accent;
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
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _challenging = false);
    }
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

    final username = _profile?['username'] ?? widget.username;
    final avatarUrl = _profile?['avatar_url'] as String?;
    final elo = _stats?['elo_rating'] ?? 1000;
    final wins = _stats?['wins'] ?? 0;
    final losses = _stats?['losses'] ?? 0;
    final draws = _stats?['draws'] ?? 0;
    final highestElo = _stats?['highest_elo'] ?? 1000;
    final matches = _stats?['matches_played'] ?? 0;
    final winRate = matches > 0
        ? ((wins / matches) * 100).toStringAsFixed(0)
        : '0';

    final tierColor = _getEloColor(elo);
    final tierLabel = _getEloTier(elo);

    return Scaffold(
      backgroundColor: bg,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : SafeArea(
              child: Column(
                children: [
                  // ─── APPBAR ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: text,
                            size: 22,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'PROFIL',
                            style: AppTextStyles.monoLabel(textMid),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─── HEADER ────────────────────────────
                          _buildHeader(
                            username,
                            avatarUrl,
                            tierLabel,
                            tierColor,
                            surface,
                            border,
                            text,
                            textMid,
                            textDim,
                          ),

                          const SizedBox(height: 28),

                          // ─── ELO STATS ─────────────────────────
                          _buildEloStats(
                            elo,
                            highestElo,
                            matches,
                            surface,
                            border,
                            text,
                            textMid,
                            textDim,
                          ),

                          const SizedBox(height: 28),

                          // ─── BILANZ ────────────────────────────
                          _buildSectionLabel(
                            'BILANZ',
                            AppColors.accent,
                            textMid,
                          ),
                          const SizedBox(height: 14),
                          _buildBalanceRow(
                            wins,
                            draws,
                            losses,
                            winRate,
                            surface,
                            border,
                            text,
                            textMid,
                            textDim,
                          ),

                          // ─── BADGES ────────────────────────────
                          if (_userBadges.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            _buildSectionLabel(
                              'BADGES · ${_userBadges.length}',
                              AppColors.warning,
                              textMid,
                            ),
                            const SizedBox(height: 14),
                            _buildBadges(surface, border, text, textMid),
                          ],

                          const SizedBox(height: 28),

                          // ─── MATCH HISTORY ─────────────────────
                          _buildSectionLabel(
                            'GEMEINSAME MATCHES · ${_matchHistory.length}',
                            AppColors.accentCyan,
                            textMid,
                          ),
                          const SizedBox(height: 14),
                          _buildMatchHistory(
                            surface,
                            border,
                            text,
                            textMid,
                            textDim,
                          ),

                          const SizedBox(height: 28),

                          // ─── CHALLENGE BUTTON ──────────────────
                          _buildChallengeButton(
                            username,
                            text,
                            textMid,
                            surface,
                            border,
                            bg,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ─── HEADER ──────────────────────────────────
  Widget _buildHeader(
    String username,
    String? avatarUrl,
    String tierLabel,
    Color tierColor,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: surface,
            border: Border.all(color: border, width: 1.5),
            image: avatarUrl != null
                ? DecorationImage(
                    image: NetworkImage(avatarUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: avatarUrl == null
              ? Center(
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: AppTextStyles.instrumentSerif(
                      size: 32,
                      color: text,
                      letterSpacing: -1,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 16),
        // Badges Row: Tier + Premium
        Row(
          children: [
            // Tier Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: tierColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: tierColor.withOpacity(0.3)),
              ),
              child: Text(
                tierLabel,
                style: AppTextStyles.mono(
                  size: 10,
                  color: tierColor,
                  weight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            // Premium Badge (nur wenn Premium)
            if (_profile?['is_premium'] == true) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
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
                        size: 10,
                        color: AppColors.accent,
                        weight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),

        // Username
        Text(
          username,
          style: AppTextStyles.instrumentSerif(
            size: 36,
            color: text,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 4),

        // Created date
        Text(
          'Dabei seit ${_formatDate(_profile?['created_at'])}',
          style: AppTextStyles.bodySmall(textMid),
        ),
      ],
    );
  }

  // ─── ELO STATS ───────────────────────────────
  Widget _buildEloStats(
    int elo,
    int highestElo,
    int matches,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.accent, AppColors.accent, surface, surface],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _eloStatItem(
              '$elo',
              'AKTUELL',
              AppColors.accent,
              text,
              textDim,
            ),
          ),
          Container(width: 1, height: 44, color: border),
          Expanded(
            child: _eloStatItem('$highestElo', 'HÖCHSTES', text, text, textDim),
          ),
          Container(width: 1, height: 44, color: border),
          Expanded(
            child: _eloStatItem('$matches', 'SPIELE', textMid, text, textDim),
          ),
        ],
      ),
    );
  }

  Widget _eloStatItem(
    String value,
    String label,
    Color valueColor,
    Color text,
    Color textDim,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.instrumentSerif(
            size: 32,
            color: valueColor,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.monoSmall(textDim)),
      ],
    );
  }

  // ─── BILANZ ──────────────────────────────────
  Widget _buildBalanceRow(
    int wins,
    int draws,
    int losses,
    String winRate,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Row(
      children: [
        Expanded(
          child: _balanceItem(
            '$wins',
            'SIEGE',
            AppColors.success,
            surface,
            border,
            text,
            textDim,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _balanceItem(
            '$draws',
            'REMIS',
            AppColors.warning,
            surface,
            border,
            text,
            textDim,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _balanceItem(
            '$losses',
            'NIEDERL.',
            AppColors.error,
            surface,
            border,
            text,
            textDim,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _balanceItem(
            '$winRate%',
            'WINRATE',
            AppColors.accent,
            surface,
            border,
            text,
            textDim,
          ),
        ),
      ],
    );
  }

  Widget _balanceItem(
    String value,
    String label,
    Color color,
    Color surface,
    Color border,
    Color text,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [color, color, surface, surface],
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.instrumentSerif(
              size: 22,
              color: text,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.monoSmall(color)),
        ],
      ),
    );
  }

  // ─── SECTION LABEL ───────────────────────────
  Widget _buildSectionLabel(String label, Color color, Color textMid) {
    return Row(
      children: [
        Container(width: 16, height: 1, color: color),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.monoLabel(color)),
      ],
    );
  }

  // ─── BADGES ──────────────────────────────────
  Widget _buildBadges(Color surface, Color border, Color text, Color textMid) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _userBadges.map((ub) {
        final badge = ub['badges'] as Map<String, dynamic>;
        return Tooltip(
          message: '${badge['name']}\n${badge['description']}',
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Center(
              child: Text(
                badge['icon'] ?? '🏆',
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── MATCH HISTORY ───────────────────────────
  Widget _buildMatchHistory(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    if (_matchHistory.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Icon(Icons.sports_esports_outlined, size: 32, color: textDim),
            const SizedBox(height: 12),
            Text(
              'Noch keine gemeinsamen Matches',
              style: AppTextStyles.bodyMedium(textMid),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: _matchHistory.asMap().entries.map((e) {
          return Column(
            children: [
              _buildMatchTile(e.value, text, textMid, textDim, border),
              if (e.key < _matchHistory.length - 1)
                Divider(height: 1, color: border, indent: 64),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMatchTile(
    Map<String, dynamic> match,
    Color text,
    Color textMid,
    Color textDim,
    Color border,
  ) {
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
      final isP1 = score['player1_id'] == _myId;
      myScore = isP1 ? score['player1_score'] : score['player2_score'];
      opponentScore = isP1 ? score['player2_score'] : score['player1_score'];
      didWin = myScore! > opponentScore!;
    }

    final resultColor = didWin == null
        ? textMid
        : didWin
        ? AppColors.success
        : AppColors.error;

    final statusLabel = didWin == null
        ? (status == 'active' ? 'AKTIV' : 'OFFEN')
        : didWin
        ? 'SIEG'
        : 'NIEDERL.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Match-ID Badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: resultColor.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                didWin == null ? '·' : (didWin ? '✓' : '✕'),
                style: AppTextStyles.mono(
                  size: 18,
                  color: resultColor,
                  weight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Match Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${matchId.substring(0, 6).toUpperCase()}',
                  style: AppTextStyles.mono(
                    size: 13,
                    color: text,
                    weight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(createdAt),
                  style: AppTextStyles.bodySmall(textMid),
                ),
              ],
            ),
          ),
          // Score / Status
          if (didWin != null && myScore != null && opponentScore != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: resultColor.withOpacity(0.3)),
              ),
              child: Text(
                '$myScore : $opponentScore',
                style: AppTextStyles.mono(
                  size: 13,
                  color: resultColor,
                  weight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: textMid.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: border),
              ),
              child: Text(statusLabel, style: AppTextStyles.monoSmall(textMid)),
            ),
        ],
      ),
    );
  }

  // ─── CHALLENGE BUTTON ────────────────────────
  Widget _buildChallengeButton(
    String username,
    Color text,
    Color textMid,
    Color surface,
    Color border,
    Color bg,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _challenging ? null : _challengePlayer,
        icon: _challenging
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: bg),
              )
            : const Icon(Icons.sports_kabaddi_rounded, size: 18),
        label: Text(
          _challenging ? 'Wird erstellt...' : '$username herausfordern',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: text,
          foregroundColor: bg,
          elevation: 0,
          textStyle: AppTextStyles.labelLarge(bg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
