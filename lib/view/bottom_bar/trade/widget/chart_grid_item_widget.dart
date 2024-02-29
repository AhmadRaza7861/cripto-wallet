import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/trade_controller.dart';
import 'package:crypto_wallet/model/all_market_response_model.dart';
import 'package:crypto_wallet/model/market_symbol_price.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/util/common.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/coin_detail/coin_detail_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/coin_detail/widget/create_bot_bottom_sheet.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:crypto_wallet/model/exchage_info_response_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../model/graph_color_model.dart';
import '../../../common_widget/custom_fade_in_image.dart';

class ChartGridItemWidget extends StatefulWidget {
  AllMarketResponseModel allMarketData;
  GraphColorsModel graphcolors;
  ChartGridItemWidget({required this.allMarketData, required this.graphcolors});

  @override
  State<ChartGridItemWidget> createState() => _ChartGridItemWidgetState();
}

class _ChartGridItemWidgetState extends State<ChartGridItemWidget> {
  final TradeController _tradeController = Get.find();
  final HomeController _homeController = Get.find();
  List<ChartData>? _chartData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("allMarketData   ===  ${widget.allMarketData}");
    List<double> priceList =
        (_tradeController.marketChartDataMap["${widget.allMarketData.s}"] ??
            []);
    _chartData = [];
    for (int i = 0; i < priceList.length; i++) {
      _chartData!.add(ChartData(i.toDouble(), priceList[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    Symbol symbol =
        _homeController.symbolInfoResponseMap[widget.allMarketData.s ?? ""] ??
            Symbol();
    MarketSymbolPrice marketSymbolPrice = (_tradeController
            .getMarketSymbolPriceData(symbol: widget.allMarketData.s ?? "") ??
        MarketSymbolPrice());

    MarketSymbolPrice marketSymbolPreviousPrice =
        (_tradeController.getMarketSymbolPreviousPriceData(
                symbol: widget.allMarketData.s ?? "") ??
            MarketSymbolPrice());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() =>
                  CoinDetailScreen(coinSymbol: widget.allMarketData.s ?? "0",graphColors: widget.graphcolors,
                  ));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(10.r),topLeft: Radius.circular(10.r)),
                color: AppColors.gridBlue,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w,),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 24.w,
                              height: 24.w,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CustomFadeInImage(
                                  url: ApiUrl.getCryptoIconUrl(
                                      symbol: symbol.baseAsset ?? "")),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${symbol.baseAsset}/${symbol.quoteAsset}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                  color: AppColors.darkBlue,
                                  borderRadius: BorderRadius.circular(100.r)),
                              child: Text(
                                "${(double.tryParse(widget.allMarketData.p ?? "0") ?? 0).toStringAsFixed(2)}%",
                                style: TextStyle(
                                  color: isPositive(s: widget.allMarketData.p)
                                      ? widget.graphcolors.darkBoderColor
                                      : Colors.red,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                color:  widget.graphcolors.darkBoderColor,
                              ),
                              width: 3.w,
                              height: 35.h,
                            ),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  (double.tryParse(widget.allMarketData.allMarketResponseModelP ?? "0") ?? 0).toStringAsFixed(2),
                                  style: TextStyle(
                                    color:  widget.graphcolors.darkBoderColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                  ),
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  // minFontSize: 10.sp,
                                  // maxFontSize: 30.sp,
                                ),
                                SizedBox(height: 3.h),
                                AutoSizeText(
                                  "${(double.tryParse(marketSymbolPrice.price ?? "0") ?? 0)}",
                                  style: TextStyle(
                                    color: AppColors.lightTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                  ),
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  // minFontSize: 10.sp,
                                  // maxFontSize: 30.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 54.h,
                          decoration: BoxDecoration(),
                          child: (_tradeController.marketChartDataMap[
                                              "${widget.allMarketData.s}"] ??
                                          [])
                                      .length >
                                  10
                              ? SfCartesianChart(
                            onChartTouchInteractionDown: (tapArgs) {
                              return ;
                            },

                                  margin: EdgeInsets.zero,
                                  primaryXAxis: CategoryAxis(
                                      isVisible: false,
                                      majorGridLines:
                                          const MajorGridLines(width: 0)),
                                  primaryYAxis: CategoryAxis(isVisible: false),
                                  series: <ChartSeries>[
                                    SplineAreaSeries<ChartData, double>(

                                      borderWidth: 1.5,
                                      borderColor: widget.graphcolors.darkBoderColor,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          widget.graphcolors.darkColor,
                                          widget.graphcolors.lightColor,
                                        ],
                                      ),
                                      dataSource: _chartData!,
                                      cardinalSplineTension: 0.1,
                                      xValueMapper: (ChartData chart, double) =>
                                          chart.x,
                                      yValueMapper: (ChartData chart, double) =>
                                          chart.y,
                                    ),
                                  ],
                                  plotAreaBorderWidth: 0,
                                )
                              : const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),

                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Text(
                  //         "=${(double.tryParse(marketSymbolPrice.price ?? "0") ?? 0).toStringAsFixed(2)} USD",
                  //         style: TextStyle(
                  //           fontSize: 10.sp,
                  //         ),
                  //       ),
                  //       SizedBox(width: 5.w),
                  //       Text(
                  //         "${(double.tryParse(widget.allMarketData.allMarketResponseModelP ?? "0") ?? 0).toStringAsFixed(2)}  ${_homeController.symbolInfoResponseMap[widget.allMarketData.s]?.quoteAsset ?? ""}",
                  //         style: TextStyle(
                  //           fontSize: 10.sp,
                  //           color: isPositive(s: widget.allMarketData.p)
                  //               ? Colors.green
                  //               : Colors.red,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       // SizedBox(width: 5.w),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          InkWell(
          onTap: (){
          Get.bottomSheet(
            CreateBotBottomSheet(coinSymbol: widget.allMarketData.s??"0"),
            isScrollControlled: true,
          );
        },
            child: Container(
              height: 30.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r),bottomRight: Radius.circular(10.r)),
                color: AppColors.blueButton,
              ),
              child: Center(
                child: Text(
                  "Create bot",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChartData {
  double x;
  double y;

  ChartData(this.x, this.y);
}
