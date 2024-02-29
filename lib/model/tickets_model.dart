// To parse this JSON data, do
//
//     final ticketsModel = ticketsModelFromJson(jsonString);

import 'dart:convert';

TicketsModel ticketsModelFromJson(String str) => TicketsModel.fromJson(json.decode(str));

String ticketsModelToJson(TicketsModel data) => json.encode(data.toJson());

class TicketsModel {
  TicketsModel({
    this.stwTickets,
    this.pawTickets,
  });

  int? stwTickets;
  int? pawTickets;

  factory TicketsModel.fromJson(Map<String, dynamic> json) => TicketsModel(
    stwTickets: json["stw_tickets"],
    pawTickets: json["paw_tickets"],
  );

  Map<String, dynamic> toJson() => {
    "stw_tickets": stwTickets,
    "paw_tickets": pawTickets,
  };
}
