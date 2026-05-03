// tools/generate_update_sql.dart
//
// Liest tools/classification_audit.csv und generiert
// ein SQL-UPDATE-Skript zum Ausführen im Supabase SQL Editor.
//
// Usage: dart run tools/generate_update_sql.dart

import 'dart:io';

void main() async {
  final csvFile = File('tools/classification_audit.csv');
  if (!await csvFile.exists()) {
    print('❌ tools/classification_audit.csv nicht gefunden');
    exit(1);
  }

  final lines = await csvFile.readAsLines();
  if (lines.length < 2) {
    print('❌ CSV ist leer');
    exit(1);
  }

  final sqlFile = File('tools/apply_classifications.sql');
  final sink = sqlFile.openWrite();

  sink.writeln('-- Auto-generated from classification_audit.csv');
  sink.writeln('-- Run this in Supabase SQL Editor');
  sink.writeln('-- Total updates: ${lines.length - 1}');
  sink.writeln();
  sink.writeln('BEGIN;');
  sink.writeln();

  // Gruppiere Fragen nach tier-Wert für effizientere UPDATE-Statements
  final byTier = <String, List<String>>{
    'basics': [],
    'praxis': [],
    'pruefung': [],
  };

  for (var i = 1; i < lines.length; i++) {
    final cols = parseCsvLine(lines[i]);
    if (cols.length < 5) continue;
    final id = cols[0];
    final tier = cols[4];
    if (byTier.containsKey(tier)) {
      byTier[tier]!.add(id);
    }
  }

  for (final entry in byTier.entries) {
    if (entry.value.isEmpty) continue;
    final ids = entry.value.join(',');
    sink.writeln(
      "UPDATE fragen SET schwierigkeitsgrad = '${entry.key}' WHERE id IN ($ids);",
    );
    sink.writeln();
  }

  sink.writeln('COMMIT;');
  sink.writeln();
  sink.writeln('-- Verify:');
  sink.writeln(
    '-- SELECT schwierigkeitsgrad, COUNT(*) FROM fragen GROUP BY schwierigkeitsgrad;',
  );

  await sink.close();

  print('✅ SQL-Skript erstellt: tools/apply_classifications.sql');
  print('   basics:   ${byTier['basics']!.length} Fragen');
  print('   praxis:   ${byTier['praxis']!.length} Fragen');
  print('   pruefung: ${byTier['pruefung']!.length} Fragen');
  print('\n📋 Nächster Schritt:');
  print('   1. Öffne tools/apply_classifications.sql');
  print('   2. Kopiere den Inhalt in den Supabase SQL Editor');
  print('   3. Führe aus');
}

// CSV-Zeilen-Parser der mit Anführungszeichen umgeht
List<String> parseCsvLine(String line) {
  final result = <String>[];
  var current = StringBuffer();
  var inQuotes = false;

  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      inQuotes = !inQuotes;
    } else if (char == ',' && !inQuotes) {
      result.add(current.toString());
      current = StringBuffer();
    } else {
      current.write(char);
    }
  }
  result.add(current.toString());
  return result;
}
