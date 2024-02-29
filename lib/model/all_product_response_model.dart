import 'dart:convert';

List<AllProductResponseModel> allProductResponseModelFromJson(String str) => List<AllProductResponseModel>.from(json.decode(str).map((x) => AllProductResponseModel.fromJson(x)));

String allProductResponseModelToJson(List<AllProductResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllProductResponseModel {
  AllProductResponseModel({
    this.id,
    this.name,
    this.desc,
    this.quantity,
    this.price,
    this.originalPrice,
    this.discount,
    this.detailedName,
    this.returnHeading,
    this.returnDetails,
    this.warrenty,
    this.cancellationPolicies,
    this.image,
    this.active,
    this.category,
    this.ratings,
    this.reviewCount,
  });

  int? id;
  String? name;
  String? desc;
  int? quantity;
  String? price;
  String? originalPrice;
  String? discount;
  String? detailedName;
  String? returnHeading;
  String? returnDetails;
  String? warrenty;
  String? cancellationPolicies;
  String? image;
  int? active;
  int? category;
  String? ratings;
  int? reviewCount;

  factory AllProductResponseModel.fromJson(Map<String, dynamic> json) => AllProductResponseModel(
    id: json["id"],
    name: json["name"],
    desc: json["desc"],
    quantity: json["quantity"],
    price: json["price"],
    originalPrice: json["originalPrice"],
    discount: json["discount"],
    detailedName: json["detailedName"],
    returnHeading: json["returnHeading"],
    returnDetails: json["returnDetails"],
    warrenty: json["warrenty"],
    cancellationPolicies: json["cancellationPolicies"],
    image: json["image"],
    active: json["active"],
    category: json["category"],
    ratings: json["ratings"],
    reviewCount: json["reviewCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "desc": desc,
    "quantity": quantity,
    "price": price,
    "originalPrice": originalPrice,
    "discount": discount,
    "detailedName": detailedName,
    "returnHeading": returnHeading,
    "returnDetails": returnDetails,
    "warrenty": warrenty,
    "cancellationPolicies": cancellationPolicies,
    "image": image,
    "active": active,
    "category": category,
    "ratings": ratings,
    "reviewCount": reviewCount,
  };
}
