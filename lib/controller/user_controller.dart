import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/api/api_service.dart';
import 'package:crypto_wallet/controller/base_controller.dart';
import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/enum/api_status_type.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/my_address_response_model.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:crypto_wallet/view/auth/login_first_screen.dart';
import 'package:crypto_wallet/view/auth/register/otp_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/bottom_bar_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart' as dio;
import '../model/Coupon_response_model.dart';
import '../util/user_details.dart';
import 'package:http_parser/http_parser.dart';

import '../view/auth/privacy/custom_lock_screen.dart';
import '../view/auth/privacy/lock_screen.dart';
import '../view/bottom_bar/profile/app_security_screen/app_security.dart';
import '../view/bottom_bar/profile/app_security_screen/biometrics_security_screen.dart';
import '../view/bottom_bar/profile/app_security_screen/password_lock_screen.dart';
import '../view/enter_password/enter_password_screen.dart';
import 'package:web3dart/web3dart.dart';
class UserController extends BaseController {
  Rx<UserResponseModel> userResponseModel = UserResponseModel().obs;
  final UserDetails _userDetails = UserDetails();
  RxString? userPasscode;
  var publicKey="".obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController landMarkController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  Rx<ApiStatus<List<MyAddressResponseModel>>> myAddressList =
      ApiStatus(data: <MyAddressResponseModel>[]).obs;
  Rx<ApiStatus<List<CouponModel>>> myCouponList =
      ApiStatus(data: <CouponModel>[]).obs;
  File? userImageFile;

