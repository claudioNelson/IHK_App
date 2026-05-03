// tools/classify_questions.dart
//
// Standalone-Skript zur AI-basierten Klassifizierung aller Fragen
// in 3 Tiers: basics / praxis / pruefung.
//
// Usage:
//   dart run tools/classify_questions.dart
//
// Voraussetzungen in .env:
//   - SUPABASE_URL
//   - SUPABASE_SERVICE_ROLE_KEY
//   - GROQ_API_KEY
//
// Output:
//   - Updates fragen.schwierigkeitsgrad in der DB
//   - tools/classification_audit.csv mit allen Klassifikationen

import 'dart:convert';
import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

// ─── Config ─────────────────────────────────────
const groqEndpoint = 'https://api.groq.com/openai/v1/chat/completions';
const groqModel = 'llama-3.3-70b-versatile';
const batchSize = 8; // Fragen pro AI-Call
const delayMs = 3500; // Pause zwischen Batches (Rate-Limiting)
const maxRetries =
    3; // Retries bei Rate-Limit-ErrorsPause zwischen Batches (Rate-Limiting)Pause zwischen Batches (Rate-Limiting)

// ─── Tier-Definitionen für AI-Prompt ─────────────
const tierGuide = '''
Du klassifizierst IHK-Prüfungsfragen für IT-Berufe in 3 Stufen:

**basics** (Tier 1 — Grundlagen):
- Definitions-Fragen ("Was ist X?")
- Einfache Begriffsdefinitionen
- Erkennen von Konzepten
- Beispiel: "Was ist ein Primärschlüssel?", "Was bedeutet RAM?"

**praxis** (Tier 2 — Anwendung):
- Vergleiche zwischen Konzepten ("Unterschied zwischen X und Y")
- Anwendungs-Szenarien
- Konkrete Beispiele anwenden
- Beispiel: "Welche SQL-Anweisung filtert Datensätze?", "Wann nutzt man INNER JOIN?"

**pruefung** (Tier 3 — Prüfungs-Niveau):
- Mehrstufige Probleme
- Berechnungen
- Komplexe Szenarien mit mehreren Konzepten
- Erklärungen mit Begründung
- Beispiel: "Erkläre Normalisierung mit ersten 3 Normalformen", "Berechne die Subnetzmaske für..."
''';

void main() async {
  print('🚀 Klassifizierungs-Skript gestartet\n');

  // ─── Env laden ───────────────────────────────
  final env = DotEnv()..load(['.env']);
  final supabaseUrl = env['SUPABASE_URL'];
  final supabaseKey = env['SUPABASE_ANON_KEY'];
  final groqKey = env['GROQ_API_KEY'];

  if (supabaseUrl == null || supabaseKey == null || groqKey == null) {
    print(
      '❌ Fehler: SUPABASE_URL, SUPABASE_ANON_KEY oder GROQ_API_KEY fehlt in .env',
    );
    exit(1);
  }

  // ─── Fragen aus DB laden ─────────────────────
  print('📥 Lade alle Fragen aus DB...');
  final fragen = await fetchFragen(supabaseUrl, supabaseKey);
  print('   ${fragen.length} Fragen geladen\n');

  // ─── CSV-Datei vorbereiten ───────────────────
  final csvFile = File('tools/classification_audit.csv');
  final csvSink = csvFile.openWrite();
  csvSink.writeln('id,modul_id,frage_kurz,alt,neu,confidence');

  // ─── Batchweise klassifizieren ───────────────
  print('🤖 Klassifiziere in Batches à $batchSize Fragen...\n');

  int success = 0;
  int failed = 0;
  final stats = <String, int>{'basics': 0, 'praxis': 0, 'pruefung': 0};

  for (var i = 0; i < fragen.length; i += batchSize) {
    final end = (i + batchSize < fragen.length) ? i + batchSize : fragen.length;
    final batch = fragen.sublist(i, end);

    print(
      '  Batch ${(i ~/ batchSize) + 1}/${(fragen.length / batchSize).ceil()} (Fragen ${i + 1}-$end)...',
    );

    try {
      final classifications = await classifyBatch(batch, groqKey);

      for (final result in classifications) {
        final id = result['id'] as int;
        final tier = result['tier'] as String;
        final originalFrage = batch.firstWhere((f) => f['id'] == id);
        final alt = originalFrage['schwierigkeitsgrad'] as String? ?? '';
        final frageKurz = (originalFrage['frage'] as String).replaceAll(
          '"',
          '""',
        );
        final frageKurzCut = frageKurz.length > 80
            ? '${frageKurz.substring(0, 80)}...'
            : frageKurz;

        // CSV-Zeile (kein DB-Update — wir generieren später SQL aus CSV)
        csvSink.writeln(
          '$id,${originalFrage['modul_id']},"$frageKurzCut",$alt,$tier,1.0',
        );

        stats[tier] = (stats[tier] ?? 0) + 1;
        success++;
      }
    } catch (e) {
      print('     ❌ Fehler: $e');
      failed += batch.length;
    }

    // Rate-Limiting Pause
    if (i + batchSize < fragen.length) {
      await Future.delayed(Duration(milliseconds: delayMs));
    }
  }

  await csvSink.close();

  // ─── Zusammenfassung ─────────────────────────
  print('\n✅ Fertig!');
  print('   Erfolgreich: $success');
  print('   Fehlgeschlagen: $failed');
  print('\n📊 Verteilung:');
  print(
    '   basics:   ${stats['basics']} (${((stats['basics']! / success) * 100).toStringAsFixed(1)}%)',
  );
  print(
    '   praxis:   ${stats['praxis']} (${((stats['praxis']! / success) * 100).toStringAsFixed(1)}%)',
  );
  print(
    '   pruefung: ${stats['pruefung']} (${((stats['pruefung']! / success) * 100).toStringAsFixed(1)}%)',
  );
  print('\n📄 Audit-Report: tools/classification_audit.csv');
}

