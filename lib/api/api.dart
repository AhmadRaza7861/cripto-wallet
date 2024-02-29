
class ApiUrl {
  static const String  _baseUrl= 'https://api.starlinecrypto.com';
  static const String baseImageUrl = "https://demo.mozilit.com/superAdminLogin/suprtaxi/public/storage/";
  static const String socketBaseUrl = "wss://stream.binance.com:9443/ws";
  static const String binanceBaseUrl = "https://api.binance.com/api";
  static const String BASE_URL = _baseUrl;
  static const String graphUrl = "$BASE_URL/graph";
  static const String termsCondition = "$BASE_URL/terms";

  static const String getBSymbolPrice = "$binanceBaseUrl/v3/ticker/price";
  static const String getBSymbolChartData = "$binanceBaseUrl/v3/klines";
  static const String bExchangeInfo = "$binanceBaseUrl/v3/exchangeInfo";
  static  String getCryptoIconUrl({required String symbol}) => "https://coinicons-api.vercel.app/api/icon/${symbol.toLowerCase()}";
  // static  String getCryptoIconUrl({required String symbol}) => "https://cryptoicons.org/api/color/${symbol.toLowerCase()}/600";

  static const String loginWithEmail = "$BASE_URL/login/email";
  static const String register = "$BASE_URL/register";
  static const String sendOTP = "$BASE_URL/sendOTP";
  static const String sendEmailOTP = "$BASE_URL/sendEmailOTP";
  static const String checkEmail = "$BASE_URL/check/email";
  static const String checkPhone = "$BASE_URL/check/phone";
  static const String verifyEmail = "$BASE_URL/verify/email";
  static const String verifyPhone = "$BASE_URL/verify/phone";
  static const String currency = "$BASE_URL/currency";

  static const String deactivateAccount = "$BASE_URL/account/deactivate";

  static const String userInfo = "$BASE_URL/user/info";
  static const String userUpdate = "$BASE_URL/user/update";
  static const String userForgotPassword = "$BASE_URL/user/forgotPassword/email";
  static const String userResetPassword = "$BASE_URL/user/resetPassword";
  static const String userAddressAdd = "$BASE_URL/user/address/add";
  static const String userAddressEdit = "$BASE_URL/user/address/edit";
  static const String userAddressViewAll = "$BASE_URL/user/address/view/all";
  static const String kycUpload = "$BASE_URL/kyc/upload";

  static const String transactionUniqueUser = "$BASE_URL/transaction/history/users";
  static const String transactionHistory = "$BASE_URL/transaction/history";
  static const String allTransactionHistory = "$BASE_URL/transaction/history/all";
  static const String sendCoin = "$BASE_URL/transaction/send";
  static const String transactionDetails = "$BASE_URL/transaction/details";
  static const String withdraw = "$BASE_URL/withdraw";
  static const String withdrawInfo = "$BASE_URL/withdraw/info";

  static const String sendTradeBot = "$BASE_URL/tradebot/send";
  static const String depositInfo = "$BASE_URL/deposit/info";
  static const String tradebotInfo = "$BASE_URL/tradebot/info";


  static const String allProduct = "$BASE_URL/shop/display/all";
  static const String categoryProduct = "$BASE_URL/shop/display/category";
  static const String specificProduct = "$BASE_URL/shop/display/selected";
  static const String addToCart = "$BASE_URL/shop/cart/add";
  static const String removeFromCart = "$BASE_URL/shop/cart/remove";
  static const String viewCart = "$BASE_URL/shop/cart/view";
  static const String purchase = "$BASE_URL/shop/purchase";
  static const String purchaseDetails = "$BASE_URL/shop/purchase/detail";
  static const String myOrderHistory = "$BASE_URL/shop/history";
  static const String banners = "$BASE_URL/shopping/banners";
  static const String categories = "$BASE_URL/shopping/categories";
  static const String addNewReview = "$BASE_URL/shopping/product/review/new";
  static const String viewReview = "$BASE_URL/shopping/product/review/view";
  static const String tradBot = "$BASE_URL/tradebot/all";

  static const String paymentSheet = "$BASE_URL/payment-sheet";
  static const String updatePaymentStatus = "$BASE_URL/payment/update";

  static const String addressBookUpdate = "$BASE_URL/addressbook/update";
  static const String addressBookView = "$BASE_URL/addressbook/view";
  static const String viewallrewards = "$BASE_URL/spin_to_win/rewards";
  static const String startSpin = "$BASE_URL/spin_to_win/spin";
  static const String coupons = "$BASE_URL/coupons";
  static const String quizQuestion = "$BASE_URL/quiz/get/active";
  static const String sendQuizAnswer = "$BASE_URL/quiz/submit";
  static const String getPredictQuestion= "$BASE_URL/paw/questions";
  static const String sendPredictAnswer= "$BASE_URL/paw/submit";
  static const String getQuizResultHistory= "$BASE_URL/quiz/reward/history";
  static const String getTickets= "$BASE_URL/tickets";

}