  String countryCode = "+971";
  String? otp;
  RxBool isRememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    _userDetails.getSaveUserDetails.then((value) {
      logger("userTokenAccess ====>   ${value.toJson()}");
      userResponseModel.value = value;
    });
    userResponseModel.listen((data) {
      _userDetails.saveUserDetails(data);
    });
  }

  Future<void> loginWithEmail() async {
    removeUnFocusManager();
    try {
      if (emailController.text.isEmpty) {
        showError(msg: "Please enter your email id");
        return;
      }

      if (passwordController.text.isEmpty) {
        showError(msg: "Please enter your password");
        return;
      }
      showLoader();
      Map<String, dynamic> params = {};
      params["email"] = emailController.text;
      params["password"] = passwordController.text;
      params["fcmToken"] = await FirebaseMessaging.instance.getToken();
      print("Params ${params}");
      await apiService.postRequest(
          url: ApiUrl.loginWithEmail,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            String publicAddress=await getPublicAddress(privateKey: data["response"]["user"]["wallet"]);
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString("publickey", publicAddress);
            dismissLoader();
            // Map<String, dynamic> user = data['response']['user'];
            // user['publickey'] = publicAddress;
            userResponseModel.value =
                userResponseModelFromJson(jsonEncode(data["response"]));
            publicKey.value=publicAddress;
            await _userDetails.saveString(
                title: AppString.email, value: params["email"]);
            await _userDetails.saveString(
                title: AppString.password, value: params["password"]);
            Get.offAll(() => const PasswordLockScreen());
          },
          onError: (ErrorType errorType, String? msg) {
            logger("onError - - -- $msg");
            showError(msg: "The email or password you entered is incorrect.");
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> getRememberMeUser() async {
    emailController.text =
        await _userDetails.getString(title: AppString.email) ?? "";
    passwordController.text =
        await _userDetails.getString(title: AppString.password) ?? "";
  }

  Future<void> getUserInfo({bool isScreenChange = true}) async {
    removeUnFocusManager();
    String userPin = await _userDetails.getString(title: "userSecurityPin") ?? '';
    bool biometrics = await _userDetails.getBoolean(title: "biometricSecurity") ?? false ;
    print("userPin    ==  ${userPin}");

    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["fcmToken"] = await FirebaseMessaging.instance.getToken();
      await apiService.postRequest(
        url: ApiUrl.userInfo,
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          print("GET USER INFO ");
          userResponseModel.value.user =
              User.fromJson(data["response"]["user"]);
          userResponseModel.refresh();
          if (isScreenChange) {
            print("  fkvfdldfkmkdf[    ");
            print("userPin 1   ==  ${userPin}");

            if(userPin.isNotEmpty || biometrics == true){
              print("userPin 2   ==  ${userPin}");
              print("biometrics   ==  ${biometrics}");
              Get.offAll(() =>  EnterPasswordScreen());
            }else {
              Get.offAll(() => const PasswordLockScreen());
            }
          }
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> updateUserInfo() async {
    removeUnFocusManager();
    try {
      Map<String, dynamic> params = {};
      params["firstname"] = firstNameController.text;
      params["lastname"] = lastNameController.text;
      params["lastname"] = lastNameController.text;
      params["phone"] = "$countryCode${phoneController.text}";
      params["country_code"] = countryCode;
      if (userImageFile != null) {
        params["photo"] = await dio.MultipartFile.fromFile(
          userImageFile!.path,
          contentType:
              MediaType("image", "${userImageFile!.path.split(".").last}"),
        );
      }
      showLoader();
      await apiService.postRequest(
        url: ApiUrl.userUpdate,
        params: dio.FormData.fromMap(params),
        header: {"Content-Type": "multipart/form-data"},
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          userResponseModel.value.user =
              User.fromJson(data["response"]["user"]);
          userResponseModel.refresh();
          Get.back();
          showSnack(msg: "Successfully user info updated");
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> register() async {
    removeUnFocusManager();
    try {
      if (firstNameController.text.isEmpty) {
        showError(msg: "Please enter your first name");
        return;
      }

      if (lastNameController.text.isEmpty) {
        showError(msg: "Please enter your last name");
        return;
      }

      if (phoneController.text.isEmpty) {
        showError(msg: "Please enter your phone number");
        return;
      }

      if (emailController.text.isEmpty) {
        showError(msg: "Please enter your email id");
        return;
      }

      if (passwordController.text.isEmpty) {
        showError(msg: "Please enter your password");
        return;
      }

      showLoader();
      Map<String, dynamic> params = {};
      params["phone"] = "${phoneController.text}";
      params["email"] = emailController.text;
      params["password"] = passwordController.text;
      params["firstname"] = firstNameController.text;
      params["lastname"] = lastNameController.text;
      params["referralCode"] = referralCodeController.text;
      params["country_code"] = countryCode;
      params["fcmToken"] = await FirebaseMessaging.instance.getToken();

      await apiService.postRequest(
          url: ApiUrl.register,
          params: params,
          onSuccess: (Map<String, dynamic> data) async{
            String publicAddress=await getPublicAddress(privateKey: data["response"]["user"]["wallet"]);
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString("publickey", publicAddress);
            dismissLoader();
            userResponseModel.value =
                userResponseModelFromJson(jsonEncode(data["response"]));
            Get.offAll(() => const PasswordLockScreen());
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<bool> checkEmail() async {
    bool isSuccess = false;
    removeUnFocusManager();
    try {
      if (firstNameController.text.isEmpty) {
        showError(msg: "Please enter your first name");
        return isSuccess;
      }

      if (lastNameController.text.isEmpty) {
        showError(msg: "Please enter your last name");
        return isSuccess;
      }

      if (phoneController.text.isEmpty) {
        showError(msg: "Please enter your phone number");
        return isSuccess;
      }

      if (emailController.text.isEmpty) {
        showError(msg: "Please enter your email id");
        return isSuccess;
      }

      if (passwordController.text.isEmpty) {
        showError(msg: "Please enter your password");
        return isSuccess;
      }

      showLoader();
      Map<String, dynamic> params = {};
      params["email"] = emailController.text;

      await apiService.postRequest(
          url: ApiUrl.checkEmail,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            isSuccess = true;
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    return isSuccess;
  }

  Future<bool> checkPhone({bool isRegisterUser = true}) async {
    bool isSuccess = false;
    removeUnFocusManager();
    try {
      if (isRegisterUser) {
        if (firstNameController.text.isEmpty) {
          showError(msg: "Please enter your first name");
          return isSuccess;
        }

        if (lastNameController.text.isEmpty) {
          showError(msg: "Please enter your last name");
          return isSuccess;
        }
      }

      if (phoneController.text.isEmpty) {
        showError(msg: "Please enter your phone number");
        return isSuccess;
      }

      if (isRegisterUser) {
        if (emailController.text.isEmpty) {
          showError(msg: "Please enter your email id");
          return isSuccess;
        }

        if (passwordController.text.isEmpty) {
          showError(msg: "Please enter your password");
          return isSuccess;
        }
      }

      showLoader();
      Map<String, dynamic> params = {};
      params["phone"] = "$countryCode${phoneController.text}";

      await apiService.postRequest(
          url: ApiUrl.checkPhone,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            isSuccess = true;
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    return isSuccess;
  }

  Future<bool> sendPhoneOTP(
      {bool isScreenChange = true, bool isRegisterUser = true}) async {
    bool isSuccess = false;
    removeUnFocusManager();
    try {
      if (isRegisterUser) {
        if (firstNameController.text.isEmpty) {
          showError(msg: "Please enter your first name");
          return isSuccess;
        }

        if (lastNameController.text.isEmpty) {
          showError(msg: "Please enter your last name");
          return isSuccess;
        }
      }

      if (phoneController.text.isEmpty) {
        showError(msg: "Please enter your phone number");
        return isSuccess;
      }

      if (isRegisterUser) {
        if (emailController.text.isEmpty) {
          showError(msg: "Please enter your email id");
          return isSuccess;
        }

        if (passwordController.text.isEmpty) {
          showError(msg: "Please enter your password");
          return isSuccess;
        }
      }

      showLoader();
      Map<String, dynamic> params = {};
      params["phone"] = "$countryCode${phoneController.text}";
      params["email"] = emailController.text;
      params["password"] = passwordController.text;
      params["firstname"] = firstNameController.text;
      params["lastname"] = lastNameController.text;

      await apiService.postRequest(
          url: ApiUrl.sendOTP,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            if (!isRegisterUser) {
              params["isPhoneOTP"] = true;
            }
            otp = "${data["response"]["otp"]}";
            if (isScreenChange) {
              Get.to(() => OtpScreen(params: params));
            } else {
              showSnack(msg: "OTP Send successFully");
            }
            isSuccess = true;
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    return isSuccess;
  }

  Future<bool> sendEmailOTP({bool isScreenChange = true}) async {
    bool isSuccess = false;
    removeUnFocusManager();
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["email"] = userResponseModel.value.user?.email ?? "";
      params["isEmailOTP"] = true;

      await apiService.postRequest(
          url: ApiUrl.sendEmailOTP,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            otp = "${data["response"]["otp"]}";
            if (isScreenChange) {
              Get.to(() => OtpScreen(params: params));
            } else {
              showSnack(msg: "OTP Send successFully");
            }
            isSuccess = true;
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    return isSuccess;
  }

  Future<bool> verifyEmail() async {
    bool isSuccess = false;
    removeUnFocusManager();
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["email"] = userResponseModel.value.user?.email ?? "";
      params["isEmailOTP"] = true;

      await apiService.postRequest(
          url: ApiUrl.verifyEmail,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            isSuccess = true;
            await getUserInfo(isScreenChange: false);
            Get.back();
            showSnack(msg: data["response"]["message"]);
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    return isSuccess;
  }

  Future<bool> verifyPhone() async {
    bool isSuccess = false;
    removeUnFocusManager();
    try {
      showLoader();
      Map<String, dynamic> params = {};
      await apiService.postRequest(
          url: ApiUrl.verifyPhone,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            isSuccess = true;
            Get.back();
            await updateUserInfo();
            // await getUserInfo(isScreenChange: false);
            // showSnack(msg: data["response"]["message"]);
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    return isSuccess;
  }

  void logout() {
    userResponseModel.value = UserResponseModel();
    Get.offAll(() => const LoginFirstScreen());
  }

  void clearData() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    referralCodeController.clear();
    countryCode = "+971";
    isRememberMe.value = false;
  }

  Future<void> makePhoneCall({required String phoneNumber}) async {
    Uri uri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showError(msg: "Could not launch $phoneNumber");
    }
  }

  Future<void> sendMail({required String mail}) async {
    print("Mail ===>  $mail");
    logger("Mail ===>  $mail");
    Uri uri = Uri.parse("mailto:$mail");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showError(msg: "Could not launch $mail");
    }
  }

  Future<bool> forgotPassword() async {
    bool isSuccess = false;
    removeUnFocusManager();
    try {
      if (emailController.text.isEmpty) {
        showError(msg: "Please enter your email id");
        return isSuccess;
      }

      showLoader();
      Map<String, dynamic> params = {};
      params["email"] = "${emailController.text}";

      await apiService.postRequest(
          url: ApiUrl.userForgotPassword,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            Map<String, dynamic> responseData = {};
            responseData["isResetPassword"] = true;
            responseData.addAll(data["response"]);
            otp = "${data["response"]["otp"]}";
            Get.to(() => OtpScreen(params: responseData));

            isSuccess = true;
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    return isSuccess;
  }

  Future<bool> changePassword(
      {required String newPassword,
      required Map<String, dynamic> userData}) async {
    bool isSuccess = false;
    removeUnFocusManager();
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["id"] = "${userData["user"]["id"]}";
      params["password"] = newPassword;

      await apiService.postRequest(
          url: ApiUrl.userResetPassword,
          params: params,
          header: {"Authorization": "Bearer ${userData["user"]["bearer"]}"},
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            Get.offAll(() => LoginFirstScreen());
            showSnack(msg: "Password change successfully");
            isSuccess = true;
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    return isSuccess;
  }

  Future<void> addAddress() async {
    removeUnFocusManager();
    try {
      final ShopController _shopController = Get.find();
      _shopController.selectedAddress = null;

      if (addressLine1Controller.text.isEmpty) {
        showError(msg: "Please enter address line 1");
        return;
      }
      if (addressLine2Controller.text.isEmpty) {
        showError(msg: "Please enter address line 2");
        return;
      }
      if (landMarkController.text.isEmpty) {
        showError(msg: "Please enter Landmark");
        return;
      }
      if (countryController.text.isEmpty) {
        showError(msg: "Please enter country name");
        return;
      }
      if (stateController.text.isEmpty) {
        showError(msg: "Please enter state name");
        return;
      }
      if (pinCodeController.text.isEmpty) {
        showError(msg: "Please enter pinCode");
        return;
      }
      if (pinCodeController.text.length < 5) {
        showError(msg: "Please enter valid pinCode");
        return;
      }

      showLoader();
      Map<String, dynamic> params = {};
      params["addressLine1"] = addressLine1Controller.text;
      params["addressLine2"] = addressLine2Controller.text;
      params["landmark"] = landMarkController.text;
      params["pincode"] = pinCodeController.text;
      params["city"] = cityController.text;
      params["state"] = stateController.text;
      params["country"] = countryController.text;

      await apiService.postRequest(
          url: ApiUrl.userAddressAdd,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            List<MyAddressResponseModel> tempAddressList =
                myAddressResponseModelFromJson(jsonEncode(data["response"]));
            myAddressList.value.data.clear();
            myAddressList.value.data.addAll(tempAddressList);
            Get.back();
            showSnack(msg: "New address add successfully");
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    myAddressList.refresh();
  }

  Future<void> editAddress(
      {required MyAddressResponseModel myAddressResponseModel}) async {
    removeUnFocusManager();
    try {
      final ShopController _shopController = Get.find();
      _shopController.selectedAddress = null;

      if (addressLine1Controller.text.isEmpty) {
        showError(msg: "Please enter address line 1");
        return;
      }
      if (addressLine2Controller.text.isEmpty) {
        showError(msg: "Please enter address line 2");
        return;
      }
      if (landMarkController.text.isEmpty) {
        showError(msg: "Please enter Landmark");
        return;
      }
      if (countryController.text.isEmpty) {
        showError(msg: "Please enter country name");
        return;
      }
      if (stateController.text.isEmpty) {
        showError(msg: "Please enter state name");
        return;
      }
      if (pinCodeController.text.isEmpty) {
        showError(msg: "Please enter pinCode");
        return;
      }
      if (pinCodeController.text.length < 5) {
        showError(msg: "Please enter valid pinCode");
        return;
      }

      showLoader();
      Map<String, dynamic> params = {};

      params["addressId"] = myAddressResponseModel.id ?? 0;
      params["addressLine1"] = addressLine1Controller.text;
      params["addressLine2"] = addressLine2Controller.text;
      params["landmark"] = landMarkController.text;
      params["pincode"] = pinCodeController.text;
      params["city"] = cityController.text;
      params["state"] = stateController.text;
      params["country"] = countryController.text;

      await apiService.postRequest(
          url: ApiUrl.userAddressEdit,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            List<MyAddressResponseModel> tempAddressList =
                myAddressResponseModelFromJson(jsonEncode(data["response"]));
            await getMyAddress();
            Get.back();
            showSnack(msg: "Address updated successfully");
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
    myAddressList.refresh();
  }

  Future<void> getMyAddress() async {
    try {
      final ShopController _shopController = Get.find();
      _shopController.selectedAddress = null;

      myAddressList.value.apiStatusType = ApiStatusType.loading;
      myAddressList.refresh();

      await apiService.postRequest(
          url: ApiUrl.userAddressViewAll,
          onSuccess: (Map<String, dynamic> data) {
            myAddressList.value.apiStatusType = ApiStatusType.none;
            List<MyAddressResponseModel> tempAddressList =
                myAddressResponseModelFromJson(jsonEncode(data["response"]));
            myAddressList.value.data.clear();
            myAddressList.value.data.addAll(tempAddressList);
          },
          onError: (ErrorType errorType, String? msg) {
            myAddressList.value.apiStatusType = ApiStatusType.error;
            showError(msg: msg);
          });
    } catch (e) {
      myAddressList.value.apiStatusType = ApiStatusType.error;
      showError(msg: "$e");
    }
    myAddressList.refresh();
  }

  Future<void> deActiveAccount() async {
    try {
      showLoader();
      await apiService.postRequest(
          url: ApiUrl.deactivateAccount,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            logout();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> updateKyc({
    required File? aadharFImage,
    required File? aadharBImage,
    required File? panFImage,
    required File? drivingLicImage,
    required File? voterIDImage,
    required File? passportImage,
  }) async {
    try {
      Map<String, dynamic> params = {};
      if (aadharFImage != null && aadharBImage != null) {
        params["aadhar_front"] = await dio.MultipartFile.fromFile(
          aadharFImage.path ?? "",
          contentType:
              MediaType("image", "${aadharFImage.path.split(".").last}"),
        );
        params["aadhar_back"] = await dio.MultipartFile.fromFile(
          aadharBImage.path ?? "",
          contentType:
              MediaType("image", "${aadharBImage.path.split(".").last}"),
        );
      } else if (panFImage != null) {
        params["pan"] = await dio.MultipartFile.fromFile(
          panFImage.path ?? "",
          contentType: MediaType("image", "${panFImage.path.split(".").last}"),
        );
      } else if (drivingLicImage != null) {
        params["driving_license"] = await dio.MultipartFile.fromFile(
          drivingLicImage.path ?? "",
          contentType:
              MediaType("image", "${drivingLicImage.path.split(".").last}"),
        );
      } else if (voterIDImage != null) {
        params["voterID"] = await dio.MultipartFile.fromFile(
          voterIDImage.path ?? "",
          contentType:
              MediaType("image", "${voterIDImage.path.split(".").last}"),
        );
      } else if (passportImage != null) {
        params["passport"] = await dio.MultipartFile.fromFile(
          passportImage.path ?? "",
          contentType:
              MediaType("image", "${passportImage.path.split(".").last}"),
        );
      }
      showLoader();
      await apiService.postRequest(
        url: ApiUrl.kycUpload,
        params: dio.FormData.fromMap(params),
        header: {"Content-Type": "multipart/form-data"},
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();
          await getUserInfo(isScreenChange: false);
          Get.back();
          showSnack(msg: "Successfully KYC Uploaded");
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
  }


  Future<void> getMyCoupon() async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = userResponseModel.value.user?.id ?? 0;
      myCouponList.value.apiStatusType = ApiStatusType.loading;
      myCouponList.refresh();
      await apiService.postRequest(
          url: ApiUrl.coupons,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            myCouponList.value.apiStatusType = ApiStatusType.none;
            CouponModel tempAddressList = couponModelFromJson(jsonEncode(data["response"]));
            myCouponList.value.data.clear();
            myCouponList.value.data.add(tempAddressList);
            logger("myCouponList = = = =${myCouponList.value.data[0].shopping[0].coupon}");
          },
          onError: (ErrorType errorType, String? msg) {
            myCouponList.value.apiStatusType = ApiStatusType.error;
            showError(msg: msg);
          });
    } catch (e) {
      myCouponList.value.apiStatusType = ApiStatusType.error;
      showError(msg: "$e");
    }
    myCouponList.refresh();
  }


  void clearAddress() {
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    landMarkController.clear();
    pinCodeController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
  }

   Future<String> getPublicAddress({required String privateKey}) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    return address.hex;
  }
}
