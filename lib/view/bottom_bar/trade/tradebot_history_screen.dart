import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/wallet_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/tradebot_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/widget/trade_bot_info_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common_widget/api_status_manage_widget.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/custom_fade_in_image.dart';
import 'package:crypto_wallet/model/exchage_info_response_model.dart';

class TradeBotScreen extends StatefulWidget {
  const TradeBotScreen({Key? key}) : super(key: key);

  @override
  State<TradeBotScreen> createState() => _TradeBotScreenState();
}

class _TradeBotScreenState extends State<TradeBotScreen> {
  final WalletController _walletController = Get.find();
  final HomeController _homeController = Get.find();

  // final UserController _userController = Get.find();
  // final String tokenizationKey = 'sandbox_8hxpnkht_kzdtzv2btm4p7s5j';
  // final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _walletController.getTradeBotList();
    });
  }

  final DateFormat _dateFormat = DateFormat("MMMM dd,yyyy 'at' hh:mm aa");
  final DateTime _nowDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(18.w),
                      child: Image.asset(
                        AppImage.icLeftArrow,
                        height: 16.5.h,
                        width: 9.w,
                        color: AppColors.walletTextColor,
                      ),
                    ),
                  ),
                  title: Text(
                    "Tradebot",
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: GetX<WalletController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return Container();
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApiStatusManageWidget(
                    customNoDataFound: _customNoDataFound(),
                    height: 300.h,
                    apiStatus: cont.tradebotList.value,
                    child: Column(
                      children: [
                        ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            shrinkWrap: true,
                            itemCount: cont.tradebotList.value.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              TradebotModel tradeBotModel =
                                  cont.tradebotList.value.data[index];
                              Symbol symbol =
                                  _homeController.symbolInfoResponseMap[
                                          tradeBotModel.coin] ??
                                      Symbol();
                              return InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                      TradeBotHistoryInfoBottomsheet(
                                          tradebotModel: tradeBotModel),
                                      isScrollControlled: true);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.withDrawBorderColor),
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: AppColors.liteGraylist),
                                  margin: EdgeInsets.symmetric(vertical: 5.h),
                                  padding: EdgeInsets.all(12.w),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        padding: EdgeInsets.all(9.w),
                                        decoration: BoxDecoration(
                                            // color: AppColors.iconBGBlue,
                                            borderRadius:
                                                BorderRadius.circular(12.r)
                                            // shape: BoxShape.circle,
                                            ),
                                        child: CustomFadeInImage(
                                          url: ApiUrl.getCryptoIconUrl(
                                              symbol: symbol.baseAsset ?? ""),
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cont.tradebotList.value
                                                      .data[index].coin ??
                                                  "",
                                              style: TextStyle(
                                                color:
                                                    AppColors.walletTextColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              maxLines: 1,
                                              _dateFormat.format(cont
                                                      .tradebotList
                                                      .value
                                                      .data[index]
                                                      .createdAt ??
                                                  _nowDateTime),
                                              style: TextStyle(
                                                color: AppColors
                                                    .walletSubTextColor,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Text(
                                        cont.tradebotList.value.data[index]
                                                .amount ??
                                            "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          color: double.parse(cont
                                                          .tradebotList
                                                          .value
                                                          .data[index]
                                                          .amount ??
                                                      "0") >
                                                  0
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: CustomButton(
                            borderRadius: 10.r,
                            title: "Create New Trade",
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _customNoDataFound() {
    return Container(
      width: 1.sw,
      height: 0.8.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            AppImage.icNoTrade,
            width: 150.w,
          ),
          SizedBox(height: 10.h),
          Text(
            "Uh on! \n No trades created yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.gray,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              fontFamily: "",
            ),
          ),
          SizedBox(height: 100.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CustomButton(
              borderRadius: 10.r,
              title: "Create New Trade",
              onTap: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
