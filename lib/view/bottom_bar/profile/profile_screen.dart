import 'dart:io';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/auth/privacy/privacy_policy_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/home/widget/receive_coin_bottom_sheet.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/about/about_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/account_security/account_security_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/edit_profile/edit_profile_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/faq/faq_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/kyc/kyc_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_address/my_address_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_orders/my_order_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/return_policy/return_policy_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/support/support_screen.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/logger.dart';
import '../../../util/user_details.dart';
import 'app_security_screen/biometrics_security_screen.dart';
import 'my_coupon/my_coupon_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserDetails _userDetails = UserDetails();
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();
  bool? lightTheme ;

  bool? status;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheme();
    setState(() {});
  }

  Future<void> getTheme() async {
    _homeController.isLightTheme.value = await _userDetails.getTheme(title: 'themeColor') ?? true;
    if(_homeController.isLightTheme.value == true){
      lightTheme= false;
    }else{
      lightTheme= true;
    }
    setState(() {});

    print("lightThemeColor  = = == ${_homeController.isLightTheme.value}");
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
          backgroundColor: AppColors.screenBGColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0.h), // here the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  title: Text(
                    "Profile",
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    Row(children: [
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(const ReceiveCoinBottomSheet(),
                              isScrollControlled: true);
                        },
                        child: Container(
                          padding: EdgeInsets.all(7.w),
                          margin: EdgeInsets.only(right: 16.w),
                          height: 35.w,
                          width: 35.w,
                          decoration: BoxDecoration(
                            color: AppColors.bgColorCon,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Image.asset(
                            AppImage.icScan,
                            color: AppColors.appBarTitelColor,
                          ),
                        ),
                      ),
                    ])
                  ],
                ),
              ],
            ),
          ),

          // appBar: AppBar(
          //   title: const Text("Profile"),
          //   actions: [
          //     IconButton(
          //       onPressed: () {
          //         Get.bottomSheet(const ReceiveCoinBottomSheet(),
          //             isScrollControlled: true);
          //       },
          //       icon: Icon(
          //         Icons.qr_code_2_outlined,
          //         color: AppColors.white,
          //       ),
          //     )
          //   ],
          // ),
          body: GetX<UserController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return Container();
            }
            User user = cont.userResponseModel.value.user ?? User();
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: CustomFadeInImage(
                        url: "${user.profileImage ?? ""}",
                        fit: BoxFit.cover,
                        placeHolder: AppImage.imgMainLogo,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "${user.firstname ?? ""} ${user.lastname ?? ""}",
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    user.email ?? "",
                    style: TextStyle(
                      color: AppColors.textFiledLabelColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightGray10,
                        borderRadius: BorderRadius.circular(12.r),
                        border:
                            Border.all(color: AppColors.withDrawBorderColor)),
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    child: Row(
                      children: [
                        SizedBox(height: 15.h),
                        Container(
                          width: 35.w,
                          height: 35.w,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Color(0xffF9FAFB),
                          ),
                          child: Image.asset(
                            AppImage.icMode,
                            color: AppColors.black,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              "Dark Mode",
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        FlutterSwitch(
                          width: 42.w,
                          height: 21.h,
                          toggleSize: 20.w,
                          value:lightTheme ?? false,
                          padding: 2.w,
                          activeColor: AppColors.black.withOpacity(.3),
                          inactiveColor: AppColors.primaryColor.withOpacity(.5),

                          activeIcon: Image.asset(AppImage.icDarkMode),
                          inactiveIcon: Image.asset(AppImage.icLightMode),
                          activeToggleBorder: Border.all(color:  AppColors.primaryColor.withOpacity(.5)),
                          onToggle: (val) async {
                            lightTheme = val;
                            _homeController.changeTheme();
                            setState((){});
                          },
                        ),
                      ],
                    ),
                  ),
                  _profileItemRow(
                    icon: AppImage.icAccountInfo,
                    title: "Account Info",
                    onTap: () {
                      Get.to(() => const EditProfileScreen());
                    },
                  ),
                  // _profileItemRow(icon: AppImage.icSetting, title: "General Setting"),
                  _profileItemRow(
                    icon: AppImage.icAccountSecurity,
                    title: "Account Security",
                    onTap: () {
                      Get.to(() => const AccountSecurityScreen());
                    },
                  ),
                   Container(
                     decoration: BoxDecoration(
                         color: AppColors.lightGray10,
                         borderRadius: BorderRadius.circular(12.r),
                         border:
                         Border.all(color: AppColors.withDrawBorderColor)),
                     margin:
                     EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                     padding:
                     EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                     child: InkWell(
                       onTap: (){
                         Get.to(() => BiomatricsSecurityScreen());
                       },
                       child: Row(
                        children: [
                          SizedBox(height: 15.h),
                          Container(
                            width: 35.w,
                            height: 35.w,
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Color(0xffF9FAFB),
                            ),
                            child: Image.asset(
                              AppImage.icFinger,
                              color: AppColors.blueBoderChart,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                "App Security",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: AppColors.textColor,
                              size: 17.w,
                            ),
                          )
                        ],
                  ),
                     ),
                   ),
                  // _profileItemRow(
                  //   icon: AppImage.icAccountSecurity,
                  //   title: "App Security",
                  //   onTap: () {
                  //     Get.to(() => BiomatricsSecurityScreen());
                  //   },
                  // ),
                  _profileItemRow(
                    icon: AppImage.icKyc,
                    title: "KYC",
                    onTap: () {
                      if (cont.userResponseModel.value.user?.kycVerified ==
                          "APPROVED") {
                        cont.showSnack(msg: "Your account is verified");
                        return;
                      }
                      if (cont.userResponseModel.value.user?.kycVerified ==
                          "SUBMITTED") {
                        cont.showSnack(msg: "KYC Submitted for the approval");
                        return;
                      }
                      Get.to(() => const KYCScreen());
                    },
                  ),
                  _profileItemRow(
                      icon: AppImage.icMyOrder,
                      title: "My Orders",
                      onTap: () {
                        Get.to(() => const MyOrderScreen());
                      }),
                  _profileItemRow(
                      icon: AppImage.icMyAddress,
                      title: "My Address",
                      onTap: () {
                        Get.to(() => MyAddressScreen());
                      }),
                  // _profileItemRow(
                  //     icon: AppImage.icReferralCode, title: "Referral Code"),
                  _profileItemRow(
                      icon: AppImage.icShareApp,
                      title: "Share App",
                      onTap: () {
                        String msg =
                            "${Platform.isAndroid ? "https://play.google.com/store/apps/details?id=com.starline.wallet" : "https://apps.apple.com/us/app/starline-wallet/id6444680105"}\n\nReferral code : ${cont.userResponseModel.value.user?.referralCode ?? ""}\n\nUse this Referral code to create an account and get 10 SLC";
                        Share.share(msg);
                        // Get.to(() => const AboutScreen());
                      }),
                  _profileItemRow(
                      icon: AppImage.icRateUs,
                      title: "Rate Us",
                      onTap: () {
                        // Get.to(() => const AboutScreen());
                        if (Platform.isAndroid) {
                          launchUrl(
                              Uri.parse(
                                  "http://play.google.com/store/apps/details?id=com.starline.wallet"),
                              mode: LaunchMode.externalApplication);
                        } else {
                          launchUrl(
                              Uri.parse(
                                "https://apps.apple.com/us/app/starline-wallet/id6444680105",
                              ),
                              mode: LaunchMode.externalApplication);
                        }
                      }),
                  _profileItemRow(
                      icon: AppImage.icPrivacyPolicy,
                      title: "Privacy Policy",
                      onTap: () {
                        Get.to(() => PrivacyPolicyScreen(
                              isPrivacyPolicy: true,
                            ));
                      }),
                  _profileItemRow(
                      icon: AppImage.icReturnPolicy,
                      title: "Return Policy",
                      onTap: () {
                        Get.to(() => ReturnPolicyScreen());
                      }),
                  _profileItemRow(
                      icon: AppImage.icAbout,
                      title: "About",
                      onTap: () {
                        Get.to(() => const AboutScreen());
                      }),
                  _profileItemRow(
                      icon: AppImage.icFaq,
                      title: "FAQs",
                      onTap: () {
                        Get.to(() => const FAQScreen());
                      }),
                  _profileItemRow(
                      icon: AppImage.icSupport,
                      title: "Support",
                      onTap: () {
                        Get.to(() => const SupportScreen());
                      }),
                  // _profileItemRow(icon: AppImage.icDelete, title: "Delete Account"),
                  _profileItemRow(
                    icon: AppImage.icLogout,
                    title: "Log Out",
                    onTap: _showLogoutDialog,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _profileItemRow({
    String? icon,
    String? title,
    Function? onTap,
  }) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.lightGray10,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.withDrawBorderColor)),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          children: [
            Image.asset(
              icon ?? AppImage.icAccountInfo,
              width: 35.w,
              // color: AppColors.white,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  title ?? "",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.textColor,
                size: 17.w,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
              onPressed: () async {
                Get.back();
                _userController.logout();
                // await _userDetails.getString(title: "userSecurityPin") ?? '';
                // await _userDetails.getBoolean(title: "biometricSecurity") ?? false ;
               await _userDetails.removeString( title:'userSecurityPin');
               await _userDetails.removeBoolean( title:'biometricSecurity');
              },
            ),
          ],
        );
      },
    );
  }
}
