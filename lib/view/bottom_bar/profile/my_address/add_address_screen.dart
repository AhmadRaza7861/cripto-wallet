import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/my_address_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddAddressScreen extends StatefulWidget {
  MyAddressResponseModel? myAddressResponseModel;


  AddAddressScreen({this.myAddressResponseModel});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    _userController.clearAddress();
    if(widget.myAddressResponseModel != null){
      _userController.addressLine1Controller.text = widget.myAddressResponseModel?.addressLine1??"";
      _userController.addressLine2Controller.text = widget.myAddressResponseModel?.addressLine2??"";
      _userController.landMarkController.text = widget.myAddressResponseModel?.landmark??"";
      _userController.countryController.text = widget.myAddressResponseModel?.country??"";
      _userController.stateController.text = widget.myAddressResponseModel?.state??"";
      _userController.cityController.text = widget.myAddressResponseModel?.city??"";
      _userController.pinCodeController.text = widget.myAddressResponseModel?.pincode??"";
    }
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
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 25.w),
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
            centerTitle: true,
            title: Text(
              "Add Address",
              style: TextStyle(
                color: AppColors.appBarTitelColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // appBar: AppBar(
          //   title: Text("Add Address"),
          // ),
          body: GetX<UserController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.values) {
              return Container();
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  CustomTextFiled(
                    controller: cont.addressLine1Controller,
                    label: "Address Line 1",
                    hint: "Enter address line 1",
                  ),
                  CustomTextFiled(
                    controller: cont.addressLine2Controller,
                    label: "Address Line 2",
                    hint: "Enter address line 2",
                  ),
                  CustomTextFiled(
                    controller: cont.landMarkController,
                    label: "Landmark",
                    hint: "Enter landmark",
                  ),
                  CustomTextFiled(
                    controller: cont.countryController,
                    label: "Country",
                    hint: "Enter country",
                  ),
                  CustomTextFiled(
                    controller: cont.stateController,
                    label: "State",
                    hint: "Enter state",
                  ),
                  CustomTextFiled(
                    controller: cont.cityController,
                    label: "City",
                    hint: "Enter city",
                  ),
                  CustomTextFiled(
                    controller: cont.pinCodeController,
                    label: "Pin code",
                    hint: "Enter pin code",
                    inputType: TextInputType.number,
                    maxLength: 6,
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    title: widget.myAddressResponseModel!=null?"Update Address":"Add Address",
                    onTap: () {
                      if(widget.myAddressResponseModel != null){
                        cont.editAddress(myAddressResponseModel: widget.myAddressResponseModel??MyAddressResponseModel());
                      }else{
                        cont.addAddress();
                      }
                    },
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
}
