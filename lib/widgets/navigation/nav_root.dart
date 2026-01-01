import 'package:flutter/material.dart';
import '../shared/nav_keep_alive.dart';
import '../../screens/module/modul_liste_screen.dart';
import '../../screens/zertifikate/zertifikate_screen.dart';
import '../../screens/simulation/simulation_screen.dart';
import '../../screens/admin/admin_panel_screen.dart';
import '../../screens/profile/new_profile_page.dart';
import '../../screens/exam_screens/specialization_selection_screen.dart';

class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  @override
  State<NavRoot> createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> {
  int _index = 0;

  late final List<Widget> _pages = [
    const NavKeepAlive(child: ModulListe()),
    const NavKeepAlive(child: ZertifikatePage()),
    const NavKeepAlive(child: SpecializationSelectionScreen()),
    const NavKeepAlive(child: SimulationPage()),
    const NavKeepAlive(child: AdminPanel()),
    const NavKeepAlive(child: NewProfilePage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Module',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_membership_outlined),
            selectedIcon: Icon(Icons.card_membership),
            label: 'Zertifikate',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Prüfung',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Matchmaking',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
