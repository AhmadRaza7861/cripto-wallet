import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:ui';

import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/api/api_service.dart';
import 'package:crypto_wallet/controller/base_controller.dart';
import 'package:crypto_wallet/controller/trade_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/all_market_response_model.dart';
import 'package:crypto_wallet/model/chart_data_response_model.dart';
import 'package:crypto_wallet/model/market_symbol_price.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../model/graph_color_model.dart';
import '../util/app_constant.dart';





class TradeController extends BaseController {
  // RxList<AllMarketResponseModel> allMarketResponseList =
  //     <AllMarketResponseModel>[].obs;
  RxMap<String, AllMarketResponseModel> allMarketResponseMap =
      <String, AllMarketResponseModel>{}.obs;
  IOWebSocketChannel? ioWebSocketAllMarketChannel;
  RxMap<String, MarketSymbolPrice> marketSymbolPriceMap =
      <String, MarketSymbolPrice>{}.obs;
  RxMap<String, MarketSymbolPrice> marketSymbolPreviousPriceMap =
      <String, MarketSymbolPrice>{}.obs;

  RxMap<String, List<double>> marketChartDataMap = <String, List<double>>{}.obs;
  Map<String, String> cryptoImageUrlMap = {};
  List<GraphColorsModel> graphColors = [];


  @override
  void onReady() {
    super.onReady();
    cryptoImageUrlMap["BTCUSDT"] = AppImage.icBitCoin;
    cryptoImageUrlMap["ETHUSDT"] = AppImage.icEthereum;
    cryptoImageUrlMap["APTUSDT"] = AppImage.icEthereum;
    cryptoImageUrlMap["SOLUSDT"] = AppImage.icBitCoin;
    cryptoImageUrlMap["BNBUSDT"] = AppImage.icBitCoin;
    // cryptoImageUrlMap["USDCUSDT"] = AppImage.icBitCoin;
    // cryptoImageUrlMap["XRCUSDT"] = AppImage.icBitCoin;
    cryptoImageUrlMap["BUSDUSDT"] = AppImage.icBitCoin;
    cryptoImageUrlMap["ADAUSDT"] = AppImage.icBitCoin;
    cryptoImageUrlMap["DOGEUSDT"] = AppImage.icBitCoin;
    cryptoImageUrlMap["MATICUSDT"] = AppImage.icBitCoin;
    // cryptoImageUrlMap["USDTUSDT"] = AppImage.icBitCoin;
    getAllMarketData();
    graphColors.add(GraphColorsModel(
      darkColor: AppColors.cyanDarkChart ,
      lightColor:AppColors.cyanLightChart ,
      darkBoderColor:AppColors.cyanBoderChart,));

    graphColors.add(GraphColorsModel(
      darkColor: AppColors.greenDarkChart ,
      lightColor:AppColors.greenLightChart,
      darkBoderColor:AppColors.greenBoderChart,));

    graphColors.add(GraphColorsModel(
      darkColor: AppColors.orangeDarkChart ,
      lightColor:AppColors.orangeBoderChart ,
      darkBoderColor:AppColors.orangeBoderChart,));

    graphColors.add(GraphColorsModel(
      darkColor: AppColors.pinkDarkChart ,
      lightColor:AppColors.pinkLightChart ,
      darkBoderColor:AppColors.pinkBoderChart,));


    graphColors.add(GraphColorsModel(
      darkColor: AppColors.cyanDarkChart ,
      lightColor:AppColors.cyanLightChart ,
      darkBoderColor:AppColors.cyanBoderChart,));

    graphColors.add(GraphColorsModel(
      darkColor: AppColors.greenDarkChart ,
      lightColor:AppColors.greenLightChart,
      darkBoderColor:AppColors.greenBoderChart,));

    graphColors.add(GraphColorsModel(
      darkColor: AppColors.orangeDarkChart ,
      lightColor:AppColors.orangeBoderChart ,
      darkBoderColor:AppColors.orangeBoderChart,));

    graphColors.add(GraphColorsModel(
      darkColor: AppColors.pinkDarkChart ,
      lightColor:AppColors.pinkLightChart ,
      darkBoderColor:AppColors.pinkBoderChart,));

    graphColors.add(GraphColorsModel(
      darkColor: AppColors.greenDarkChart ,
      lightColor:AppColors.greenLightChart,
      darkBoderColor:AppColors.greenBoderChart,));
  }

