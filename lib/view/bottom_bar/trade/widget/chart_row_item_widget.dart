// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:crypto_wallet/api/api.dart';
// import 'package:crypto_wallet/controller/home_controller.dart';
// import 'package:crypto_wallet/controller/trade_controller.dart';
// import 'package:crypto_wallet/model/all_market_response_model.dart';
// import 'package:crypto_wallet/model/market_symbol_price.dart';
// import 'package:crypto_wallet/util/app_constant.dart';
// import 'package:crypto_wallet/util/common.dart';
// import 'package:crypto_wallet/view/bottom_bar/trade/coin_detail/coin_detail_screen.dart';
// import 'package:crypto_wallet/view/bottom_bar/trade/coin_detail/widget/create_bot_bottom_sheet.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:crypto_wallet/model/exchage_info_response_model.dart';
//
// import '../../../common_widget/custom_fade_in_image.dart';
//
// class ChartRowItemWidget extends StatefulWidget {
//   AllMarketResponseModel allMarketData;
//
//   ChartRowItemWidget({required this.allMarketData});
//
//   @override
//   State<ChartRowItemWidget> createState() => _ChartRowItemWidgetState();
// }
//
// class _ChartRowItemWidgetState extends State<ChartRowItemWidget> {
//   final TradeController _tradeController = Get.find();
//   final HomeController _homeController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     Symbol symbol =
//         _homeController.symbolInfoResponseMap[widget.allMarketData.s ?? ""] ??
//             Symbol();
//     MarketSymbolPrice marketSymbolPrice = (_tradeController
//             .getMarketSymbolPriceData(symbol: widget.allMarketData.s ?? "") ??
//         MarketSymbolPrice());
//
//     MarketSymbolPrice marketSymbolPreviousPrice =
//         (_tradeController.getMarketSymbolPreviousPriceData(
//                 symbol: widget.allMarketData.s ?? "") ??
//             MarketSymbolPrice());
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
//       child: InkWell(
//         onTap: () {
//           Get.to(
//               () => CoinDetailScreen(coinSymbol: widget.allMarketData.s ?? "0"));
//         },
//         child: Container(
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.r),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.7),
//                       spreadRadius: 0.2.r,
//                       blurRadius: 1.r,
//                       offset: const Offset(0.5, 1),
//                     ),
//                   ],
//                   // border: Border.all(color: AppColors.primaryColor,width: 1.w),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 30.w,
//                           height: 30.w,
//                           clipBehavior: Clip.antiAlias,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                           ),
//                           child: CustomFadeInImage(
//                               url: ApiUrl.getCryptoIconUrl(
//                                   symbol: symbol.baseAsset ?? "")),
//                         ),
//                         SizedBox(width: 5.w),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               "${symbol.baseAsset}/",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Text(
//                               "${symbol.quoteAsset}",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10.sp,
//                                 // fontWeight: FontWeight.w500
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           height: 35.h,
//                           width: 0.3.sw,
//                           clipBehavior: Clip.antiAlias,
//                           margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(5),
//                             ),
//                             color: Colors.white,
//                             // boxShadow: [
//                             //   BoxShadow(
//                             //     color: (isPositive(s: widget.allMarketData.p)
//                             //             ? Colors.green
//                             //             : Colors.red)
//                             //         .withOpacity(0.15),
//                             //     blurRadius: 3,
//                             //   )
//                             // ],
//                           ),
//                           child: Container(
//                             padding:
//                                 EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                             ),
//                             child: (_tradeController.marketChartDataMap[
//                                                 "${widget.allMarketData.s}"] ??
//                                             [])
//                                         .length >
//                                     10
//                                 ? LineChart(
//                                     mainData(),
//                                     swapAnimationDuration:
//                                         const Duration(milliseconds: 0),
//                                   )
//                                 : const Center(child: CircularProgressIndicator()),
//                           ),
//                         ),
//                         SizedBox(width: 10.w),
//                         Expanded(
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Expanded(
//                                 child: AutoSizeText(
//                                   (double.tryParse(marketSymbolPrice.price ?? "0") ?? 0)
//                                       .toStringAsFixed(2),
//                                   style: TextStyle(
//                                     color: isPriceGraterThen(
//                                       s1: marketSymbolPrice.price,
//                                       s2: marketSymbolPreviousPrice.price,
//                                     )
//                                         ? Colors.green
//                                         : Colors.red,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 30.sp,
//                                   ),
//                                   textAlign: TextAlign.end,
//                                   maxLines: 1,
//                                   // minFontSize: 10.sp,
//                                   // maxFontSize: 30.sp,
//                                 ),
//                               ),
//                               SizedBox(width: 5.w),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: 5.h,
//                                   horizontal: 10.w,
//                                 ),
//                                 clipBehavior: Clip.antiAlias,
//                                 decoration: BoxDecoration(
//                                     color: (isPositive(s: widget.allMarketData.p)
//                                             ? Colors.green
//                                             : Colors.red)
//                                         .withOpacity(0.3),
//                                     borderRadius: BorderRadius.circular(8.r)),
//                                 child: Text(
//                                   "${(double.tryParse(widget.allMarketData.p ?? "0") ?? 0).toStringAsFixed(2)}%",
//                                   style: TextStyle(
//                                     color: isPositive(s: widget.allMarketData.p)
//                                         ? Colors.green
//                                         : Colors.red,
//                                     fontSize: 10.sp,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "=${(double.tryParse(marketSymbolPrice.price ?? "0") ?? 0).toStringAsFixed(2)} USD",
//                             style: TextStyle(
//                               fontSize: 10.sp,
//                             ),
//                           ),
//                           SizedBox(width: 5.w),
//                           Text(
//                             "${(double.tryParse(widget.allMarketData.allMarketResponseModelP ?? "0") ?? 0).toStringAsFixed(2)}  ${_homeController.symbolInfoResponseMap[widget.allMarketData.s]?.quoteAsset ?? ""}",
//                             style: TextStyle(
//                               fontSize: 10.sp,
//                               color: isPositive(s: widget.allMarketData.p)
//                                   ? Colors.green
//                                   : Colors.red,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           // SizedBox(width: 5.w),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: InkWell(
//                   onTap: (){
//                     Get.bottomSheet(
//                       CreateBotBottomSheet(coinSymbol: widget.allMarketData.s??"0"),
//                       isScrollControlled: true,
//                     );
//                   },
//                   child: Container(
//                     width: 1.sw,
//                     alignment: Alignment.center,
//                     padding: EdgeInsets.symmetric(horizontal: 10.h,vertical: 10.h),
//                     decoration: BoxDecoration(
//                         color: Color(0xff073152),
//                     ),
//                     child: Text(
//                       "Create Bot",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Color(0xff68737d),
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     );
//     Widget text;
//     switch (value.toInt()) {
//       case 2:
//         text = const Text('MAR', style: style);
//         break;
//       case 5:
//         text = const Text('JUN', style: style);
//         break;
//       case 8:
//         text = const Text('SEP', style: style);
//         break;
//       default:
//         text = const Text('', style: style);
//         break;
//     }
//
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 8.0,
//       child: text,
//     );
//   }
//
//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Color(0xff67727d),
//       fontWeight: FontWeight.bold,
//       fontSize: 15,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 1:
//         text = '10K';
//         break;
//       case 3:
//         text = '30k';
//         break;
//       case 5:
//         text = '50k';
//         break;
//       default:
//         return Container();
//     }
//
//     return Text(text, style: style, textAlign: TextAlign.left);
//   }
//
//   LineChartData mainData() {
//     List<FlSpot> flSpotList = [];
//     List<double> priceList =
//         (_tradeController.marketChartDataMap["${widget.allMarketData.s}"] ??
//             []);
//     for (int i = 0; i < priceList.length; i++) {
//       flSpotList.add(FlSpot(i.toDouble(), priceList[i]));
//     }
//     if (flSpotList.isEmpty) {
//       flSpotList.add(const FlSpot(0, 1));
//       flSpotList.add(const FlSpot(1, 2));
//       flSpotList.add(const FlSpot(2, 1.5));
//     }
//
//     return LineChartData(
//       lineTouchData: LineTouchData(enabled: false),
//       gridData: FlGridData(
//         show: false,
//         drawVerticalLine: true,
//         horizontalInterval: 1,
//         verticalInterval: 1,
//         // getDrawingHorizontalLine: (value) {
//         //   return FlLine(
//         //     color: const Color(0xff37434d),
//         //     strokeWidth: 1,
//         //   );
//         // },
//         // getDrawingVerticalLine: (value) {
//         //   return FlLine(
//         //     color: const Color(0xff37434d),
//         //     strokeWidth: 1,
//         //   );
//         // },
//       ),
//       titlesData: FlTitlesData(
//         show: false,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//             reservedSize: 30,
//             interval: 1,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//             interval: 1,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: false,
//         border: Border.all(
//           color: const Color(0xff37434d),
//           width: 1,
//         ),
//       ),
//       lineBarsData: [
//         LineChartBarData(
//           spots: flSpotList,
//           isCurved: true,
//           // gradient: LinearGradient(
//           //   colors: gradientColors,
//           //   begin: Alignment.centerLeft,
//           //   end: Alignment.centerRight,
//           // ),
//           color: isPositive(s: widget.allMarketData.p)
//               ? AppColors.greenColor
//               : AppColors.closeWordColor,
//           barWidth: 1,
//           isStrokeCapRound: false,
//           dotData: FlDotData(
//             show: false,
//           ),
//           // belowBarData: BarAreaData(
//           //   show: true,
//           //   gradient: LinearGradient(
//           //     colors: gradientColors
//           //         .map((color) => color.withOpacity(0.3))
//           //         .toList(),
//           //     begin: Alignment.centerLeft,
//           //     end: Alignment.centerRight,
//           //   ),
//           // ),
//         ),
//       ],
//     );
//   }
// }
