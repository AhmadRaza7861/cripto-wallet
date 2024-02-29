import 'package:crypto_wallet/view/auth/login/login_screen.dart';
import 'package:crypto_wallet/view/auth/register/register_screen.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../util/app_constant.dart';

class LoginFirstScreen extends StatefulWidget {
  const LoginFirstScreen({Key? key}) : super(key: key);

  @override
  State<LoginFirstScreen> createState() => _LoginFirstScreenState();
}

class _LoginFirstScreenState extends State<LoginFirstScreen> {
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
          backgroundColor: AppColors.homeBGColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 150.w,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r)),
                          child: Image.asset(
                            AppImage.imgLogo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  title: "Get Started",
                  bgColor: AppColors.buttonBGColor,
                  textColor: AppColors.buttonTitleColor,
                  onTap: () {
                    Get.to(() => const RegisterScreen());
                  },
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  title: "Sign In",
                  isShowBorder: true,
                  bgColor: AppColors.buttonBGColor,
                  borderColor: AppColors.white,
                  textColor: AppColors.buttonTitleColor,
                  onTap: () {
                    Get.to(() => const LoginScreen());
                  },
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
