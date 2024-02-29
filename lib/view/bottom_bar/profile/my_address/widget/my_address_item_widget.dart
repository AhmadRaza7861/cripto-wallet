import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/model/my_address_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_address/add_address_screen.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyAddressItemWidget extends StatelessWidget {
  MyAddressResponseModel myAddressResponseModel;
  bool isEditButtonShow;
  bool isSelectedAddress;

  MyAddressItemWidget({
    required this.myAddressResponseModel,
    this.isEditButtonShow = false,
    this.isSelectedAddress = false,
  });

  final ShopController _shopController = Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelectedAddress
          ? () {
              _shopController.selectedAddress = myAddressResponseModel;
              Get.back();
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 15.h,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 15.h,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: AppColors.walletConBGColor, borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _addressData(
                title: "Address Line1",
                value: myAddressResponseModel.addressLine1 ?? ""),
            _addressData(
                title: "Address Line2",
                value: myAddressResponseModel.addressLine2 ?? ""),
            _addressData(
              title: "Land Mark:-",
              value: myAddressResponseModel.landmark ?? "",
            ),
            _addressData(
              title: "Pincode:-",
              value: myAddressResponseModel.pincode ?? "",
            ),
            _addressData(
              title: "City",
              value: myAddressResponseModel.city ?? "",
            ),
            _addressData(
              title: "State",
              value: myAddressResponseModel.state ?? "",
            ),
            _addressData(
              title: "Country",
              value: myAddressResponseModel.country ?? "",
            ),
            if (isEditButtonShow) ...[
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      borderRadius: 8.r,
                      title: "Edit",
                      bgColor: AppColors.white,
                      textColor: AppColors.black,
                      onTap: () {
                        Get.to(
                          () => AddAddressScreen(
                            myAddressResponseModel: myAddressResponseModel,
                          ),
                        );
                      },
                    ),
                  ),
                  // SizedBox(width: 10.w),
                  // Expanded(
                  //   child: CustomButton(
                  //     title: "Remove",
                  //     borderColor: AppColors.primaryColor,
                  //     isShowBorder: true,
                  //     textColor: AppColors.primaryColor,
                  //   ),
                  // ),
                ],
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget _addressData({required String title, required String value}) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
