import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/async_duel_service.dart';
import '../../../async_match_progress.dart';

class AsyncMatchPlayPage extends StatefulWidget {
  final String matchId;
  const AsyncMatchPlayPage({super.key, required this.matchId});

  @override
  State<AsyncMatchPlayPage> createState() => _AsyncMatchPlayPageState();
}

class _AsyncMatchPlayPageState extends State<AsyncMatchPlayPage> {
  final _svc = AsyncDuelService();

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

  bool _matchCompleted = false;
  Map<String, dynamic>? _finalScores;

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'local';

  @override
  void initState() {
    super.initState();
    _init();
  }

Future<void> _init() async {
  try {
    print('🟢 _init() gestartet für Match: ${widget.matchId}');

    _store ??= await AsyncMatchProgressStore.instance;
    _progress = await _store!.ensure(_userId, widget.matchId);

    print('🟡 Lade Match-Daten...');
    final data = await _svc.loadMatch(widget.matchId);
    print('🟢 Match-Daten geladen: $data');

    final q = (data['questions'] as List<dynamic>).toList()
      ..sort((a, b) => (a['idx'] as int).compareTo(b['idx'] as int));

    print('🟢 Anzahl Fragen: ${q.length}');
    _questions = q;

    // Prüfe ob bereits alle Fragen beantwortet wurden (aus DB)
    final myAnswers = data['myAnswers'] as List<dynamic>;
    print('🟢 Bereits beantwortete Fragen: ${myAnswers.length}');

    if (myAnswers.length >= _questions.length) {
      // Alle Fragen bereits beantwortet -> direkt finalisieren
      print('✅ Alle Fragen bereits beantwortet, finalisiere...');
      await _tryFinalize();
      return;
    }

    // Setze Index auf erste unbeantwortete Frage
    final answeredIdxs = myAnswers.map((a) => a['idx'] as int).toSet();
    _idx = 0;
    for (int i = 0; i < _questions.length; i++) {
      final qIdx = _questions[i]['idx'] as int;
      if (!answeredIdxs.contains(qIdx)) {
        _idx = i;
        break;
      }
    }

    // Sync lokalen Progress
    _progress!.currentIdx = _idx;
    await _store!.save(_progress!);

    print('🟢 Starte bei Frage $_idx');

  } catch (e, stackTrace) {
    print('🔴 FEHLER in _init:');
    print('🔴 Error: $e');
    print('🔴 StackTrace: $stackTrace');

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fehler beim Laden: $e')),
    );
  } finally {
    if (!mounted) return;
    setState(() => _loading = false);
  }
}
  Future<void> _submit(int answerId, bool correct) async {
    if (_submitting || _answered) return;

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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
      setState(() {
        _submitting = false;
        _selectedAnswerId = null;
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
    });

    _progress!.currentIdx = _idx;
    await _store!.save(_progress!);
  }

Future<void> _tryFinalize() async {
  try {
    final status = await _svc.tryFinalize(widget.matchId);
    print('🏁 Finalize-Status: $status');

    // "completed" ODER "finalized" = Match ist fertig
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Match-Status: $status')),
        );
      }
    }
  } catch (e) {
    print('🔴 Fehler beim Finalisieren: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Abschluss: $e')),
      );
    }
  }
}

@override
Widget build(BuildContext context) {
  if (_loading) {
    return Scaffold(
      appBar: AppBar(title: const Text('AsyncMatch')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  // NEU: Waiting Screen
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

  final q = _questions[_idx];
  final frageData = q['fragen'];
  final frageText = frageData['frage'] as String;
  final antworten = (frageData['antworten'] as List<dynamic>).toList();

  return Scaffold(
    appBar: AppBar(
      title: Text('Frage ${_idx + 1} / ${_questions.length}'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_submitting) const LinearProgressIndicator(),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                frageText,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: antworten.length,
              itemBuilder: (ctx, i) {
                final a = antworten[i];
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

                return Card(
                  color: color,
                  child: ListTile(
                    title: Text(text),
                    onTap: _answered || _submitting
                        ? null
                        : () => _submit(aid, correct),
                    trailing: _answered && selected
                        ? Icon(
                            _wasCorrect ? Icons.check : Icons.close,
                            color: _wasCorrect ? Colors.green : Colors.red,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          if (_answered)
            ElevatedButton(
              onPressed: _next,
              child: Text(
                _idx + 1 >= _questions.length ? 'Beenden' : 'Weiter',
              ),
            ),
        ],
      ),
    ),
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
    final myId = _finalScores?['user_id'];
    final oppId = _finalScores?['opponent_id'];

    return Scaffold(
      appBar: AppBar(title: const Text('Match beendet')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 24),
              const Text(
                'Match abgeschlossen!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Du: $myScore Punkte',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 8),
                      Text('Gegner: $oppScore Punkte',
                          style: const TextStyle(fontSize: 20)),
                      const Divider(height: 32),
                      Text(
                        myScore > oppScore
                            ? '🎉 Gewonnen!'
                            : myScore < oppScore
                                ? '😔 Verloren'
                                : '🤝 Unentschieden',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Zurück'),
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
}