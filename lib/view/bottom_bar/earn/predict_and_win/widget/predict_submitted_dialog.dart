import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../util/app_constant.dart';
import '../../../../common_widget/custom_button.dart';

class PredictSubmittedDailog extends StatefulWidget {
  const PredictSubmittedDailog({Key? key}) : super(key: key);

  @override
  State<PredictSubmittedDailog> createState() => _PredictSubmittedDailogState();
}

class _PredictSubmittedDailogState extends State<PredictSubmittedDailog> {
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      backgroundColor: AppColors.bottomSheetBG,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
            color: AppColors.bottomSheetBG, borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5.h),
            Image.asset(AppImage.icComplete,
                // width: 80.w,
                height: 80.w),
            SizedBox(height: 20.h),

            Text(
              "Predictions submitted",
              style: TextStyle(
                  color: AppColors.appBarTitelColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),

            Text(
              "Wait for the results to be announced",
              style: TextStyle(
                  color: AppColors.appBarTitelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              title: "Okay",
              // bgColor: AppColors.primaryColor,
              // textColor: Colors.white,
              onTap: () {
                Get.back();
              },
            )
          ],
        ),
      ),

    );
  }
}
