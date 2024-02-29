import 'dart:developer';
import 'package:country_code_picker/country_localizations.dart';
import 'package:crypto_wallet/controller/swap_screen_controller.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/controller/coin_detail_controller.dart';
import 'package:crypto_wallet/controller/home_controller.dart';
import 'package:crypto_wallet/controller/shop_controller.dart';
import 'package:crypto_wallet/controller/trade_controller.dart';
import 'package:crypto_wallet/controller/wallet_controller.dart';
import 'package:crypto_wallet/model/view_all_reward.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:crypto_wallet/view/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import 'controller/base_controller.dart';
import 'controller/predictController.dart';
import 'controller/quiz_controller.dart';
import 'controller/spinner_controller.dart';
import 'controller/theame_controller.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  // Stripe.publishableKey = "pk_test_51KY4rIDTWskRcVheL28yuBvlh1JcTfONUxFy8uM4aO0xf4LvLkKK21RHi5HiLCWGjrlmaKLC69WKFogF65DtP2Ip001Ijixifh";
  Stripe.publishableKey =
      "pk_live_51KY4rIDTWskRcVheRL6ObI7RuS75qhiraYMZwUC84gkst94Yyg9in1WwGvuK5oNNe99eFIUyE5MSGvZq0iKNuB7O00l4W5hmkM";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark,);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,

  ]);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserController _userController = Get.put(UserController());
  final SwapScreenController _swapScreenController = Get.put((SwapScreenController()));
  final WalletController _walletController = Get.put(WalletController());
  final TradeController _tradeController = Get.put(TradeController());
  final HomeController _homeController = Get.put(HomeController());
  final ShopController _shopController = Get.put(ShopController());
  final BaseController _baseController = Get.put(BaseController());
  final SpinnerController _spinnerController = Get.put(SpinnerController());
  final QuizController _quizController = Get.put(QuizController());
  final PredictController _predictController = Get.put(PredictController());

  final CoinDetailController _coinDetailController =
      Get.put(CoinDetailController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseMessaging.onBackgroundMessage((message) {
        log("RemoteMessage  ===>  12   ${message.data}");
        print("RemoteMessage  ===>  12   ${message.data}");
        return Future.value(true);
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        AppleNotification? appleNotification = message.notification?.apple;
        log("RemoteMessage  ===>  ${message.data}   ${Get.currentRoute}");
        print("RemoteMessage  ===>  ${message.data}  ${Get.currentRoute}");
        String? event = message.data["event"];
        String currentScreen = Get.currentRoute;
        if(event != null){
          if (event == "COIN_RECEIVED") {
            if (currentScreen.contains("UserActivityLogScreen")) {
              await _homeController.getTransactionHistoryByUser();
            }
            if(currentScreen.contains("BottomBarScreen")){
              await _walletController.getTransactionHistory(isShowLoader: false);
            }
            await _homeController.getTransactionUser();
          } else if (event == "COIN_SENT") {
            if (currentScreen.contains("UserActivityLogScreen")) {
              await _homeController.getTransactionHistoryByUser();
            }
            if(currentScreen.contains("BottomBarScreen")){
              await _walletController.getTransactionHistory(isShowLoader: false);
            }
            await _homeController.getTransactionUser();
          } else if (event == "COIN_WITHDRAW_REQUEST") {
            if (currentScreen.contains("UserActivityLogScreen")) {
              await _homeController.getTransactionHistoryByUser();
            }
            if(currentScreen.contains("BottomBarScreen")){
              await _walletController.getTransactionHistory(isShowLoader: false);
            }
          }else if (event == "COIN_WITHDRAW_REJECTED") {
            if (currentScreen.contains("UserActivityLogScreen")) {
              await _homeController.getTransactionHistoryByUser();
            }
            if(currentScreen.contains("BottomBarScreen")){
              await _walletController.getTransactionHistory(isShowLoader: false);
            }
          } else if (event == "TRADEBOT_CREATED") {
            await _walletController.getTransactionHistory(isShowLoader: false);
          } else if (event == "TRADEBOT_RETURNED") {
            await _walletController.getTransactionHistory(isShowLoader: false);
          } else if (event == "COIN_DEPOSITED") {
            await _walletController.getTransactionHistory(isShowLoader: false);
          } else if (event == "COIN_WITHDRAW_REQUEST") {
            await _walletController.getTransactionHistory(isShowLoader: false);
          }
          await _userController.getUserInfo(isScreenChange: false);
        }

        /*if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              playSound: true,
              icon: "@mipmap/ic_launcher",
            ),
          ),
        );
      } else if (notification != null && appleNotification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              iOS: IOSNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              )),
        );
      }*/
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      // minTextAdapt: true,
      // splitScreenMode: true,
      builder: (BuildContext context, Widget? child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            unselectedWidgetColor: Colors.white,
            primarySwatch: _primaryColor,
            fontFamily: "Roboto",
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(),
              titleTextStyle: TextStyle(
                color: AppColors.textColor,
                fontSize: 18.sm,
                fontWeight: FontWeight.w600,
              ),
              iconTheme:  IconThemeData(
                color: AppColors.white,
              ),
            )
            // scaffoldBackgroundColor: const Color.fromARGB(255, 250, 196, 2),
            ),
        darkTheme:  ThemeData(
            unselectedWidgetColor: Colors.white,
          // backgroundColor: ,
            primarySwatch: _primaryColor,
            fontFamily: "Roboto",
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              // systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(),
              titleTextStyle: TextStyle(
                color: AppColors.textColor,
                fontSize: 18.sm,
                fontWeight: FontWeight.w600,
              ),
              iconTheme:  IconThemeData(
                color: AppColors.white,
              ),
            )
          // scaffoldBackgroundColor: const Color.fromARGB(255, 250, 196, 2),
        ),
        // themeMode: _homeController.isLightTheme.value?ThemeMode.light:ThemeMode.dark,
        home: child,
        localizationsDelegates: const [
          CountryLocalizations.delegate,
          // GlobalMaterialLocalizations.delegate,
          // GlobalWidgetsLocalizations.delegate,
        ],
      ),
      child: const SplashScreen(),
    );
  }

  final MaterialColor _primaryColor =
      MaterialColor(AppColors.white.value,  {
    50: AppColors.white,
    100: AppColors.white,
    200: AppColors.white,
    300: AppColors.white,
    400: AppColors.white,
    500: AppColors.white,
    600: AppColors.white,
    700: AppColors.white,
    800: AppColors.white,
    900: AppColors.white,
  });
}
