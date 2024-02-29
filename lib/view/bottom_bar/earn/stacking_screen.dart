import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/stack_controller.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import '../../../controller/user_controller.dart';
import '../../common_widget/custom_button.dart';
import '../trade/coin_detail/widget/chart_full_screen.dart';

class StackingScreen extends StatefulWidget {
   StackingScreen({Key? key}) : super(key: key);

  @override
  State<StackingScreen> createState() => _StackingScreenState();
}

class _StackingScreenState extends State<StackingScreen> {
   final stackController=Get.put(StackController());
   final UserController _userController = Get.find();
   final HomeController _homeController=Get.find();
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      stackController.yourStakesController.text="";
      if(_userController.publicKey.value==""||_userController.publicKey.value==null)
      {
        SharedPreferences pref=await SharedPreferences.getInstance();
        _userController.publicKey.value=pref.getString("publickey").toString();
      }
      String Abi= await stackController.loadABIFile();
      stackController.StackingFunction(sendAddress: "", publicKey: _userController.publicKey.value,privateKey:_userController.userResponseModel.value.user!.wallet.toString(), abi: Abi,);
    });
   }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: CustomButton(
          //     title: 'resent',
          //     onTap: () async{
          //      print("ABI ${_userController.publicKey.value}");
          //    String allowance=await stackController.getAllowanceFunction(privateKey: _userController.userResponseModel.value.user!.wallet.toString(), waletPublickey:_userController.publicKey.value , stackingContractAddress: "0x7C1aEc957aa36dd7F0600329CF3e772c86F869a7");
          //    print("ALLOWANCE ${allowance}");
          //    print("BALANCE ${stackController.balance.value.substring(0,stackController.balance.value.length-18)}");
          //     },
          //   ),
          // ),
         Obx(()=>ShowStackInformationWidget(titleText: "Total Stakers",value: stackController.totalStakers.value)),
          Obx(()=>ShowStackInformationWidget(titleText: "Total Staked",value:stackController.totalStaked.value.length>2?stackController.totalStaked.value.substring(0,stackController.totalStaked.value.length-18):stackController.totalStaked.value)),
          Obx(()=>ShowStackInformationWidget(titleText: "Total Withdrawn",value: stackController.totalWithdrawn.value.length>2?stackController.totalStaked.value.substring(0,stackController.totalWithdrawn.value.length-18):stackController.totalWithdrawn.value)),
        //  ShowStackInformationWidget(titleText: "Total Unstaked",value: "11.082786732205"),
        //   Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: Container(height: 60,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(30),
        //           border: Border.all(color: AppColors.primaryColor)
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 10,right: 10),
        //         child: Center(
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceAround,
        //             children: [
        //               RichText(text: TextSpan(
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: AppColors.primaryColor,
        //                       fontSize: 18
        //                   ),
        //                   text: "Current Price:",
        //                   children: [
        //                     TextSpan(text: "\$27.576",
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold,
        //                             color: Colors.black,
        //                             fontSize: 18
        //                         )
        //                     )
        //                   ]
        //               ),
        //
        //               ),
        //               Row(
        //                 children: [
        //                   Icon(Icons.arrow_downward,color: Colors.red),
        //                   SizedBox(width: 10,),
        //                   Text("-0.02%",
        //                     style: TextStyle(
        //                         fontWeight: FontWeight.bold,
        //                         color: Colors.black,
        //                         fontSize: 18
        //                     ),
        //                   )
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
          Padding(
            padding: EdgeInsets.only(top: 10,left: 12),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Your Stakes",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Row(
                children: [
                  SizedBox(width: 10,),
                  Text(
                    'SLC ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      controller: stackController.yourStakesController,
                      decoration: InputDecoration(
                        hintText: 'Enter Stake amount',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (e)async
                      {
                        // if(!e.isEmpty && e.toString()!="")
                        //   {
                        //     String cleanedInput = e.toString().replaceAll(RegExp(r'[^0-9-]'), '');
                        //     BigInt amount = BigInt.parse(cleanedInput) * BigInt.from(10).pow(18);
                        //     String allowance=await stackController.getAllowanceFunction(privateKey: _userController.userResponseModel.value.user!.wallet.toString(), waletPublickey:_userController.publicKey.value , stackingContractAddress: "0x7C1aEc957aa36dd7F0600329CF3e772c86F869a7");
                        //
                        //     BigInt AllowAllowance = BigInt.parse(allowance);
                        //     BigInt UseAmount = BigInt.parse(amount.toString());
                        //     print("AllowAllowance ${AllowAllowance} UseAmount ${UseAmount}");
                        //     print(AllowAllowance<UseAmount);
                        //     if(AllowAllowance<UseAmount)
                        //       {
                        //         print("APPROVE ");
                        //         stackController.stackButtonText.value="Approve";
                        //       }
                        //     else
                        //       {
                        //         print("ENTER STAKE NOW");
                        //         stackController.stackButtonText.value="Stake Now";
                        //       }
                        //     //print("ALLOWANCE ${allowance}  AMMOUNT ${amount}");
                        //
                        //   }
                        // else
                        //   {
                        //     print("CONTRONMN");
                        //     stackController.stackButtonText.value="Approve";
                        //   }
                      },
                    ),
                  ),
                  InkWell(
                    onTap: ()
                    {
                      stackController.onTapMax();
                    },
                    child: Text(
                      'Max ',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 20,bottom: 15),
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Text("Lock Duration",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                ),
               SizedBox(height: 15,),
               Obx(()=>
                  Wrap(
                   spacing: 8.0, // Horizontal spacing between children
                   runSpacing: 8.0, // Vertical spacing between lines
                   children: [
                     ChipButton(text: "30 Months",onPressed: (){
                       stackController.chipButtontext.value="30 Months";
                       stackController.currentSelectLockDuration=0;
                       print("6 MONTHS");
                     }),
                     ChipButton(text: "60 Months",onPressed: (){
                       stackController.chipButtontext.value="60 Months";
                       stackController.currentSelectLockDuration=1;
                     }),
                     ChipButton(text: "90 Months",onPressed: (){
                       stackController.chipButtontext.value="90 Months";
                       stackController.currentSelectLockDuration=2;
                     }),
                     ChipButton(text: "180 Months",onPressed: (){
                       stackController.chipButtontext.value="180 Months";
                       stackController.currentSelectLockDuration=3;
                     }),
                     ChipButton(text: "365 Months",onPressed: (){
                       stackController.chipButtontext.value="365 Months";
                       stackController.currentSelectLockDuration=4;
                     }),
                   ],
                 ),
               )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(()=>
              CustomButton(
                title: stackController.stackButtonText.value,
                onTap: () async{
                  stackController.onPressStakeNowButton(privateKey:_userController.userResponseModel.value.user!.wallet.toString(),publicKey: _userController.publicKey.value );
                  // String allowance=await stackController.ApproveAllowanceFunction(privateKey: _userController.userResponseModel.value.user!.wallet.toString(), waletPublickey:_userController.publicKey.value );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ChipButton({required String text,required Function onPressed}) {
    return
       InputChip(
        onPressed: (){
          onPressed();
        },
        label: Semantics(
          button: true,
          child: Text(text,
            style: TextStyle(
                color:stackController.chipButtontext.value==text?Colors.white:AppColors.primaryColor
            ),
          ),
        ),
        backgroundColor:stackController.chipButtontext.value==text?AppColors.primaryColor:Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AppColors.primaryColor,
            width: 2.0, // Border width
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),

      );
  }

  Widget ShowStackInformationWidget({required String titleText,required String value}) {
    return
       Padding(
         padding: const EdgeInsets.all(10.0),
         child: Container(height: 60,
         decoration: BoxDecoration(
           color: Color(0xFFEEEEEE),
           borderRadius: BorderRadius.circular(5),
         ),
           child: Padding(
             padding: const EdgeInsets.only(left: 10,right: 10),
             child: Center(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(titleText,
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                     color: Colors.black,
                     fontSize: 18
                   ),
                   ),
                   Text(value,
                     style: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: Colors.black,
                         fontSize: 18
                     ),
                   )
                 ],
               ),
             ),
           ),
         ),
       );
  }
}
