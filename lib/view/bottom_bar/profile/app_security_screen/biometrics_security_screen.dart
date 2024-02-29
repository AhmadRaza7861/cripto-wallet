import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../util/app_constant.dart';
import '../../../../util/user_details.dart';
import '../../../common_widget/custom_button.dart';
import '../../bottom_bar_screen.dart';
import 'app_security.dart';

class BiomatricsSecurityScreen extends StatefulWidget {
  const BiomatricsSecurityScreen({Key? key}) : super(key: key);

  @override
  State<BiomatricsSecurityScreen> createState() => _BiomatricsSecurityScreenState();
}

class _BiomatricsSecurityScreenState extends State<BiomatricsSecurityScreen> {
  UserController userController = Get.find();
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  final UserDetails _userDetails = UserDetails();
  String? userPin;
  bool? isSwitched;

  @override
  void initState() {
    super.initState();
      getUserPin();
    getBiometrics();
    _checkBiometrics();
  }
  Future<void> getUserPin() async {
    userPin = await _userDetails.getString(title: "userSecurityPin") ?? '';
    print("userPin1  ===   ${userPin}");
    setState(() {});
  }
  Future<void> getBiometrics() async {
    isSwitched = await _userDetails.getBoolean(title: "biometricSecurity") ;
    print("biometricsSecurity  ===   ${isSwitched}");
    setState(() {});
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
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
                  centerTitle: true,
                  leading: InkWell(
                    onTap: () {
                      Get.offAll(()=>BottomBarScreen(),predicate: (route) => false);
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
                  title: Text(
                    "Security",
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.0.w),
            child: Column(
              children: [
                 CustomButton(
                   borderRadius: 10.r,
                   title: (userPin != null && userPin != "") ? "Change Password" : "Set Passcode",
                   onTap: (){
                     setState(() {});
                       Get.to(() =>  CustomLockScreen(confirmPass:false,oldPin: userPin,));
                   },
                 ),
                _canCheckBiometrics == true ?  Row(
                  children: [
                    Text("Biometrics security",
                      style: TextStyle(fontSize: 16.sp, color: AppColors.appBarTitelColor),
                    ),
                    Expanded(child: Container()),
                    Switch(
                      value: isSwitched ?? false,
                      onChanged: (value) async {
                        print("userPin    = = = = ${userPin}");
                        if(userPin != null && userPin != ""){
                        isSwitched = value;
                        print("visSwitched = = == ${isSwitched}");
                        await _userDetails.saveBoolean(title: "biometricSecurity", value: isSwitched ?? false);
                        setState(()  {});
                      }else{
                          userController.showError(msg: "Please Set Password");
                        }},
                      activeTrackColor: AppColors.securityBtnTrackColor,
                      activeColor: AppColors.securityBtnColor,
                    ),
                  ],
                ): Container(),

              ],
            ),
          ),

        ),
      ],
    );
  }
}
