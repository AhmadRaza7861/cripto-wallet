import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../controller/home_controller.dart';
import '../../../../../util/app_constant.dart';
import '../../../../common_widget/custom_button.dart';
import '../../../wallet/deposit/deposit_screen.dart';

class SendBalanceConversationDialog extends StatefulWidget {
  String sendAddress;
  double coin;
  String privateKey;
  HomeController homeController;
   SendBalanceConversationDialog ({Key? key,required this.sendAddress,required this.coin,required this.homeController,required this.privateKey}) : super(key: key);

  @override
  State<SendBalanceConversationDialog> createState() => _SendBalanceConversationDialogState();
}

class _SendBalanceConversationDialogState extends State<SendBalanceConversationDialog > {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bottomSheetBG,
      // insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        decoration: BoxDecoration(
            color: AppColors.bottomSheetBG, borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Text("Address : ",
                style: TextStyle(
                    color: AppColors.appBarTitelColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600
                ),
              ),
              Expanded(child: Text(widget.sendAddress,
            style: TextStyle(
                  color: AppColors.appBarTitelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
              ),
              ))
            ],
          ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text("Coin : ",
                  style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600
                  ),
                ),
                Expanded(child: Text("${widget.coin.toString()} Slc",
                  style: TextStyle(
                      color: AppColors.appBarTitelColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400
                  ),
                ))
              ],
            ),
            SizedBox(height: 15,),
            Text("Ensure that the address and coin is correct .",
              style: TextStyle(
                  color:Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Cancel",
                    // bgColor: AppColors.primaryColor,
                    // textColor: Colors.white,
                    onTap: () {
                      Get.back(result: false);
                    },
                  ),
                ),
                SizedBox(width: 5.w,),
                Expanded(
                  child: CustomButton(
                    title: "Continue",
                    // bgColor: AppColors.primaryColor,
                    // textColor: Colors.white,
                    onTap: () async{
                      String abi=await widget.homeController.loadTokenABIFile();
                      bool isSuccess = await widget.homeController.sendCoinLocally(
                          sendAddress: widget.sendAddress,
                          coin: widget.coin,
                          privateKey: widget.privateKey,
                          tokenAbi: abi
                      );
                      if (isSuccess) {
                        Get.back();
                        _showMyDialog(context: context,
                            hash: widget.homeController.TransectionSuccesstxHash);
                      }
                    },
                  ),
                ),
              ],
            )
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
