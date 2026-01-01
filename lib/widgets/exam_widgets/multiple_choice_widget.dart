// widgets/exam_widgets/multiple_choice_widget.dart

import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import 'question_widget_base.dart';

class MultipleChoiceWidget extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;
  final Function(dynamic) onAnswerChanged;
  final dynamic currentAnswer;

  const MultipleChoiceWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onAnswerChanged,
    this.currentAnswer,
  });

  @override
  State<MultipleChoiceWidget> createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  late dynamic selectedAnswer;
  
  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.currentAnswer;
  }

  @override
  Widget build(BuildContext context) {
    final isMultipleSelect = widget.question.type == QuestionType.multipleSelect;
    
    return QuestionWidgetBase(
      question: widget.question,
      questionNumber: widget.questionNumber,
      totalQuestions: widget.totalQuestions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isMultipleSelect 
              ? 'Wählen Sie alle zutreffenden Antworten:' 
              : 'Wählen Sie die richtige Antwort:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          ...widget.question.options!.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            
            if (isMultipleSelect) {
              // Multiple Select (Checkboxen)
              final selectedList = selectedAnswer is List ? selectedAnswer as List : [];
              final isSelected = selectedList.contains(option);
              
              return _buildCheckboxOption(
                option: option,
                isSelected: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (selectedAnswer == null || selectedAnswer is! List) {
                      selectedAnswer = <String>[];
                    }
                    
                    if (value == true) {
                      (selectedAnswer as List).add(option);
                    } else {
                      (selectedAnswer as List).remove(option);
                    }
                    
                    widget.onAnswerChanged(selectedAnswer);
                  });
                },
              );
            } else {
              // Single Choice (Radio Buttons)
              return _buildRadioOption(
                option: option,
                isSelected: selectedAnswer == option,
                onChanged: () {
                  setState(() {
                    selectedAnswer = option;
                    widget.onAnswerChanged(selectedAnswer);
                  });
                },
              );
            }
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String option,
    required bool isSelected,
    required VoidCallback onChanged,
  }) {
    return InkWell(
      onTap: onChanged,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue[400]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue[600]! : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? Colors.blue[600] : Colors.white,
              ),
              child: isSelected
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Colors.blue[900] : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption({
    required String option,
    required bool isSelected,
    required Function(bool?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue[400]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? Colors.blue[600]! : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? Colors.blue[600] : Colors.white,
              ),
              child: isSelected
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Colors.blue[900] : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
