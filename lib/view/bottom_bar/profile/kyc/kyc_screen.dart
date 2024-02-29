import 'dart:io';

import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_fade_in_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  File? _aadharFCardImage,
      _aadharBCardImage,
      _panCardImage,
      _drivingLicenceImage,
      _voterIDImage,
      _passportImage;
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();
  List<String> _documentList = [];
  String? _selectedDocument;

  @override
  void initState() {
    super.initState();

    _documentList.add("Passport");
    _documentList.add("Driving Licence");
    _documentList.add("Aadhaar Card");
    _documentList.add("Pan Card");
    _documentList.add("VoterID");

    _selectedDocument = _documentList[0];
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
          appBar: AppBar(
            title: Text("KYC"),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Document Type",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: DropdownButton<String>(
                    value: _selectedDocument,
                    elevation: 16,
                    isExpanded: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600),
                    underline: Container(),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      _aadharFCardImage = _aadharBCardImage = _panCardImage =
                          _drivingLicenceImage =
                              _voterIDImage = _passportImage = null;
                      setState(() {
                        _selectedDocument = value;
                      });
                    },
                    items: _documentList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 15.h),
                if (_selectedDocument == "Aadhaar Card") ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      splashColor: Colors.transparent,
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png'],
                        );
                        if (result != null) {
                          _aadharFCardImage =
                              File(result.files.single.path ?? "");
                          setState(() {});
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: double.infinity,
                        height: 150.h,
                        // margin: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomFadeInImage(
                          url: _aadharFCardImage?.path ?? "",
                          placeHolderWidget: Center(
                            child: Text(
                              "Select Aadhaar card",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      splashColor: Colors.transparent,
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png'],
                        );
                        if (result != null) {
                          _aadharBCardImage =
                              File(result.files.single.path ?? "");
                          setState(() {});
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomFadeInImage(
                          url: _aadharBCardImage?.path ?? "",
                          placeHolderWidget: Center(
                            child: Text(
                              "Select Back Aadhaar card",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else if (_selectedDocument == "Pan Card") ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png'],
                        );
                        if (result != null) {
                          _panCardImage = File(result.files.single.path ?? "");
                          setState(() {});
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomFadeInImage(
                          url: _panCardImage?.path ?? "",
                          placeHolderWidget: Center(
                            child: Text(
                              "Select Front Pan Card",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else if (_selectedDocument == "Driving Licence") ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png'],
                        );
                        if (result != null) {
                          _drivingLicenceImage =
                              File(result.files.single.path ?? "");
                          setState(() {});
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomFadeInImage(
                          url: _drivingLicenceImage?.path ?? "",
                          placeHolderWidget: Center(
                            child: Text(
                              "Select Driving Licence",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else if (_selectedDocument == "VoterID") ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png'],
                        );
                        if (result != null) {
                          _voterIDImage = File(result.files.single.path ?? "");
                          setState(() {});
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomFadeInImage(
                          url: _voterIDImage?.path ?? "",
                          placeHolderWidget: Center(
                            child: Text(
                              "Select VoterID",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else if (_selectedDocument == "Passport") ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png'],
                        );
                        if (result != null) {
                          _passportImage = File(result.files.single.path ?? "");
                          setState(() {});
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomFadeInImage(
                          url: _passportImage?.path ?? "",
                          placeHolderWidget: Center(
                            child: Text(
                              "Select Passport",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 20.h),
                CustomButton(
                  title: "Upload",
                  onTap: () {
                    if (_selectedDocument == "Aadhaar Card") {
                      if (_aadharFCardImage == null) {
                        _userController.showError(
                            msg: "Please select front aadhar card");
                        return;
                      }
                      if (_aadharBCardImage == null) {
                        _userController.showError(
                            msg: "Please select back aadhar card");
                        return;
                      }
                    }

                    if (_selectedDocument == "Pan Card") {
                      if (_panCardImage == null) {
                        _userController.showError(
                            msg: "Please select front pan card");
                        return;
                      }
                    }

                    if (_selectedDocument == "Driving Licence") {
                      if (_drivingLicenceImage == null) {
                        _userController.showError(
                            msg: "Please select Driving Licence");
                        return;
                      }
                    }

                    if (_selectedDocument == "VoterID") {
                      if (_voterIDImage == null) {
                        _userController.showError(msg: "Please select VoterID");
                        return;
                      }
                    }

                    if (_selectedDocument == "Passport") {
                      if (_passportImage == null) {
                        _userController.showError(
                            msg: "Please select Passport");
                        return;
                      }
                    }

                    _userController.updateKyc(
                      aadharFImage: _aadharFCardImage,
                      aadharBImage: _aadharBCardImage,
                      panFImage: _panCardImage,
                      drivingLicImage: _drivingLicenceImage,
                      voterIDImage: _voterIDImage,
                      passportImage: _passportImage,
                    );
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        )
      ],
    );
  }
}
