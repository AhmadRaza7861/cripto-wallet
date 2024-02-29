import 'dart:convert';

import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/api/api_service.dart';
import 'package:crypto_wallet/controller/base_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/enum/api_status_type.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/exchage_info_response_model.dart';
import 'package:crypto_wallet/model/transaction_history_response_model.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../util/app_constant.dart';
import '../util/user_details.dart';

class HomeController extends BaseController {
  final UserDetails _userDetails = UserDetails();

  final UserController _userController = Get.find();
  RxMap<String, Symbol> symbolInfoResponseMap = <String, Symbol>{}.obs;
  Rx<ApiStatus<List<User>>> userList = ApiStatus(data: <User>[]).obs;
  Rx<ApiStatus<List<TransactionHistoryResponseModel>>>
      transactionHistoryByUserList =
      ApiStatus(data: <TransactionHistoryResponseModel>[]).obs;
  int? transactionHistoryByUserId;
  RxBool isLightTheme = false.obs;


  Future<void> getExchangeInfo() async {
    try {
      await apiService.getRequest(
        url: ApiUrl.bExchangeInfo,
        onSuccess: (Map<String, dynamic> data) {
          ExchangeInfoResponseModel exchangeInfoResponseModel =
              exchangeInfoResponseModelFromJson(jsonEncode(data["response"]));

          for (var element in exchangeInfoResponseModel.symbols) {
            symbolInfoResponseMap[element.symbol ?? ""] = element;
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

  Future<void> getTransactionUser() async {
    try {
      userList.value.apiStatusType = ApiStatusType.loading;
      userList.refresh();
      await apiService.postRequest(
        url: ApiUrl.transactionUniqueUser,
        onSuccess: (Map<String, dynamic> data) {
          userList.value.apiStatusType = ApiStatusType.none;
          userList.value.data.clear();
          List<User> tempUserList =
              List<User>.from(data["response"].map((x) => User.fromJson(x)));
          userList.value.data.addAll(tempUserList);
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
          userList.value.apiStatusType = ApiStatusType.error;
        },
      );
    } catch (e) {
      userList.value.apiStatusType = ApiStatusType.error;
      showError(msg: "$e");
    }
    userList.refresh();
  }

  Future<void> getTransactionHistoryByUser() async {
    try {
      transactionHistoryByUserList.value.apiStatusType = ApiStatusType.loading;
      transactionHistoryByUserList.refresh();
      Map<String, dynamic> params = {};
      params["to"] = transactionHistoryByUserId;
      await apiService.postRequest(
        url: ApiUrl.transactionHistory,
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          transactionHistoryByUserList.value.apiStatusType = ApiStatusType.none;
          transactionHistoryByUserList.value.data.clear();
          List<TransactionHistoryResponseModel> tempList =
              transactionHistoryResponseModelFromJson(
                  jsonEncode(data["response"]));
          transactionHistoryByUserList.value.data.addAll(tempList);
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
    transactionHistoryByUserList.refresh();
  }

  Future<String> loadTokenABIFile() async {
    final ByteData data = await rootBundle.load('assets/abi/tokenAbi.js');
    final String content = String.fromCharCodes(data.buffer.asUint8List());
    return content;
    // Now you can use 'content' which contains the ABI file data.
  }

  final String providerUrl =
     // "https://rpc-mumbai.maticvigil.com";
      "https://polygon-mumbai.blockpi.network/v1/rpc/public";
  final EthereumAddress contractAddress = EthereumAddress.fromHex("0x4dEcE918E8abD4B1A4205A7A79bd0A6038b8F068");
   String TransectionSuccesstxHash="";
   String ApproveResponse=false.toString();
  Future<bool> sendCoinLocally({required String sendAddress, double coin = 0,required String privateKey,required String tokenAbi}) async {
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};
      params["to"] = sendAddress;
      params["amount"] = coin;

      //web3 provider
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);

      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(tokenAbi, 'MATIC'), contractAddress);

      final credentials = await ethClient.credentialsFromPrivateKey(privateKey);
      final transferFunction = contract.function('transfer');

      final List<dynamic> decimals = await ethClient.call(
        contract: contract,
        function: contract.function('decimals'),
        params: [],
      );
      String cleanedInput = coin.toString().replaceAll(RegExp(r'[^0-9-]'), '');
      BigInt amount = BigInt.parse(cleanedInput) * BigInt.from(10).pow(18);


       TransectionSuccesstxHash = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: transferFunction,
          parameters: [EthereumAddress.fromHex(sendAddress), amount],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 210000,
        ),
        // fetchChainIdFromNetworkId: true,
        chainId: 80001, // Polygon Mumbai network ID
      );

      dismissLoader();
      Get.back();
      // await _userController.getUserInfo(isScreenChange: false);
      showSnack(msg: "Send successfully");
      return true;

    } catch (e) {
      print("ERROR ${e}");
      showError(msg: "$e");
      return false;
    }
  }

  Future<void> sendCoin({required String sendAddress, double coin = 0}) async {
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};
      params["to"] = sendAddress;
      params["amount"] = coin;
      await apiService.postRequest(
        url: ApiUrl.sendCoin,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();
          Get.back();
          // await _userController.getUserInfo(isScreenChange: false);
          showSnack(msg: data["response"]["message"]);
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<String> getBalanceLocally({required String publicKey, double coin = 0,required String privateKey,required String tokenAbi}) async {
    try {
      print("PUBLIC KEY ${publicKey}");
      removeUnFocusManager();
    //  showLoader();
      Map<String, dynamic> params = {};
      params["to"] = publicKey;
      params["amount"] = coin;

      //web3 provider
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);

      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(tokenAbi, 'MATIC'), contractAddress);


      final List<dynamic> balance = await ethClient.call(
        contract: contract,
        function: contract.function('balanceOf'),
        params: [
          EthereumAddress.fromHex(publicKey)
        ],
      );

      print("Balance  ${balance}");

      // await _userController.getUserInfo(isScreenChange: false);
      return balance[0].toString();

    } catch (e) {
      print("ERROR ${e}");
      showError(msg: "$e");
      showSnack(msg: "$e");
      return "";
    }
  }

