import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_service.dart';
import '../../services/sound_service.dart';
import '../../services/badge_service.dart';
import '../../services/app_cache_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import '../auth/change_password_screen.dart';

class NewProfilePage extends StatefulWidget {
  const NewProfilePage({super.key});

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  final _authService = AuthService();
  final _soundService = SoundService();
  final _badgeService = BadgeService();
  final _supabase = Supabase.instance.client;

  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _playerStats;
  List<Map<String, dynamic>> _myBadges = [];

  // Learning progress
  int _questionsAnswered = 0;
  int _correctAnswered = 0;
  int _streakDays = 0;
  int _certsPassed = 0;
  int _examsPassed = 0;

  bool _loading = true;
  bool _notificationsEnabled = true;
  bool _soundsEnabled = true;
  bool _moduleViewAsList = false;

  @override
  void initState() {
    super.initState();
    final cacheService = AppCacheService();
    if (cacheService.profileLoaded && cacheService.cachedMyProfile != null) {
      _profile = cacheService.cachedMyProfile;
      _myBadges = List.from(cacheService.cachedMyBadges);
      _loading = false;
    } else {
      _loadProfile();
      _loadBadges();
    }
    _loadSettings();
    _loadAllStats();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _authService.getProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _loadBadges() async {
    try {
      final badges = await _badgeService.getMyBadges();
      if (!mounted) return;
      setState(() => _myBadges = badges);
    } catch (_) {}
  }

  /// Lädt alle Stats parallel — Player-Stats, Learning-Progress, Certs, Exams
  Future<void> _loadAllStats() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // Parallel laden für Speed
      final results = await Future.wait([
        // Match Stats
        _supabase
            .from('player_stats')
            .select(
              'elo_rating, wins, losses, draws, matches_played, highest_elo, correct_answers',
            )
            .eq('user_id', userId)
            .maybeSingle(),
        // Learning Progress — Anzahl beantworteter Fragen
        _supabase
            .from('user_progress')
            .select('is_correct')
            .eq('user_id', userId),
        // Bestandene Zertifikate
        _supabase
            .from('user_certificates')
            .select('id')
            .eq('user_id', userId)
            .eq('passed', true),
        // Bestandene Prüfungen
        _supabase
            .from('user_exam_attempts')
            .select('id')
            .eq('user_id', userId)
            .eq('passed', true),
      ]);

      final playerStats = results[0] as Map<String, dynamic>?;
      final progressData = results[1] as List<dynamic>;
      final certs = results[2] as List<dynamic>;
      final exams = results[3] as List<dynamic>;

      final totalAnswered = progressData.length;
      final totalCorrect = progressData
          .where((r) => (r as Map)['is_correct'] == true)
          .length;

      // Streak aus lokalen Prefs
      final streak = await _calcStreak();

      if (!mounted) return;
      setState(() {
        _playerStats = playerStats;
        _questionsAnswered = totalAnswered;
        _correctAnswered = totalCorrect;
        _certsPassed = certs.length;
        _examsPassed = exams.length;
        _streakDays = streak;
      });
    } catch (e) {
      debugPrint('Stats-Load error: $e');
    }
  }

  /// Berechnet Streak aus letztem Login-Tag in SharedPreferences
  Future<int> _calcStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastLogin = prefs.getString('last_login_date');
      int streak = prefs.getInt('streak_days') ?? 0;
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month}-${today.day}';

      if (lastLogin == todayStr) {
        return streak;
      }

      if (lastLogin != null) {
        final last = DateTime.tryParse(lastLogin);
        if (last != null) {
          final diff = today.difference(last).inDays;
          if (diff == 1) {
            streak += 1;
          } else if (diff > 1) {
            streak = 1;
          }
        }
      } else {
        streak = 1;
      }

      await prefs.setString('last_login_date', todayStr);
      await prefs.setInt('streak_days', streak);
      return streak;
    } catch (_) {
      return 0;
    }
  }

  Future<void> _loadSettings() async {
    await _soundService.init();
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
        _soundsEnabled = _soundService.soundsEnabled;
        _moduleViewAsList = prefs.getBool('module_view_as_list') ?? false;
      });
    } catch (_) {}
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    if (!mounted) return;
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _toggleSounds(bool value) async {
    await _soundService.toggleSounds(value);
    if (!mounted) return;
    setState(() => _soundsEnabled = value);
    if (value) _soundService.playSound(SoundType.correct);
  }

  Future<void> _toggleModuleView(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('module_view_as_list', value);
    if (!mounted) return;
    setState(() => _moduleViewAsList = value);
  }

  Future<void> _handleLogout() async {
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Abmelden?', style: AppTextStyles.h2(text)),
        content: Text(
          'Möchtest du dich wirklich abmelden?',
          style: AppTextStyles.bodyMedium(text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await _authService.signOut();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
        }
      }
    }
  }

  Future<void> _editProfile() async {
    final isDark = context.read<ThemeProvider>().isDark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _profile?['username']);
        return AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Text('Benutzername ändern', style: AppTextStyles.h2(text)),
          content: TextField(
            controller: controller,
            style: AppTextStyles.bodyMedium(text),
            decoration: const InputDecoration(labelText: 'Neuer Benutzername'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
    if (result != null &&
        result.isNotEmpty &&
        result != _profile?['username']) {
      try {
        await _authService.updateProfileInDB(username: result);
        await _loadProfile();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✓ Benutzername aktualisiert'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
        }
      }
    }
  }

  Future<void> _clearLocalData() async {
    final isDark = context.read<ThemeProvider>().isDark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Lokale Daten löschen?', style: AppTextStyles.h2(text)),
        content: Text(
          'Dies löscht deinen lokalen Lernfortschritt. Dein Account bleibt erhalten.',
          style: AppTextStyles.bodyMedium(text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final keysToRemove = prefs
            .getKeys()
            .where(
              (key) =>
                  key.startsWith('fortschritt_') ||
                  key.startsWith('score_') ||
                  key.startsWith('async_match/'),
            )
            .toList();
        for (final key in keysToRemove) {
          await prefs.remove(key);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ ${keysToRemove.length} Einträge gelöscht'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
        }
      }
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  String _getEloTier(int elo) {
    if (elo >= 1500) return 'MEISTER';
    if (elo >= 1300) return 'DIAMANT';
    if (elo >= 1150) return 'GOLD';
    if (elo >= 1000) return 'SILBER';
    if (elo >= 850) return 'BRONZE';
    return 'STARTER';
  }

  Color _getTierColor(int elo) {
    if (elo >= 1500) return const Color(0xFFEF4444); // Meister rot
    if (elo >= 1300) return const Color(0xFF22D3EE); // Diamant cyan
    if (elo >= 1150) return const Color(0xFFF59E0B); // Gold
    if (elo >= 1000) return const Color(0xFF94A3B8); // Silber
    if (elo >= 850) return const Color(0xFFB45309); // Bronze
    return const Color(0xFF94A3B8);
  }

  String _formatJoinDate(dynamic date) {
    if (date == null) return 'Unbekannt';
    try {
      final dt = date is String ? DateTime.parse(date) : date as DateTime;
      const months = [
        'Jan',
        'Feb',
        'Mär',
        'Apr',
        'Mai',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Okt',
        'Nov',
        'Dez',
      ];
      return '${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return 'Unbekannt';
    }
  }

  int get _successRate {
    if (_questionsAnswered == 0) return 0;
    return ((_correctAnswered / _questionsAnswered) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    final user = _authService.currentUser;
    final isFallback = _profile?['is_fallback'] == true;

    if (_loading) {
      return Scaffold(
        backgroundColor: bg,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    final hasMatchData = (_playerStats?['matches_played'] ?? 0) > 0;

    return Scaffold(
      backgroundColor: bg,
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async {
          await _loadAllStats();
          await _loadProfile();
        },
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.zero,
          children: [
            // ─── HEADER ─────────────────────────────────
            SafeArea(
              bottom: false,
              child: _buildHeader(
                user,
                isFallback,
                surface,
                border,
                text,
                textMid,
                textDim,
              ),
            ),

            // ─── CONTENT ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LERNFORTSCHRITT
                  _sectionLabel('DEIN FORTSCHRITT', textDim),
                  const SizedBox(height: 12),
                  _buildProgressGrid(surface, border, text, textMid, textDim),

                  const SizedBox(height: 32),

                  // MATCH STATS (nur wenn gespielt)
                  if (hasMatchData) ...[
                    _sectionLabel('MATCH STATISTIK', textDim),
                    const SizedBox(height: 12),
                    _buildMatchStats(surface, border, text, textMid, textDim),
                    const SizedBox(height: 32),
                  ],

                  // BADGES (nur wenn vorhanden)
                  if (_myBadges.isNotEmpty) ...[
                    _sectionLabel('BADGES · ${_myBadges.length}', textDim),
                    const SizedBox(height: 12),
                    _buildBadges(surface, border, text, textMid),
                    const SizedBox(height: 32),
                  ],

                  // EINSTELLUNGEN
                  _sectionLabel('EINSTELLUNGEN', textDim),
                  const SizedBox(height: 12),
                  _buildSettingsGroup(
                    themeProvider,
                    isDark,
                    surface,
                    border,
                    text,
                    textMid,
                    textDim,
                  ),

                  const SizedBox(height: 32),

                  // ACCOUNT
                  _sectionLabel('ACCOUNT', textDim),
                  const SizedBox(height: 12),
                  _buildAccountGroup(surface, border, text, textMid, textDim),

                  const SizedBox(height: 32),

                  // LOGOUT
                  _buildLogoutButton(surface, border, textMid),
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
    User? user,
    bool isFallback,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final elo = _playerStats?['elo_rating'] ?? 0;
    final hasElo = elo > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: surface,
                  border: Border.all(color: border, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _getInitials(_profile?['username']),
                    style: AppTextStyles.instrumentSerif(
                      size: 38,
                      color: AppColors.accent,
                      letterSpacing: -1.0,
                    ),
                  ),
                ),
              ),
              if (isFallback)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                      border: Border.all(color: surface, width: 2),
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Username in Instrument Serif
          Text(
            _profile?['username'] ?? 'Unbekannt',
            style: AppTextStyles.instrumentSerif(
              size: 32,
              color: text,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(user?.email ?? '', style: AppTextStyles.bodySmall(textMid)),
          const SizedBox(height: 16),

          // Meta Row: Tier + Join Date
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (hasElo) ...[
                _metaPill(
                  text: _getEloTier(elo),
                  color: _getTierColor(elo),
                  border: border,
                ),
                _metaPill(text: 'ELO $elo', color: textMid, border: border),
              ],
              _metaPill(
                text:
                    'SEIT ${_formatJoinDate(_profile?['created_at']).toUpperCase()}',
                color: textMid,
                border: border,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Edit Button
          OutlinedButton.icon(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit_outlined, size: 14),
            label: const Text('Profil bearbeiten'),
            style: OutlinedButton.styleFrom(
              foregroundColor: text,
              side: BorderSide(color: border),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              textStyle: AppTextStyles.labelMedium(text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaPill({
    required String text,
    required Color color,
    required Color border,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: AppTextStyles.mono(
          size: 10,
          color: color,
          weight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
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

  // ─── PROGRESS GRID ────────────────────────────────
  Widget _buildProgressGrid(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statBox(
                  value: '$_questionsAnswered',
                  label: 'FRAGEN',
                  text: text,
                  textDim: textDim,
                  rightBorder: true,
                  border: border,
                ),
              ),
              Expanded(
                child: _statBox(
                  value: '$_successRate',
                  unit: '%',
                  label: 'TREFFERQUOTE',
                  text: text,
                  textDim: textDim,
                  rightBorder: true,
                  border: border,
                  valueColor: _successRate >= 70
                      ? AppColors.success
                      : _successRate >= 50
                      ? AppColors.warning
                      : AppColors.error,
                ),
              ),
              Expanded(
                child: _statBox(
                  value: '$_streakDays',
                  unit: 'd',
                  label: 'STREAK',
                  text: text,
                  textDim: textDim,
                  border: border,
                  valueColor: _streakDays > 0 ? AppColors.accentCyan : text,
                ),
              ),
            ],
          ),
          Divider(height: 1, color: border),
          Row(
            children: [
              Expanded(
                child: _statBox(
                  value: '$_certsPassed',
                  label: 'ZERTIFIKATE',
                  text: text,
                  textDim: textDim,
                  rightBorder: true,
                  border: border,
                  valueColor: _certsPassed > 0 ? AppColors.success : text,
                ),
              ),
              Expanded(
                child: _statBox(
                  value: '$_examsPassed',
                  label: 'PRÜFUNGEN',
                  text: text,
                  textDim: textDim,
                  border: border,
                  valueColor: _examsPassed > 0 ? AppColors.success : text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox({
    required String value,
    String? unit,
    required String label,
    required Color text,
    required Color textDim,
    required Color border,
    bool rightBorder = false,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      decoration: BoxDecoration(
        border: rightBorder ? Border(right: BorderSide(color: border)) : null,
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppTextStyles.instrumentSerif(
                    size: 36,
                    color: valueColor ?? text,
                    letterSpacing: -1.0,
                  ),
                ),
                if (unit != null)
                  TextSpan(
                    text: unit,
                    style: AppTextStyles.bodyMedium(textDim),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.monoSmall(textDim)),
        ],
      ),
    );
  }

  // ─── MATCH STATS ──────────────────────────────────
  Widget _buildMatchStats(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final wins = _playerStats?['wins'] ?? 0;
    final losses = _playerStats?['losses'] ?? 0;
    final draws = _playerStats?['draws'] ?? 0;
    final matches = _playerStats?['matches_played'] ?? 0;
    final highestElo = _playerStats?['highest_elo'] ?? 0;
    final winRate = matches > 0
        ? ((wins / matches) * 100).toStringAsFixed(0)
        : '0';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Async-Matches', style: AppTextStyles.h3(text)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PEAK ELO $highestElo',
                  style: AppTextStyles.mono(
                    size: 9,
                    color: AppColors.accent,
                    weight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // WLD + Winrate
          Row(
            children: [
              _miniStat('$wins', 'SIEGE', AppColors.success, textDim),
              const SizedBox(width: 20),
              _miniStat('$draws', 'REMIS', AppColors.warning, textDim),
              const SizedBox(width: 20),
              _miniStat('$losses', 'NIEDERL.', AppColors.error, textDim),
              const Spacer(),
              _miniStat('$winRate%', 'WINRATE', AppColors.accent, textDim),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label, Color color, Color textDim) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.interTight(
            size: 18,
            weight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(label, style: AppTextStyles.monoSmall(textDim)),
      ],
    );
  }

  // ─── BADGES ───────────────────────────────────────
  Widget _buildBadges(Color surface, Color border, Color text, Color textMid) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _myBadges.map((ub) {
          final badge = ub['badges'] as Map<String, dynamic>;
          return Tooltip(
            message: '${badge['name']}\n${badge['description']}',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accent.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    badge['icon'] ?? '🏆',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
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
    );
  }

  // ─── SETTINGS ─────────────────────────────────────
  Widget _buildSettingsGroup(
    ThemeProvider themeProvider,
    bool isDark,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          _switchTile(
            icon: isDark ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
            title: 'Dark Mode',
            subtitle: isDark ? 'Dunkel' : 'Hell',
            value: isDark,
            onChanged: (_) => themeProvider.toggleTheme(),
            text: text,
            textMid: textMid,
          ),
          _divider(border),
          _switchTile(
            icon: Icons.notifications_outlined,
            title: 'Benachrichtigungen',
            subtitle: 'Push-Benachrichtigungen',
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
            text: text,
            textMid: textMid,
          ),
          _divider(border),
          _switchTile(
            icon: _soundsEnabled
                ? Icons.volume_up_outlined
                : Icons.volume_off_outlined,
            title: 'Sound-Effekte',
            subtitle: 'Feedback bei Antworten',
            value: _soundsEnabled,
            onChanged: _toggleSounds,
            text: text,
            textMid: textMid,
          ),
          _divider(border),
          _switchTile(
            icon: _moduleViewAsList
                ? Icons.view_list_outlined
                : Icons.grid_view_outlined,
            title: 'Modul-Ansicht',
            subtitle: _moduleViewAsList ? 'Liste' : 'Raster',
            value: _moduleViewAsList,
            onChanged: _toggleModuleView,
            text: text,
            textMid: textMid,
          ),
        ],
      ),
    );
  }

  // ─── ACCOUNT ──────────────────────────────────────
  Widget _buildAccountGroup(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          _actionTile(
            icon: Icons.person_outline,
            title: 'Benutzername ändern',
            onTap: _editProfile,
            text: text,
            textMid: textMid,
            textDim: textDim,
          ),
          _divider(border),
          _actionTile(
            icon: Icons.lock_outline,
            title: 'Passwort ändern',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
            ),
            text: text,
            textMid: textMid,
            textDim: textDim,
          ),
          _divider(border),
          _actionTile(
            icon: Icons.delete_outline,
            title: 'Lokale Daten löschen',
            subtitle: 'Lernfortschritt zurücksetzen',
            iconColor: AppColors.error,
            onTap: _clearLocalData,
            text: text,
            textMid: textMid,
            textDim: textDim,
          ),
        ],
      ),
    );
  }

  // ─── LOGOUT ───────────────────────────────────────
  Widget _buildLogoutButton(Color surface, Color border, Color textMid) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _handleLogout,
        icon: const Icon(Icons.logout_rounded, size: 16),
        label: const Text('Abmelden'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.error.withOpacity(0.4)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: AppTextStyles.labelLarge(AppColors.error),
        ),
      ),
    );
  }

  // ─── TILES ────────────────────────────────────────
  Widget _switchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color text,
    required Color textMid,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: textMid, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge(text)),
                if (subtitle != null)
                  Text(subtitle, style: AppTextStyles.bodySmall(textMid)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required Color text,
    required Color textMid,
    required Color textDim,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? textMid, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge(iconColor ?? text),
                  ),
                  if (subtitle != null)
                    Text(subtitle, style: AppTextStyles.bodySmall(textMid)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: textDim, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _divider(Color border) => Container(
    height: 1,
    margin: const EdgeInsets.only(left: 50),
    color: border,
  );
}
