// widgets/exam_widgets/table_completion_widget.dart

import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import 'question_widget_base.dart';

class TableCompletionWidget extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;
  final Function(String) onAnswerChanged;
  final String? currentAnswer;

  const TableCompletionWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onAnswerChanged,
    this.currentAnswer,
  });

  @override
  State<TableCompletionWidget> createState() => _TableCompletionWidgetState();
}

class _TableCompletionWidgetState extends State<TableCompletionWidget> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentAnswer ?? '');
    _controller.addListener(() {
      widget.onAnswerChanged(_controller.text);
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuestionWidgetBase(
      question: widget.question,
      questionNumber: widget.questionNumber,
      totalQuestions: widget.totalQuestions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.table_chart,
                color: Colors.green[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Tabelle vervollständigen:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Beispiel-Tabelle (würde aus additionalData kommen)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    _buildTableHeader('Tabelle'),
                    _buildTableHeader('Schlüssel'),
                  ],
                ),
                TableRow(
                  children: [
                    _buildTableCell('Kunde'),
                    _buildTableCell('Kunden_ID (PK)'),
                  ],
                ),
                TableRow(
                  children: [
                    _buildTableCell('...'),
                    _buildTableCell('...'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Anleitung
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.green[700], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Geben Sie die fehlenden Tabellen und Schlüssel an. Kennzeichnen Sie Primärschlüssel mit (PK) und Fremdschlüssel mit (FK).',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Antwortfeld
          const Text(
            'Ihre Tabellendefinitionen:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          
          TextField(
            controller: _controller,
            maxLines: 12,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: '''Beispiel:
Kunde
- Kunden_ID (PK)
- Name
- Vorname
- ...

Rechnung
- Rechnungs_ID (PK)
- Kunden_ID (FK)
- ...''',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'monospace',
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green[400]!, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}
