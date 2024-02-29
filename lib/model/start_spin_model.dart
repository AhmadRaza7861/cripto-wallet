// To parse this JSON data, do
//
//     final startSpin = startSpinFromJson(jsonString);

import 'dart:convert';

StartSpin startSpinFromJson(String str) => StartSpin.fromJson(json.decode(str));

String startSpinToJson(StartSpin data) => json.encode(data.toJson());

class StartSpin {
  StartSpin({
     this.result,
     this.reward,
  });

  Result? result;
  Reward? reward;

  factory StartSpin.fromJson(Map<String, dynamic> json) => StartSpin(
    result:json["result"] == null?null: Result.fromJson(json["result"]),
    reward:json["reward"] == null?null: Reward.fromJson(json["reward"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "reward": reward?.toJson(),
  };
}

class Result {
  Result({
     this.id,
     this.name,
     this.active,
  });

  int? id;
  String? name;
  int? active;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null?null: json["id"],
    name:json["name"] == null?null:  json["name"],
    active: json["active"] == null?null: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active": active,
  };
}

class Reward {
  Reward({
    this.coupon,
    this.balance,
    this.stwTickets,
    this.pawTickets,
    this.quizTickets,
    this.winningAmount
  });

  String? coupon;
  String? balance;
  int? stwTickets;
  int? pawTickets;
  int? quizTickets;
  int? winningAmount;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    coupon: json["coupon"] == null?null:json["coupon"],
    balance:json["balance"] == null?null: json["balance"],
    stwTickets:json["stw_tickets"] == null?null:json["stw_tickets"],
    pawTickets:json["paw_tickets"] == null?null:json["paw_tickets"],
    quizTickets:json["quiz_tickets"] == null?null:json["quiz_tickets"],
    winningAmount:json["winningAmount"] == null?null:json["winningAmount"],
  );

  Map<String, dynamic> toJson() => {
    "coupon": coupon,
    "balance": balance,
    "stw_tickets": stwTickets,
    "paw_tickets": pawTickets,
    "quiz_tickets": quizTickets,
    "winningAmount": winningAmount,
  };
}
