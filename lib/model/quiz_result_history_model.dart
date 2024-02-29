// To parse this JSON data, do
//
//     final quizResultHistory = quizResultHistoryFromJson(jsonString);

import 'dart:convert';

List<QuizResultHistory> quizResultHistoryFromJson(String str) => List<QuizResultHistory>.from(json.decode(str).map((x) => QuizResultHistory.fromJson(x)));

String quizResultHistoryToJson(List<QuizResultHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuizResultHistory {
  QuizResultHistory({
    this.gameId,
    this.title,
    this.reward,
    this.attemptDate,
  });

  int? gameId;
  String? title;
  String? reward;
  DateTime? attemptDate;

  factory QuizResultHistory.fromJson(Map<String, dynamic> json) => QuizResultHistory(
    gameId: json["gameId"],
    title: json["title"],
    reward: json["reward"],
    attemptDate: DateTime.parse(json["attemptDate"]),
  );

  Map<String, dynamic> toJson() => {
    "gameId": gameId,
    "title": title,
    "reward": reward,
    "attemptDate": attemptDate?.toIso8601String(),
  };
}
