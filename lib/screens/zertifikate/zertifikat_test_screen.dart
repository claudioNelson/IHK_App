import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/sound_service.dart';
import '../../services/badge_service.dart';
import '../../widgets/badge_celebration_dialog.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class ZertifikatTestPage extends StatefulWidget {
  final int zertifikatId;
  final String zertifikatName;
  final int anzahlFragen;
  final int pruefungsdauer;
  final int mindestPunktzahl;

  const ZertifikatTestPage({
    super.key,
    required this.zertifikatId,
    required this.zertifikatName,
    required this.anzahlFragen,
    required this.pruefungsdauer,
    required this.mindestPunktzahl,
  });

  @override
  State<ZertifikatTestPage> createState() => _ZertifikatTestPageState();
}

class _ZertifikatTestPageState extends State<ZertifikatTestPage>
    with WidgetsBindingObserver {
  final supabase = Supabase.instance.client;

  List<dynamic> fragen = [];
  Map<int, List<dynamic>> gemischteAntworten = {};
  int aktuelleFrage = 0;
  Map<int, int> antworten = {};
  bool loading = true;
  bool pruefungAbgeschlossen = false;
  final _soundService = SoundService();
  final _badgeService = BadgeService();

  int? score;
  bool? bestanden;

  Timer? _timer;
  int _remainingSeconds = 0;
  DateTime? _startTime;
  int? _timeTakenSeconds;
  bool _autoSubmitted = false;

  @override
  void initState() {
    super.initState();
    _soundService.init();
    WidgetsBinding.instance.addObserver(this);
    _loadFragen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      if (!pruefungAbgeschlossen && _remainingSeconds > 0) _startTimer();
    }
  }

  Future<void> _loadFragen() async {
    try {
      final data = await supabase
          .from('fragen')
          .select('id, frage, antworten(id, text, ist_richtig)')
          .eq('zertifikat_id', widget.zertifikatId)
          .limit(widget.anzahlFragen);

      if (!mounted) return;
      for (final frage in data) {
        final antwortListe = List.from(frage['antworten'] as List);
        antwortListe.shuffle();
        gemischteAntworten[frage['id']] = antwortListe;
      }
      setState(() {
        fragen = data;
        loading = false;
      });
      _startPruefung();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e')));
      setState(() => loading = false);
    }
  }

  void _startPruefung() {
    _startTime = DateTime.now();
    _remainingSeconds = widget.pruefungsdauer * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() => _remainingSeconds--);
      if (_remainingSeconds == 600) _showTimeWarning();
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _autoSubmitted = true;
        _submitPruefung();
      }
    });
  }

  void _showTimeWarning() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.alarm_rounded, color: Colors.orange.shade700),
            ),
            const SizedBox(width: 12),
            const Text('Zeitwarnung'),
          ],
        ),
        content: const Text(
          'Noch 10 Minuten verbleibend!\n\nDie Prüfung wird automatisch beendet, wenn die Zeit abläuft.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: _indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _selectAntwort(int antwortId) {
    if (pruefungAbgeschlossen) return;
    _soundService.playSound(SoundType.click);
    setState(() => antworten[aktuelleFrage] = antwortId);
  }

  void _naechsteFrage() {
    if (aktuelleFrage < fragen.length - 1) setState(() => aktuelleFrage++);
  }

  void _vorherigeFrageGehen() {
    if (aktuelleFrage > 0) setState(() => aktuelleFrage--);
  }

  Future<bool> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.warning_rounded, color: Colors.red.shade600),
            ),
            const SizedBox(width: 12),
            const Text('Prüfung abbrechen?'),
          ],
        ),
        content: const Text(
          'Möchtest du die Prüfung wirklich abbrechen?\n\nDein Fortschritt geht verloren.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(foregroundColor: _indigo),
            child: const Text('Weiter üben'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _submitPruefung() async {
    _timer?.cancel();
    if (_startTime != null && _timeTakenSeconds == null) {
      _timeTakenSeconds = DateTime.now().difference(_startTime!).inSeconds;
    }

    int richtig = 0;
    for (int i = 0; i < fragen.length; i++) {
      final selectedId = antworten[i];
      if (selectedId == null) continue;
      final frage = fragen[i];
      final antwortListe = gemischteAntworten[frage['id']]!;
      final selected = antwortListe.firstWhere((a) => a['id'] == selectedId);
      if (selected['ist_richtig'] == true) richtig++;
    }

    final prozent = ((richtig / fragen.length) * 100).round();
    final passed = prozent >= widget.mindestPunktzahl;

    setState(() {
      score = prozent;
      bestanden = passed;
      pruefungAbgeschlossen = true;
    });

    await _saveResult(prozent, passed);

    if (passed) {
      _soundService.playSound(SoundType.victory);
      Future.delayed(const Duration(milliseconds: 500), _checkCertificateBadges);
    } else {
      _soundService.playSound(SoundType.defeat);
    }
  }

  Future<void> _saveResult(int score, bool passed) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final existing = await supabase
          .from('user_certificates')
          .select()
          .eq('user_id', userId)
          .eq('zertifikat_id', widget.zertifikatId)
          .maybeSingle();

      if (existing == null) {
        await supabase.from('user_certificates').insert({
          'user_id': userId,
          'zertifikat_id': widget.zertifikatId,
          'best_score': score,
          'passed': passed,
          'passed_at': passed ? DateTime.now().toIso8601String() : null,
          'attempts': 1,
        });
      } else {
        final newBestScore = score > (existing['best_score'] ?? 0) ? score : existing['best_score'];
        final newPassed = passed || (existing['passed'] ?? false);
        await supabase.from('user_certificates').update({
          'best_score': newBestScore,
          'passed': newPassed,
          'passed_at': (newPassed && existing['passed_at'] == null)
              ? DateTime.now().toIso8601String()
              : existing['passed_at'],
          'attempts': (existing['attempts'] ?? 0) + 1,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('user_id', userId).eq('zertifikat_id', widget.zertifikatId);
      }
    } catch (e) {
      print('❌ Fehler beim Speichern: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5FF),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: _indigo),
              const SizedBox(height: 16),
              Text('Lade Fragen...',
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
    }

    if (pruefungAbgeschlossen) return _buildErgebnisScreen();

    if (fragen.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Keine Fragen verfügbar',
              style: TextStyle(color: Colors.grey.shade500)),
        ),
      );
    }

    final frage = fragen[aktuelleFrage];
    final antwortListe = gemischteAntworten[frage['id']]!;
    final selectedId = antworten[aktuelleFrage];
    final isLowTime = _remainingSeconds <= 600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final exit = await _showExitDialog();
        if (exit && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5FF),
        body: Column(
          children: [
            // ── HEADER ──────────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_indigoDark, _indigo, _indigoLight],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _indigo.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    children: [
                      // Top row: back + title + timer
                      Row(
                        children: [
                          // Abbrechen Button
                          GestureDetector(
                            onTap: () async {
                              final exit = await _showExitDialog();
                              if (exit && context.mounted) Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.close_rounded,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.zertifikatName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Timer
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isLowTime
                                  ? Colors.red.withOpacity(0.3)
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isLowTime
                                    ? Colors.red.shade200
                                    : Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isLowTime
                                      ? Icons.alarm_rounded
                                      : Icons.timer_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _formatTime(_remainingSeconds),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Progress
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (aktuelleFrage + 1) / fragen.length,
                                backgroundColor:
                                    Colors.white.withOpacity(0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                                minHeight: 5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${aktuelleFrage + 1}/${fragen.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── CONTENT ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status chip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Frage ${aktuelleFrage + 1} von ${fragen.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: selectedId != null
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selectedId != null
                                  ? Colors.green.withOpacity(0.4)
                                  : Colors.orange.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selectedId != null
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                size: 13,
                                color: selectedId != null
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                selectedId != null ? 'Beantwortet' : 'Offen',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selectedId != null
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Fragetext
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _indigo.withOpacity(0.1), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: _indigo.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [_indigo, _indigoLight],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.help_outline_rounded,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              frage['frage'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Antworten
                    ...antwortListe.asMap().entries.map((entry) {
                      final index = entry.key;
                      final antwort = entry.value;
                      final antwortId = antwort['id'] as int;
                      final isSelected = selectedId == antwortId;

                      return GestureDetector(
                        onTap: () => _selectAntwort(antwortId),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _indigo.withOpacity(0.06)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? _indigo
                                  : Colors.grey.shade200,
                              width: isSelected ? 2 : 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? _indigo.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [_indigo, _indigoLight],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  color: isSelected
                                      ? null
                                      : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  antwort['text'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? const Color(0xFF1A1A2E)
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ── NAVIGATION ──────────────────────────────
            _buildNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    final beantwortet = antworten.length;
    final gesamt = fragen.length;
    final alleDone = beantwortet >= gesamt;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fortschritt
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _indigo.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz_outlined, color: _indigo, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '$beantwortet von $gesamt Fragen beantwortet',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _indigo,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (aktuelleFrage > 0) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _vorherigeFrageGehen,
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Zurück'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: _indigo),
                        foregroundColor: _indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: aktuelleFrage < fragen.length - 1
                        ? _naechsteFrage
                        : (alleDone ? _submitPruefung : null),
                    icon: Icon(
                      aktuelleFrage < fragen.length - 1
                          ? Icons.arrow_forward_rounded
                          : Icons.check_rounded,
                      size: 18,
                    ),
                    label: Text(
                      aktuelleFrage < fragen.length - 1 ? 'Weiter' : 'Abgeben',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: _indigo,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade200,
                      disabledForegroundColor: Colors.grey.shade500,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _checkCertificateBadges() async {
    if (bestanden != true) return;
    try {
      String? certKey;
      switch (widget.zertifikatId) {
        case 1: certKey = 'aws'; break;
        case 2: certKey = 'sap'; break;
        case 3: certKey = 'azure'; break;
        case 4: certKey = 'gcp'; break;
      }
      final earnedCerts = <String>[];
      if (certKey != null) earnedCerts.add(certKey);
      final newBadges = await _badgeService.checkCertificateBadges(earnedCerts);
      if (newBadges.isNotEmpty && mounted) {
        final allBadges = await _badgeService.getAllBadges();
        final earnedDetails =
            allBadges.where((b) => newBadges.contains(b['id'])).toList();
        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => BadgeCelebrationDialog(
              badgeIds: newBadges,
              badgeDetails: earnedDetails,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Badge-Fehler: $e');
    }
  }

  Widget _buildErgebnisScreen() {
    final color = bestanden! ? Colors.green : Colors.red;
    final timeTakenFormatted =
        _timeTakenSeconds != null ? _formatTime(_timeTakenSeconds!) : 'Unbekannt';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          // Header
          Container(
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
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Column(
                  children: [
                    const Text(
                      'Prüfungsergebnis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Score Circle
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.4), width: 3),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$score%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              bestanden! ? '✓ Bestanden' : '✗ Nicht bestanden',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                children: [
                  // Status Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            bestanden!
                                ? Icons.emoji_events_rounded
                                : Icons.sentiment_dissatisfied_rounded,
                            color: color,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          bestanden!
                              ? 'Herzlichen Glückwunsch!'
                              : 'Leider nicht bestanden',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Stats Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _indigo.withOpacity(0.1), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: _indigo.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _statRow('Zertifikat', widget.zertifikatName,
                              Icons.card_membership_rounded, _indigo),
                          _divider(),
                          _statRow('Erreichte Punktzahl', '$score%',
                              Icons.trending_up_rounded, color),
                          _divider(),
                          _statRow('Mindestpunktzahl',
                              '${widget.mindestPunktzahl}%',
                              Icons.flag_rounded, Colors.grey),
                          _divider(),
                          _statRow('Beantwortet',
                              '${antworten.length}/${fragen.length} Fragen',
                              Icons.quiz_outlined, Colors.blue),
                          _divider(),
                          _statRow('Benötigte Zeit', timeTakenFormatted,
                              Icons.timer_rounded, Colors.orange),
                          if (_autoSubmitted) ...[
                            _divider(),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.alarm_rounded,
                                      color: Colors.red.shade600, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Automatisch abgegeben (Zeit abgelaufen)',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Progress Bar Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: color.withOpacity(0.2), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Deine Leistung',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            Text('$score%',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: color)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: score! / 100,
                            minHeight: 16,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation(color),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0%',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500)),
                            Text(
                              'Mindest: ${widget.mindestPunktzahl}%',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text('100%',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Zurück'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: _indigo),
                            foregroundColor: _indigo,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Nochmal'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: _indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ZertifikatTestPage(
                                  zertifikatId: widget.zertifikatId,
                                  zertifikatName: widget.zertifikatName,
                                  anzahlFragen: widget.anzahlFragen,
                                  pruefungsdauer: widget.pruefungsdauer,
                                  mindestPunktzahl: widget.mindestPunktzahl,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 14))),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.only(left: 48),
        child: Divider(height: 16, color: Colors.grey.shade100),
      );
}