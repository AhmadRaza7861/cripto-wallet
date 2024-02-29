import 'dart:convert';
import 'dart:developer';

import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails {
  Future<void> saveUserDetails(UserResponseModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("user", jsonEncode(userModel.toJson()));
  }

  Future<void> logoutUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("user");
  }

  Future<UserResponseModel> get getSaveUserDetails async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("user");
    logger("message  ==>  $userData");
    if (userData == null) {
      return UserResponseModel();
    }
    return userResponseModelFromJson(userData);
  }

  Future<void> saveTutorialShow({bool isTutorialShow = false}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isTutorialShow", isTutorialShow);
  }

  Future<bool> get isTutorialShow async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("isTutorialShow") ?? false;
  }

  Future<void> saveString(
      {required String title, required String value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(title, value);
  }

  Future<void> removeString({required String title}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String?> getString({required String title}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(title);
  }

  Future<void> saveBoolean({required String title, required bool value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(title, value);
  }

  Future<bool?> getBoolean({required String title}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(title);
  }

  Future<void> removeBoolean({required String title}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveTheme({required String title, required bool value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(title, value);
  }

  Future<bool?> getTheme({required String title}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(title);
  }
}
