import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/model/all_product_response_model.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/trade_controller.dart';
import '../../../../enum/error_type.dart';
import '../../../../util/app_constant.dart';
import '../../../common_widget/custom_text_filed.dart';

class ProductDetails extends StatefulWidget {
  AllProductResponseModel allProductResponseModel;

  ProductDetails({required this.allProductResponseModel});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _currentSliderIndex = 0;
  final CarouselController _carouselController = CarouselController();
  List<String> _imageList = [];
  bool isChecked = false;

  @override
  void initState() {
    super.initState();

    _imageList.add(widget.allProductResponseModel.image ?? "");
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
          backgroundColor: AppColors.screenBGColor,
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.all(19.w),
                child: Image.asset(
                  AppImage.icLeftArrow,
                  color: AppColors.white,
                ),
              ),
            ),
            backgroundColor: AppColors.shoppingDetailSrColor,
          ),
          body: GetX<ShopController>(
            builder: (cont) {
              if (cont.error.value.errorType == ErrorType.internet) {
                return Container();
              }
              return Column(
                children: [
                  Expanded(
                    flex: 27,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10.h),
                      // height: 261.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.shoppingDetailSrColor,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(24.r),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        fit: StackFit.expand,
                        children: [
                          Container(
                            // color: AppColors.primaryColor,
                            child: CarouselSlider.builder(
                              carouselController: _carouselController,
                              itemCount: _imageList.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  CustomFadeInImage(
                                url: _imageList[itemIndex],
                                width: double.infinity,
                                // fit: BoxFit.cover,
                              ),
                              options: CarouselOptions(
                                pageSnapping: true,
                                autoPlay: true,
                                enableInfiniteScroll: _imageList.length != 1,
                                height: double.infinity,
                                viewportFraction: 1,
                                autoPlayInterval: const Duration(seconds: 3),
                                onPageChanged:
                                    (int index, CarouselPageChangedReason ca) {
                                  _currentSliderIndex = index;
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.bottomCenter,
                          //   child: Padding(
                          //     padding: EdgeInsets.symmetric(vertical: 5.h),
                          //     child: SizedBox(
                          //       height: 15.h,
                          //       child: ListView.builder(
                          //         itemBuilder:
                          //             (BuildContext? context, int index) {
                          //           return InkWell(
                          //             onTap: () {
                          //               _carouselController.jumpToPage(index);
                          //             },
                          //             child: Container(
                          //               width: 8.w,
                          //               height: 8.w,
                          //               margin: EdgeInsets.symmetric(
                          //                   horizontal: 2.w),
                          //               decoration: BoxDecoration(
                          //                 color: _currentSliderIndex == index
                          //                     ? AppColors.primaryColor
                          //                     : AppColors.lightGray,
                          //                 shape: BoxShape.circle,
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //         itemCount: _imageList.length,
                          //         shrinkWrap: true,
                          //         scrollDirection: Axis.horizontal,
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 73,
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          Text(
                            widget.allProductResponseModel.name ?? "",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          RichText(
                            text: TextSpan(
                              text:
                                  "${AppString.currencySymbol} ${widget.allProductResponseModel.price ?? "0"}  ",
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              children: [
                                if (widget.allProductResponseModel.discount !=
                                        null &&
                                    widget.allProductResponseModel.discount !=
                                        "" &&
                                    widget.allProductResponseModel
                                            .originalPrice !=
                                        widget.allProductResponseModel.price)
                                  TextSpan(
                                    text:
                                        "${AppString.currencySymbol} ${widget.allProductResponseModel.originalPrice ?? ""}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.lightTextColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                if (widget.allProductResponseModel.discount !=
                                        null &&
                                    widget.allProductResponseModel.discount !=
                                        "" &&
                                    widget.allProductResponseModel
                                            .originalPrice !=
                                        widget.allProductResponseModel.price)
                                  TextSpan(
                                    text:
                                        "  ${widget.allProductResponseModel.discount ?? ""}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.greenDiscountFont,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              RatingBar.builder(
                                ignoreGestures: true,
                                itemSize: 20.w,
                                initialRating: double.parse(widget.allProductResponseModel.ratings ?? "0") ,
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
                                  print(rating);
                                },
                              ),
                              Text("(${widget.allProductResponseModel.reviewCount ?? 0} Reviews)",
                              style: TextStyle(
                                color: AppColors.appBarTitelColor
                              ),)
                            ],
                          ),

                          SizedBox(
                            height: 20.h,
                          ),
                          // CustomTextFiled(
                          //   label: "Promo Code",
                          //   hint: "Enter Promo Code",
                          //   hintStyle: TextStyle(
                          //       fontSize: 12.sp,
                          //       fontWeight: FontWeight.w500,
                          //       color: AppColors.textColor),
                          //   suffixIcon: Checkbox(
                          //
                          //     activeColor: AppColors.white,
                          //       side: BorderSide(color: AppColors.white,
                          //         width: 1.5.w
                          //       ),
                          //       checkColor: AppColors.darkBlue,
                          //       value: isChecked,
                          //       onChanged: (value) {
                          //         setState(() {
                          //           isChecked = value!;
                          //         });
                          //       }),
                          // ),
                          // SizedBox(
                          //   height: 12.h,
                          // ),
                          Text(
                            "About this item",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appBarTitelColor,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                             widget.allProductResponseModel.desc ?? "",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textFiledLabelColor,
                            ),),
                          // Html(
                          //   data: widget.allProductResponseModel.desc ?? "",
                          // ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            widget.allProductResponseModel.returnHeading ?? "",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appBarTitelColor,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            widget.allProductResponseModel.returnDetails ?? "",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textFiledLabelColor,
                            ),
                          ),
                          SizedBox(
                            height: 22.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.w),
                            decoration: BoxDecoration(
                              color:AppColors.shoppingWarrntyBGColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 9.5.w , horizontal: 12.5.w),
                                  child: Image.asset(
                                    AppImage.icWarranty,
                                  ),
                                  height: 40.w,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color:Color(0x20FFFFFF),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Warranty",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(height: 3.h,),
                                      Text(
                                        widget.allProductResponseModel
                                                .warrenty ??
                                            "",
                                        style: TextStyle(
                                          fontSize: 12.5.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18.h,
                                  color: AppColors.textColor,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 22.h,
                          ),
                          Text(
                            "Cancellation Policies",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appBarTitelColor,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            widget.allProductResponseModel
                                    .cancellationPolicies ??
                                "",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textFiledLabelColor,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          CustomButton(
                            title: "Add to Cart",
                            bgColor: AppColors.blueButton,
                            textColor: Colors.white,
                            onTap: () {
                              cont.addToCart(
                                  allProductResponseModel:
                                      widget.allProductResponseModel);
                            },
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
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
