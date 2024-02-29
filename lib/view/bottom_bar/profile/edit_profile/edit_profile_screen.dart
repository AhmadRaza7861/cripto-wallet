import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/util/common.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:crypto_wallet/view/bottom_bar/home/widget/receive_coin_bottom_sheet.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    _userController.userImageFile = null;
    User user = _userController.userResponseModel.value.user ?? User();
    _userController.firstNameController.text = user.firstname ?? "";
    _userController.lastNameController.text = user.lastname ?? "";
    _userController.emailController.text = user.email ?? "";
    _userController.referralCodeController.text = user.referralCode ?? "";
    _userController.countryCode = user.countryCode ?? "+971";
    _userController.phoneController.text =
        (user.phone ?? "").replaceAll(_userController.countryCode, "");
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
          backgroundColor:AppColors.screenBGColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0.h), // here the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(

                  centerTitle: true,
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
                  title: Text(
                    "Account Info",
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Get.bottomSheet(const ReceiveCoinBottomSheet(),
                                            isScrollControlled: true);
                          },
                          child: Container(
                            padding: EdgeInsets.all(7.w),
                            margin: EdgeInsets.only(right: 16.w),
                            height: 35.w,
                            width: 35.w,
                            decoration:  BoxDecoration(
                              color: AppColors.bgColorCon,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Image.asset(
                              AppImage.icScan,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),

          // appBar: AppBar(
          //   title: const Text(
          //     "Account Info",
          //   ),
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
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration:  BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CustomFadeInImage(
                            url: cont.userImageFile?.path ??
                                cont.userResponseModel.value.user
                                    ?.profileImage ??
                                "",
                            fit: BoxFit.cover,
                            placeHolderWidget: Text(
                              userDetailsFirstLetter(
                                  user: cont.userResponseModel.value.user ??
                                      User()),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _pickImageFile();
                          },
                          child: Image.asset(
                            AppImage.icEdit,
                            width: 30.w,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFiled(
                    controller: cont.firstNameController,
                    label: "First Name",
                    hint: "Enter your first name",
                  ),
                  CustomTextFiled(
                    controller: cont.lastNameController,
                    label: "Last Name",
                    hint: "Enter your last name",
                  ),
                  CustomTextFiled(
                    controller: cont.emailController,
                    label: "Email",
                    hint: "Enter your email address",
                    readOnly: true,
                    // enabled: false,
                  ),
                  Text(
                    "Phone number",
                    style: TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    padding: EdgeInsets.symmetric(),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.textFiledBorderColor, width: 1.0)),
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
                          initialSelection: cont.countryCode ?? '+971',
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
                            color:  AppColors.textfieldTextColor,
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
                                color: AppColors.white.withOpacity(0.8),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              // contentPadding:
                              // EdgeInsets.symmetric(vertical: 15.h, horizontal: 0.w),
                            ),
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color:AppColors.textfieldTextColor),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h,),
                  CustomTextFiled(
                    controller: cont.referralCodeController,
                    label: "Referral Code.",
                    hint: "Referral Code.",
                    // enabled: false,
                    readOnly: true,

                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          isShowBorder: true,
                          titleTextSize: 12.sp,
                          borderColor: AppColors.borderColor,
                          borderRadius: 8.r,
                          // textColor: AppColors.blueButton,
                          title: "Update",
                          onTap: () async {
                            bool isMobileNumberChange =
                                ("${_userController.countryCode}${_userController.phoneController.text}" !=
                                    (_userController.userResponseModel.value.user ??
                                            User())
                                        .phone);
                            bool isSuccessFullyChange = false;
                            if (isMobileNumberChange) {
                              bool isAvailablePhoneNumber = await _userController
                                  .checkPhone(isRegisterUser: false);
                              if (isAvailablePhoneNumber) {
                                isSuccessFullyChange = await _userController
                                    .sendPhoneOTP(isRegisterUser: false);
                              }
                              logger(
                                  "msg   ==>   $isAvailablePhoneNumber   $isMobileNumberChange  ${isSuccessFullyChange}");
                            } else {
                              _userController.updateUserInfo();
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 18.w,),
                      Expanded(
                        child: CustomButton(
                          isShowBorder: true,
                          titleTextSize: 12.sp,
                          borderColor: AppColors.textFiledBorderColor,
                          bgColor: Colors.transparent,
                          textColor: AppColors.appBarTitelColor,
                          borderRadius: 8.r,
                          title: "Delete Account",
                          onTap: () async {
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _pickImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      _userController.userImageFile = File(result.files.single.path ?? "");
      logger(
          "message ==>   ${_userController.userImageFile?.path}   ${_userController.userImageFile?.lengthSync()}");
      int? bytes = await _userController.userImageFile?.length();

      const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      var i = (math.log(bytes ?? 0) / math.log(1024)).floor();
      logger(
          "message  File Size ==>   ${(((bytes ?? 0) / math.pow(1024, i)).toStringAsFixed(2)) + ' ' + suffixes[i]}");

      setState(() {});
    }
  }
}
