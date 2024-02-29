import 'dart:convert';

import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:intl/intl.dart';

List<AllTransactionHistoryResponseModel>
    allTransactionHistoryResponseModelFromJson(String str) =>
        List<AllTransactionHistoryResponseModel>.from(json
            .decode(str)
            .map((x) => AllTransactionHistoryResponseModel.fromJson(x)));

String allTransactionHistoryResponseModelToJson(
        List<AllTransactionHistoryResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
DateFormat _dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

class AllTransactionHistoryResponseModel {
  AllTransactionHistoryResponseModel({
    this.id,
    this.amount,
    this.transactionId,
    this.type,
    this.time,
    this.user,
  });

  int? id;
  double? amount;
  int? transactionId;
  Type? type;
  DateTime? time;
  User? user;

  factory AllTransactionHistoryResponseModel.fromJson(
          Map<String, dynamic> json) =>
      AllTransactionHistoryResponseModel(
        id: json["id"],
        amount: double.tryParse((json["amount"] ?? "0").toString()) ?? 0,
        type: json["type"] == null ? null : typeValues.map[json["type"]],
        transactionId: json["transactionId"],
        time: json["time"] == null
            ? null
            : DateTime.parse(json["time"]).toLocal(),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "type": typeValues.reverse?[type],
        "transactionId": transactionId,
        "time": time?.toIso8601String(),
        "user": user?.toJson(),
      };
}

enum Type {
  TRADEBOT,
  SHOPPING,
  DEPOSIT,
  COIN_TRANSFER,
  WITHDRAW,
  TRADEBOT_RETURN,
  WITHDRAW_REJECTED,
  REFERAL_REWARD,
  MONTHLY_REWARD,
  DAILY_SPIN,
  QUIZ_REWARD
}

final typeValues = EnumValues({
  "COIN_TRANSFER": Type.COIN_TRANSFER,
  "DEPOSIT": Type.DEPOSIT,
  "SHOPPING": Type.SHOPPING,
  "TRADEBOT": Type.TRADEBOT,
  "WITHDRAW": Type.WITHDRAW,
  "TRADEBOT_RETURN": Type.TRADEBOT_RETURN,
  "WITHDRAW_REJECTED": Type.WITHDRAW_REJECTED,
  "REFERAL_REWARD":Type.REFERAL_REWARD,
  "MONTHLY_REWARD":Type.MONTHLY_REWARD,
  "DAILY_SPIN":Type.DAILY_SPIN,
  "QUIZ_REWARD":Type.QUIZ_REWARD
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
