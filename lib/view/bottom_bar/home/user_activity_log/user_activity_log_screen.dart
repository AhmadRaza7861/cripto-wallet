import 'dart:async';
import 'dart:developer';

import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/transaction_history_response_model.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/home/user_activity_log/widget/transaction_widget.dart';
import 'package:crypto_wallet/view/bottom_bar/home/widget/send_coin_bottom_sheet.dart';
import 'package:crypto_wallet/view/common_widget/api_status_manage_widget.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserActivityLogScreen extends StatefulWidget {
  User user;

  UserActivityLogScreen({required this.user});

  @override
  State<UserActivityLogScreen> createState() => _UserActivityLogScreenState();
}

class _UserActivityLogScreenState extends State<UserActivityLogScreen> {
  final HomeController _homeController = Get.find();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _homeController.transactionHistoryByUserList.value.data.clear();
    _homeController.transactionHistoryByUserId = widget.user.id ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.getTransactionHistoryByUser();
    });
    _streamSubscription =
        _homeController.transactionHistoryByUserList.listen((p0) {
      // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      Future.delayed(
        Duration(milliseconds: 500),
        () {
          if (_scrollController.positions.isNotEmpty) {
            // log("message  ===>   ${_scrollController.offset} ${_scrollController.position.maxScrollExtent}");
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        },
      );
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
          backgroundColor: Colors.transparent,
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
                      padding: EdgeInsets.all(18.w),
                      child: Image.asset(
                        AppImage.icLeftArrow,
                        height: 16.5.h,
                        width: 9.w,
                        color: AppColors.appBarTitelColor,
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomUserProfileImage(width: 35.w, user: widget.user),
                      SizedBox(width: 5.w),
                      Text(
                        "${widget.user.firstname ?? ""} ${widget.user.lastname ?? ""}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.appBarTitelColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(kToolbarHeight),
          //   child: Stack(
          //     children: [
          //       Container(
          //         height: 1.sh,
          //         width: 1.sw,
          //         child: Image.asset(
          //           AppImage.imgBg,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //       AppBar(
          //         title: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             CustomUserProfileImage(width: 35.w, user: widget.user),
          //             SizedBox(width: 5.w),
          //             Text(
          //               "${widget.user.firstname ?? ""} ${widget.user.lastname ?? ""}",
          //               maxLines: 1,
          //               overflow: TextOverflow.ellipsis,
          //               style: TextStyle(
          //                 color: AppColors.white,
          //                 fontSize: 16.sp,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             )
          //           ],
          //         ),
          //         centerTitle: true,
          //       ),
          //     ],
          //   ),
          // ),
          body: GetX<HomeController>(
            builder: (cont) {
              if (cont.error.value.errorType == ErrorType.internet) {
                return Container();
              }
              return Column(
                children: [
                  Expanded(
                    child: ApiStatusManageWidget(
                      apiStatus: cont.transactionHistoryByUserList.value,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        itemBuilder: (BuildContext context, int index) {
                          TransactionHistoryResponseModel
                              transactionHistoryResponseModel = cont
                                  .transactionHistoryByUserList
                                  .value
                                  .data[index];
                          bool isSender =
                              transactionHistoryResponseModel.sender?.id ==
                                  widget.user.id;
                          return Align(
                            alignment: isSender
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: TransactionWidget(
                              isReceive: isSender,
                              transactionHistoryResponseModel:
                                  transactionHistoryResponseModel,
                            ),
                          );
                        },
                        itemCount:
                            cont.transactionHistoryByUserList.value.data.length,
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: CustomButton(
                      onTap: () {
                        Get.bottomSheet(
                          SendCoinBottomSheet(user: widget.user),
                          isScrollControlled: true,
                        );
                      },
                      title: "Send",
                    ),
                    // child: InkWell(
                    //   onTap: () {
                    //     Get.bottomSheet(
                    //       SendCoinBottomSheet(user: widget.user),
                    //       isScrollControlled: true,
                    //     );
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: 15.w, vertical: 10.h),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.white,
                    //       borderRadius: BorderRadius.circular(40.r),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(
                    //           Icons.arrow_upward,
                    //           color: AppColors.primaryColor,
                    //         ),
                    //         SizedBox(width: 3.w),
                    //         Text(
                    //           "Send",
                    //           style: TextStyle(
                    //             color: AppColors.primaryColor,
                    //             fontSize: 16.sp,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _homeController.transactionHistoryByUserId = null;
    _streamSubscription?.cancel();
  }
}
