import 'package:flutter/material.dart';
import '../../screens/module/modul_liste_screen.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/flashcard_service.dart';
import 'review_screen.dart';
import 'core_topics_screen.dart';
import 'flashcard_screen.dart';
import '../zertifikate/certificate_overview_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class LearningHubScreen extends StatefulWidget {
  const LearningHubScreen({super.key});

  @override
  State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  final _srsService = SpacedRepetitionService();
  final _flashcardService = FlashcardService();
  int _dueCount = 0;
  int _flashcardCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final count = await _srsService.getDueCount();
    final fcCount = await _flashcardService.getCount();
    print('🔢 getDueCount: $count');
    if (!mounted) return;
    setState(() {
      _dueCount = count;
      _flashcardCount = fcCount;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            forceElevated: true,
            backgroundColor: _indigoDark,
            clipBehavior: Clip.hardEdge,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_indigoDark, _indigo, _indigoLight],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lern Hub',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  'Alles auf einen Blick',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Wiederholungen
                _buildRepetitionCard(),
                const SizedBox(height: 14),

                // Flashcards
                _buildFlashcardCard(),
                const SizedBox(height: 14),

                // 2-er Grid: Module + Kernthemen
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallCard(
                        label: 'Module',
                        sub: 'Themen durcharbeiten',
                        icon: Icons.auto_stories_rounded,
                        color: _indigo,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ModulListe(),
                            ),
                          );
                          _loadCounts();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSmallCard(
                        label: 'Kernthemen',
                        sub: 'Prüfungsrelevante Basics',
                        icon: Icons.star_rounded,
                        color: const Color(0xFF0D9488),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CoreTopicsScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Zertifikate
                _buildCertificatesCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── WIEDERHOLUNGEN ───────────────────────────────────
  Widget _buildRepetitionCard() {
    final hasItems = _dueCount > 0;
    return GestureDetector(
      onTap: hasItems
          ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReviewScreen(totalCount: _dueCount),
                ),
              );
              _loadCounts();
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: hasItems
                ? [const Color(0xFFFFF7ED), Colors.white]
                : [Colors.grey.shade50, Colors.white],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasItems
                ? Colors.orange.withOpacity(0.3)
                : Colors.grey.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: hasItems
                  ? Colors.orange.withOpacity(0.1)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: hasItems
                      ? [Colors.orange, Colors.orange.shade700]
                      : [Colors.grey.shade400, Colors.grey.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (hasItems ? Colors.orange : Colors.grey).withOpacity(
                      0.3,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.replay_circle_filled_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Heute wiederholen',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (_loading)
                    SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.orange.shade400,
                      ),
                    )
                  else
                    Text(
                      hasItems
                          ? '$_dueCount Fragen warten auf dich'
                          : 'Alles erledigt für heute 🎉',
                      style: TextStyle(
                        fontSize: 13,
                        color: hasItems
                            ? Colors.orange.shade700
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            if (hasItems) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '$_dueCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ── FLASHCARDS ───────────────────────────────────────
  Widget _buildFlashcardCard() {
    final hasCards = _flashcardCount > 0;
    const cardColor = Color(0xFF7C3AED);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FlashcardScreen()),
        );
        _loadCounts();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: hasCards
                ? [const Color(0xFFF5F3FF), Colors.white]
                : [Colors.grey.shade50, Colors.white],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasCards
                ? cardColor.withOpacity(0.25)
                : Colors.grey.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: hasCards
                  ? cardColor.withOpacity(0.1)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: hasCards
                      ? [cardColor, const Color(0xFF5B21B6)]
                      : [Colors.grey.shade400, Colors.grey.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (hasCards ? cardColor : Colors.grey).withOpacity(
                      0.3,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text('🃏', style: TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meine Flashcards',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (_loading)
                    SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cardColor,
                      ),
                    )
                  else
                    Text(
                      hasCards
                          ? '$_flashcardCount falsch beantwortete Fragen'
                          : 'Noch keine Flashcards — fang an zu lernen!',
                      style: TextStyle(
                        fontSize: 13,
                        color: hasCards
                            ? cardColor.withOpacity(0.8)
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            if (hasCards) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: cardColor.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '$_flashcardCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ── KLEINE KARTE ─────────────────────────────────────
  Widget _buildSmallCard({
    required String label,
    required String sub,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.75)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              sub,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: color,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── ZERTIFIKATE ──────────────────────────────────────
  Widget _buildCertificatesCard() {
    const certColor = Color(0xFF7C3AED);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CertificateOverviewScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F3FF), Colors.white],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: certColor.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: certColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: certColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Zertifikate üben',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cloud-Zertifizierungen mit Erklärungen',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildCertChip('AWS', const Color(0xFFFF9900)),
                      const SizedBox(width: 6),
                      _buildCertChip('Azure', const Color(0xFF0078D4)),
                      const SizedBox(width: 6),
                      _buildCertChip('GCP', const Color(0xFF4285F4)),
                      const SizedBox(width: 6),
                      _buildCertChip('SAP', const Color(0xFF0070F2)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertChip(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
