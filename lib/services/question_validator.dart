// lib/services/question_validator.dart
import 'package:flutter/foundation.dart';
import 'telegram_service.dart';

/// Validiert Fragen-Daten und meldet Probleme automatisch an Admin via Telegram.
///
/// Läuft beim Laden von Fragen und prüft auf häufige Fehler:
/// - Leere Fragen (keine Antworten)
/// - Keine richtige Antwort markiert
/// - Alle Antworten richtig markiert
/// - Fehlende calculation_data bei Spezial-Fragen
/// - Type-spezifische Felder fehlen
class QuestionValidator {
  static final QuestionValidator _instance = QuestionValidator._internal();
  factory QuestionValidator() => _instance;
  QuestionValidator._internal();

  final _telegram = TelegramService();
  final Set<String> _reportedIssues = {};

  Future<void> validateQuestions({
    required List<dynamic> questions,
    required String contextName,
    String contextType = 'modul',
  }) async {
    for (final q in questions) {
      await _validateSingle(q, contextName, contextType);
    }
  }

  Future<void> validateQuestion({
    required Map<String, dynamic> question,
    required String contextName,
    String contextType = 'modul',
  }) async {
    await _validateSingle(question, contextName, contextType);
  }

  Future<void> _validateSingle(
    dynamic q,
    String contextName,
    String contextType,
  ) async {
    final frageId = q['id'] as int?;
    if (frageId == null) return;

    final frageText = q['frage'] as String? ?? '';
    final questionType = q['question_type'] as String? ?? 'multiple_choice';
    final antworten = (q['antworten'] as List?) ?? [];
    final calculationData = q['calculation_data'] as Map<String, dynamic>?;

    // ─── 1. LEERE FRAGE (Multiple Choice ohne Antworten) ─────────
    if (questionType == 'multiple_choice' && antworten.isEmpty) {
      await _report(
        issueKey: 'empty_$frageId',
        title: '🚨 Leere Frage',
        problem: 'Multiple-Choice ohne Antworten',
        frageId: frageId,
        frageText: frageText,
        contextName: contextName,
        contextType: contextType,
        questionType: questionType,
      );
      return;
    }

    // ─── 2. KEINE RICHTIGE ANTWORT ───────────────────────────────
    if (questionType == 'multiple_choice' && antworten.isNotEmpty) {
      final hasCorrect = antworten.any((a) => a['ist_richtig'] == true);
      if (!hasCorrect) {
        await _report(
          issueKey: 'no_correct_$frageId',
          title: '⚠️ Keine richtige Antwort',
          problem: 'Multiple-Choice ohne Lösung',
          frageId: frageId,
          frageText: frageText,
          contextName: contextName,
          contextType: contextType,
          questionType: questionType,
        );
      }

      // ─── 3. ALLE ANTWORTEN RICHTIG ─────────────────────────────
      final allCorrect = antworten.every((a) => a['ist_richtig'] == true);
      if (allCorrect && antworten.length > 1) {
        await _report(
          issueKey: 'all_correct_$frageId',
          title: '⚠️ Alle Antworten richtig',
          problem:
              'Multiple-Choice mit ${antworten.length} richtigen Antworten',
          frageId: frageId,
          frageText: frageText,
          contextName: contextName,
          contextType: contextType,
          questionType: questionType,
        );
      }
    }

    // ─── 4. CALCULATION DATA FEHLT (genereller Check) ────────────
    final needsCalcData = [
      'binary_calculation',
      'network_calculation',
      'raid_calculation',
      'dns_port_match',
      'freitext_ada',
      'er_to_tables',
      'fill_blank',
      'sequence',
    ].contains(questionType);

    if (needsCalcData && (calculationData == null || calculationData.isEmpty)) {
      await _report(
        issueKey: 'no_calcdata_$frageId',
        title: '⚠️ Calculation Data fehlt',
        problem: '$questionType ohne calculation_data',
        frageId: frageId,
        frageText: frageText,
        contextName: contextName,
        contextType: contextType,
        questionType: questionType,
      );
      return; // Ohne calc-data sind weitere Type-Checks sinnlos
    }

    // Hier vorbei wenn keine calc-data benötigt
    if (calculationData == null) return;

    // ─── 5. TYPE-SPEZIFISCHE CHECKS ──────────────────────────────
    final missingFields = <String>[];

    switch (questionType) {
      case 'binary_calculation':
      case 'dns_port_match':
        if (calculationData['options'] is! List ||
            (calculationData['options'] as List).isEmpty) {
          missingFields.add('options');
        }
        if (calculationData['correct_answer'] == null ||
            (calculationData['correct_answer'] as String?)?.isEmpty == true) {
          missingFields.add('correct_answer');
        }
        break;

      case 'raid_calculation':
        for (final field in [
          'usable_capacity',
          'fault_tolerance',
          'min_drives',
        ]) {
          if (calculationData[field] == null) {
            missingFields.add(field);
          }
        }
        break;

      case 'network_calculation':
        for (final field in [
          'network_address',
          'broadcast_address',
          'subnet_mask',
          'usable_hosts',
        ]) {
          if (calculationData[field] == null) {
            missingFields.add(field);
          }
        }
        break;

      case 'freitext_ada':
        if (calculationData['bewertungskriterien'] is! List ||
            (calculationData['bewertungskriterien'] as List).isEmpty) {
          missingFields.add('bewertungskriterien');
        }
        break;

      case 'er_to_tables':
        if (calculationData['tables'] is! Map ||
            (calculationData['tables'] as Map).isEmpty) {
          missingFields.add('tables');
        }
        break;

      case 'sequence':
        if (calculationData['items'] is! List ||
            (calculationData['items'] as List).isEmpty) {
          missingFields.add('items');
        }
        if (calculationData['correctOrder'] is! List ||
            (calculationData['correctOrder'] as List).isEmpty) {
          missingFields.add('correctOrder');
        }
        break;

      case 'fill_blank':
        if (calculationData['blanks'] is! List ||
            (calculationData['blanks'] as List).isEmpty) {
          missingFields.add('blanks');
        }
        break;
    }

    if (missingFields.isNotEmpty) {
      await _report(
        issueKey: '${questionType}_invalid_$frageId',
        title: '⚠️ ${_typeLabel(questionType)} unvollständig',
        problem: 'Fehlende Felder: ${missingFields.join(', ')}',
        frageId: frageId,
        frageText: frageText,
        contextName: contextName,
        contextType: contextType,
        questionType: questionType,
      );
    }

    // ─── 6. ERKLÄRUNG FEHLT (nur Multiple Choice mit Antworten) ─
    final erklaerung = q['erklaerung'] as String?;
    if (questionType == 'multiple_choice' &&
        antworten.isNotEmpty &&
        (erklaerung == null || erklaerung.trim().isEmpty)) {
      final hasAnyExplanation = antworten.any((a) {
        final exp = a['erklaerung'] as String?;
        return exp != null && exp.trim().isNotEmpty;
      });
      if (!hasAnyExplanation) {
        await _report(
          issueKey: 'no_explanation_$frageId',
          title: 'ℹ️ Keine Erklärung',
          problem: 'Frage und Antworten ohne Erklärung',
          frageId: frageId,
          frageText: frageText,
          contextName: contextName,
          contextType: contextType,
          questionType: questionType,
        );
      }
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'binary_calculation':
        return 'Binary-Frage';
      case 'dns_port_match':
        return 'DNS/Port-Frage';
      case 'raid_calculation':
        return 'RAID-Berechnung';
      case 'network_calculation':
        return 'Netzwerk-Berechnung';
      case 'freitext_ada':
        return 'Freitext-Frage';
      case 'er_to_tables':
        return 'ER-Diagramm-Frage';
      case 'sequence':
        return 'Reihenfolge-Frage';
      case 'fill_blank':
        return 'Lückentext-Frage';
      default:
        return 'Frage';
    }
  }

  Future<void> _report({
    required String issueKey,
    required String title,
    required String problem,
    required int frageId,
    required String frageText,
    required String contextName,
    required String contextType,
    required String questionType,
  }) async {
    if (_reportedIssues.contains(issueKey)) return;
    _reportedIssues.add(issueKey);

    debugPrint('🔴 Validierungs-Fehler: $title (Frage $frageId)');

    final escaped = _escapeHtml(frageText);
    final preview = escaped.length > 200
        ? '${escaped.substring(0, 200)}...'
        : escaped;

    final message =
        '''
$title

⚠️ <b>Problem:</b> $problem

📝 <b>Frage ID:</b> <code>$frageId</code>
📚 <b>${_capitalize(contextType)}:</b> ${_escapeHtml(contextName)}
🏷️ <b>Type:</b> ${_escapeHtml(questionType)}

<b>Frage:</b>
$preview

⏰ ${DateTime.now().toString().substring(0, 16)}
''';

    await _telegram.sendNotification(message);
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }
}
