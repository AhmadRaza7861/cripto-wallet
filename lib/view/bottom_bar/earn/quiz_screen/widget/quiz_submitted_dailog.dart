import 'package:crypto_wallet/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../controller/quiz_controller.dart';
import '../../../../../util/app_constant.dart';
import '../../../../common_widget/custom_button.dart';

class QuizAlreadySubmittedDialog extends StatefulWidget {
  const QuizAlreadySubmittedDialog({Key? key}) : super(key: key);

  @override
  State<QuizAlreadySubmittedDialog> createState() => _QuizAlreadySubmittedDialogState();
}

class _QuizAlreadySubmittedDialogState extends State<QuizAlreadySubmittedDialog> {
  final QuizController _quizController = Get.find();

  int? ansForWin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logger("total - -- - ${_quizController.submitModel.value.data.first.total!}");
    if(_quizController.submitModel.value.data.first.total != null ){
      if(_quizController.submitModel.value.data.first.total == 1 || _quizController.submitModel.value.data.first.total == 2 ){
        ansForWin = 1;
      }
      else{
        ansForWin = (_quizController.submitModel.value.data.first.total! ~/ 2 + 1 );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            Image.asset(AppImage.icFail,
            // width: 80.w,
            height: 80.w),
            SizedBox(height: 20.h),
            Text(
              "${_quizController.submitModel.value.data.first.correct} RIGHT ANSWER",
              style: TextStyle(
                color: AppColors.appBarTitelColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Text(
              "you should select at least $ansForWin Right answer to win",
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
