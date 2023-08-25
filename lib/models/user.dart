// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? address;
  String? type;
  int? v;
  List<dynamic>? cart;
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.address,
    this.type,
    this.v,
    this.cart,
    this.token,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    address: json["address"],
    type: json["type"],
    v: json["__v"],
    cart: json["cart"] == null ? [] : List<dynamic>.from(json["cart"]!.map((x) => x)),
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "name": name,
    "email": email,
    "password": password,
    "address": address,
    "type": type,
    "__v": v,
    "cart": cart == null ? [] : List<dynamic>.from(cart!.map((x) => x)),
    "token": token,
  };

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    int? v,
    List<dynamic>? cart,
    String? token,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        address: address ?? this.address,
        type: type ?? this.type,
        v: v ?? this.v,
        cart: cart ?? this.cart,
        token: token ?? this.token,
      );
}
