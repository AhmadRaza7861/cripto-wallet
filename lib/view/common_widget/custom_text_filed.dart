import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFiled extends StatelessWidget {
  TextEditingController? controller;
  String? label;
  String? hint;
  Color? fillColor;
  bool? filled;
  bool? isShowBorder;
  TextStyle? hintStyle;
  TextInputType inputType;
  bool isPassword;
  bool readOnly;
  bool enabled;
  Widget? suffixIcon;
  Widget? prefixIcon;
  Function? onTap;
  int? minLines;
  int? maxLength;
  Color? cursorColor;

  CustomTextFiled({
    this.controller,
    this.label,
    this.hintStyle,
    this.filled = false,
    this.hint,
    this.fillColor,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false,
    this.enabled = true,
    this.isShowBorder = true,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.minLines,
    this.maxLength,
    this.cursorColor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label ?? "",
            style: TextStyle(
              color: AppColors.textFiledLabelColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.h),
        ],
        GestureDetector(
          onTap: () {
            // if (onTap != null) {
            //   onTap!();
            // }
          },
          child: Container(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(12.r),
            // ),
            child: TextField(
              cursorColor: cursorColor ?? AppColors.textfieldTextColor,
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                        color: AppColors.textFiledBorderColor, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                        color: AppColors.textFiledBorderColor, width: 1.0),
                  ),
                hintText: hint,
                hintStyle: hintStyle ??
                    TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textfieldTextColor,
                      fontWeight: FontWeight.w500,

                    ),
                border: (isShowBorder ?? false)
                    ?  OutlineInputBorder()
                    : InputBorder.none,
                filled: filled,
                fillColor: fillColor,
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                counter: Text("")
              ),

              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color:  AppColors.textfieldTextColor ,
              ),
              minLines: minLines,
              maxLines: minLines,
              maxLength: maxLength,
              keyboardType: inputType,
              onTap: () {
                if (onTap != null) {
                  onTap!();
                }
              },
              enabled: enabled,
              readOnly: readOnly,
            ),
          ),
        ),
      ],
    );
  }
}
