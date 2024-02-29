// To parse this JSON data, do
//
//     final couponModel = couponModelFromJson(jsonString);

import 'dart:convert';

CouponModel couponModelFromJson(String str) => CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  CouponModel({
    this.shopping = const [],
    this.tradebot  = const [],
  });

  List<Shopping> shopping;
  List<Shopping> tradebot;

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
    shopping: json["shopping"] == null ? [] : List<Shopping>.from(json["shopping"]!.map((x) => Shopping.fromJson(x))),
    tradebot: json["tradebot"] == null ? [] : List<Shopping>.from(json["tradebot"]!.map((x) => Shopping.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "shopping": shopping == null ? [] : List<dynamic>.from(shopping!.map((x) => x.toJson())),
    "tradebot": tradebot == null ? [] : List<dynamic>.from(tradebot!.map((x) => x.toJson())),
  };
}

class Shopping {
  Shopping({
    this.id,
    this.coupon,
    this.userId,
    this.percentOff,
    this.used,
    this.insertedAt,
    this.usedAt,
  });

  int? id;
  String? coupon;
  int? userId;
  int? percentOff;
  int? used;
  DateTime? insertedAt;
  dynamic usedAt;

  factory Shopping.fromJson(Map<String, dynamic> json) => Shopping(
    id: json["id"],
    coupon: json["coupon"],
    userId: json["userId"],
    percentOff: json["percentOff"],
    used: json["used"],
    insertedAt: json["insertedAt"] == null ? null : DateTime.parse(json["insertedAt"]),
    usedAt: json["usedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "coupon": coupon,
    "userId": userId,
    "percentOff": percentOff,
    "used": used,
    "insertedAt": insertedAt?.toIso8601String(),
    "usedAt": usedAt,
  };
}
