// To parse this JSON data, do
//
//     final dineInRestaurantsSingleModel = dineInRestaurantsSingleModelFromJson(jsonString);

import 'dart:convert';

DineInRestaurantsSingleModel dineInRestaurantsSingleModelFromJson(String str) =>
    DineInRestaurantsSingleModel.fromJson(json.decode(str));

String dineInRestaurantsSingleModelToJson(DineInRestaurantsSingleModel data) =>
    json.encode(data.toJson());

class DineInRestaurantsSingleModel {
  int? status;
  DineInData? dineInData;
  dynamic error;
  dynamic message;

  DineInRestaurantsSingleModel({
    this.status,
    this.dineInData,
    this.error,
    this.message,
  });

  factory DineInRestaurantsSingleModel.fromJson(Map<String, dynamic> json) =>
      DineInRestaurantsSingleModel(
        status: json["status"],
        dineInData: json["dineInData"] == null
            ? null
            : DineInData.fromJson(json["dineInData"]),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "dineInData": dineInData?.toJson(),
        "error": error,
        "message": message,
      };
}

class DineInData {
  Restaurant? restaurant;
  List<Menu>? menu;
  List<Facility>? facility;

  DineInData({
    this.restaurant,
    this.menu,
    this.facility,
  });

  factory DineInData.fromJson(Map<String, dynamic> json) => DineInData(
        restaurant: json["restaurant"] == null
            ? null
            : Restaurant.fromJson(json["restaurant"]),
        menu: json["menu"] == null
            ? []
            : List<Menu>.from(json["menu"]!.map((x) => Menu.fromJson(x))),
        facility: json["facility"] == null
            ? []
            : List<Facility>.from(
                json["facility"]!.map((x) => Facility.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "restaurant": restaurant?.toJson(),
        "menu": menu == null
            ? []
            : List<dynamic>.from(menu!.map((x) => x.toJson())),
        "facility": facility == null
            ? []
            : List<dynamic>.from(facility!.map((x) => x.toJson())),
      };
}

class Facility {
  String? facilityImage;
  String? facilityDescription;
  String? imageName;

  Facility({
    this.facilityImage,
    this.facilityDescription,
    this.imageName,
  });

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        facilityImage: json["facilityImage"],
        facilityDescription: json["facilityDescription"],
        imageName: json["imageName"],
      );

  Map<String, dynamic> toJson() => {
        "facilityImage": facilityImage,
        "facilityDescription": facilityDescription,
        "imageName": imageName,
      };
}

class Menu {
  String? description;
  String? imageName;
  String? restaurantMenuImage;

  Menu({
    this.description,
    this.imageName,
    this.restaurantMenuImage,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        description: json["description"],
        imageName: json["imageName"],
        restaurantMenuImage: json["restaurantMenuImage"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "imageName": imageName,
        "restaurantMenuImage": restaurantMenuImage,
      };
}

class Restaurant {
  String? restaurantName;
  String? description;
  String? imageName;
  String? image;

  Restaurant({
    this.restaurantName,
    this.description,
    this.imageName,
    this.image,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        restaurantName: json["restaurantName"],
        description: json["description"],
        imageName: json["imageName"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "restaurantName": restaurantName,
        "description": description,
        "imageName": imageName,
        "image": image,
      };
}
