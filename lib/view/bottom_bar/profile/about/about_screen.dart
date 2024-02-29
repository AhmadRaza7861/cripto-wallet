import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final HomeController _homeController = Get.find();
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

                  centerTitle:true,
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
                    "About",
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

          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.aboutLogoBGColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImage.icLogoAbout,
                              width: 135.w,
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              "Starline",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    color: Color(0xffD2D2D2),
                    height: 25.w,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.textFiledBorderColor),
                      borderRadius: BorderRadius.circular(10.r)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Creating a tokenized world where all value can flow freely",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textfieldTextColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text("Starline empowers people to harness the value behind their assets, shaping a new, better financial system. Disrupting the financial system, one bit at a time. Buy Starline coin instantly with credit/debit card, Trade with starline coin using advanced AI-trading tools and indicators. Earn monthly interest on your assets.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textFiledLabelColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.textFiledBorderColor),
                        borderRadius: BorderRadius.circular(10.r)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unleash the Power of Starline Coin",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textfieldTextColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text("With the account that caters to your profit and prosperity through our leading trading bots and high-yield interest on your idle savings.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textFiledLabelColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.textFiledBorderColor),
                        borderRadius: BorderRadius.circular(10.r)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your eCommerce Partner",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textfieldTextColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text("With the account that caters to your profit and prosperity through our leading trading bots and high-yield interest on your idle savings.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textFiledLabelColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.textFiledBorderColor,),
                        borderRadius: BorderRadius.circular(10.r)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AI-Trading Partner",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textfieldTextColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text("Set up strategies like Arbitrage, Grid Bots to automate your probability of turning a profit.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textFiledLabelColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.textFiledBorderColor),
                        borderRadius: BorderRadius.circular(10.r)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pro-Investment Partner",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textfieldTextColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text("Make your idle digital assets work for you. Start earning up to 16% APR, paid out monthly.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textFiledLabelColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),
                  // SizedBox(height: 15.h),
                  // Text(
                  //   "Leveraging the best of the team's years of experience in FinTech along with the power of blockchain technology, Starline empowers people to harness the value behind their crypto assets, shaping a new, better financial system. Disrupting the financial system, one bit at a time.",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white,
                  //     fontSize: 12.sp,
                  //   ),
                  // ),
                  // SizedBox(height: 10.h),
                  // Text(
                  //   "Unleash the Power of Your Crypto",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.white,
                  //     fontSize: 16.sp,
                  //   ),
                  // ),
                  // SizedBox(height: 3.h),
                  // Text(
                  //   "With the account that caters to your profit and prosperity through our leading trading bots and high-yield interest on your idle savings.",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white.withOpacity(0.8),
                  //     fontSize: 12.sp,
                  //   ),
                  // ),
                  // SizedBox(height: 10.h),
                  // Text(
                  //   "Your eCommerce Partner",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.white,
                  //     fontSize: 16.sp,
                  //   ),
                  // ),
                  // SizedBox(height: 3.h),
                  // Text(
                  //   "We are the future of decentralized e-commerce. Get the latest cellular & wearable deals & save!",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white.withOpacity(0.8),
                  //     fontSize: 12.sp,
                  //   ),
                  // ),
                  // SizedBox(height: 10.h),
                  // Text(
                  //   "Crypto-trading Partner",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.white,
                  //     fontSize: 16.sp,
                  //   ),
                  // ),
                  // SizedBox(height: 3.h),
                  // Text(
                  //   "Set up strategies like Arbitrage, Grid Bots to auto- mate your probability of turning a profit.",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white.withOpacity(0.8),
                  //     fontSize: 12.sp,
                  //   ),
                  // ),
                  // SizedBox(height: 10.h),
                  // Text(
                  //   "Pro-Investment Partner",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.white,
                  //     fontSize: 16.sp,
                  //   ),
                  // ),
                  // SizedBox(height: 3.h),
                  // Text(
                  //   "Make your idle digital assets work for you. Start earning up to 16% APR, paid out monthly.",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white.withOpacity(0.8),
                  //     fontSize: 12.sp,
                  //   ),
                  // ),
                  // SizedBox(height: 30.h),
                  // InkWell(
                  //   onTap: (){
                  //     Get.to(()=> PrivacyPolicyScreen());
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(vertical: 10.h),
                  //     child: Row(
                  //       children: [
                  //         Icon(
                  //           Icons.privacy_tip_outlined,
                  //           color: AppColors.white,
                  //         ),
                  //         SizedBox(width: 5.w),
                  //         Expanded(
                  //           child: Text(
                  //             "Privacy Policy",
                  //             style: TextStyle(
                  //               color: AppColors.white,
                  //               fontSize: 16.sp,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ),
                  //         Icon(
                  //           Icons.arrow_forward_ios_outlined,
                  //           size: 15.w,
                  //           color: AppColors.white,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 5.h),
                  // InkWell(
                  //   onTap: (){
                  //     Get.to(()=> PrivacyPolicyScreen(isPrivacyPolicy: false,));
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(vertical: 10.h),
                  //     child: Row(
                  //       children: [
                  //         Icon(
                  //           Icons.privacy_tip_outlined,
                  //           color: AppColors.white,
                  //         ),
                  //         SizedBox(width: 5.w),
                  //         Expanded(
                  //           child: Text(
                  //             "Terms & Conditions",
                  //             style: TextStyle(
                  //               color: AppColors.white,
                  //               fontSize: 16.sp,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ),
                  //         Icon(
                  //           Icons.arrow_forward_ios_outlined,
                  //           size: 15.w,
                  //           color: AppColors.white,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
//           body: SfPdfViewer.asset(AppPdf.aboutUs),
        ),
      ],
    );
  }
}
