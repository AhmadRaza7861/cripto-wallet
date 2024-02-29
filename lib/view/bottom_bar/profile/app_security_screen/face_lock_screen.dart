import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../util/app_constant.dart';
import '../../bottom_bar_screen.dart';

class FaceLockScreen extends StatefulWidget {
  const FaceLockScreen({Key? key}) : super(key: key);

  @override
  State<FaceLockScreen> createState() => _FaceLockScreenState();
}

class _FaceLockScreenState extends State<FaceLockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 45.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Unlock Remember With \n your Face Id",
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
              AppImage.icFaceLock,
              height: 84.w,
              width: 84.w,
              color: AppColors.appBarTitelColor,
            ),
            SizedBox(height: 54.h),
            CustomButton(
              title: "Use Face Id",
              titleTextSize:14.sp ,
              onTap: (){},
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
    );
  }
}
