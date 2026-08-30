// lib/screens/kurse/kurs_uebersicht_screen.dart
//
// Kursplan: alle Lektionen als Kacheln, mit Fortschritt.
// Funktioniert für jeden Kurs — SQL wie Python.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/kurse/kurs_config.dart';
import '../../models/kurs_aufgabe.dart';
import '../../services/badge_service.dart';
import '../../widgets/badge_celebration_dialog.dart';
import '../../services/kurs_fortschritt_service.dart';
import '../../services/subscription_service.dart';
import '../../widgets/premium_kauf_sheet.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/kurs_theme.dart';
import '../../theme/theme_provider.dart';
import 'lektion_screen.dart';

class KursUebersichtScreen extends StatefulWidget {
  final Kurs kurs;

  const KursUebersichtScreen({super.key, required this.kurs});

  @override
  State<KursUebersichtScreen> createState() => _KursUebersichtScreenState();
}

class _KursUebersichtScreenState extends State<KursUebersichtScreen> {
  final _fortschritt = KursFortschrittService.instance;
  bool _bereit = false;

  @override
  void initState() {
    super.initState();
    _fortschritt.laden().then((_) {
      if (mounted) setState(() => _bereit = true);
    });
  }

  Set<String> get _geloest => _fortschritt.alleGeloesten();

  int _geloestIn(Lektion lektion) =>
      _fortschritt.geloestVon(lektion.aufgaben.map((a) => a.id));

  bool _istGesperrt(Lektion lektion) =>
      kursPremiumAktiv &&
      lektion.premium &&
      !SubscriptionService().isPremium;

  bool _istKomplett(Lektion lektion) =>
      lektion.aufgaben.isNotEmpty &&
      _geloestIn(lektion) >= lektion.aufgaben.length;

  /// Verriegelt = Vorgaenger-Lektion noch nicht komplett geloest.
  bool _istVerriegelt(int index) {
    if (!kursReihenfolgeAktiv || index == 0) return false;
    return !_istKomplett(widget.kurs.lektionen[index - 1]);
  }

