enum QuestionType {
  multipleChoice,
  multipleSelect,
  freeText,
  code,
  diagram,
  calculation,
  sqlQuery,
  tableCompletion,
  fillInBlank, // NEU
  sequence,
}

class Question {
  final String id;
  final String title;
  final String description;
  final QuestionType type;
  final int points;
  final List<String>? options; // Für Multiple Choice/Select
  final List<String>? correctAnswers; // Richtige Antworten
  final String? hint; // Hinweise für die Lösung
  final String? imageAsset; // Pfad zum Bild
  final Map<String, dynamic>? additionalData; // Zusätzliche Daten
  final Map<String, dynamic>? calculationData; // NEU: Für Rechenaufgaben

  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.points,
    this.options,
    this.correctAnswers,
    this.hint,
    this.imageAsset,
    this.additionalData,
    this.calculationData, // NEU
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type.toString(),
    'points': points,
    'options': options,
    'correctAnswers': correctAnswers,
    'hint': hint,
    'imageAsset': imageAsset,
    'additionalData': additionalData,
    'calculationData': calculationData, // NEU
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'].toString(),
    title: json['title'] ?? json['aufgabe_nummer'] ?? '',
    description: json['description'] ?? json['frage'] ?? '',
    type: _parseQuestionType(json['question_type']),
    points: json['points'] ?? json['punkte'] ?? 1,
    options: json['options'] != null
        ? List<String>.from(json['options'])
        : null,
    correctAnswers: json['correctAnswers'] != null
        ? List<String>.from(json['correctAnswers'])
        : null,
    hint: json['hint'],
    imageAsset: json['imageAsset'] ?? json['bild_url'],
    additionalData: json['additionalData'],
    calculationData: json['calculation_data'], // NEU
  );

  /// NEU: Helper Funktion um DB question_type zu QuestionType Enum zu konvertieren
  static QuestionType _parseQuestionType(dynamic type) {
    if (type == null) return QuestionType.multipleChoice;

    final typeStr = type.toString().toLowerCase();

    switch (typeStr) {
      case 'calculation':
        return QuestionType.calculation;
      case 'fill_blank':
      case 'fillblank':
      case 'fill_in_blank':
        return QuestionType.fillInBlank; // NEU
      case 'multiple_choice':
      case 'multiplechoice':
        return QuestionType.multipleChoice;
      case 'multiple_select':
      case 'multipleselect':
        return QuestionType.multipleSelect;
      case 'free_text':
      case 'freetext':
        return QuestionType.freeText;
      case 'code':
        return QuestionType.code;
      case 'diagram':
        return QuestionType.diagram;
      case 'sql_query':
      case 'sqlquery':
        return QuestionType.sqlQuery;
      case 'table_completion':
      case 'tablecompletion':
        return QuestionType.tableCompletion;
      default:
        return QuestionType.multipleChoice;
    }
  }
}

class ExamSection {
  final String id;
  final String title;
  final List<Question> questions;
  final int totalPoints;

  ExamSection({
    required this.id,
    required this.title,
    required this.questions,
    required this.totalPoints,
  });

  int get currentPoints {
    return questions.fold(0, (sum, q) => sum + q.points);
  }
}

class UserAnswer {
  final String questionId;
  final dynamic answer; // Kann String, List<String>, etc. sein
  final DateTime timestamp;

  UserAnswer({
    required this.questionId,
    required this.answer,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'answer': answer,
    'timestamp': timestamp.toIso8601String(),
  };
}

class ExamAttempt {
  final String id;
  final String examId;
  final DateTime startTime;
  final DateTime? endTime;
  final Map<String, UserAnswer> answers;
  final int? score;
  final int totalPoints;

  ExamAttempt({
    required this.id,
    required this.examId,
    required this.startTime,
    this.endTime,
    required this.answers,
    this.score,
    required this.totalPoints,
  });

  bool get isCompleted => endTime != null;

  double get percentage => score != null ? (score! / totalPoints) * 100 : 0;
}
