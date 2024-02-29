import 'dart:convert';

import 'package:crypto_wallet/model/user_response_model.dart';

List<TransactionHistoryResponseModel> transactionHistoryResponseModelFromJson(String str) => List<TransactionHistoryResponseModel>.from(json.decode(str).map((x) => TransactionHistoryResponseModel.fromJson(x)));

String transactionHistoryResponseModelToJson(List<TransactionHistoryResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionHistoryResponseModel {
  TransactionHistoryResponseModel({
    this.id,
    this.sender,
    this.receiver,
    this.transactionTime,
    this.transactionAmount,
  });

  int? id;
  User? sender;
  User? receiver;
  DateTime? transactionTime;
  String? transactionAmount;

  factory TransactionHistoryResponseModel.fromJson(Map<String, dynamic> json) => TransactionHistoryResponseModel(
    id: json["id"],
    sender:json["sender"] == null?null: User.fromJson(json["sender"]),
    receiver:json["receiver"] == null?null: User.fromJson(json["receiver"]),
    transactionTime:json["transactionTime"] == null?null: DateTime.parse(json["transactionTime"]).toLocal(),
    transactionAmount:json["transactionAmount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender": sender?.toJson(),
    "receiver": receiver?.toJson(),
    "transactionTime": transactionTime?.toIso8601String(),
    "transactionAmount": transactionAmount,
  };
}

