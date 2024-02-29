// To parse this JSON data, do
//
//     final withDrawResponseModel = withDrawResponseModelFromJson(jsonString);

import 'dart:convert';

WithDrawResponseModel withDrawResponseModelFromJson(String str) =>
    WithDrawResponseModel.fromJson(json.decode(str));

String withDrawResponseModelToJson(WithDrawResponseModel data) =>
    json.encode(data.toJson());

class WithDrawResponseModel {
  WithDrawResponseModel({
    this.id,
    this.user,
    this.amount,
    this.createdAt,
    this.status,
    this.accountNo,
    this.ifscCode,
    this.accountHolderName,
  });

  int? id;
  int? user;
  String? amount;
  DateTime? createdAt;
  String? status;
  String? accountNo;
  String? ifscCode;
  String? accountHolderName;

  factory WithDrawResponseModel.fromJson(Map<String, dynamic> json) =>
      WithDrawResponseModel(
        id: json["id"],
        user: json["user"],
        amount: json["amount"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]).toLocal(),
        status: json["status"],
        accountNo: json["accountNo"],
        ifscCode: json["ifsc_code"],
        accountHolderName: json["accountHolderName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "amount": amount,
        "createdAt": createdAt?.toIso8601String(),
        "status": status,
        "accountNo": accountNo,
        "ifsc_code": ifscCode,
        "accountHolderName": accountHolderName,
      };
}
