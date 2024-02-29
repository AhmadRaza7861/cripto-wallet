import 'package:crypto_wallet/controller/coin_detail_controller.dart';
import 'package:crypto_wallet/model/trade_bot_info_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/coin_detail/widget/create_bot_success_dialog.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateBotBottomSheet extends StatefulWidget {
  String coinSymbol;

  CreateBotBottomSheet({required this.coinSymbol});

  @override
  State<CreateBotBottomSheet> createState() => _CreateBotBottomSheetState();
}

class _CreateBotBottomSheetState extends State<CreateBotBottomSheet> {
  final List<TradeBotInfoModel> _tradeDayList = [];
  TradeBotInfoModel _selectedTradeDay = TradeBotInfoModel(
      duration: "7D",
      gridProfit: "0.89% (APY 46.56%)",
      maximumDropDown: "-4.66",
      volatility: "61.94",
      priceRange: "1427.24-1855.46",
      profitPerGrid: "0.12%~0.19% (104 Grids)",
  durationBetween: "7-20D"
  );
  final TextEditingController _coinTextEditingController =
      TextEditingController();
  final CoinDetailController _coinDetailController = Get.find();
  final GlobalKey _appBarKey = GlobalKey();
  double _appBarSize = 0;

  @override
  void initState() {
    super.initState();
    _tradeDayList.add(TradeBotInfoModel(
        duration: "1D",
        gridProfit: "0.1%-1%",
        maximumDropDown: "-5% to -1",
        volatility: "50-100",
        priceRange: "1200-2000",
        profitPerGrid: "0.01%-0.1%",
        durationBetween: "1 day"
    ));
    _tradeDayList.add(TradeBotInfoModel(
        duration: "3D",
        gridProfit: "0.3%(APY 23.46%)",
        maximumDropDown: "-3.3",
        volatility: "36.59",
        priceRange: "1227.24-1555.46",
        profitPerGrid: "0.07%-0.13% ( 104 Grid)",
        durationBetween: "3-7D"
    ));
    _tradeDayList.add(TradeBotInfoModel(
        duration: "7D",
        gridProfit: "0.89% (APY 46.56%)",
        maximumDropDown: "-4.66",
        volatility: "61.94",
        priceRange: "1427.24-1855.46",
        profitPerGrid: "0.12%~0.19% (104 Grids)",
        durationBetween: "7-20D"
    ));
    _tradeDayList.add(TradeBotInfoModel(
        duration: "30D",
        gridProfit: "4.20% (APY 51.14%)",
        maximumDropDown: "-4.68",
        volatility: "56.87",
        priceRange: "1387.54-1908.55",
        profitPerGrid: "0.44%~0.64% (52 Grids)",
        durationBetween: "30-50D"
    ));

    _selectedTradeDay = _tradeDayList[0];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Size? size = _appBarKey.currentContext?.size;
      _appBarSize = size?.height ?? 0;
      setState(() {});
      // _walletController.transactionHistoryList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _appBarKey,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bottomSheetBG,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            30.r,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 13.h),
            Container(
              width: 100.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Smart parameters",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  height: 30.h,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected =
                          _selectedTradeDay == _tradeDayList[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              _selectedTradeDay = _tradeDayList[index];
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              padding: EdgeInsets.symmetric(
                                vertical: 3.h,
                                horizontal: 10.w,
                              ),
                              decoration: BoxDecoration(
                                  // color: isSelected
                                  //     ? AppColors.white.withOpacity(0.2)
                                  //     : Colors.transparent,
                                  border: Border(bottom: BorderSide(width: 2.h,color: isSelected
                                      ? AppColors.tradeDayListSelectedColor
                                      : AppColors.tradeDayListUnSelectedColor,)),
                              ),
                              child: Text(
                                _tradeDayList[index].duration,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.tradeDayListSelectedColor
                                      : AppColors.tradeDayListUnSelectedColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: _tradeDayList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                )
              ],
            ),
            SizedBox(height: 7.h),
            _botCustomRow(
              title: "Grid profit",
              value: "${_selectedTradeDay.gridProfit}",
              valueColor: AppColors.lightGreen,
            ),
            SizedBox(height: 5.h),
            _botCustomRowBold(
              title: "Maximum Dropdown",
              value: "${_selectedTradeDay.maximumDropDown}%",
              valueColor: AppColors.walletTextColor,
            ),
            SizedBox(height:5.h),

            _botCustomRowBold(
              title: "Volatility",
              value: "${_selectedTradeDay.volatility}%",
              valueColor: AppColors.walletTextColor,

            ),
            SizedBox(height: 5.h),

            _botCustomRow(
              title: "Price range (USDT): ",
              value: "${_selectedTradeDay.priceRange}",
              valueColor: AppColors.walletTextColor,

            ),
            _botCustomRow(
              title: "Profit per grid(Fee deducted)",
              value: "${_selectedTradeDay.profitPerGrid}",
              valueColor: AppColors.walletTextColor,

            ),
            SizedBox(height:3.h),

            CustomTextFiled(
              controller: _coinTextEditingController,
              label: "Coin",
              hint: "Enter ${AppString.currencySymbol} quantity",
              inputType: TextInputType.number,
            ),
            SizedBox(height: 10.h),
            CustomButton(
              title: "Create Bot",
              borderRadius: 8.r,
              onTap: () {
                int minimumSLC = 100;
                double coinQty =
                    double.tryParse(_coinTextEditingController.text) ?? 0;
                if (coinQty <= 0) {
                  _coinDetailController.showError(
                      msg:
                          "Please enter valid ${AppString.currencySymbol}");
                  return;
                }
                if (coinQty < minimumSLC) {
                  _coinDetailController.showError(
                      msg:
                          "Minimum investment $minimumSLC ${AppString.currencySymbol}");
                  return;
                }
                _coinDetailController.sendTradeBot(
                  coinAmount: _coinTextEditingController.text,
                  tradeBotInfoModel: _selectedTradeDay,
                  coinSymbol: widget.coinSymbol,
                );
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _botCustomRow(
      {String? title, String? value, Color valueColor = Colors.white}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Text(
            title ?? "",
            style: TextStyle(
              color: AppColors.walletSubTextColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(child: Container()),
          Text(
            value ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: valueColor,
            ),
          )
        ],
      ),
    );
  }
  Widget _botCustomRowBold(
      {String? title, String? value, Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Text(
            title ?? "",
            style: TextStyle(
              color: AppColors.walletSubTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(child: Container()),
          Text(
            value ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: valueColor,
            ),
          )
        ],
      ),
    );
  }
}
