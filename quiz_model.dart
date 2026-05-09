class QuizModel {
  final String? id;
  final String? userId;
  final String topic;
  final int score;
  final int totalQuestions;
  final DateTime? createdAt;

  QuizModel({
    this.id,
    this.userId,
    required this.topic,
    required this.score,
    required this.totalQuestions,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'topic': topic,
      'score': score,
      'total_questions': totalQuestions,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      answerIndex: map['answerIndex'] ?? 0,
      explanation: map['explanation'] ?? '',
    );
  }
}
