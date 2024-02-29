import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/my_address_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_address/add_address_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_address/widget/my_address_item_widget.dart';
import 'package:crypto_wallet/view/common_widget/api_status_manage_widget.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyAddressScreen extends StatefulWidget {
  bool isSelectAddress;

  MyAddressScreen({this.isSelectAddress = false});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
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
          backgroundColor:AppColors.screenBGColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0.h), // here the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
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
                    "My Address",
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
          body: GetX<UserController>(
            builder: (cont) {
              if (cont.error.value.errorType == ErrorType.internet) {
                return Container();
              }
              return Stack(
                fit: StackFit.expand,
                alignment: Alignment.bottomCenter,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ApiStatusManageWidget(
                            apiStatus: cont.myAddressList.value,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                MyAddressResponseModel myAddressResponseModel =
                                    cont.myAddressList.value.data[index];
                                return MyAddressItemWidget(
                                  myAddressResponseModel: myAddressResponseModel,
                                  isSelectedAddress: widget.isSelectAddress,
                                  isEditButtonShow: true,
                                );
                              },
                              itemCount: cont.myAddressList.value.data.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          // CustomButton(
                          //   title: "Add new address",
                          //   onTap: () {
                          //     Get.to(() => AddAddressScreen());
                          //   },
                          // ),
                        ],
                      ),

                    ),
                  ),
                  Align(
                    alignment:Alignment.bottomCenter,
                    child: Container(
                      child: CustomButton(
                        borderRadius: 10.r,
                        width: .8.sw,
                        height: 40.h,
                        title: "Add new address",
                        onTap: () {
                          Get.to(() => AddAddressScreen());
                        },
                      ),
                      padding: EdgeInsets.only(bottom: 15.h),
                    ),
                  ),
                ],
              );

            },
          ),
        ),
      ],
    );
  }
}
