

import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  String author;
  String title;
  String image;
  int price;
  String description;

  Cart({
    required this.author,
    required this.title,
    required this.image,
    required this.price,
    required this.description,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    author: json["author"],
    title: json["title"],
    image: json["image"],
    price: json["price"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "author": author,
    "title": title,
    "image": image,
    "price": price,
    "description": description,
  };
}
