import 'dart:developer';
import 'package:crypto_wallet/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import '../../../../../controller/quiz_controller.dart';
import '../../../../../model/quiz_model.dart';
import '../../../../../util/app_constant.dart';
import '../../../common_widget/custom_button.dart';

class QuizScreen extends StatefulWidget {
  Game question;
  int? index;
  QuizScreen({Key? key, required this.question ,  this.index}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController _quizController = Get.find();
  int questionIndex = 0;
  int? answerIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.question.gameId;
  }

  var radioValue = "";
  int? questionAnswer;

  @override
  Widget build(BuildContext context) {
    Question question = widget.question.questions[questionIndex];
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
                        color: AppColors.appBarTitelColor,
                      ),
                    ),
                  ),
                  title: Text(
                    "Quiz",
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
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            width: 1.sw,
            // color: Colors.red,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${questionIndex + 1} / ${widget.question.questions.length}",
                  style: TextStyle(
                      color: AppColors.quizTextColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16.sp),
                ),
                // SizedBox(height: 8.h),
                Container(
                  width: 1.sw,
                  child: Row(
                    children: [
                      for (int i = 0;
                          i < int.parse("${widget.question.questions.length}");
                          i++)
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              logger("msg sfd");
                              logger("question index $i");
                              questionIndex = i;
                              answerIndex = -1;
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 8.w),
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: i <= questionIndex
                                    ? AppColors.appBarTitelColor
                                    : AppColors.quizAnsRememberColor,
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "${question.question}",
                  style: TextStyle(
                      color: AppColors.quizTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Answer And Get Points",
                  style: TextStyle(
                      color: AppColors.quizTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp),
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: IgnorePointer(
                    ignoring: question.selectedAnsId != null ||
                        widget.question.attempted?.attempt == true,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: question.options.length,
                        itemBuilder: (BuildContext context, index) {
                          int ind = (index + 1);
                          // question.oldAnswer = ((question.answer ?? 1) + 1);
                          if (widget.question.attempted
                                  ?.attempt == true) {
                            question.oldAnswer = widget.question.attempted
                                ?.userAnswers[questionIndex].ans;
                          }
                          print("oldAnswer - - ${question.oldAnswer}");
                          if (question.options[index].isEmpty) {
                            return Container();
                          }
                          return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: (answerIndex == index ||
                                          (widget.question.attempted?.attempt ==
                                                  true &&
                                              ((question.answer ?? 0) - 1) ==
                                                  index))
                                      ? AppColors.greenColor
                                      : AppColors.walletConBGColor),
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  "${question.options[index]}",
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp),
                                ),
                                value: ind,
                                groupValue: question.oldAnswer ??
                                    question.selectedAnsId,
                                onChanged: (value) {
                                  question.selectedAnsId = ind;
                                  answerIndex = ((question.answer ?? 0) - 1);
                                  setState(() {});
                                },
                              ));
                        }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 17.w),
                  child: CustomButton(
                    borderRadius: 10.r,
                    width: 1.sw,
                    title: questionIndex + 1 == widget.question.questions.length
                        ? "Submit"
                        : "Next",
                    onTap: () async {
                      // if (question.questionId != null &&
                      //     question.selectedAnsId != null) {
                      if (questionIndex + 1 ==
                          widget.question.questions.length) {
                        Vibration.vibrate(duration: 100);
                        await _quizController.submitQuizAnswer(
                            question: widget.question , index:widget.index ?? 0);
                      } else {
                        log("selectedAnsId- - ok");
                        Vibration.vibrate(duration: 100);
                        questionIndex++;
                        answerIndex = -1;
                        print("answerIndex - - --- $answerIndex");
                        setState(() {});
                      }
                      // } else {
                      //   _quizController.showError(
                      //       msg: "Please select the anser");
                      // }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
