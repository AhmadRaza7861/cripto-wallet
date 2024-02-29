import 'dart:convert';

import 'package:crypto_wallet/model/all_product_response_model.dart';

MyOrderResponseModel myOrderResponseModelFromJson(String str) =>
    MyOrderResponseModel.fromJson(json.decode(str));

String myOrderResponseModelToJson(MyOrderResponseModel data) =>
    json.encode(data.toJson());

class MyOrderResponseModel {
  MyOrderResponseModel({
    this.orders = const [],
  });

  List<Order> orders;

  factory MyOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      MyOrderResponseModel(
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.orderId,
    this.invoiceNo,
    this.products = const [],
    this.address,
    this.amount,
    this.orderDate,
    this.orderStatus,
  });

  int? orderId;
  String? invoiceNo;
  List<Product> products;
  String? address;
  String? amount;
  DateTime? orderDate;
  String? orderStatus;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"],
        invoiceNo: json["invoiceNo"],
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        address: json["address"],
        amount: json["amount"],
        orderDate:json["orderDate"] ==null?null: DateTime.parse(json["orderDate"]).toLocal(),
        orderStatus: json["orderStatus"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "invoiceNo": invoiceNo,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "address": address,
        "amount": amount,
        "orderDate": orderDate?.toIso8601String(),
        "orderStatus": orderStatus,
      };
}

class Product {
  Product({
    this.itemDetails,
    this.orderQuantity,
  });

  AllProductResponseModel? itemDetails;
  int? orderQuantity;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        itemDetails: json["itemDetails"] == null
            ? null
            : AllProductResponseModel.fromJson(json["itemDetails"]),
        orderQuantity: json["orderQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "itemDetails": itemDetails?.toJson(),
        "orderQuantity": orderQuantity,
      };
}
