import 'dart:convert';
import 'dart:developer';

import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/api/api_service.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/controller/base_controller.dart';
import 'package:crypto_wallet/enum/api_status_type.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/enum/payment_type.dart';
import 'package:crypto_wallet/model/all_transaction_history_response_model.dart';
import 'package:crypto_wallet/model/available_currency_response_model.dart';
import 'package:crypto_wallet/model/deposit_info_response_model.dart';
import 'package:crypto_wallet/model/trade_bot_info_response_model.dart';
import 'package:crypto_wallet/model/tradebot_model.dart';
import 'package:crypto_wallet/model/transaction_history_response_model.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/model/with_draw_response_model.dart';
import 'package:crypto_wallet/util/logger.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class WalletController extends BaseController {
  final UserController _userController = Get.find();
  Rx<ApiStatus<List<AllTransactionHistoryResponseModel>>>
      transactionHistoryList =
      ApiStatus(data: <AllTransactionHistoryResponseModel>[]).obs;
  Rx<ApiStatus<List<User>>> saveAddressList = ApiStatus(data: <User>[]).obs;
  Rx<ApiStatus<List<TradebotModel>>> tradebotList = ApiStatus(data: <TradebotModel>[]).obs;
  RxList<AvailableCurrencyResponseModel> availableCurrencyResponseModel = <AvailableCurrencyResponseModel>[].obs;
  AvailableCurrencyResponseModel? selectedCurrency;

  Future<void> createStripePaymentIntent({required double amount}) async {
    removeUnFocusManager();
    if(selectedCurrency == null){
      showError(msg: "Please select currency");
    }
    showLoader();
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? "";
      params["amount"] = amount.toInt();
      params["currency"] = selectedCurrency?.currency;

      await apiService.postRequest(
          url: ApiUrl.paymentSheet,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Map stripeData = data["response"];
            logger("message  ==> Step 1  ${stripeData["paymentIntent"]}");
            Stripe.publishableKey= stripeData["publishableKey"];
            await Stripe.instance.applySettings();
            await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: stripeData["paymentIntent"],
                customerEphemeralKeySecret: stripeData["ephemeralKey"],
                customerId: stripeData["customer"],
                allowsDelayedPaymentMethods: true,
                merchantDisplayName: "Starline Beyond Crypto",
              ),
            );
            logger("message  ==> Step 12");
            try {
              // 3. display the payment sheet.
              await Stripe.instance.presentPaymentSheet();

              // showSnack(msg: "Payment successfully completed");
              paymentStatusUpdate(
                paymentMethod: PaymentType.stripe.name,
                paymentId: stripeData["paymentIntent"],
                amount: "${(amount / 100)}",
              );
            } on Exception catch (e) {
              if (e is StripeException) {
                showError(msg: "${e.error.localizedMessage}");
              } else {
                showError(msg: "${e}");
              }
            }
            logger("message  ==> Step 123");
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> getTransactionHistory({bool isShowLoader = true}) async {
    try {
      if (isShowLoader) {
        // showLoader();
        transactionHistoryList.value.apiStatusType = ApiStatusType.loading;
      }
      transactionHistoryList.refresh();
      Map<String, dynamic> params = {};
      await apiService.postRequest(
        url: ApiUrl.allTransactionHistory,
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          // dismissLoader();
          transactionHistoryList.value.apiStatusType = ApiStatusType.none;

          transactionHistoryList.value.data.clear();
          List<AllTransactionHistoryResponseModel> tempList =
              allTransactionHistoryResponseModelFromJson(
                  jsonEncode(data["response"]));
          transactionHistoryList.value.data.addAll(tempList);
        },
        onError: (ErrorType errorType, String? msg) {
          transactionHistoryList.value.apiStatusType = ApiStatusType.error;
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
      transactionHistoryList.value.apiStatusType = ApiStatusType.error;
    }
    transactionHistoryList.refresh();
  }

  Future<void> paymentStatusUpdate({
    required String paymentMethod,
    required String paymentId,
    required String amount,
  }) async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["method"] = paymentMethod.toUpperCase();
      params["intent"] = paymentId;
      params["amount"] = amount;
      params["status"] = "SUCCESS";
      params["currency"] = selectedCurrency?.currency;

      await apiService.postRequest(
        url: ApiUrl.updatePaymentStatus,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();
          Get.back();
          // await _userController.getUserInfo(isScreenChange: false);
          // getTransactionHistory(isShowLoader: false);
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<TransactionHistoryResponseModel?> getTransactionDetails({
    required int transactionId,
  }) async {
    TransactionHistoryResponseModel? transactionHistoryResponseModel;
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["transactionId"] = transactionId;

      await apiService.postRequest(
        url: ApiUrl.transactionDetails,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();
          transactionHistoryResponseModel =
              TransactionHistoryResponseModel.fromJson(data["response"]);
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
    return transactionHistoryResponseModel;
  }

  Future<bool> addressBookUpdate({
    required String address,
    String action = "ADD",
  }) async {
    bool isSuccessFull = false;
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["action"] = action;
      params["address"] = address;

      await apiService.postRequest(
        url: ApiUrl.addressBookUpdate,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();
          saveAddressList.value.apiStatusType = ApiStatusType.none;
          saveAddressList.value.data.clear();

          List<User> tempUserList =
              List<User>.from(data["response"].map((x) => User.fromJson(x)));
          saveAddressList.value.data.addAll(tempUserList);
          isSuccessFull = true;
        },
        onError: (ErrorType errorType, String? msg) {
          saveAddressList.value.apiStatusType = ApiStatusType.error;
          showError(msg: msg);
        },
      );
    } catch (e) {
      saveAddressList.value.apiStatusType = ApiStatusType.none;
      showError(msg: "$e");
    }
    saveAddressList.refresh();
    return isSuccessFull;
  }

  Future<void> getAddressBookView({bool isShowLoader = true}) async {
    try {
      if (isShowLoader) {
        // showLoader();
        saveAddressList.value.apiStatusType = ApiStatusType.loading;
      }
      transactionHistoryList.refresh();
      Map<String, dynamic> params = {};

      await apiService.postRequest(
        url: ApiUrl.addressBookView,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          // dismissLoader();
          saveAddressList.value.apiStatusType = ApiStatusType.none;
          saveAddressList.value.data.clear();
          List<User> tempUserList =
              List<User>.from(data["response"].map((x) => User.fromJson(x)));
          saveAddressList.value.data.addAll(tempUserList);
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
          saveAddressList.value.apiStatusType = ApiStatusType.error;
        },
      );
    } catch (e) {
      showError(msg: "$e");
      saveAddressList.value.apiStatusType = ApiStatusType.error;
    }
    transactionHistoryList.refresh();
  }

  Future<void> withDraw({required Map<String, dynamic> params}) async {
    try {
      removeUnFocusManager();
      showLoader();
      await apiService.postRequest(
        url: ApiUrl.withdraw,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();
          _userController.userResponseModel.value.user =
              User.fromJson(data["response"]["user"]);
          _userController.userResponseModel.refresh();
          Get.back();
          showSnack(msg: "Successfully withdraw request send");
          // getTransactionHistory(isShowLoader: false);
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<WithDrawResponseModel?> withDrawInfo(
      {required int transactionId}) async {
    WithDrawResponseModel? withDrawResponseModel;
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};
      params["transactionId"] = transactionId;
      await apiService.postRequest(
        url: ApiUrl.withdrawInfo,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();
          withDrawResponseModel =
              withDrawResponseModelFromJson(jsonEncode(data["response"]));
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
    return withDrawResponseModel;
  }

  Future<TradeBotInfoResponseModel?> tradeBotInfo(
      {required int transactionId}) async {
    TradeBotInfoResponseModel? tradeBotInfoResponseModel;
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};
      params["tradeId"] = transactionId;
      await apiService.postRequest(
        url: ApiUrl.tradebotInfo,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();
          tradeBotInfoResponseModel = tradeBotInfoResponseModelFromJson(
              jsonEncode(data["response"][0]));
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
    return tradeBotInfoResponseModel;
  }

  Future<DepositInfoResponseModel?> depositInfo(
      {required int transactionId}) async {
    DepositInfoResponseModel? depositInfoResponseModel;
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};
      params["depositId"] = transactionId;
      await apiService.postRequest(
        url: ApiUrl.depositInfo,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();
          depositInfoResponseModel =
              depositInfoResponseModelFromJson(jsonEncode(data["response"][0]));
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
    return depositInfoResponseModel;
  }

  Future<void> getPaymentCurrencyList() async {
    try {
      removeUnFocusManager();
      await apiService.getRequest(
        url: ApiUrl.currency,
        onSuccess: (Map<String, dynamic> data) async {
          selectedCurrency = null;
          availableCurrencyResponseModel.value =
              availableCurrencyResponseModelFromJson(
                  jsonEncode(data["response"]));
          availableCurrencyResponseModel.refresh();
          if(availableCurrencyResponseModel.isNotEmpty){
            selectedCurrency = availableCurrencyResponseModel[0];
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

  Future<void> getTradeBotList() async {
    try {
      tradebotList.refresh();
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? "";
      logger("tradebotList    = = == = }");

      await apiService.postRequest(
        url: ApiUrl.tradBot,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          // dismissLoader();
          logger("tradebotList    = = == = }");

          tradebotList.value.apiStatusType = ApiStatusType.none;
          tradebotList.value.data.clear();
          List<TradebotModel> tempUserList = tradebotModelFromJson(jsonEncode(data["response"]));
          tradebotList.value.data.addAll(tempUserList);
          tradebotList.refresh();
          print("tradebotList    = = == = =${tradebotList.value.data.first.user?.userId}");
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
          tradebotList.value.apiStatusType = ApiStatusType.error;
        },
      );
    } catch (e) {
      showError(msg: "$e");
      tradebotList.value.apiStatusType = ApiStatusType.error;
    }
    tradebotList.refresh();
  }

}
