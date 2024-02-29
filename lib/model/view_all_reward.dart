// To parse this JSON data, do
//
//     final viewAllReward = viewAllRewardFromJson(jsonString);

import 'dart:convert';

List<ViewAllReward> viewAllRewardFromJson(String str) => List<ViewAllReward>.from(json.decode(str).map((x) => ViewAllReward.fromJson(x)));

String viewAllRewardToJson(List<ViewAllReward> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ViewAllReward {
  ViewAllReward({
    this.id,
    this.name,
    this.active,
  });

  int? id;
  String? name;
  int? active;

  factory ViewAllReward.fromJson(Map<String, dynamic> json) => ViewAllReward(
    id: json["id"],
    name: json["name"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active": active,
  };
}
