import 'dart:convert';

import 'package:crypto_wallet/controller/base_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:get/get.dart';

import '../api/api.dart';
import '../api/api_service.dart';
import '../enum/api_status_type.dart';
import '../enum/error_type.dart';
import '../model/predict_question_model.dart';
import '../model/view_all_reward.dart';
import '../util/logger.dart';
import '../view/bottom_bar/earn/predict_and_win/widget/predict_submitted_dialog.dart';

class PredictController extends BaseController {
  final UserController _userController = Get.find();

  Rx<ApiStatus<List<PredictModel>>> predictQuestionList =
      ApiStatus(data: <PredictModel>[]).obs;

  Future<void> getPredictQuestion() async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      predictQuestionList.value.apiStatusType = ApiStatusType.loading;
      predictQuestionList.refresh();
      await apiService.postRequest(
          url: ApiUrl.getPredictQuestion,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            predictQuestionList.value.apiStatusType = ApiStatusType.none;
            predictQuestionList.value.data.clear();
            List<PredictModel> tempList = predictModelFromJson(jsonEncode(data["response"]));
            predictQuestionList.value.data.addAll(tempList);
            predictQuestionList.refresh();
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
            predictQuestionList.value.apiStatusType = ApiStatusType.error;
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }
  Future<void> submitPredictAnswer({required PredictModel predictModel , bool? last}) async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      params["questionId"] = predictModel.id;
      params["ans"] = predictModel.selectedAnsId;
      print("predictModel -* - -- - $params");

      await apiService.postRequest(
          url: ApiUrl.sendPredictAnswer,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            logger("msg  - - -yj");
            if(last == true ){
               Get.back();
               Get.dialog(PredictSubmittedDailog());
            }
            // Get.back();
            // Get.dialog(PredictSubmittedDailog());

            // showSnack(msg: data["response"]["message"]);
          },
          onError: (ErrorType errorType, String msg) {
            logger("msg  - - -$msg");
            Get.back();
            showError(msg: msg);
          });
    } catch (e) {

      logger("eeeeee  - - -$e");
      showError(msg: "$e");
    }
  }

}
