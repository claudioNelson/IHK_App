import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/async_duel_service.dart';
import '../../../async_match_progress.dart';
import 'async_match_play_screen.dart';

class AsyncMatchDemoPage extends StatefulWidget {
  const AsyncMatchDemoPage({super.key});

  @override
  State<AsyncMatchDemoPage> createState() => _AsyncMatchDemoPageState();
}

class _AsyncMatchDemoPageState extends State<AsyncMatchDemoPage> {
  final _svc = AsyncDuelService();
  AsyncMatchProgressStore? _store;
  AsyncMatchProgress? _progress;
  String? _matchId;
  bool _busy = false;

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'local';

  Future<void> _attachProgress(String matchId) async {
    _store ??= await AsyncMatchProgressStore.instance;
    _progress = await _store!.ensure(_userId, matchId);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _createMatch() async {
    setState(() => _busy = true);
    try {
      final id = await _svc.createMatch(count: 10);
      _matchId = id;
      await _attachProgress(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Erstellen: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _joinRandom() async {
    setState(() => _busy = true);
    try {
      final id = await _svc.joinRandomMatch();
      if (id == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kein offenes Match gefunden')),
        );
        return;
      }
      _matchId = id;
      await _attachProgress(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Beitreten: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMatch = _matchId != null && _progress != null;
    final info = hasMatch
        ? 'Match: $_matchId • Aktuelle Frage: ${_progress!.currentIdx + 1}'
        : 'Kein aktives Match';

    return Scaffold(
      appBar: AppBar(title: const Text('AsyncMatch (Beta)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_busy) const LinearProgressIndicator(),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(info),
              subtitle: const Text('Fortschritt wird lokal gespeichert.'),
              trailing: hasMatch
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AsyncMatchPlayPage(matchId: _matchId!),
                          ),
                        );
                      },
                      child: const Text('Weiter spielen'),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Match erstellen'),
                onPressed: _busy ? null : _createMatch,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.shuffle),
                label: const Text('Zufällig beitreten'),
                onPressed: _busy ? null : _joinRandom,
              ),
            ],
          ),
        ],
      ),
    );
  }
}