import 'dart:convert';

List<ChartDataResponseModel> chartDataResponseModelFromJson(String str) =>
    List<ChartDataResponseModel>.from(
        json.decode(str).map((x) => ChartDataResponseModel.fromJson(x)));

// String chartDataResponseModelToJson(List<List<ChartDataResponseModel>> data) => json.encode(List<ChartDataResponseModel>.from(data.map((x) => List<dynamic>.from(x.map((x) => x)))));

class ChartDataResponseModel {
  DateTime? openTime;
  double? openPrice;
  double? highPrice;
  double? lowPrice;
  double? closePrice;
  double? volume;
  DateTime? closeTime;
  double? quoteVolume;
  int? trade;
  double? baseAssetVolume;
  double? quoteAssetVolume;
  bool isClosedCandle;

  ChartDataResponseModel(
      {this.openTime,
      this.openPrice,
      this.highPrice,
      this.lowPrice,
      this.closePrice,
      this.volume,
      this.closeTime,
      this.quoteVolume,
      this.trade,
      this.baseAssetVolume,
      this.quoteAssetVolume,
      this.isClosedCandle = false});

  factory ChartDataResponseModel.fromJson(List list) => ChartDataResponseModel(
        openTime: DateTime.fromMillisecondsSinceEpoch(list[0], isUtc: true),
        openPrice: double.tryParse(list[1]) ?? 0,
        highPrice: double.tryParse(list[2]) ?? 0,
        lowPrice: double.tryParse(list[3]) ?? 0,
        closePrice: double.tryParse(list[4]) ?? 0,
        volume: double.tryParse(list[5]) ?? 0,
        closeTime: DateTime.fromMillisecondsSinceEpoch(list[6], isUtc: true),
        quoteVolume: double.tryParse(list[7]) ?? 0,
        trade: list[8] ?? 0,
        baseAssetVolume: double.tryParse(list[9]) ?? 0,
        quoteAssetVolume: double.tryParse(list[10]) ?? 0,
        isClosedCandle: true,
      );

  factory ChartDataResponseModel.fromJsonMap(Map<String, dynamic> json) =>
      ChartDataResponseModel(
        openTime: DateTime.fromMillisecondsSinceEpoch(json["t"], isUtc: true),
        openPrice: double.tryParse(json["o"]) ?? 0,
        highPrice: double.tryParse(json["h"]) ?? 0,
        lowPrice: double.tryParse(json["l"]) ?? 0,
        closePrice: double.tryParse(json["c"]) ?? 0,
        volume: double.tryParse(json["v"]) ?? 0,
        closeTime: DateTime.fromMillisecondsSinceEpoch(json["T"], isUtc: true),
        quoteVolume: double.tryParse(json["q"]) ?? 0,
        trade: json["n"] ?? 0,
        baseAssetVolume: double.tryParse(json["V"]) ?? 0,
        quoteAssetVolume: double.tryParse(json["Q"]) ?? 0,
        isClosedCandle: json["x"] == true,
      );
}
