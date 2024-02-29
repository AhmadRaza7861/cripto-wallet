import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/kyc/kyc_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({Key? key}) : super(key: key);

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final HomeController _homeController = Get.find();
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
          backgroundColor:AppColors.screenBGColor,
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
                      padding: EdgeInsets.only(left: 25.w),
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
                  title: Text(
                    "Account Security",
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
          body: GetX<UserController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return Container();
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.textFiledBorderColor,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                            color: AppColors.appBarTitelColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(child: Container()),
                        Text(
                          "Verified",
                          style: TextStyle(
                            color: AppColors.greenColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.textFiledBorderColor,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Email Id",
                          style: TextStyle(
                            color: AppColors.appBarTitelColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          onTap: cont.userResponseModel.value.user
                                      ?.emailVerified ==
                                  1
                              ? null
                              : () {
                                  cont.sendEmailOTP();
                                },
                          child: Text(
                            cont.userResponseModel.value.user?.emailVerified ==
                                    1
                                ? "Verified"
                                : "Send OTP",
                            style: TextStyle(
                              color: cont.userResponseModel.value.user
                                          ?.emailVerified ==
                                      1
                                  ? AppColors.greenColor
                                  : AppColors.closeWordColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  if (cont.userResponseModel.value.user?.countryCode ==
                      "+91") ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.textFiledBorderColor,
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "KYC",
                            style: TextStyle(
                              color: AppColors.appBarTitelColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(child: Container()),
                          InkWell(
                            onTap: kReleaseMode
                                ? cont.userResponseModel.value.user
                                            ?.kycVerified !=
                                        "PENDING"
                                    ? null
                                    : () {
                                        Get.to(() => KYCScreen());
                                      }
                                : () {
                                    Get.to(() => KYCScreen());
                                  },
                            child: Text(
                              "${cont.userResponseModel.value.user?.kycVerified == "PENDING" ? "Update KYC" : cont.userResponseModel.value.user?.kycVerified ?? ""}",
                              style: TextStyle(
                                color: cont.userResponseModel.value.user
                                            ?.kycVerified ==
                                        "PENDING"
                                    ? AppColors.white
                                    : cont.userResponseModel.value.user
                                                ?.kycVerified ==
                                            "SUBMITTED"
                                        ? AppColors.bgColor
                                        : cont.userResponseModel.value.user
                                                    ?.kycVerified ==
                                                "REJECTED"
                                            ? AppColors.closeWordColor
                                            : AppColors.greenColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
