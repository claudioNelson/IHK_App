import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../services/sound_service.dart';
import '../auth/change_password_screen.dart';
import '../../services/badge_service.dart';
import '../../services/app_cache_service.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class NewProfilePage extends StatefulWidget {
  const NewProfilePage({super.key});

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  final _authService = AuthService();
  final _soundService = SoundService();
  final _badgeService = BadgeService();

  Map<String, dynamic>? _profile;
  List<Map<String, dynamic>> _myBadges = [];
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden: $e')),
      );
    }
  }

  Future<void> _loadBadges() async {
    try {
      final badges = await _badgeService.getMyBadges();
      if (!mounted) return;
      setState(() => _myBadges = badges);
    } catch (_) {}
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Abmelden?'),
          ],
        ),
        content: const Text('Möchtest du dich wirklich abmelden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: _indigo),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Fehler: $e')));
        }
      }
    }
  }

  Future<void> _editProfile() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _profile?['username']);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Benutzername ändern'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Neuer Benutzername',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _indigo, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: _indigo),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: _indigo,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
    if (result != null && result.isNotEmpty && result != _profile?['username']) {
      try {
        await _authService.updateProfileInDB(username: result);
        await _loadProfile();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('✅ Benutzername aktualisiert'),
            backgroundColor: Colors.green,
          ));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Fehler: $e')));
        }
      }
    }
  }

  Future<void> _clearLocalData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Lokale Daten löschen?'),
        content: const Text(
            'Dies löscht deinen lokalen Lernfortschritt. Dein Account bleibt erhalten.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: _indigo),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final keysToRemove = prefs.getKeys().where((key) =>
            key.startsWith('fortschritt_') ||
            key.startsWith('score_') ||
            key.startsWith('async_match/')).toList();
        for (final key in keysToRemove) await prefs.remove(key);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('✅ ${keysToRemove.length} Einträge gelöscht'),
            backgroundColor: Colors.green,
          ));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Fehler: $e')));
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

  String _formatDate(dynamic date) {
    if (date == null) return 'Unbekannt';
    try {
      final dt = date is String ? DateTime.parse(date) : date as DateTime;
      final diff = DateTime.now().difference(dt);
      if (diff.inDays < 1) return 'Heute';
      if (diff.inDays < 7) return 'vor ${diff.inDays} Tagen';
      if (diff.inDays < 30) return 'vor ${(diff.inDays / 7).floor()} Wochen';
      if (diff.inDays < 365) return 'vor ${(diff.inDays / 30).floor()} Monaten';
      return 'vor ${(diff.inDays / 365).floor()} Jahren';
    } catch (_) {
      return 'Unbekannt';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final isFallback = _profile?['is_fallback'] == true;

    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5FF),
        body: Center(child: CircularProgressIndicator(color: _indigo)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
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
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
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
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _getInitials(_profile?['username']),
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: _indigo,
                                  fontWeight: FontWeight.bold,
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
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.warning_rounded,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _profile?['username'] ?? 'Unbekannt',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      if (isFallback) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('⚠️ Profil nicht synchronisiert',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Dabei-seit Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 14, color: Colors.white70),
                            const SizedBox(width: 6),
                            Text(
                              'Dabei seit ${_formatDate(_profile?['created_at'])}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      // Edit-Button
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: _editProfile,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_rounded,
                                  size: 14, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Profil bearbeiten',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
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
                  // ── BADGES ────────────────────────────────
                  if (_myBadges.isNotEmpty) ...[
                    _sectionTitle('Meine Badges',
                        Icons.military_tech_rounded, Colors.amber),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: _cardDeco(Colors.amber),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _myBadges.map((ub) {
                          final badge = ub['badges'] as Map<String, dynamic>;
                          return Tooltip(
                            message:
                                '${badge['name']}\n${badge['description']}',
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.amber.shade200),
                              ),
                              child: Text(badge['icon'] ?? '🏆',
                                  style: const TextStyle(fontSize: 22)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── ACCOUNT ───────────────────────────────
                  _sectionTitle('Account', Icons.manage_accounts_rounded, _indigo),
                  const SizedBox(height: 10),
                  Container(
                    decoration: _cardDeco(_indigo),
                    child: Column(
                      children: [
                        _actionTile(
                          icon: Icons.person_outline_rounded,
                          iconColor: _indigo,
                          title: 'Benutzername ändern',
                          onTap: _editProfile,
                        ),
                        _divider(),
                        _actionTile(
                          icon: Icons.lock_outline_rounded,
                          iconColor: const Color(0xFF7C3AED),
                          title: 'Passwort ändern',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ChangePasswordScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── EINSTELLUNGEN ─────────────────────────
                  _sectionTitle(
                      'Einstellungen', Icons.settings_rounded, Colors.teal),
                  const SizedBox(height: 10),
                  Container(
                    decoration: _cardDeco(Colors.teal),
                    child: Column(
                      children: [
                        _switchTile(
                          icon: Icons.notifications_outlined,
                          iconColor: Colors.orange,
                          title: 'Benachrichtigungen',
                          subtitle: 'Push-Benachrichtigungen',
                          value: _notificationsEnabled,
                          onChanged: _toggleNotifications,
                        ),
                        _divider(),
                        _switchTile(
                          icon: _soundsEnabled
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                          iconColor: Colors.green,
                          title: 'Sound-Effekte',
                          subtitle: 'Feedback bei Antworten',
                          value: _soundsEnabled,
                          onChanged: _toggleSounds,
                        ),
                        _divider(),
                        _switchTile(
                          icon: _moduleViewAsList
                              ? Icons.view_list_rounded
                              : Icons.grid_view_rounded,
                          iconColor: Colors.blue,
                          title: 'Modul-Ansicht',
                          subtitle: _moduleViewAsList
                              ? 'Listenansicht aktiv'
                              : 'Rasteransicht aktiv',
                          value: _moduleViewAsList,
                          onChanged: _toggleModuleView,
                        ),
                        _divider(),
                        _actionTile(
                          icon: Icons.delete_outline_rounded,
                          iconColor: Colors.red,
                          title: 'Lokale Daten löschen',
                          subtitle: 'Lernfortschritt zurücksetzen',
                          onTap: _clearLocalData,
                          trailingColor: Colors.red,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── LOGOUT ────────────────────────────────
                  GestureDetector(
                    onTap: _handleLogout,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.red.withOpacity(0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.logout_rounded,
                                color: Colors.red, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Text('Abmelden',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
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

  BoxDecoration _cardDeco(Color accent) => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      );

  Widget _sectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 10),
        Icon(icon, color: color, size: 17),
        const SizedBox(width: 6),
        Text(title,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _actionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? trailingColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  if (subtitle != null)
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: trailingColor ?? _indigo, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                if (subtitle != null)
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: _indigo),
        ],
      ),
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.only(left: 68),
        child: Divider(height: 1, color: Colors.grey.shade100),
      );
}