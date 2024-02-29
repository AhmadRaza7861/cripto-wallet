import 'dart:convert';

List<MyAddressResponseModel> myAddressResponseModelFromJson(String str) =>
    List<MyAddressResponseModel>.from(
        json.decode(str).map((x) => MyAddressResponseModel.fromJson(x)));

String myAddressResponseModelToJson(List<MyAddressResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyAddressResponseModel {
  MyAddressResponseModel({
    this.id,
    this.user,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.pincode,
    this.state,
    this.country,
    this.active,
  });

  int? id;
  int? user;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? pincode;
  String? state;
  String? country;
  int? active;

  factory MyAddressResponseModel.fromJson(Map<String, dynamic> json) =>
      MyAddressResponseModel(
        id: json["id"],
        user: json["user"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        landmark: json["landmark"],
        city: json["city"],
        pincode: json["pincode"],
        state: json["state"],
        country: json["country"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "landmark": landmark,
        "city": city,
        "pincode": pincode,
        "state": state,
        "country": country,
        "active": active,
      };
}
