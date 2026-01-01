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
  bool _busy = false;
  List<Map<String, dynamic>> _myMatches = [];

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'local';

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    setState(() => _busy = true);
    try {
      final matches = await _svc.getMyMatches();
      if (!mounted) return;
      setState(() => _myMatches = matches);
    } catch (e) {
      print('❌ Fehler beim Laden der Matches: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createMatch() async {
    setState(() => _busy = true);
    try {
      final id = await _svc.createMatch(count: 10);
      print('✅ Match erstellt: $id');
      await _loadMatches();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Match erstellt: ${id.substring(0, 8)}...')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Erstellen: $e')),
      );
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
      print('✅ Match beigetreten: $id');
      await _loadMatches();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Beigetreten: ${id.substring(0, 8)}...')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Beitreten: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _playMatch(String matchId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AsyncMatchPlayPage(matchId: matchId),
      ),
    ).then((_) => _loadMatches()); // Refresh nach Rückkehr
  }

  String _getStatusText(Map<String, dynamic> match) {
    final status = match['status'] as String;
    final isPlayer1 = match['player1_id'] == _userId;
    final hasPlayer2 = match['player2_id'] != null;

    switch (status) {
      case 'open':
        return '⏳ Wartet auf Gegner';
      case 'active':
        return '🎮 Aktiv - Spielen!';
      case 'waiting':
        return '⏳ Wartet auf Gegner-Antworten';
      case 'completed':
        return '✅ Abgeschlossen';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.orange;
      case 'active':
        return Colors.green;
      case 'waiting':
        return Colors.blue;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncMatch (Beta)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _busy ? null : _loadMatches,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_busy) const LinearProgressIndicator(),
          
          // Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Match erstellen'),
                    onPressed: _busy ? null : _createMatch,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Zufällig beitreten'),
                    onPressed: _busy ? null : _joinRandom,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Matches Liste
          Expanded(
            child: _myMatches.isEmpty
                ? const Center(
                    child: Text(
                      'Keine Matches vorhanden.\nErstelle ein Match oder tritt einem bei!',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _myMatches.length,
                    itemBuilder: (ctx, i) {
                      final match = _myMatches[i];
                      final matchId = match['id'] as String;
                      final status = match['status'] as String;
                      final canPlay = status == 'active' || status == 'open';

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(status),
                            child: Text(
                              '${match['total_questions']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text('Match ${matchId.substring(0, 8)}...'),
                          subtitle: Text(_getStatusText(match)),
                          trailing: canPlay
                              ? ElevatedButton(
                                  onPressed: () => _playMatch(matchId),
                                  child: const Text('Spielen'),
                                )
                              : status == 'completed'
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : const Icon(Icons.hourglass_empty),
                          onTap: () => _playMatch(matchId),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}