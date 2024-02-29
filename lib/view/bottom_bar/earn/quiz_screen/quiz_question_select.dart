import 'package:crypto_wallet/model/quiz_model.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/quiz_screen/quiz_result_history_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/quiz_screen/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../controller/quiz_controller.dart';
import '../../../../../enum/error_type.dart';
import '../../../../../util/app_constant.dart';

class QuizQuestion extends StatefulWidget {
  const QuizQuestion({Key? key}) : super(key: key);

  @override
  State<QuizQuestion> createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  final QuizController _quizController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
     await _quizController.getQuizQuestion();
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
                    "SELECT A QUIZ TO START",
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        InkWell(
                          onTap:(){
                            Get.to(()=>QuizResultHistoryScreen());
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15.w,top: 9.h, bottom: 9.w),

                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color:AppColors.walletConBGColor,
                            ),
                            child: Image.asset(AppImage.icHistory,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
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
                      child: cont.viewAllQuizQuestion.value.data.isNotEmpty ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: cont
                            .viewAllQuizQuestion.value.data[0].games.length,
                        itemBuilder: (BuildContext context, index) {
                          QuizModel quizList =
                              cont.viewAllQuizQuestion.value.data[0];
                          return InkWell(
                            onTap: () {
                              // if(quizList.games[index].attempted == false ){
                                Get.to(() => QuizScreen(
                                  question: quizList.games[index], index:index ,
                                ))?.then((value) {
                                  _quizController.getQuizQuestion();
                                });
                              // }
                              // else{
                              //   }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5.h),
                                padding: EdgeInsets.symmetric(
                                  vertical: 17.h, horizontal: 10.w
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: AppColors.walletConBGColor
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${quizList.games[index].gameTitle ?? ""} ",
                                        style: TextStyle(color: AppColors.white),
                                      ),
                                    ),
                                    SizedBox(width: 4.w,),
                                    quizList.games[index].attempted?.attempt == true ?  Container(
                                      child: Text(
                                        "submitted",
                                        style: TextStyle(color: AppColors.white),
                                      ),
                                    ) : Container()
                                  ],
                                )),
                          );
                        },
                      ) : Center(child: CircularProgressIndicator()),
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
