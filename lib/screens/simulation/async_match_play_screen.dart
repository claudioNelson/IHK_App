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
      _idx = (_progress!.currentIdx).clamp(0, 1 << 30);

      print('🟡 Lade Match-Daten...');
      final data = await _svc.loadMatch(widget.matchId);
      print('🟢 Match-Daten geladen: $data');

      final q = (data['questions'] as List<dynamic>).toList()
        ..sort((a, b) => (a['idx'] as int).compareTo(b['idx'] as int));

      print('🟢 Anzahl Fragen: ${q.length}');
      _questions = q;

      if (_idx >= _questions.length) {
        print('⚠️ Alle Fragen beantwortet, finalisiere...');
        await _tryFinalize();
      }
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

      if (status == 'completed') {
        final scores = await _svc.loadScores(widget.matchId);
        setState(() {
          _matchCompleted = true;
          _finalScores = scores;
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