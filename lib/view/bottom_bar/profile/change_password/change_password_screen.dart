import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  ChangePasswordScreen({required this.params});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newConPasswordController =
      TextEditingController();

  final UserController _userController = Get.find();

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
            title: Text("Change Password"),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                CustomTextFiled(
                  controller: _newPasswordController,
                  label: "New Password",
                  hint: "Enter new password",
                  isPassword: true,
                  minLines: 1,
                ),
                CustomTextFiled(
                  controller: _newConPasswordController,
                  label: "Confirm Password",
                  hint: "Enter new password",
                  isPassword: true,
                  minLines: 1,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  title: "Update Password",
                  onTap: () {
                    if (_newPasswordController.text.isEmpty) {
                      _userController.showError(
                          msg: "Please enter new password");
                      return;
                    }

                    if (_newPasswordController.text !=
                        _newConPasswordController.text) {
                      _userController.showError(
                          msg: "Please enter valid confirm password");
                      return;
                    }

                    _userController.changePassword(
                      newPassword: _newPasswordController.text,
                      userData: widget.params,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
