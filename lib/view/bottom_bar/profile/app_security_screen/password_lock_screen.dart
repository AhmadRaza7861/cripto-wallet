import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../util/app_constant.dart';
import '../../../common_widget/custom_button.dart';
import '../../bottom_bar_screen.dart';
import 'app_security.dart';

class PasswordLockScreen extends StatefulWidget {
  const PasswordLockScreen({Key? key}) : super(key: key);

  @override
  State<PasswordLockScreen> createState() => _PasswordLockScreenState();
}

class _PasswordLockScreenState extends State<PasswordLockScreen> {
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
            padding: EdgeInsets.symmetric(horizontal: 45.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Unlock Starline Wallet \n with your FaceID",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.appBarTitelColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Use Face ID to Unlock Remember \n or type in your Master Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.appBarTitelColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 54.h),
                Image.asset(
                  AppImage.icSetPassword,
                  height: 84.w,
                  width: 84.w,
                  color: AppColors.appBarTitelColor,
                ),
                SizedBox(height: 54.h),
                CustomButton(
                  title: "Set Passcode",
                  titleTextSize:14.sp ,
                  textColor: AppColors.buttonTitleColor,
                  onTap: (){
                    Get.to(()=>CustomLockScreen());
                  },
                ),
                InkWell(
                  onTap: (){
                    Get.offAll(()=>BottomBarScreen(),predicate: (route) => false);
                  },
                  child: Padding(
                    padding:EdgeInsets.symmetric(vertical: 16.h),
                    child: Text(
                      "Skip this for now ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.appBarTitelColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

  }
}
