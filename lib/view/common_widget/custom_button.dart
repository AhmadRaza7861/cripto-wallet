import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  Function? onTap;
  Color? bgColor;
  Color? borderColor;
  Color? textColor;
  String? title;
  Widget? titleWidget;
  bool isShowBorder;
  double? height;
  double? width;
  double? borderRadius;
  double? titleTextSize;

  CustomButton(
      {this.onTap,
      this.title,
      this.bgColor,
      this.borderColor,
      this.textColor,
      this.titleWidget,
      this.height,
      this.width,
      this.borderRadius,
      this.titleTextSize,
      this.isShowBorder = false});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(vertical: 11.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          color: bgColor ?? AppColors.buttonBGColor,
          border: Border.all(
            color: isShowBorder
                ? borderColor ?? AppColors.primaryColor
                : bgColor ?? AppColors.white,
            width: 1.w,
          ),
        ),

        // ButtonStyle(
        //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //       RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8.0),
        //
        //           // side: BorderSide(color: Colors.red)
        //       )
        //   ),
        // ),
        child: titleWidget ??
            Text(
              title ?? "",
              style: TextStyle(
                color: textColor ?? AppColors.buttonTitleColor,
                fontSize: titleTextSize ?? 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
      ),
    );
  }
}
