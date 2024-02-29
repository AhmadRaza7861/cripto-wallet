import 'dart:convert';

List<AvailableCurrencyResponseModel> availableCurrencyResponseModelFromJson(String str) => List<AvailableCurrencyResponseModel>.from(json.decode(str).map((x) => AvailableCurrencyResponseModel.fromJson(x)));

String availableCurrencyResponseModelToJson(List<AvailableCurrencyResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AvailableCurrencyResponseModel {
  AvailableCurrencyResponseModel({
    this.title,
    this.currency,
    this.limit,
  });

  String? title;
  String? currency;
  int? limit;

  factory AvailableCurrencyResponseModel.fromJson(Map<String, dynamic> json) => AvailableCurrencyResponseModel(
    title: json["title"],
    currency: json["currency"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "currency": currency,
    "limit": limit,
  };
}
