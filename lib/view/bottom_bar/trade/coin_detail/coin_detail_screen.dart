import 'dart:io';

import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/controller/coin_detail_controller.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/trade_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/all_market_response_model.dart';
import 'package:crypto_wallet/model/market_symbol_price.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/util/common.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/coin_detail/widget/chart_full_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/coin_detail/widget/create_bot_bottom_sheet.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:crypto_wallet/model/exchage_info_response_model.dart';

import '../../../../model/graph_color_model.dart';

class CoinDetailScreen extends StatefulWidget {
  String coinSymbol;
  GraphColorsModel graphColors;

  CoinDetailScreen({required this.coinSymbol,required this.graphColors});

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  final CoinDetailController _coinDetailController = Get.find();
  bool _isShowChart = true;
  WebViewController? _webViewController;
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _coinDetailController.coinDepthConnect(symbol: widget.coinSymbol);
      _coinDetailController.candleSeriesChartDataList.clear();
      // await _coinDetailController.getChartData(symbol: widget.coinSymbol);
      // _coinDetailController.coinCandlestickConnect(symbol: widget.coinSymbol);
      // _isShowChart = true;
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    print("object ===>  ${_size.width}    ${_size.height}");
    Symbol symbol =
        _homeController.symbolInfoResponseMap[widget.coinSymbol ?? ""] ??
            Symbol();

