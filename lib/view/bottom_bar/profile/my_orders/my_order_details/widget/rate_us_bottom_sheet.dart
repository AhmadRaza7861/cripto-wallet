import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/wallet_controller.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../controller/shop_controller.dart';
import '../../../../../../model/all_product_response_model.dart';
import '../../../../../common_widget/custom_fade_in_image.dart';

class RateUsBottomSheet extends StatefulWidget {
  AllProductResponseModel? allProductResponseModel;
  RateUsBottomSheet({this.allProductResponseModel});

  @override
  State<RateUsBottomSheet> createState() => _RateUsBottomSheetState();
}

class _RateUsBottomSheetState extends State<RateUsBottomSheet> {
  final TextEditingController _reviewController = TextEditingController();
  final HomeController _homeController = Get.find();
  final ShopController _shopController = Get.find();
  double newReview = 0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _shopController.viewReview(widget.allProductResponseModel?.id);
      print("  viewProductReview  ==  ${_shopController.viewProductReview.value.data.first.stars}");
      _reviewController.text = _shopController.viewProductReview.value.data.first.review ?? "";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bottomSheetBG,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            30.r,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15.h),
            Container(
              width: 100.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            SizedBox(height: 25.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.white
                  ),
                  child: CustomFadeInImage(
                    url: widget.allProductResponseModel?.image ?? "",
                    width: 50.w,
                    height: 50.w,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          widget.allProductResponseModel?.name ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: AppColors.textfieldTextColor
                          ),
                        ),
                        SizedBox(height: 3.h),
                        RatingBar.builder(
                          // ignoreGestures: true,
                          itemSize: 25.w,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:EdgeInsets.zero,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            // size: 5.w,
                          ),
                          onRatingUpdate: (rating) {
                            newReview = rating;
                            print(rating);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15.h),
            CustomTextFiled(
              controller: _reviewController,
              hint: "Write your review",
              minLines:4 ,
            ),
            CustomButton(
              title: "Submit",
              onTap: () async {
                if(newReview <= 0){
                  _shopController.showError(msg: "please select star");}
                else if ( _reviewController.text.isEmpty || _reviewController == "" ){
                  _shopController.showError(msg: "please write your review");
                }else{
                  _shopController.sendReview(widget.allProductResponseModel?.id , _reviewController.text ,newReview );}
              },
            ),
            SizedBox(height: 25.h),
          ],
        ),
      ),

    );
  }
}
