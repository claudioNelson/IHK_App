import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/sound_service.dart';
import '../../services/badge_service.dart';
import '../../widgets/badge_celebration_dialog.dart';

class ZertifikatTestPage extends StatefulWidget {
  final int zertifikatId;
  final String zertifikatName;
  final int anzahlFragen;
  final int pruefungsdauer; // in Minuten
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

  // Fragen & Antworten
  List<dynamic> fragen = [];
  Map<int, List<dynamic>> gemischteAntworten = {};
  int aktuelleFrage = 0;
  Map<int, int> antworten = {}; // index -> antwort_id
  bool loading = true;
  bool pruefungAbgeschlossen = false;
  final _soundService = SoundService();
  final _badgeService = BadgeService();

  // Ergebnis
  int? score;
  bool? bestanden;

  // Timer
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
      print('⏸️ App pausiert - Timer gestoppt');
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      print('▶️ App fortgesetzt - Timer neu gestartet');
      if (!pruefungAbgeschlossen && _remainingSeconds > 0) {
        _startTimer();
      }
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

      // Antworten mischen
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e')));
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
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });

      // Warnung bei 10 Minuten
      if (_remainingSeconds == 600) {
        _showTimeWarning();
      }

      // Zeit abgelaufen
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
        title: const Row(
          children: [
            Icon(Icons.alarm, color: Colors.orange),
            SizedBox(width: 12),
            Text('Zeitwarnung'),
          ],
        ),
        content: const Text(
          'Noch 10 Minuten verbleibend!\n\nDie Prüfung wird automatisch beendet, wenn die Zeit abläuft.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
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
    setState(() {
      antworten[aktuelleFrage] = antwortId;
    });
  }

  void _naechsteFrage() {
    if (aktuelleFrage < fragen.length - 1) {
      setState(() {
        aktuelleFrage++;
      });
    }
  }

  void _vorherigeFrageGehen() {
    if (aktuelleFrage > 0) {
      setState(() {
        aktuelleFrage--;
      });
    }
  }

  Future<bool> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 12),
            Text('Prüfung abbrechen?'),
          ],
        ),
        content: const Text(
          'Möchtest du die Prüfung wirklich abbrechen?\n\nDein Fortschritt geht verloren.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Weiter üben'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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

    // Berechne Score
    int richtig = 0;
    for (int i = 0; i < fragen.length; i++) {
      final selectedId = antworten[i];
      if (selectedId == null) continue;

      final frage = fragen[i];
      final antwortListe = gemischteAntworten[frage['id']]!;
      final selected = antwortListe.firstWhere((a) => a['id'] == selectedId);

      if (selected['ist_richtig'] == true) {
        richtig++;
      }
    }

    final prozent = ((richtig / fragen.length) * 100).round();
    final passed = prozent >= widget.mindestPunktzahl;

    setState(() {
      score = prozent;
      bestanden = passed;
      pruefungAbgeschlossen = true;
    });

    // Ergebnis in Datenbank speichern
    await _saveResult(prozent, passed);

    // Sound abspielen

    // Sound abspielen
    if (passed) {
      _soundService.playSound(SoundType.victory);
      // Badges prüfen - mit kleiner Verzögerung damit UI fertig ist
      Future.delayed(const Duration(milliseconds: 500), () {
        _checkCertificateBadges();
      });
    } else {
      _soundService.playSound(SoundType.defeat);
    }
  }

  Future<void> _saveResult(int score, bool passed) async {
  try {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Prüfe ob schon ein Eintrag existiert
    final existing = await supabase
        .from('user_certificates')
        .select()
        .eq('user_id', userId)
        .eq('zertifikat_id', widget.zertifikatId)
        .maybeSingle();

    if (existing == null) {
      // Neuer Eintrag
      await supabase.from('user_certificates').insert({
        'user_id': userId,
        'zertifikat_id': widget.zertifikatId,
        'best_score': score,
        'passed': passed,
        'passed_at': passed ? DateTime.now().toIso8601String() : null,
        'attempts': 1,
      });
    } else {
      // Update: Beste Score und Versuche erhöhen
      final newBestScore = score > (existing['best_score'] ?? 0) 
          ? score 
          : existing['best_score'];
      final newPassed = passed || (existing['passed'] ?? false);
      
      await supabase
          .from('user_certificates')
          .update({
            'best_score': newBestScore,
            'passed': newPassed,
            'passed_at': (newPassed && existing['passed_at'] == null) 
                ? DateTime.now().toIso8601String() 
                : existing['passed_at'],
            'attempts': (existing['attempts'] ?? 0) + 1,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('zertifikat_id', widget.zertifikatId);
    }
    
    print('✅ Zertifikat-Ergebnis gespeichert');
  } catch (e) {
    print('❌ Fehler beim Speichern: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.zertifikatName)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (pruefungAbgeschlossen) {
      return _buildErgebnisScreen();
    }

    if (fragen.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.zertifikatName)),
        body: const Center(child: Text('Keine Fragen verfügbar')),
      );
    }

    final frage = fragen[aktuelleFrage];
    final antwortListe = gemischteAntworten[frage['id']]!;
    final selectedId = antworten[aktuelleFrage];
    final isLowTime = _remainingSeconds <= 600; // 10 Minuten

    return WillPopScope(
      onWillPop: _showExitDialog,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.zertifikatName),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isLowTime ? Colors.red.shade50 : Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isLowTime ? Colors.red : Colors.indigo,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 20,
                    color: isLowTime ? Colors.red : Colors.indigo,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isLowTime ? Colors.red : Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (aktuelleFrage + 1) / fragen.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(Colors.indigo),
              minHeight: 4,
            ),

            // Fragen-Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.indigo.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Frage ${aktuelleFrage + 1} von ${fragen.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selectedId != null
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedId != null
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedId != null ? Icons.check : Icons.warning,
                          size: 16,
                          color: selectedId != null
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          selectedId != null ? 'Beantwortet' : 'Offen',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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
            ),

            // Frage & Antworten
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Fragetext
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        frage['frage'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Antwort-Optionen
                    ...antwortListe.asMap().entries.map((entry) {
                      final index = entry.key;
                      final antwort = entry.value;
                      final antwortId = antwort['id'] as int;
                      final isSelected = selectedId == antwortId;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectAntwort(antwortId),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.indigo.shade50
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.indigo
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: Colors.indigo.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.indigo
                                          : Colors.grey.shade300,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + index),
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      antwort['text'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Navigation
            _buildNavigationBar(),
          ],
        ),
        backgroundColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildNavigationBar() {
    final beantwortet = antworten.length;
    final gesamt = fragen.length;
    final alleDone = beantwortet >= gesamt;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fortschrittsanzeige
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz, color: Colors.indigo, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '$beantwortet von $gesamt Fragen beantwortet',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Buttons
            Row(
              children: [
                if (aktuelleFrage > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _vorherigeFrageGehen,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Zurück'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.indigo),
                        foregroundColor: Colors.indigo,
                      ),
                    ),
                  ),
                if (aktuelleFrage > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: aktuelleFrage < fragen.length - 1
                        ? _naechsteFrage
                        : (alleDone ? _submitPruefung : null),
                    icon: Icon(
                      aktuelleFrage < fragen.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                    ),
                    label: Text(
                      aktuelleFrage < fragen.length - 1 ? 'Weiter' : 'Abgeben',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkCertificateBadges() async {
    if (bestanden != true) return; // Nur wenn bestanden

    try {
      print('🎓 _checkCertificateBadges() gestartet');

      // Mapping: Zertifikat-ID zu Badge-Key
      String? certKey;
      switch (widget.zertifikatId) {
        case 1:
          certKey = 'aws';
          break; // AWS
        case 2:
          certKey = 'sap';
          break; // SAP (kein Badge dafür)
        case 3:
          certKey = 'azure';
          break; // Azure
        case 4:
          certKey = 'gcp';
          break; // Google Cloud
      }

      final earnedCerts = <String>[];
      if (certKey != null) earnedCerts.add(certKey);

      print('🎓 Bestandenes Zertifikat: $certKey');

      final newBadges = await _badgeService.checkCertificateBadges(earnedCerts);
      print('🎓 Neue Badges: $newBadges');

      if (newBadges.isNotEmpty && mounted) {
        final allBadges = await _badgeService.getAllBadges();
        final earnedDetails = allBadges
            .where((b) => newBadges.contains(b['id']))
            .toList();

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
    final icon = bestanden! ? Icons.emoji_events : Icons.sentiment_dissatisfied;

    final timeTakenFormatted = _timeTakenSeconds != null
        ? _formatTime(_timeTakenSeconds!)
        : 'Unbekannt';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prüfungsergebnis'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(icon, size: 80, color: Colors.white),
              ),

              const SizedBox(height: 32),

              // Titel
              Text(
                bestanden!
                    ? 'Herzlichen Glückwunsch!'
                    : 'Leider nicht bestanden',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Score Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      bestanden! ? Icons.check_circle : Icons.cancel,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      bestanden! ? 'Bestanden!' : 'Nicht bestanden',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Statistiken
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildStatRow(
                        'Zertifikat',
                        widget.zertifikatName,
                        Icons.card_membership,
                        Colors.indigo,
                      ),
                      const Divider(height: 24),
                      _buildStatRow(
                        'Erreichte Punktzahl',
                        '$score%',
                        Icons.trending_up,
                        color,
                      ),
                      const Divider(height: 24),
                      _buildStatRow(
                        'Mindestpunktzahl',
                        '${widget.mindestPunktzahl}%',
                        Icons.flag,
                        Colors.grey,
                      ),
                      const Divider(height: 24),
                      _buildStatRow(
                        'Beantwortete Fragen',
                        '${antworten.length}/${fragen.length}',
                        Icons.quiz,
                        Colors.blue,
                      ),
                      const Divider(height: 24),
                      _buildStatRow(
                        'Benötigte Zeit',
                        timeTakenFormatted,
                        Icons.timer,
                        Colors.orange,
                      ),
                      if (_autoSubmitted) ...[
                        const Divider(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.alarm,
                                color: Colors.red.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Automatisch abgegeben (Zeit abgelaufen)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
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

              const SizedBox(height: 32),

              // Fortschrittsbalken
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Deine Leistung',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$score%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: score! / 100,
                          minHeight: 20,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '0%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            'Mindestpunktzahl: ${widget.mindestPunktzahl}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '100%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Zurück'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.indigo),
                        foregroundColor: Colors.indigo,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Nochmal'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
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
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
