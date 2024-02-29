// To parse this JSON data, do
//
//     final predictModel = predictModelFromJson(jsonString);

import 'dart:convert';

List<PredictModel> predictModelFromJson(String str) => List<PredictModel>.from(json.decode(str).map((x) => PredictModel.fromJson(x)));

String predictModelToJson(List<PredictModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PredictModel {
  PredictModel({
    this.id,
    this.question,
    this.options = const [],
    this.selectedAnsId

  });

  int? id;
  String? question;
  List<String> options;
  int? selectedAnsId;


  factory PredictModel.fromJson(Map<String, dynamic> json) => PredictModel(
    id: json["id"],
    question: json["question"],
    options: List<String>.from(json["options"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "options": List<dynamic>.from(options.map((x) => x)),
  };
}
