import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/async_duel_service.dart';
import '../../../async_match_progress.dart';
import 'dart:async';
import '../../../widgets/report_dialog.dart';
import '../../../services/sound_service.dart';
import '../../services/badge_service.dart';
import '../../widgets/badge_celebration_dialog.dart';

class AsyncMatchPlayPage extends StatefulWidget {
  final String matchId;
  const AsyncMatchPlayPage({super.key, required this.matchId});

  @override
  State<AsyncMatchPlayPage> createState() => _AsyncMatchPlayPageState();
}

class _AsyncMatchPlayPageState extends State<AsyncMatchPlayPage> {
  final _svc = AsyncDuelService();
  final _soundService = SoundService();

  AsyncMatchProgressStore? _store;
  AsyncMatchProgress? _progress;

  List<dynamic> _questions = [];
  int _idx = 0;
  bool _loading = true;

  bool _answered = false;
  bool _submitting = false;
  bool _wasCorrect = false;
  int? _selectedAnswerId;
  bool _waitingForOpponent = false;

  // NEU - Für fill_blank und sequence
  Map<int, String> _fillBlankAnswers = {}; // Lücke-Index -> Antwort
  List<String> _sequenceOrder = []; // Aktuelle Reihenfolge
  Map<int, List<dynamic>> _shuffledAnswers = {};

  bool _matchCompleted = false;
  Map<String, dynamic>? _finalScores;

  Timer? _timer;
  int _timeLeft = 30;
  final int _maxTime = 30;
  final _badgeService = BadgeService();

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'local';

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  Future<void> _init() async {
    try {
      print('🟢 _init() gestartet für Match: ${widget.matchId}');

      // Sound Service initialisieren
      await _soundService.init();

      _store ??= await AsyncMatchProgressStore.instance;
      _progress = await _store!.ensure(_userId, widget.matchId);

      print('🟡 Lade Match-Daten...');
      final data = await _svc.loadMatch(widget.matchId);
      print('🟢 Match-Daten geladen: $data');

      final q = (data['questions'] as List<dynamic>).toList()
        ..sort((a, b) => (a['idx'] as int).compareTo(b['idx'] as int));

      print('🟢 Anzahl Fragen: ${q.length}');
      _questions = q;

      final myAnswers = data['myAnswers'] as List<dynamic>;
      print('🟢 Bereits beantwortete Fragen: ${myAnswers.length}');

      if (myAnswers.length >= _questions.length) {
        print('✅ Alle Fragen bereits beantwortet, finalisiere...');
        await _tryFinalize();
        return;
      }

      final answeredIdxs = myAnswers.map((a) => a['idx'] as int).toSet();
      _idx = 0;
      for (int i = 0; i < _questions.length; i++) {
        final qIdx = _questions[i]['idx'] as int;
        if (!answeredIdxs.contains(qIdx)) {
          _idx = i;
          break;
        }
      }

      _progress!.currentIdx = _idx;
      await _store!.save(_progress!);

      print('🟢 Starte bei Frage $_idx');

      // Timer starten
      _startTimer();
    } catch (e, stackTrace) {
      print('🔴 FEHLER in _init:');
      print('🔴 Error: $e');
      print('🔴 StackTrace: $stackTrace');

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = _maxTime;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _timeLeft--;
      });

      if (_timeLeft <= 0) {
        timer.cancel();
        _onTimeUp();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _onTimeUp() {
    if (_answered || _submitting) return;

    _soundService.playSound(SoundType.timeUp); // ← NEU

    print('⏰ Zeit abgelaufen für Frage $_idx');

    setState(() {
      _answered = true;
      _wasCorrect = false;
      _selectedAnswerId = null;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _next();
    });
  }

  // Für Multiple Choice
  Future<void> _submitMultipleChoice(int answerId, bool correct) async {
    if (_submitting || _answered) return;

    _stopTimer();

    setState(() {
      _submitting = true;
      _selectedAnswerId = answerId;
    });

    final q = _questions[_idx];

    try {
      final ok = await _svc.submitAnswer(
        matchId: widget.matchId,
        idx: q['idx'] as int,
        answerId: answerId,
      );

      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Antwort nicht akzeptiert ❌')),
          );
          setState(() {
            _submitting = false;
            _selectedAnswerId = null;
          });
        }
        return;
      }

      _progress!.answers[_idx] = answerId;
      await _store!.save(_progress!);

