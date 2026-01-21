import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../auth/change_password_screen.dart';

class NewProfilePage extends StatefulWidget {
  const NewProfilePage({super.key});

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  final _authService = AuthService();
  Map<String, dynamic>? _profile;
  bool _loading = true;
  bool _notificationsEnabled = true;
  bool _moduleViewAsList = false; // NEU: Modul-Ansicht

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadSettings();
  }

  Future<void> _loadProfile() async {
    try {
      print('📖 Lade Profil...');
      final profile = await _authService.getProfile();

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _loading = false;
      });

      print('✅ Profil geladen: ${profile?['username']}');
    } catch (e) {
      print('❌ Fehler beim Laden des Profils: $e');

      if (!mounted) return;

      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Laden: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getBool('notifications_enabled') ?? true;
      final viewAsList = prefs.getBool('module_view_as_list') ?? false; // NEU

      if (!mounted) return;

      setState(() {
        _notificationsEnabled = notifications;
        _moduleViewAsList = viewAsList; // NEU
      });
    } catch (e) {
      print('⚠️ Fehler beim Laden der Einstellungen: $e');
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', value);

      if (!mounted) return;

      setState(() {
        _notificationsEnabled = value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value
                ? '✅ Benachrichtigungen aktiviert'
                : '🔕 Benachrichtigungen deaktiviert',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Fehler beim Speichern: $e');
    }
  }

  // NEU: Toggle für Modul-Ansicht
  Future<void> _toggleModuleView(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('module_view_as_list', value);

      if (!mounted) return;

      setState(() {
        _moduleViewAsList = value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value ? '📋 Listenansicht aktiviert' : '🎨 Rasteransicht aktiviert',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Fehler beim Speichern: $e');
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abmelden?'),
        content: const Text('Möchtest du dich wirklich abmelden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        }

        await _authService.signOut();

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler beim Abmelden: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _editProfile() async {
    final usernameController = TextEditingController(
      text: _profile?['username'] ?? '',
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Benutzername ändern'),
        content: TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Neuer Benutzername',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = usernameController.text.trim();
              if (newName.isNotEmpty) {
                Navigator.pop(context, newName);
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    if (result != null && result != _profile?['username']) {
      try {
        await _authService.updateProfileInDB(username: result);
        await _loadProfile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Benutzername aktualisiert'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _clearLocalData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lokale Daten löschen?'),
        content: const Text(
          'Dies löscht deinen lokalen Lernfortschritt. '
          'Dein Account bleibt erhalten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
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
              content: Text('✅ ${keysToRemove.length} Einträge gelöscht'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'Unbekannt';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return 'Unbekannt';
    }
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final isFallback = _profile?['is_fallback'] == true;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header mit Profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.indigo.shade700, Colors.purple.shade600],
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          _getInitials(_profile?['username']),
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
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
                            child: const Icon(
                              Icons.warning,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _profile?['username'] ?? 'Unbekannt',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (isFallback) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '⚠️ Profil nicht synchronisiert',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatChip(
                        icon: Icons.access_time,
                        label: 'Dabei seit',
                        value: _formatDate(_profile?['created_at']),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account
                  const Text(
                    'Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 1,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('Benutzername ändern'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: _editProfile,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.lock_outline),
                          title: const Text('Passwort ändern'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChangePasswordScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Einstellungen
                  const Text(
                    'Einstellungen',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 1,
                    child: Column(
                      children: [
                        SwitchListTile(
                          secondary: const Icon(Icons.notifications_outlined),
                          title: const Text('Benachrichtigungen'),
                          subtitle: const Text('Push-Benachrichtigungen'),
                          value: _notificationsEnabled,
                          onChanged: _toggleNotifications,
                        ),
                        const Divider(height: 1),
                        // NEU: Modul-Ansicht Toggle
                        SwitchListTile(
                          secondary: Icon(
                            _moduleViewAsList ? Icons.list : Icons.grid_view,
                          ),
                          title: const Text('Modul-Ansicht'),
                          subtitle: Text(
                            _moduleViewAsList
                                ? 'Listenansicht'
                                : 'Rasteransicht',
                          ),
                          value: _moduleViewAsList,
                          onChanged: _toggleModuleView,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.delete_outline,
                            color: Colors.orange,
                          ),
                          title: const Text('Lokale Daten löschen'),
                          subtitle: const Text('Lernfortschritt zurücksetzen'),
                          onTap: _clearLocalData,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Abmelden'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
}
