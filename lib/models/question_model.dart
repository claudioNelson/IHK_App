// models/question_model.dart
enum QuestionType {
  multipleChoice,      // Multiple Choice mit einer richtigen Antwort
  multipleSelect,      // Mehrere richtige Antworten möglich
  freeText,           // Freitext-Antwort
  code,               // Code/Pseudocode schreiben
  diagram,            // Diagramm erstellen (UML, ER)
  calculation,        // Berechnungsaufgabe
  sqlQuery,           // SQL-Abfrage schreiben
  tableCompletion     // Tabelle ausfüllen
}

class Question {
  final String id;
  final String title;
  final String description;
  final QuestionType type;
  final int points;
  final List<String>? options;           // Für Multiple Choice/Select
  final List<String>? correctAnswers;    // Richtige Antworten
  final String? hint;                    // Hinweise für die Lösung
  final String? imageAsset;              // NEU: Pfad zum Bild (z.B. 'assets/images/hs2_graph.png')
  final Map<String, dynamic>? additionalData; // Zusätzliche Daten (z.B. Tabellen, Diagramme)

  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.points,
    this.options,
    this.correctAnswers,
    this.hint,
    this.imageAsset,                     // NEU
    this.additionalData,
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
    'imageAsset': imageAsset,            // NEU
    'additionalData': additionalData,
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    type: QuestionType.values.firstWhere(
      (e) => e.toString() == json['type'],
    ),
    points: json['points'],
    options: json['options'] != null ? List<String>.from(json['options']) : null,
    correctAnswers: json['correctAnswers'] != null ? List<String>.from(json['correctAnswers']) : null,
    hint: json['hint'],
    imageAsset: json['imageAsset'],      // NEU
    additionalData: json['additionalData'],
  );
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
  final dynamic answer;  // Kann String, List<String>, etc. sein
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