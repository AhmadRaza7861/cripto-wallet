
import 'dart:math';

import 'package:crypto_wallet/controller/swap_screen_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../util/app_constant.dart';
import '../../common_widget/custom_button.dart';
class SwapScreen extends StatefulWidget {
   SwapScreen({Key? key,required this.screenHeight}) : super(key: key);
   double screenHeight;

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  final SwapScreenController _swapScreenController=Get.find();
  final UserController _userController=Get.find();
  String selectedOption = 'USDT';
 // Variable to store selected dropdown value
 //  TextEditingController textController = TextEditingController();
 // Controller for the text field
  List<String> dropdownOptions = ['USDT', 'WBTC', 'ETH'];
 // Dropdown menu options
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15,),
                  DropdownButtonFormField(
                    value: selectedOption,
                    items: dropdownOptions.map((String option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _swapScreenController.textController.text="";
                        selectedOption = newValue!;
                        _swapScreenController.selectedOption=newValue;
                        _swapScreenController.finalAmountValue.value="";
                        if(newValue=="USDT")
                          {
                            _swapScreenController.functionName="buyWithUSDT";
                          }
                        else if(newValue=="ETH")
                          {
                            _swapScreenController.functionName="buyWithEth";
                          }
                        else
                          {
                            _swapScreenController.functionName="buyWithWBTC";
                          }
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select an option',
                      labelStyle: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor)
                      ),
                      focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor)
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Enter amount to buy",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppColors.black
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  TextField(
                    controller: _swapScreenController.textController,
                    cursorColor: AppColors.primaryColor,
                    keyboardType: TextInputType.number,
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.digitsOnly,
                    // ],
                    onChanged: (value)async
                    {
                      print("ENTER ENTER ${value==""}");
                      if(value=="")
                        {
                          print("ENTER ENTER ${value}");
                          Future.delayed(Duration(seconds: 1)).then((value)
                              {
                                _swapScreenController.finalAmountValue.value="";
                              });
                        }
                      else
                        {
                          if(value!="" && value!=null)
                            {
                              if(selectedOption=="USDT")
                              {
                                String FinalValue=await _swapScreenController.getTokenOutAmount(address:_swapScreenController.USDTKey,Useramount: value,decimals: 6);
                                print("FINAL AMOUNT ${FinalValue}");
                                String vv="${FinalValue.length>18?(BigInt.parse(FinalValue) ~/ BigInt.parse(pow(10, 18).toString())):FinalValue}";
                                _swapScreenController.finalAmountValueWithDecimal.value=FinalValue;
                                _swapScreenController.finalAmountValue.value=vv;
                              }
                              else if(selectedOption=="WBTC")
                              {
                                String FinalValue=await _swapScreenController.getTokenOutAmount(address:_swapScreenController.WBTCkey,Useramount: value,decimals: 8);
                                _swapScreenController.finalAmountValueWithDecimal.value=FinalValue;
                                String vv="${FinalValue.length>18?(BigInt.parse(FinalValue) ~/ BigInt.parse(pow(10, 18).toString())):FinalValue}";
                                _swapScreenController.finalAmountValue.value=vv;
                              }
                              else
                              {
                                String FinalValue=await _swapScreenController.getTokenOutAmount(address:_swapScreenController.ETHkey,Useramount: value,decimals: 18);
                                _swapScreenController.finalAmountValueWithDecimal.value=FinalValue;
                                String vv="${FinalValue.length>18?(BigInt.parse(FinalValue) ~/ BigInt.parse(pow(10, 18).toString())):FinalValue}";
                                _swapScreenController.finalAmountValue.value=vv;
                              }
                            }
                        }

                    },
                    decoration: InputDecoration(
                      labelText: 'Enter amount',
                      labelStyle: TextStyle(
                          color: AppColors.primaryColor
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Obx(()=>
                       Text( _swapScreenController.finalAmountValue.value.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            )),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  SizedBox(height: 50,),
                  CustomButton(
                    title: "Continue",
                    onTap: () async{
                      if(_swapScreenController.textController.text==""||_swapScreenController.textController.text.isEmpty||_swapScreenController.finalAmountValue.value=="")
                      {
                        SnackShow(msg: "Please enter a amount");
                      }
                      else
                        {
                          _swapScreenController.userTypeValue=_swapScreenController.textController.text;
                          _swapScreenController.onPressBuyTokenButton(privateKey: _userController.userResponseModel.value.user!.wallet.toString(),publicKey: _userController.publicKey.value,ContractAddress: selectedOption=="USDT"?_swapScreenController.USDTContractKey:selectedOption=="WBTC"?_swapScreenController.WBTCContractKey:"");
                        }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

  void SnackShow({String title = "Alert!", String? msg}) {
    if (msg != null) {
      Get.snackbar(title, msg,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
    }
  }


}
