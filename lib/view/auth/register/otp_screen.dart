import 'dart:async';

import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/change_password/change_password_screen.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/app_constant.dart';

class OtpScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  OtpScreen({required this.params});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = "";

  final UserController _userController = Get.find();
  int _timeCount = 60;
  Timer? _otpResendTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _startOTPTimer();
    });
  }

  void _startOTPTimer() {
    _timeCount = 60;
    _otpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeCount--;
      setState(() {});
      if (_timeCount <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isResendOTP = _timeCount <= 0;
    return Stack(
      children: [
        Container(
          height: 1.sh,
          child: Image.asset(
            AppImage.imgBg,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          // backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppColors.primaryColor,
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(15.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.params.containsKey("isResetPassword"))
                    Text(
                      'Verify your Email Id ${widget.params["user"]["email"]}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (widget.params.containsKey("isEmailOTP"))
                    Text(
                      'Verify your Email Id ${widget.params["email"]}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Text(
                      'Verify your Phone number ${widget.params["phone"]}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      "We have sent you a verification code\non your ${(widget.params.containsKey("isResetPassword") || widget.params.containsKey("isEmailOTP")) ? "email id" : "mobile number"}.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  // CustomTextFiled(
                  //   label: "Email",
                  //   hint: "Enter your email OTP",
                  // ),
                  OtpTextField(
                    numberOfFields: 4,
                    borderColor: AppColors.primaryColor,
                    showFieldAsBox: true,
                    fillColor: Colors.white,
                    enabledBorderColor: AppColors.primaryColor,
                    focusedBorderColor: AppColors.primaryColor,
                    disabledBorderColor: AppColors.gray,
                    autoFocus: true,
                    cursorColor: AppColors.white,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                      _otp = code;
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      _otp = verificationCode;
                      print("object  ==>  $_otp");
                    }, // end onSubmit
                  ),

                  SizedBox(
                    height: 15.h,
                  ),
                  if (!widget.params.containsKey("isResetPassword"))
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async {
                          bool isSuccess = await _userController.sendPhoneOTP(
                              isScreenChange: false);
                          if (isSuccess) {
                            _startOTPTimer();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 3.h),
                          child: Text(
                            "Resend OTP${isResendOTP ? "" : " ($_timeCount)"}",
                            style: TextStyle(
                              color: isResendOTP
                                  ? AppColors.primaryColor
                                  : AppColors.gray,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 50.h,
                  ),
                  CustomButton(
                    title: 'Verify OTP',
                    onTap: () {
                      if (_otp.length != 4) {
                        _userController.showError(msg: "please_enter_otp".tr);
                        return;
                      }
                      if (_userController.otp != _otp) {
                        _userController.showError(
                            msg: "Please enter valid OTP");
                        return;
                      }
                      if (widget.params.containsKey("isResetPassword")) {
                        Get.to(
                          () => ChangePasswordScreen(params: widget.params),
                        );
                      } else if (widget.params.containsKey("isEmailOTP")) {
                        _userController.verifyEmail();
                      } else if (widget.params.containsKey("isPhoneOTP")) {
                        _userController.verifyPhone();
                      } else {
                        _userController.register();
                      }
                      // Get.offAll(()=>const BottomBarScreen());
                    },
                    bgColor: AppColors.primaryColor,
                    textColor: AppColors.backWhite,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _otpResendTimer?.cancel();
  }
}
