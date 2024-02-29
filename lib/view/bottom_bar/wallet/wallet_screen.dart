import 'dart:developer';

import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/controller/wallet_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/all_transaction_history_response_model.dart';
import 'package:crypto_wallet/model/deposit_info_response_model.dart';
import 'package:crypto_wallet/model/trade_bot_info_response_model.dart';
import 'package:crypto_wallet/model/transaction_history_response_model.dart';
import 'package:crypto_wallet/model/user_response_model.dart';
import 'package:crypto_wallet/model/with_draw_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/home/user_activity_log/transaction_detail/transaction_detail_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/wallet/add_address/add_address_widget.dart';
import 'package:crypto_wallet/view/bottom_bar/wallet/deposit/deposit_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/wallet/deposit_info/deposit_info_bottomsheet.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/rewards_coin_info_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/tradebot_history_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/wallet/wallet_info/wallet_info_bottomsheet.dart';
import 'package:crypto_wallet/view/bottom_bar/wallet/withdraw/withdraw_screen.dart';
import 'package:crypto_wallet/view/common_widget/api_status_manage_widget.dart';
import 'package:crypto_wallet/view/common_widget/custom_button.dart';
import 'package:crypto_wallet/view/common_widget/custom_user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../trade/trade_screen.dart';
import 'trade_bot_info/trade_bot_info_bottomsheet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final GlobalKey _appBarKey = GlobalKey();
  final UserController _userController = Get.find();
  final WalletController _walletController = Get.find();
  final ShopController _shopController = Get.find();
  double _appBarSize = 0;
  final DateFormat _dateFormat = DateFormat("MMMM dd,yyyy 'at' hh:mm aa");
  final DateTime _nowDateTime = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Size? size = _appBarKey.currentContext?.size;
      _appBarSize = size?.height ?? 0;
      setState(() {});
      // _walletController.transactionHistoryList.clear();
      await _walletController.getTransactionHistory();
      await _walletController.getAddressBookView();
      await _walletController.getTradeBotList();
    });
    _scrollController.addListener(() {
      if (_scrollController.offset < 150) setState(() {});
    });
    _tabController?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isShowAppbarTitle = _scrollController.positions.isNotEmpty
        ? _scrollController.offset > 100
        : false;
    return Stack(
      children: [
        Container(
          height: 1.sh,
          width: 1.sw,
          child: Image.asset(
            AppImage.imgBg,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: AppColors.screenBGColor,
          // appBar:isShowAppbarTitle? null:AppBar(title: Text("Wallet"),),
          body: GetX<WalletController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return Container();
            }
            return NestedScrollView(
              controller: _scrollController,
              clipBehavior: Clip.antiAlias,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  if (_appBarSize != 0)
                    SliverAppBar(
                      pinned: true,
                      primary: true,
                      stretch: true,
                      title: isShowAppbarTitle
                          ? Text(
                        "Wallet",
                        style:
                        TextStyle(color: AppColors.appBarTitelColor),
                      )
                          : null,
                      backgroundColor: !isShowAppbarTitle
                          ? Colors.transparent
                          : AppColors.bottomSheetBG,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: _appBarSize != 0
                            ? Column(
                          children: [
                            SizedBox(height: kToolbarHeight),
                            appBarWidget(),
                          ],
                        )
                            : null,
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(30.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.w, vertical: 5.w),
                          decoration: BoxDecoration(
                            color: isShowAppbarTitle
                                ? AppColors.bottomSheetBG
                                : Colors.transparent,
                          ),
                          child: SizedBox(
                            height: 30.h,
                            child: TabBar(
                              unselectedLabelColor:
                              AppColors.walletSubTextColor,
                              labelColor: AppColors.walletTextColor,
                              indicatorColor: AppColors.walletTextColor,
                              tabs: <Widget>[
                                Tab(
                                  child: Text(
                                    "History",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Address Book",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                )
                              ],
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                              // indicator: BoxDecoration(
                              //   color: AppColors.primaryColor,
                              //   borderRadius: BorderRadius.circular(
                              //     10.r,
                              //   ),
                              // ),

                              padding: EdgeInsets.zero,
                              labelPadding: EdgeInsets.zero,
                              indicatorPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                      expandedHeight: _appBarSize + kToolbarHeight + 20,
                    )
                ];
              },
              body: Stack(
                children: [
                  if (_appBarSize == 0)
                    Column(
                      children: [
                        SizedBox(height: kToolbarHeight),
                        appBarWidget(key: _appBarKey),
                      ],
                    )
                  else
                    Container(
                      // decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          Expanded(
                            child: TabBarView(
                              viewportFraction: 1,
                              controller: _tabController,
                              children: <Widget>[
                                ApiStatusManageWidget(
                                    height: 300.h,
                                    apiStatus:
                                    cont.transactionHistoryList.value,
                                    child: ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 10.h,
                                      ),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        AllTransactionHistoryResponseModel
                                        allTransactionHistoryResponseModel =
                                        cont.transactionHistoryList.value
                                            .data[index];
                                        Type type =
                                            allTransactionHistoryResponseModel
                                                .type ??
                                                Type.SHOPPING;
                                        // if(type == Type.TRADEBOT_RETURN){
                                        //   type = Type.TRADEBOT;
                                        // }
                                        if (type == Type.WITHDRAW_REJECTED) {
                                          type = Type.WITHDRAW;
                                        }
                                        return  InkWell(
                                          onTap: () async {
                                            if (type == Type.COIN_TRANSFER) {
                                              TransactionHistoryResponseModel?
                                              transactionHistoryResponseModel =
                                              await cont.getTransactionDetails(
                                                  transactionId:
                                                  allTransactionHistoryResponseModel
                                                      .transactionId ??
                                                      0);
                                              if (transactionHistoryResponseModel !=
                                                  null) {
                                                Get.bottomSheet(
                                                  TransactionDetailScreen(
                                                    transactionHistoryResponseModel:
                                                    transactionHistoryResponseModel,
                                                  ),
                                                  isScrollControlled: true,
                                                );
                                              }
                                            } else if (type == Type.SHOPPING) {
                                              _shopController.getOrderDetails(
                                                  transactionId:
                                                  allTransactionHistoryResponseModel
                                                      .transactionId ??
                                                      0);
                                            } else if (type == Type.WITHDRAW) {
                                              WithDrawResponseModel?
                                              withDrawResponseModel =
                                              await cont.withDrawInfo(
                                                transactionId:
                                                allTransactionHistoryResponseModel
                                                    .transactionId ??
                                                    0,
                                              );
                                              if (withDrawResponseModel !=
                                                  null) {
                                                Get.bottomSheet(
                                                    WalletInfoBottomSheet(
                                                        withDrawResponseModel:
                                                        withDrawResponseModel),
                                                    isScrollControlled: true);
                                              }
                                            } else if (type == Type.TRADEBOT ||
                                                type == Type.TRADEBOT_RETURN) {
                                              TradeBotInfoResponseModel?
                                              tradeBotInfoResponseModel =
                                              await cont.tradeBotInfo(
                                                transactionId:
                                                allTransactionHistoryResponseModel
                                                    .transactionId ??
                                                    0,
                                              );

                                              if (tradeBotInfoResponseModel !=
                                                  null) {
                                                Get.bottomSheet(
                                                    TradeBotInfoBottomsheet(
                                                        tradeBotInfoResponseModel:
                                                        tradeBotInfoResponseModel),
                                                    isScrollControlled: true);
                                              }
                                            } else if (type == Type.DEPOSIT) {
                                              DepositInfoResponseModel?
                                              depositInfoResponseModel =
                                              await cont.depositInfo(
                                                transactionId:
                                                allTransactionHistoryResponseModel
                                                    .transactionId ??
                                                    0,
                                              );

                                              if (depositInfoResponseModel !=
                                                  null) {
                                                Get.bottomSheet(
                                                    DepositInfoBottomSheet(
                                                        depositInfoResponseModel:
                                                        depositInfoResponseModel),
                                                    isScrollControlled: true);
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors
                                                          .withDrawBorderColor),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      16.r),
                                                  color:
                                                  AppColors.liteGraylist),
                                              padding: EdgeInsets.all(15.w),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 40.w,
                                                    height: 40.w,
                                                    padding:
                                                    EdgeInsets.all(9.w),
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .iconBGBlue,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(12.r)
                                                      // shape: BoxShape.circle,
                                                    ),
                                                    child: Image.asset(
                                                      type == Type.SHOPPING
                                                          ? AppImage
                                                          .icWalletShopCart
                                                          : (type == Type.TRADEBOT ||
                                                          type ==
                                                              Type
                                                                  .TRADEBOT_RETURN)
                                                          ? AppImage
                                                          .icTradeBot
                                                          : type ==
                                                          Type
                                                              .WITHDRAW
                                                          ? AppImage
                                                          .icMoneyWithdrawal
                                                          : type ==
                                                          Type
                                                              .COIN_TRANSFER
                                                          ? AppImage
                                                          .icTransaction
                                                          : type == Type.DEPOSIT
                                                          ? AppImage
                                                          .icDeposit
                                                          : (type == Type.REFERAL_REWARD ||
                                                          type == Type.DAILY_SPIN ||
                                                          type == Type.QUIZ_REWARD ||
                                                          type == Type.MONTHLY_REWARD)
                                                          ? AppImage.icBonus
                                                          : AppImage.icDeposit,
                                                      color: AppColors
                                                          .walletIconColor,
                                                    ),
                                                  ),
                                                  SizedBox(width: 9.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        // if(transactionHistoryResponseModel.type == "")
                                                        Text(
                                                          type ==
                                                              Type
                                                                  .DAILY_SPIN
                                                              ? "REWARD"
                                                              : type ==
                                                              Type
                                                                  .TRADEBOT_RETURN
                                                              ? "TRADEBOT EARNINGS"
                                                              : type ==
                                                              Type
                                                                  .REFERAL_REWARD
                                                              ? "REWARD"
                                                          // : type ==
                                                          //         Type.WITHDRAW_REJECTED
                                                          //     ? "WITHDRAW REJECTED"
                                                              : type ==
                                                              Type.DEPOSIT
                                                              ? "DEPOSIT"
                                                              : type == Type.COIN_TRANSFER
                                                              ? "COIN TRANSFER"
                                                              : type == Type.QUIZ_REWARD
                                                              ? "QUIZ REWARD"
                                                              : type == Type.MONTHLY_REWARD
                                                              ? "MONTHLY REWARD"
                                                              : type == Type.SHOPPING
                                                              ? "SHOPPING"
                                                              : type == Type.TRADEBOT
                                                              ? "TRADEBOT"
                                                              : type == Type.WITHDRAW
                                                              ? "WITHDRAW"
                                                          // : type != Type.COIN_TRANSFER
                                                          //     ? type.name
                                                              : "${allTransactionHistoryResponseModel.user?.firstname ?? ""} ${allTransactionHistoryResponseModel.user?.lastname ?? ""}",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .walletTextColor,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.h),
                                                        Text(
                                                          '${_dateFormat.format(
                                                            (allTransactionHistoryResponseModel
                                                                .time ??
                                                                _nowDateTime),
                                                          )}',
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .walletSubTextColor,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  Text(
                                                    (allTransactionHistoryResponseModel
                                                        .amount ??
                                                        0)
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                      color: (allTransactionHistoryResponseModel
                                                          .amount ??
                                                          0) >
                                                          0
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: cont.transactionHistoryList
                                          .value.data.length,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                    )),
                                ApiStatusManageWidget(
                                    height: 300.h,
                                    apiStatus: cont.saveAddressList.value,
                                    child: ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 10.h),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        User user = cont
                                            .saveAddressList.value.data[index];
                                        return InkWell(
                                          onTap: () async {
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: user.wallet ?? ""));
                                            _userController.showSnack(
                                                msg:
                                                "Successfully Address Copy");
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.liteGraylist,
                                              borderRadius:
                                              BorderRadius.circular(16.r),
                                              border: Border.all(
                                                  color: AppColors
                                                      .withDrawBorderColor),
                                            ),
                                            padding: EdgeInsets.all(15.w),
                                            child: Row(
                                              children: [
                                                CustomUserProfileImage(
                                                    width: 35.w, user: user),
                                                SizedBox(width: 5.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        "${user.firstname ?? ""} ${user.lastname ?? ""}",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .walletTextColor,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w400),
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      Text(
                                                        '${user.wallet}',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .walletSubTextColor,
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w400),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 5.w),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: cont
                                          .saveAddressList.value.data.length,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                    )),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 30.w),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: CustomButton(
                          //           titleWidget: Row(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               Image.asset(
                          //                 AppImage.icSend,
                          //                 width: 16.w,
                          //               ),
                          //               SizedBox(width: 3.w),
                          //               Text(
                          //                 "Send",
                          //                 style: TextStyle(
                          //                   fontSize: 14.sp,
                          //                   color: Colors.white,
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(width: 10.w),
                          //       Expanded(
                          //         child: CustomButton(
                          //           titleWidget: Row(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               Image.asset(
                          //                 AppImage.icReceive,
                          //                 width: 16.w,
                          //                 color: AppColors.primaryColor,
                          //               ),
                          //               SizedBox(width: 3.w),
                          //               Text(
                          //                 "Receive",
                          //                 style: TextStyle(
                          //                     fontSize: 14.sp,
                          //                     color: AppColors.primaryColor),
                          //               )
                          //             ],
                          //           ),
                          //           bgColor: Colors.transparent,
                          //           isShowBorder: true,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 20.h)
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
          floatingActionButton: _tabController?.index == 0
              ? null
              : FloatingActionButton(
            onPressed: () {
              Get.bottomSheet(
                const AddAddressWidget(),
                isScrollControlled: true,
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget appBarWidget({GlobalKey? key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: <Widget>[
            // if (_appBarSize != 0)
            //   Column(
            //     children: [
            //       Container(
            //         height: _appBarSize / 2,
            //         color: AppColors.lightGray,
            //       ),
            //       Container(
            //         height: _appBarSize / 2,
            //         color: AppColors.white,
            //       ),
            //     ],
            //   ),
            Stack(
              children: [
                Container(
                  padding:
                  EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                      color: AppColors.walletConBGColor,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 0.5.r,
                      //     blurRadius: 0.5.r,
                      //     offset: const Offset(
                      //       0.5,
                      //       1,
                      //     ),
                      //   )
                      // ],
                      borderRadius: BorderRadius.circular(15.r)),
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Available Coin",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "${AppString.currencySymbol} ${_userController.userResponseModel.value.user?.balance ?? "0"}",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20.w,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  // left: 120.w,
                  top: 6.h,
                  right: 28.w,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const RewardsCoinInfoScreen());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightGray10,
                      ),
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        Icons.info_outline,
                        color: AppColors.white,
                        size: 15.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 0.h),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    DateTime _dateTime = DateTime.now();
                    log("message   ===>   ${_dateFormat.format(_dateTime)}     ${_dateTime.toUtc()}");
                    Get.to(() => const DepositScreen());
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColors.walletConBGColor),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImage.icAdd,
                          width: 18.w,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "Deposit",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: InkWell(
              //     onTap: () {
              //       Get.to(() => TradeBotScreen());
              //     },
              //     child: Container(
              //       margin: EdgeInsets.symmetric(horizontal: 12.w),
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(16.r),
              //           color: AppColors.walletConBGColor),
              //       padding: EdgeInsets.symmetric(vertical: 12.h),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Image.asset(
              //             AppImage.icTradewallet,
              //             width: 18.w,
              //           ),
              //           SizedBox(
              //             height: 5.h,
              //           ),
              //           Text(
              //             "Trade",
              //             style: TextStyle(
              //                 fontSize: 12.sp,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.w400),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => const WithDrawScreen());
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColors.walletConBGColor),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImage.icWithdraw,
                          width: 18.w,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "Withdraw",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
