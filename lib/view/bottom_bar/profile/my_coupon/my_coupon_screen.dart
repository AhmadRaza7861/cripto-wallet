import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controller/user_controller.dart';
import '../../../../enum/error_type.dart';
import '../../../../model/Coupon_response_model.dart';
import '../../../../util/app_constant.dart';
import '../../shop/shopping_screen.dart';

class MyCouponScreen extends StatefulWidget {
  const MyCouponScreen({Key? key}) : super(key: key);

  @override
  State<MyCouponScreen> createState() => _MyCouponScreenState();
}

class _MyCouponScreenState extends State<MyCouponScreen> {
  final UserController _userController = Get.find();
  final DateFormat _dateFormat = DateFormat("MMMM dd , yyyy");
  var formatter = DateFormat('dd MMMM yyyy');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getMyCoupon();
    });
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
            backgroundColor: AppColors.screenBGColor,
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
                    centerTitle: true,
                    title: Text(
                      "Rewards",
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
              if (cont.myCouponList.value.data.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w),
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
                    height: 8.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cont.myCouponList.value.data[0].shopping.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext Context, index) {
                        Shopping coupon =
                            cont.myCouponList.value.data[0].shopping[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.boxShadowColor,
                                  offset: Offset(2, 2),
                                  blurRadius: 7.r,
                                )
                              ],
                              borderRadius: BorderRadius.circular(16.r),
                              color: AppColors.checkBoxColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${coupon.percentOff}% off" ?? "",
                                style: TextStyle(
                                    color: AppColors.appBarTitelColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp),
                              ),
                              SizedBox(height: 12.h,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 12.h),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:AppColors.rewardBorderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(AppImage.icDate,
                                              width: 14.w,
                                              color: AppColors.appBarTitelColor,

                                            ),
                                            SizedBox(width: 5.w,),
                                            Text(
                                              _dateFormat.format(
                                                coupon.insertedAt ?? DateTime.now(),
                                              ),
                                              style: TextStyle(
                                                  color: AppColors.appBarTitelColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.w,
                                    ),
                                    coupon.usedAt != null ? Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(6.w),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6.r),
                                            color: AppColors.couponBgColor),
                                        child: Row(
                                          children: [
                                            Image.asset(AppImage.icExpire,
                                                width: 14.w),
                                            SizedBox(width: 5.w,),
                                            Text(
                                              _dateFormat.format(
                                                coupon.usedAt ?? DateTime.now(),
                                              ),
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ): Expanded(child: Container()),
                                  ],
                                ),
                              ),

                              SizedBox(height: 12.h,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:AppColors.rewardBorderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        coupon.coupon ?? "",
                                        style: TextStyle(
                                            color: AppColors.appBarTitelColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp),
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () async {
                                        await Clipboard.setData(ClipboardData(text: coupon.coupon ?? ""));
                                        _userController.showSnack(msg:coupon.coupon ?? "");

                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0.w),
                                        child: Image.asset(AppImage.icCopy,
                                          color: AppColors.appBarTitelColor,
                                          height: 20.h,
                                          width: 16.w,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 14.h),
                              InkWell(
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(text: coupon.coupon ?? ""));
                                  Get.to(()=>ShoppingScreen());
                                },
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: AppColors.blueButton,
                                        borderRadius: BorderRadius.circular(8.r)
                                      ),
                                  padding: EdgeInsets.symmetric(vertical: 11.h),
                                  child: Center(child: Text("Redeem now",
                                  style: TextStyle(
                                     fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: AppColors.white
                                  ),)),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            })),
      ],
    );
  }
}
