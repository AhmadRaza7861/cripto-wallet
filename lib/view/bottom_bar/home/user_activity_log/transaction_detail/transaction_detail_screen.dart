import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/model/transaction_history_response_model.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/common_widget/custom_user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatefulWidget {
  TransactionHistoryResponseModel transactionHistoryResponseModel;

  TransactionDetailScreen({required this.transactionHistoryResponseModel});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final DateFormat _dateFormat = DateFormat("MMMM dd,yyyy");
  final DateFormat _timeFormat = DateFormat("hh:mm aa");
  final DateTime _nowDateTime = DateTime.now();
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    User user = (widget.transactionHistoryResponseModel.receiver?.id ==
            _userController.userResponseModel.value.user?.id)
        ? widget.transactionHistoryResponseModel.sender ?? User()
        : widget.transactionHistoryResponseModel.receiver ?? User();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bottomSheetBG,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            30.r,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15.h),
          Container(
            width: 100.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
          SizedBox(height: 10.h),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CustomUserProfileImage(
                  width: 70.w,
                  user: user,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                "${user.firstname ?? ""} ${user.lastname ?? ""}",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImage.imgLogoWithoutBg, width: 30.w),
                  SizedBox(
                    width: 7.w,
                  ),
                  Text(
                    widget.transactionHistoryResponseModel.transactionAmount ??
                        "",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.greenColor,
                    size: 18.w,
                  ),
                  Text(
                    " Completed • ${_dateFormat.format(widget.transactionHistoryResponseModel.transactionTime ?? _nowDateTime)} at ${_timeFormat.format(widget.transactionHistoryResponseModel.transactionTime ?? _nowDateTime)}",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  )
                ],
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.textFiledBorderColor,
                      width: 2.w,
                    ),
                    borderRadius: BorderRadius.circular(10.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _transactionItemWidget(
                      title: "Address Id:",
                      value: widget.transactionHistoryResponseModel.receiver
                              ?.wallet ??
                          "",
                    ),
                    const Divider(),
                    _transactionItemWidget(
                      title: "From:",
                      value:
                          "${widget.transactionHistoryResponseModel.sender?.firstname ?? ""} ${widget.transactionHistoryResponseModel.sender?.lastname ?? ""}",
                    ),
                    SizedBox(height: 7.h),
                    _transactionItemWidget(
                      title: "To:",
                      value:
                          "${widget.transactionHistoryResponseModel.receiver?.firstname ?? ""} ${widget.transactionHistoryResponseModel.receiver?.lastname ?? ""}",
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Image.asset(
          //   AppImage.imgCryptoTransaction,
          //   fit: BoxFit.contain,
          //   width: double.infinity,
          // ),
          SizedBox(height: 15.h),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 40.w),
          //   child: CustomButton(
          //     title: "Share",
          //     onTap: () {
          //       Get.back();
          //     },
          //   ),
          // ),
          // SizedBox(height: 25.h)
        ],
      ),
    );
  }

  Widget _transactionItemWidget({String? title, String? value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp),
        ),
        SizedBox(height: 3.h),
        Text(
          value ?? "",
          style: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp),
        )
      ],
    );
  }
}
