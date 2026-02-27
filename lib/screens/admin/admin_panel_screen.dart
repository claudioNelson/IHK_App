import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final supabase = Supabase.instance.client;

  List<dynamic> module = [];
  int? selectedModuleId;
  List<dynamic> themen = [];
  List<dynamic> fragen = [];
  bool loading = false;

  // KI Generation State
  Map<int, bool> generatingAI = {}; // antwort_id -> loading
  Map<int, String> aiErrors = {}; // antwort_id -> error message

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => loading = true);
    try {
      final mods = await supabase.from('module').select('id, name').order('id');
      if (!mounted) return;
      setState(() => module = mods);
    } catch (e) {
      _snack('Fehler beim Laden der Module: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _loadThemen(int modulId) async {
    try {
      final res = await supabase
          .from('themen')
          .select(
            'id, name, beschreibung, sort_index, required_score, unlocked_by',
          )
          .eq('module_id', modulId)
          .order('sort_index, name');
      if (!mounted) return;
      setState(() => themen = res);
    } catch (e) {
      _snack('Fehler beim Laden der Themen: $e');
    }
  }

  Future<void> _loadFragenForModule(int modulId) async {
    setState(() {
      loading = true;
      selectedModuleId = modulId;
      fragen = [];
      themen = [];
    });
    try {
      await _loadThemen(modulId);
      final res = await supabase
          .from('fragen')
          .select(
            'id, frage, erklaerung, modul_id, thema_id, antworten(id, text, ist_richtig, erklaerung)',
          )
          .eq('modul_id', modulId)
          .order('id');
      if (!mounted) return;
      setState(() => fragen = res);
    } catch (e) {
      _snack('Fehler beim Laden der Fragen: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ============================================================================
  // KI ERKLÄRUNGS-GENERATOR
  // ============================================================================

  Future<void> _generateAIExplanation({
    required int antwortId,
    required String frage,
    required String antwort,
  }) async {
    setState(() {
      generatingAI[antwortId] = true;
      aiErrors.remove(antwortId);
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 1000,
          'messages': [
            {
              'role': 'user',
              'content':
                  '''Du bist ein IHK-Prüfungsexperte.

Erstelle eine präzise, lehrreiche Erklärung (1-2 Sätze) für diese Frage und Antwort:

Frage: $frage
Richtige Antwort: $antwort

Die Erklärung soll:
- Kurz und verständlich sein (max. 2 Sätze)
- Den Lerneffekt maximieren
- Erklären WARUM die Antwort richtig ist
- Fachlich korrekt sein
- Auf Deutsch sein

Antworte NUR mit der Erklärung, ohne Einleitung oder Markdown.''',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['content'] != null && data['content'].isNotEmpty) {
          final erklaerung = data['content'][0]['text'].toString().trim();

          // Speichere in Supabase
          await supabase
              .from('antworten')
              .update({'erklaerung': erklaerung})
              .eq('id', antwortId);

          if (!mounted) return;

          _snack('✅ Erklärung generiert und gespeichert!');

          // Reload Fragen
          if (selectedModuleId != null) {
            await _loadFragenForModule(selectedModuleId!);
          }
        } else {
          throw Exception('Keine Erklärung erhalten');
        }
      } else {
        throw Exception('API Fehler: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        aiErrors[antwortId] = e.toString();
      });
      _snack('❌ Fehler: $e');
    } finally {
      if (mounted) setState(() { generatingAI[antwortId] = false; });
    }
  }

  // Generiere Erklärungen für ALLE richtigen Antworten einer Frage
  Future<void> _generateAllExplanations(Map<String, dynamic> frage) async {
    final antworten = (frage['antworten'] ?? []) as List<dynamic>;
    final richtigeAntworten = antworten
        .where((a) => a['ist_richtig'] == true)
        .toList();

    if (richtigeAntworten.isEmpty) {
      _snack('⚠️ Keine richtige Antwort gefunden');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('KI-Erklärungen generieren?'),
        content: Text(
          'Soll Claude Erklärungen für ${richtigeAntworten.length} richtige Antwort(en) erstellen?\n\n'
          'Dies überschreibt vorhandene Erklärungen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generieren'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    for (final antwort in richtigeAntworten) {
      await _generateAIExplanation(
        antwortId: antwort['id'] as int,
        frage: frage['frage'] as String,
        antwort: antwort['text'] as String,
      );

      // Kurze Pause zwischen Requests
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
  // ============================================================================
  // DIALOGE FÜR FRAGEN/ANTWORTEN BEARBEITEN
  // ============================================================================

  Future<void> _editFrageDialog(Map<String, dynamic> frage) async {
    final frageCtrl = TextEditingController(text: frage['frage'] ?? '');
    final erkCtrl = TextEditingController(
      text: (frage['erklaerung'] ?? '').toString(),
    );
    int? selectedThemaId = frage['thema_id'] as int?;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSB) => AlertDialog(
          title: const Text('Frage bearbeiten'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: frageCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Frage',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: selectedThemaId,
                    decoration: const InputDecoration(
                      labelText: 'Thema',
                      border: OutlineInputBorder(),
                    ),
                    items: themen.map((t) {
                      return DropdownMenuItem<int>(
                        value: t['id'] as int,
                        child: Text(t['name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (v) => setSB(() => selectedThemaId = v),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: erkCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Erklärung (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await supabase.from('fragen').update({
                    'frage': frageCtrl.text.trim(),
                    'thema_id': selectedThemaId,
                    'erklaerung': erkCtrl.text.trim(),
                  }).eq('id', frage['id']);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  _snack('Frage aktualisiert');
                  if (selectedModuleId != null) {
                    _loadFragenForModule(selectedModuleId!);
                  }
                } catch (e) {
                  _snack('Fehler beim Speichern: $e');
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editAntwortDialog(
    Map<String, dynamic> antwort,
    String frageText,
  ) async {
    final textCtrl = TextEditingController(text: antwort['text'] ?? '');
    final erkCtrl = TextEditingController(
      text: (antwort['erklaerung'] ?? '').toString(),
    );
    bool istRichtig = antwort['ist_richtig'] == true;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSB) => AlertDialog(
          title: const Text('Antwort bearbeiten'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Antworttext',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Ist richtige Antwort'),
                    value: istRichtig,
                    onChanged: (v) => setSB(() => istRichtig = v ?? false),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: erkCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Erklärung (Antwort-spezifisch)',
                      border: OutlineInputBorder(),
                      helperText: 'Oder nutze KI-Generator unten ⬇️',
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 12),

                  // KI-Generator Button
                  if (istRichtig)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Mit KI generieren'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _generateAIExplanation(
                          antwortId: antwort['id'] as int,
                          frage: frageText,
                          antwort: textCtrl.text.trim(),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await supabase
                      .from('antworten')
                      .update({
                        'text': textCtrl.text.trim(),
                        'ist_richtig': istRichtig,
                        'erklaerung': erkCtrl.text.trim(),
                      })
                      .eq('id', antwort['id']);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  _snack('Antwort aktualisiert');
                  if (selectedModuleId != null) {
                    _loadFragenForModule(selectedModuleId!);
                  }
                } catch (e) {
                  _snack('Fehler beim Speichern: $e');
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // UI BUILD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin – KI-gestützte Verwaltung'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Colors.purple),
            tooltip: 'KI-Features',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('KI-Funktionen'),
                    ],
                  ),
                  content: const Text(
                    'Diese Version nutzt Claude AI um automatisch lehrreiche Erklärungen zu generieren.\n\n'
                    '• Klicke auf "🤖 KI" bei einer Frage um alle Erklärungen zu generieren\n'
                    '• Oder bearbeite einzelne Antworten und nutze "Mit KI generieren"\n\n'
                    'Die Erklärungen werden automatisch in der Datenbank gespeichert.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Verstanden'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : selectedModuleId == null
              ? _buildModuleSelection()
              : _buildFragenListe(),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildModuleSelection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings, size: 80, color: Colors.indigo),
            const SizedBox(height: 24),
            const Text(
              'Modul auswählen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ...module.map((m) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _loadFragenForModule(m['id']),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(300, 60),
                  ),
                  child: Text(
                    m['name'] ?? '',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFragenListe() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.indigo.shade50,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedModuleId = null;
                    fragen = [];
                  });
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  module.firstWhere((m) => m['id'] == selectedModuleId)['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${fragen.length} Fragen',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigo.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fragen.length,
            itemBuilder: (context, index) {
              final f = fragen[index];
              final antw = (f['antworten'] ?? []) as List<dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              f['frage'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // KI Button für alle Antworten
                          IconButton(
                            tooltip: 'Alle Erklärungen mit KI generieren',
                            icon: const Icon(Icons.auto_awesome),
                            color: Colors.purple,
                            onPressed: () => _generateAllExplanations(
                              f as Map<String, dynamic>,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _editFrageDialog(
                              f as Map<String, dynamic>,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Antworten
                      const Text(
                        'Antworten:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...antw.map((a) {
                        final bool ok = a['ist_richtig'] == true;
                        final int aId = a['id'] as int;
                        final bool isGenerating = generatingAI[aId] == true;
                        final String? error = aiErrors[aId];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: ok
                                ? Colors.green.shade50
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ok
                                  ? Colors.green.shade200
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(a['text'] ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if ((a['erklaerung'] ?? '')
                                        .toString()
                                        .trim()
                                        .isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          '💡 ${a['erklaerung']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    if (isGenerating)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Generiere Erklärung...',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (error != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          '❌ $error',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // KI Button für einzelne Antwort
                                    if (ok && !isGenerating)
                                      IconButton(
                                        tooltip: 'KI-Erklärung generieren',
                                        icon: const Icon(
                                          Icons.auto_awesome,
                                          size: 20,
                                        ),
                                        color: Colors.purple,
                                        onPressed: () => _generateAIExplanation(
                                          antwortId: aId,
                                          frage: f['frage'] as String,
                                          antwort: a['text'] as String,
                                        ),
                                      ),
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 20),
                                      onPressed: () => _editAntwortDialog(
                                        a as Map<String, dynamic>,
                                        f['frage'] as String,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}