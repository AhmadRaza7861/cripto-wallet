import 'dart:convert';
import 'dart:developer';

import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/api/api_service.dart';
import 'package:crypto_wallet/controller/base_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/enum/chart_interval.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/chart_data_response_model.dart';
import 'package:crypto_wallet/model/specific_symbol_bid_ask_response_model.dart';
import 'package:crypto_wallet/model/trade_bot_info_model.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/coin_detail/widget/create_bot_success_dialog.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class CoinDetailController extends BaseController {
  Rx<SpecificSymbolBidsAskResponseModel> specificSymbolBidsAskResponseModel =
      SpecificSymbolBidsAskResponseModel().obs;
  IOWebSocketChannel? ioWebSocketCoinDepthChannel;
  IOWebSocketChannel? ioWebSocketCoinCandlestickChannel;
  RxList<ChartDataResponseModel> candleSeriesChartDataList =
      <ChartDataResponseModel>[].obs;
  Rx<ChartInterval> selectedChartInterval = ChartInterval.s1.obs;
  final UserController _userController = Get.find();

  void coinDepthConnect({required String symbol}) {
    ioWebSocketCoinDepthChannel = IOWebSocketChannel.connect(
        Uri.parse('${ApiUrl.socketBaseUrl}/${symbol.toLowerCase()}@depth10'));

    ioWebSocketCoinDepthChannel?.stream.listen((message) {
      logger("message ===>   $message");
      specificSymbolBidsAskResponseModel.value =
          specificSymbolBidsAskResponseModelFromJson(message);
    });
  }

  void coinCandlestickConnect({required String symbol}) {
    ioWebSocketCoinCandlestickChannel = IOWebSocketChannel.connect(Uri.parse(
        '${ApiUrl.socketBaseUrl}/${symbol.toLowerCase()}@kline_${selectedChartInterval.value.name}'));

    ioWebSocketCoinCandlestickChannel?.stream.listen((message) {
      logger("message ===>  4566 $message");
      Map<String, dynamic> data = jsonDecode(message);
      if (candleSeriesChartDataList.isNotEmpty) {
        if (!candleSeriesChartDataList.last.isClosedCandle) {
          candleSeriesChartDataList.removeLast();
        }
      }
      ChartDataResponseModel lastChartDataResponseModel =
          ChartDataResponseModel();
      ChartDataResponseModel currentChartDataResponseModel =
          ChartDataResponseModel.fromJsonMap(data["k"]);
      if (candleSeriesChartDataList.isNotEmpty) {
        lastChartDataResponseModel = candleSeriesChartDataList.last;
      }
      if (lastChartDataResponseModel.openTime ==
          currentChartDataResponseModel.openTime) {
        candleSeriesChartDataList.last;
      }
      candleSeriesChartDataList.add(currentChartDataResponseModel);
    });
  }

  void coinDepthDisconnect() {
    ioWebSocketCoinDepthChannel?.sink.close(status.goingAway);
  }

  void coinCandlestickDisconnect() {
    ioWebSocketCoinCandlestickChannel?.sink.close(status.goingAway);
  }

  Future<void> getChartData({required String symbol}) async {
    try {
      Map<String, dynamic> params = {};
      params["symbol"] = symbol;
      params["interval"] = selectedChartInterval.value.name;
      Uri uri = Uri(queryParameters: params);

      await apiService.getRequest(
          url: "${ApiUrl.getBSymbolChartData}?${uri.query}",
          onSuccess: (Map<String, dynamic> data) {
            List<ChartDataResponseModel> tempList =
                chartDataResponseModelFromJson(jsonEncode(data["response"]));
            // if (candleSeriesChartDataList.isEmpty) {
            candleSeriesChartDataList.addAll(tempList);
            // }
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: "$msg");
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> sendTradeBot(
      {required String coinAmount,
      required TradeBotInfoModel tradeBotInfoModel,
      required String coinSymbol}) async {
    try {
      Map<String, dynamic> params = {};
      params["duration"] = tradeBotInfoModel.duration;
      params["coin"] = coinSymbol;
      params["amount"] = coinAmount;
      Uri uri = Uri(queryParameters: params);
      showLoader();

      await apiService.postRequest(
          url: ApiUrl.sendTradeBot,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            // await _userController.getUserInfo(isScreenChange: false);
            Get.back();
            logger("message   ===>   ${data}");
            // showSnack(msg: data["response"]["message"]);
            Get.dialog(CreateBotSuccessDialog(tradeBotInfoModel: tradeBotInfoModel));
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: "$msg");
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }
}
