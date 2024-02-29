import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final UserController _userController = Get.find();
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
                    "Support",
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

          // appBar: AppBar(
          //   title: const Text("Support"),
          // ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.bgColorCon,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: AppColors.textFiledBorderColor)
                    // boxShadow: [
                    //   AppBoxShadow.defaultShadow(),
                    // ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 60.w,
                          width: 60.w,
                          child: Image.asset(AppImage.imgCustomerService),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        VerticalDivider(width : 1.w ,color: Color(0xffD1D1D1),
                            thickness: 1.w
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Our team persons will contact you soon!",
                                style: TextStyle(
                                  color: AppColors.supportTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 12.h,),
                              // InkWell(
                              //   onTap: () {
                              //     _userController.makePhoneCall(
                              //         phoneNumber: "+917043862463");
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 20.w, vertical: 7.h),
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.circular(20.r),
                              //       boxShadow: [
                              //         AppBoxShadow.defaultShadow(),
                              //       ],
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         "Call",
                              //         style: TextStyle(
                              //           color: AppColors.primaryColor,
                              //           fontSize: 12.sp,
                              //           fontWeight: FontWeight.w600,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  _userController.sendMail(
                                      mail: "support@starlinecrypto.com");
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.appBarTitelColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                    // boxShadow: [
                                    //   AppBoxShadow.defaultShadow(),
                                    // ],
                                  ),
                                  child: Text(
                                    "Message",
                                    style: TextStyle(
                                      color: AppColors.withDrawButtonTextColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Text(
                  //   "Our team persons will contact you soon!",
                  //   style: TextStyle(
                  //     color: AppColors.primaryColor,
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 12.sp,
                  //   ),
                  // )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
