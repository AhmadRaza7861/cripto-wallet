import 'dart:math';
import 'dart:typed_data';

import 'package:crypto_wallet/model/view_product_review_model.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart_builders/utils.dart';
import 'base_controller.dart';
class SwapScreenController extends BaseController
{
  TextEditingController textController = TextEditingController();
  String selectedOption = 'USDT';
  String USDTKey="";
  String WBTCkey="";
  String USDTContractKey="0x41b7c21e40134BB77ddf00f0ea809075c35Df63f";
  String WBTCContractKey="0xED6602023ED11F240469f805fF92E06aF8b55A64";

  var finalAmountValue="".obs;
  String userTypeValue="";
  var finalAmountValueWithDecimal="".obs;
  String functionName="buyWithUSDT";
  String ETHkey="0x0000000000000000000000000000000000000000";
  String PresaleTokenContractAddress="0x9B8d2cD8C254ba49b402B77429E4457f07344723";

  final EthereumAddress contractAddress = EthereumAddress.fromHex("0xb5C7fb2Fc0f44833053bA902ddc73CA4D760ad41");
  final String providerUrl ="https://polygon-mumbai.blockpi.network/v1/rpc/public";

  Future<String> loadABIFile({required String name}) async {
    final ByteData data = await rootBundle.load('assets/abi/$name');
    final String content = String.fromCharCodes(data.buffer.asUint8List());
    return content;
    // Now you can use 'content' which contains the ABI file data.
  }

  void read_USDT_WBTC_address()async
  {
    String presaleAbi=await loadABIFile(name: "presaleAbi.js");
    //web3 provider
    final Client httpClient = Client();
    final Web3Client ethClient = Web3Client(providerUrl, httpClient);

    final DeployedContract contract = DeployedContract(ContractAbi.fromJson(presaleAbi, 'MATIC'), contractAddress);

    final List<dynamic> USDTValue = await ethClient.call(
      contract: contract,
      function: contract.function('USDT'),
      params: [
      ],
    );
    final List<dynamic> WBTCValue = await ethClient.call(
      contract: contract,
      function: contract.function('WBTC'),
      params: [
      ],
    );
    USDTKey=USDTValue[0].toString();
    WBTCkey=WBTCValue[0].toString();
    print("decimals ${WBTCValue}");
  }

  Future<String> getTokenOutAmount({required String address,required String Useramount,required int decimals})async
  {
    String presaleAbi=await loadABIFile(name: "presaleAbi.js");
    //web3 provider
    final Client httpClient = Client();
    final Web3Client ethClient = Web3Client(providerUrl, httpClient);

    //String cleanedInput = Useramount.toString().replaceAll(RegExp(r'[^0-9-]'), '');
    BigInt amount = BigInt.from(double.parse(Useramount) * pow(10, decimals));
   // print("Int Value ${intValue}");
   // BigInt amount = BigInt.parse(Useramount.toString()) * BigInt.from(10).pow(decimals);

   // var value= amount ~/ BigInt.from(10).pow(6);
     print("VALUE 99 ${amount}  Address ${address}");
   // print("VALUE ${value}");

    final DeployedContract contract = DeployedContract(ContractAbi.fromJson(presaleAbi, 'MATIC'), contractAddress);

    final List<dynamic> data = await ethClient.call(
      contract: contract,
      function: contract.function('getTokenOutAmount'),
      params: [
        EthereumAddress.fromHex(address),
        amount
      ],
    );
    print("decimals ${data[0]}");
    return data[0].toString();

  }

