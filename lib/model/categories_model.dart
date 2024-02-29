// To parse this JSON data, do
//
//     final categoriesMoldel = categoriesMoldelFromJson(jsonString);

import 'dart:convert';

List<CategoriesMoldel> categoriesMoldelFromJson(String str) =>  List<CategoriesMoldel>.from(json.decode(str)!.map((x) => CategoriesMoldel.fromJson(x)));

String categoriesMoldelToJson(List<CategoriesMoldel?>? data) => json.encode( List<dynamic>.from(data!.map((x) => x!.toJson())));

class CategoriesMoldel {
  CategoriesMoldel({
    this.id,
    this.name,
    this.image,
    this.active,
    this.insertedAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? image;
  int? active;
  DateTime? insertedAt;
  DateTime? updatedAt;

  factory CategoriesMoldel.fromJson(Map<String, dynamic> json) => CategoriesMoldel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    active: json["active"],
    insertedAt: DateTime.parse(json["insertedAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "active": active,
    "insertedAt": insertedAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
