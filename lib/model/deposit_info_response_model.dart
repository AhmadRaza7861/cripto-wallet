import 'dart:convert';
import 'package:crypto_wallet/model/user_response_model.dart';

DepositInfoResponseModel depositInfoResponseModelFromJson(String str) => DepositInfoResponseModel.fromJson(json.decode(str));

String depositInfoResponseModelToJson(DepositInfoResponseModel data) => json.encode(data.toJson());

class DepositInfoResponseModel {
  DepositInfoResponseModel({
    this.depositId,
    this.status,
    this.amount,
    this.initiatedAt,
    this.method,
    this.user,
  });

  int? depositId;
  String? status;
  String? amount;
  DateTime? initiatedAt;
  String? method;
  User? user;

  factory DepositInfoResponseModel.fromJson(Map<String, dynamic> json) => DepositInfoResponseModel(
    depositId: json["depositId"],
    status: json["status"],
    amount: json["amount"],
    initiatedAt:json["initiatedAt"] == null?null: DateTime.parse(json["initiatedAt"]).toLocal(),
    method: json["method"],
    user: json["user"] == null?null:User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "depositId": depositId,
    "status": status,
    "amount": amount,
    "initiatedAt": initiatedAt?.toIso8601String(),
    "method": method,
    "user": user?.toJson(),
  };
}