  void onPressBuyTokenButton({required String privateKey,required String publicKey,required String ContractAddress})async
  {try {
            showLoader();
            String presaleTokenAbi=await loadABIFile(name: "presaleTokenAbi.js");
            String presaleAbi=await loadABIFile(name: "presaleAbi.js");
            String minAmount=await checkMinAmount(privateKey: privateKey, waletPublickey:publicKey ,abi:presaleAbi,ContractAddress: "0xb5C7fb2Fc0f44833053bA902ddc73CA4D760ad41");
            String minAmountWithoutDecimal="${minAmount.length>18?(BigInt.parse(minAmount) ~/ BigInt.parse(pow(10, 18).toString())):minAmount}";
            print("MINIMUM AMOUNT ${minAmountWithoutDecimal}");
            if(BigInt.parse(finalAmountValue.value)>=BigInt.parse(minAmountWithoutDecimal))
              {
                if(ContractAddress=="")
                {
                  try
                  {
                    final Client httpClient = Client();
                    final Web3Client ethClient = Web3Client(providerUrl, httpClient);
                    final EthereumAddress myAddress = EthereumAddress.fromHex("$publicKey");
                    EtherAmount balance = await ethClient.getBalance(myAddress);

                    if(balance.getValueInUnit(EtherUnit.ether)>double.parse(userTypeValue.toString()))
                    {
                      String response=await BuyTokenFunction(privateKey:privateKey ,waletPublickey:publicKey ,abi:presaleAbi,isEith: true,decimalContractAddress: "0x41b7c21e40134BB77ddf00f0ea809075c35Df63f" ,TokenAbi: presaleTokenAbi);
                      dismissLoader();
                      if(response!="")
                      {
                        showSnack(msg: "Buy Successfully");
                        textController.text="";
                      }
                      else
                      {
                        showSnack(msg: "Not Buy Successfully");
                      }
                    }
                    else
                    {
                      showSnack(msg: "Insufficient balance");
                      dismissLoader();
                    }
                    print('Balance: ${balance.getValueInUnit(EtherUnit.ether)} ETH');
                  }
                  catch(e)
                  {
                    print("CATCH ${e}");
                    showSnack(msg: "$e");
                    dismissLoader();
                  }
                }
                else
                {
                  String allowance=await getAllowanceFunction(privateKey: privateKey, waletPublickey:publicKey ,abi:presaleTokenAbi,ContractAddress: ContractAddress );
                  print("ALLOWANCE GET SUCCESSSFULLY ${allowance}");
                  BigInt AllowAllowance = BigInt.parse(allowance);
                  BigInt UseAmount;
                  if(selectedOption=="USDT")
                    {
                       UseAmount = BigInt.from(double.parse(userTypeValue) * pow(10, 6));
                      //UseAmount = BigInt.parse(userTypeValue) * BigInt.from(10).pow(6);
                    }
                  else
                    {
                       UseAmount = BigInt.from(double.parse(userTypeValue) * pow(10, 8));
                       //UseAmount = BigInt.parse(userTypeValue) * BigInt.from(10).pow(8);
                    }

                  //  BigInt UseAmount = BigInt.parse(finalAmountValueWithDecimal.toString());
                  print("AllowAllowance ${AllowAllowance} UseAmount ${UseAmount}");
                  print(AllowAllowance<UseAmount);
                  if(AllowAllowance<UseAmount)
                  {
                    String allowance=await ApproveAllowanceFunction(privateKey: privateKey, waletPublickey:publicKey,abi: presaleTokenAbi,ContractAddress: ContractAddress);
                    print("APPROVE ALLOWANCE ${allowance}");
                    if(allowance.length>10)
                    {
                      Future.delayed(Duration(seconds: 13)).then((value) async
                      {
                        String response=await BuyTokenFunction(privateKey:privateKey ,waletPublickey:publicKey ,abi:presaleAbi,decimalContractAddress: ContractAddress,TokenAbi: presaleTokenAbi);
                        dismissLoader();
                        if(response!="")
                        {
                          showSnack(msg: "Buy Successfully");
                          textController.text="";
                        }
                        else
                        {
                          showSnack(msg: "Not Buy Successfully");
                        }
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
                    String response=await BuyTokenFunction(privateKey:privateKey ,waletPublickey:publicKey ,abi:presaleAbi,decimalContractAddress: ContractAddress ,TokenAbi: presaleTokenAbi);
                    dismissLoader();
                    if(response!="")
                    {
                      showSnack(msg: "Buy Successfully");
                      textController.text="";
                    }
                    else
                    {
                      showSnack(msg: "Not Buy Successfully");
                    }
                  }
                }
              }
           else
             {
               showSnack(msg: "Your amount is less then min amount");
             }
          }
          catch(e)
    {
      dismissLoader();
      showSnack(msg: "$e");
    }



  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    read_USDT_WBTC_address();
  }

  Future<String> getAllowanceFunction({required String privateKey,required String waletPublickey,required String abi,required String ContractAddress})async
  {
    try
    {
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);
      final EthereumAddress PresaleTokencontractAddress = EthereumAddress.fromHex(ContractAddress);
      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(abi, 'MATIC'), PresaleTokencontractAddress);

      final List<dynamic> data = await ethClient.call(
        contract: contract,
        function: contract.function('allowance'),
        params: [
          EthereumAddress.fromHex(waletPublickey),
          contractAddress
        ],
      );
      return data[0].toString();
    }
    catch(e)
    {
      showSnack(msg: "$e");
      return "";
    }
  }

  Future<String> ApproveAllowanceFunction({required String privateKey, required String waletPublickey,required String abi,required String ContractAddress}) async{
    try
        {
          final Client httpClient = Client();
          final Web3Client ethClient = Web3Client(providerUrl, httpClient);
          final EthereumAddress PresaleTokencontractAddress = EthereumAddress.fromHex(ContractAddress);
          final DeployedContract contract = DeployedContract(ContractAbi.fromJson(abi, 'MATIC'), PresaleTokencontractAddress);

          print("APPROVE ${ContractAddress}");

          final credentials =  EthPrivateKey.fromHex(privateKey);
          final approveFunction = contract.function('approve');

          final List<dynamic> decimals = await ethClient.call(
            contract: contract,
            function: contract.function('decimals'),
            params: [],
          );
          int decimalValue=int.parse(decimals[0].toString());

         // BigInt amount = BigInt.parse(userTypeValue) * BigInt.from(10).pow(decimalValue);
          BigInt amount = BigInt.from(double.parse(userTypeValue) * pow(10, decimalValue));
          var nonce = await ethClient.getTransactionCount(credentials.address);
         String ApproveResponse = await ethClient.sendTransaction(
            credentials,
            Transaction.callContract(
              contract: contract,
              function: approveFunction,
              nonce: nonce,
              parameters: [contractAddress,amount],
              maxPriorityFeePerGas: EtherAmount.fromBase10String(EtherUnit.gwei,"100"),
              maxFeePerGas:EtherAmount.fromBase10String(EtherUnit.gwei,"100"),
            ),
            // fetchChainIdFromNetworkId: true,
            chainId: 80001, // Polygon Mumbai network ID
          );
         return ApproveResponse;
        }
        catch(e)
    {
      showError(msg: "$e");
      print("ERROR ${e}");
      return "";
    }
  }

  Future<String> BuyTokenFunction({required String privateKey, required String waletPublickey,required String decimalContractAddress,required String TokenAbi,required String abi,bool isEith=false}) async{
    try
    {
      print("CONTROLL ENTER 11111");
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);

      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(abi, 'MATIC'), contractAddress);
      final DeployedContract Decimalcontract = DeployedContract(ContractAbi.fromJson(TokenAbi, 'MATIC'), EthereumAddress.fromHex(decimalContractAddress));

      final credentials =  EthPrivateKey.fromHex(privateKey);
      final approveFunction = contract.function("$functionName");
      print("CONTROLL ENTER 22222  ${TokenAbi}");
     // BigInt amount=BigInt.parse(finalAmountValueWithDecimal.value);
      //BigInt amount=BigInt.parse(userTypeValue);

      final List<dynamic> decimals = await ethClient.call(
        contract: Decimalcontract,
        function: Decimalcontract.function('decimals'),
        params: [],
      );

      print("CONTROLL ENTER 3333 ${decimals}");
      int decimalValue=int.parse(decimals[0].toString());
      BigInt amount;
      if(!isEith)
        {
          amount = BigInt.from(double.parse(userTypeValue) * pow(10, decimalValue));
           //amount = BigInt.parse(userTypeValue) * BigInt.from(10).pow(decimalValue);
        }
      else{
         amount = BigInt.from(double.parse(userTypeValue) * pow(10, 0));
       // amount= BigInt.parse(userTypeValue);
      }
     // BigInt amount=BigInt.parse(12000000.toString());
      print("AMMOUNT  Enter${amount}");


      var nonce = await ethClient.getTransactionCount(credentials.address);
      String ApproveResponse = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: approveFunction,
          nonce: nonce,
          parameters: [amount],
          maxPriorityFeePerGas: EtherAmount.fromBase10String(EtherUnit.gwei,"100"),
          maxFeePerGas:EtherAmount.fromBase10String(EtherUnit.gwei,"100"),
        ),
        // fetchChainIdFromNetworkId: true,
        chainId: 80001, // Polygon Mumbai network ID
      );
      return ApproveResponse;
    }
    catch(e)
    {
      showSnack(msg: "$e");
      print("ERROR ERROR ${e}");
      return "";
    }

  }

  Future<String> checkMinAmount({required String privateKey,required String waletPublickey,required String abi,required String ContractAddress})async
  {
    try
    {
      final Client httpClient = Client();
      final Web3Client ethClient = Web3Client(providerUrl, httpClient);
      final EthereumAddress PresaleTokencontractAddress = EthereumAddress.fromHex(ContractAddress);
      final DeployedContract contract = DeployedContract(ContractAbi.fromJson(abi, 'MATIC'), PresaleTokencontractAddress);

      final List<dynamic> data = await ethClient.call(
        contract: contract,
        function: contract.function('minAmount'),
        params: [],
      );
      return data[0].toString();
    }
    catch(e)
    {
      showSnack(msg: "$e");
      return "";
    }
  }
}