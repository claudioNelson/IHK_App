import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/nav_keep_alive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import '../../screens/learning/learning_hub_screen.dart';
import '../../screens/pruefen/pruefen_screen.dart';
import '../../screens/simulation/async_match_demo_screen.dart';
import '../../screens/profile/new_profile_page.dart';

class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  @override
  State<NavRoot> createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> {
  int _index = 0;

  late final List<Widget> _pages = [
    const NavKeepAlive(child: LearningHubScreen()),
    const NavKeepAlive(child: PruefenScreen()),
    const NavKeepAlive(child: AsyncMatchDemoPage()),
    const NavKeepAlive(child: NewProfilePage()),
  ];

  static const _tabs = [
    _TabItem(icon: Icons.menu_book_outlined, label: 'Lernen'),
    _TabItem(icon: Icons.timer_outlined, label: 'Prüfen'),
    _TabItem(icon: Icons.bolt_outlined, label: 'Arena'),
    _TabItem(icon: Icons.person_outline, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: _pages[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surface,
          border: Border(top: BorderSide(color: border, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(
                _tabs.length,
                (i) => Expanded(
                  child: _buildNavItem(
                    index: i,
                    tab: _tabs[i],
                    text: text,
                    textDim: textDim,
                    border: border,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required _TabItem tab,
    required Color text,
    required Color textDim,
    required Color border,
  }) {
    final isSelected = _index == index;

    return GestureDetector(
      onTap: () => setState(() => _index = index),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          if (isSelected)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0),
                      AppColors.accent,
                      AppColors.accent.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Icon(
                    tab.icon,
                    color: isSelected ? text : textDim,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tab.label,
                  style: isSelected
                      ? AppTextStyles.interTight(
                          size: 10,
                          weight: FontWeight.w600,
                          color: text,
                          letterSpacing: 0,
                        )
                      : AppTextStyles.interTight(
                          size: 10,
                          weight: FontWeight.w500,
                          color: textDim,
                          letterSpacing: 0,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;

  const _TabItem({required this.icon, required this.label});
}
