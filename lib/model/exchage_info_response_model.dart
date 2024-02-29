import 'dart:convert';

ExchangeInfoResponseModel exchangeInfoResponseModelFromJson(String str) =>
    ExchangeInfoResponseModel.fromJson(json.decode(str));

String exchangeInfoResponseModelToJson(ExchangeInfoResponseModel data) =>
    json.encode(data.toJson());

class ExchangeInfoResponseModel {
  ExchangeInfoResponseModel({
    this.timezone,
    this.serverTime,
    this.rateLimits = const [],
    this.exchangeFilters = const [],
    this.symbols = const [],
  });

  String? timezone;
  int? serverTime;
  List<RateLimit> rateLimits;
  List<dynamic> exchangeFilters;
  List<Symbol> symbols;

  factory ExchangeInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      ExchangeInfoResponseModel(
        timezone: json["timezone"],
        serverTime: json["serverTime"],
        rateLimits: json["rateLimits"] == null
            ? []
            : List<RateLimit>.from(
                json["rateLimits"].map((x) => RateLimit.fromJson(x))),
        exchangeFilters: json["exchangeFilters"] == null
            ? []
            : List<dynamic>.from(json["exchangeFilters"].map((x) => x)),
        symbols: json["symbols"] == null
            ? []
            : List<Symbol>.from(json["symbols"].map((x) => Symbol.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "timezone": timezone,
        "serverTime": serverTime,
        "rateLimits": List<dynamic>.from(rateLimits.map((x) => x.toJson())),
        "exchangeFilters": List<dynamic>.from(exchangeFilters.map((x) => x)),
        "symbols": List<dynamic>.from(symbols.map((x) => x.toJson())),
      };
}

class RateLimit {
  RateLimit({
    this.rateLimitType,
    this.interval,
    this.intervalNum,
    this.limit,
  });

  String? rateLimitType;
  String? interval;
  int? intervalNum;
  int? limit;

  factory RateLimit.fromJson(Map<String, dynamic> json) => RateLimit(
        rateLimitType: json["rateLimitType"],
        interval: json["interval"],
        intervalNum: json["intervalNum"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "rateLimitType": rateLimitType,
        "interval": interval,
        "intervalNum": intervalNum,
        "limit": limit,
      };
}

class Symbol {
  Symbol({
    this.symbol,
    this.status,
    this.baseAsset,
    this.baseAssetPrecision,
    this.quoteAsset,
    this.quotePrecision,
    this.quoteAssetPrecision,
    this.baseCommissionPrecision,
    this.quoteCommissionPrecision,
    this.orderTypes = const [],
    this.icebergAllowed,
    this.ocoAllowed,
    this.quoteOrderQtyMarketAllowed,
    this.allowTrailingStop,
    this.cancelReplaceAllowed,
    this.isSpotTradingAllowed,
    this.isMarginTradingAllowed,
    this.filters = const [],
    this.permissions = const [],
  });

  String? symbol;
  String? status;
  String? baseAsset;
  int? baseAssetPrecision;
  String? quoteAsset;
  int? quotePrecision;
  int? quoteAssetPrecision;
  int? baseCommissionPrecision;
  int? quoteCommissionPrecision;
  List<String> orderTypes;
  bool? icebergAllowed;
  bool? ocoAllowed;
  bool? quoteOrderQtyMarketAllowed;
  bool? allowTrailingStop;
  bool? cancelReplaceAllowed;
  bool? isSpotTradingAllowed;
  bool? isMarginTradingAllowed;
  List<Filter> filters;
  List<String> permissions;

  factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
        symbol: json["symbol"],
        status: json["status"],
        baseAsset: json["baseAsset"],
        baseAssetPrecision: json["baseAssetPrecision"],
        quoteAsset: json["quoteAsset"],
        quotePrecision: json["quotePrecision"],
        quoteAssetPrecision: json["quoteAssetPrecision"],
        baseCommissionPrecision: json["baseCommissionPrecision"],
        quoteCommissionPrecision: json["quoteCommissionPrecision"],
        orderTypes: json["orderTypes"] == null
            ? []
            : List<String>.from(json["orderTypes"].map((x) => x)),
        icebergAllowed: json["icebergAllowed"],
        ocoAllowed: json["ocoAllowed"],
        quoteOrderQtyMarketAllowed: json["quoteOrderQtyMarketAllowed"],
        allowTrailingStop: json["allowTrailingStop"],
        cancelReplaceAllowed: json["cancelReplaceAllowed"],
        isSpotTradingAllowed: json["isSpotTradingAllowed"],
        isMarginTradingAllowed: json["isMarginTradingAllowed"],
        filters: json["filters"] == null
            ? []
            : List<Filter>.from(json["filters"].map((x) => Filter.fromJson(x))),
        permissions: json["permissions"] == null
            ? []
            : List<String>.from(json["permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "status": status,
        "baseAsset": baseAsset,
        "baseAssetPrecision": baseAssetPrecision,
        "quoteAsset": quoteAsset,
        "quotePrecision": quotePrecision,
        "quoteAssetPrecision": quoteAssetPrecision,
        "baseCommissionPrecision": baseCommissionPrecision,
        "quoteCommissionPrecision": quoteCommissionPrecision,
        "orderTypes": List<dynamic>.from(orderTypes.map((x) => x)),
        "icebergAllowed": icebergAllowed,
        "ocoAllowed": ocoAllowed,
        "quoteOrderQtyMarketAllowed": quoteOrderQtyMarketAllowed,
        "allowTrailingStop": allowTrailingStop,
        "cancelReplaceAllowed": cancelReplaceAllowed,
        "isSpotTradingAllowed": isSpotTradingAllowed,
        "isMarginTradingAllowed": isMarginTradingAllowed,
        "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
        "permissions": List<dynamic>.from(permissions.map((x) => x)),
      };
}

class Filter {
  Filter({
    this.filterType,
    this.minPrice,
    this.maxPrice,
    this.tickSize,
    this.multiplierUp,
    this.multiplierDown,
    this.avgPriceMins,
    this.minQty,
    this.maxQty,
    this.stepSize,
    this.minNotional,
    this.applyToMarket,
    this.limit,
    this.minTrailingAboveDelta,
    this.maxTrailingAboveDelta,
    this.minTrailingBelowDelta,
    this.maxTrailingBelowDelta,
    this.maxNumOrders,
    this.maxNumAlgoOrders,
    this.bidMultiplierUp,
    this.bidMultiplierDown,
    this.askMultiplierUp,
    this.askMultiplierDown,
    this.maxPosition,
  });

  String? filterType;
  String? minPrice;
  String? maxPrice;
  String? tickSize;
  String? multiplierUp;
  String? multiplierDown;
  int? avgPriceMins;
  String? minQty;
  String? maxQty;
  String? stepSize;
  String? minNotional;
  bool? applyToMarket;
  int? limit;
  int? minTrailingAboveDelta;
  int? maxTrailingAboveDelta;
  int? minTrailingBelowDelta;
  int? maxTrailingBelowDelta;
  int? maxNumOrders;
  int? maxNumAlgoOrders;
  String? bidMultiplierUp;
  String? bidMultiplierDown;
  String? askMultiplierUp;
  String? askMultiplierDown;
  String? maxPosition;

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        filterType: json["filterType"],
        minPrice: json["minPrice"],
        maxPrice: json["maxPrice"],
        tickSize: json["tickSize"],
        multiplierUp: json["multiplierUp"],
        multiplierDown: json["multiplierDown"],
        avgPriceMins: json["avgPriceMins"],
        minQty: json["minQty"],
        maxQty: json["maxQty"],
        stepSize: json["stepSize"],
        minNotional: json["minNotional"],
        applyToMarket: json["applyToMarket"],
        limit: json["limit"],
        minTrailingAboveDelta: json["minTrailingAboveDelta"],
        maxTrailingAboveDelta: json["maxTrailingAboveDelta"],
        minTrailingBelowDelta: json["minTrailingBelowDelta"],
        maxTrailingBelowDelta: json["maxTrailingBelowDelta"],
        maxNumOrders: json["maxNumOrders"],
        maxNumAlgoOrders: json["maxNumAlgoOrders"],
        bidMultiplierUp: json["bidMultiplierUp"],
        bidMultiplierDown: json["bidMultiplierDown"],
        askMultiplierUp: json["askMultiplierUp"],
        askMultiplierDown: json["askMultiplierDown"],
        maxPosition: json["maxPosition"],
      );

  Map<String, dynamic> toJson() => {
        "filterType": filterType,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
        "tickSize": tickSize,
        "multiplierUp": multiplierUp,
        "multiplierDown": multiplierDown,
        "avgPriceMins": avgPriceMins,
        "minQty": minQty,
        "maxQty": maxQty,
        "stepSize": stepSize,
        "minNotional": minNotional,
        "applyToMarket": applyToMarket,
        "limit": limit,
        "minTrailingAboveDelta": minTrailingAboveDelta,
        "maxTrailingAboveDelta": maxTrailingAboveDelta,
        "minTrailingBelowDelta": minTrailingBelowDelta,
        "maxTrailingBelowDelta": maxTrailingBelowDelta,
        "maxNumOrders": maxNumOrders,
        "maxNumAlgoOrders": maxNumAlgoOrders,
        "bidMultiplierUp": bidMultiplierUp,
        "bidMultiplierDown": bidMultiplierDown,
        "askMultiplierUp": askMultiplierUp,
        "askMultiplierDown": askMultiplierDown,
        "maxPosition": maxPosition,
      };
}
