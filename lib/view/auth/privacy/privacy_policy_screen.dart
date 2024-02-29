import 'dart:convert';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  bool isPrivacyPolicy;

  PrivacyPolicyScreen({this.isPrivacyPolicy = false});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  WebViewController? _webViewController;
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
                  centerTitle: true,
                  title: Text(
                    widget.isPrivacyPolicy
                        ? "Privacy Policy"
                        : "Terms & Conditions",
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
          //   title: Text(widget.isPrivacyPolicy
          //       ? "Privacy Policy"
          //       : "Terms & Conditions"),
          // ),
          body: widget.isPrivacyPolicy
              ? SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Privacy Policy for STARLINE CRYPTO TRADING FZCO",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        """At starlinecrypto, accessible from https://starlinecrypto.com/, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by starlinecrypto and how we use it.
If you have additional questions or require more information about our Privacy Policy, do not
 
hesitate to contact us.
This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in starlinecrypto. This policy is not applicable to any information collected offline or via channels other than this website. Our Privacy Policy was created with the help of the Free Privacy Policy Generator.""",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Consent",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "By using our website, you hereby consent to our Privacy Policy and agree to its terms.",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Information we collect",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "The personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information. If you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide. When you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number. ",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "How we use your information",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        """We use the information we collect in various ways, including to: 
⦿ Provide, operate, and maintain our website
⦿ Improve, personalize, and expand our website
⦿ Understand and analyze how you use our website
⦿ Develop new products, services, features, and functionality
⦿ Communicate with you, either directly or through one of our partners, including for
customer service, to provide you with updates and other information relating to the
website, and for marketing and promotional purposes 
⦿ Send you emails
⦿ Find and prevent fraud""",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Log Files",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "starlinecrypto follows a standard procedure of using log files. These files log visitors when they visit websites. All hosting companies do this and a part of hosting services' analytics. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the site, tracking users' movement on the website, and gathering demographic information.",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Cookies and Web Beacons",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Like any other website, starlinecrypto uses 'cookies'. These cookies are used to store information including visitors' preferences, and the pages on the website that the visitor accessed or visited. The information is used to optimize the users' experience by customizing our web page content based on visitors' browser type and/or other information.",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Google DoubleClick DART Cookie",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Google is one of a third-party vendor on our site. It also uses cookies, known as DART cookies, to serve ads to our site visitors based upon their visit to www.website.com and other sites on the internet. However, visitors may choose to decline the use of DART cookies by visiting the Google ad and content network Privacy Policy at the following URL – https://policies.google.com/technologies/ads",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Our Advertising Partners",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Some of advertisers on our site may use cookies and web beacons. Our advertising partners are listed below. Each of our advertising partners has their own Privacy Policy for their policies on user data. For easier access, we hyperlinked to their Privacy Policies below.",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "    ⦿ Google",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "https://policies.google.com/technologies/ads",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Advertising Partners Privacy Policies",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        """You may consult this list to find the Privacy Policy for each of the advertising partners of starlinecrypto.

Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on starlinecrypto, which are sent directly to users' browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit.

Note that starlinecrypto has no access to or control over these cookies that are used by third-party advertisers.""",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Third Party Privacy Policies",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        """starlinecrypto's Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.

You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers' respective websites.""",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "CCPA Privacy Rights (Do Not Sell My Personal Information)",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        """Under the CCPA, among other rights, California consumers have the right to:

Request that a business that collects a consumer's personal data disclose the categories and specific pieces of personal data that a business has collected about consumers.

Request that a business delete any personal data about the consumer that a business has collected.

Request that a business that sells a consumer's personal data, not sell the consumer's personal data.

If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us.""",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "GDPR Data Protection Rights",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        """We would like to make sure you are fully aware of all of your data protection rights. Every user is entitled to the following:

The right to access – You have the right to request copies of your personal data. We may charge you a small fee for this service.

The right to rectification – You have the right to request that we correct any information you believe is inaccurate. You also have the right to request that we complete the information you believe is incomplete.

The right to erasure – You have the right to request that we erase your personal data, under certain conditions.

The right to restrict processing – You have the right to request that we restrict the processing of your personal data, under certain conditions.

The right to object to processing – You have the right to object to our processing of your personal data, under certain conditions.

The right to data portability – You have the right to request that we transfer the data that we have collected to another organization, or directly to you, under certain conditions.

If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us.""",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Children's Information",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBarTitelColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        """Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.

starlinecrypto does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.""",
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.w500,
                          color: AppColors.textFiledLabelColor,
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                )
              : WebView(
                  onWebViewCreated: (WebViewController? webViewController) {
                    _webViewController = webViewController;
                    _loadHtmlFromAssets();
                  },
                  onPageFinished: (String url) {
                    // _webViewController?.evaluateJavascript('document.body.style.overflow = \'hidden\';');
                  },
                  initialUrl: "about:blank",
                  debuggingEnabled: true,
                  gestureNavigationEnabled: true,
                  javascriptMode: JavascriptMode.unrestricted,
                  // gestureNavigationEnabled: true,
                  // backgroundColor: Colors.red,
                  onPageStarted: (s) {
                    print("object ===>   $s");
                  },
                ),
        ),
      ],
    );
  }

  void _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString(widget.isPrivacyPolicy
        ? 'assets/privacy.html'
        : 'assets/terms_and_condition.html');
    _webViewController?.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
