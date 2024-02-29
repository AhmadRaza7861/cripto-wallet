import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../util/app_constant.dart';
import '../../../../common_widget/custom_button.dart';
import '../../../wallet/deposit/deposit_screen.dart';

class NotEfficientBalance extends StatefulWidget {
  const NotEfficientBalance ({Key? key}) : super(key: key);

  @override
  State<NotEfficientBalance> createState() => _NotEfficientBalanceState();
}

class _NotEfficientBalanceState extends State<NotEfficientBalance > {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bottomSheetBG,
      // insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        decoration: BoxDecoration(
            color: AppColors.bottomSheetBG, borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset(AppImage.icFail,
            // // width: 80.w,
            // height: 80.w),
            Text(
              "Efficient SLC",
              style: TextStyle(
                  color: AppColors.appBarTitelColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Text(
              "You have not efficient balance for spin please add SLC",
              style: TextStyle(
                  color: AppColors.appBarTitelColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Cancel",
                    // bgColor: AppColors.primaryColor,
                    // textColor: Colors.white,
                    onTap: () {
                      Get.back(result: false);
                    },
                  ),
                ),
                SizedBox(width: 5.w,),
                Expanded(
                  child: CustomButton(
                    title: "Add SLC",
                    // bgColor: AppColors.primaryColor,
                    // textColor: Colors.white,
                    onTap: () {
                      Get.back();
                      Get.to(() => const DepositScreen());
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
