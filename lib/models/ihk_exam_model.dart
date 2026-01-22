// Fragetypen für IHK Prüfungen
enum QuestionType {
  info, // Nur Informationstext, keine Antwort nötig
  freeText, // Freitext-Antwort
  code, // Code/SQL-Eingabe
  diagram, // Diagramm zeichnen
  multipleChoice, // Multiple Choice (falls später gebraucht)
  fillBlanks, // Lückentext (falls später gebraucht)
}

// Einzelne Frage
class ExamQuestion {
  final String id;
  final String title;
  final String description;
  final QuestionType type;
  final int points;
  final String? hint;
  final String? image;

  ExamQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.points,
    this.hint,
    this.image,
  });

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    return ExamQuestion(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: _parseQuestionType(json['type']),
      points: json['points'],
      hint: json['hint'],
      image: json['image'],
    );
  }

  static QuestionType _parseQuestionType(String type) {
    switch (type) {
      case 'info':
        return QuestionType.info;
      case 'freeText':
        return QuestionType.freeText;
      case 'code':
        return QuestionType.code;
      case 'diagram':
        return QuestionType.diagram;
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'fillBlanks':
        return QuestionType.fillBlanks;
      default:
        return QuestionType.freeText;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'points': points,
      'hint': hint,
      'image': image,
    };
  }
}

// Handlungsschritt (Section)
class ExamSection {
  final String id;
  final String title;
  final int totalPoints;
  final List<ExamQuestion> questions;

  ExamSection({
    required this.id,
    required this.title,
    required this.totalPoints,
    required this.questions,
  });

  factory ExamSection.fromJson(Map<String, dynamic> json) {
    return ExamSection(
      id: json['id'],
      title: json['title'],
      totalPoints: json['totalPoints'],
      questions: (json['questions'] as List)
          .map((q) => ExamQuestion.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'totalPoints': totalPoints,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

// Komplette Prüfung
class IHKExam {
  final String id;
  final String title;
  final int year;
  final String season;
  final int duration; // in Minuten
  final int totalPoints;
  final String company;
  final String scenario;
  final List<ExamSection> sections;

  IHKExam({
    required this.id,
    required this.title,
    required this.year,
    required this.season,
    required this.duration,
    required this.totalPoints,
    required this.company,
    required this.scenario,
    required this.sections,
  });

  factory IHKExam.fromJson(Map<String, dynamic> json) {
    return IHKExam(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      season: json['season'],
      duration: json['duration'],
      totalPoints: json['totalPoints'],
      company: json['company'],
      scenario: json['scenario'],
      sections: (json['sections'] as List)
          .map((s) => ExamSection.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'season': season,
      'duration': duration,
      'totalPoints': totalPoints,
      'company': company,
      'scenario': scenario,
      'sections': sections.map((s) => s.toJson()).toList(),
    };
  }
}

// Liste aller Prüfungen
class ExamList {
  static List<IHKExam> getAEExams() {
    // Hier kommen später die echten Daten
    return [];
  }

  static List<IHKExam> getSIExams() {
    // Hier kommen später die echten Daten
    return [];
  }

  static List<IHKExam> getAllExams() {
    return [...getAEExams(), ...getSIExams()];
  }
}
