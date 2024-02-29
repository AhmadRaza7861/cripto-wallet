// To parse this JSON data, do
//
//     final tradebotModel = tradebotModelFromJson(jsonString);

import 'dart:convert';

List<TradebotModel> tradebotModelFromJson(String str) => List<TradebotModel>.from(json.decode(str).map((x) => TradebotModel.fromJson(x)));

String tradebotModelToJson(List<TradebotModel> data) => json.encode( List<dynamic>.from(data.map((x) => x.toJson())));

class TradebotModel {
  TradebotModel({
    this.tradeId,
    this.duration,
    this.amount,
    this.coin,
    this.createdAt,
    this.amountReturned,
    this.updatedAt,
    this.user,
  });

  int? tradeId;
  String? duration;
  String? amount;
  String? coin;
  DateTime? createdAt;
  String? amountReturned;
  DateTime? updatedAt;
  TradebotUser? user;

  factory TradebotModel.fromJson(Map<String, dynamic> json) => TradebotModel(
    tradeId: json["tradeId"],
    duration: json["duration"],
    amount: json["amount"],
    coin: json["coin"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    amountReturned:json["amountReturned"] == null ? null : json["amountReturned"],
    updatedAt:json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    user: TradebotUser.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "tradeId": tradeId,
    "duration": duration,
    "amount": amount,
    "coin": coin,
    "createdAt": createdAt?.toIso8601String(),
    "amountReturned": amountReturned,
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user!.toJson(),
  };
}

class TradebotUser {
  TradebotUser({
    this.userId,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.balance,
    this.walletAddress,
    this.profileImage,
  });

  int? userId;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? balance;
  String? walletAddress;
  String? profileImage;

  factory TradebotUser.fromJson(Map<String, dynamic> json) => TradebotUser(
    userId: json["userId"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    phone: json["phone"],
    balance: json["balance"],
    walletAddress: json["walletAddress"],
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "phone": phone,
    "balance": balance,
    "walletAddress": walletAddress,
    "profileImage": profileImage,
  };
}
