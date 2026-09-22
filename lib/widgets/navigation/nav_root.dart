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
import '../../services/streak_service.dart';

class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  /// Tab-Wechsel von aussen (z. B. Tagesplan im Lernhub -> Pruefen-Tab):
  /// `NavRoot.tabWechsel.value = 1`. Wird nach dem Wechsel wieder auf null
  /// gesetzt, damit derselbe Tab mehrfach angefordert werden kann.
  static final ValueNotifier<int?> tabWechsel = ValueNotifier<int?>(null);

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

  final _streakService = StreakService();

  @override
  void initState() {
    super.initState();
    NavRoot.tabWechsel.addListener(_onTabWechsel);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowStreakGreeting();
    });
  }

  @override
  void dispose() {
    NavRoot.tabWechsel.removeListener(_onTabWechsel);
    super.dispose();
  }

  void _onTabWechsel() {
    final ziel = NavRoot.tabWechsel.value;
    if (ziel == null || ziel < 0 || ziel >= _pages.length) return;
    if (mounted) setState(() => _index = ziel);
    NavRoot.tabWechsel.value = null;
  }

  /// Streak nur berechnen (einmal am Tag in der DB fortschreiben) und an
  /// den Lernhub melden (StreakService.aktuell). Kein Popup mehr
  /// (Entscheidung 21.09.2026): der Streak steht in der Countdown-Karte.
  Future<void> _maybeShowStreakGreeting() async {
    await _streakService.evaluate();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    final navBar = SizedBox(
      height: 64,
      child: Row(
        children: List.generate(
          _tabs.length,
          (i) => Expanded(
            child: _buildNavItem(
              index: i,
              tab: _tabs[i],
              isDark: isDark,
              text: text,
              textDim: textDim,
              border: border,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: bg,
      body: _pages[_index],
      bottomNavigationBar: isDark
          // Dark: flaechige Leiste mit oberer Linie (unveraendert)
          ? Container(
              decoration: BoxDecoration(
                color: surface,
                border: Border(top: BorderSide(color: border, width: 1)),
              ),
              child: SafeArea(top: false, child: navBar),
            )
          // Light (Variante D): schwebende weisse Pille mit Schatten
          : Container(
              color: bg,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: border),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.lightShadowStrong,
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: navBar,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required _TabItem tab,
    required bool isDark,
    required Color text,
    required Color textDim,
    required Color border,
  }) {
    final isSelected = _index == index;

    // Light: aktiver Tab als gefuellte Akzent-Pille, Label in Akzent
    if (!isDark) {
      return GestureDetector(
        onTap: () => setState(() => _index = index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 46,
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  tab.icon,
                  color: isSelected ? Colors.white : textDim,
                  size: 20,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                tab.label,
                style: AppTextStyles.interTight(
                  size: 10,
                  weight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.lightAccentInk : textDim,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
