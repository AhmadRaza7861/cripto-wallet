import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/auth/login_first_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/bottom_bar_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/trade_controller.dart';
import '../../model/graph_color_model.dart';
import '../../util/logger.dart';
import '../../util/user_details.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserController _userController = Get.find();
  final UserDetails _userDetails = UserDetails();
  bool? lightThemeColor;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      lightThemeColor = await _userDetails.getTheme(title: 'themeColor');
      logger("lightthemeColor  ${lightThemeColor}");
      if (lightThemeColor != null){
        if(lightThemeColor == true){
          setLightTheme();
        }
        else{
          setDarkTheme();
        }
      }else{
        setLightTheme();
      }
      setState(() {});
     await _checkAppTrackingTransparency();
      Timer(
        const Duration(seconds: 3),
        () {
          if(_userController.userResponseModel.value.brearerToken == null){
            Get.offAll(() => const LoginFirstScreen());
          }else{
            _userController.getUserInfo();
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 150.w,
                  // decoration:
                  //     BoxDecoration(borderRadius: BorderRadius.circular(15.r)),
                  child: Image.asset(
                    AppImage.imgSplashLogo,
                    color: AppColors.appBarTitelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _checkAppTrackingTransparency({bool isFirstTime = false}) async {
    if (!Platform.isIOS) {
      return true;
    }

    if (isFirstTime) {
      await showCustomTrackingDialog();
    }
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    // If the system can show an authorization request dialog
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.notDetermined) {
      // await showCustomTrackingDialog();
      // // Show a custom explainer dialog before the system dialog
      // await Future.delayed(const Duration(milliseconds: 200));
      // // Request system's tracking authorization dialog
      // final status =
      //     await AppTrackingTransparency.requestTrackingAuthorization();
    } else if (status != TrackingStatus.authorized && !isFirstTime) {
      // await showCustomTrackingDialog().then((value) async {});
      // await openAppSettings();
    }
    return (await AppTrackingTransparency.requestTrackingAuthorization()) ==
        TrackingStatus.authorized;
  }

  Future<void> showCustomTrackingDialog() async => await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Dear User'),
      content: const Text(
        'We care about your privacy and data security. This enables the driver to track the live location of user so that he can reach his current location by looking at the screen while a ride is booked.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Continue'),
        ),
      ],
    ),
  );


}
