import 'package:crypto_wallet/controller/quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../enum/error_type.dart';
import '../../../../model/quiz_result_history_model.dart';
import '../../../../util/app_constant.dart';

class QuizResultHistoryScreen extends StatefulWidget {
  const QuizResultHistoryScreen({Key? key}) : super(key: key);

  @override
  State<QuizResultHistoryScreen> createState() =>
      _QuizResultHistoryScreenState();
}

class _QuizResultHistoryScreenState extends State<QuizResultHistoryScreen> {
  final QuizController _quizController = Get.find();
  final DateFormat _dateFormat = DateFormat("MMMM dd,yyyy 'at' hh:mm aa");
  final DateTime _nowDateTime = DateTime.now();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _quizController.getQuizResultHistory();
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
                    "History",
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
          body: GetX<QuizController>(
            builder: (cont) {
              if (cont.error.value.errorType == ErrorType.internet) {
                return Container();
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: cont.viewAllQuizQuestion.value.data.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  cont.quizResultHistory.value.data.length,
                              itemBuilder: (BuildContext context, index) {
                                QuizResultHistory quizHistory =
                                    cont.quizResultHistory.value.data[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.h),
                                  decoration: BoxDecoration(color:AppColors.liteGraylist,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(color: AppColors.withDrawBorderColor),
                                  ),
                                  padding: EdgeInsets.all(12.w),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        padding: EdgeInsets.all(6.w),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          color:AppColors.iconBGBlue,
                                        ),
                                        child: Image.asset(AppImage.icHistory,
                                        ),
                                      ),

                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              "${quizHistory.title}",
                                              style: TextStyle(
                                                  color: AppColors.walletTextColor,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              "${quizHistory.reward}",
                                              style: TextStyle(
                                                  color: AppColors
                                                      .walletTextColor,
                                                  fontSize: 13.sp,
                                                  fontWeight:
                                                  FontWeight
                                                      .w400),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              '${_dateFormat.format((quizHistory.attemptDate ?? _nowDateTime),)}',
                                              style: TextStyle(
                                                color: AppColors.walletSubTextColor,
                                                fontSize: 12.sp,
                                                fontWeight:
                                                FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(child: CircularProgressIndicator()),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
