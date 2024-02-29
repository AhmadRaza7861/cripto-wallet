import 'package:country_code_picker/country_code_picker.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/auth/privacy/privacy_policy_screen.dart';
import 'package:crypto_wallet/view/auth/register/otp_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/home/home_screen.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/logger.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserController _userController = Get.find();
  bool _isCheckPrivacyPolicy = false;
  bool _isPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    _userController.clearData();

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
          appBar: AppBar(
            leading: InkWell(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(left:25.w),
                child: Row(
                  children: [
                    Image.asset(
                      AppImage.icLeftArrow,
                      height: 17.h,
                      color: AppColors.appBarTitelColor,

                    ),
                  ],
                ),
              ),
            ),

          ),
          body: GetX<UserController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return Container();
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create your account',
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextFiled(
                    controller: _userController.firstNameController,
                    label: "First Name",
                    hint: "First name",
                  ),
                  CustomTextFiled(
                    controller: _userController.lastNameController,
                    label: "Last Name",
                    hint: "Last name",
                  ),
                  Text(
                    "Phone number",
                    style: TextStyle(
                      color: AppColors.textFiledLabelColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    padding: EdgeInsets.symmetric(),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.textFiledBorderColor)),
                    child: Row(
                      children: [
                        CountryCodePicker(
                          onChanged: (CountryCode countryCode) {
                            logPrint("  ==>  ${countryCode.dialCode}");
                            if (countryCode.dialCode != null) {
                              cont.countryCode = countryCode.dialCode!;
                            }
                          },
                          // padding: EdgeInsets.all(1),
                          flagWidth: 25,
                          initialSelection: cont.countryCode,
                          // countryFilter: ['IT', 'FR', 'IN'],
                          showFlagDialog: true,
                          // builder: (code){
                          //   return Row(children: [Text("${code?.code}")],);
                          // },
                          // barrierColor: Colors.white,
                          // boxDecoration: BoxDecoration(
                          //   border: Border.all(width: 1.0),
                          //   borderRadius:
                          //       BorderRadius.all(Radius.circular(5.0) //
                          //           ),
                          // ),
                          comparator: (a, b) =>
                              b.name!.compareTo(a.name.toString()),
                          //Get the country information relevant to the initial selection
                          onInit: (code) => print(
                              "on init ${code!.name} ${code.dialCode} ${code.name}"),
                          textStyle: TextStyle(
                            color: AppColors.appBarTitelColor,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: TextField(
                            controller: _userController.phoneController,
                            decoration: InputDecoration(
                              hintText: "1234567890",
                              hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.appBarTitelColor),
                              border: InputBorder.none,
                              isDense: true,
                              // contentPadding:
                              // EdgeInsets.symmetric(vertical: 15.h, horizontal: 0.w),
                            ),
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.appBarTitelColor),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 17.h),

                  CustomTextFiled(
                    controller: _userController.emailController,
                    label: "Email",
                    hint: "example@gmail.com",
                  ),
                  CustomTextFiled(
                    controller: _userController.passwordController,
                    label: "Password",
                    hint: "Enter your password",
                    minLines: 1,
                    isPassword: _isPasswordVisible,
                    suffixIcon: InkWell(
                      onTap: () {
                        _isPasswordVisible = !_isPasswordVisible;
                        setState(() {});
                      },
                      child: Icon(_isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: AppColors.appBarTitelColor ,
                      ),
                    ),
                  ),
                  CustomTextFiled(
                    controller: _userController.referralCodeController,
                    label: "Referral Code",
                    hint: "Enter referral code",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Theme(
                    data: ThemeData(unselectedWidgetColor: AppColors.appBarTitelColor,
                    ),
                    child: CheckboxListTile(
                      value: _isCheckPrivacyPolicy,
                      onChanged: (bool? value) {
                        _isCheckPrivacyPolicy = value ?? false;
                        setState(() {});
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      checkColor: AppColors.checkBoxColor,
                      activeColor: AppColors.appBarTitelColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: InkWell(
                        onTap: () {
                          Get.to(() => PrivacyPolicyScreen());
                        },
                        child: Text(
                          "I certify that I am 18 years of age or older, and I agree to the User Agreement and Privacy Policy",
                          style: TextStyle(
                            color: AppColors.appBarTitelColor,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  CustomButton(
                    title: 'Sign up',
                    onTap: () async {
                      bool isEmailAvailable =
                          await _userController.checkEmail();
                      bool isPhoneAvailable = false;
                      if (isEmailAvailable) {
                        isPhoneAvailable = await _userController.checkPhone();
                      }
                      if (!_isCheckPrivacyPolicy) {
                        _userController.showError(
                            msg: "Please check privacy policy");
                        return;
                      }
                      if (isEmailAvailable && isPhoneAvailable) {
                        await _userController.sendPhoneOTP();
                      }
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
