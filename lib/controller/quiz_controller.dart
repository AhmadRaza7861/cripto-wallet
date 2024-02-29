import 'dart:convert';
import 'dart:developer';
import 'package:crypto_wallet/controller/base_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/model/quiz_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../api/api.dart';
import '../api/api_service.dart';
import '../enum/api_status_type.dart';
import '../enum/error_type.dart';
import '../model/answer_submit_model.dart';
import '../model/quiz_result_history_model.dart';
import '../model/tickets_model.dart';
import '../util/logger.dart';
import '../view/bottom_bar/earn/quiz_screen/widget/quiz_submitted_dailog.dart';

class QuizController extends BaseController {
  final UserController _userController = Get.find();

  Rx<ApiStatus<List<QuizModel>>> viewAllQuizQuestion = ApiStatus(data: <QuizModel>[]).obs;
  Rx<ApiStatus<List<QuizResultHistory>>> quizResultHistory = ApiStatus(data: <QuizResultHistory>[]).obs;
  Rx<ApiStatus<TicketsModel>> ticketsModel = ApiStatus(data: TicketsModel()).obs;
  Rx<ApiStatus<List<SubmitModel>>> submitModel = ApiStatus(data: <SubmitModel>[]).obs;

  Future<void> getQuizQuestion() async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      viewAllQuizQuestion.value.apiStatusType = ApiStatusType.loading;
      viewAllQuizQuestion.refresh();
      await apiService.postRequest(
          url: ApiUrl.quizQuestion,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            viewAllQuizQuestion.value.apiStatusType = ApiStatusType.none;
            viewAllQuizQuestion.value.data.clear();
            QuizModel quizModel =
                quizModelFromJson(jsonEncode(data["response"]));
            viewAllQuizQuestion.value.data.add(quizModel);
            viewAllQuizQuestion.refresh();
          },
          onError: (ErrorType errorType, String msg) {
            print("onError - --  $msg");
            showError(msg: msg);
            viewAllQuizQuestion.value.apiStatusType = ApiStatusType.error;
          });
    } catch (e) {
      showError(msg: "$e");
    }
    viewAllQuizQuestion.refresh();
  }
  Future<void> getTickets() async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      ticketsModel.value.apiStatusType = ApiStatusType.loading;
      ticketsModel.refresh();
      await apiService.postRequest(
          url: ApiUrl.getTickets,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            ticketsModel.value.apiStatusType = ApiStatusType.none;
            TicketsModel ticketsModeltemp =
            ticketsModelFromJson(jsonEncode(data["response"]));
            ticketsModel.value.data = ticketsModeltemp;
            ticketsModel.refresh();
          },
          onError: (ErrorType errorType, String msg) {
            print("onError - --  $msg");
            showError(msg: msg);
            ticketsModel.value.apiStatusType = ApiStatusType.error;
          });
    } catch (e) {
      showError(msg: "$e");
    }
    ticketsModel.refresh();
  }

  Future<void> submitQuizAnswer({required Game question , required int index}) async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      params["gameId"] = question.gameId;
      List<Map<String, dynamic>> ansMapList = [];
      question.questions.forEach((element) {
        Map<String, dynamic> ansMap = {};
        ansMap["questionId"] = element.questionId;
        ansMap["ans"] = element.selectedAnsId;
        ansMapList.add(ansMap);
      });
      params["userSubmission"] = ansMapList;
      // return;

      await apiService.postRequest(
          url: ApiUrl.sendQuizAnswer,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Get.back();
            print(" message - -- -  ${data["response"]["message"]}");
            if(data["response"]["message"] == "fail"){
              logger("data - - -- $data");
              submitModel.value.data.clear();
              submitModel.value.apiStatusType = ApiStatusType.loading;
              submitModel.refresh();
              SubmitModel submitModeltemp =
              submitModelFromJson(jsonEncode(data["response"]));
              submitModel.value.data.add(submitModeltemp);
              submitModel.refresh();
              logger("data -- -- ${submitModel.value.data}");

               Get.dialog(QuizAlreadySubmittedDialog());

              // Game _games = viewAllQuizQuestion.value.data[0].games[index];
              // await getQuizQuestion();
              // List userAnswerList = [];
              // for(Question ele in _games.questions){
              //   userAnswerList.add(ele.answer);
              // }
              // logger("useranswer");
              // for( int i= 0 ; i < (_games.attempted?.userAnswers.length  ?? 0);  i++ ){
              //   _games.attempted?.userAnswers[i].ans == userAnswerList[i];
              //   logger("useranswer - - - ${_games.attempted?.userAnswers[i].ans} rightanswer ${userAnswerList[i]}");
              // }
              // question.attempted.userAnswers
              // Get.dialog(QuizAlreadySubmittedDialog());
            }else{
            showSnack(msg: data["response"]["message"]);}
          },
          onError: (ErrorType errorType, String msg) {
            logger("msg  - - -$msg");
            Get.back();
            showError(msg: msg);
          });
    } catch (e) {
      if (e is DioError) {
        logger("DioError  - - -$e");
      }
      logger("eeeeee  - - -$e");
      showError(msg: "$e");
    }
  }

  Future<void> getQuizResultHistory() async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      quizResultHistory.value.apiStatusType = ApiStatusType.loading;
      quizResultHistory.refresh();
      await apiService.postRequest(
          url: ApiUrl.getQuizResultHistory,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            quizResultHistory.value.apiStatusType = ApiStatusType.none;
            quizResultHistory.value.data.clear();
            List<QuizResultHistory> quizModel = quizResultHistoryFromJson(jsonEncode(data["response"]));
            quizResultHistory.value.data.addAll(quizModel);
            quizResultHistory.refresh();

            logger(
                "quizResultHistory = = = =${quizResultHistory.value.data.last.gameId}");
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
            quizResultHistory.value.apiStatusType = ApiStatusType.error;
          });
    } catch (e) {
      showError(msg: "$e");
    }
    quizResultHistory.refresh();
  }

}
