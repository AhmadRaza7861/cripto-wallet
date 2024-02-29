import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/my_order_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_orders/my_order_details/my_order_details_screen.dart';
import 'package:crypto_wallet/view/common_widget/api_status_manage_widget.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final ShopController _shopController = Get.find();
  final HomeController _homeController = Get.find();
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy hh:mm:ss aa");
  final DateTime _nowDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _shopController.getMyOrder();
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
                  title: Text(
                    "My Order",
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
                apiStatus: cont.myOrderList.value,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    Order order = cont.myOrderList.value.data[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        // horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: AppColors.walletConBGColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _orderDetailRow(
                              title: "Placed On:-",
                              value:
                                  "${_dateFormat.format(order.orderDate ?? DateTime.now())}"),
                          _orderDetailRow(
                              title: "Total Items:-",
                              value:
                                  "${order.products.length}"),
                          _orderDetailRow(
                              title: "Total Amount:-",
                              value:
                                  "${order.amount ?? "0"}"),
                          _orderDetailRow(
                              title: "Order ID:-",
                              value:
                                  "${order.invoiceNo ?? "0"}"),
                          // Text(
                          //   "Placed on ${_dateFormat.format(order.orderDate ?? DateTime.now())}",
                          //   style: TextStyle(
                          //     fontSize: 12.sp,
                          //     color: AppColors.white,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Text(
                          //         "${order.products.length} Items",
                          //         style: TextStyle(
                          //           fontSize: 14.sp,
                          //           color: AppColors.white,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //       ),
                          //     ),
                          //     Text(
                          //       "${order.amount ?? "0"}",
                          //       style: TextStyle(
                          //         fontSize: 18.sp,
                          //         color: AppColors.white,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 5.h),
                          // Text(
                          //   "Order ID : ${order.invoiceNo ?? "0"}",
                          //   style: TextStyle(
                          //     fontSize: 12.sp,
                          //     color: AppColors.white,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // SizedBox(height: 10.h),
                          SizedBox(height: 8.h,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: CustomButton(
                              borderRadius: 8.r,
                              title: "View Details",
                              bgColor: AppColors.white,
                              textColor: AppColors.black,
                              onTap: () {
                                Get.to(() => MyOrderDetailsScreen(order: order));
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: cont.myOrderList.value.data.length,
                ));
          }),
        ),
      ],
    );
  }

  Widget _orderDetailRow({String? title, String? value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? "",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value ?? "",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
