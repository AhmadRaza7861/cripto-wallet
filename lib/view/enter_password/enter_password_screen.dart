import 'package:crypto_wallet/view/bottom_bar/bottom_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

import '../../controller/user_controller.dart';
import '../../util/app_constant.dart';
import '../../util/user_details.dart';
import '../bottom_bar/profile/app_security_screen/app_security.dart';
import '../bottom_bar/profile/profile_screen.dart';
import '../common_widget/custom_button.dart';

class EnterPasswordScreen extends StatefulWidget {
  const EnterPasswordScreen({Key? key}) : super(key: key);

  @override
  State<EnterPasswordScreen> createState() => _EnterPasswordScreenState();
}

class _EnterPasswordScreenState extends State<EnterPasswordScreen> {

  final LocalAuthentication auth = LocalAuthentication();

  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;



  final UserDetails _userDetails = UserDetails();
  final UserController userController = Get.find();
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  String? confirmPin;
  String? userPin;
  bool? biometricsSecurity;

  @override
  void initState() {
    super.initState();
    getBiometrics().then((value) {
      print(" biometricsSecurity 2     ${biometricsSecurity}");
      biometricsSecurity == true ? _checkBiometrics() : null;
    });
    getUserPin();
  }
  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
      _canCheckBiometrics == true ? _authenticateWithBiometrics( ) : null;
    });
  }
  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
      // print(object);
    } on PlatformException catch (e) {
      print("Authenticating    = = = ${e}");
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }
    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    if(message == "Authorized") {
      Get.offAll(()=>BottomBarScreen());
    }else{

    }
    print(" message   == ${message}");
    setState(() {
      _authorized = message;
    });
  }

  Future<void> getUserPin() async {
    userPin = await _userDetails.getString(title: "userSecurityPin") ?? '';
    print("userPin1  ===   ${userPin}");
    setState(() {});
  }
  Future<void> getBiometrics() async {
    biometricsSecurity = await _userDetails.getBoolean(title: "biometricSecurity") ;
    print("biometricsSecurity  ===   ${biometricsSecurity}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isSwitched = false;
    final defaultPinTheme = PinTheme(
      width: 45.w,
      height: 45.w,
      textStyle: TextStyle(
        fontSize: 22,
        color: AppColors.white,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.textFiledLabelColor,
      ),
    );
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
          backgroundColor: AppColors.homeBGColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0.h), // here the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  title: Text(
                    "Enter Passcode",
                    style: TextStyle(fontSize: 16.sp,
                        color: AppColors.appBarTitelColor),
                  ),
                )
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    // color: AppColors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        "Enter Password",
                        style: TextStyle(
                            fontSize: 16.sp, color: AppColors.appBarTitelColor),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          controller: pinController,
                          focusNode: focusNode,
                          length: 6,
                          // androidSmsAutofillMethod:
                          // AndroidSmsAutofillMethod.smsUserConsentApi,
                          // listenForMultipleSmsOnAndroid: true,
                          defaultPinTheme: defaultPinTheme,
                          // validator: (value) {
                          //   return widget.confirmPass == false
                          //       ? (widget.pin == value
                          //           ? null
                          //           : 'Pin is incorrect')
                          //       : null;
                          // },
                          // onClipboardFound: (value) {
                          //   debugPrint('onClipboardFound: $value');
                          //   pinController.setText(value);
                          // },
                          hapticFeedbackType:
                              HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            confirmPin = pin;
                            setState(() {});
                            debugPrint('onCompleted: $pin');
                          },
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration:
                                defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.textFiledLabelColor,
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration:
                                defaultPinTheme.decoration!.copyWith(
                              color: AppColors.textFiledLabelColor,
                              borderRadius: BorderRadius.circular(10.r),
                              // border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
              // Expanded(child: SizedBox()),
              Container(
                child: CustomButton(
                  borderRadius: 10.r,
                  width: .8.sw,
                  height: 40.h,
                  title: "Next",
                  onTap: () async {
                    if (confirmPin == userPin) {
                      setState(() {});
                      Get.offAll(() => const BottomBarScreen());
                    } else {
                      userController.showError(msg: "Passcode is Incorrect");
                    }
                  },
                ),
                padding: EdgeInsets.only(bottom: 15.h),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
enum _SupportState {
  unknown,
  supported,
  unsupported,
}
