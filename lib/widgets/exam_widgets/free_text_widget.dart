// widgets/exam_widgets/free_text_widget.dart

import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import 'question_widget_base.dart';


class FreeTextWidget extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;
  final Function(String) onAnswerChanged;
  final String? currentAnswer;

  const FreeTextWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onAnswerChanged,
    this.currentAnswer,
  });

  @override
  State<FreeTextWidget> createState() => _FreeTextWidgetState();
}

class _FreeTextWidgetState extends State<FreeTextWidget> {
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
          const Text(
            'Ihre Antwort:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          TextField(
            controller: _controller,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Geben Sie hier Ihre Antwort ein...',
              hintStyle: TextStyle(color: Colors.grey[400]),
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
                borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
              ),
            ),
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Zeichenzähler
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_controller.text.length} Zeichen',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
