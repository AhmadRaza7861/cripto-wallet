import 'package:crypto_wallet/api/api_service.dart';
import 'package:crypto_wallet/enum/api_status_type.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApiStatusManageWidget<T> extends StatelessWidget {
  ApiStatus<T> apiStatus;
  Widget child;
  double? height;
  Widget? customNoDataFound;

  ApiStatusManageWidget(
      {required this.apiStatus,
      required this.child,
      this.height,
      this.customNoDataFound});

  @override
  Widget build(BuildContext context) {
    if (apiStatus.apiStatusType == ApiStatusType.loading) {
      if (apiStatus.data is List) {
        if ((apiStatus.data as List).isEmpty) {
          return Container(
            height: height,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      } else {
        return Container(
          height: height,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      }
    }
    if (apiStatus.data is List) {
      if ((apiStatus.data as List).isEmpty) {
        return customNoDataFound ??
            Container(
              width: double.infinity,
              height: height,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImage.icNoData,
                    width: 150.w,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "No data found",
                    style: TextStyle(
                      color: AppColors.gray,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      fontFamily: "",
                    ),
                  )
                ],
              ),
            );
      }
    }
    return child;
  }
}
