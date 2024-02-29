import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/predict_and_win/predict_and_win_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/quiz_screen/quiz_question_select.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/spinner/spinning_wheel_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/stacking_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/swap_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/your_staks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../profile/my_coupon/my_coupon_screen.dart';

class RewardsCoinInfoScreen extends StatefulWidget {
  const RewardsCoinInfoScreen({Key? key}) : super(key: key);

  @override
  State<RewardsCoinInfoScreen> createState() => _RewardsCoinInfoScreenState();
}

class _RewardsCoinInfoScreenState extends State<RewardsCoinInfoScreen> {
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
        DefaultTabController(
          initialIndex: 0,
          length: 4,
          child: Scaffold(
            backgroundColor: AppColors.screenBGColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(75.0.h), // here the desired height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AppBar(
                        centerTitle: true,
                        title: Text(
                          "Earn",
                         // "Coin Info",
                          style: TextStyle(
                            color: AppColors.appBarTitelColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        bottom:  TabBar(
                          indicatorColor: AppColors.primaryColor,
                          tabs: <Widget>[
                            Tab(
                              child: Text("Swap",
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                             // text: "Swap",
                            ),
                            Tab(
                              child: Text("Staking",
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                             // text: "Staking",
                            ),
                            Tab(
                              child: Text("Your Stakes",
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                             // text: "Your Stakes",
                            ),
                            Tab(
                              child: Text("Coin Info",
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            // text: "Coin Info",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // body: SfPdfViewer.asset(AppPdf.rewards),
            body:  TabBarView(
              children: <Widget>[
                SwapScreen(screenHeight: MediaQuery.of(context).size.height),
                StackingScreen(),
                YourStaksScreen(),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => SpinningWheelScreen());
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: AppColors.walletConBGColor),
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImage.icSpinner,
                                        height: 24.w,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        "Spinner",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => const QuizQuestion());
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: AppColors.walletConBGColor),
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImage.icQuiz,
                                        height: 24.w,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        "Quiz",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => const PredictAndWinScreen());
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: AppColors.walletConBGColor),
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImage.icPrediction,
                                        height: 24.w,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        "Prediction",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const MyCouponScreen());
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 18.w),
                          padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                          decoration: BoxDecoration(
                            color: AppColors.walletConBGColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Win \nrewards everyday",
                                      // "Reward & \nRecognition Quots",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        "Rewards",
                                        style: TextStyle(
                                            color: AppColors.darkBlue,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      AppImage.icCoupons,
                                      height: 110.h,
                                      width: 142.w,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          "User benefits REWARDS:",
                          style: TextStyle(
                            color: AppColors.walletTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          "If a user is maintaining 10000 ${AppString.currencySymbol} In his account regularly they will be getting 500 ${AppString.currencySymbol} monthly as a Balance Maintaining Rewards.",
                          style: TextStyle(
                            color: AppColors.walletSubTextColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: AppColors.lightGray10,
                            borderRadius: BorderRadius.circular(15.r)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.withDrawButtonBGColor,
                                        borderRadius: BorderRadius.circular(8.r)),
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppImage.icCoin,
                                            width: 18.w,
                                            height: 24.h,
                                            color: AppColors.withDrawButtonTextColor,
                                          ),
                                          SizedBox(width: 5.w),
                                          Text(
                                            "Maintain ${AppString.currencySymbol}",
                                            style: TextStyle(
                                              color:
                                              AppColors.withDrawButtonTextColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    decoration: BoxDecoration(
                                        color: AppColors.withDrawButtonBGColor,
                                        borderRadius: BorderRadius.circular(8.r)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppImage.icCoin,
                                            width: 18.w,
                                            height: 24.h,
                                            color: AppColors.withDrawButtonTextColor,
                                          ),
                                          SizedBox(width: 5.w),
                                          Text(
                                            "Reward ${AppString.currencySymbol}",
                                            style: TextStyle(
                                              color:
                                              AppColors.withDrawButtonTextColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            _rewardRowWidget(maintain: "25000", reward: "1500"),
                            _rewardRowWidget(maintain: "50000", reward: "3500"),
                            _rewardRowWidget(maintain: "100000", reward: "10000"),
                            _rewardRowWidget(maintain: "200000", reward: "25000"),
                            _rewardRowWidget(maintain: "500000", reward: "80000"),
                            _rewardRowWidget(maintain: "1000000", reward: "200000"),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5.h),
                            Text(
                              "How to Start Earning on Starline",
                              style: TextStyle(
                                color: AppColors.walletTextColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "Create your Starline account and go from zero to earning in seconds. All you have to do is:",
                              style: TextStyle(
                                color: AppColors.walletSubTextColor,
                                fontSize: 10.sp,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1. Add Assets",
                                        style: TextStyle(
                                          color: AppColors.walletTextColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        "Buy or transfer crypto to your Starline wallet.",
                                        style: TextStyle(
                                          color: AppColors.walletSubTextColor,
                                          fontSize: 12.sp,
                                          // fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "2. Start Earning",
                                        style: TextStyle(
                                          color: AppColors.walletTextColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        "You’re all set – no further action is needed! You’re now earning compound interest on your crypto, paid out daily.",
                                        style: TextStyle(
                                          color: AppColors.walletSubTextColor,
                                          fontSize: 12.sp,
                                          // fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.w),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: Color(0xfff7f7f7),
                                        borderRadius: BorderRadius.circular(8.r)),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          AppImage.imgDailyPayoutsGreen,
                                          width: 1.sw,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 5.h),
                                          child: Text(
                                            "Monthly Payout",
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.w),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: Color(0xfff7f7f7),
                                        borderRadius: BorderRadius.circular(8.r)),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          AppImage.imgFlexibleEarningsGreen,
                                          width: 1.sw,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 5.h),
                                          child: Text(
                                            "Flexible Earnings",
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.w),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Color(0xfff7f7f7),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          AppImage.imgZeroFeesGreen,
                                          width: 1.sw,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 5.h),
                                        child: Text(
                                          "Zero Fees",
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.w),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Color(0xfff7f7f7),
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        AppImage.imgFlexibleEarningsGreen,
                                        width: 1.sw,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 5.h),
                                        child: Text(
                                          "Top-Tier Insurance",
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 18.w),
                        clipBehavior: Clip.antiAlias,
                        padding:
                        EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info,
                              color: AppColors.walletTextColor,
                              size: 20.w,
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                "Maintain average monthly balance of SLC 1,000 to earn interest benefits. If this is not maintained, the monthly interest  will not be credited",
                                style: TextStyle(
                                  color: AppColors.walletTextColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // SizedBox(height: 10.h),
                      SizedBox(height: 15.h)
                    ],
                  ),
                ),
              ],
            ),
            // SingleChildScrollView(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 10.w),
            //         child: Row(
            //           children: [
            //             Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   Get.to(() => SpinningWheelScreen());
            //                 },
            //                 child: Container(
            //                   margin: EdgeInsets.symmetric(horizontal: 12.w),
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(16.r),
            //                       color: AppColors.walletConBGColor),
            //                   padding: EdgeInsets.symmetric(vertical: 12.h),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Image.asset(
            //                         AppImage.icSpinner,
            //                         height: 24.w,
            //                       ),
            //                       SizedBox(
            //                         height: 5.h,
            //                       ),
            //                       Text(
            //                         "Spinner",
            //                         style: TextStyle(
            //                             fontSize: 12.sp,
            //                             color: Colors.white,
            //                             fontWeight: FontWeight.w400),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   Get.to(() => const QuizQuestion());
            //                 },
            //                 child: Container(
            //                   margin: EdgeInsets.symmetric(horizontal: 12.w),
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(16.r),
            //                       color: AppColors.walletConBGColor),
            //                   padding: EdgeInsets.symmetric(vertical: 12.h),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Image.asset(
            //                         AppImage.icQuiz,
            //                         height: 24.w,
            //                       ),
            //                       SizedBox(
            //                         height: 5.h,
            //                       ),
            //                       Text(
            //                         "Quiz",
            //                         style: TextStyle(
            //                             fontSize: 12.sp,
            //                             color: Colors.white,
            //                             fontWeight: FontWeight.w400),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   Get.to(() => const PredictAndWinScreen());
            //                 },
            //                 child: Container(
            //                   margin: EdgeInsets.symmetric(horizontal: 12.w),
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(16.r),
            //                       color: AppColors.walletConBGColor),
            //                   padding: EdgeInsets.symmetric(vertical: 12.h),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Image.asset(
            //                         AppImage.icPrediction,
            //                         height: 24.w,
            //                       ),
            //                       SizedBox(
            //                         height: 5.h,
            //                       ),
            //                       Text(
            //                         "Prediction",
            //                         style: TextStyle(
            //                             fontSize: 12.sp,
            //                             color: Colors.white,
            //                             fontWeight: FontWeight.w400),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       SizedBox(
            //         height: 16.h,
            //       ),
            //       InkWell(
            //         onTap: () {
            //           Get.to(() => const MyCouponScreen());
            //         },
            //         child: Container(
            //           margin: EdgeInsets.symmetric(horizontal: 18.w),
            //           padding:
            //               EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            //           decoration: BoxDecoration(
            //             color: AppColors.walletConBGColor,
            //             borderRadius: BorderRadius.circular(16.r),
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Expanded(
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       "Win \nrewards everyday",
            //                       // "Reward & \nRecognition Quots",
            //                       style: TextStyle(
            //                           color: AppColors.white,
            //                           fontSize: 16.sp,
            //                           fontWeight: FontWeight.w500),
            //                     ),
            //                     SizedBox(
            //                       height: 12.h,
            //                     ),
            //                     Container(
            //                       padding: EdgeInsets.symmetric(
            //                           horizontal: 16.w, vertical: 6.h),
            //                       decoration: BoxDecoration(
            //                         color: AppColors.white,
            //                         borderRadius: BorderRadius.circular(8.r),
            //                       ),
            //                       child: Text(
            //                         "Rewards",
            //                         style: TextStyle(
            //                             color: AppColors.darkBlue,
            //                             fontSize: 14.sp,
            //                             fontWeight: FontWeight.w500),
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //               Expanded(
            //                   child: Container(
            //                 alignment: Alignment.centerRight,
            //                 child: Image.asset(
            //                   AppImage.icCoupons,
            //                   height: 110.h,
            //                   width: 142.w,
            //                 ),
            //               ))
            //             ],
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         height: 24.h,
            //       ),
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 20.w),
            //         child: Text(
            //           "User benefits REWARDS:",
            //           style: TextStyle(
            //             color: AppColors.walletTextColor,
            //             fontSize: 16.sp,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ),
            //       SizedBox(height: 6.h),
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 20.w),
            //         child: Text(
            //           "If a user is maintaining 10000 ${AppString.currencySymbol} In his account regularly they will be getting 500 ${AppString.currencySymbol} monthly as a Balance Maintaining Rewards.",
            //           style: TextStyle(
            //             color: AppColors.walletSubTextColor,
            //             fontSize: 14.sp,
            //             fontWeight: FontWeight.w400,
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         height: 10.h,
            //       ),
            //       Container(
            //         margin: EdgeInsets.symmetric(vertical: 10.h),
            //         padding:
            //             EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
            //         clipBehavior: Clip.antiAlias,
            //         decoration: BoxDecoration(
            //             color: AppColors.lightGray10,
            //             borderRadius: BorderRadius.circular(15.r)),
            //         child: Column(
            //           children: [
            //             Row(
            //               children: [
            //                 Expanded(
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         color: AppColors.withDrawButtonBGColor,
            //                         borderRadius: BorderRadius.circular(8.r)),
            //                     padding: EdgeInsets.symmetric(vertical: 8.h),
            //                     child: Center(
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: [
            //                           Image.asset(
            //                             AppImage.icCoin,
            //                             width: 18.w,
            //                             height: 24.h,
            //                             color: AppColors.withDrawButtonTextColor,
            //                           ),
            //                           SizedBox(width: 5.w),
            //                           Text(
            //                             "Maintain ${AppString.currencySymbol}",
            //                             style: TextStyle(
            //                               color:
            //                                   AppColors.withDrawButtonTextColor,
            //                               fontSize: 14.sp,
            //                               fontWeight: FontWeight.w600,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   width: 16.w,
            //                 ),
            //                 Expanded(
            //                   child: Container(
            //                     padding: EdgeInsets.symmetric(vertical: 8.h),
            //                     decoration: BoxDecoration(
            //                         color: AppColors.withDrawButtonBGColor,
            //                         borderRadius: BorderRadius.circular(8.r)),
            //                     child: Center(
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: [
            //                           Image.asset(
            //                             AppImage.icCoin,
            //                             width: 18.w,
            //                             height: 24.h,
            //                             color: AppColors.withDrawButtonTextColor,
            //                           ),
            //                           SizedBox(width: 5.w),
            //                           Text(
            //                             "Reward ${AppString.currencySymbol}",
            //                             style: TextStyle(
            //                               color:
            //                                   AppColors.withDrawButtonTextColor,
            //                               fontSize: 14.sp,
            //                               fontWeight: FontWeight.w600,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 6.h,
            //             ),
            //             _rewardRowWidget(maintain: "25000", reward: "1500"),
            //             _rewardRowWidget(maintain: "50000", reward: "3500"),
            //             _rewardRowWidget(maintain: "100000", reward: "10000"),
            //             _rewardRowWidget(maintain: "200000", reward: "25000"),
            //             _rewardRowWidget(maintain: "500000", reward: "80000"),
            //             _rewardRowWidget(maintain: "1000000", reward: "200000"),
            //           ],
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.symmetric(horizontal: 18.w),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             SizedBox(height: 5.h),
            //             Text(
            //               "How to Start Earning on Starline",
            //               style: TextStyle(
            //                 color: AppColors.walletTextColor,
            //                 fontSize: 16.sp,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //             SizedBox(height: 5.h),
            //             Text(
            //               "Create your Starline account and go from zero to earning in seconds. All you have to do is:",
            //               style: TextStyle(
            //                 color: AppColors.walletSubTextColor,
            //                 fontSize: 10.sp,
            //                 // fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //             SizedBox(height: 10.h),
            //             Row(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Expanded(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         "1. Add Assets",
            //                         style: TextStyle(
            //                           color: AppColors.walletTextColor,
            //                           fontSize: 14.sp,
            //                           fontWeight: FontWeight.w500,
            //                         ),
            //                       ),
            //                       SizedBox(height: 3.h),
            //                       Text(
            //                         "Buy or transfer crypto to your Starline wallet.",
            //                         style: TextStyle(
            //                           color: AppColors.walletSubTextColor,
            //                           fontSize: 12.sp,
            //                           // fontWeight: FontWeight.w500,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(height: 7.h),
            //             Row(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Expanded(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         "2. Start Earning",
            //                         style: TextStyle(
            //                           color: AppColors.walletTextColor,
            //                           fontSize: 14.sp,
            //                           fontWeight: FontWeight.w500,
            //                         ),
            //                       ),
            //                       SizedBox(height: 3.h),
            //                       Text(
            //                         "You’re all set – no further action is needed! You’re now earning compound interest on your crypto, paid out daily.",
            //                         style: TextStyle(
            //                           color: AppColors.walletSubTextColor,
            //                           fontSize: 12.sp,
            //                           // fontWeight: FontWeight.w500,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //       SizedBox(height: 6.h),
            //
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 12.w),
            //         child: Row(
            //           children: [
            //             Expanded(
            //               child: AspectRatio(
            //                 aspectRatio: 1,
            //                 child: Container(
            //                     margin: EdgeInsets.symmetric(
            //                         horizontal: 10.w, vertical: 10.w),
            //                     clipBehavior: Clip.antiAlias,
            //                     decoration: BoxDecoration(
            //                         color: Color(0xfff7f7f7),
            //                         borderRadius: BorderRadius.circular(8.r)),
            //                     child: Stack(
            //                       fit: StackFit.expand,
            //                       children: [
            //                         Image.asset(
            //                           AppImage.imgDailyPayoutsGreen,
            //                           width: 1.sw,
            //                         ),
            //                         Padding(
            //                           padding: EdgeInsets.symmetric(
            //                               horizontal: 10.w, vertical: 5.h),
            //                           child: Text(
            //                             "Monthly Payout",
            //                             style: TextStyle(
            //                               color: AppColors.primaryColor,
            //                               fontWeight: FontWeight.w600,
            //                             ),
            //                           ),
            //                         )
            //                       ],
            //                     )),
            //               ),
            //             ),
            //             Expanded(
            //               child: AspectRatio(
            //                 aspectRatio: 1,
            //                 child: Container(
            //                     margin: EdgeInsets.symmetric(
            //                         horizontal: 10.w, vertical: 10.w),
            //                     clipBehavior: Clip.antiAlias,
            //                     decoration: BoxDecoration(
            //                         color: Color(0xfff7f7f7),
            //                         borderRadius: BorderRadius.circular(8.r)),
            //                     child: Stack(
            //                       fit: StackFit.expand,
            //                       children: [
            //                         Image.asset(
            //                           AppImage.imgFlexibleEarningsGreen,
            //                           width: 1.sw,
            //                         ),
            //                         Padding(
            //                           padding: EdgeInsets.symmetric(
            //                               horizontal: 10.w, vertical: 5.h),
            //                           child: Text(
            //                             "Flexible Earnings",
            //                             style: TextStyle(
            //                               color: AppColors.primaryColor,
            //                               fontWeight: FontWeight.w600,
            //                             ),
            //                           ),
            //                         )
            //                       ],
            //                     )),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 12.w),
            //         child: Row(
            //           children: [
            //             Expanded(
            //               child: AspectRatio(
            //                 aspectRatio: 1,
            //                 child: Container(
            //                   margin: EdgeInsets.symmetric(
            //                       horizontal: 10.w, vertical: 10.w),
            //                   clipBehavior: Clip.antiAlias,
            //                   decoration: BoxDecoration(
            //                     color: Color(0xfff7f7f7),
            //                     borderRadius: BorderRadius.circular(8.r),
            //                   ),
            //                   child: Stack(
            //                     fit: StackFit.expand,
            //                     children: [
            //                       Container(
            //                         child: Image.asset(
            //                           AppImage.imgZeroFeesGreen,
            //                           width: 1.sw,
            //                         ),
            //                       ),
            //                       Padding(
            //                         padding: EdgeInsets.symmetric(
            //                             horizontal: 10.w, vertical: 5.h),
            //                         child: Text(
            //                           "Zero Fees",
            //                           style: TextStyle(
            //                             color: AppColors.primaryColor,
            //                             fontWeight: FontWeight.w600,
            //                           ),
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: AspectRatio(
            //                 aspectRatio: 1,
            //                 child: Container(
            //                   margin: EdgeInsets.symmetric(
            //                       horizontal: 10.w, vertical: 10.w),
            //                   clipBehavior: Clip.antiAlias,
            //                   decoration: BoxDecoration(
            //                       color: Color(0xfff7f7f7),
            //                       borderRadius: BorderRadius.circular(8.r)),
            //                   child: Stack(
            //                     children: [
            //                       Image.asset(
            //                         AppImage.imgFlexibleEarningsGreen,
            //                         width: 1.sw,
            //                       ),
            //                       Padding(
            //                         padding: EdgeInsets.symmetric(
            //                             horizontal: 10.w, vertical: 5.h),
            //                         child: Text(
            //                           "Top-Tier Insurance",
            //                           style: TextStyle(
            //                             color: AppColors.primaryColor,
            //                             fontWeight: FontWeight.w600,
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //
            //       SizedBox(height: 10.h),
            //       Container(
            //         margin: EdgeInsets.symmetric(horizontal: 18.w),
            //         clipBehavior: Clip.antiAlias,
            //         padding:
            //             EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
            //         decoration: BoxDecoration(
            //             color: AppColors.white.withOpacity(0.08),
            //             borderRadius: BorderRadius.circular(10.r)),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Icon(
            //               Icons.info,
            //               color: AppColors.walletTextColor,
            //               size: 20.w,
            //             ),
            //             SizedBox(width: 5.w),
            //             Expanded(
            //               child: Text(
            //                 "Maintain average monthly balance of SLC 1,000 to earn interest benefits. If this is not maintained, the monthly interest  will not be credited",
            //                 style: TextStyle(
            //                   color: AppColors.walletTextColor,
            //                   fontSize: 12.sp,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //
            //       // SizedBox(height: 10.h),
            //       SizedBox(height: 15.h)
            //     ],
            //   ),
            // ),
          ),
        ),
      ],
    );
  }

  // Widget _rewardRowWidget({required String maintain, required String reward}) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 7.h),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "$maintain ${AppString.currencySymbol}",
  //                 style: TextStyle(
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w500,
  //                   color: AppColors.black,
  //                 ),
  //               ),
  //               SizedBox(height: 2.h),
  //               Text(
  //                 "Per Month",
  //                 style: TextStyle(
  //                   fontSize: 10.sp,
  //                   color: AppColors.black,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               Text(
  //                 "$reward ${AppString.currencySymbol}",
  //                 style: TextStyle(
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w500,
  //                   color: AppColors.greenColor,
  //                 ),
  //               ),
  //               SizedBox(height: 2.h),
  //               Text(
  //                 "Per Month",
  //                 style: TextStyle(
  //                   fontSize: 10.sp,
  //                   color: AppColors.black,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _rewardRowWidget({required String maintain, required String reward}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.withDrawBorderColor),
                  color: AppColors.lightGray10,
                  borderRadius: BorderRadius.circular(8.r)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$maintain ${AppString.currencySymbol}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.walletTextColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Per Month",
                      style: TextStyle(
                        color: AppColors.walletSubTextColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.withDrawBorderColor),
                  color: AppColors.lightGray10,
                  borderRadius: BorderRadius.circular(8.r)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$reward ${AppString.currencySymbol}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greenFont,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Per Month",
                      style: TextStyle(
                        color: AppColors.walletSubTextColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
