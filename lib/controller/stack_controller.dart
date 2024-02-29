import 'dart:typed_data';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web3dart/credentials.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import '../model/your_staks_model.dart';
import 'base_controller.dart';

class StackController extends BaseController
{
  final HomeController _homeController=Get.find();
  var chipButtontext="30 Months".obs;
  var totalStakers=''.obs;
  var totalStaked=''.obs;
  var totalWithdrawn=''.obs;
  var totalunstaked=''.obs;
  var balance=''.obs;
  var stackButtonText="Stake Now".obs;
  var currentSelectLockDuration=0;
  var isLoading=false.obs;
  RxList<yourStaksModel> dataList = <yourStaksModel>[].obs;
  String StackingContractAddress="0x821fA2CB3f01f486A7B0a92dCcEcE4f87e2D481c";
  TextEditingController yourStakesController=TextEditingController();

  Future<String> loadABIFile() async {
    final ByteData data = await rootBundle.load('assets/abi/stakingAbi.js');
    final String content = String.fromCharCodes(data.buffer.asUint8List());
    return content;
    // Now you can use 'content' which contains the ABI file data.
  }

  final String providerUrl ="https://rpc-mumbai.maticvigil.com";
  final EthereumAddress contractAddress = EthereumAddress.fromHex("0x821fA2CB3f01f486A7B0a92dCcEcE4f87e2D481c");
  String TransectionSuccesstxHash="";
  Future<bool> StackingFunction({required String sendAddress, double coin = 0,required String privateKey,required String abi,required String publicKey}) async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["to"] = sendAddress;
      params["amount"] = coin;

