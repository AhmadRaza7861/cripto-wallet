// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

List<BannerModel> bannerModelFromJson(String str) =>  List<BannerModel>.from(json.decode(str)!.map((x) => BannerModel.fromJson(x)));

String bannerModelToJson(List<BannerModel> data) => json.encode( List<dynamic>.from(data.map((x) => x.toJson())));



class BannerModel {
  BannerModel({
    this.id,
    this.image,
    this.insertedAt,
    this.updatedAt,
  });

  int? id;
  String? image;
  DateTime? insertedAt;
  DateTime? updatedAt;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json["id"],
    image: json["image"],
    insertedAt: DateTime.parse(json["insertedAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "insertedAt": insertedAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
