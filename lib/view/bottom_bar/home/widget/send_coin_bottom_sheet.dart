import 'dart:developer';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:crypto_wallet/controller/base_controller.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/controller/wallet_controller.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../user_activity_log/widget/send_balance_confermation_dislog.dart';

class SendCoinBottomSheet extends StatefulWidget {
  User? user;

  SendCoinBottomSheet({this.user});

  @override
  State<SendCoinBottomSheet> createState() => _SendCoinBottomSheetState();
}

class _SendCoinBottomSheetState extends State<SendCoinBottomSheet> {
  final TextEditingController _recipientAddress = TextEditingController();
  final TextEditingController _coinController = TextEditingController();
  final HomeController _homeController = Get.find();
  final WalletController _walletController = Get.find();
  final UserController _userController = Get.find();
  bool _isSaveAddress = false;
  final GlobalKey _totalBalanceKey = GlobalKey();
  double _bottomSheetHeight = 0;

  @override
  void initState() {
    super.initState();
    _recipientAddress.text = widget.user?.wallet ?? "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Size? size = _totalBalanceKey.currentContext?.size;
      _bottomSheetHeight = size?.height ?? 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _totalBalanceKey,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bottomSheetBG,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            30.r,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15.h),
            Container(
              width: 100.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            SizedBox(height: 30.h),
            if(widget.user == null)
              CustomTextFiled(
                controller: _recipientAddress,
                label: "Recipient Address",
                hint: "Enter Recipient Address",
                isShowBorder: true,
                minLines: 1,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async {
                        var result = await BarcodeScanner.scan();
                        logger("message ====>  ${result.rawContent}");
                        _recipientAddress.text = result.rawContent;
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 5.w),
                        child: Image.asset(
                          AppImage.icScan,
                          width: 17.w,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        ClipboardData? data =
                        await Clipboard.getData(Clipboard.kTextPlain);
                        if (data != null) {
                          _recipientAddress.text = data.text ?? "";
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 5.w),
                        child: Text(
                          "Paste",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textfieldTextColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                  ],
                ),
              ),
            CustomTextFiled(
              controller: _coinController,
              hint: "SLC",
              inputType: const TextInputType.numberWithOptions(),
            ),
            if(widget.user == null)
              CheckboxListTile(
                value: _isSaveAddress,
                onChanged: (bool? value) {
                  if (value != null) {
                    _isSaveAddress = value ?? false;
                    setState(() {});
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                checkColor: AppColors.checkBoxColor,
                activeColor: AppColors.textfieldTextColor,
                // checkboxShape: CircleBorder(),
                side: BorderSide(
                  color: AppColors.textfieldTextColor,
                ),
                contentPadding: const EdgeInsets.symmetric(),
                title: Text(
                  "Save Address",
                  style: TextStyle(
                    color: AppColors.textfieldTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            SizedBox(height: 15.h),
            CustomButton(
              title: "Send",
              onTap: () async {
                double coin = double.tryParse(_coinController.text) ?? 0;
                if (_recipientAddress.text.isEmpty) {
                  _homeController.showError(
                      msg: "Please enter user wallet address");
                  return;
                }

                if (coin <= 0) {
                  _homeController.showError(
                      msg: "Please enter valid coin quantity");
                  return;
                }

                bool isSuccessFull = true;
                if (_isSaveAddress) {
                  isSuccessFull = await _walletController.addressBookUpdate(
                      address: _recipientAddress.text.trim());
                }
                String privateKey = _userController.userResponseModel.value
                    .user!.wallet.toString();
                if (privateKey == "" || privateKey.isEmpty) {
                  _homeController.showError(
                      msg: "something went wrong login again");
                }
                else {
                  if (isSuccessFull) {
                    Get.back();
                    Get.dialog(SendBalanceConversationDialog(coin: coin,sendAddress: _recipientAddress.text,homeController: _homeController,privateKey: privateKey,));


                    // String abi=await _homeController.loadTokenABIFile();
                    // bool isSuccess = await _homeController.sendCoinLocally(
                    //     sendAddress: _recipientAddress.text,
                    //     coin: coin,
                    //     privateKey: privateKey,
                    // tokenAbi: abi
                    // );
                    // if (isSuccess) {
                    //   _showMyDialog(context: context,
                    //       hash: _homeController.TransectionSuccesstxHash);
                    // }


                    //Api method for send coin
                    // _homeController.sendCoin(
                    //   sendAddress: _recipientAddress.text,
                    //   coin: coin,
                    // );
                  }
                }
              },
            ),
            SizedBox(height: 25.h),
          ],
        ),
      ),

    );
  }

  void _showMyDialog({required BuildContext context, required String hash}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return an AlertDialog
        return AlertDialog(
          title: Text('Successfull'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${hash}'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: Text('Close', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          AppColors.buttonBGColor)
                  ),
                  child: Text('View on PolygonScan',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    print("HASH ${hash}");
                    OpenUrlAtWebView(hash:hash );
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void OpenUrlAtWebView({required String hash}) async {
    String url = 'https://mumbai.polygonscan.com/tx/$hash'; // Replace with your URL
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}