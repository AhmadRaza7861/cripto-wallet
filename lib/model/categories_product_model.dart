// To parse this JSON data, do
//
//     final categoriesMoldel = categoriesMoldelFromJson(jsonString);

import 'dart:convert';

List<CategoriesMoldel> categoriesMoldelFromJson(String str) => List<CategoriesMoldel>.from(json.decode(str)!.map((x) => CategoriesMoldel.fromJson(x)));

String categoriesMoldelToJson(List<CategoriesMoldel> data) => json.encode( List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesMoldel {
  CategoriesMoldel({
    this.id,
    this.name,
    this.desc,
    this.quantity,
    this.price,
    this.discount,
    this.detailedName,
    this.returnHeading,
    this.returnDetails,
    this.warrenty,
    this.cancellationPolicies,
    this.image,
    this.originalPrice,
    this.active,
    this.category,
  });

  int? id;
  String? name;
  String? desc;
  int? quantity;
  String? price;
  String? discount;
  String? detailedName;
  String? returnHeading;
  String? returnDetails;
  String? warrenty;
  String? cancellationPolicies;
  String? image;
  String? originalPrice;
  int? active;
  int? category;

  factory CategoriesMoldel.fromJson(Map<String, dynamic> json) => CategoriesMoldel(
    id: json["id"],
    name: json["name"],
    desc: json["desc"],
    quantity: json["quantity"],
    price: json["price"],
    discount: json["discount"],
    detailedName: json["detailedName"],
    returnHeading: json["returnHeading"],
    returnDetails: json["returnDetails"],
    warrenty: json["warrenty"],
    cancellationPolicies: json["cancellationPolicies"],
    image: json["image"],
    originalPrice: json["originalPrice"],
    active: json["active"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "desc": desc,
    "quantity": quantity,
    "price": price,
    "discount": discount,
    "detailedName": detailedName,
    "returnHeading": returnHeading,
    "returnDetails": returnDetails,
    "warrenty": warrenty,
    "cancellationPolicies": cancellationPolicies,
    "image": image,
    "originalPrice": originalPrice,
    "active": active,
    "category": category,
  };
}