      setState(() {
        _answered = true;
        _wasCorrect = correct;
      });

      print('🔊 Spiele Sound: ${correct ? "correct" : "wrong"}');
      if (correct) {
        _soundService.playSound(SoundType.correct);
      } else {
        _soundService.playSound(SoundType.wrong);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      setState(() {
        _submitting = false;
        _selectedAnswerId = null;
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _submitSpecialQuestion(
    bool isCorrect,
    dynamic userAnswer,
  ) async {
    if (_submitting || _answered) return;

    _stopTimer();

    setState(() {
      _submitting = true;
    });

    final q = _questions[_idx];

    try {
      final ok = await _svc.submitAnswer(
        matchId: widget.matchId,
        idx: q['idx'] as int,
        answerId: 1, // Dummy-ID für Supabase
      );

      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Antwort nicht akzeptiert ❌')),
          );
          setState(() {
            _submitting = false;
          });
        }
        return;
      }

      _progress!.answers[_idx] = 1;
      await _store!.save(_progress!);

      setState(() {
        _answered = true;
        _wasCorrect = isCorrect;
      });

      if (isCorrect) {
        _soundService.playSound(SoundType.correct);
      } else {
        _soundService.playSound(SoundType.wrong);
      }

      // NEU: Automatisch weiter nach kurzer Pause
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _next();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      setState(() {
        _submitting = false;
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _next() async {
    if (_idx + 1 >= _questions.length) {
      await _tryFinalize();
      return;
    }

    setState(() {
      _idx++;
      _answered = false;
      _wasCorrect = false;
      _selectedAnswerId = null;
      _fillBlankAnswers = {}; // NEU - Reset
      _sequenceOrder = []; // NEU - Reset
    });

    _progress!.currentIdx = _idx;
    await _store!.save(_progress!);
    _startTimer();
  }

  Future<void> _tryFinalize() async {
    try {
      final status = await _svc.tryFinalize(widget.matchId);
      print('🏁 Finalize-Status: $status');

      if (status == 'completed' || status == 'finalized') {
        final scores = await _svc.loadScores(widget.matchId);
        setState(() {
          _matchCompleted = true;
          _finalScores = scores;
        });
      } else if (status == 'waiting') {
        setState(() {
          _waitingForOpponent = true;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Match-Status: $status')));
        }
      }
    } catch (e) {
      print('🔴 Fehler beim Finalisieren: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler beim Abschluss: $e')));
      }
    }
  }

  String _getQuestionType() {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    return frageData['question_type'] as String? ?? 'multiple_choice';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('AsyncMatch')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_waitingForOpponent) {
      return _buildWaitingScreen();
    }
    if (_matchCompleted && _finalScores != null) {
      return _buildResultScreen();
    }
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('AsyncMatch')),
        body: const Center(child: Text('Keine Fragen verfügbar')),
      );
    }
    final questionType = _getQuestionType();
    return Scaffold(
      appBar: AppBar(
        title: Text('Frage ${_idx + 1} / ${_questions.length}'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3730A3), Color(0xFF6366F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Timer (unverändert)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _timeLeft <= 5
                  ? Colors.red
                  : _timeLeft <= 10
                  ? Colors.orange
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$_timeLeft',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Report Button (unverändert)
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Problem melden',
            onPressed: () {
              if (_questions.isEmpty || _idx >= _questions.length) return;
              final q = _questions[_idx];
              final frageData = q['fragen'];
              final frageId = frageData['id'] as int;
              showDialog(
                context: context,
                builder: (context) =>
                    ReportDialog(frageId: frageId, screenType: 'async_match'),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_submitting) const LinearProgressIndicator(),
            const SizedBox(height: 16),
            // Render based on question type
            Expanded(
              child: SingleChildScrollView(
                // NEU:
                child: questionType == 'fill_blank'
                    ? _buildFillBlankQuestion()
                    : questionType == 'sequence'
                    ? _buildSequenceQuestion()
                    : questionType == 'dns_port_match'
                    ? _buildDnsPortMatchQuestion()
                    : questionType == 'freitext_ada'
                    ? _buildFreitextQuestion()
                    : _buildMultipleChoiceQuestion(),
              ),
            ),
            const SizedBox(height: 16),
            if (_answered)
              ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                ),
                child: Text(
                  _idx + 1 >= _questions.length ? 'Beenden' : 'Weiter',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDnsPortMatchQuestion() {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    final calcData =
        frageData['calculation_data'] as Map<String, dynamic>? ?? {};
    final options = (calcData['options'] as List?)?.cast<String>() ?? [];
    final correctAnswer = calcData['correct_answer'] as String? ?? '';

    if (!_shuffledAnswers.containsKey(_idx)) {
      final list = options
          .map((o) => {'text': o, 'ist_richtig': o == correctAnswer})
          .toList();
      list.shuffle();
      _shuffledAnswers[_idx] = list;
    }
    final antworten = _shuffledAnswers[_idx]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.indigo.shade700, Colors.indigo.shade500],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Text(
            frageText,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...antworten.asMap().entries.map((entry) {
          final i = entry.key;
          final a = entry.value as Map<String, dynamic>;
          final text = a['text'] as String;
          final correct = a['ist_richtig'] == true;
          final label = String.fromCharCode(65 + i);

          Color borderColor = Colors.grey.shade300;
          Color bgColor = Colors.white;
          Color labelBg = Colors.grey.shade100;
          Color labelText = Colors.grey.shade600;
          Widget? trailingIcon;

          if (_answered) {
            if (_selectedAnswerId == i && _wasCorrect) {
              borderColor = Colors.green;
              bgColor = Colors.green.shade50;
              labelBg = Colors.green;
              labelText = Colors.white;
              trailingIcon = const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 22,
              );
            } else if (_selectedAnswerId == i && !_wasCorrect) {
              borderColor = Colors.red;
              bgColor = Colors.red.shade50;
              labelBg = Colors.red;
              labelText = Colors.white;
              trailingIcon = const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 22,
              );
            } else if (correct) {
              borderColor = Colors.green.shade300;
              bgColor = Colors.green.shade50;
              labelBg = Colors.green.shade300;
              labelText = Colors.white;
            }
          } else if (_selectedAnswerId == i) {
            borderColor = Colors.indigo;
            bgColor = Colors.indigo.shade50;
            labelBg = Colors.indigo;
            labelText = Colors.white;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: _answered || _submitting
                  ? null
                  : () {
                      setState(() => _selectedAnswerId = i);
                      _submitMultipleChoice(i, correct);
                    },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: labelBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: labelText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: 8),
                      trailingIcon,
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFreitextQuestion() {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    final calcData =
        frageData['calculation_data'] as Map<String, dynamic>? ?? {};
    final keywords = (calcData['keywords'] as List?)?.cast<String>() ?? [];
    final controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.indigo.shade700, Colors.indigo.shade500],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Text(
            frageText,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (!_answered) ...[
          TextField(
            controller: controller,
            maxLines: 5,
            maxLength: calcData['max_length'] as int? ?? 500,
            decoration: InputDecoration(
              hintText: 'Deine Antwort...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _submitting
                ? null
                : () {
                    final text = controller.text.toLowerCase();
                    final hits = keywords
                        .where((k) => text.contains(k.toLowerCase()))
                        .length;
                    final isCorrect = hits >= (keywords.length * 0.5).ceil();
                    _submitSpecialQuestion(isCorrect, controller.text);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Antwort prüfen',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _wasCorrect ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _wasCorrect ? Colors.green : Colors.orange,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _wasCorrect ? '✅ Gut erklärt!' : '💡 Wichtige Begriffe:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: keywords
                      .map(
                        (k) => Chip(
                          label: Text(k, style: const TextStyle(fontSize: 12)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMultipleChoiceQuestion() {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    if (!_shuffledAnswers.containsKey(_idx)) {
      final list = (frageData['antworten'] as List<dynamic>? ?? []).toList();
      list.shuffle();
      _shuffledAnswers[_idx] = list;
    }
    final antworten = _shuffledAnswers[_idx]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Frage-Card mit Gradient
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo.shade700, Colors.indigo.shade500],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Frage ${_idx + 1} von ${_questions.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                frageText,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Antwort-Optionen
        Text(
          'Wähle die richtige Antwort:',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),

        ...antworten.asMap().entries.map((entry) {
          final i = entry.key;
          final a = entry.value;
          final aid = a['id'] as int;
          final text = a['text'] as String;
          final correct = a['ist_richtig'] == true;
          final selected = _selectedAnswerId == aid;

          // Label A, B, C, D
          final label = String.fromCharCode(65 + i);

          Color borderColor = Colors.grey.shade300;
          Color bgColor = Colors.white;
          Color labelBg = Colors.grey.shade100;
          Color labelText = Colors.grey.shade600;
          Widget? trailingIcon;

          if (_answered) {
            if (selected && _wasCorrect) {
              borderColor = Colors.green;
              bgColor = Colors.green.shade50;
              labelBg = Colors.green;
              labelText = Colors.white;
              trailingIcon = const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 22,
              );
            } else if (selected && !_wasCorrect) {
              borderColor = Colors.red;
              bgColor = Colors.red.shade50;
              labelBg = Colors.red;
              labelText = Colors.white;
              trailingIcon = const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 22,
              );
            } else if (correct) {
              borderColor = Colors.green.shade300;
              bgColor = Colors.green.shade50;
              labelBg = Colors.green.shade300;
              labelText = Colors.white;
            }
          } else if (selected) {
            borderColor = Colors.indigo;
            bgColor = Colors.indigo.shade50;
            labelBg = Colors.indigo;
            labelText = Colors.white;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _answered || _submitting
                    ? null
                    : () => _submitMultipleChoice(aid, correct),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Label-Kreis
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: labelBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: labelText,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        trailingIcon,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFillBlankQuestion() {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    final calculationData =
        frageData['calculation_data'] as Map<String, dynamic>? ?? {};

    final blanks =
        (calculationData['blanks'] as List?)?.cast<Map<String, dynamic>>() ??
        [];

    // Alle ausgefüllt?
    final allFilled = _fillBlankAnswers.length == blanks.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(frageText, style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 24),

        // Lücken
        ...List.generate(blanks.length, (index) {
          final blank = blanks[index];
          final options = (blank['options'] as List?)?.cast<String>() ?? [];
          final selectedAnswer = _fillBlankAnswers[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Lücke ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (selectedAnswer != null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.indigo.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedAnswer,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: _answered || _submitting
                                    ? null
                                    : () {
                                        setState(() {
                                          _fillBlankAnswers.remove(index);
                                        });
                                      },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Expanded(
                        child: Text(
                          '_____',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
                if (selectedAnswer == null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: options.map((option) {
                      final isUsed = _fillBlankAnswers.values.contains(option);

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _answered || _submitting || isUsed
                              ? null
                              : () {
                                  setState(() {
                                    _fillBlankAnswers[index] = option;
                                  });
                                },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isUsed
                                  ? Colors.grey.shade200
                                  : Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isUsed
                                    ? Colors.grey.shade400
                                    : Colors.indigo.shade300,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isUsed
                                    ? Colors.grey.shade500
                                    : Colors.indigo.shade700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 16),

        // Submit Button
        if (!_answered)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_submitting || !allFilled)
                  ? null
                  : () {
                      // Prüfe Korrektheit
                      bool allCorrect = true;
                      for (int i = 0; i < blanks.length; i++) {
                        final correctAnswer =
                            blanks[i]['correctAnswer'] as String;
                        final userAnswer = _fillBlankAnswers[i];
                        if (userAnswer != correctAnswer) {
                          allCorrect = false;
                          break;
                        }
                      }

                      _submitSpecialQuestion(allCorrect, _fillBlankAnswers);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                allFilled ? 'Prüfen' : 'Bitte alle Lücken ausfüllen',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSequenceQuestion() {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    final calculationData =
        frageData['calculation_data'] as Map<String, dynamic>? ?? {};

    final items = (calculationData['items'] as List?)?.cast<String>() ?? [];
    final correctOrder =
        (calculationData['correctOrder'] as List?)?.cast<String>() ?? [];

    // Initialisiere _sequenceOrder wenn leer
    if (_sequenceOrder.isEmpty && items.isNotEmpty) {
      _sequenceOrder = List<String>.filled(items.length, '');
    }

    // Alle Slots gefüllt?
    final allFilled =
        _sequenceOrder.where((s) => s.isNotEmpty).length == items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(frageText, style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 24),

        // Slots
        ...List.generate(items.length, (index) {
          final item = _sequenceOrder.length > index
              ? _sequenceOrder[index]
              : '';
          final isEmpty = item.isEmpty;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // Positions-Nummer
                Container(
                  width: 40,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Slot
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isEmpty || _answered || _submitting
                          ? null
                          : () {
                              setState(() {
                                _sequenceOrder[index] = '';
                              });
                            },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isEmpty ? Colors.white : Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isEmpty
                                ? Colors.grey.shade300
                                : Colors.indigo.shade300,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                isEmpty ? '__________' : item,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isEmpty
                                      ? FontWeight.normal
                                      : FontWeight.w500,
                                  color: isEmpty
                                      ? Colors.grey.shade400
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (!isEmpty && !_answered && !_submitting)
                              Icon(
                                Icons.close,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 24),

        // Auswahl
        if (!_answered) ...[
          Text(
            'Wähle aus:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              final isSelected = _sequenceOrder.contains(item);

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _answered || _submitting || isSelected
                      ? null
                      : () {
                          setState(() {
                            // Finde ersten leeren Slot
                            final emptyIndex = _sequenceOrder.indexOf('');
                            if (emptyIndex != -1) {
                              _sequenceOrder[emptyIndex] = item;
                            }
                          });
                        },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.grey.shade200
                          : Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.grey.shade400
                            : Colors.indigo.shade300,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.grey.shade500
                            : Colors.indigo.shade700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Submit Button
        if (!_answered)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_submitting || !allFilled)
                  ? null
                  : () {
                      // Prüfe Korrektheit
                      bool isCorrect = true;
                      for (int i = 0; i < correctOrder.length; i++) {
                        if (i >= _sequenceOrder.length ||
                            _sequenceOrder[i] != correctOrder[i]) {
                          isCorrect = false;
                          break;
                        }
                      }

                      _submitSpecialQuestion(isCorrect, _sequenceOrder);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                allFilled ? 'Prüfen' : 'Bitte alle Positionen ausfüllen',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Match abgeschlossen')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_empty, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                'Warte auf Gegner...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Du hast alle Fragen beantwortet!\nDas Ergebnis wird angezeigt, sobald dein Gegner fertig ist.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() => _loading = true);
                  await _tryFinalize();
                  setState(() => _loading = false);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Status prüfen'),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Zurück'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final myScore = _finalScores?['my_score'] ?? 0;
    final oppScore = _finalScores?['opponent_score'] ?? 0;
    final myProfile = _finalScores?['my_profile'] as Map<String, dynamic>?;
    final oppProfile =
        _finalScores?['opponent_profile'] as Map<String, dynamic>?;

    final myName = myProfile?['username'] ?? 'Du';
    final oppName = oppProfile?['username'] ?? 'Gegner';

    final isWinner = myScore > oppScore;
    final isDraw = myScore == oppScore;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isWinner) {
        _soundService.playSound(SoundType.victory);
      } else if (!isDraw) {
        _soundService.playSound(SoundType.defeat);
      }

      // Badges prüfen
      print('🏆 Prüfe Badges...');
      final newBadges = await _badgeService.checkMatchBadges();
      print('🏆 Neue Badges: $newBadges');
      if (newBadges.isNotEmpty && mounted) {
        // Badge-Details laden
        final allBadges = await _badgeService.getAllBadges();
        final earnedDetails = allBadges
            .where((b) => newBadges.contains(b['id']))
            .toList();

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => BadgeCelebrationDialog(
              badgeIds: newBadges,
              badgeDetails: earnedDetails,
            ),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Match beendet')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isDraw ? Icons.handshake : Icons.emoji_events,
                size: 80,
                color: isDraw
                    ? Colors.orange
                    : (isWinner ? Colors.amber : Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                isWinner
                    ? '🎉 Gewonnen!'
                    : (isDraw ? '🤝 Unentschieden' : '😔 Verloren'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildPlayerCard(
                      name: myName,
                      score: myScore,
                      isMe: true,
                      isWinner: myScore > oppScore,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildPlayerCard(
                      name: oppName,
                      score: oppScore,
                      isMe: false,
                      isWinner: oppScore > myScore,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Zurück zur Übersicht'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required int score,
    required bool isMe,
    required bool isWinner,
  }) {
    return Card(
      elevation: isWinner ? 8 : 2,
      color: isWinner ? Colors.amber.shade50 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isWinner
            ? const BorderSide(color: Colors.amber, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: isMe ? Colors.indigo : Colors.deepPurple,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 218, 148, 148),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isMe ? '$name (Du)' : name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isWinner ? Colors.amber : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$score Punkte',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isWinner ? Colors.black : Colors.grey.shade700,
                ),
              ),
            ),
            if (isWinner) ...[
              const SizedBox(height: 8),
              const Text('👑', style: TextStyle(fontSize: 24)),
            ],
          ],
        ),
      ),
    );
  }
}
