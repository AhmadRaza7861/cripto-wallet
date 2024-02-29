import 'dart:developer';

import 'package:crypto_wallet/controller/predictController.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/predict_and_win/widget/predict_submitted_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../../../../enum/error_type.dart';
import '../../../../model/predict_question_model.dart';
import '../../../../util/app_constant.dart';
import '../../../common_widget/custom_button.dart';

class PredictAndWinScreen extends StatefulWidget {
  const PredictAndWinScreen({Key? key}) : super(key: key);

  @override
  State<PredictAndWinScreen> createState() => _PredictAndWinScreenState();
}

class _PredictAndWinScreenState extends State<PredictAndWinScreen> {
  final PredictController _predictController = Get.find();
  int questionIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _predictController.getPredictQuestion();
    });
  }

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
                      padding: EdgeInsets.all(18.33.w),
                      child: Image.asset(
                        AppImage.icLeftArrow,
                        height: 16.5.h,
                        width: 9.w,
                        color: AppColors.appBarTitelColor,
                      ),
                    ),
                  ),
                  title: Text(
                    "Predict And Win",
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
          body:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: Image.asset(
                  AppImage.icPredictionBreak,
                ),
              ),
              SizedBox(height: 10.h,),
              Text("We Are on break, Will be back soon",
                style:  TextStyle(
                  color: AppColors.appBarTitelColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 24.h,),
            ],
          )
          // GetX<PredictController>(
          //   builder: (cont) {
          //     if (cont.error.value.errorType == ErrorType.internet) {
          //       return Container();
          //     }
          //     if(cont.predictQuestionList.value.data.isEmpty){
          //       return Center(
          //         child: Container(
          //           padding: EdgeInsets.symmetric(horizontal: 10.w , vertical: 10.w),
          //           decoration: BoxDecoration(
          //             color: AppColors.buttonBGColor,
          //             borderRadius: BorderRadius.circular(8.r)
          //           ),
          //           child: Text("Prediction not available",
          //             style: TextStyle(
          //               color: AppColors.buttonTitleColor
          //             ),
          //           ),
          //         ),
          //       );
          //     }
          //     PredictModel predictModel = cont.predictQuestionList.value.data[questionIndex];
          //     return Container(
          //       padding: EdgeInsets.symmetric(horizontal: 16.w),
          //       width: 1.sw,
          //       // color: Colors.red,
          //       child: Column(
          //         mainAxisSize: MainAxisSize.max,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Question ${questionIndex + 1} / ${cont.predictQuestionList.value.data.length}",
          //             style: TextStyle(
          //                 color: AppColors.quizTextColor,
          //                 fontWeight: FontWeight.w300,
          //                 fontSize: 16.sp),
          //           ),
          //           // SizedBox(height: 8.h),
          //           Container(
          //             width: 1.sw,
          //             child: Row(
          //               children: [
          //                 for (int i = 0; i < int.parse("${cont.predictQuestionList.value.data.length}"); i++)
          //                   Expanded(
          //                     child: InkWell(
          //                       onTap: () {
          //                         questionIndex = i;
          //                         setState(() {});
          //                       },
          //                       child: Container(
          //                         margin: EdgeInsets.symmetric(
          //                             horizontal: 4.w, vertical: 8.w),
          //                         height: 5.h,
          //                         decoration: BoxDecoration(
          //                           color: i <= questionIndex
          //                               ? AppColors.appBarTitelColor
          //                               : AppColors.quizAnsRememberColor,
          //                           borderRadius: BorderRadius.circular(100.r),
          //                         ),
          //                       ),
          //                     ),
          //                   )
          //               ],
          //             ),
          //           ),
          //           SizedBox(height: 16.h),
          //           Text(
          //             "${predictModel.question}",
          //             style: TextStyle(
          //                 color: AppColors.quizTextColor,
          //                 fontWeight: FontWeight.w700,
          //                 fontSize: 20.sp),
          //           ),
          //           SizedBox(height: 8.h),
          //           Text(
          //             "Answer And Get Points",
          //             style: TextStyle(
          //                 color: AppColors.quizTextColor,
          //                 fontWeight: FontWeight.w400,
          //                 fontSize: 14.sp),
          //           ),
          //           SizedBox(height: 24.h),
          //           Expanded(
          //             child: ListView.builder(
          //               shrinkWrap: true,
          //                 itemCount: cont.predictQuestionList.value.data[questionIndex].options.length,
          //                 itemBuilder: (BuildContext context, index) {
          //                   int ind = (index + 1);
          //                   return Container(
          //                       margin: EdgeInsets.symmetric(vertical: 8.h),
          //                       decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(12.r),
          //                           color: AppColors.walletConBGColor),
          //                       child: RadioListTile(
          //                         contentPadding: EdgeInsets.zero,
          //                         title: Text(
          //                           "${predictModel.options[index]}",
          //                           style: TextStyle(
          //                               color: AppColors.white,
          //                               fontWeight: FontWeight.w500,
          //                               fontSize: 12.sp),
          //                         ),
          //                         value: ind,
          //                         groupValue: predictModel.selectedAnsId,
          //                         onChanged: (value) {
          //                           predictModel.selectedAnsId = ind;
          //                           setState(() {});
          //                         },
          //                       ));
          //                 }),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.only(bottom: 17.w),
          //             child: CustomButton(
          //               borderRadius: 10.r,
          //               width: 1.sw,
          //               height: 40.h,
          //               title:"Submit",
          //               onTap: () async {
          //                 if (questionIndex + 1 == cont.predictQuestionList.value.data.length) {
          //                   Vibration.vibrate(duration: 100);
          //                   await _predictController.submitPredictAnswer(predictModel: predictModel , last: true);
          //                   // Get.dialog(PredictSubmittedDailog());
          //                 } else {
          //                   log("selectedAnsId- - ok");
          //                   Vibration.vibrate(duration: 100);
          //                   await _predictController.submitPredictAnswer(predictModel: predictModel , last: false);
          //                   questionIndex++;
          //                   setState(() {});
          //                 }
          //                 // } else {
          //                 //   _quizController.showError(
          //                 //       msg: "Please select the anser");
          //                 // }
          //               },
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ),
      ],
    );
  }
}
