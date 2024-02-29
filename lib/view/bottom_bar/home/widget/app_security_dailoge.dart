import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../profile/app_security_screen/biometrics_security_screen.dart';

class AppSecurityDialog extends StatefulWidget {
  const AppSecurityDialog({Key? key}) : super(key: key);

  @override
  State<AppSecurityDialog> createState() => _AppSecurityDialogState();
}

class _AppSecurityDialogState extends State<AppSecurityDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0x00000000),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 15.h),
                child: Text("Please Add Biometrics security or Passcode",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: (){
                Get.to(()=>BiomatricsSecurityScreen());
                // Get.back();
              },
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 6.h),
                child: Container(
                  child: Center(
                    child: Text("ok",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h,)
          ],
        ),
      ),

    );
  }
}
