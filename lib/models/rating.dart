// To parse this JSON data, do
//
//     final rating = ratingFromMap(jsonString);

import 'dart:convert';

Rating ratingFromMap(String str) => Rating.fromMap(json.decode(str));

String ratingToMap(Rating data) => json.encode(data.toMap());

class Rating {
  String? userId;
  dynamic rating;

  Rating({
    this.userId,
    this.rating,
  });

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
    userId: json["userId"],
    rating: json["rating"],
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "rating": rating,
  };
}
