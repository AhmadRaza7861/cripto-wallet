// To parse this JSON data, do
//
//     final submitModel = submitModelFromJson(jsonString);

import 'dart:convert';

SubmitModel submitModelFromJson(String str) => SubmitModel.fromJson(json.decode(str));

String submitModelToJson(SubmitModel data) => json.encode(data.toJson());

class SubmitModel {
  SubmitModel({
    this.marks,
    this.correct,
    this.total,
    this.message,
  });

  int? marks;
  int? correct;
  int? total;
  String? message;

  factory SubmitModel.fromJson(Map<String, dynamic> json) => SubmitModel(
    marks: json["marks"],
    correct: json["correct"],
    total: json["total"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "marks": marks,
    "correct": correct,
    "total": total,
    "message": message,
  };
}
