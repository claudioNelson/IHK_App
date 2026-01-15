// widgets/question_widget_router.dart
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import 'exam_widgets/multiple_choice_widget.dart';
import 'exam_widgets/free_text_widget.dart';
import 'exam_widgets/code_widget.dart';
import 'exam_widgets/diagram_widget.dart';
import 'exam_widgets/table_completion_widget.dart';
import 'calculation_question_widget.dart'; // NEU
import 'fill_in_blank_widget.dart'; // NEU

class QuestionWidgetRouter extends StatelessWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;
  final Function(dynamic) onAnswerChanged;
  final dynamic currentAnswer;

  const QuestionWidgetRouter({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onAnswerChanged,
    this.currentAnswer,
  });

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.multipleChoice:
      case QuestionType.multipleSelect:
        return MultipleChoiceWidget(
          question: question,
          questionNumber: questionNumber,
          totalQuestions: totalQuestions,
          onAnswerChanged: onAnswerChanged,
          currentAnswer: currentAnswer,
        );

      case QuestionType.freeText:
        return FreeTextWidget(
          question: question,
          questionNumber: questionNumber,
          totalQuestions: totalQuestions,
          onAnswerChanged: onAnswerChanged,
          currentAnswer: currentAnswer as String?,
        );

      case QuestionType.code:
      case QuestionType.sqlQuery:
        return CodeWidget(
          question: question,
          questionNumber: questionNumber,
          totalQuestions: totalQuestions,
          onAnswerChanged: onAnswerChanged,
          currentAnswer: currentAnswer as String?,
        );

      case QuestionType.diagram:
        return DiagramWidget(
          question: question,
          questionNumber: questionNumber,
          totalQuestions: totalQuestions,
          onAnswerChanged: onAnswerChanged,
          currentAnswer: currentAnswer as String?,
        );

      case QuestionType.tableCompletion:
        return TableCompletionWidget(
          question: question,
          questionNumber: questionNumber,
          totalQuestions: totalQuestions,
          onAnswerChanged: onAnswerChanged,
          currentAnswer: currentAnswer as String?,
        );

      case QuestionType.fillInBlank: // NEU
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: FillInTheBlankWidget(
            questionText: question.description,
            blankData: question.additionalData ?? {},
            onAnswerSubmitted: (isCorrect, userAnswers) {
              onAnswerChanged(userAnswers);
            },
          ),
        );

      case QuestionType.calculation:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: CalculationQuestionWidget(
            questionText: question.description,
            calculationData: question.calculationData ?? {},
            onAnswerSubmitted: (isCorrect, userAnswer) {
              onAnswerChanged(userAnswer);
            },
          ),
        );
    }
  }
}
