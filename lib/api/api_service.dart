import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import 'logging_dio_interceptor.dart';

class ApiService {
  static final Dio _dio = Dio();

  final UserController _userController = Get.find();

  ApiService() {
    _dio.interceptors.add(LoggingDioInterceptor());
  }

  Future<void> postRequest({
    required String url,
    dynamic params,
    dynamic header,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String) onError,
  }) async {
    try {
      // logPrint('Method => POST , API URL ==> $url');
      logPrint('Params ==> $params');
      print("brearerToken - - - ${_userController.userResponseModel.value.brearerToken}");

      var headers = {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${_userController.userResponseModel.value.brearerToken}",
        // "X-Requested-With": "XMLHttpRequest"
      };
      print("Brearr Token ${_userController.userResponseModel.value.brearerToken}");
      if (header != null) {
        headers.addAll(header);
      }
      _dio.options.headers.addAll(headers);
      Map<String, dynamic> tempParams = {};
      tempParams["id"] = _userController.userResponseModel.value.user?.id;
      if (params != null) {
        if (params is dio.FormData) {
          params.fields.forEach((MapEntry<String, String> element) {
            tempParams[element.key] = element.value;
          });
          params.files.forEach((element) {
            tempParams[element.key] = element.value;
          });
        } else {
          tempParams.addAll(params);
        }
      }
      log('Params ==>456  ${headers}  ${tempParams}');
      var response = await _dio.post(url,
          data: params is dio.FormData
              ? dio.FormData.fromMap(tempParams)
              : tempParams);
      logger("response  ===>  11 ${jsonEncode(response.data)}");
      if (response.statusCode != 200) {
        onError(ErrorType.none, response.data['message']);
      } else {
        if (response.data is HashMap) {
          if (response.data["status"] != null) {
            if (response.data["status"] == false) {
              onError(ErrorType.none, response.data['message']);
              return;
            }
          }
        }
        Map<String, dynamic> data = Map();
        data["response"] = response.data;
        onSuccess(data);
        // onSuccess(data);
      }
    } on DioError catch (e) {
      logPrint('Error  ===>  $e  ${e.response}  ${e.type}');
      if (e.type == DioErrorType.unknown) {
        onError(ErrorType.internet, e.message ?? "");
      }
      if (e.response != null) {
        logPrint('Error  ===>  ${e.response?.data}  ${e.type}');
        onError(ErrorType.none,
            e.response?.data['message'] ?? e.response?.data['error']);
      }
    }catch(e){
      onError(ErrorType.internet, "$e");
    }
    return;
  }

  Future<void> getRequest({
    required String url,
    Map<String, dynamic>? header,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String?) onError,
  }) async {
    try {
      // logPrint('Method => GET , API URL ==> $url');
      var headers = {
        'Content-Type': 'application/json',
        // "Authorization":
        //     "Bearer ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      if (header != null) {
        _dio.options.headers.addAll(header);
      } else {
        _dio.options.headers.addAll(headers);
      }
      var response = await _dio.get(url);
      // log('response  ===>  $response');
      if (response.statusCode != 200) {
        onError(ErrorType.none, response.data['message']);
      } else {
        // if (response.data is HashMap) {
        //   if (response.data["status"] != null) {
        //     if (response.data["status"] == false) {
        //       onError(ErrorType.none, response.data['message']);
        //       return;
        //     }
        //   }
        // }
        Map<String, dynamic> data = Map();
        data["response"] = response.data;
        onSuccess(data);
      }
    } on DioError catch (e) {
      logPrint('Error 12 ===>  $e    ${e.type}');
      if (e.type == DioErrorType.unknown) {
        onError(ErrorType.internet, null);
      }
      if (e.response != null) {
        logPrint('Error12  ===>  ${e.response?.data}');
        onError(ErrorType.none,
            e.response?.data['message'] ?? e.response?.data["error"]);
      }
    }catch(e){
      onError(ErrorType.internet, "$e");
    }
    return;
  }

  Future<void> deleteRequest({
    required String url,
    Map<String, dynamic>? header,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String?) onError,
  }) async {
    try {
      // logPrint('Method => DELETE , API URL ==> $url');
      var headers = {
        'Content-Type': 'application/json',
        // "Authorization":
        //     "Bearer ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      if (header != null) {
        _dio.options.headers.addAll(header);
      } else {
        _dio.options.headers.addAll(headers);
      }
      var response = await _dio.delete(url);
      log('response  ===>  $response');
      if (response.statusCode != 200) {
        onError(ErrorType.none, response.data['message']);
      } else {
        if (response.data is HashMap) {
          if (response.data["status"] != null) {
            if (response.data["status"] == false) {
              onError(ErrorType.none, response.data['message']);
              return;
            }
          }
        }
        Map<String, dynamic> data = Map();
        data["response"] = response.data;
        onSuccess(data);
      }
    } on DioError catch (e) {
      logPrint('Error 12 ===>  $e    ${e.type}');
      if (e.type == DioErrorType.unknown) {
        onError(ErrorType.internet, null);
      }
      if (e.response != null) {
        logPrint('Error12  ===>  ${e.response?.data}');
        onError(ErrorType.none,
            e.response?.data['message'] ?? e.response?.data["error"]);
      }
    }catch(e){
      onError(ErrorType.internet, "$e");
    }
    return;
  }

  Future<void> putRequest({
    required String url,
    dynamic params,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String?) onError,
  }) async {
    try {
      // logPrint('Method => PUT , API URL ==> $url');
      logPrint('Params ==> $params');
      var headers = {
        'Content-Type': 'application/json',
        // "Authorization": "Token ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      _dio.options.headers.addAll(headers);
      var response = await _dio.put(url, data: params);
      logger("response   ===>   $response");
      onSuccess(json.decode(response.toString()));
    } on DioError catch (e) {
      logPrint('Error 12 ===>  $e    ${e.type}');
      if (e.type == DioErrorType.unknown) {
        onError(ErrorType.internet, null);
      }
      if (e.response != null) {
        logPrint('Error12  ===>  ${e.response?.data}');
        onError(ErrorType.none, e.response?.data['message']);
      }
    }catch(e){
      onError(ErrorType.internet, "$e");
    }
    return;
  }
}

ApiService apiService = ApiService();
