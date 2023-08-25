// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

import 'package:amazon_clone/models/rating.dart';

List<Product> productFromMap(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromMap(x)));

String productToMap(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Product {
  String? id;
  String? name;
  String? description;
  List<String>? images;
  double? quantity;
  double? price;
  String? category;
  int? v;
  List<Rating>? ratings;

  Product({
    this.id,
    this.name,
    this.description,
    this.images,
    this.quantity,
    this.price,
    this.category,
    this.v,
    this.ratings,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    quantity: json["quantity"]?.toDouble(),
    price: json["price"]?.toDouble(),
    category: json["category"],
    v: json["__v"],
    ratings: json["ratings"] == null ? [] : List<Rating>.from(json["ratings"]!.map((x) => Rating.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "name": name,
    "description": description,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "quantity": quantity,
    "price": price,
    "category": category,
    "__v": v,
    "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x.toMap())),
  };
}
