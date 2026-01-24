import 'package:flutter/material.dart';
import '../shared/nav_keep_alive.dart';
import '../../screens/module/modul_liste_screen.dart';
import '../../screens/zertifikate/zertifikate_screen.dart';
import '../../screens/simulation/async_match_demo_screen.dart';
import '../../screens/profile/new_profile_page.dart';
import '../../pages/pruefung/ihk_pruefung_liste_screen.dart';

class NavRoot extends StatefulWidget {
  const NavRoot({super.key});
  @override
  State<NavRoot> createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> {
  int _index = 0;

  late final List<Widget> _pages = [
    const NavKeepAlive(child: ModulListe()),
    const NavKeepAlive(child: IHKPruefungListeScreen()),
    const NavKeepAlive(child: AsyncMatchDemoPage()),
    const NavKeepAlive(child: ZertifikatePage()),
    const NavKeepAlive(child: NewProfilePage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                0,
                Icons.menu_book_outlined,
                Icons.menu_book,
                'Lernen',
              ),
              _buildNavItem(
                1,
                Icons.assignment_outlined,
                Icons.assignment,
                'Prüfung',
              ),
              _buildNavItem(
                2,
                Icons.sports_esports_outlined,
                Icons.sports_esports,
                'Match',
              ),
              _buildNavItem(
                3,
                Icons.workspace_premium_outlined,
                Icons.workspace_premium,
                'Zertifikate',
              ),
              _buildNavItem(4, Icons.person_outline, Icons.person, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = _index == index;

    return GestureDetector(
      onTap: () => setState(() => _index = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
