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
import '../auth/login_screen.dart';
import '../auth/upgrade_account_screen.dart';
import '../../services/subscription_service.dart';
import '../legal/legal_document_screen.dart';
import '../../services/daily_goal_service.dart';
import '../../services/bereitschafts_service.dart';
import '../../theme/modul_stil.dart';
import '../../widgets/streak_calendar.dart';

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
  int _streakDays = 0;
  int _certsPassed = 0;
  int _examsPassed = 0;
  Map<DateTime, int> _activeDayCounts = {};

  // Pruefungsbereitschaft (gemeisterte Themen im Uebungsbereich)
  Bereitschaft? _bereitschaft;
  bool _bereitschaftOffen = false;

  // Bewertete IHK-Simulationen (neueste zuerst)
  List<_PruefungsEintrag> _pruefungen = [];

  bool _loading = true;
  bool _notificationsEnabled = true;
  bool _soundsEnabled = true;

  @override
  void initState() {
    super.initState();
    final cacheService = AppCacheService();
    if (cacheService.profileLoaded && cacheService.cachedMyProfile != null) {
      _profile = cacheService.cachedMyProfile;
      _myBadges = List.from(cacheService.cachedMyBadges);
      _loading = false;
      // Der Cache stammt vom App-Start. Badges koennen seitdem neu
      // dazugekommen sein, darum im Hintergrund frisch nachladen.
      _loadBadges();
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
      // Cache aktualisieren, damit auch der naechste Profil-Besuch
      // in dieser Sitzung den frischen Stand zeigt.
      AppCacheService().cachedMyBadges = List.from(badges);
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
      final results = await Future.wait<dynamic>([
        // Match Stats
        _supabase
            .from('player_stats')
            .select(
              'elo_rating, wins, losses, draws, matches_played, highest_elo, correct_answers',
            )
            .eq('user_id', userId)
            .maybeSingle(),
        // Bestandene Zertifikate
        _supabase
            .from('user_certificates')
            .select('id')
            .eq('user_id', userId)
            .eq('passed', true),
        // Alle Pruefungsversuche (Liste mit Noten + Zaehler "bestanden")
        _supabase
            .from('user_exam_attempts')
            .select('id, exam_id, submitted_at, percentage, passed, status')
            .eq('user_id', userId)
            .order('submitted_at', ascending: false),
        // Pruefungsbereitschaft (Themen gemeistert je Modul)
        BereitschaftsService().laden(),
        // IHK-Pruefungen (nur typ 'ihk', keine Zertifikats-Uebungen)
        _supabase.from('exams').select('id, name, beschreibung, typ'),
      ]);

      final playerStats = results[0] as Map<String, dynamic>?;
      final certs = results[1] as List<dynamic>;
      final attempts = results[2] as List<dynamic>;
      final bereitschaft = results[3] as Bereitschaft?;
      final examsRoh = results[4] as List<dynamic>;

      // Nur echte IHK-Simulationen, nur bewertete Versuche. Alle Noten
      // zeigen (auch nicht bestanden), sonst denkt man, es fehlt etwas.
      final ihkExams = <int, Map<String, dynamic>>{};
      for (final e in examsRoh) {
        if (e['typ'] == 'ihk') ihkExams[e['id'] as int] = e;
      }
      final pruefungen = <_PruefungsEintrag>[];
      var bestanden = 0;
      for (final a in attempts) {
        final exam = ihkExams[a['exam_id'] as int?];
        if (exam == null || a['status'] != 'graded' || a['percentage'] == null) {
          continue;
        }
        final prozent = (a['percentage'] as num).round();
        final passed = a['passed'] == true;
        if (passed) bestanden++;
        pruefungen.add(
          _PruefungsEintrag(
            name: (exam['name'] ?? 'Prüfung') as String,
            info: exam['beschreibung'] as String?,
            datum: DateTime.tryParse(a['submitted_at'] as String? ?? '')
                ?.toLocal(),
            prozent: prozent,
            bestanden: passed,
          ),
        );
      }

      // Streak aus lokalen Prefs
      final streak = await _calcStreak();

      // Aktivität der letzten 12 Wochen für den Kalender
      final activeDays = await DailyGoalService().getActiveDayCounts();

      if (!mounted) return;
      setState(() {
        _playerStats = playerStats;
        _certsPassed = certs.length;
        _examsPassed = bestanden;
        _pruefungen = pruefungen;
        _bereitschaft = bereitschaft;
        _streakDays = streak;
        _activeDayCounts = activeDays;
      });
    } catch (e) {
      debugPrint('Stats-Load error: $e');
    }
  }

  /// Berechnet den Streak anhand des letzten Login-Tags – pro Account in der DB
  Future<int> _calcStreak() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      final row = await _supabase
          .from('profiles')
          .select('streak_days, last_login_date')
          .eq('id', userId)
          .maybeSingle();

      int streak = (row?['streak_days'] as num?)?.toInt() ?? 0;
      final lastLogin = row?['last_login_date'] as String?;

      final today = DateTime.now();
      final todayStr =
          '${today.year.toString().padLeft(4, '0')}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';

      // Heute bereits gezählt -> unverändert zurück
      if (lastLogin == todayStr) return streak;

      if (lastLogin != null) {
        final last = DateTime.tryParse(lastLogin);
        if (last != null) {
          final lastDay = DateTime(last.year, last.month, last.day);
          final todayDay = DateTime(today.year, today.month, today.day);
          final diff = todayDay.difference(lastDay).inDays;
          if (diff == 1) {
            streak += 1; // gestern aktiv -> Streak +1
          } else if (diff > 1) {
            streak = 1; // Lücke -> zurück auf 1
          }
          // diff <= 0 -> unverändert lassen
        } else {
          streak = 1;
        }
      } else {
        streak = 1; // erster Login
      }

      await _supabase
          .from('profiles')
          .update({'streak_days': streak, 'last_login_date': todayStr})
          .eq('id', userId);

      return streak;
    } catch (e) {
      debugPrint('Streak-Berechnung fehlgeschlagen: $e');
      return _streakDays; // letzter bekannter Wert statt 0
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

  Future<void> _handleLogout() async {
    final isDark = context.read<ThemeProvider>().isDark;
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
        SubscriptionService().clear();
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
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

  /// Loescht das Konto endgueltig — Auth-Nutzer und alle Daten.
  ///
  /// Apple verlangt seit 2022 (Guideline 5.1.1(v)), dass Apps mit
  /// Kontoerstellung die Loeschung IN DER APP anbieten. Ein Verweis auf
  /// E-Mail oder eine Webseite reicht nicht und fuehrt zur Ablehnung.
  ///
  /// Die eigentliche Arbeit macht die Edge Function 'delete-account'. Sie
  /// braucht den Service-Role-Key, der niemals in die App gehoert.
  ///
  /// Zwei Abfragen hintereinander, weil der Schritt nicht rueckgaengig zu
  /// machen ist: erst die Warnung, dann das Eintippen des Wortes.
  Future<void> _deleteAccount() async {
    final isDark = context.read<ThemeProvider>().isDark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;

    // ---- Abfrage 1: Was passiert -------------------------------------
    final weiter = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Konto löschen?', style: AppTextStyles.h2(text)),
        content: Text(
          'Dein Konto und alle deine Daten werden endgültig gelöscht:\n\n'
          '• Lernfortschritt und Testergebnisse\n'
          '• Karteikarten und Wiederholungen\n'
          '• Abzeichen und Zertifikate\n'
          '• Arena-Wertung und Matches\n'
          '• Premium-Status\n\n'
          'Das lässt sich nicht rückgängig machen.',
          style: AppTextStyles.bodyMedium(text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Weiter', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (weiter != true || !mounted) return;

    // ---- Abfrage 2: Wort eintippen -----------------------------------
    final eingabe = TextEditingController();
    final bestaetigt = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLokal) => AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Text('Wirklich löschen?', style: AppTextStyles.h2(text)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tippe LÖSCHEN ein, um zu bestätigen.',
                style: AppTextStyles.bodyMedium(text),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: eingabe,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(hintText: 'LÖSCHEN'),
                onChanged: (_) => setLokal(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: eingabe.text.trim().toUpperCase() == 'LÖSCHEN'
                  ? () => Navigator.pop(context, true)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Endgültig löschen'),
            ),
          ],
        ),
      ),
    );
    eingabe.dispose();
    if (bestaetigt != true || !mounted) return;

    // ---- Loeschen ----------------------------------------------------
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final antwort = await _supabase.functions.invoke(
        'delete-account',
        body: {'bestaetigung': 'LOESCHEN'},
      );

      final daten = antwort.data as Map<String, dynamic>?;
      if (daten?['ok'] != true) {
        throw Exception(daten?['error'] ?? 'Unbekannter Fehler');
      }

      // Sitzung lokal beenden. Der Auth-Nutzer existiert serverseitig nicht
      // mehr, ein Fehler beim Abmelden ist deshalb unerheblich.
      try {
        await _authService.signOut();
      } catch (_) {}
      SubscriptionService().clear();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!mounted) return;
      Navigator.of(context).pop(); // Ladeanzeige schliessen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dein Konto wurde gelöscht.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Ladeanzeige schliessen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Löschen fehlgeschlagen: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
                  // GAST-HINWEIS: Account erstellen & Fortschritt sichern
                  if (_authService.isGuest) ...[
                    _buildGuestUpgradeCard(isDark, text, textMid),
                    const SizedBox(height: 32),
                  ],

                  // LERNFORTSCHRITT
                  _sectionLabel('DEIN FORTSCHRITT', textDim),
                  const SizedBox(height: 12),
                  _buildProgressGrid(surface, border, text, textMid, textDim),

                  const SizedBox(height: 32),

                  // PRUEFUNGEN (nur wenn bewertete Versuche vorliegen)
                  if (_pruefungen.isNotEmpty) ...[
                    _sectionLabel(
                      'PRÜFUNGEN · $_examsPassed/${_pruefungen.length} BESTANDEN',
                      textDim,
                    ),
                    const SizedBox(height: 12),
                    _buildPruefungen(surface, border, text, textMid, textDim),
                    const SizedBox(height: 32),
                  ],

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

                  // AKTIVITÄT (Streak-Kalender, ausklappbar)
                  _buildCalendarSection(surface, border, text, textDim),

                  const SizedBox(height: 32),

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

                  // RECHTLICHES
                  _sectionLabel('RECHTLICHES', textDim),
                  const SizedBox(height: 12),
                  _buildLegalGroup(surface, border, text, textMid, textDim),

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
              // Premium / Free Badge
              _premiumPill(border: border, surface: surface),
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

  // ─── PREMIUM / FREE PILL ───────────────────────
  Widget _premiumPill({required Color border, required Color surface}) {
    final isPremium = SubscriptionService().isPremium;
    final color = isPremium ? AppColors.accent : AppColors.warning;
    final label = isPremium ? 'PREMIUM' : 'FREE';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPremium) ...[
            Icon(Icons.workspace_premium_rounded, color: color, size: 11),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.mono(
              size: 10,
              color: color,
              weight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ─── AKTIVITÄT (ausklappbar) ──────────────────────
  Widget _buildCalendarSection(
    Color surface,
    Color border,
    Color text,
    Color textDim,
  ) {
    return Theme(
      // ExpansionTile zeichnet sonst eigene Trennlinien — die nehmen wir weg.
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: AppColors.accent,
          collapsedIconColor: textDim,
          title: Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'AKTIVITÄT · 12 WOCHEN',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          children: [
            StreakCalendar(
              dayCounts: _activeDayCounts,
              surface: surface,
              border: border,
              text: text,
              textDim: textDim,
            ),
          ],
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

  // ─── PROGRESS (Bereitschaft + Kennzahlen) ─────────
  Widget _buildProgressGrid(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Column(
      children: [
        _buildBereitschaftsKarte(surface, border, text, textMid, textDim),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: _statBox(
                  value: '$_streakDays',
                  unit: 'd',
                  label: 'STREAK',
                  text: text,
                  textDim: textDim,
                  rightBorder: true,
                  border: border,
                  valueColor: _streakDays > 0 ? AppColors.accentCyan : text,
                ),
              ),
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
        ),
      ],
    );
  }

  // ─── PRÜFUNGSBEREITSCHAFT ─────────────────────────
  //
  // Das Herzstueck des Profils: EIN Wert, der die wichtigste Frage der
  // Nutzer beantwortet ("Bin ich bereit fuer die IHK-Pruefung?").
  // Grundlage: gemeisterte Themen im Uebungsbereich (best_score erreicht
  // den required_score des Themas, Standard 80). Tippen klappt die
  // Aufschluesselung je Modul auf.
  Widget _buildBereitschaftsKarte(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final b = _bereitschaft;
    final prozent = b?.prozent ?? 0;
    final farbe = prozent >= 100
        ? AppColors.success
        : prozent > 0
        ? AppColors.accent
        : textDim;

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: b == null || b.bereiche.isEmpty
            ? null
            : () => setState(() => _bereitschaftOffen = !_bereitschaftOffen),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Grosser Ring mit Prozentzahl
                  SizedBox(
                    width: 76,
                    height: 76,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: (b?.anteil ?? 0).clamp(0.0, 1.0),
                          strokeWidth: 6,
                          backgroundColor: border,
                          valueColor: AlwaysStoppedAnimation(farbe),
                          strokeCap: StrokeCap.round,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$prozent',
                                  style: AppTextStyles.instrumentSerif(
                                    size: 26,
                                    color: text,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: '%',
                                  style: AppTextStyles.bodySmall(textDim),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRÜFUNGSBEREIT',
                          style: AppTextStyles.monoLabel(AppColors.accent),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          b == null
                              ? 'Fortschritt wird geladen'
                              : 'Dein Lernstand über alle Bereiche',
                          style: AppTextStyles.bodyMedium(text),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tippen für Details je Bereich',
                          style: AppTextStyles.bodySmall(textDim),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _bereitschaftOffen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: textDim,
                  ),
                ],
              ),

              // Aufschluesselung je Bereich
              if (_bereitschaftOffen && b != null) ...[
                const SizedBox(height: 14),
                Divider(height: 1, color: border),
                const SizedBox(height: 6),
                for (final bereich in b.bereiche)
                  _bereitschaftsZeile(bereich, border, text, textDim),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Icon und Farbe je Bereich (bewusst fest verdrahtet, es sind nur vier).
  ({IconData icon, Color farbe}) _bereichsStil(String schluessel) {
    switch (schluessel) {
      case 'module':
        return (icon: Icons.school_outlined, farbe: AppColors.accent);
      case 'levels':
        return (icon: Icons.stairs_rounded, farbe: AppColors.warning);
      case 'sql':
        return (icon: Icons.storage_rounded, farbe: AppColors.info);
      case 'python':
        return (icon: Icons.code_rounded, farbe: AppColors.success);
      default:
        return (icon: Icons.school_outlined, farbe: AppColors.accent);
    }
  }

  Widget _bereitschaftsZeile(
    BereitschaftsBereich bereich,
    Color border,
    Color text,
    Color textDim,
  ) {
    final stil = _bereichsStil(bereich.schluessel);
    final fertig = bereich.gesamt > 0 && bereich.geschafft >= bereich.gesamt;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: stil.farbe.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(stil.icon, color: stil.farbe, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              bereich.name,
              style: AppTextStyles.bodyMedium(text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${bereich.geschafft}/${bereich.gesamt}',
            style: AppTextStyles.monoSmall(textDim),
          ),
          const SizedBox(width: 10),
          FortschrittsRing(
            wert: bereich.anteil,
            farbe: bereich.geschafft > 0 ? stil.farbe : textDim,
            hintergrund: border,
            fertig: fertig,
            textFarbe: textDim,
            klein: true,
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

  // ─── PRÜFUNGEN ────────────────────────────────────
  Widget _buildPruefungen(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _pruefungen.length; i++) ...[
            if (i > 0) Divider(height: 1, color: border),
            _pruefungsZeile(_pruefungen[i], border, text, textMid, textDim),
          ],
        ],
      ),
    );
  }

  Widget _pruefungsZeile(
    _PruefungsEintrag p,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final farbe = p.bestanden ? AppColors.success : textDim;
    final datum = p.datum == null
        ? ''
        : '${p.datum!.day.toString().padLeft(2, '0')}.'
            '${p.datum!.month.toString().padLeft(2, '0')}.${p.datum!.year}';
    final untertitel = [
      if (p.info != null && p.info!.isNotEmpty) p.info!,
      if (datum.isNotEmpty) datum,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: p.bestanden
                  ? AppColors.success.withValues(alpha: 0.16)
                  : border.withValues(alpha: 0.6),
            ),
            child: Icon(
              p.bestanden ? Icons.check_rounded : Icons.circle_outlined,
              size: 15,
              color: farbe,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: AppTextStyles.bodyMedium(text),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (untertitel.isNotEmpty)
                  Text(
                    untertitel,
                    style: AppTextStyles.bodySmall(textDim),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: border),
            ),
            child: Text(
              'Note ${p.note}',
              style: AppTextStyles.monoSmall(textDim),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${p.prozent}%',
            style: AppTextStyles.mono(
              size: 13,
              color: farbe,
              weight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
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
        ],
      ),
    );
  }

  // ─── GAST → ACCOUNT ───────────────────────────────
  Future<void> _openUpgradeScreen() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const UpgradeAccountScreen()),
    );
    if (ok == true && mounted) {
      // Profil-Cache verwerfen und neu laden,
      // damit Username/E-Mail direkt aktuell sind
      final cache = AppCacheService();
      cache.cachedMyProfile = null;
      cache.profileLoaded = false;
      await _loadProfile();
      if (mounted) setState(() {});
    }
  }

  Widget _buildGuestUpgradeCard(bool isDark, Color text, Color textMid) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openUpgradeScreen,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent.withOpacity(isDark ? 0.16 : 0.10),
                AppColors.accent.withOpacity(isDark ? 0.05 : 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.accent.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_add_alt_1_outlined,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account erstellen & Fortschritt sichern',
                      style: AppTextStyles.labelLarge(text),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Als Gast geht dein Fortschritt bei einer '
                      'Deinstallation verloren.',
                      style: AppTextStyles.bodySmall(textMid),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.accent,
                size: 14,
              ),
            ],
          ),
        ),
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
          if (_authService.isGuest)
            _actionTile(
              icon: Icons.person_add_alt_1_outlined,
              title: 'Account erstellen',
              subtitle: 'Fortschritt dauerhaft sichern',
              iconColor: AppColors.accent,
              onTap: _openUpgradeScreen,
              text: text,
              textMid: textMid,
              textDim: textDim,
            )
          else
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
            subtitle: 'Lernfortschritt auf diesem Gerät zurücksetzen',
            iconColor: AppColors.warning,
            onTap: _clearLocalData,
            text: text,
            textMid: textMid,
            textDim: textDim,
          ),
          _divider(border),
          // Pflicht seit Apple-Richtlinie 5.1.1(v): Die Kontoloeschung muss
          // in der App moeglich sein, nicht nur per E-Mail. Bewusst getrennt
          // von "Lokale Daten loeschen" und in Rot, damit niemand das eine
          // fuer das andere haelt.
          _actionTile(
            icon: Icons.person_remove_outlined,
            title: 'Konto löschen',
            subtitle: 'Konto und alle Daten endgültig entfernen',
            iconColor: AppColors.error,
            onTap: _deleteAccount,
            text: text,
            textMid: textMid,
            textDim: textDim,
          ),
        ],
      ),
    );
  }

  //---RECHTLICHES------------------------------------------------------

  Widget _buildLegalGroup(
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
            icon: Icons.info_outline,
            title: 'Impressum',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const LegalDocumentScreen(doc: LegalDoc.impressum),
              ),
            ),
            text: text,
            textMid: textMid,
            textDim: textDim,
          ),
          _divider(border),
          _actionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Datenschutz',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const LegalDocumentScreen(doc: LegalDoc.datenschutz),
              ),
            ),
            text: text,
            textMid: textMid,
            textDim: textDim,
          ),
          _divider(border),
          _actionTile(
            icon: Icons.description_outlined,
            title: 'AGB',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LegalDocumentScreen(doc: LegalDoc.agb),
              ),
            ),
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

/// Ein bewerteter Versuch einer IHK-Simulation fuers Profil.
class _PruefungsEintrag {
  final String name;
  final String? info;
  final DateTime? datum;
  final int prozent;
  final bool bestanden;

  const _PruefungsEintrag({
    required this.name,
    required this.info,
    required this.datum,
    required this.prozent,
    required this.bestanden,
  });

  /// IHK-Notenschluessel
  int get note {
    if (prozent >= 92) return 1;
    if (prozent >= 81) return 2;
    if (prozent >= 67) return 3;
    if (prozent >= 50) return 4;
    if (prozent >= 30) return 5;
    return 6;
  }
}
