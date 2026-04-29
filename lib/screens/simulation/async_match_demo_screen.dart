import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/async_duel_service.dart';
import '../../../services/app_cache_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'leaderboard_screen.dart';
import 'async_match_play_screen.dart';
import '../../services/usage_tracker.dart';
import '../../widgets/limit_reached_dialog.dart';

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
      debugPrint('❌ Fehler: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ─── LIMIT-CHECK für Free-User ─────────────────
  /// Prüft Async-Match-Limit. Returns true wenn Match starten erlaubt ist.
  /// Bei false: Dialog wird gezeigt + Aktion abgebrochen.
  Future<bool> _checkAsyncMatchLimit() async {
    final canUse = await UsageTracker().canUse(
      feature: UsageFeature.asyncMatch,
    );
    if (canUse) return true;

    if (!mounted) return false;

    LimitReachedDialog.show(
      context,
      featureName: 'Async Matches',
      limit: UsageTracker.limitAsyncMatch,
      icon: Icons.sports_esports_rounded,
      onUpgrade: () {
        // TODO: später zur Pricing-Page
      },
    );
    return false;
  }

  Future<void> _createMatch() async {
    if (!await _checkAsyncMatchLimit()) return;

    setState(() => _busy = true);
    try {
      final id = await _svc.createMatch(count: 10);
      await UsageTracker().increment(feature: UsageFeature.asyncMatch);
      await _loadData();
      if (!mounted) return;
      _playMatch(id);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Fehler: $e', AppColors.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _joinRandom() async {
    if (!await _checkAsyncMatchLimit()) return;

    setState(() => _busy = true);
    try {
      final id = await _svc.joinRandomMatch();
      if (id == null) {
        if (!mounted) return;
        _showSnack('Kein offenes Match gefunden', AppColors.warning);
        return;
      }
      await UsageTracker().increment(feature: UsageFeature.asyncMatch);
      await _loadData();
      if (!mounted) return;
      _playMatch(id);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Fehler: $e', AppColors.error);
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
      _showSnack('Fehler: $e', AppColors.error);
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
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: border)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: textDim,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  Container(width: 16, height: 1, color: AppColors.accent),
                  const SizedBox(width: 10),
                  Text(
                    'OFFENE MATCHES',
                    style: AppTextStyles.monoLabel(AppColors.accent),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _joinRandom();
                    },
                    icon: Icon(
                      Icons.shuffle_rounded,
                      size: 16,
                      color: AppColors.accent,
                    ),
                    label: Text(
                      'Zufällig',
                      style: AppTextStyles.labelMedium(AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: border),
            Expanded(
              child: _openMatches.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined, size: 40, color: textDim),
                          const SizedBox(height: 12),
                          Text(
                            'Keine offenen Matches',
                            style: AppTextStyles.bodyMedium(textMid),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      itemCount: _openMatches.length,
                      itemBuilder: (_, i) => _buildOpenMatchTile(
                        _openMatches[i],
                        surface,
                        border,
                        text,
                        textMid,
                        textDim,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenMatchTile(
    Map<String, dynamic> match,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final matchId = match['id'] as String;
    final questions = match['total_questions'] ?? 10;
    final createdAt = match['created_at'] as String?;
    final creator = match['creator'] as Map<String, dynamic>?;
    final creatorName = creator?['username'] ?? 'Unbekannt';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  creatorName.isNotEmpty ? creatorName[0].toUpperCase() : '?',
                  style: AppTextStyles.instrumentSerif(
                    size: 18,
                    color: AppColors.accent,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(creatorName, style: AppTextStyles.labelLarge(text)),
                  const SizedBox(height: 2),
                  Text(
                    '$questions Fragen · ${_formatDate(createdAt)}',
                    style: AppTextStyles.monoSmall(textDim),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _joinMatch(matchId),
              style: ElevatedButton.styleFrom(
                backgroundColor: text,
                foregroundColor: surface,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              child: Text(
                'Beitreten',
                style: AppTextStyles.labelMedium(surface),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinMatch(String matchId) async {
    Navigator.pop(context);
    if (!await _checkAsyncMatchLimit()) return;

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
      await UsageTracker().increment(feature: UsageFeature.asyncMatch);
      await _loadData();
      if (!mounted) return;
      _playMatch(matchId);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Fehler: $e', AppColors.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 1) return 'gerade eben';
      if (diff.inMinutes < 60) return 'vor ${diff.inMinutes} Min';
      if (diff.inHours < 24) return 'vor ${diff.inHours}h';
      if (diff.inDays == 1) return 'gestern';
      if (diff.inDays < 7) return 'vor ${diff.inDays} Tagen';
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return '';
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

    final elo = _myStats?['elo_rating'] ?? 0;
    final hasPlayed = (_myStats?['matches_played'] ?? 0) > 0;

    return Scaffold(
      backgroundColor: bg,
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.accent,
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.zero,
          children: [
            // ─── HEADER ───────────────────────────────────
            SafeArea(
              bottom: false,
              child: _buildHeader(text, textMid, textDim, surface, border),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status (nur wenn gespielt)
                  if (hasPlayed) ...[
                    _buildStatusBanner(
                      elo,
                      surface,
                      border,
                      text,
                      textMid,
                      textDim,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Progress Bar (wenn loading)
                  if (_busy)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          color: AppColors.accent,
                          backgroundColor: border,
                          minHeight: 2,
                        ),
                      ),
                    ),

                  // Actions
                  _sectionLabel('MATCH STARTEN', textDim),
                  const SizedBox(height: 12),
                  _buildPrimaryActions(surface, border, text, textMid, textDim),

                  const SizedBox(height: 32),

                  // Aktive Matches
                  _sectionLabel(
                    'AKTIVE MATCHES · ${_activeMatches.length}',
                    textDim,
                  ),
                  const SizedBox(height: 12),
                  if (_activeMatches.isEmpty)
                    _buildEmpty(
                      icon: Icons.sports_kabaddi_outlined,
                      title: 'Keine aktiven Matches',
                      sub: 'Starte ein neues Match um loszulegen',
                      surface: surface,
                      border: border,
                      textMid: textMid,
                      textDim: textDim,
                    )
                  else
                    ..._activeMatches.map(
                      (m) => _buildMatchCard(
                        m,
                        isHistory: false,
                        surface: surface,
                        border: border,
                        text: text,
                        textMid: textMid,
                        textDim: textDim,
                      ),
                    ),

                  const SizedBox(height: 32),

                  // History
                  if (_historyMatches.isNotEmpty) ...[
                    GestureDetector(
                      onTap: () =>
                          setState(() => _historyExpanded = !_historyExpanded),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 1,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'HISTORY · ${_historyMatches.length}',
                            style: AppTextStyles.monoLabel(AppColors.accent),
                          ),
                          const Spacer(),
                          Icon(
                            _historyExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: textMid,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Zeige max 3 wenn eingeklappt
                    ..._historyMatches
                        .take(_historyExpanded ? _historyMatches.length : 3)
                        .map(
                          (m) => _buildMatchCard(
                            m,
                            isHistory: true,
                            surface: surface,
                            border: border,
                            text: text,
                            textMid: textMid,
                            textDim: textDim,
                          ),
                        ),
                    if (!_historyExpanded && _historyMatches.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextButton(
                          onPressed: () =>
                              setState(() => _historyExpanded = true),
                          child: Text(
                            'Alle ${_historyMatches.length} anzeigen',
                            style: AppTextStyles.labelMedium(AppColors.accent),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────
  Widget _buildHeader(
    Color text,
    Color textMid,
    Color textDim,
    Color surface,
    Color border,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 16, height: 1, color: AppColors.accent),
                    const SizedBox(width: 10),
                    Text(
                      'ARENA',
                      style: AppTextStyles.monoLabel(AppColors.accent),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Fordere andere heraus.',
                  style: AppTextStyles.instrumentSerif(
                    size: 34,
                    color: text,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Async-Matches · ELO-Rating · Wöchentliche Ranglisten',
                  style: AppTextStyles.bodyMedium(textMid),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Leaderboard Button
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Icon(Icons.emoji_events_outlined, color: textMid, size: 18),
                  const SizedBox(height: 4),
                  Text(
                    'LEADERBOARD',
                    style: AppTextStyles.mono(
                      size: 9,
                      color: textMid,
                      weight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── STATUS BANNER ────────────────────────────────
  Widget _buildStatusBanner(
    int elo,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final tierColor = _getTierColor(elo);
    final wins = _myStats?['wins'] ?? 0;
    final losses = _myStats?['losses'] ?? 0;
    final draws = _myStats?['draws'] ?? 0;
    final total = wins + losses + draws;
    final winRate = total > 0 ? ((wins / total) * 100).toInt() : 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        // Top-Accent in Tier-Farbe
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [tierColor, tierColor, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tierColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getTier(elo),
                  style: AppTextStyles.mono(
                    size: 10,
                    color: tierColor,
                    weight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              Text('ELO', style: AppTextStyles.monoSmall(textDim)),
              const SizedBox(width: 6),
              Text(
                '$elo',
                style: AppTextStyles.instrumentSerif(
                  size: 28,
                  color: text,
                  letterSpacing: -1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statMini('$wins', 'SIEGE', AppColors.success, textDim),
              const SizedBox(width: 20),
              _statMini('$draws', 'REMIS', AppColors.warning, textDim),
              const SizedBox(width: 20),
              _statMini('$losses', 'NIEDERL.', AppColors.error, textDim),
              const Spacer(),
              _statMini('$winRate%', 'WINRATE', AppColors.accent, textDim),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statMini(String value, String label, Color color, Color textDim) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.interTight(
            size: 16,
            weight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(label, style: AppTextStyles.monoSmall(textDim)),
      ],
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

  // ─── PRIMARY ACTIONS ──────────────────────────────
  Widget _buildPrimaryActions(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Column(
      children: [
        // Hero CTA: Neues Match
        GestureDetector(
          onTap: _busy ? null : _createMatch,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: text,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: surface.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.bolt_rounded, color: surface, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Neues Match',
                        style: AppTextStyles.interTight(
                          size: 16,
                          weight: FontWeight.w600,
                          color: surface,
                        ),
                      ),
                      Text(
                        '10 Fragen · warten auf Gegner',
                        style: AppTextStyles.bodySmall(
                          surface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: surface, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // 2 Secondary Actions
        Row(
          children: [
            Expanded(
              child: _buildSecondaryAction(
                icon: Icons.search_rounded,
                label: 'Beitreten',
                sub: 'Offene Matches',
                onTap: _busy ? null : _showOpenMatches,
                surface: surface,
                border: border,
                text: text,
                textMid: textMid,
                textDim: textDim,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSecondaryAction(
                icon: Icons.shuffle_rounded,
                label: 'Zufällig',
                sub: 'Sofort starten',
                onTap: _busy ? null : _joinRandom,
                surface: surface,
                border: border,
                text: text,
                textMid: textMid,
                textDim: textDim,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryAction({
    required IconData icon,
    required String label,
    required String sub,
    required VoidCallback? onTap,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: text, size: 20),
            const SizedBox(height: 14),
            Text(label, style: AppTextStyles.labelLarge(text)),
            const SizedBox(height: 2),
            Text(sub, style: AppTextStyles.bodySmall(textDim)),
          ],
        ),
      ),
    );
  }

  // ─── EMPTY ────────────────────────────────────────
  Widget _buildEmpty({
    required IconData icon,
    required String title,
    required String sub,
    required Color surface,
    required Color border,
    required Color textMid,
    required Color textDim,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: border, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: textDim),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.labelLarge(textMid)),
          const SizedBox(height: 4),
          Text(sub, style: AppTextStyles.bodySmall(textDim)),
        ],
      ),
    );
  }

  // ─── MATCH CARD ───────────────────────────────────
  Widget _buildMatchCard(
    Map<String, dynamic> match, {
    required bool isHistory,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    final matchId = match['id'] as String;
    final status = match['status'] as String;
    final questions = match['total_questions'] ?? 10;
    final createdAt = match['created_at'] as String?;
    final canPlay = status == 'active' || status == 'open';

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

    final resultColor = isHistory
        ? (didWin == true ? AppColors.success : AppColors.error)
        : AppColors.accent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: isHistory ? null : () => _playMatch(matchId),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              // Match-ID in Mono + Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        const SizedBox(width: 8),
                        if (!isHistory)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  status == 'active' ? 'AKTIV' : 'OFFEN',
                                  style: AppTextStyles.mono(
                                    size: 9,
                                    color: AppColors.accent,
                                    weight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$questions Fragen · ${_formatDate(createdAt)}',
                      style: AppTextStyles.monoSmall(textDim),
                    ),
                  ],
                ),
              ),

              // Right-Side: Score (History) oder Play-Button (Active)
              if (isHistory && didWin != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: resultColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: resultColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        didWin ? 'SIEG' : 'NIEDERL.',
                        style: AppTextStyles.mono(
                          size: 9,
                          color: resultColor,
                          weight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$myScore:$opponentScore',
                        style: AppTextStyles.interTight(
                          size: 15,
                          weight: FontWeight.w700,
                          color: resultColor,
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
                    color: text,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_rounded, color: surface, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Spielen',
                        style: AppTextStyles.interTight(
                          size: 12,
                          weight: FontWeight.w600,
                          color: surface,
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
