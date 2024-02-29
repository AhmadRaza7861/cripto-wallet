import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_wallet/model/all_product_response_model.dart';
import 'package:crypto_wallet/model/my_order_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_orders/my_order_details/widget/rate_us_bottom_sheet.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';

import '../../../../../controller/home_controller.dart';
import '../../../../../controller/shop_controller.dart';

class MyOrderDetailsScreen extends StatefulWidget {
  Order order;

  MyOrderDetailsScreen({required this.order});

  @override
  State<MyOrderDetailsScreen> createState() => _MyOrderDetailsScreenState();
}

class _MyOrderDetailsScreenState extends State<MyOrderDetailsScreen> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy 'at' hh:mm:ss aa");
  final ShopController shopController = Get.find();

  @override
  void initState() {
    super.initState();

    _orderIdController.text = widget.order.invoiceNo ?? "0";
    _dateController.text =
        _dateFormat.format(widget.order.orderDate ?? DateTime.now());
    _addressController.text = widget.order.address ?? "";
    _amountController.text = widget.order.amount ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find();

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
                  title: Text(
                    "Order Details",
                    style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  centerTitle: true,
                ),
              ],
            ),
          ),

          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 18.h, horizontal: 18.w),
                  decoration: BoxDecoration(
                    color: AppColors.walletConBGColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImage.icReceiptText,
                            width: 16.w,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order ID:-",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${widget.order.invoiceNo ?? "0"}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImage.icCalendar,
                            width: 16.w,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date & Time:-",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${_dateFormat.format(widget.order.orderDate ?? DateTime.now())}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImage.icReceiptText,
                            width: 16.w,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Address:-",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    width: 0.4.sw,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${widget.order.address ?? "0"}",
                                          maxLines: 3,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Divider(
                        color: AppColors.dividerColor,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 90.w,
                            child: Text(
                              "Amount:",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,),
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            "${AppString.currencySymbol} ${widget.order.amount ?? "0"}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Order Items :- ",
                  style: TextStyle(
                    color: AppColors.appBarTitelColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext conrtext, int index) {
                    Product product = widget.order.products[index];
                    AllProductResponseModel allProductResponseModel =
                        product.itemDetails ?? AllProductResponseModel();
                    return Container(
                      padding: EdgeInsets.all(12.w),
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.cartCardBGColor
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: AppColors.white
                            ),
                            child: CustomFadeInImage(
                              url: allProductResponseModel.image ?? "",
                              width: 84.w,
                              height: 84.w,
                              fit: BoxFit.cover,
                            ),
                            clipBehavior: Clip.antiAlias,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 5.h,
                                bottom: 5.h,
                                left: 5.w,
                                right: 10.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    allProductResponseModel.name ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: AppColors.white
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    "Qty : ${product.orderQuantity ?? "0"}",
                                    style: TextStyle(
                                      color: AppColors.textfieldTextColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    "Price : ${AppString.currencySymbol} ${allProductResponseModel.price ?? "0"}",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                    Row(
                                      children: [
                                        if (allProductResponseModel.discount != null &&
                                            allProductResponseModel.discount != "" &&
                                            allProductResponseModel.originalPrice !=
                                                allProductResponseModel.price) RichText(
                                            text: TextSpan(
                                              text:
                                              "${AppString.currencySymbol} ${allProductResponseModel.originalPrice ?? ""}",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.cartDispriceColor,
                                                fontWeight: FontWeight.w400,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            )),
                                        Expanded(child: Container()),
                                        InkWell(
                                          onTap:(){
                                            Get.bottomSheet(
                                              RateUsBottomSheet(allProductResponseModel:allProductResponseModel ),
                                              isScrollControlled: true,
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5.r),
                                                color: AppColors.walletConBGColor
                                            ),
                                            padding:EdgeInsets.all(4.w),
                                            child: Text(
                                                "Rate Us",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.order.products.length,
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
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
          Container(
            child: Row(
              children: [
                Text(
                  title ?? "",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
