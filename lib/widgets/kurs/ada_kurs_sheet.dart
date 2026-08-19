// lib/widgets/kurs/ada_kurs_sheet.dart
//
// Ada im Kurs: ein Bottom Sheet mit Chat, das die aktuelle Lektion und
// (falls gerade eine Aufgabe offen ist) die Aufgabenstellung als Kontext
// mitgibt. Läuft über GeminiService -> Edge Function ai-tutor, damit das
// serverseitige Tageslimit (5 Fragen für Free-Nutzer) automatisch gilt.
//
// Ada verrät keine Lösungen: der Kontext-Prompt weist sie an, zum
// Selbstdenken anzuleiten statt die fertige Abfrage zu liefern.

import 'package:flutter/material.dart';

import '../../services/gemini_service.dart';

/// Öffnet das Ada-Sheet. [lektionsTitel] ist Pflicht, [aufgabenText] nur
/// gesetzt, wenn der Nutzer gerade auf einer Aufgabenseite steht.
Future<void> zeigeAdaKursSheet(
  BuildContext context, {
  required String kursTitel,
  required String lektionsTitel,
  String? aufgabenText,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => Padding(
      // Tastatur nicht das Eingabefeld verdecken lassen
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _AdaKursSheet(
        kursTitel: kursTitel,
        lektionsTitel: lektionsTitel,
        aufgabenText: aufgabenText,
      ),
    ),
  );
}

class _AdaKursSheet extends StatefulWidget {
  final String kursTitel;
  final String lektionsTitel;
  final String? aufgabenText;

  const _AdaKursSheet({
    required this.kursTitel,
    required this.lektionsTitel,
    this.aufgabenText,
  });

  @override
  State<_AdaKursSheet> createState() => _AdaKursSheetState();
}

class _Nachricht {
  final String text;
  final bool vonAda;
  const _Nachricht(this.text, {required this.vonAda});
}

class _AdaKursSheetState extends State<_AdaKursSheet> {
  final _eingabe = TextEditingController();
  final _scroll = ScrollController();
  final List<_Nachricht> _verlauf = [];
  final List<Map<String, String>> _historie = [];
  bool _laedt = false;

  /// Kontext, den Ada zu jeder Frage bekommt. Wichtig: sie soll helfen,
  /// nicht vorsagen. Sonst ist der Kurs ein Lösungsautomat.
  String get _kontext {
    final aufgabe = widget.aufgabenText != null
        ? '\nDer Azubi arbeitet gerade an dieser Aufgabe:\n'
            '${widget.aufgabenText}\n'
            'WICHTIG: Nenne NIEMALS die fertige Lösung oder die komplette '
            'Abfrage. Leite zum Selbstdenken an, erkläre Konzepte, gib '
            'höchstens den nächsten Denkschritt.'
        : '';

    return 'Kurs: ${widget.kursTitel}, '
        'Lektion: ${widget.lektionsTitel}.$aufgabe';
  }

  @override
  void dispose() {
    _eingabe.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _senden() async {
    final frage = _eingabe.text.trim();
    if (frage.isEmpty || _laedt) return;

    setState(() {
      _verlauf.add(_Nachricht(frage, vonAda: false));
      _laedt = true;
      _eingabe.clear();
    });
    _nachUntenScrollen();

    String antwort;
    try {
      antwort = await GeminiService().chatWithTutor(
        userMessage: frage,
        conversationHistory: _historie,
        currentQuestion: _kontext,
        topic: widget.kursTitel,
      );
      _historie
        ..add({'role': 'user', 'content': frage})
        ..add({'role': 'assistant', 'content': antwort});
    } on LimitReachedException catch (e) {
      antwort =
          'Du hast deine ${e.limit} kostenlosen Ada-Fragen für heute '
          'aufgebraucht. Morgen geht es weiter, oder du schaust dir den '
          'Tipp bei der Aufgabe an. Mit Premium fragst du ohne Limit.';
    } catch (_) {
      antwort =
          'Ada ist gerade nicht erreichbar. Prüf deine Internetverbindung '
          'und versuch es gleich nochmal.';
    }

    if (!mounted) return;
    setState(() {
      _verlauf.add(_Nachricht(antwort, vonAda: true));
      _laedt = false;
    });
    _nachUntenScrollen();
  }

  void _nachUntenScrollen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: Column(
        children: [
          // Kopf
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: farben.primary.withValues(alpha: 0.18),
                  child:
                      Icon(Icons.school, size: 19, color: farben.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ada fragen',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(
                        widget.aufgabenText != null
                            ? 'Sie kennt deine aktuelle Aufgabe'
                            : widget.lektionsTitel,
                        style: TextStyle(
                            fontSize: 12, color: farben.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Verlauf
          Expanded(
            child: _verlauf.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Text(
                        widget.aufgabenText != null
                            ? 'Frag mich etwas zur Aufgabe. Ich helfe beim '
                                'Verstehen, verrate aber nicht die Lösung.'
                            : 'Frag mich etwas zu dieser Lektion.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: farben.onSurfaceVariant),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(16),
                    itemCount: _verlauf.length + (_laedt ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i >= _verlauf.length) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(
                              child: SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(strokeWidth: 2.5),
                          )),
                        );
                      }
                      final n = _verlauf[i];
                      return Align(
                        alignment: n.vonAda
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.8),
                          decoration: BoxDecoration(
                            color: n.vonAda
                                ? farben.surfaceContainerHighest
                                : farben.primary.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: SelectableText(n.text,
                              style: const TextStyle(height: 1.45)),
                        ),
                      );
                    },
                  ),
          ),

          // Eingabe
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _eingabe,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _senden(),
                      decoration: InputDecoration(
                        hintText: 'Deine Frage an Ada',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _laedt ? null : _senden,
                    icon: const Icon(Icons.arrow_upward),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
