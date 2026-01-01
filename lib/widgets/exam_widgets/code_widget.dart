// widgets/exam_widgets/code_widget.dart

import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import 'question_widget_base.dart';

class CodeWidget extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;
  final Function(String) onAnswerChanged;
  final String? currentAnswer;

  const CodeWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onAnswerChanged,
    this.currentAnswer,
  });

  @override
  State<CodeWidget> createState() => _CodeWidgetState();
}

class _CodeWidgetState extends State<CodeWidget> {
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
    final isSql = widget.question.type == QuestionType.sqlQuery;
    
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
                isSql ? Icons.storage : Icons.code,
                color: Colors.blue[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isSql ? 'SQL-Abfrage:' : 'Code/Pseudocode:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: Column(
              children: [
                // Code-Editor Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        isSql ? 'query.sql' : 'code.txt',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Code-Editor
                TextField(
                  controller: _controller,
                  maxLines: 15,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    hintText: isSql 
                      ? 'SELECT * FROM ...' 
                      : '// Geben Sie hier Ihren Code ein...',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'monospace',
                    ),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Info-Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isSql
                      ? 'Schreiben Sie eine vollständige SQL-Abfrage'
                      : 'Verwenden Sie Pseudocode oder eine Programmiersprache Ihrer Wahl',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Zeilen- und Zeichenzähler
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${_controller.text.split('\n').length} Zeilen',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${_controller.text.length} Zeichen',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