  Future<void> _oeffnen(Lektion lektion, int index) async {
    if (_istVerriegelt(index)) {
      final vorher = widget.kurs.lektionen[index - 1];
      final offen = vorher.aufgaben.length - _geloestIn(vorher);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Löse erst Lektion ${vorher.nr} komplett. '
            'Es ${offen == 1 ? "fehlt noch 1 Aufgabe" : "fehlen noch $offen Aufgaben"}.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_istGesperrt(lektion)) {
      // Ohne Kaufmoeglichkeit (iOS, siehe premiumKaufMoeglich) bleibt die
      // Lektion einfach gesperrt. Kein Kauf-Sheet, kein Verweis nach aussen.
      if (!premiumKaufMoeglich) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Diese Lektion gehört zu Premium.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      final gekauft = await showPremiumKaufSheet(context);
      if (gekauft != true) return;
      setState(() {}); // Schloesser neu zeichnen
    }
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LektionScreen(
          lektion: lektion,
          kursTitel: widget.kurs.titel,
          bereitsGeloest: _geloest,
          onAufgabeGeloest: (id) {
            _fortschritt.alsGeloestMarkieren(id);
            setState(() {});
          },
        ),
      ),
    );
    setState(() {}); // Fortschritt neu zeichnen
    await _kursBadgesPruefen();
  }

  // Diagnose-Snackbar: bei Badge-Problemen auf true stellen, dann zeigt
  // die Kursuebersicht Login-Status und Lektionszaehler unten an.
  static const bool _badgeDebug = false;

  void _debugMeldung(String text) {
    if (!_badgeDebug || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Nach jeder Lektion: Kurs-Badges pruefen und Neue feiern.
  /// Fehler (offline, Gast ohne Login) brechen nie den Ablauf.
  Future<void> _kursBadgesPruefen() async {
    try {
      final nutzer = Supabase.instance.client.auth.currentUser;
      final fertige = widget.kurs.lektionen.where(_istKomplett).length;

      _debugMeldung(
        'DEBUG · Login: ${nutzer == null ? "KEINE SESSION" : (nutzer.email ?? "anonym/Gast ${nutzer.id.substring(0, 8)}")} '
        '· fertige Lektionen: $fertige',
      );

      final service = BadgeService();
      final neue = await service.checkKursBadges(
        kursSlug: widget.kurs.slug,
        abgeschlosseneLektionen: fertige,
        // Bei Kursen im Aufbau die GEPLANTE Lektionszahl, sonst wird man
        // mit 3 von 14 Lektionen schon Meister.
        lektionenGesamt: widget.kurs.lektionenFuerBadges,
      );

      if (neue.isEmpty) {
        _debugMeldung('DEBUG · Badge-Pruefung lief, nichts Neues vergeben');
        return;
      }
      if (!mounted) return;

      final details = await service.getBadgeDetails(neue);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => BadgeCelebrationDialog(
          badgeIds: neue,
          badgeDetails: details,
        ),
      );
    } catch (e) {
      debugPrint('Kurs-Badges: $e');
      _debugMeldung('DEBUG · Badge-Fehler: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    // Eigenes Theme aus den AppColors, damit alle Kurs-Widgets
    // automatisch in der Farbwelt der App gerendert werden.
    return Theme(
      data: kursTheme(isDark),
      child: Builder(builder: (context) => _inhalt(context, isDark)),
    );
  }

  Widget _inhalt(BuildContext context, bool isDark) {
    final farben = Theme.of(context).colorScheme;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    if (!_bereit) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final kursIds =
        widget.kurs.lektionen.expand((l) => l.aufgaben).map((a) => a.id);
    final gesamtAufgaben = widget.kurs.anzahlAufgaben;
    final gesamtGeloest = _fortschritt.geloestVon(kursIds);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // ─── Kopf im Stil des Level-Screens ────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: text,
                      ),
                      child: Icon(Icons.arrow_back,
                          size: 20,
                          color: isDark
                              ? AppColors.darkBg
                              : AppColors.lightBg),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text('KURS', style: AppTextStyles.monoLabel(AppColors.accent)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.kurs.titel,
            style: AppTextStyles.instrumentSerif(
              size: 34,
              color: text,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.kurs.beschreibung,
            style: AppTextStyles.bodyMedium(textMid),
          ),
          const SizedBox(height: 22),

          // ─── Fortschrittsleiste über den ganzen Kurs ───────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dein Fortschritt',
                        style: Theme.of(context).textTheme.labelLarge),
                    Text(
                      '$gesamtGeloest von $gesamtAufgaben Aufgaben',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: farben.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: gesamtAufgaben == 0
                        ? 0
                        : gesamtGeloest / gesamtAufgaben,
                    minHeight: 8,
                    backgroundColor: farben.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${widget.kurs.lektionen.length} Lektionen · '
                  'etwa ${widget.kurs.gesamtDauer} Minuten',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: farben.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'LEKTIONEN · ${widget.kurs.lektionen.length}',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),

          for (var i = 0; i < widget.kurs.lektionen.length; i++)
            _LektionsKachel(
              lektion: widget.kurs.lektionen[i],
              geloest: _geloestIn(widget.kurs.lektionen[i]),
              gesperrt: _istGesperrt(widget.kurs.lektionen[i]),
              verriegelt: _istVerriegelt(i),
              onTap: () => _oeffnen(widget.kurs.lektionen[i], i),
            ),
        ],
      ),
    );
  }
}

class _LektionsKachel extends StatelessWidget {
  final Lektion lektion;
  final int geloest;

  /// Premium-Gate (Kauf noetig).
  final bool gesperrt;

  /// Reihenfolge-Gate (Vorgaenger erst abschliessen).
  final bool verriegelt;

  final VoidCallback onTap;

  const _LektionsKachel({
    required this.lektion,
    required this.geloest,
    this.gesperrt = false,
    this.verriegelt = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;
    final gesamt = lektion.aufgaben.length;
    final fertig = gesamt > 0 && geloest >= gesamt;
    final begonnen = geloest > 0 && !fertig;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: verriegelt ? 0.45 : 1.0,
        child: Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: fertig
                    ? AppColors.success.withValues(alpha: 0.6)
                    : (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder),
              ),
            ),
            child: Row(
              children: [
                // Nummer oder Haken
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: fertig
                        ? const Color(0xFF5FD98A).withValues(alpha: 0.18)
                        : farben.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: fertig
                      ? const Icon(Icons.check,
                          color: Color(0xFF5FD98A), size: 22)
                      : verriegelt
                          ? Icon(Icons.lock_outline,
                              size: 20, color: farben.onSurfaceVariant)
                          : gesperrt
                              ? Icon(Icons.lock_outline,
                                  size: 20, color: farben.primary)
                              : Text(
                          '${lektion.nr}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: farben.primary,
                          ),
                        ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lektion.titel,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        lektion.kurzbeschreibung,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: farben.onSurfaceVariant,
                                ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 13, color: farben.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            '${lektion.dauerMinuten} Min',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: farben.onSurfaceVariant),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.edit_note,
                              size: 14, color: farben.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            begonnen
                                ? '$geloest / $gesamt Aufgaben'
                                : '$gesamt Aufgaben',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: begonnen
                                    ? farben.primary
                                    : farben.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Icon(Icons.chevron_right,
                    color: farben.onSurfaceVariant.withValues(alpha: 0.7)),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
