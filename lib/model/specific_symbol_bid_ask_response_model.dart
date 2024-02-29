import 'dart:convert';

SpecificSymbolBidsAskResponseModel specificSymbolBidsAskResponseModelFromJson(String str) => SpecificSymbolBidsAskResponseModel.fromJson(json.decode(str));

String specificSymbolBidsAskResponseModelToJson(SpecificSymbolBidsAskResponseModel data) => json.encode(data.toJson());

class SpecificSymbolBidsAskResponseModel {
  SpecificSymbolBidsAskResponseModel({
    this.lastUpdateId,
    this.bids = const [],
    this.asks = const [],
  });

  int? lastUpdateId;
  List<List<String>> bids;
  List<List<String>> asks;

  factory SpecificSymbolBidsAskResponseModel.fromJson(Map<String, dynamic> json) => SpecificSymbolBidsAskResponseModel(
    lastUpdateId: json["lastUpdateId"],
    bids:json["bids"] == null?[]: List<List<String>>.from(json["bids"].map((x) => List<String>.from(x.map((x) => x)))),
    asks:json["asks"] == null?[]: List<List<String>>.from(json["asks"].map((x) => List<String>.from(x.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "lastUpdateId": lastUpdateId,
    "bids": List<dynamic>.from(bids.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "asks": List<dynamic>.from(asks.map((x) => List<dynamic>.from(x.map((x) => x)))),
  };
}
