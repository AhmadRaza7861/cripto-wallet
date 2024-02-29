import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/home_controller.dart';
import '../../../controller/stack_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../model/your_staks_model.dart';
class YourStaksScreen extends StatefulWidget {
  const YourStaksScreen({Key? key}) : super(key: key);

  @override
  State<YourStaksScreen> createState() => _YourStaksScreenState();
}

class _YourStaksScreenState extends State<YourStaksScreen> {
  final StackController _stackController=Get.find();
  final UserController _userController = Get.find();
  //List<yourStaksModel> dataList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      _stackController.isLoading.value=false;
      String Abi= await _stackController.loadABIFile();
      _stackController.dataList.value=await _stackController.YourStakesLocallyFunction(waletPublickey: _userController.publicKey.value,StakeAbi: Abi );
      _stackController.isLoading.value=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
       _stackController.isLoading.value?ListView.builder(
        itemCount: _stackController.dataList.value.length,
          itemBuilder: (context,index)
      {
        int unixTimestamp = int.parse(_stackController.dataList.value[index].endTime.toString());
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
        String formattedDate = DateFormat("MMMM d, yyyy\n h:mm a").format(dateTime);
        BigInt? number=_stackController.dataList.value[index].claimReward;
        String clainReward=(number!/BigInt.from(1000000000000000000)).toString();
        return  _stackController.dataList.value[index].viewStaking?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.prBGColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                    ),
                    child:Padding(
                      padding: const EdgeInsets.only(top: 25,bottom: 25,left: 10,right: 10),
                      child: Column(
                        children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Amount :",
                            style: TextStyle(
                              color: AppColors.primaryColor.withOpacity(0.5),
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                            Container(
                              width: 110,
                              child: Text("${_stackController.dataList.value[index].amount.toString()!.substring(0,_stackController.dataList.value[index].amount.toString().length-18)} SLC",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Claimable Reward :",
                                style: TextStyle(
                                    color: AppColors.primaryColor.withOpacity(0.5),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Container(
                                width: 110,
                                child: Text("$clainReward SLC",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Withdrawal Time :",
                                style: TextStyle(
                                    color: AppColors.primaryColor.withOpacity(0.5),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),

                              Container(
                                width: 120,
                                child: Text(formattedDate,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ) ,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text('  Withdraw  ', style: TextStyle(color:AppColors.primaryColor)),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.only(right: 40,left: 40,top: 5,bottom: 5),),
                            // backgroundColor: MaterialStateProperty.all(
                            //     AppColors.buttonBGColor),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                              ),
                            )
                        ),
                        onPressed: () {
                          _stackController.onTapWithDrawAmount(withDrawIndex: index,waletPublickey: _userController.publicKey.value,privateKey: _userController.userResponseModel.value.user!.wallet.toString());
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.only(right: 40,left: 40,top: 5,bottom: 5),),
                            backgroundColor: MaterialStateProperty.all(
                                AppColors.buttonBGColor),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                              ),
                            )
                        ),
                        child: Text('Claim Reward',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _stackController.onTapClaimReward(claimAprIndex: index,waletPublickey: _userController.publicKey.value,privateKey: _userController.userResponseModel.value.user!.wallet.toString());
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ):Container();
      }
      ):Container(),
    );
  }
}
