// To parse this JSON data, do
//
//     final viewProductReview = viewProductReviewFromJson(jsonString);

import 'dart:convert';

ViewProductReview viewProductReviewFromJson(String str) => ViewProductReview.fromJson(json.decode(str));

String viewProductReviewToJson(ViewProductReview data) => json.encode(data.toJson());

class ViewProductReview {
  ViewProductReview({
    this.avgRating,
    this.reviews = const [],
  });

  double? avgRating;
  List<Review> reviews;

  factory ViewProductReview.fromJson(Map<String, dynamic> json) => ViewProductReview(
    avgRating: json["avg_rating"].toDouble(),
    reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "avg_rating": avgRating,
    "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
  };
}

class Review {
  Review({
    this.reviewId,
    this.productId,
    this.stars,
    this.review,
    this.insertedAt,
    this.updatedAt,
    this.user,
  });

  int? reviewId;
  int? productId;
  String? stars;
  String? review;
  DateTime? insertedAt;
  DateTime? updatedAt;
  User? user;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    reviewId: json["reviewId"],
    productId: json["productId"],
    stars: json["stars"],
    review: json["review"],
    insertedAt: DateTime.parse(json["insertedAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "reviewId": reviewId,
    "productId": productId,
    "stars": stars,
    "review": review,
    "insertedAt": insertedAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user!.toJson(),
  };
}

class User {
  User({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.wallet,
    this.profileImage,
  });

  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? wallet;
  String? profileImage;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    phone: json["phone"],
    wallet: json["wallet"],
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "phone": phone,
    "wallet": wallet,
    "profileImage": profileImage,
  };
}
