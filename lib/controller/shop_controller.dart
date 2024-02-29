import 'dart:convert';
import 'dart:developer';

import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/api/api_service.dart';
import 'package:crypto_wallet/controller/user_controller.dart';
import 'package:crypto_wallet/controller/base_controller.dart';
import 'package:crypto_wallet/enum/api_status_type.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/all_product_response_model.dart';
import 'package:crypto_wallet/model/my_address_response_model.dart';
import 'package:crypto_wallet/model/my_order_response_model.dart';
import 'package:crypto_wallet/view/bottom_bar/profile/my_orders/my_order_details/my_order_details_screen.dart';
import 'package:crypto_wallet/view/bottom_bar/shop/cart/cart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/Banner_Model.dart';
import '../model/categories_model.dart';
import '../model/view_product_review_model.dart';

class ShopController extends BaseController {
  final UserController _userController = Get.find();
  Rx<ApiStatus<List<AllProductResponseModel>>> allProductList =
      ApiStatus(data: <AllProductResponseModel>[]).obs;
  RxList<AllProductResponseModel> tempProductList =
      <AllProductResponseModel>[].obs;
  Rx<ApiStatus<List<AllProductResponseModel>>> cartList = ApiStatus(data: <AllProductResponseModel>[]).obs;
  Rx<ApiStatus<List<AllProductResponseModel>>> categoriesProductList = ApiStatus(data: <AllProductResponseModel>[]).obs;
  Rx<ApiStatus<List<Order>>> myOrderList = ApiStatus(data: <Order>[]).obs;
  Rx<ApiStatus<List<BannerModel>>> bannerList = ApiStatus(data: <BannerModel>[]).obs;
  Rx<ApiStatus<List<CategoriesMoldel>>> categoriesList = ApiStatus(data: <CategoriesMoldel>[]).obs;
  Rx<ApiStatus<List<Review>>> viewProductReview = ApiStatus(data: <Review>[]).obs;
  RxDouble totalAmount = 0.0.obs;
  TextEditingController addressController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  MyAddressResponseModel? selectedAddress;

  @override
  void onInit() {
    super.onInit();

    cartList.listen((p0) {
      _checkTotalAmount();
    });

    searchController.addListener(() {
      allProductList.value.data.clear();
      if (searchController.text.isNotEmpty) {
        for (var element in tempProductList) {
          if ((element.name ?? "")
              .toLowerCase()
              .contains(searchController.text.toLowerCase())) {
            allProductList.value.data.add(element);
          }
        }
      } else {
        allProductList.value.data.addAll(tempProductList);
      }
    });
  }

