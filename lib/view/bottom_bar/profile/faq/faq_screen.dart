import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/model/faq_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<FAQModel> faqList = [];

  @override
  void initState() {
    super.initState();
    faqList.add(
      FAQModel(
        question: "What is an SLC token?",
        ans:
            "SLC refers to Starline Crypto Tokens. It is an independent token developed by using the Polygon platform",
      ),
    );

    faqList.add(
      FAQModel(
        question:
            "What is the use of the SLC token and where I can use SLC token?",
        ans:
            "SLC tokens can be used in our e-commerce platform to buy the products and use our overwhelmed auto-trade bot option to multiply your earnings",
      ),
    );

    faqList.add(
      FAQModel(
        question: "Is it free to join Starline Crypto?",
        ans:
            "Starline Crypto is 100% free to enroll and any nationalities can enroll in Starline wallet without any restrictions.",
      ),
    );

    faqList.add(FAQModel(
      question:
          "How much minimum investment is required to start a Starline wallet?",
      ans:
          "There is no set of any minimal regulations for monitoring or enrolling into Starline Wallet",
    ));

    faqList.add(FAQModel(
      question: "What is the minimum investment to access the auto-trade bot?",
      ans:
          "There is no monitoring requirement to access the auto-trade bot. Users can start with any amount as per their wish.",
    ));

    faqList.add(FAQModel(
        question: "What are the benefits if I purchased SLC tokens?",
        ans:
            "Users will get fixed profit margins as mentioned in our pool quota tab."));

    faqList.add(FAQModel(
      question: "What is the value of one SLC token?",
      ans: "SLC token’s value will be updated frequently in your wallet.",
    ));

    faqList.add(FAQModel(
        question: "Will the token’s value get depreciated?",
        ans:
            "SLC token’s values will not be getting depreciated from its initial value."));

    faqList.add(FAQModel(
      question: "What are all the products I can buy?",
      ans:
          "Customers can get any of the product which is available on our e-commerce site without any restrictions.",
    ));

    faqList.add(FAQModel(
      question: "How can I withdraw the SLC token?",
      ans: "SLC tokens can be withdrawn to any of your bank accounts by giving a withdrawal request.",
    ));

    faqList.add(FAQModel(
      question: "After the withdrawal request, how much time will take to credit in our bank?",
      ans: "Usually, the SLC team will credit your withdrawal funds within 24 hours on working days.",
    ));

    faqList.add(FAQModel(
      question: "Can a user can create multiple accounts?",
      ans: "Users can create multiple accounts with different email IDs and registered phone numbers",
    ));

    faqList.add(FAQModel(
      question: "If users have forgotten the password, how it should be retrieved?",
      ans:
      "Users can reset their password over email by reset the password option.",
    ));

    faqList.add(FAQModel(
      question: "Can business owners transfer salary to their staff by SLC token?",
      ans:
      "Currently, in Singapore, Malaysia, and Thailand, business owners can offer this service. For the remaining countries, we are working to get it progressed.",
    ));

    faqList.add(FAQModel(
      question: "How does an employee will get benefit by receiving SLC token as their salary?",
      ans: "Employees will be receiving 10% fixed bonus on every salary credited to their SLC wallet.",
    ));

    faqList.add(FAQModel(
      question: "Is SLC business wallet is available in India for salary transfers?",
      ans: "Currently, we are working with Reserve Bank Authorities to enroll with their own pay system. Soon, we will be launching a business wallet for Indian businessmen/entrepreneurs to do their payouts and international purchases",
    ));

    faqList.add(FAQModel(
      question: "Does SLC wallet will be charging any transactional fee for outward or inward transactions?",
      ans: "SLC token will never charge any transactional fee for inward or outward inside the wallet",
    ));

    faqList.add(FAQModel(
      question: "In how many countries, SLC token is existing?",
      ans: "Currently, SLC tokens are live in UAE, Qatar, kingdom Saudi Arabia (KSA), USA, Mexico, El-Salvador, India, Sri Lanka, Pakistan, Bangladesh, Malaysia, Singapore, and Thailand.",
    ));

    faqList.add(FAQModel(
      question: "Is KYC mandatory to enroll into SLC wallet?",
      ans:
      "As per certain country monitory regulatory facts/federal tax authority regulation, KYC will be required. If KYC is mandatory in your country, it will be asking you to verify KYC in your wallet before making any transactions.",
    ));

    faqList.add(FAQModel(
      question: "Where I can buy Starline tokens?",
      ans:
      "Starline tokens (SLC) can be bought only with registered SLC token agents and SLC wallet.",
    ));

    faqList.add(FAQModel(
      question: "What is SLC star member?",
      ans:
      "SLC star member is a premium option in which users can get many benefits and double earning points.",
    ));

    faqList.add(FAQModel(
      question: "Who can become an SLC star member?",
      ans:
      "An individual user who is maintaining a minimum of 500,000SLC will be considered as Star member and all the privilege services will be provided.",
    ));
  }
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
   bool _isExpanded = false ;
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
                      "FAQs",
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

            body: ListView.builder(
              shrinkWrap: true,
              itemCount: faqList.length,
              padding: EdgeInsets.only(bottom: 20.h),
              itemBuilder: (BuildContext context, int index) {
                FAQModel faqModel = faqList[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.textFiledBorderColor,
                    width: 1.w)
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

                    child: ExpansionTile(
                      onExpansionChanged: ( bool value) {
                        setState(() {
                          _isExpanded = value;
                        });
                      },
                      // trailing:_isExpanded ? Image.asset(AppImage.icDownR, width: 18.w,)
                      //     : Image.asset(AppImage.icUpR,
                      //   width: 18.w,
                      // ),
                      title: Text(
                        "${index + 1}. ${faqModel.question ?? ""}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.detailTitelColor,
                        ),
                      ),
                      collapsedIconColor: AppColors.appBarTitelColor,

                      iconColor: AppColors.appBarTitelColor,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            faqModel.ans ?? "",
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.detailsColor),
                          ),
                        ),
                        SizedBox(height: 10.h)
                      ],
                    ),
                  ),
                );
              },
              
            )),
      ],
    );
  }
}
