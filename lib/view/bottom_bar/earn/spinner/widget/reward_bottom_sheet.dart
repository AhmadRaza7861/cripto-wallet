import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../controller/spinner_controller.dart';
import '../../../../common_widget/custom_button.dart';

class RewardBottomSheet extends StatefulWidget {
  const RewardBottomSheet({Key? key}) : super(key: key);

  @override
  State<RewardBottomSheet> createState() => _RewardBottomSheetState();
}

class _RewardBottomSheetState extends State<RewardBottomSheet> {
  final SpinnerController _spinnerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.bottomSheetBG,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Image.asset(
            AppImage.icCongratulation,
            width: 0.50.sw,
            height: 0.50.sw,
          ),
          SizedBox(
            height: 24.h,
          ),
          _spinnerController.startSpin?.result?.name != "Better luck next time" ? Text(
            "Congratulations",
            style: TextStyle(
                color: AppColors.textfieldTextColor,
                fontSize: 26.sp,
                fontWeight: FontWeight.w700),
          ) : Container(),
          _spinnerController.startSpin?.result?.name != "Better luck next time" ? SizedBox(
            height: 16.h,
          ) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _spinnerController.startSpin?.result?.name != "Better luck next time" ?  Text(
                "You won ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textfieldTextColor.withOpacity(0.6),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400),
              ) : Container(),
              Text(
                _spinnerController.startSpin?.result?.name == "10 - 500 SLC"?
                "${_spinnerController.startSpin?.reward?.winningAmount} SLC" : "${_spinnerController.startSpin?.result?.name}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textfieldTextColor.withOpacity(0.6),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
            child: CustomButton(
              borderRadius: 8.r,
              title: "Continue",
              onTap: () async {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