    return Stack(
      children: [
        Container(
          height: 1.sh,
          width: 1.sw,
          child: Image.asset(
            AppImage.imgBg,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor:AppColors.screenBGColor,
          appBar:AppBar(
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.all(19.w),
                child: Image.asset(
                  AppImage.icLeftArrow,
                  color: AppColors.appBarTitelColor,

                ),
              ),
            ),
            title: Text(
              "${symbol.baseAsset}/${symbol.quoteAsset}",
              style: TextStyle(
                color: AppColors.appBarTitelColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Image.asset(
                  AppImage.icCoinMenu,
                  color: AppColors.appBarTitelColor,
                ),
              ),
            ],
          ),

          body: GetX<TradeController>(builder: (tradeCont) {
            if (tradeCont.error.value.errorType == ErrorType.internet) {
              return Container();
            }
            AllMarketResponseModel allMarketResponseModel =
                (tradeCont.allMarketResponseMap[widget.coinSymbol] ??
                    AllMarketResponseModel());
            MarketSymbolPrice marketSymbolPrice =
                (tradeCont.getMarketSymbolPriceData(
                        symbol: widget.coinSymbol ?? "") ??
                    MarketSymbolPrice());
            MarketSymbolPrice marketSymbolPreviousPrice =
                (tradeCont.getMarketSymbolPreviousPriceData(
                        symbol: widget.coinSymbol ?? "") ??
                    MarketSymbolPrice());
            return GetX<CoinDetailController>(builder: (cont) {
              if (cont.error.value.errorType == ErrorType.internet) {
                return Container();
              }
              double totalBid = 0;
              double totalAsk = 0;
              for (var value1
                  in cont.specificSymbolBidsAskResponseModel.value.bids) {
                double bidPrice = double.tryParse(value1[1] ?? "0") ?? 0;
                totalBid = totalBid + bidPrice;
              }
              for (var value1
                  in cont.specificSymbolBidsAskResponseModel.value.asks) {
                double askPrice = double.tryParse(value1[1] ?? "0") ?? 0;
                totalAsk = totalAsk + askPrice;
              }
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 255.w,
                            padding: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 15.w),
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: AppColors.walletConBGColor,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.lightGray10,
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      padding: EdgeInsets.all(10.w) ,
                                      child: CustomFadeInImage(
                                          url: ApiUrl.getCryptoIconUrl(
                                              symbol: symbol.baseAsset ?? "")),
                                      width: 44.w,
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                SizedBox(height: 13.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100.r),
                                        color: widget.graphColors.darkBoderColor
                                      ),
                                      width: 3.w,
                                      height: 35.h,
                                    ),
                                    SizedBox(width: 10.w,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("${(double.tryParse(marketSymbolPrice.price ?? "0") ?? 0)}" ,
                                              style: TextStyle(
                                                fontSize: 24.sp,
                                                color:widget.graphColors.darkBoderColor ,
                                                // color: isPriceGraterThen(
                                                //   s1: marketSymbolPrice.price,
                                                //   s2: marketSymbolPreviousPrice.price,
                                                // )
                                                //     ? Colors.green
                                                //     : Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2.h),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${(double.tryParse(marketSymbolPrice.price ?? "0") ?? 0).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color:AppColors.tradeTextColor,
                                              ),
                                            ),
                                            SizedBox(width: 5.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5.h,
                                                horizontal: 10.w,
                                              ),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  color: AppColors.darkBlue,
                                                  borderRadius:
                                                  BorderRadius.circular(4.r)),
                                              child: Text(
                                                "${(double.tryParse(allMarketResponseModel.p ?? "0") ?? 0).toStringAsFixed(2)}%",
                                                style: TextStyle(
                                                  color:widget.graphColors.darkBoderColor,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            )

                                            // Text(
                                            //   "${(double.tryParse(allMarketResponseModel.allMarketResponseModelP ?? "0") ?? 0).toStringAsFixed(2)}  ${_homeController.symbolInfoResponseMap[widget.coinSymbol]?.quoteAsset ?? ""}",
                                            //   style: TextStyle(
                                            //     fontSize: 10.sp,
                                            //     color: isPositive(
                                            //         s: allMarketResponseModel.p)
                                            //         ? Colors.green
                                            //         : Colors.red,
                                            //     fontWeight: FontWeight.w500,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h,),
                          Container(
                            width: 1.sw,
                            padding:EdgeInsets.symmetric(vertical: 15.w),
                            decoration: BoxDecoration(
                                color: AppColors.walletConBGColor,
                                ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.h, horizontal: 7.w),
                                    decoration: BoxDecoration(
                                        color: AppColors.coinDetailConBGColor,
                                        borderRadius: BorderRadius.circular(4.r)),
                                    child: Text(
                                      "24H High: ${stringPricePrefix(s: allMarketResponseModel.h)}",
                                      style: TextStyle(
                                        color: AppColors.textfieldTextColor,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.h, horizontal: 7.w),
                                    decoration: BoxDecoration(
                                        color: AppColors.coinDetailConBGColor,
                                        borderRadius: BorderRadius.circular(4.r)),
                                    child: Text(
                                      "24H Low: ${stringPricePrefix(s: allMarketResponseModel.allMarketResponseModelL)}",
                                      style: TextStyle(
                                        color: AppColors.textfieldTextColor,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.h, horizontal: 7.w),
                                    decoration: BoxDecoration(
                                        color: AppColors.coinDetailConBGColor,
                                        borderRadius: BorderRadius.circular(4.r)),
                                    child: Text(
                                      "24H Vol: ${stringPricePrefix(s: allMarketResponseModel.v)}",
                                      style: TextStyle(
                                        color: AppColors.textfieldTextColor,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ), if (_isShowChart) ...[
                            // SizedBox(height: _size.height*0.6, child:  ChartWidget(coinSymbol: widget.coinSymbol)),
                            SizedBox(
                              height: _size.height * 0.7,
                              child: Stack(
                                children: [
                                  WebView(
                                    onWebViewCreated:
                                        (WebViewController? webViewController) {
                                      _webViewController = webViewController;
                                      _webViewController?.loadUrl(
                                          "${ApiUrl.graphUrl}/${widget.coinSymbol}",
                                          headers: {"Authorization": ""});
                                    },
                                    onPageFinished: (String url) {
                                      // _webViewController?.evaluateJavascript('document.body.style.overflow = \'hidden\';');
                                    },
                                    initialUrl:
                                        "${ApiUrl.graphUrl}/${widget.coinSymbol}",
                                    debuggingEnabled: true,
                                    gestureNavigationEnabled: true,
                                    javascriptMode: JavascriptMode.unrestricted,
                                    // gestureNavigationEnabled: true,
                                    // backgroundColor: Colors.red,
                                    onPageStarted: (s) {
                                      print("object ===>   $s");
                                    },
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => ChartFullScreen(
                                            coinSymbol: widget.coinSymbol,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(7.w),
                                        margin: EdgeInsets.only(right: 10.w),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.zoom_out_map,
                                          color: Colors.white,
                                          size: 18.w,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                          Container(
                            color: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "BID",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Price(USDT)",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "ASK(BTC)",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          List<String> stringList = cont
                                              .specificSymbolBidsAskResponseModel
                                              .value
                                              .bids[index];
                                          return Container(
                                            height: 13.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(),
                                            child: Stack(
                                              children: [
                                                FAProgressBar(
                                                  currentValue: 100 -
                                                      ((((double.tryParse(stringList[
                                                                          1] ??
                                                                      "0") ??
                                                                  0) *
                                                              100) /
                                                          totalBid)),
                                                  displayText: '%',
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.r),
                                                  backgroundColor: Colors.green
                                                      .withOpacity(0.5),
                                                  progressColor:
                                                      AppColors.primaryColor,
                                                  displayTextStyle:
                                                      const TextStyle(
                                                          color: Colors
                                                              .transparent),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        stringList[1],
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        (double.tryParse(
                                                                    stringList[
                                                                            0] ??
                                                                        "0") ??
                                                                0)
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: AppColors
                                                              .greenColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount: cont
                                            .specificSymbolBidsAskResponseModel
                                            .value
                                            .bids
                                            .length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          List<String> stringList = cont
                                              .specificSymbolBidsAskResponseModel
                                              .value
                                              .asks[index];
                                          return Container(
                                            height: 13.w,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            decoration: BoxDecoration(),
                                            child: Stack(
                                              children: [
                                                FAProgressBar(
                                                  currentValue: ((((double.tryParse(
                                                                  stringList[
                                                                          1] ??
                                                                      "0") ??
                                                              0) *
                                                          100) /
                                                      totalAsk)),
                                                  displayText: '%',
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.r),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  progressColor: AppColors
                                                      .closeWordColor
                                                      .withOpacity(0.5),
                                                  displayTextStyle:
                                                      const TextStyle(
                                                          color: Colors
                                                              .transparent),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        (double.tryParse(
                                                                    stringList[
                                                                            0] ??
                                                                        "0") ??
                                                                0)
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: AppColors
                                                              .closeWordColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        stringList[1],
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount: cont
                                            .specificSymbolBidsAskResponseModel
                                            .value
                                            .asks
                                            .length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 20.w,
                    ),
                    child: CustomButton(
                      title: "Create Bot",
                      borderRadius: 8.r,
                      onTap: () {
                        Get.bottomSheet(
                          CreateBotBottomSheet(coinSymbol: widget.coinSymbol),
                          isScrollControlled: true,
                        );
                      },
                    ),
                  ),
                ],
              );
            });
          }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _coinDetailController.coinDepthDisconnect();
    _coinDetailController.coinCandlestickDisconnect();
  }
}
