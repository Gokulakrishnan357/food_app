// To parse this JSON data, do
//
//     final foodCartModel = foodCartModelFromJson(jsonString);

import 'dart:convert';

FoodCartModel foodCartModelFromJson(String str) =>
    FoodCartModel.fromJson(json.decode(str));

String foodCartModelToJson(FoodCartModel data) => json.encode(data.toJson());

class FoodCartModel {
  int? status;
  List<FoodCartDatum>? foodCartData;
  dynamic error;
  dynamic message;

  FoodCartModel({
    this.status,
    this.foodCartData,
    this.error,
    this.message,
  });

  factory FoodCartModel.fromJson(Map<String, dynamic> json) => FoodCartModel(
        status: json["status"],
        foodCartData: json["foodCartData"] == null
            ? []
            : List<FoodCartDatum>.from(
                json["foodCartData"]!.map((x) => FoodCartDatum.fromJson(x))),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "foodCartData": foodCartData == null
            ? []
            : List<dynamic>.from(foodCartData!.map((x) => x.toJson())),
        "error": error,
        "message": message,
      };
}

class FoodCartDatum {
  int? quantity;
  double? totalPrice;
  String? restaurantMenuName;
  String? restaurantMenuImage;

  FoodCartDatum({
    this.quantity,
    this.totalPrice,
    this.restaurantMenuName,
    this.restaurantMenuImage,
  });

  factory FoodCartDatum.fromJson(Map<String, dynamic> json) => FoodCartDatum(
        quantity: json["quantity"],
        totalPrice: json["totalPrice"],
        restaurantMenuName: json["restaurantMenuName"],
        restaurantMenuImage: json["restaurantMenuImage"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "totalPrice": totalPrice,
        "restaurantMenuName": restaurantMenuName,
        "restaurantMenuImage": restaurantMenuImage,
      };
}
