import 'dart:async';
import 'dart:io';

import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiveCoinBottomSheet extends StatefulWidget {
  const ReceiveCoinBottomSheet({Key? key}) : super(key: key);

  @override
  State<ReceiveCoinBottomSheet> createState() => _ReceiveCoinBottomSheetState();
}

class _ReceiveCoinBottomSheetState extends State<ReceiveCoinBottomSheet> {
  final UserController _userController = Get.find();
  final GlobalKey _qrCodeKey = GlobalKey();
  final GlobalKey _totalBalanceKey = GlobalKey();
  double _bottomSheetHeight = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      Size? size = _totalBalanceKey.currentContext?.size;
      _bottomSheetHeight = size?.height ?? 0;
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Size? size = _totalBalanceKey.currentContext?.size;
        _bottomSheetHeight = size?.height ?? 0;
        setState(() {});
        Timer(
          Duration(milliseconds: 100),
          () {
            Size? size = _totalBalanceKey.currentContext?.size;
            _bottomSheetHeight = size?.height ?? 0;
            setState(() {});
          },
        );
      });
      if(_userController.publicKey.value==""||_userController.publicKey.value==null)
      {
        SharedPreferences pref=await SharedPreferences.getInstance();
        _userController.publicKey.value=pref.getString("publickey").toString();
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    String data = _userController.publicKey.value;
    print("Height  ==>   ${_bottomSheetHeight}");
    return Container(
      key: _totalBalanceKey,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xff1F3355),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            30.r,
          ),
        ),
      ),
      child:
      Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15.h),
              Center(
                child: Container(
                  width: 100.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                width: 200.w,
                clipBehavior: Clip.antiAlias,
                // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gray.withOpacity(0.5.r),
                        spreadRadius: 0.5.r,
                        blurRadius: 0.5.r,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10.r)),
                child: Column(
                  children: [
                    RepaintBoundary(
                      key: _qrCodeKey,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.w),
                        child: QrImageView(
                          data: data,
                          backgroundColor: Colors.white,
                          version: QrVersions.auto,
                          size: 180.w,
                          gapless: true,
                          // embeddedImage: AssetImage(AppImage.imgLogo),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: const Size(40, 40),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(data),
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: data));
                      Get.back();
                      _userController.showSnack(msg: "Successfully Copy");
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(9.r),
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Color(0x20FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            AppImage.icCopy,

                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Copy",
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 25.w),
                  InkWell(
                    onTap: () {
                      _capturePng();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Color(0x20FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.share,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Share",
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
            ],
          ),
    );
  }

  Future<void> _capturePng() async {
    try {
      _userController.showLoader();
      RenderRepaintBoundary boundary = _qrCodeKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 10);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();

      final pathOfImage = File('${directory.path}/temp.png');
      if (!await pathOfImage.exists()) {
        pathOfImage.create();
      }
      await pathOfImage.writeAsBytes(pngBytes);
      _userController.dismissLoader();
      List<XFile> fileList = [];
      fileList.add(XFile(pathOfImage.path));
      Get.back();
      Share.shareXFiles(fileList);
    } catch (e) {
      _userController.showError(msg: "$e");
    }
  }
}
