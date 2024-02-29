import 'dart:convert';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReturnPolicyScreen extends StatefulWidget {
  ReturnPolicyScreen();

  @override
  State<ReturnPolicyScreen> createState() => _ReturnPolicyScreenState();
}

class _ReturnPolicyScreenState extends State<ReturnPolicyScreen> {
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
                    "Return Policy",
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

          // appBar: AppBar(
          //   title: Text("Return Policy"),
          // ),
          // body: SfPdfViewer.asset(AppPdf.returnPolicy),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleWidget(
                  title: "Return and Refund Policy",
                ),
                SizedBox(height: 5.h),
                _titleWidget(
                  title: "Last updated: November 05, 2022",
                  isShowUnderLine: false,
                ),
                SizedBox(height: 10.h),
                _titleWidget(
                  title:
                      "Thank you for shopping at Starline Crypto website and STARLINE CRYPTO app.",
                  isShowUnderLine: false,
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "If, for any reason, You are not completely satisfied with a purchase We invite You to review our policy on refunds and returns. This Return and Refund Policy has been created with the help of the [TermsFeed Return and Refund Policy Generator](https://www.termsfeed.com/return-refund-policy-generator/).\n\nThe following terms are applicable for any products that You purchased with Us.",
                ),
                SizedBox(height: 10.h),
                _titleWidget(
                  title: "Interpretation and Definitions",
                ),
                SizedBox(height: 5.h),
                _titleWidget(
                    title: "Interpretation", fontSize: 13, isShowDash: true),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.",
                ),
                SizedBox(height: 10.h),
                _titleWidget(
                    title: "Definitions", fontSize: 13, isShowDash: true),
                SizedBox(height: 5.h),
                _valueWidget(
                  title: "For the purposes of this Return and Refund Policy:",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      " * Application means the software program provided by the Company downloaded by You on any electronic device, named STARLINE CRYPTO",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      " * Company (referred to as either \"the Company\", \"We\", \"Us\" or \"Our\" in this Agreement) refers to STARLINE CRYPTO TRADING FZCO, A2 BUILDING, DUBAI DIGITAL PARK, IFZA.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      " * Goods refer to the items offered for sale on the Service.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "* Orders mean a request by You to purchase Goods from Us.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "* Service refers to the Application or the Website or both.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "* Website refers to Starline Crypto, accessible from <https://starlinecrypto.com/>",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "* You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.",
                ),
                SizedBox(height: 10.h),
                _titleWidget(
                  title: "Your Order Cancellation Rights",
                  fontSize: 14,
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "You are entitled to cancel Your Order within 14 days without giving any reason for doing so.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "The deadline for cancelling an Order is 14 days from the date on which You received the Goods or on which a third party you have appointed, who is not the carrier, takes possession of the product delivered.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "In order to exercise Your right of cancellation, You must inform Us of your decision by means of a clear statement. You can inform us of your decision by:",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "In order to exercise Your right of cancellation, You must inform Us of your decision by means of a clear statement. You can inform us of your decision by:",
                ),
                SizedBox(height: 5.h),
                _titleWidget(
                  title: "* By email: hello@starlinecrypto.com",
                  fontSize: 13,
                  isShowUnderLine: false,
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "We will reimburse You no later than 14 days from the day on which We receive the returned Goods. We will use the same means of payment as You used for the Order, and You will not incur any fees for such reimbursement.",
                ),
                SizedBox(height: 10.h),
                _titleWidget(
                  title: "Conditions for Returns",
                ),
                SizedBox(height: 5.h),
                _titleWidget(
                  title:
                      "In order for the Goods to be eligible for a return, please make sure that:",
                  fontSize: 13,
                  isShowUnderLine: false,
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title: "* The Goods were purchased in the last 14 days",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title: "* The Goods are in the original packaging",
                ),
                SizedBox(height: 5.h),
                _titleWidget(
                  title: "The following Goods cannot be returned:",
                  fontSize: 13,
                  isShowUnderLine: false,
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "* The supply of Goods made to Your specifications or clearly personalized.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      " * The supply of Goods which according to their nature are not suitable to be returned, deteriorate rapidly or where the date of expiry is over.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      " * The supply of Goods which are not suitable for return due to health protection or hygiene reasons and were unsealed after delivery.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "* The supply of Goods which are, after delivery, according to their nature, inseparably mixed with other items.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "We reserve the right to refuse returns of any merchandise that does not meet the above return conditions in our sole discretion.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "Only regular priced Goods may be refunded. Unfortunately, Goods on sale cannot be refunded. This exclusion may not apply to You if it is not permitted by applicable law.",
                ),
                SizedBox(height: 10.h),
                _titleWidget(
                  title: "Returning Goods",
                ),
                SizedBox(height: 5.h),
                _titleWidget(
                  title:
                      "You are responsible for the cost and risk of returning the Goods to Us. You should send the Goods at the following address:",
                  isShowUnderLine: false,
                  fontSize: 13,
                ),
                SizedBox(height: 5.h),
                _titleWidget(
                  title: "STARLINE CRYPTO COLLECTION AGENT",
                  isShowUnderLine: false,
                  fontSize: 13,
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "We cannot be held responsible for Goods damaged or lost in return shipment. Therefore, We recommend an insured and trackable mail service. We are unable to issue a refund without actual receipt of the Goods or proof of received return delivery.",
                ),
                SizedBox(height: 10.h),
                _titleWidget(
                  title: "Gifts",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "If the Goods were marked as a gift when purchased and then shipped directly to you, You'll receive a gift credit for the value of your return. Once the returned product is received, a gift certificate will be mailed to You.",
                ),
                SizedBox(height: 5.h),
                _valueWidget(
                  title:
                      "If the Goods weren't marked as a gift when purchased, or the gift giver had the Order shipped to themselves to give it to You later, We will send the refund to the gift giver.",
                ),
                SizedBox(height: 10.h),
                _titleWidget(
                  title: "Contact Us",
                ),
                SizedBox(height: 5.h),
                _titleWidget(
                  title:
                      "If you have any questions about our Returns and Refunds Policy, please contact us:",
                  fontSize: 13,
                  isShowUnderLine: false,
                ),
                SizedBox(height: 5.h),
                _titleWidget(
                  title: "* By email: hello@starlinecrypto.com",
                  isShowUnderLine: false,
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleWidget(
      {required String title,
      bool isShowUnderLine = true,
      double fontSize = 14,
      bool isShowDash = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title",
          style: TextStyle(
            color: AppColors.appBarTitelColor,
            fontWeight: FontWeight.w600,
            fontSize: fontSize.sp,
          ),
        ),
        if (isShowUnderLine)
          Text(
            isShowDash ? "----------------" : "=================",
            style: TextStyle(
              color: AppColors.appBarTitelColor,
              fontWeight: FontWeight.w600,
              fontSize: fontSize.sp,
            ),
          )
      ],
    );
  }

  Widget _valueWidget({required String title}) {
    return Text(
      "$title",
      style: TextStyle(
        color: AppColors.textFiledLabelColor,
        fontSize: 12.sp,
      ),
    );
  }
}
