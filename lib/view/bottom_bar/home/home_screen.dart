import 'dart:math';

import 'package:crypto_wallet/controller/stack_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/trade_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/home/user_activity_log/user_activity_log_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/home/widget/receive_coin_bottom_sheet.dart';
import 'package:crypto_wallet/view/bottom_bar/home/widget/send_coin_bottom_sheet.dart';
import 'package:crypto_wallet/view/common_widget/api_status_manage_widget.dart';
import 'package:crypto_wallet/view/common_widget/custom_user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TradeController _tradeController = Get.find();
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();
  final StackController _stackController=Get.put(StackController());
  final GlobalKey _totalBalanceKey = GlobalKey();
  double _totalBalanceHeight = 0;
  final GlobalKey conKey = GlobalKey();
  final GlobalKey appbarKey = GlobalKey();
  final GlobalKey key = GlobalKey();
  Size? conKeySize;
  Size? appbarKeySize;
  Size? keySize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      Size? size = _totalBalanceKey.currentContext?.size;
      _totalBalanceHeight = size?.height ?? 0;
      _getSize();
      setState(() {});
      _homeController.getTransactionUser();

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      _userController.publicKey.value=sharedPreferences.getString("publickey")!;
      String tokenAbi=await _homeController.loadTokenABIFile();
      _homeController.getBalanceLocally(publicKey: _userController.publicKey.value, privateKey: "", tokenAbi: tokenAbi).then((value)
      {
        _stackController.balance.value=value;
      });
      print("PUBLIC KEY Home ${_userController.publicKey.value}");




    });
  }

  void _getSize() async {
    conKeySize = conKey.currentContext!.size;
    print("conKeySize - - $conKeySize");
    appbarKeySize = appbarKey.currentContext!.size;
    print("conKeySize - - $appbarKeySize");
    keySize = key.currentContext!.size;
    print("conKeySize - - $keySize");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;

    EdgeInsets padding = MediaQuery
        .of(context)
        .padding;
    return Stack(
      children: [
        Container(
          key: key,
          height: 1.sh,
          width: 1.sw,
          child: Image.asset(
            AppImage.imgBg,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: AppColors.homeBGColor,
          body: GetX<UserController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return Container();
            }
            return GetX<HomeController>(
              builder: (cont) {
                if (cont.error.value.errorType == ErrorType.internet) {
                  return Container();
                }
                return Column(
                  children: [
                    Container(
                      key: appbarKey,
                      margin: EdgeInsets.only(top: 15.h),
                      padding: EdgeInsets.only(
                          left: 17.w,
                          right: 10.w,
                          top: padding.top + 5.h,
                          bottom: 5.h),
                      decoration: const BoxDecoration(
                        // color: AppColors.lightGray,
                      ),
                      child: Row(
                        children: [
                          CustomUserProfileImage(
                              width: 44.w,
                              user: _userController
                                  .userResponseModel.value.user ??
                                  User()),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              "Hello, ${_userController.userResponseModel.value
                                  .user?.firstname ?? ""}",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24.sp,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                          // Image.asset(
                          //   AppImage.icNotification,
                          //   width: 24.w,
                          // ),
                          SizedBox(width: 5.w),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              key: conKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 17.w, vertical: 8.h),
                                    child: Text(
                                      "Total balance",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.lightTextColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 17.w),
                                    child: Obx(()=>
                                        Text(
                                          "${AppString
                                              .currencySymbol} "
                                              "${_stackController.balance.value.length>18?(BigInt.parse(_stackController.balance.value) / BigInt.parse(pow(10, 18).toString())).toStringAsFixed(2):_stackController.balance.value}",
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.symmetric(
                                  //       horizontal: 8.w, vertical: 6.h),
                                  //   margin: EdgeInsets.symmetric(
                                  //       horizontal: 17.w, vertical: 8.h),
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(100.r),
                                  //       color: AppColors.darkBlue),
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     children: [
                                  //       Image.asset(
                                  //         AppImage.icUpArrow,
                                  //         width: 10.w,
                                  //         height: 12.h,
                                  //       ),
                                  //       Padding(
                                  //         padding: EdgeInsets.only(left: 6.0.w),
                                  //         child: Text(
                                  //           "4,536.56(20.02%)",
                                  //           style: TextStyle(
                                  //             fontSize: 12.sp,
                                  //             color: AppColors.white,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    key: _totalBalanceKey,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 4.w),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 17.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                        color: AppColors.bgColorCon,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.boxShadowColor
                                                .withOpacity(0.14),
                                            blurRadius: 14.r,
                                            // spreadRadius: 0.8.r,
                                            offset: Offset(-1, -1),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(
                                            12.r)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                SendCoinBottomSheet(),
                                                isScrollControlled: true,
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w,
                                                  vertical: 14.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                BorderRadius.circular(8.r),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    AppImage.icUpArrow,
                                                    width: 11.5.w,
                                                    height: 14.h,
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  Text(
                                                    "Send",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15.w),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                  const ReceiveCoinBottomSheet(),
                                                  isScrollControlled: true);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.w, vertical: 4.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    AppImage.icDownArrow,
                                                    width: 11.5.w,
                                                    height: 14.h,
                                                    color: AppColors.textColor,
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  Text(
                                                    "Receive",
                                                    style: TextStyle(
                                                      color: AppColors.textColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 17.w, vertical: 12.h),
                                    child: Text(
                                      'Activity Log',
                                      style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: ((keySize?.height ?? 0) -
                                    (appbarKeySize?.height ?? 0) -
                                    (conKeySize?.height ?? 0)
                                ),),
                              child: Container(
                                // height:double.parse("${sizeKeySize?.height}") - double.parse("${conKeySize?.height}"),
                                // width: 1.sw,
                                decoration: BoxDecoration(
                                  color: AppColors.liteGraylist,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(24.r),
                                    topLeft: Radius.circular(24.r),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.boxShadowColor,
                                      blurRadius: 4.r,
                                      // spreadRadius: 0.8.r,
                                    )
                                  ],
                                ),
                                child: ApiStatusManageWidget(
                                  apiStatus: cont.userList.value,
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(top: 16.h),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                      cont.userList.value.data.length ,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        User user =
                                        cont.userList.value.data[index];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 5.h,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(
                                                      () =>
                                                      UserActivityLogScreen(
                                                        user: user,
                                                      ));
                                            },
                                            borderRadius: BorderRadius.circular(
                                                12.r),
                                            child: Container(
                                              width: 1.sw,
                                              padding: EdgeInsets.only(
                                                  top: 16.w,
                                                  bottom: 16.w,
                                                  left: 16.w,
                                                  right: 20.w),
                                              decoration: BoxDecoration(
                                                  color:
                                                  AppColors.liteGraylist,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      12.r),
                                                  // border: Border.all(color:AppColors.borderColor.withOpacity(0.2) )
                                                  border: Border.all(
                                                      color: AppColors
                                                          .borderColor)),
                                              child: Row(
                                                children: [
                                                  CustomUserProfileImage(
                                                      width: 40.w,
                                                      user: user),
                                                  SizedBox(
                                                    width: 12.w,
                                                  ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Text(
                                                        "${user.firstname ??
                                                            ""} ${user.lastname ??
                                                            ""}",
                                                        maxLines: 1,
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textColor,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Image.asset(
                                                    AppImage.icRightArrow,
                                                    height: 15.h,
                                                    width: 10.w,
                                                    color:
                                                    AppColors.textColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
