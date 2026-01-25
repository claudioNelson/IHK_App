import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/async_duel_service.dart';
import '../../../async_match_progress.dart';
import '../../../widgets/fill_in_blank_widget.dart';
import '../../../widgets/sequence_question_widget.dart';
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
      if (!mounted) return;
      setState(() => _loading = false);
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
        actions: [
          // Timer
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _timeLeft <= 5
                  ? Colors.red
                  : _timeLeft <= 10
                  ? Colors.orange
                  : Colors.green,
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
          // Report Button
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
                child: questionType == 'fill_blank'
                    ? _buildFillBlankQuestion()
                    : questionType == 'sequence'
                    ? _buildSequenceQuestion()
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

  Widget _buildMultipleChoiceQuestion() {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    final antworten = (frageData['antworten'] as List<dynamic>? ?? []).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(frageText, style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 16),
        ...antworten.map((a) {
          final aid = a['id'] as int;
          final text = a['text'] as String;
          final correct = a['ist_richtig'] == true;
          final selected = _selectedAnswerId == aid;

          Color? color;
          if (_answered && selected) {
            color = _wasCorrect ? Colors.green : Colors.red;
          } else if (selected) {
            color = Colors.blue.shade100;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              color: color,
              child: ListTile(
                title: Text(text),
                onTap: _answered || _submitting
                    ? null
                    : () => _submitMultipleChoice(aid, correct),
                trailing: _answered && selected
                    ? Icon(
                        _wasCorrect ? Icons.check : Icons.close,
                        color: _wasCorrect ? Colors.green : Colors.red,
                      )
                    : null,
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
