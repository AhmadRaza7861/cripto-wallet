import 'dart:convert';

import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:get/get.dart';
import '../api/api.dart';
import '../api/api_service.dart';
import '../enum/api_status_type.dart';
import '../enum/error_type.dart';
import '../model/start_spin_model.dart';
import '../model/view_all_reward.dart';
import 'base_controller.dart';

class SpinnerController extends BaseController {
  final UserController _userController = Get.find();
  Rx<ApiStatus<List<ViewAllReward>>> viewAllReward =
      ApiStatus(data: <ViewAllReward>[]).obs;
  StartSpin? startSpin;

  Future<void> getAllReward() async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      viewAllReward.value.apiStatusType = ApiStatusType.loading;
      viewAllReward.refresh();
      await apiService.postRequest(
          url: ApiUrl.viewallrewards,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            viewAllReward.value.apiStatusType = ApiStatusType.none;
            viewAllReward.value.data.clear();
            List<ViewAllReward> tempList =
                viewAllRewardFromJson(jsonEncode(data["response"]));
            viewAllReward.value.data.addAll(tempList);
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
            viewAllReward.value.apiStatusType = ApiStatusType.error;
          });
    } catch (e) {
      showError(msg: "$e");
      viewAllReward.value.apiStatusType = ApiStatusType.error;
    }
    viewAllReward.refresh();
  }

  Future<void> getSpinValue() async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      params["useCoins"] = "true";
      startSpin = null;
      await apiService.postRequest(
          url: ApiUrl.startSpin,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            startSpin = startSpinFromJson(jsonEncode(data["response"]));
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }
}
