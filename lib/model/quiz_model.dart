// To parse this JSON data, do
//
//     final quizModel = quizModelFromJson(jsonString);

import 'dart:convert';

QuizModel quizModelFromJson(String str) => QuizModel.fromJson(json.decode(str));

String quizModelToJson(QuizModel data) => json.encode(data.toJson());

class QuizModel {
  QuizModel({
    this.games = const [],
  });

  List<Game> games;

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
    games: json["games"] == null ? [] : List<Game>.from(json["games"].map((x) => Game.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "games": List<dynamic>.from(games.map((x) => x.toJson())),
  };
}

class Game {
  Game({
    this.gameId,
    this.gameTitle,
    this.attempted,
    this.questions = const [],
  });

  int? gameId;
  String? gameTitle;
  Attempted? attempted;
  List<Question> questions;

  factory Game.fromJson(Map<String, dynamic> json) => Game(
    gameId: json["gameId"],
    gameTitle: json["gameTitle"],
    attempted:json["attempted"] == null? null: Attempted.fromJson(json["attempted"]),
    questions:json["questions"] == null ? [] : List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "gameId": gameId,
    "gameTitle": gameTitle,
    "attempted": attempted?.toJson(),
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Attempted {
  Attempted({
    this.attempt,
    this.userAnswers = const [],
  });

  bool? attempt;
  List<UserAnswer> userAnswers;

  factory Attempted.fromJson(Map<String, dynamic> json) => Attempted(
    attempt: json["attempt"],
    userAnswers:json["userAnswers"] == null ? []: List<UserAnswer>.from(json["userAnswers"].map((x) => UserAnswer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "attempt": attempt,
    "userAnswers": List<dynamic>.from(userAnswers.map((x) => x.toJson())),
  };
}

class UserAnswer {
  UserAnswer({
    this.questionId,
    this.ans,
  });

  int? questionId;
  int? ans;

  factory UserAnswer.fromJson(Map<String, dynamic> json) => UserAnswer(
    questionId: json["questionId"],
    ans: json["ans"],
  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "ans": ans,
  };
}

class Question {
  Question({
    this.questionId,
    this.question,
    this.options = const [],
    this.answer,
    this.selectedAnsId,
    this.oldAnswer,
  });

  int? questionId;
  String? question;
  List<String> options;
  int? answer;
  int?selectedAnsId;
  int ? oldAnswer;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    questionId: json["questionId"],
    question: json["question"],
    options: List<String>.from(json["options"].map((x) => x)),
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "question": question,
    "options": List<dynamic>.from(options.map((x) => x)),
    "answer": answer,
  };
}
