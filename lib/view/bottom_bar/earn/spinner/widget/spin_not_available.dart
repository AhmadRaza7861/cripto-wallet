import 'package:crypto_wallet/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../controller/quiz_controller.dart';
import '../../../../../util/app_constant.dart';
import '../../../../common_widget/custom_button.dart';

class SpinNotAvailableDialog extends StatefulWidget {
  const SpinNotAvailableDialog({Key? key}) : super(key: key);

  @override
  State<SpinNotAvailableDialog> createState() => _SpinNotAvailableDialogState();
}

class _SpinNotAvailableDialogState extends State<SpinNotAvailableDialog> {
  final QuizController _quizController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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
              "You have used all free spins for today",
              style: TextStyle(
                color: AppColors.appBarTitelColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Text(
              "Congratulations on using up all your free spins for the day! But don't let the fun stop there. Play more rounds and increase your chances of winning big by purchasing additional spins for just SLC 100 per spin",
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
                    title: "Spin",
                    // bgColor: AppColors.primaryColor,
                    // textColor: Colors.white,
                    onTap: () {
                      Get.back(result: true);
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