// ─── Helpers ────────────────────────────────────

Future<List<Map<String, dynamic>>> fetchFragen(String url, String key) async {
  // Wir nutzen den anon/publishable key — Read ist via Policy "Anyone can view fragen" erlaubt
  final response = await http.get(
    Uri.parse(
      '$url/rest/v1/fragen?select=id,modul_id,frage,schwierigkeitsgrad&order=id',
    ),
    headers: {'apikey': key, 'Authorization': 'Bearer $key'},
  );

  if (response.statusCode != 200) {
    throw Exception(
      'DB-Fetch fehlgeschlagen: ${response.statusCode} - ${response.body}',
    );
  }

  return List<Map<String, dynamic>>.from(json.decode(response.body));
}

Future<List<Map<String, dynamic>>> classifyBatch(
  List<Map<String, dynamic>> batch,
  String groqKey,
) async {
  // Prompt bauen
  final fragenList = batch
      .asMap()
      .entries
      .map((e) {
        return '${e.key + 1}. (id=${e.value['id']}) ${e.value['frage']}';
      })
      .join('\n');

  final prompt =
      '''$tierGuide

Klassifiziere folgende ${batch.length} Fragen:

$fragenList

**Antworte AUSSCHLIESSLICH als valides JSON-Array** in dieser Form:
[{"id": 123, "tier": "basics"}, {"id": 124, "tier": "praxis"}, ...]

Keine Erklärungen, kein Markdown, nur das JSON.''';

  // Retry-Loop bei Rate-Limit
  for (var attempt = 1; attempt <= maxRetries; attempt++) {
    final response = await http.post(
      Uri.parse(groqEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $groqKey',
      },
      body: json.encode({
        'model': groqModel,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 2000,
        'temperature': 0.1,
        'response_format': {'type': 'json_object'},
      }),
    );

    // Rate-Limit → warten und nochmal versuchen
    if (response.statusCode == 429) {
      // Retry-After aus Body extrahieren ("try again in 1.234s")
      final retryMatch = RegExp(
        r'try again in ([\d.]+)s',
      ).firstMatch(response.body);
      final waitSec = retryMatch != null
          ? double.tryParse(retryMatch.group(1)!) ?? 5.0
          : 5.0;
      final waitMs = ((waitSec + 1) * 1000).toInt(); // +1s Puffer

      print(
        '     ⏳ Rate-Limit (Versuch $attempt/$maxRetries) — warte ${(waitMs / 1000).toStringAsFixed(1)}s...',
      );
      await Future.delayed(Duration(milliseconds: waitMs));
      continue;
    }

    if (response.statusCode != 200) {
      throw Exception('Groq-Fehler: ${response.statusCode} - ${response.body}');
    }

    // Erfolg
    final data = json.decode(response.body);
    final content = data['choices'][0]['message']['content'] as String;

    final parsed = json.decode(content);
    if (parsed is List) {
      return List<Map<String, dynamic>>.from(parsed);
    }
    if (parsed is Map) {
      for (final value in parsed.values) {
        if (value is List) {
          return List<Map<String, dynamic>>.from(value);
        }
      }
    }
    throw Exception('Unerwartetes JSON-Format: $content');
  }

  throw Exception('Max retries erreicht für Batch');
}

Future<void> updateFrageTier(
  String url,
  String key,
  int id,
  String tier,
) async {
  final response = await http.patch(
    Uri.parse('$url/rest/v1/fragen?id=eq.$id'),
    headers: {
      'apikey': key,
      'Authorization': 'Bearer $key',
      'Content-Type': 'application/json',
      'Prefer': 'return=minimal',
    },
    body: json.encode({'schwierigkeitsgrad': tier}),
  );

  if (response.statusCode != 204 && response.statusCode != 200) {
    throw Exception(
      'Update fehlgeschlagen für Frage $id: ${response.statusCode} - ${response.body}',
    );
  }
}
