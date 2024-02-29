import 'dart:convert';

UserResponseModel userResponseModelFromJson(String str) => UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) => json.encode(data.toJson());

class UserResponseModel {
  UserResponseModel({
    this.message,
    this.user,
    this.brearerToken,
  });

  String? message;
  User? user;
  String? brearerToken;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) => UserResponseModel(
    message: json["message"],
    user:json["user"] == null?null: User.fromJson(json["user"]),
    brearerToken: json["brearerToken"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "user": user?.toJson(),
    "brearerToken": brearerToken,
  };
}

class User {
  User({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.referralCode,
    this.balance,
    this.wallet,
    this.profileImage,
    this.emailVerified,
    this.phoneVerified,
    this.address,
    this.kycVerified,
    this.countryCode,
  });

  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? referralCode;
  String? balance;
  String? wallet;
  String? profileImage;
  int? emailVerified;
  int? phoneVerified;
  String? address;
  String? kycVerified;
  String? countryCode;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    phone: json["phone"],
    referralCode: json["referralCode"],
    balance: json["balance"],
    wallet: json["wallet"]??json["walletAddress"],
    profileImage: json["profileImage"],
    emailVerified: json["emailVerified"],
    phoneVerified: json["phoneVerified"],
    address: json["address"],
    kycVerified: json["kycVerified"],
    countryCode: json["country_code"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "phone": phone,
    "referralCode": referralCode,
    "balance": balance,
    "wallet": wallet,
    "profileImage": profileImage,
    "emailVerified": emailVerified,
    "phoneVerified": phoneVerified,
    "address": address,
    "kycVerified": kycVerified,
    "country_code": countryCode,

  };
}