  Future<void> getAllProduct() async {
    try {
      searchController.clear();
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      allProductList.value.apiStatusType = ApiStatusType.loading;
      allProductList.refresh();
      await apiService.postRequest(
          url: ApiUrl.allProduct,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            allProductList.value.apiStatusType = ApiStatusType.none;
            allProductList.value.data.clear();
            tempProductList.clear();
            List<AllProductResponseModel> tempList =
                allProductResponseModelFromJson(jsonEncode(data["response"]));
            tempProductList.addAll(tempList);
            allProductList.value.data.addAll(tempList);
            log("data - - -- $data");
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
            allProductList.value.apiStatusType = ApiStatusType.error;
          });
    } catch (e) {
      showError(msg: "$e");
      allProductList.value.apiStatusType = ApiStatusType.error;
    }
    allProductList.refresh();
  }


  Future<void> getCategoriesProduct(int? categoryId) async {
    try {
      searchController.clear();
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      params["categoryId"] = categoryId ?? 0;
      categoriesProductList.value.apiStatusType = ApiStatusType.loading;
      categoriesProductList.refresh();
      await apiService.postRequest(
          url: ApiUrl.categoryProduct,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            categoriesProductList.value.apiStatusType = ApiStatusType.none;
            categoriesProductList.value.data.clear();
            // tempProductList.clear();
            List<AllProductResponseModel> tempList =
            allProductResponseModelFromJson(jsonEncode(data["response"]));
            // tempProductList.addAll(tempList);
            categoriesProductList.value.data.addAll(tempList);
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
            categoriesProductList.value.apiStatusType = ApiStatusType.error;
          });
    } catch (e) {
      showError(msg: "$e");
      categoriesProductList.value.apiStatusType = ApiStatusType.error;
    }
    categoriesProductList.refresh();
  }

  Future<void> addToCart(
      {required AllProductResponseModel allProductResponseModel,
      int qty = 1}) async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      params["itemID"] = allProductResponseModel.id;
      params["quantity"] = qty;
      cartList.value.apiStatusType = ApiStatusType.loading;
      cartList.refresh();
      await apiService.postRequest(
          url: ApiUrl.addToCart,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            cartList.value.apiStatusType = ApiStatusType.none;
            cartList.value.data.clear();
            List<AllProductResponseModel> tempList =
                allProductResponseModelFromJson(jsonEncode(data["response"]));
            cartList.value.data.addAll(tempList);
            Get.to(() => const CartScreen());
          },
          onError: (ErrorType errorType, String msg) {
            cartList.value.apiStatusType = ApiStatusType.none;
            showError(msg: msg);
          });
    } catch (e) {
      cartList.value.apiStatusType = ApiStatusType.none;
      showError(msg: "$e");
    }
    cartList.refresh();
  }

  Future<bool> removeFromCart(
      {required AllProductResponseModel allProductResponseModel,
      bool isQtyChanged = false}) async {
    bool isSuccess = false;
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      params["itemID"] = allProductResponseModel.id;
      cartList.value.apiStatusType = ApiStatusType.loading;
      cartList.refresh();
      await apiService.postRequest(
          url: ApiUrl.removeFromCart,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            // dismissLoader();
            cartList.value.apiStatusType = ApiStatusType.none;
            cartList.refresh();
            if (!isQtyChanged) {
              cartList.value.data.clear();
              List<AllProductResponseModel> tempList =
                  allProductResponseModelFromJson(jsonEncode(data["response"]));
              cartList.value.data.addAll(tempList);
            }
            isSuccess = true;
          },
          onError: (ErrorType errorType, String msg) {
            cartList.value.apiStatusType = ApiStatusType.error;
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
      cartList.value.apiStatusType = ApiStatusType.error;
    }
    cartList.refresh();
    return isSuccess;
  }

  Future<void> manualQty(
      {required AllProductResponseModel allProductResponseModel,
      int qty = 1}) async {
    try {
      showLoader();
      bool isSuccess = await removeFromCart(
        allProductResponseModel: allProductResponseModel,
        isQtyChanged: true,
      );
      if (isSuccess) {
        await addToCart(
            allProductResponseModel: allProductResponseModel, qty: qty);
      }
      dismissLoader();
    } catch (e) {
      dismissLoader();
    }
  }

  Future<void> getViewCart() async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      cartList.value.apiStatusType = ApiStatusType.loading;
      cartList.refresh();
      await apiService.postRequest(
          url: ApiUrl.viewCart,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            cartList.value.apiStatusType = ApiStatusType.none;
            cartList.value.data.clear();
            List<AllProductResponseModel> tempList =
                allProductResponseModelFromJson(jsonEncode(data["response"]));
            cartList.value.data.addAll(tempList);
          },
          onError: (ErrorType errorType, String msg) {
            cartList.value.apiStatusType = ApiStatusType.error;
            showError(msg: msg);
          });
    } catch (e) {
      cartList.value.apiStatusType = ApiStatusType.error;
      showError(msg: "$e");
    }
    cartList.refresh();
  }

  Future<void> placeOrder() async {
    try {
      if (selectedAddress == null) {
        showError(msg: "Please select delivery address");
        return;
      }
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      params["addressLine1"] = selectedAddress?.addressLine1;
      params["addressLine2"] = selectedAddress?.addressLine2;
      params["landmark"] = selectedAddress?.landmark;
      params["pincode"] = selectedAddress?.pincode;
      params["city"] = selectedAddress?.city;
      params["state"] = selectedAddress?.state;
      params["country"] = selectedAddress?.country;
      cartList.value.apiStatusType = ApiStatusType.loading;
      cartList.refresh();
      await apiService.postRequest(
          url: ApiUrl.purchase,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            cartList.value.apiStatusType = ApiStatusType.none;
            cartList.value.data.clear();
            // await _userController.getUserInfo(isScreenChange: false);
            Get.back();
            Get.back();
            showSnack(msg: data["response"]["message"]);
          },
          onError: (ErrorType errorType, String msg) {
            cartList.value.apiStatusType = ApiStatusType.error;
            showError(msg: msg);
          });
    } catch (e) {
      cartList.value.apiStatusType = ApiStatusType.error;
      showError(msg: "$e");
    }
    cartList.refresh();
  }

  Future<void> getMyOrder() async {
    try {
      Map<String, dynamic> params = {};
      myOrderList.value.apiStatusType = ApiStatusType.loading;
      myOrderList.refresh();
      await apiService.postRequest(
          url: ApiUrl.myOrderHistory,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            myOrderList.value.apiStatusType = ApiStatusType.none;
            myOrderList.value.data.clear();
            MyOrderResponseModel myOrderResponseModel =
                myOrderResponseModelFromJson(jsonEncode(data["response"]));
            myOrderList.value.data.addAll(myOrderResponseModel.orders);
          },
          onError: (ErrorType errorType, String msg) {
            myOrderList.value.apiStatusType = ApiStatusType.error;
            showError(msg: msg);
          });
    } catch (e) {
      myOrderList.value.apiStatusType = ApiStatusType.error;
      showError(msg: "$e");
    }
    myOrderList.refresh();
  }

  Future<void> getOrderDetails({required int transactionId}) async {
    try {
      Map<String, dynamic> params = {};
      params["orderId"] = transactionId;

      showLoader();
      await apiService.postRequest(
          url: ApiUrl.purchaseDetails,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            Order order = Order.fromJson(data["response"]);
            Get.to(() => MyOrderDetailsScreen(order: order));
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }


  Future<void> getBanners() async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      bannerList.value.apiStatusType = ApiStatusType.loading;
      bannerList.refresh();
      // showLoader();
      await apiService.postRequest(
          url: ApiUrl.banners,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            bannerList.value.apiStatusType = ApiStatusType.none;
            bannerList.value.data.clear();
            List<BannerModel> tempList = bannerModelFromJson(jsonEncode(data["response"]));
            bannerList.value.data.addAll(tempList);
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> getCategories() async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      categoriesList.value.apiStatusType = ApiStatusType.loading;
      categoriesList.refresh();
      // showLoader();
      await apiService.postRequest(
          url: ApiUrl.categories,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            categoriesList.value.apiStatusType = ApiStatusType.none;
            categoriesList.value.data.clear();
            List<CategoriesMoldel> tempList = categoriesMoldelFromJson(jsonEncode(data["response"]));
            categoriesList.value.data.addAll(tempList);
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> sendReview(int? id, String? review , double? newReview  ) async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      params["productId"] = id ?? 0;
      params["review"] = review ?? "";
      params["stars"] = newReview ?? 0.0;
      // cartList.value.apiStatusType = ApiStatusType.loading;
      // cartList.refresh();
      showLoader();
      await apiService.postRequest(
          url: ApiUrl.addNewReview,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader() ;
            print(" id  ==   ${data["response"]["id"]}");
            print(" review  ==   ${data["response"]["review"]}");
            print(" stars  ==   ${data["response"]["stars"]}");
            Get.back();
          },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
      dismissLoader() ;
    } catch (e) {
      showError(msg: "$e");
    }
  }

  Future<void> viewReview(int? id) async {
    try {
      Map<String, dynamic> params = {};
      params["id"] = _userController.userResponseModel.value.user?.id ?? 0;
      params["productId"] = id ?? 0;
      viewProductReview.refresh();

      // showLoader();
      await apiService.postRequest(
          url: ApiUrl.viewReview,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            viewProductReview.value.apiStatusType = ApiStatusType.none;
            viewProductReview.value.data.clear();
            ViewProductReview _viewProductReview = viewProductReviewFromJson(jsonEncode(data["response"]));
            viewProductReview.value.data.addAll(_viewProductReview.reviews);
            },
          onError: (ErrorType errorType, String msg) {
            showError(msg: msg);
          });
      dismissLoader() ;
    } catch (e) {
      showError(msg: "$e");
    }
    viewProductReview.refresh();

  }


  void _checkTotalAmount() {
    totalAmount.value = 0.0;
    for (var element in cartList.value.data) {
      totalAmount.value = (totalAmount.value +
          ((double.tryParse(element.price ?? "0") ?? 0) *
              (element.quantity ?? 0)));
    }
  }
}
