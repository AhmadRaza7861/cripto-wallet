import 'package:crypto_wallet/model/trade_bot_info_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateBotSuccessDialog extends StatefulWidget {
  TradeBotInfoModel tradeBotInfoModel;

  CreateBotSuccessDialog({required this.tradeBotInfoModel});

  @override
  State<CreateBotSuccessDialog> createState() => _CreateBotSuccessDialogState();
}

class _CreateBotSuccessDialogState extends State<CreateBotSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Grid bot created successfully with\nGrid profit ${widget.tradeBotInfoModel.gridProfit} Based on ${widget.tradeBotInfoModel.duration} backtest, suitable for running ${widget.tradeBotInfoModel.durationBetween}",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.2.h
                ),

                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.h),
              Text(
                "All earnings will be credited to your account \n after the trade duration",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.h),
              CustomButton(
                title: "Okay",
                bgColor: AppColors.primaryColor,
                textColor: Colors.white,
                onTap: () {
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
