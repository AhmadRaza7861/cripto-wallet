import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/auth/privacy/privacy_policy_screen.dart';
import 'package:crypto_wallet/view/auth/register/register_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/home/home_screen.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../bottom_bar/bottom_bar_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserController _userController = Get.find();
  bool _isPasswordVisible = true;
  bool _isRememberMe = false;

  @override
  void initState() {
    super.initState();
    _userController.clearData();
    _userController.getRememberMeUser();
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: InkWell(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(left:25.w),
                child: Row(
                  children: [
                    Image.asset(
                      AppImage.icLeftArrow,
                      height: 17.h,
                      color: AppColors.appBarTitelColor,

                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(15.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: AppColors.appBarTitelColor,
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Center(
                    child: Text(
                      'Login to your account',
                      style: TextStyle(
                        color: AppColors.appBarTitelColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextFiled(
                    controller: _userController.emailController,
                    // label: "Email",
                    hint: "Email Id",
                    prefixIcon: Icon(
                      Icons.email,
                      color: AppColors.appBarTitelColor,
                    ),
                  ),
                  CustomTextFiled(
                    controller: _userController.passwordController,

                    // label: "Password",
                    hint: "Password",
                    minLines: 1,
                    isPassword: _isPasswordVisible,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: AppColors.appBarTitelColor,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        _isPasswordVisible = !_isPasswordVisible;
                        setState(() {});
                      },
                      child: Icon(_isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: AppColors.appBarTitelColor,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  AppColors.appBarTitelColor),
                          child: CheckboxListTile(
                            value: _userController.isRememberMe.value,
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            checkColor: AppColors.checkBoxColor,
                            activeColor: AppColors.appBarTitelColor,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool? value) {
                              _userController.isRememberMe.value =
                                  value ?? false;
                              setState(() {});
                            },
                            title: Text(
                              "Remember Me",
                              style: TextStyle(
                                color: AppColors.appBarTitelColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _userController.forgotPassword();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5.h,
                          ),
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: AppColors.appBarTitelColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(()=>PrivacyPolicyScreen());
                      //   },
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(
                      //       vertical: 5.h,
                      //     ),
                      //     child: Text(
                      //       "Privacy policy",
                      //       style: TextStyle(
                      //         color: AppColors.white,
                      //         fontSize: 12.sp,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  CustomButton(
                    title: 'Sign In',
                    onTap: () {
                      // Get.offAll(()=>const BottomBarScreen());
                      _userController.loginWithEmail();
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => RegisterScreen());
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don`t have an account? ",
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  decoration: TextDecoration.underline,
                                  color: AppColors.appBarTitelColor),
                            ),
                          ],
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.appBarTitelColor),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
}
