import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/model/all_product_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/shop/product_detail/product_detail.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartItemRowWidget extends StatefulWidget {
  AllProductResponseModel allProductResponseModel;

  CartItemRowWidget({required this.allProductResponseModel});

  @override
  State<CartItemRowWidget> createState() => _CartItemRowWidgetState();
}

class _CartItemRowWidgetState extends State<CartItemRowWidget> {
  final ShopController _shopController = Get.find();

  @override
  Widget build(BuildContext context) {
    AllProductResponseModel allProductResponseModel =
        widget.allProductResponseModel;
    return InkWell(
      onTap: () {
        Get.to(() =>
            ProductDetails(allProductResponseModel: allProductResponseModel));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(12.w),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.cartCardBGColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: CustomFadeInImage(
                url: allProductResponseModel.image ?? "",
                width: 90.w,
                height: 90.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 5.h,
                  bottom: 5.h,
                  left: 5.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            allProductResponseModel.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _shopController.removeFromCart(
                              allProductResponseModel: allProductResponseModel,
                            );
                          },
                          child: Container(
                            height: 27.w,
                            width: 27.w,
                            decoration: BoxDecoration(
                              color: AppColors.lightGray10,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            padding: EdgeInsets.all(5.5.w),
                            child: Icon(
                              Icons.delete,
                              color: AppColors.white,
                              size: 17.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppString.currencySymbol} ${allProductResponseModel.price ?? "0"}",
                              style: TextStyle(
                                color: AppColors.cartpriceColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            if (allProductResponseModel.discount != null &&
                                allProductResponseModel.discount != "" &&
                                allProductResponseModel.originalPrice !=
                                    allProductResponseModel.price)
                              RichText(
                                  text: TextSpan(
                                text:
                                    "${AppString.currencySymbol} ${allProductResponseModel.originalPrice ?? ""}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.cartDispriceColor,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                //     children: [
                                // TextSpan(
                                //   text:"${"40% off"}",
                                // style: TextStyle(
                                //     fontSize: 12.sp,
                                //     color: AppColors.greenDiscountFont,
                                //     fontWeight: FontWeight.w400
                                // ),
                                // )
                                // ]
                              )),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  _shopController.manualQty(
                                    allProductResponseModel:
                                        allProductResponseModel,
                                    qty: ((allProductResponseModel.quantity ??
                                            0) -
                                        1),
                                  );
                                },
                                child: Image.asset(
                                  AppImage.icMinus,
                                  width: 22.w,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "${allProductResponseModel.quantity ?? 0}",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              InkWell(
                                onTap: () {
                                  _shopController.manualQty(
                                    allProductResponseModel:
                                        allProductResponseModel,
                                    qty: ((allProductResponseModel.quantity ??
                                            0) +
                                        1),
                                  );
                                },
                                child: Image.asset(
                                  AppImage.icPlus,
                                  width: 22.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
