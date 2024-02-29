import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/util/common.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomUserProfileImage extends StatelessWidget {
  double width;
  User user;

  CustomUserProfileImage({required this.width, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      clipBehavior: Clip.antiAlias,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor,
      ),
      child: CustomFadeInImage(
        url: (user.profileImage ?? ""),
        fit: BoxFit.cover,
        placeHolder: AppImage.imgMainLogo,
        // placeHolderWidget: Center(
        //   child: Text(
        //     userDetailsFirstLetter(
        //       user: user,
        //     ),
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: width*0.5,
        //       fontWeight: FontWeight.w600
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
