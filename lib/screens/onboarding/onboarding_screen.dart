// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.quiz_rounded,
      gradient: [Color(0xFF4F46E5), Color(0xFF6366F1)],
      title: 'Echte Prüfungsfragen',
      description:
          'Über 600 Fragen aus allen IHK-Themenbereichen — so wie sie in der echten Abschlussprüfung vorkommen.',
      badge: '600+ Fragen',
    ),
    _OnboardingData(
      icon: Icons.assignment_rounded,
      gradient: [Color(0xFF2563EB), Color(0xFF3B82F6)],
      title: 'IHK Prüfungssimulation',
      description:
          'Simuliere die echte Abschlussprüfung mit Timer, Fragenübersicht und realistischen Bedingungen — für FIAE und FISI.',
      badge: 'FIAE & FISI',
    ),
    _OnboardingData(
      icon: Icons.psychology_rounded,
      gradient: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
      title: 'KI-Tutor Ada',
      description:
          'Deine persönliche KI-Assistentin erklärt Lösungen, gibt Feedback und hilft dir gezielt bei Schwächen.',
      badge: 'Powered by KI',
    ),
    _OnboardingData(
      icon: Icons.emoji_events_rounded,
      gradient: [Color(0xFFEA580C), Color(0xFFF97316)],
      title: 'Gegen andere antreten',
      description:
          'Fordere andere Azubis im AsyncMatch-Modus heraus und klettere in der Rangliste nach oben.',
      badge: 'AsyncMatch',
    ),
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [_indigoDark, _indigo]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.school_rounded,
                            color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'IHK App',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: _indigoDark),
                      ),
                    ],
                  ),
                  // Skip
                  TextButton(
                    onPressed: _finishOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade500,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                    child: const Text('Überspringen',
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),

            // ── Slide ───────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnboardingSlide(data: _pages[i]),
              ),
            ),

            // ── Dots ────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: _currentPage == i
                        ? const LinearGradient(
                            colors: [_indigoDark, _indigoLight])
                        : null,
                    color:
                        _currentPage == i ? null : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Button ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Zurück-Button (ab Seite 2)
                  if (_currentPage > 0) ...[
                    GestureDetector(
                      onTap: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.grey.shade200, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: _indigo, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Weiter / Starten Button
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isLast
                              ? [Colors.green.shade600, Colors.green.shade400]
                              : page.gradient,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: (isLast ? Colors.green : page.gradient[0])
                                .withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: () {
                            if (!isLast) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _finishOnboarding();
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isLast ? 'Jetzt starten' : 'Weiter',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isLast
                                      ? Icons.rocket_launch_rounded
                                      : Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

// ── Data Model ────────────────────────────────────────────────────────────────

class _OnboardingData {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String description;
  final String badge;

  const _OnboardingData({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.description,
    required this.badge,
  });
}

// ── Slide Widget ──────────────────────────────────────────────────────────────

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container mit Gradient + Glow
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: data.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: data.gradient[0].withOpacity(0.35),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(data.icon, size: 72, color: Colors.white),
          ),

          const SizedBox(height: 32),

          // Badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: data.gradient[0].withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: data.gradient[0].withOpacity(0.3)),
            ),
            child: Text(
              data.badge,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: data.gradient[0],
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Titel
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              height: 1.2,
            ),
          ),

          const SizedBox(height: 14),

          // Beschreibung
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}