import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/controller/wallet_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/available_currency_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/kyc/kyc_screen.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WithDrawScreen extends StatefulWidget {
  const WithDrawScreen({Key? key}) : super(key: key);

  @override
  State<WithDrawScreen> createState() => _WithDrawScreenState();
}

class _WithDrawScreenState extends State<WithDrawScreen> {
  final WalletController _walletController = Get.find();
  final UserController _userController = Get.find();
  final TextEditingController _coinQtyController = TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();
  final TextEditingController _conAccountNoController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _accountHolderNameController =
      TextEditingController();
  String? _selectedAccountType;
  List<String> accountTypeList = [];

  @override
  void initState() {
    super.initState();
    accountTypeList.add("Saving");
    accountTypeList.add("Current");
    _selectedAccountType = accountTypeList[0];

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
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(18.w),
                      child: Image.asset(
                        AppImage.icLeftArrow,
                        height: 16.5.h,
                        width: 9.w,
                        color: AppColors.walletTextColor,
                      ),
                    ),
                  ),
                  title: Text(
                    "Withdraw",
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFiled(
                    controller: _coinQtyController,
                    label: "Coin",
                    hint: "SLC",
                    inputType: TextInputType.number,
                  ),
                  Text(
                    "Withdraw Currency",
                    style: TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  DropdownButtonFormField<AvailableCurrencyResponseModel>(
                    isDense: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide:
                            BorderSide(color: AppColors.textFiledBorderColor, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide:
                            BorderSide(color: AppColors.textFiledBorderColor, width: 1.0),
                      ),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(15.r),
                      //   borderSide: BorderSide(
                      //       color: AppColors.white, width: 1.0),
                      // ),
                    ),
                    items: cont.availableCurrencyResponseModel
                        .map((AvailableCurrencyResponseModel value) {
                      return DropdownMenuItem<AvailableCurrencyResponseModel>(
                        value: value,
                        child: Text(
                          value.title ?? "",
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
                        color: AppColors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return cont.availableCurrencyResponseModel
                          .map((AvailableCurrencyResponseModel value) {
                        return DropdownMenuItem<AvailableCurrencyResponseModel>(
                          value: value,
                          child: Text(
                            value.title ?? "",
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
                  SizedBox(height: 15),
                  CustomTextFiled(
                    controller: _accountNoController,
                    label: "Account No.",
                    hint: "Enter Account No.",
                  ),
                  CustomTextFiled(
                    controller: _conAccountNoController,
                    label: "Confirm Account No.",
                    hint: "Re-Enter Account No.",
                  ),
                  CustomTextFiled(
                    controller: _ifscCodeController,
                    label: "IFSC/IBAN/SWIFT Code",
                    hint: "Enter IFSC/IBAN/SWIFT Code",
                  ),
                  Text(
                    "Account Type",
                    style: TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap:(){
                              _selectedAccountType = "Saving";
                              setState(() {});
                            },
                            child: Container(
                        padding: EdgeInsets.symmetric(
                              vertical: 13.h, horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: _selectedAccountType == "Saving" ? AppColors.withDrawButtonColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: AppColors.textFiledBorderColor, width: 1)),
                        child: Text(
                            "Saving",
                            style: TextStyle(
                              color: _selectedAccountType == "Saving" ? AppColors.white : AppColors.walletTextColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                        ),
                      ),
                          )),
                      SizedBox(width: 15.w,),
                      Expanded(
                          child: InkWell(
                            onTap:(){
                              _selectedAccountType = "Current";
                              setState(() {});
                            },
                            child: Container(
                        padding: EdgeInsets.symmetric(
                              vertical: 13.h, horizontal: 8.w),
                        decoration: BoxDecoration(
                              color: _selectedAccountType == "Current" ? AppColors.withDrawButtonColor : Colors.transparent,

                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: AppColors.textFiledBorderColor, width: 1)),
                        child: Text(
                            "Current",
                            style: TextStyle(
                              color: _selectedAccountType == "Current" ? AppColors.white : AppColors.walletTextColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                        ),
                      ),
                          )),
                    ],
                  ),
                  // DropdownButton<String>(
                  //   items: accountTypeList.map((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(
                  //         value,
                  //         style: TextStyle(
                  //           fontSize: 14.sp,
                  //           fontWeight: FontWeight.w500,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     );
                  //   }).toList(),
                  //   selectedItemBuilder: (BuildContext context) {
                  //     return accountTypeList.map((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(
                  //           value,
                  //           style: TextStyle(
                  //             fontSize: 14.sp,
                  //             fontWeight: FontWeight.w500,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       );
                  //     }).toList();
                  //   },
                  //   value: _selectedAccountType,
                  //   hint: Text(
                  //     "Select Account Type",
                  //     style: TextStyle(
                  //       fontSize: 14.sp,
                  //       color: AppColors.white.withOpacity(0.7),
                  //     ),
                  //   ),
                  //   style: TextStyle(
                  //     fontSize: 14.sp,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white,
                  //   ),
                  //   onChanged: (_) {
                  //     _selectedAccountType = _;
                  //     setState(() {});
                  //   },
                  //   isExpanded: true,
                  // ),
                  SizedBox(height: 10.h),
                  CustomTextFiled(
                    controller: _accountHolderNameController,
                    label: "Account Holder Name",
                    hint: "Enter account holder name",
                  ),
                  SizedBox(height: 15.h),
                  CustomButton(
                    title: "Submit",
                    borderRadius: 8.r,
                    onTap: () {
                      double coinQty =
                          double.tryParse(_coinQtyController.text) ?? 0;
                      if (coinQty <= 0) {
                        _walletController.showError(
                            msg: "Please enter valid coin quantity");
                        return;
                      }
                      if (coinQty < 1000) {
                        _walletController.showError(
                            msg: "You can withdraw more than 1000 only");
                        return;
                      }
                      if (_accountNoController.text.isEmpty) {
                        _walletController.showError(
                            msg: "please enter valid account number");
                        return;
                      }
                      if (_accountNoController.text !=
                          _conAccountNoController.text) {
                        _walletController.showError(
                            msg:
                                "Account number and Confirm account number not match");
                        return;
                      }

                      if (_ifscCodeController.text.isEmpty) {
                        _walletController.showError(
                            msg: "Please enter IFSC code");
                        return;
                      }

                      if (_selectedAccountType == null) {
                        _walletController.showError(
                            msg: "Please select account type");
                        return;
                      }
                      if (_accountHolderNameController.text.isEmpty) {
                        _walletController.showError(
                            msg: "Please enter Account holder name");
                        return;
                      }

                      if (_userController
                              .userResponseModel.value.user?.kycVerified ==
                          "SUBMITTED") {
                        _userController.showSnack(
                            msg:
                                "You can withdraw money only if you are verified user");
                        return;
                      }

                      if (_userController
                              .userResponseModel.value.user?.kycVerified ==
                          "PENDING") {
                        _userController.showError(
                            msg:
                                "You can withdraw money only if you are verified user");
                        Get.to(() => const KYCScreen());
                        return;
                      }

                      if (_userController
                              .userResponseModel.value.user?.kycVerified ==
                          "REJECTED") {
                        _userController.showError(
                            msg:
                                "You can withdraw money only if you are verified user");
                        Get.to(() => const KYCScreen());
                        return;
                      }

                      Map<String, dynamic> params = {};
                      params["amount"] = coinQty;
                      params["accountNo"] = _accountNoController.text;
                      params["ifsc_code"] = _ifscCodeController.text;
                      params["iban"] = _ifscCodeController.text;
                      params["currency"] =
                          cont.selectedCurrency?.currency ?? "";
                      params["accountHolderName"] =
                          _accountHolderNameController.text;
                      params["accountType"] = _selectedAccountType;
                      _walletController.withDraw(params: params);
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
