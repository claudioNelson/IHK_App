// lib/screens/onboarding/ziel_screen.dart
//
// "Dein Ziel": Pruefung (AP1/AP2), Fachrichtung (AE/SI) und Termin auf
// einer Seite. Wird aus dem Lernhub geoeffnet (Countdown-Karte) und spaeter
// aus dem Profil. Speichert ueber ZielService (profiles + SharedPreferences).
// Phase 1 von claude/pruefungs-countdown-plan.md.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ziel_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class ZielScreen extends StatefulWidget {
  const ZielScreen({super.key});

  /// "30. September 2026" - auch vom Lernhub-Countdown genutzt.
  static String datumText(DateTime d) {
    const monate = [
      'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli',
      'August', 'September', 'Oktober', 'November', 'Dezember',
    ];
    return '${d.day}. ${monate[d.month - 1]} ${d.year}';
  }

  @override
  State<ZielScreen> createState() => _ZielScreenState();
}

class _ZielScreenState extends State<ZielScreen> {
  final _service = ZielService();
  String _pruefung = 'AP1';
  String _fachrichtung = 'AE';
  DateTime? _datum;
  bool _datumUnbekannt = false;
  List<PruefungsTermin> _termine = const [];
  bool _laden = true;
  bool _speichert = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final ziel = _service.ziel ?? await _service.laden();
    final termine = await _service.termine();
    if (!mounted) return;
    setState(() {
      _termine = termine;
      if (ziel != null) {
        _pruefung = ziel.pruefung;
        _fachrichtung = ziel.fachrichtung;
        _datum = ziel.datum;
        _datumUnbekannt = ziel.datum == null;
      } else {
        _datum = _vorschlag(_pruefung);
      }
      _laden = false;
    });
  }

  DateTime? _vorschlag(String pruefung) {
    for (final t in _termine) {
      if (t.pruefung == pruefung) return t.datum;
    }
    return null;
  }

  Future<void> _datumWaehlen() async {
    final jetzt = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _datum ?? jetzt.add(const Duration(days: 30)),
      firstDate: jetzt,
      lastDate: DateTime(jetzt.year + 2),
      helpText: 'Prüfungstermin',
      cancelText: 'Abbrechen',
      confirmText: 'Übernehmen',
      // Kein locale-Parameter: die App hat keine flutter_localizations-
      // Delegates, ein Locale('de') wuerde hier werfen.
    );
    if (picked != null && mounted) {
      setState(() {
        _datum = picked;
        _datumUnbekannt = false;
      });
    }
  }

  Future<void> _speichern() async {
    setState(() => _speichert = true);
    await _service.speichern(
      PruefungsZiel(
        pruefung: _pruefung,
        fachrichtung: _fachrichtung,
        datum: _datumUnbekannt ? null : _datum,
      ),
    );
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final accentSoft =
        isDark ? AppColors.darkAccentSoft : AppColors.lightAccentSoft;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: text),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: _laden
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 1,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'DEIN ZIEL',
                              style: AppTextStyles.monoLabel(AppColors.accent),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Wann ist deine Prüfung?',
                          style: AppTextStyles.instrumentSerif(
                            size: 36,
                            color: text,
                            letterSpacing: -1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Daraus baut Lernarena deinen Countdown und '
                          'bald auch deinen Tagesplan.',
                          style: AppTextStyles.bodyMedium(textMid),
                        ),
                        const SizedBox(height: 28),

                        _label('PRÜFUNG', textDim),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _wahlKarte(
                                titel: 'AP1',
                                untertitel: 'Teil 1 · Ende 2. Lehrjahr',
                                aktiv: _pruefung == 'AP1',
                                onTap: () => setState(() {
                                  _pruefung = 'AP1';
                                  if (!_datumUnbekannt) {
                                    _datum = _vorschlag('AP1') ?? _datum;
                                  }
                                }),
                                surface: surface,
                                border: border,
                                text: text,
                                textMid: textMid,
                                accentSoft: accentSoft,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _wahlKarte(
                                titel: 'AP2',
                                untertitel: 'Teil 2 · Abschluss',
                                aktiv: _pruefung == 'AP2',
                                onTap: () => setState(() {
                                  _pruefung = 'AP2';
                                  if (!_datumUnbekannt) {
                                    _datum = _vorschlag('AP2') ?? _datum;
                                  }
                                }),
                                surface: surface,
                                border: border,
                                text: text,
                                textMid: textMid,
                                accentSoft: accentSoft,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        _label('FACHRICHTUNG', textDim),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _wahlKarte(
                                titel: 'AE',
                                untertitel: 'Anwendungsentwicklung',
                                aktiv: _fachrichtung == 'AE',
                                onTap: () =>
                                    setState(() => _fachrichtung = 'AE'),
                                surface: surface,
                                border: border,
                                text: text,
                                textMid: textMid,
                                accentSoft: accentSoft,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _wahlKarte(
                                titel: 'SI',
                                untertitel: 'Systemintegration',
                                aktiv: _fachrichtung == 'SI',
                                onTap: () =>
                                    setState(() => _fachrichtung = 'SI'),
                                surface: surface,
                                border: border,
                                text: text,
                                textMid: textMid,
                                accentSoft: accentSoft,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        _label('TERMIN', textDim),
                        const SizedBox(height: 10),
                        // Vorschlaege aus pruefungstermine fuer die gewaehlte Pruefung
                        for (final t in _termine.where(
                          (t) => t.pruefung == _pruefung,
                        )) ...[
                          _terminZeile(
                            titel: '${t.pruefung} ${t.bezeichnung}',
                            untertitel: ZielScreen.datumText(t.datum),
                            hinweis: t.hinweis,
                            aktiv: !_datumUnbekannt &&
                                _datum != null &&
                                _gleicherTag(_datum!, t.datum),
                            onTap: () => setState(() {
                              _datum = t.datum;
                              _datumUnbekannt = false;
                            }),
                            surface: surface,
                            border: border,
                            text: text,
                            textMid: textMid,
                            textDim: textDim,
                            accentSoft: accentSoft,
                          ),
                          const SizedBox(height: 8),
                        ],
                        _terminZeile(
                          titel: 'Anderes Datum',
                          untertitel: !_datumUnbekannt &&
                                  _datum != null &&
                                  !_termine.any(
                                    (t) =>
                                        t.pruefung == _pruefung &&
                                        _gleicherTag(_datum!, t.datum),
                                  )
                              ? ZielScreen.datumText(_datum!)
                              : 'Termin deiner IHK eintragen',
                          aktiv: !_datumUnbekannt &&
                              _datum != null &&
                              !_termine.any(
                                (t) =>
                                    t.pruefung == _pruefung &&
                                    _gleicherTag(_datum!, t.datum),
                              ),
                          onTap: _datumWaehlen,
                          trailing: Icons.calendar_month_outlined,
                          surface: surface,
                          border: border,
                          text: text,
                          textMid: textMid,
                          textDim: textDim,
                          accentSoft: accentSoft,
                        ),
                        const SizedBox(height: 8),
                        _terminZeile(
                          titel: 'Weiß ich noch nicht',
                          untertitel: 'Ohne Countdown, Tagesziel bleibt',
                          aktiv: _datumUnbekannt,
                          onTap: () => setState(() => _datumUnbekannt = true),
                          surface: surface,
                          border: border,
                          text: text,
                          textMid: textMid,
                          textDim: textDim,
                          accentSoft: accentSoft,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: surface,
                      border: Border(top: BorderSide(color: border)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _speichert ? null : _speichern,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: text,
                          foregroundColor: bg,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: AppTextStyles.labelLarge(bg),
                        ),
                        child: Text(_speichert ? 'Speichern …' : 'Ziel speichern'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  static bool _gleicherTag(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _label(String s, Color color) =>
      Text(s, style: AppTextStyles.monoLabel(color));

  Widget _wahlKarte({
    required String titel,
    required String untertitel,
    required bool aktiv,
    required VoidCallback onTap,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color accentSoft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: aktiv ? accentSoft : surface,
          border: Border.all(
            color: aktiv ? AppColors.accent : border,
            width: aktiv ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titel,
              style: AppTextStyles.instrumentSerif(
                size: 26,
                color: aktiv ? AppColors.accent : text,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(untertitel, style: AppTextStyles.bodySmall(textMid)),
          ],
        ),
      ),
    );
  }

  Widget _terminZeile({
    required String titel,
    required String untertitel,
    String? hinweis,
    required bool aktiv,
    required VoidCallback onTap,
    IconData? trailing,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
    required Color accentSoft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: aktiv ? accentSoft : surface,
          border: Border.all(
            color: aktiv ? AppColors.accent : border,
            width: aktiv ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: aktiv ? AppColors.accent : textDim,
                  width: 1.5,
                ),
                color: aktiv ? AppColors.accent : Colors.transparent,
              ),
              child: aktiv
                  ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titel, style: AppTextStyles.labelLarge(text)),
                  const SizedBox(height: 2),
                  Text(untertitel, style: AppTextStyles.bodySmall(textMid)),
                  if (hinweis != null && aktiv) ...[
                    const SizedBox(height: 6),
                    Text(hinweis, style: AppTextStyles.bodySmall(textDim)),
                  ],
                ],
              ),
            ),
            if (trailing != null) Icon(trailing, size: 18, color: textMid),
          ],
        ),
      ),
    );
  }
}
