import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/wallet_controller.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddAddressWidget extends StatefulWidget {
  const AddAddressWidget({Key? key}) : super(key: key);

  @override
  State<AddAddressWidget> createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends State<AddAddressWidget> {
  final TextEditingController _recipientAddress = TextEditingController();
  final HomeController _homeController = Get.find();
  final WalletController _walletController = Get.find();

  final GlobalKey _appBarKey = GlobalKey();
  double _appBarSize = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Size? size = _appBarKey.currentContext?.size;
      _appBarSize = size?.height ?? 0;
      setState(() {});
      // _walletController.transactionHistoryList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _appBarKey,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            30.r,
          ),
        ),
      ),
      child: Stack(
        children: [
          if (_appBarSize != 0)
            Container(
              width: double.infinity,
              height: _appBarSize,
              child: Image.asset(
                AppImage.imgBg,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Container(
                  width: 100.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
                SizedBox(height: 15.h),
                CustomTextFiled(
                  controller: _recipientAddress,
                  label: "Recipient Address",
                  hint: "Enter Recipient Address",
                  minLines: 1,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          var result = await BarcodeScanner.scan();
                          _recipientAddress.text = result.rawContent;
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.h, horizontal: 5.w),
                          child: Icon(
                            Icons.qr_code_scanner_outlined,
                            color: AppColors.white,
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
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                    ],
                  ),
                ),

                SizedBox(height: 15.h),
                CustomButton(
                  title: "Add Wallet Address",
                  onTap: () async {
                    if (_recipientAddress.text.isEmpty) {
                      _homeController.showError(
                          msg: "Please enter user wallet address");
                      return;
                    }

                    await _walletController.addressBookUpdate(
                        address: _recipientAddress.text).then((value) => Get.back());
                  },
                ),
                SizedBox(height: 25.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
