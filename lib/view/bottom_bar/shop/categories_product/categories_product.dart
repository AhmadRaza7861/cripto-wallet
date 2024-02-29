import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/model/all_product_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/shop/cart/cart_screen.dart';
import 'package:crypto_wallet/view/common_widget/api_status_manage_widget.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../enum/error_type.dart';
import '../../../../model/Banner_Model.dart';
import '../../../../model/categories_model.dart';
import '../product_detail/product_detail.dart';

class CategoriesProductScreen extends StatefulWidget {
  CategoriesMoldel? categoryProduct;
   CategoriesProductScreen({Key? key, this.categoryProduct}) : super(key: key);

  @override
  State<CategoriesProductScreen> createState() => _CategoriesProductScreenState();
}

class _CategoriesProductScreenState extends State<CategoriesProductScreen> {
  final GlobalKey _categorySearchKey = GlobalKey();
  double _categorySearchSize = 0;
  final ShopController _shopController = Get.find();
  Widget _appBarTitle =  Text( "");
  Icon _actionIcon = const Icon(Icons.search);
  final HomeController _homeController = Get.find();
  @override
  void initState() {
    super.initState();
     _appBarTitle =  Text( "${widget.categoryProduct?.name}",
      style: TextStyle(
        color: AppColors.appBarTitelColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ), );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      Size? size = _categorySearchKey.currentContext?.size;
      _categorySearchSize = size?.height ?? 0;
      setState(() {});
      await _shopController.getCategoriesProduct(widget.categoryProduct?.id);
      // await _shopController.getBanners();
      // await _shopController.getCategories();
      // await _shopController.getViewCart();
      print(" imageimage ======    ]] ${_shopController.bannerList.value.data[0].image}");
    });
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return GetX<ShopController>(builder: (cont) {
      if (cont.error.value.errorType == ErrorType.internet) {
        return Container();
      }
      return WillPopScope(
        onWillPop: () {
          if (_actionIcon.icon != Icons.search) {
            _shopController.searchController.clear();
            _actionIcon = const Icon(Icons.search);
            _appBarTitle =  Text(widget.categoryProduct?.name ?? "" );
            setState(() {});
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Stack(
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
                preferredSize:
                Size.fromHeight(70.0.h), // here the desired height
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      title: _appBarTitle,
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
                      centerTitle: true,
                      actions: [
                        Row(
                          children: [
                            Container(
                              height: 34.w,
                              width: 34.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppColors.bgColorCon),
                              child: IconButton(
                                icon: Image.asset(AppImage.icSearch , color: AppColors.appBarTitelColor),
                                onPressed: () {
                                  setState(() {
                                    if (_actionIcon.icon == Icons.search) {
                                      _actionIcon = const Icon(Icons.close);
                                      _appBarTitle = TextField(
                                        controller:
                                        _shopController.searchController,
                                        autofocus: true,
                                        cursorColor: AppColors.appBarTitelColor,
                                        style:  TextStyle(
                                          color: AppColors.appBarTitelColor,
                                        ),
                                        onChanged: (s) {
                                          setState(() {});
                                        },
                                        decoration:  InputDecoration(
                                            prefixIcon: Icon(Icons.search,
                                                color: AppColors.appBarTitelColor),
                                            hintText: "Search...",
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.appBarTitelColor,
                                              ),
                                            ),
                                            disabledBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.appBarTitelColor,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.appBarTitelColor,
                                              ),
                                            ),
                                            hintStyle:
                                            TextStyle(color: AppColors.appBarTitelColor)),
                                      );
                                    } else {
                                      _shopController.searchController.clear();
                                      _actionIcon = Icon(Icons.search ,color: AppColors.appBarTitelColor);
                                      _appBarTitle = Text(
                                        widget.categoryProduct?.name ?? "",
                                        style: TextStyle(
                                          color: AppColors.appBarTitelColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 11.w),
                              height: 34.w,
                              width: 34.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppColors.bgColorCon),
                              child: IconButton(
                                onPressed: () {
                                  Get.to(() => CartScreen());
                                },
                                icon: badges.Badge(
                                  position: BadgePosition.topEnd(
                                      top: -5.h, end: -10.w),
                                  badgeStyle: badges.BadgeStyle(
                                    shape: BadgeShape.circle,
                                    badgeColor: AppColors.primaryColor,
                                  ),

                                  badgeContent: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "${cont.cartList.value.data.length}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.sp,
                                      ),
                                    ),
                                  ),
                                  child: Image.asset(
                                    AppImage.icBag,
                                    color: AppColors.appBarTitelColor,
                                    width: 16.w,
                                    height: 21.h,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body:  SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ApiStatusManageWidget(
                        height: 0.6.sh,
                        apiStatus: cont.categoriesProductList.value,
                        child: MasonryGridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15.w,
                          crossAxisSpacing: 15.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 15.h),
                          itemCount: cont.categoriesProductList.value.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            AllProductResponseModel allProductResponseModel =
                            cont.categoriesProductList.value.data[index];
                            return InkWell(
                              onTap: () {
                                Get.to(() => ProductDetails(
                                  allProductResponseModel:
                                  allProductResponseModel,
                                ));
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  // color: AppColors.backWhite,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12.r)),
                                    border: Border.all(
                                        color: AppColors.withDrawBorderColor)),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.bgColorCon,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(17.r),topRight: Radius.circular(17.r)),

                                          ),
                                          // color: AppColors.bgColor,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(topLeft:Radius.circular(12.r), topRight:Radius.circular(12.r),),
                                            child: CustomFadeInImage(
                                              url: allProductResponseModel
                                                  .image ??
                                                  "",
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.w),
                                          decoration: BoxDecoration(
                                            color: AppColors.shoppingCardColor,
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.r),bottomLeft: Radius.circular(12.r)),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          allProductResponseModel
                                                              .name ??
                                                              "",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: AppColors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // InkWell(
                                                  //   onTap: () {
                                                  //     cont.addToCart(
                                                  //         allProductResponseModel:
                                                  //             allProductResponseModel);
                                                  //   },
                                                  //   child: Image.asset(
                                                  //     AppImage.icAddToCart,
                                                  //     width: 24.w,
                                                  //     color: AppColors.primaryColor,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.symmetric(vertical: 6.h),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    RatingBar.builder(
                                                      itemSize: 14.w,
                                                      initialRating: 3,
                                                      minRating: 1,
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
                                                    SizedBox(width: 3.w,),
                                                    Text(
                                                      "(4 Reviews)",
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: AppColors.white,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${AppString.currencySymbol} ${allProductResponseModel.price ?? "0"}",
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: AppColors.white,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.only(top: 6.5.w),
                                                child: Row(
                                                  children: [
                                                    if (allProductResponseModel
                                                        .discount !=
                                                        null &&
                                                        allProductResponseModel
                                                            .discount !=
                                                            "" &&
                                                        allProductResponseModel
                                                            .originalPrice !=
                                                            allProductResponseModel
                                                                .price)  Text(
                                                      "${AppString.currencySymbol} ${allProductResponseModel.originalPrice ?? "0"}",
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: AppColors.lightTextColor,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.symmetric(
                                        //       horizontal: 5.w),
                                        //   child: Row(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.end,
                                        //     children: [
                                        //       Text(
                                        //         "${AppString.currencySymbol} ${allProductResponseModel.price ?? "0"}",
                                        //         style: TextStyle(
                                        //           fontSize: 13.sp,
                                        //           fontFamily: "Roboto",
                                        //           color: AppColors.black,
                                        //         ),
                                        //       ),
                                        //       SizedBox(
                                        //         width: 5.w,
                                        //       ),
                                        //       if (allProductResponseModel
                                        //                   .discount !=
                                        //               null &&
                                        //           allProductResponseModel
                                        //                   .discount !=
                                        //               "" &&
                                        //           allProductResponseModel
                                        //                   .originalPrice !=
                                        //               allProductResponseModel
                                        //                   .price)
                                        //         Expanded(
                                        //           child: Text(
                                        //             "${AppString.currencySymbol} ${allProductResponseModel.originalPrice ?? ""}",
                                        //             style: TextStyle(
                                        //               fontSize: 9.sp,
                                        //               fontFamily: "Roboto",
                                        //               color:
                                        //                   AppColors.hintColor,
                                        //               decoration: TextDecoration
                                        //                   .lineThrough,
                                        //             ),
                                        //           ),
                                        //         ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   height: 5.h,
                                        // )
                                      ],
                                    ),
                                    if (allProductResponseModel.discount !=
                                        null &&
                                        allProductResponseModel.discount !=
                                            "" &&
                                        allProductResponseModel.originalPrice !=
                                            allProductResponseModel.price)
                                      Positioned(
                                        top: 7.h,
                                        left: -13.w,
                                        child: Transform.rotate(
                                          angle: -0.7,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 2.h),
                                            decoration: BoxDecoration(
                                                color:
                                                AppColors.closeWordColor),
                                            child: Text(
                                              allProductResponseModel
                                                  .discount ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontFamily: "Roboto",
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))

                    /*GridView.builder(
                      padding: EdgeInsets.only(
                          right: 15.w, left: 15.w, bottom: 15.h, top: 15.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        mainAxisSpacing: 15.w,
                        crossAxisSpacing: 15.w,
                      ),
                      itemCount: cont.categoriesProductList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        AllProductResponseModel allProductResponseModel =
                        cont.categoriesProductList[index];
                        return InkWell(
                          onTap: () {
                            Get.to(() => ProductDetails(
                              allProductResponseModel: allProductResponseModel,
                            ));
                          },
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: AppColors.backWhite,
                                boxShadow: [
                                  AppBoxShadow.defaultShadow(),
                                ],
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.r)),
                                border: Border.all(color: AppColors.shadowColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      // borderRadius: BorderRadius.all(
                                      //   Radius.circular(8.r),
                                      // ),
                                      color: AppColors.itemDetailsColor,
                                    ),
                                    // color: AppColors.bgColor,
                                    child: CustomFadeInImage(
                                      url: allProductResponseModel.image ?? "",
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            allProductResponseModel.name ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: "Roboto",
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "\u{20B9}${allProductResponseModel.price ?? "0"}",
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontFamily: "Roboto",
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              if (allProductResponseModel
                                                  .discount !=
                                                  null)
                                                Text(
                                                  allProductResponseModel
                                                      .discount ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontFamily: "Roboto",
                                                    color: AppColors.discountColor,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        cont.addToCart(
                                            allProductResponseModel:
                                            allProductResponseModel);
                                      },
                                      child: Image.asset(
                                        AppImage.icAddToCart,
                                        width: 24.w,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 7.w),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
