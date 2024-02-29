import 'dart:convert';

List<MarketSymbolPrice> marketSymbolPriceFromJson(String str) => List<MarketSymbolPrice>.from(json.decode(str).map((x) => MarketSymbolPrice.fromJson(x)));

String marketSymbolPriceToJson(List<MarketSymbolPrice> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarketSymbolPrice {
  MarketSymbolPrice({
    this.symbol,
    this.price,
  });

  String? symbol;
  String? price;

  factory MarketSymbolPrice.fromJson(Map<String, dynamic> json) => MarketSymbolPrice(
    symbol: json["symbol"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "price": price,
  };
}
