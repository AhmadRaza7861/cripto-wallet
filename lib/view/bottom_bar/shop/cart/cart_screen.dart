import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/all_product_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/shop/cart/widget/cart_item_row_widget.dart';
import 'package:crypto_wallet/view/bottom_bar/shop/product_detail/product_detail.dart';
import 'package:crypto_wallet/view/bottom_bar/shop/purchase_screen.dart';
import 'package:crypto_wallet/view/common_widget/api_status_manage_widget.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ShopController _shopController = Get.find();
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _shopController.getViewCart();
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
                  title: Text(
                    "My Cart",
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
          body: GetX<ShopController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return Container();
            }

            return ApiStatusManageWidget(
                apiStatus: cont.cartList.value,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  itemBuilder: (BuildContext context, int index) {
                                    AllProductResponseModel allProductResponseModel =
                                        cont.cartList.value.data[index];
                                    return CartItemRowWidget(
                                      allProductResponseModel: allProductResponseModel,
                                    );
                                  },
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cont.cartList.value.data.length,
                                  padding: EdgeInsets.only(
                                    bottom: 75.h,
                                  ),
                                ),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: AppColors.liteGray,
                                //     borderRadius: BorderRadius.circular(8.r),
                                //   ),
                                //   padding:EdgeInsets.symmetric(horizontal: 8.w, vertical: 13.w),
                                //   child: Row(
                                //     mainAxisSize: MainAxisSize.max,
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Text("Total Amount",
                                //           style: TextStyle(
                                //             color: AppColors.white,
                                //             fontSize: 12.sp,
                                //             fontWeight: FontWeight.w400,
                                //           )),
                                //       Text(
                                //         "${AppString.currencySymbol} ${cont.totalAmount.value.toStringAsFixed(2)}",
                                //         style:  TextStyle(
                                //           color: AppColors.white,
                                //           fontSize: 12.sp,
                                //           fontWeight: FontWeight.w400,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Center(
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8.r),
                    //             color: AppColors.white,
                    //             border: Border.all(color:AppColors.borderColor,
                    //             width: 1.w),
                    //           ),
                    //           child: Text(
                    //             "Check out",
                    //             style: TextStyle(
                    //               color: AppColors.blueButton,
                    //               fontWeight: FontWeight.w700,
                    //               fontSize: 12.sp,
                    //             ),
                    //           ),
                    //           // padding: EdgeInsets.symmetric(vertical: 13.h),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(width: 17.w,),
                    //     Expanded(
                    //       child: Center(
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8.r),
                    //             color:Colors.transparent,
                    //             border: Border.all(color:AppColors.borderColor,
                    //             width: 1.w),
                    //           ),
                    //           child: Text(
                    //             "Select Address",
                    //             style: TextStyle(
                    //               color: AppColors.white,
                    //               fontWeight: FontWeight.w700,
                    //               fontSize: 12.sp,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),


                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 20.h),
                      child: CustomButton(
                        bgColor: AppColors.blueButton,
                        borderRadius: 10.r,
                        height: 40.h,
                        titleWidget: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            children: [
                              Text(
                                "${AppString.currencySymbol} ${cont.totalAmount.value.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
                                "Check Out",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.white,
                                size: 20.w,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Get.to(
                            () => const PurchaseScreen(),
                          );
                        },
                      ),
                    ),
                  ],
                ));
          }),
        ),
      ],
    );
  }
}
