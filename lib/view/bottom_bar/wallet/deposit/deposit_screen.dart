import 'dart:developer';

import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/controller/wallet_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/enum/payment_type.dart';
import 'package:crypto_wallet/model/available_currency_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  PaymentType _selectedPaymentType = PaymentType.stripe;
  final WalletController _walletController = Get.find();
  final UserController _userController = Get.find();
  final TextEditingController _amountController = TextEditingController();
  final String tokenizationKey = 'sandbox_8hxpnkht_kzdtzv2btm4p7s5j';
  final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _walletController.getPaymentCurrencyList();
    });
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
          backgroundColor:AppColors.screenBGColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0.h), // here the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  centerTitle: true,
                  leading: InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(18.w),
                      child: Image.asset(
                        AppImage.icLeftArrow,
                        height: 16.5.h,
                        width: 9.w,
                        color: AppColors.walletTextColor,

                      ),
                    ),
                  ),
                  title:  Text("Deposit",
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
          body: GetX<WalletController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return Container();
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFiled(
                    controller: _amountController,
                    label: "Amount",
                    hint: "Enter amount",
                    inputType: TextInputType.number,
                  ),
                  Text(
                    "Currency",
                    style: TextStyle(
                      color: AppColors.textFiledLabelColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height:5.h),
                  DropdownButtonFormField<AvailableCurrencyResponseModel>(
                    isDense: true,
                    decoration:  InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: BorderSide(
                            color: AppColors.textFiledBorderColor, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: BorderSide(
                            color: AppColors.textFiledBorderColor, width: 1.0),
                      ),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(15.r),
                      //   borderSide: BorderSide(
                      //       color: AppColors.white, width: 1.0),
                      // ),
                    ),
                    items: cont.availableCurrencyResponseModel.map((AvailableCurrencyResponseModel value) {
                      return DropdownMenuItem<AvailableCurrencyResponseModel>(
                        value: value,
                        child: Text(
                          value.title??"",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Currency",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textfieldTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textfieldTextColor,
                    ),
                    selectedItemBuilder: (BuildContext context){
                      return cont.availableCurrencyResponseModel
                          .map((AvailableCurrencyResponseModel value) {
                        return DropdownMenuItem<AvailableCurrencyResponseModel>(
                          value: value,
                          child: Text(
                            value.title??"",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textfieldTextColor,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    value: cont.selectedCurrency,
                    isExpanded: true,
                    onChanged: (AvailableCurrencyResponseModel? currency) {
                      cont.selectedCurrency = currency;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Choose Payment Method",
                    style: TextStyle(
                      color: AppColors.walletTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 15.h,),
                  /*  RadioListTile<PaymentType>(
                      value: PaymentType.payPal,
                      groupValue: _selectedPaymentType,
                      onChanged: (PaymentType? paymentType) {
                        if (paymentType != null) {
                          _selectedPaymentType = paymentType;
                          setState(() {});
                        }
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Image.asset(
                            AppImage.icPaypal,
                            height: 20.h,
                            width: 70.w,
                            fit: BoxFit.cover,
                          )
                        ],
                      ),
                    ),
                    // RadioListTile<PaymentType>(
                    //   value: PaymentType.amazonPay,
                    //   groupValue: _selectedPaymentType,
                    //   onChanged: (PaymentType? paymentType) {
                    //     if (paymentType != null) {
                    //       _selectedPaymentType = paymentType;
                    //       setState(() {});
                    //     }
                    //   },
                    //   dense: true,
                    //   contentPadding: EdgeInsets.zero,
                    //   title: Row(
                    //     children: [
                    //       Image.asset(
                    //         AppImage.icAmazonPay,
                    //         height: 20.h,
                    //         width: 70.w,
                    //         fit: BoxFit.cover,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    RadioListTile<PaymentType>(
                      value: PaymentType.razorPay,
                      groupValue: _selectedPaymentType,
                      onChanged: (PaymentType? paymentType) {
                        if (paymentType != null) {
                          _selectedPaymentType = paymentType;
                          setState(() {});
                        }
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Image.asset(
                            AppImage.icRazorPay,
                            height: 20.h,
                            fit: BoxFit.cover,
                          )
                        ],
                      ),
                    ),*/
                  RadioListTile<PaymentType>(
                    value: PaymentType.stripe,
                    activeColor:AppColors.walletTextColor ,
                    groupValue: _selectedPaymentType,
                    onChanged: (PaymentType? paymentType) {
                      if (paymentType != null) {
                        _selectedPaymentType = paymentType;
                        setState(() {});
                      }
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text("Strip",
                      style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.walletTextColor,
                    ),
                      // children: [
                      //   Image.asset(
                      //     AppImage.icStripe,
                      //     height: 20.h,
                      //     width: 50.w,
                      //     color: AppColors.white,
                      //     fit: BoxFit.cover,
                      //   )
                      // ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  CustomButton(
                    title: "Continue",
                    onTap: openPaymentGateway,
                    borderRadius: 8.r,
                  )
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  Future<void> openPaymentGateway() async {
    double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      _walletController.showError(msg: "Please enter amount");
      return;
    }

    if (amount <= (_walletController.selectedCurrency?.limit??1)) {
      _walletController.showError(msg: "Please add more than ${_walletController.selectedCurrency?.limit} ${_walletController.selectedCurrency?.currency}");
      return;
    }

    _userController.removeUnFocusManager();
    if (_selectedPaymentType == PaymentType.payPal) {
      final request = BraintreePayPalRequest(
        amount: "${amount}",
        currencyCode: "USD",
      );
      final result = await Braintree.requestPaypalNonce(
        tokenizationKey,
        request,
      );
      logger("Result ===>   ${result?.nonce}    ${result?.paypalPayerId}");
      if (result?.nonce != null) {
        _walletController.paymentStatusUpdate(
          paymentMethod: _selectedPaymentType.name,
          paymentId: result?.nonce ?? "",
          amount: _amountController.text,
        );
      }
    } else if (_selectedPaymentType == PaymentType.stripe) {
      // print("Result ===>   ${_selectedPaymentType}");
      // await Stripe.instance.initPaymentSheet(
      //   paymentSheetParameters: const SetupPaymentSheetParameters(
      //     paymentIntentClientSecret:
      //         "pi_3LxpTHSJlAhvwwyT0vMAjqji_secret_BkIGXkslOc5De7xtjTviM9Jy8",
      //     // customerEphemeralKeySecret: stripeData["ephemeralKey"],
      //     // customerId: stripeData["customer"],
      //     allowsDelayedPaymentMethods: true,
      //     style: ThemeMode.light,
      //   ),
      // );
      // Stripe.instance.presentPaymentSheet();
      _walletController.createStripePaymentIntent(amount: amount * 100);
    } else if (_selectedPaymentType == PaymentType.razorPay) {
      var options = {
        'key': 'rzp_test_Ju6wtuJvPUFvx0',
        'amount': amount * 100,
        // "currency": "USD",
        'name': 'Crypto',
        'description': '',
        'prefill': {
          'contact': _userController.userResponseModel.value.user?.phone ?? "0",
          'email': _userController.userResponseModel.value.user?.email ?? ""
        }
      };
      _razorpay.open(options);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _walletController.paymentStatusUpdate(
      paymentMethod: _selectedPaymentType.name,
      paymentId: response.paymentId ?? "",
      amount: _amountController.text,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _walletController.showError(msg: response.message ?? "");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _walletController.showError(msg: response.walletName ?? "");
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }
}
