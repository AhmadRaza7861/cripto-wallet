import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/view/bottom_bar/bottom_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../util/app_constant.dart';
import 'package:pinput/pinput.dart';
import '../../../../util/user_details.dart';
import '../../../common_widget/custom_button.dart';

class CustomLockScreen extends StatefulWidget {
  bool? confirmPass;
  String? pin;
  String? oldPin;
  bool? changePass;

  CustomLockScreen(
      {Key? key, this.confirmPass, this.pin, this.oldPin, this.changePass})
      : super(key: key);

  @override
  State<CustomLockScreen> createState() => _CustomLockScreenState();
}

class _CustomLockScreenState extends State<CustomLockScreen> {
  final UserDetails _userDetails = UserDetails();

  final UserController userController = Get.find();
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  String? confirmPin;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45.w,
      height: 45.w,
      textStyle: TextStyle(
        fontSize: 22,
        color: AppColors.white,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.textFiledLabelColor,
      ),
    );
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
          backgroundColor: AppColors.homeBGColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0.h), // here the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
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
                  title: widget.changePass == true
                      ? Text(
                          "Change Passcode",
                          style: TextStyle(
                              fontSize: 16.sp, color: AppColors.appBarTitelColor),
                        )
                      : widget.oldPin != null
                          ? Text(
                              "Enter Passcode",
                              style: TextStyle(
                                  fontSize: 16.sp, color: AppColors.appBarTitelColor),
                            )
                          : Text(
                             "Set Passcode",
                              style: TextStyle(
                                  fontSize: 16.sp, color: AppColors.appBarTitelColor),
                            ),
                )
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    // color: AppColors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      widget.changePass == true
                          ? Text(
                              widget.confirmPass == false
                                  ? "Set your 6 digit PIN"
                                  : "Confirm your 6 digit PIN",
                              style: TextStyle(
                                  fontSize: 16.sp, color: AppColors.appBarTitelColor),
                            )
                          : widget.oldPin != null
                              ? Text(
                                  "Enter your pin",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.appBarTitelColor),
                                )
                              : Text(
                                  widget.confirmPass == false
                                      ? "Set your 6 digit PIN"
                                      : "Confirm your 6 digit PIN",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.appBarTitelColor),
                                ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          controller: pinController,
                          focusNode: focusNode,
                          length: 6,
                          // androidSmsAutofillMethod:
                          // AndroidSmsAutofillMethod.smsUserConsentApi,
                          // listenForMultipleSmsOnAndroid: true,
                          defaultPinTheme: defaultPinTheme,
                          // validator: (value) {
                          //   return widget.confirmPass == false
                          //       ? (widget.pin == value
                          //           ? null
                          //           : 'Pin is incorrect')
                          //       : null;
                          // },
                          // onClipboardFound: (value) {
                          //   debugPrint('onClipboardFound: $value');
                          //   pinController.setText(value);
                          // },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            confirmPin = pin;
                            setState(() {});
                            debugPrint('onCompleted: $pin');
                          },
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration:
                                defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.textFiledLabelColor,
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration:
                                defaultPinTheme.decoration!.copyWith(
                              color: AppColors.textFiledLabelColor,
                              borderRadius: BorderRadius.circular(10.r),
                              // border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: CustomButton(
                    borderRadius: 10.r,
                    width: .8.sw,
                    height: 40.h,
                    title: "Next",
                    onTap: () async {
                      if (widget.oldPin != null && widget.oldPin != "") {
                        print("  oldPin     - - - -${widget.oldPin}");
                        if (pinController.text == widget.oldPin) {
                          Get.to(
                                  () => CustomLockScreen(
                                  changePass: true, confirmPass: false),
                              preventDuplicates: false);
                        } else {
                          userController.showError(msg: "Passcode is not right");
                        }
                      } else if (widget.confirmPass == true) {

                        if (confirmPin == widget.pin) {
                          await _userDetails.saveString(title: "userSecurityPin", value: confirmPin ?? '');
                          userController.userPasscode?.value = confirmPin ?? "";

                          setState(() {});
                          Get.offAll(()=>BottomBarScreen(),predicate: (route) => false);
                        } else {
                          userController.showError(msg: "Passcode is not match");
                        }
                      } else {
                        if (pinController.text.isNotEmpty &&
                            pinController.text.length == 6) {
                          Get.to(
                                  () => CustomLockScreen(
                                  confirmPass: true, pin: pinController.text),
                              preventDuplicates: false);
                        } else {
                          userController.showError(msg: "please input Passcode");
                        }
                      }
                    },
                  ),
                  padding: EdgeInsets.only(bottom: 15.h),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}