      //web3 provider
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);

      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(abi, 'MATIC'), contractAddress);

      print("ENTER ENTER111");

      //final credentials = await ethClient.credentialsFromPrivateKey(privateKey);
      //final transferFunction = contract.function('transfer');
      print("ENTER ENTER222");
      final List<dynamic> totalstakers = await ethClient.call(
        contract: contract,
        function: contract.function('totalStakers'),
        params: [],
      );
      final List<dynamic> totalStakedToken = await ethClient.call(
        contract: contract,
        function: contract.function('totalStakedToken'),
        params: [],
      );
      final List<dynamic> totalWithdrawanToken = await ethClient.call(
        contract: contract,
        function: contract.function('totalWithdrawanToken'),
        params: [],
      );
      totalStakers.value=totalstakers[0].toString();
      totalStaked.value=totalStakedToken[0].toString();
      totalWithdrawn.value=totalWithdrawanToken[0].toString();
      String tokenAbi=await _homeController.loadTokenABIFile();
      balance.value=await _homeController.getBalanceLocally(publicKey:publicKey, privateKey: privateKey,tokenAbi: tokenAbi);

      print("Balance ${balance.value}");
      dismissLoader();
      Get.back();
      // await _userController.getUserInfo(isScreenChange: false);
     // showSnack(msg: "Send successfully");
      return true;
    } catch (e) {
      print("ERROR ${e}");
      showError(msg: "$e");
      return false;
    }
  }

  Future<String> getAllowanceFunction({required String privateKey,required String waletPublickey,required String stackingContractAddress})async
  {
    // showLoader();
    String tokenAbi=await _homeController.loadTokenABIFile();
   String allowance=await _homeController.getAllowanceLocally(sendAddress: "", privateKey: privateKey, waletPublickey: waletPublickey,
       stackingContractAddress: stackingContractAddress,tokenAbi: tokenAbi);
    // dismissLoader();
return allowance;
  }

  Future<String> ApproveAllowanceFunction({required String privateKey,required String waletPublickey,})async
  {
    String tokenAbi=await _homeController.loadTokenABIFile();
    String allowance=await _homeController.ApproveAllowanceLocally( privateKey: privateKey, tokenAbi: tokenAbi,coin:yourStakesController.text);
    return allowance;
  }


  Future<String>StakeLocallyFunction({required String privateKey,required String waletPublickey,required String StakeAbi,required BigInt amount})async
  {
    try {
      removeUnFocusManager();
     // showLoader();

      //web3 provider
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);

      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(StakeAbi, 'MATIC'), contractAddress,);

      final credentials =  EthPrivateKey.fromHex(privateKey);
      final approveFunction = contract.function('stake');

      // String cleanedInput = ammount.toString().replaceAll(RegExp(r'[^0-9-]'), '');
      // BigInt amount = BigInt.parse(cleanedInput) * BigInt.from(10).pow(18);
      print("AMMOUNT ${amount}");


      var nonce = await ethClient.getTransactionCount(credentials.address);
      print("ENTER FF AMOUNT  ${amount}");
      var ApproveResponse = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: approveFunction,
          nonce: nonce,
          parameters: [amount,BigInt.parse(currentSelectLockDuration.toString())],
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
      showSnack(msg: "Staked successfully");
      return ApproveResponse;
    } catch (e) {
      //dismissLoader();
      print("ERROR ${e}");
      showError(msg: "$e");
      return "";
    }
  }

  Future<List<yourStaksModel>>YourStakesLocallyFunction({required String waletPublickey,required String StakeAbi,bool isClaimReward=false,int claimAprIndex=0,String privatekey="",bool isWithDrawAmount=false})async
  {
    showLoader();
    List<yourStaksModel> dataList=[];
    try {
      removeUnFocusManager();
      // showLoader();

      //web3 provider
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);

      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(StakeAbi, 'MATIC'), contractAddress,);
      if(isClaimReward)
        {
          print("Jjjg ${ BigInt.parse(claimAprIndex.toString())}");
          final credentials =  EthPrivateKey.fromHex(privatekey);
          final approveFunction = contract.function('stake');



          var nonce = await ethClient.getTransactionCount(credentials.address);
          var ApproveResponse = await ethClient.sendTransaction(
              credentials,
              Transaction.callContract(
                contract: contract,
                function: contract.function('claimApr'),
                nonce: nonce,
                parameters: [BigInt.parse(claimAprIndex.toString())],
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
          chainId: 80001,
          );
        }
      if(isWithDrawAmount)
        {
          final credentials =  EthPrivateKey.fromHex(privatekey);
          var nonce = await ethClient.getTransactionCount(credentials.address);
          var withdrawAmount = await ethClient.sendTransaction(
            credentials,
            Transaction.callContract(
              contract: contract,
              function: contract.function('withdrawAmount'),
              nonce: nonce,
              parameters: [BigInt.parse(claimAprIndex.toString())],
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
            chainId: 80001,
          );
        }
      final List<dynamic> UsersData = await ethClient.call(
        contract: contract,
        function: contract.function('users'),
        params: [
          EthereumAddress.fromHex(waletPublickey),
        ],
      );
      for(int i=0;i<int.parse(UsersData[3].toString());i++)
        {
          print("CCC $i");
          final List<dynamic> viewStacking = await ethClient.call(
            contract: contract,
            function: contract.function('viewStaking'),
            params: [
              EthereumAddress.fromHex(waletPublickey),
              BigInt.parse(i.toString())
            ],
          );
          final List<dynamic> getCurrentClaimableReward = await ethClient.call(
            contract: contract,
            function: contract.function('getCurrentClaimableReward'),
            params: [ EthereumAddress.fromHex(waletPublickey),BigInt.parse(i.toString())],
          );
          final List<dynamic> viewStaking = await ethClient.call(
            contract: contract,
            function: contract.function('viewStaking'),
            params: [ EthereumAddress.fromHex(waletPublickey),BigInt.parse(i.toString())],
          );

         yourStaksModel staksModel=yourStaksModel(amount:viewStacking[0] ,claimedApr:viewStacking[1] ,startTime:viewStacking[2] ,endTime:viewStacking[3] ,lastWithdrawTime:viewStacking[4] ,percentPerInterval:viewStacking[5] ,lockupTime:viewStacking[6] ,isClaimed:viewStacking[7] ,isActive:viewStacking[8] ,index:i,claimReward:getCurrentClaimableReward[0],viewStaking:viewStaking[8]  );
          dataList.add(staksModel);
        }

      // String cleanedInput = ammount.toString().replaceAll(RegExp(r'[^0-9-]'), '');
      // BigInt amount = BigInt.parse(cleanedInput) * BigInt.from(10).pow(18);
      print("UsersData ${UsersData[3]}");



      dismissLoader();
      Get.back();
      // await _userController.getUserInfo(isScreenChange: false);
      return dataList;
    } catch (e) {
      dismissLoader();
      print("ERROR ${e}");
      showError(msg: "$e");
      return dataList;
    }
  }

  void onPressStakeNowButton({required String privateKey,required String publicKey})async
  {
    if(yourStakesController.text==""||yourStakesController.text.isEmpty)
      {
        showSnack(msg: "Please enter a amount");
      }
    else if(BigInt.parse(yourStakesController.text)>BigInt.parse(balance.value.substring(0,balance.value.length-18)))
      {
        showSnack(msg: "Error! insufficient funds");
      }
    else
      {
        showLoader();
        String tokenAbi=await _homeController.loadTokenABIFile();
        balance.value=await _homeController.getBalanceLocally(publicKey:publicKey, privateKey: privateKey,tokenAbi: tokenAbi);
        if(BigInt.parse(yourStakesController.text)>BigInt.parse(balance.value.substring(0,balance.value.length-18)))
        {
          dismissLoader();
          showSnack(msg: "Error! insufficient funds");
        }
        else
          {
            String cleanedInput = yourStakesController.text.replaceAll(RegExp(r'[^0-9-]'), '');
            BigInt amount = BigInt.parse(cleanedInput) * BigInt.from(10).pow(18);
            String allowance=await getAllowanceFunction(privateKey: privateKey, waletPublickey:publicKey , stackingContractAddress:StackingContractAddress);

            BigInt AllowAllowance = BigInt.parse(allowance);
            BigInt UseAmount = BigInt.parse(amount.toString());
            print("AllowAllowance ${AllowAllowance} UseAmount ${UseAmount}");
            print(AllowAllowance<UseAmount);
            if(AllowAllowance<UseAmount)
            {
              String allowance=await ApproveAllowanceFunction(privateKey: privateKey, waletPublickey:publicKey);
              if(allowance.length>10)
              {
                Future.delayed(Duration(seconds: 10)).then((value) async
                {
                  String Abi= await loadABIFile();
                  String SuccessHash=await  StakeLocallyFunction(privateKey: privateKey, waletPublickey: publicKey, StakeAbi: Abi, amount: UseAmount);
                  print("SUCCESSHASH  ${SuccessHash}");
                  dismissLoader();
                });
              }
              else
              {
                showError(msg: "Allowance not approved successfully");
                dismissLoader();
              }
            }
            else
            {
              String Abi= await loadABIFile();
              String SuccessHash=await  StakeLocallyFunction(privateKey: privateKey, waletPublickey: publicKey, StakeAbi: Abi, amount: UseAmount);
              print("SUCCESSHASH  ${SuccessHash}");
              dismissLoader();
            }
          }
      }
  }

  void onTapMax()
  {
    yourStakesController.text=balance.value.length>2?balance.value.substring(0,balance.value.length-18):balance.value;
  }

  void onTapClaimReward({required int claimAprIndex,required String waletPublickey ,required String privateKey})async
  {
    String Abi= await loadABIFile();
    var data=await YourStakesLocallyFunction(waletPublickey: waletPublickey,StakeAbi: Abi ,isClaimReward: true,claimAprIndex:claimAprIndex,privatekey: privateKey);
    if(data.length>0)
      {
        dataList.value=data;
      }
  }

  void onTapWithDrawAmount({required int withDrawIndex,required String waletPublickey ,required String privateKey})async
  {
    String Abi= await loadABIFile();
    var data=await YourStakesLocallyFunction(waletPublickey: waletPublickey,StakeAbi: Abi ,claimAprIndex:withDrawIndex,privatekey: privateKey,isWithDrawAmount: true);
    if(data.length>0)
    {
      dataList.value=data;
    }
  }
}