  Future<String> getAllowanceLocally({required String sendAddress, double coin = 0,
    required String privateKey,required String waletPublickey,required String stackingContractAddress,required String tokenAbi}) async
  {
    try {
     // removeUnFocusManager();
      Map<String, dynamic> params = {};
      params["to"] = sendAddress;
      params["amount"] = coin;

      //web3 provider
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);

      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(tokenAbi, 'MATIC'), contractAddress);
      print("ENTER ENTER ${waletPublickey}");
      print("ENTER  ${stackingContractAddress}");
      // final credentials = await ethClient.credentialsFromPrivateKey(privateKey);
      // final transferFunction = contract.function('transfer');

      final List<dynamic> decimals = await ethClient.call(
        contract: contract,
        function: contract.function('allowance'),
        params: [
         EthereumAddress.fromHex(waletPublickey),
          EthereumAddress.fromHex(stackingContractAddress)
        ],
      );
      print("DECIMALS ${decimals}");

      // await _userController.getUserInfo(isScreenChange: false);
      return decimals[0].toString();
    } catch (e) {
      print("ERROR ${e}");
      showError(msg: "$e");
      showSnack(msg: "$e");
      return "";
    }
  }

  Future<String> ApproveAllowanceLocally({String SpenderAddress="0x821fA2CB3f01f486A7B0a92dCcEcE4f87e2D481c",
    required String coin,required String privateKey,required String tokenAbi}) async {
    try {
      removeUnFocusManager();
      //showLoader();

      //web3 provider
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);

      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(tokenAbi, 'MATIC'), contractAddress);

      final credentials =  EthPrivateKey.fromHex(privateKey);
      final approveFunction = contract.function('approve');

      final List<dynamic> decimals = await ethClient.call(
        contract: contract,
        function: contract.function('decimals'),
        params: [],
      );
      print("DECIMALS ${decimals}");
      String cleanedInput = coin.toString().replaceAll(RegExp(r'[^0-9-]'), '');
      BigInt amount = BigInt.parse(cleanedInput) * BigInt.from(10).pow(18);
print("AMMOUNT ${amount}");

      final data = contract.function('approve').encodeCall(
        [EthereumAddress.fromHex(SpenderAddress), amount],
      );
    // final gas = await ethClient.estimateGas(
    // sender: EthereumAddress.fromHex("0xc521d6713d20c982123ebd7a166128d3664ca05d"),
    // to: EthereumAddress.fromHex("0xcf8Ca0B65Ba447383C602F87bBe4Bb8A4a87feAb"),
    // data: data,
    // );

      var nonce = await ethClient.getTransactionCount(credentials.address);
      print("ENTER FF");
      ApproveResponse = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: approveFunction,
          nonce: nonce,
          parameters: [EthereumAddress.fromHex(SpenderAddress),amount],
           maxPriorityFeePerGas: EtherAmount.fromBase10String(EtherUnit.gwei,"100"),
           maxFeePerGas:EtherAmount.fromBase10String(EtherUnit.gwei,"100"),
           //EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(100)),
         //  gasPrice:
          //EtherAmount.inWei(BigInt.from(85000000000)),
         // EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(200)),
          //EtherAmount.inWei(BigInt.one),
         // maxGas: 210000,
          //gas.toInt() + 10000,
        ),
        // fetchChainIdFromNetworkId: true,
        chainId: 80001, // Polygon Mumbai network ID
      );
      print("APPROVE RESPONSE ${ApproveResponse}");

     // dismissLoader();
     // Get.back();
      // await _userController.getUserInfo(isScreenChange: false);
      //showSnack(msg: "Send successfully");
      return ApproveResponse;

    } catch (e) {
      dismissLoader();
      print("ERROR ApproveAllowanceLocally ${e}");
      showError(msg: "$e");
      return ApproveResponse;
    }
  }

  Future<void> changeTheme() async {
    if (isLightTheme.value == false) {
      isLightTheme.value = true;
      print("isLightTheme  - - - - ${isLightTheme.value}");
      setLightTheme();
      await _userDetails.saveBoolean(title: "themeColor", value: true );
    } else {
      isLightTheme.value = false;
      print("isLightTheme  - - - - ${isLightTheme.value}");
      setDarkTheme();
      await _userDetails.saveBoolean(title: "themeColor", value: false);

    }
  }
}
