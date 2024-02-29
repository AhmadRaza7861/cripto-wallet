import 'package:crypto_wallet/model/trade_bot_info_response_model.dart';
import 'package:crypto_wallet/model/with_draw_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TradeBotInfoBottomsheet extends StatefulWidget {
  TradeBotInfoResponseModel tradeBotInfoResponseModel;

  TradeBotInfoBottomsheet({required this.tradeBotInfoResponseModel});

  @override
  State<TradeBotInfoBottomsheet> createState() => _TradeBotInfoBottomsheetState();
}

class _TradeBotInfoBottomsheetState extends State<TradeBotInfoBottomsheet> {
  final GlobalKey _totalBalanceKey = GlobalKey();
  double _bottomSheetHeight = 0;
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy 'at' HH:mm:ss aa");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Size? size = _totalBalanceKey.currentContext?.size;
      _bottomSheetHeight = size?.height ?? 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _totalBalanceKey,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            30.r,
          ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            height: _bottomSheetHeight,
            width: 1.sw,
            child: Image.asset(
              AppImage.imgBg,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Container(
                    width: 100.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.gray,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.tradeBotInfoResponseModel.coin ?? ""}",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "${widget.tradeBotInfoResponseModel.duration ?? ""}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3.h),
                Divider(
                  color: AppColors.gray,
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(
                      "Amount :",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${widget.tradeBotInfoResponseModel.amountReturned ??widget.tradeBotInfoResponseModel.amount ?? "0"}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10.h),
                // Row(
                //   children: [
                //     Text(
                //       "IFSC Code:",
                //       style: TextStyle(
                //         fontSize: 14.sp,
                //         color: AppColors.gray,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     Expanded(
                //       child: Text(
                //         "${widget.tradeBotInfoResponseModel.ifscCode ?? ""}",
                //         style: TextStyle(
                //           fontSize: 14.sp,
                //           color: AppColors.textColor,
                //           fontWeight: FontWeight.w500,
                //         ),
                //         textAlign: TextAlign.end,
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      "Created Date:",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${_dateFormat.format(widget.tradeBotInfoResponseModel.createdAt ?? DateTime.now())}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
