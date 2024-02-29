import 'dart:convert';
import 'package:crypto_wallet/model/user_response_model.dart';

TradeBotInfoResponseModel tradeBotInfoResponseModelFromJson(String str) =>
    TradeBotInfoResponseModel.fromJson(json.decode(str));

String tradeBotInfoResponseModelToJson(TradeBotInfoResponseModel data) =>
    json.encode(data.toJson());

class TradeBotInfoResponseModel {
  TradeBotInfoResponseModel({
    this.tradeId,
    this.duration,
    this.amount,
    this.coin,
    this.amountReturned,
    this.createdAt,
    this.user,
  });

  int? tradeId;
  String? duration;
  String? amount;
  String? coin;
  String? amountReturned;
  DateTime? createdAt;
  User? user;

  factory TradeBotInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      TradeBotInfoResponseModel(
        tradeId: json["tradeId"],
        duration: json["duration"],
        amount: json["amount"],
        coin: json["coin"],
        amountReturned: json["amountReturned"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]).toLocal(),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "tradeId": tradeId,
        "duration": duration,
        "amount": amount,
        "coin": coin,
        "amountReturned": amountReturned,
        "createdAt": createdAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}
