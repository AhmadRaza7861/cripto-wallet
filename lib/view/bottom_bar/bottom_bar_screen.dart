import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/bottom_bar/home/home_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/app_security_screen/biometrics_security_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/profile_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/shop/shopping_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/trade/trade_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/earn/rewards_coin_info_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../util/user_details.dart';
import 'home/widget/app_security_dailoge.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final HomeController _homeController = Get.find();
  final UserDetails _userDetails = UserDetails();

  int _selectedIndex = 0;
  List<Widget> _widgetList = [];
  DateTime? _currentBackPressTime;

  @override
  void initState() {
    super.initState();

    _widgetList.add(HomeScreen());
    _widgetList.add(WalletScreen());
    _widgetList.add(TradeScreen());
    _widgetList.add(ShoppingScreen());
    _widgetList.add(RewardsCoinInfoScreen());
    _widgetList.add(ProfileScreen());


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      _homeController.getExchangeInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
        builder: (cont) {
          if(cont.error.value.errorType == ErrorType.internet){
            return Container();
          }
          if(cont.isLightTheme.value){

          }
          return Stack(
            fit: StackFit.expand,
            children: [
              AppBar(),
              Container(
                height: 1.sh,
                width: 1.sw,
                child: Image.asset(
                  AppImage.imgBg,
                  fit: BoxFit.cover,
                ),
              ),
              WillPopScope(
                onWillPop: onWillPop,
                child: Scaffold(
                  // appBar: AppBar(),
                  // extendBody: true,
                  // extendBodyBehindAppBar: true,
                  backgroundColor: Colors.transparent,
                  bottomNavigationBar: bottomNavigationBar,
                  body: _widgetList[_selectedIndex],
                ),
              ),
            ],
          );
        }
    );
  }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius:  BorderRadius.only(
        topRight: Radius.circular(20.r),
        topLeft: Radius.circular(20.r),
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(3.w),
              child: Image.asset(
                AppImage.icHome,
                width: 18.w,
                height: 16.75.h,
                color: _selectedIndex == 0? AppColors.white:AppColors.gray,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(3.w),
              child: Image.asset(
                AppImage.icWallet,
                width: 20.w,
                height: 16.6.h,
                color: _selectedIndex == 1? AppColors.white:AppColors.gray,
              ),
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(3.w),
              child: Image.asset(
                AppImage.icTrade,
                width: 20.w,
                height: 20.w,
                color: _selectedIndex == 2? AppColors.white:AppColors.gray,
              ),
            ),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(3.w),
              child: Image.asset(
                AppImage.icShoppingCart,
                width: 20.w,
                height: 20.w,
                color: _selectedIndex == 3? AppColors.white:AppColors.gray,
              ),
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(3.w),
              child: Image.asset(
                AppImage.icEarn,
                width: 20.w,
                height: 20.w,
                color: _selectedIndex == 4? AppColors.white:AppColors.gray,
              ),
            ),
            label: 'Earn',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(3.w),
              child: Image.asset(
                AppImage.icProfile,
                width: 20.w,
                height: 20.w,
                color: _selectedIndex == 5? AppColors.white:AppColors.gray,
              ),
            ),
            label: 'Profile',
          ),

        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime??DateTime.now()) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      _homeController.showError(msg: "Press BACK again to exit!");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
