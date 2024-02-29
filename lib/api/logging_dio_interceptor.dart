import 'dart:developer';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getX;

class LoggingDioInterceptor implements Interceptor {
  UserController _userController = getX.Get.find();

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // logger(
    //     "message ==> response  $err ${err.response?.statusCode}    ${err.response?.data}");
    // logger(
    //     "message ==> response  ${err.requestOptions.baseUrl}   123 ${err.requestOptions.uri}    ");
    if (err.response?.statusCode == 401) {
      // _userController. userToken.value = LoginResponseModel();
      // _userController. userToken.refresh();
      // getX.Get.offAll(() => SignInUpScreen());
      _userController.dismissLoader();
      _userController.logout();
      // if (err.response?.data["msg"] != null) {
      //   _userController.showError(msg: err.response?.data["msg"] ?? "");
      // }
    }
    handler.next(err);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      // logger(
      //     "message ==> response  $response ${response.statusCode}    ${response.data}");
    }
    if (response.statusCode == 401) {
      // _userController. userToken.value = LoginResponseModel();
      // _userController. userToken.refresh();
      // getX.Get.offAll(() => SignInUpScreen());
      _userController.dismissLoader();
      _userController.logout();
      // if (err.response?.data["msg"] != null) {
      //   _userController.showError(msg: err.response?.data["msg"] ?? "");
      // }
    }
    handler.next(response);
  }
}
