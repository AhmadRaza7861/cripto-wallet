import 'package:crypto_wallet/model/transaction_history_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/home/user_activity_log/transaction_detail/transaction_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatefulWidget {
  bool isReceive;
  TransactionHistoryResponseModel transactionHistoryResponseModel;

  TransactionWidget(
      {this.isReceive = true, required this.transactionHistoryResponseModel});

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  final DateFormat _dateFormat = DateFormat("MMM dd");
  final DateTime _nowDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: AppColors.walletConBGColor, borderRadius: BorderRadius.circular(15.r)),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(15.r),
      //   border: Border.all(
      //     color: AppColors.primaryColor,
      //     width: 2.w,
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: AppColors.primaryColor.withOpacity(0.8),
      //       blurRadius: 1,
      //       spreadRadius: 1,
      //       offset: const Offset(
      //         0.5,
      //         0.5,
      //       ),
      //     )
      //   ],
      // ),
      child: Container(
        width: 0.6.sw,
        // decoration: BoxDecoration(
        //   color: AppColors.primaryColor.withRed(10),
        // ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.r),
          onTap: () {
            // Get.to(() => const TransactionDetailScreen());
            Get.bottomSheet(
                TransactionDetailScreen(
                  transactionHistoryResponseModel:
                      widget.transactionHistoryResponseModel,
                ),
                isScrollControlled: true);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isReceive
                      ? "Received By you"
                      : "Sent to ${widget.transactionHistoryResponseModel.receiver?.firstname ?? ""} ${widget.transactionHistoryResponseModel.receiver?.lastname ?? ""}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Image.asset(
                      AppImage.imgLogoWithoutBg,
                      width: 20.w,
                    ),
                    SizedBox(width: 5.h),
                    Expanded(
                      child: Text(
                        widget.transactionHistoryResponseModel
                                .transactionAmount ??
                            "0",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.white,
                      size: 20.w,
                    ),
                    SizedBox(width: 5.w),
                    const Text(
                      "Completed • ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _dateFormat.format(widget
                                .transactionHistoryResponseModel
                                .transactionTime ??
                            DateTime.now()),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15.w,
                      color: Colors.white,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
