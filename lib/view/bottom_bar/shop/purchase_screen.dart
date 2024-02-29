import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/model/my_address_response_model.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_address/my_address_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_address/widget/my_address_item_widget.dart';
import 'package:crypto_wallet/view/common_widget/api_status_manage_widget.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../enum/error_type.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final ShopController _shopController = Get.find();
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    // _shopController.addressController.clear();
    // _shopController.addressController.text =
    //     _userController.userResponseModel.value.user?.address ?? "";
    _shopController.selectedAddress = null;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getMyAddress();
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
          // appBar: AppBar(
          //   title: const Text("Check Out"),
          // ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0.h), // here the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  centerTitle: true,
                  leading: InkWell(
                    onTap: () {
                      Get.back();
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
                  title: Text("Check Out",
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),),
                ),
              ],
            ),
          ),

          body: GetX<UserController>(builder: (userCont) {
            if (userCont.error.value.errorType == ErrorType.internet) {
              return Container();
            }
            return GetX<ShopController>(builder: (cont) {
              if (cont.error.value.errorType == ErrorType.internet) {
                return Container();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Address",
                      style: TextStyle(
                        color: AppColors.appBarTitelColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (cont.selectedAddress == null) ...[
                      SizedBox(height: 15.h),
                      CustomButton(
                        title: "Select Address",
                        onTap: () {
                          Get.to(() => MyAddressScreen(isSelectAddress: true,))
                              ?.then((value) => setState(() {}));
                        },
                      ),
                    ] else
                      MyAddressItemWidget(
                        myAddressResponseModel:
                            cont.selectedAddress ?? MyAddressResponseModel(),isEditButtonShow: false,
                      ),
                    // ApiStatusManageWidget(
                    //   apiStatus: userCont.myAddressList.value,
                    //   child: ListView.builder(
                    //     itemBuilder: (BuildContext context, int index) {
                    //       MyAddressResponseModel myAddressResponseModel =
                    //           userCont.myAddressList.value.data[index];
                    //       return MyAddressItemWidget(
                    //           myAddressResponseModel: myAddressResponseModel);
                    //     },
                    //     itemCount: userCont.myAddressList.value.data.length,
                    //     shrinkWrap: true,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: CustomButton(
                        height: 40.h,
                        titleWidget: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(

                            children: [
                              Text(
                                "${AppString.currencySymbol} ${cont.totalAmount.value.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.buttonTitleColor
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
                                "Place Order",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                    color: AppColors.buttonTitleColor

                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.buttonTitleColor,
                                size: 20.w,
                              )
                            ],
                            // mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                        onTap: () {
                          cont.placeOrder();
                        },
                        // textColor:AppColors.appBarTitelColor,
                        // titleTextSize:16.sp ,
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              );
            });
          }),
        ),
      ],
    );
  }

  Widget _addressData({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
