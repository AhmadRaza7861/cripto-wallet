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
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../enum/error_type.dart';
import '../../../model/Banner_Model.dart';
import '../../../model/categories_model.dart';
import 'categories_product/categories_product.dart';
import 'product_detail/product_detail.dart';


class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final GlobalKey _categorySearchKey = GlobalKey();
  double _categorySearchSize = 0;
  int currentPos = 0 ;
  final CarouselController _controller = CarouselController();

  final ShopController _shopController = Get.find();
  Widget _appBarTitle =  Text("Shop" ,
    style: TextStyle(
    color: AppColors.appBarTitelColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  ), );
  Icon _actionIcon = const Icon(Icons.search);
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Size? size = _categorySearchKey.currentContext?.size;
      _categorySearchSize = size?.height ?? 0;
      setState(() {});
      await _shopController.getAllProduct();
      await _shopController.getBanners();
      await _shopController.getCategories();
      await _shopController.getViewCart();
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
            _appBarTitle = const Text("Shop");
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
              // appBar: AppBar(
              //   centerTitle: true,
              //   title: Text(
              //     "Shop",
              //     style: TextStyle(
              //       color: AppColors.white,
              //       fontSize: 18.sp,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              //   actions: [
              //     Container(
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(8.r),
              //           color: AppColors.liteGray),
              //       padding: EdgeInsets.all(20.w),
              //       child: Image.asset(
              //         AppImage.icCoinMenu,
              //       ),
              //     ),
              //   ],
              // ),
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(70.0.h), // here the desired height
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      title: _appBarTitle,
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
                                        "Shop",
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
                    Stack(

                      children: [
                        CarouselSlider.builder(
                          options: CarouselOptions(
                              viewportFraction: .9,
                              height: 170.h,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              pageSnapping: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentPos = index;
                                });
                              }
                          ),
                          itemCount: cont.bannerList.value.data.length,
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            if (cont.bannerList.value.data.isNotEmpty){
                              BannerModel banner = cont.bannerList.value.data[index] ;

                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: AppColors.shoppingCardColor),
                                width: 1.sw,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: CustomFadeInImage(
                                    url: banner.image ?? "",
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  ),
                                ),
                              );
                            }
                            else{
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                        Positioned(
                          bottom: 7.h,
                          left: 0.w,
                          right: 0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  cont.bannerList.value.data.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 8.w,
                                  height: 8.w,
                                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentPos == entry.key ? AppColors.primaryColor : AppColors.white.withOpacity(0.5)
                                  ),

                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    // Center(
                    //   key: _categorySearchKey,
                    //   child: Stack(
                    //     children: [
                    //       // if (_categorySearchSize != 0)
                    //       //   Container(
                    //       //     height: (_categorySearchSize / 2) + 5.h,
                    //       //     color: AppColors.lightGray,
                    //       //   ),
                    //       Container(
                    //         padding: EdgeInsets.symmetric(
                    //           horizontal: 15.w,
                    //           vertical: 2.w,
                    //         ),
                    //         margin: EdgeInsets.only(
                    //             left: 40.w, right: 40.w, top: 10.h, bottom: 5.h),
                    //         decoration: BoxDecoration(
                    //           color: Colors.transparent,
                    //           borderRadius: BorderRadius.circular(25.r),
                    //           border: Border.all(color: Colors.white)
                    //           /*  boxShadow: [
                    //             BoxShadow(
                    //                 color: AppColors.gray.withOpacity(
                    //                   0.5,
                    //                 ),
                    //                 blurRadius: 0.5.r,
                    //                 spreadRadius: 0.5.r,
                    //                 offset: const Offset(0.5, 0.5))
                    //           ],
                    //         */
                    //         ),
                    //         // width: ,
                    //         // height: size.height * 0.065,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Image.asset(
                    //               AppImage.icSearch,
                    //               width: 16.w,
                    //               height: 16.w,
                    //               color: AppColors.white,
                    //             ),
                    //             SizedBox(
                    //               width: 10.w,
                    //             ),
                    //             Expanded(
                    //               child: TextField(
                    //                 controller: cont.searchController,
                    //                 decoration:  InputDecoration(
                    //                   hintText: "Search Product",
                    //                   border: InputBorder.none,
                    //                   focusColor: AppColors.black,
                    //                   hintStyle: TextStyle(color:AppColors.white.withOpacity(0.8)),
                    //                 ),
                    //                 style: TextStyle(
                    //                   color: AppColors.white,
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      // color: AppColors.closeWordColor,
                      margin: EdgeInsets.symmetric(horizontal: 9.w),
                      // padding: EdgeInsets.symmetric(vertical: 5.w),
                      height: 61.5.h,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cont.categoriesList.value.data.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if(cont.categoriesList.value.data.isNotEmpty){
                              CategoriesMoldel categories = cont.categoriesList.value.data[index] ;

                              return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              child: InkWell(
                                onTap: (){
                                  print(" categories.id    == === ${categories.id}");
                                  Get.to(()=>CategoriesProductScreen(categoryProduct:categories ,));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.r)),
                                      height: 50.w,
                                      width: 50.w,
                                      child: ClipRRect(
                                        child: CustomFadeInImage(
                                          url: categories.image ?? "",
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100.r),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      "${categories.name}",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.appBarTitelColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );}
                            else {
                              return Center(
                                child: SizedBox(
                                  height: 25.w,
                                  width: 25.w,
                                    child: CircularProgressIndicator()),
                              );
                            }
                          }),
                    ),
                    ApiStatusManageWidget(
                        height: 0.6.sh,
                        apiStatus: cont.allProductList.value,
                        child: MasonryGridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15.w,
                          crossAxisSpacing: 15.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 15.h),
                          itemCount: cont.allProductList.value.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            AllProductResponseModel allProductResponseModel =
                                cont.allProductList.value.data[index];
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
                                        BorderRadius.all(Radius.circular(18.r)),
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
                                            borderRadius: BorderRadius.only(topLeft:Radius.circular(18.r), topRight:Radius.circular(18.r),),
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
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(17.r),bottomLeft: Radius.circular(17.r)),
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
                                                      ignoreGestures: true,
                                                      itemSize: 14.w,
                                                      initialRating: double.parse(cont.allProductList.value.data[index].ratings ?? "0") ,
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
                                                      "(${cont.allProductList.value.data[index].reviewCount ?? 0} Reviews)",
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
                      itemCount: cont.allProductList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        AllProductResponseModel allProductResponseModel =
                        cont.allProductList[index];
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
