import 'dart:async';
import 'dart:math';

import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/spinner/widget/not_efficient_balance_dialog.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/spinner/widget/spin_not_available.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/spinner/widget/reward_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../controller/spinner_controller.dart';
import '../../../../controller/quiz_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../enum/error_type.dart';
import '../../../../util/logger.dart';
import '../../../common_widget/custom_button.dart';

class SpinningWheelScreen extends StatefulWidget {
  const SpinningWheelScreen({Key? key}) : super(key: key);

  @override
  State<SpinningWheelScreen> createState() => _SpinningWheelScreenState();
}

class _SpinningWheelScreenState extends State<SpinningWheelScreen> {
  final StreamController<int> selectedStream = StreamController<int>();
  final SpinnerController _spinnerController = Get.find();
  final QuizController _quizController = Get.find();
  final UserController _userController = Get.find();
  bool _isSpinApiCall = false;

  int? wheelValue;
  int index = 0;
  int rewardIndex = 0;

  @override
  void dispose() {
    selectedStream.close();
    super.dispose();
  }

  List<SpinnerModel> rewardList = [];
  List<Color> colorList = [
    Colors.blue,
    Colors.red,
    Colors.teal,
    Colors.orange,
    Colors.grey,
    Colors.green,
    Colors.pink,
    Colors.purple,
    Colors.teal,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _spinnerController.getAllReward().then((value) {
        for (int i = 0;
            i < _spinnerController.viewAllReward.value.data.length;
            i++) {
          rewardList.add(SpinnerModel(
            name: _spinnerController.viewAllReward.value.data[i].name,
            color: colorList[i],
            id: _spinnerController.viewAllReward.value.data[i].id,
          ));
        }
        setState(() {});
      });
      await _quizController.getTickets();
    });
  }

  Future<void> startSpin() async {
    _isSpinApiCall = true;
    Random random = new Random();
    int randomNumber = random.nextInt(rewardList.length);
    selectedStream.add(randomNumber);
    print("randomNumber   -  $randomNumber");
    setState(() {});
    await _spinnerController.getSpinValue();
    _isSpinApiCall = false;
    if (_spinnerController.startSpin != null) {
      // rewardList.forEach((element) {});
      for (int i = 0; i < rewardList.length; i++) {
        if (rewardList[i].id == _spinnerController.startSpin?.result?.id) {
          rewardIndex = i;
          selectedStream.add(rewardIndex);
          print("rewardIndex - - -- $i");
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SpinnerController>(builder: (cont) {
      if (cont.error.value.errorType == ErrorType.internet) {
        return Container();
      }
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
                          color: AppColors.walletTextColor,
                        ),
                      ),
                    ),
                    title: Text(
                      "Spin To Win",
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImage.icCoinAv,
                        height: 20.w,
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Text(
                          "Available Coins : ${AppString.currencySymbol} ${_userController.userResponseModel.value.user?.balance ?? "0"}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.appBarTitelColor)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.13.sh,
                ),
                SizedBox(
                  height: .9.sw,
                  child: rewardList.isNotEmpty
                      ? InkWell(
                    onTap: () async {
                      if(_quizController
                          .ticketsModel.value.data.stwTickets != null){
                        if (_quizController
                            .ticketsModel.value.data.stwTickets ==
                            0) {
                          Get.dialog(SpinNotAvailableDialog())
                              .then((value) async {
                            if (value == true) {
                              print("value = = = = $value");
                              if (double.parse(_userController
                                  .userResponseModel
                                  .value
                                  .user
                                  ?.balance ??
                                  "0") <
                                  100) {
                                Get.dialog(NotEfficientBalance());
                              } else {
                                startSpin();
                              }
                            }
                          });
                        } else {
                          startSpin();
                        }}
                    },
                        child: FortuneWheel(
                            selected: selectedStream.stream,
                            indicators: <FortuneIndicator>[
                              FortuneIndicator(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  AppImage.icIndicator,
                                  height: 90.w,
                                  width: 90.w,
                                ),
                              ),

                            ],

                            onAnimationEnd: () async {
                              // if (_isSpinApiCall) {
                              //   Random random = new Random();
                              //   int randomNumber =
                              //       random.nextInt(rewardList.length);
                              //   selectedStream.add(randomNumber);
                              //   print("randomNumber  1 -  $randomNumber");
                              //   return;
                              // }
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) {
                                    return RewardBottomSheet();
                                  } // your stateful widget
                                  );
                              await _userController.getUserInfo(
                                  isScreenChange: false);
                              await _quizController.getTickets();
                              setState(() {});
                            },
                            animateFirst: false,
                            alignment: Alignment.topCenter,
                          styleStrategy: UniformStyleStrategy(
                              color: Colors.red,
                              borderColor: Colors.green,
                              borderWidth: 3,
                          ),                            items: [
                              for (var it in rewardList)
                                FortuneItem(
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 50.w,
                                          right: 50.w,
                                          bottom: 50.w,
                                          top: 5.w),
                                      child: Text(
                                        it.name ?? "",
                                        style: TextStyle(fontSize: 12.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  style: FortuneItemStyle(
                                    color: it.color ?? Colors.red,
                                    borderColor: AppColors.bottomSheetBG,
                                    borderWidth: 5.w,
                                    textStyle: TextStyle(),
                                  ),
                                ),
                            ],
                          ),
                      )
                      : Center(child: CircularProgressIndicator()),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.appBarTitelColor,
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        "now you have ${_quizController.ticketsModel.value.data.stwTickets} free spin out of 5",
                        style: TextStyle(
                          color: AppColors.appBarTitelColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                  child: CustomButton(
                    title: "Spin",
                    onTap: () async {
                      index = 0;
                      if (_quizController.ticketsModel.value.data.stwTickets == 0) {
                        Get.dialog(SpinNotAvailableDialog())
                            .then((value) async {
                          if (value == true) {
                            if (double.parse(_userController.userResponseModel
                                        .value.user?.balance ??
                                    "0") <
                                100) {
                              Get.dialog(NotEfficientBalance());
                            } else {
                              startSpin();
                            }
                          }
                        });
                      } else {
                        startSpin();
                      }
                    },
                    borderRadius: 8.r,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class SpinnerModel {
  String? name;
  Color? color;
  int? id;

  SpinnerModel({this.name, this.color, this.id});
}
