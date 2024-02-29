import 'dart:math';

import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/trade_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/all_market_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/widget/chart_grid_item_widget.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/widget/chart_row_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';
import '../../../model/graph_color_model.dart';
import 'tradebot_history_screen.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({Key? key}) : super(key: key);

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  final TradeController _tradeController = Get.find();
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).padding;
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
          backgroundColor: AppColors.screenBGColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0.h), // here the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  centerTitle: true,
                  title: Text(
                    "Trade",
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        InkWell(
                          onTap:(){
                            Get.to(()=>TradeBotScreen());
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15.w,top: 9.h, bottom: 9.w),

                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color:AppColors.walletConBGColor,
                            ),
                            child: Image.asset(AppImage.icHistory,
                            ),
                          ),
                        )
                      ],
                    )
                  ],

                ),
              ],
            ),
          ),
          body: GetX<TradeController>(
            builder: (cont) {
              if (cont.error.value.errorType == ErrorType.internet) {
                return Container();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Balance",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: AppColors.lightTextColor,
                          ),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          "${AppString.currencySymbol} ${_userController.userResponseModel.value.user?.balance ?? "0"}",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "Top coins",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          AllMarketResponseModel allMarketData =
                              cont.allMarketResponseMap.values.toList()[index];

                          // return ChartGridItemWidget(
                          //   allMarketData: allMarketData,
                          //   graphcolors: _getColorsModel(),
                          // );
                          return ChartGridItemWidget(
                            allMarketData: allMarketData,
                            graphcolors: _tradeController.graphColors[index],
                          );
                        },
                        itemCount:
                            cont.allMarketResponseMap.values.toList().length,
                      ),
                    ),
                  ),

                  // Expanded(
                  //   child: ListView.builder(
                  //     padding: EdgeInsets.zero,
                  //     // physics: const NeverScrollableScrollPhysics(),
                  //     itemBuilder: (context, index) {
                  //       AllMarketResponseModel allMarketData =
                  //           cont.allMarketResponseMap.values.toList()[index];
                  //       return ChartRowItemWidget(
                  //         allMarketData: allMarketData,
                  //       );
                  //     },
                  //     itemCount: cont.allMarketResponseMap.values.toList().length,
                  //   ),
                  // ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // GraphColorsModel _getColorsModel() {
  //   int index = _random.nextInt(_tradeController.graphColors.length);
  //
  //   return _tradeController.graphColors[index];
  // }
}