  void getAllMarketData() {
    ioWebSocketAllMarketChannel = IOWebSocketChannel.connect(
        Uri.parse('${ApiUrl.socketBaseUrl}/!ticker@arr'),
    );
    bool isFirstTime = true;
    ioWebSocketAllMarketChannel?.stream.listen((message) {
      getBSymbolPrice();
      bool isNotEmptyMarketData = allMarketResponseMap.isNotEmpty;
      List<AllMarketResponseModel> tempList =
          allMarketResponseModelFromJson(message);
      // if (isNotEmptyMarketData) {
      //   allPreviousMarketResponseMap.addAll(allMarketResponseMap);
      // }
      for (var element in tempList) {
        if (cryptoImageUrlMap.keys.contains(element.s)) {
          allMarketResponseMap["${element.s}"] = element;
          if (isFirstTime) {
            getBSymbolChartData(symbol: element.s ?? "");
          }
        }
      }
      isFirstTime = false;
      // if (!isNotEmptyMarketData) {
      //   allPreviousMarketResponseMap.addAll(allMarketResponseMap);
      // }
    });
  }

  void getBSymbolPrice() {
    try {
      Map<String, dynamic> params = {};
      params["symbols"] =
          jsonEncode(List<dynamic>.from(cryptoImageUrlMap.keys.map((x) => x)));

      Uri uri = Uri(queryParameters: params);
      apiService.getRequest(
          url: "${ApiUrl.getBSymbolPrice}?${uri.query}",
          onSuccess: ((Map<String, dynamic> data) {
            List<MarketSymbolPrice> tempList =
                marketSymbolPriceFromJson(jsonEncode(data["response"]));
            for (var element in tempList) {
              marketSymbolPreviousPriceMap["${element.symbol}"] =
                  marketSymbolPriceMap["${element.symbol}"] ??
                      MarketSymbolPrice();
              marketSymbolPriceMap["${element.symbol}"] = element;
              List<double> priceList =
                  marketChartDataMap["${element.symbol}"] ?? [];
              double price = double.tryParse(element.price ?? "0") ?? 0;
              if (priceList.length > 150) {
                priceList.removeAt(0);
              }
              if (priceList.isEmpty) {
                double highPrice = price + 10;
                double lowPrice = price - 10;
                Random rng = Random();
                for (int i = 0; i < 149; i++) {
                  priceList.add(lowPrice +
                      rng.nextInt(highPrice.toInt() - lowPrice.toInt()));
                }
              }
              priceList.add(price);
              marketChartDataMap["${element.symbol}"] = priceList;
            }
          }),
          onError: (ErrorType errorType, String? msg) {
            showError(msg: "$msg");
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> getBSymbolChartData(
      {required String symbol, String interval = "1s"}) async {
    try {
      Map<String, dynamic> params = {};
      params["symbol"] = symbol;
      params["interval"] = interval;
      params["limit"] = "150";
      Uri uri = Uri(queryParameters: params);

      await apiService.getRequest(
          url: "${ApiUrl.getBSymbolChartData}?${uri.query}",
          onSuccess: (Map<String, dynamic> data) {
            List<ChartDataResponseModel> tempList =
                chartDataResponseModelFromJson(jsonEncode(data["response"]));
            List<double> priceList = [];
            for (var value in tempList) {
              priceList.add(value.closePrice ?? 0);
            }
            marketChartDataMap[symbol] = priceList;
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: "$msg");
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  MarketSymbolPrice? getMarketSymbolPriceData({required String symbol}) {
    return marketSymbolPriceMap[symbol];
  }

  MarketSymbolPrice? getMarketSymbolPreviousPriceData(
      {required String symbol}) {
    return marketSymbolPreviousPriceMap[symbol];
  }

  @override
  void dispose() {
    super.dispose();
    ioWebSocketAllMarketChannel?.sink.close(status.goingAway);
  }
}

