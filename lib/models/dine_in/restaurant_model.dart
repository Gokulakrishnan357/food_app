// To parse this JSON data, do
//
//     final dineInRestaurantsModel = dineInRestaurantsModelFromJson(jsonString);

import 'dart:convert';

DineInRestaurantsModel dineInRestaurantsModelFromJson(String str) =>
    DineInRestaurantsModel.fromJson(json.decode(str));

String dineInRestaurantsModelToJson(DineInRestaurantsModel data) =>
    json.encode(data.toJson());

class DineInRestaurantsModel {
  List<Restaurant>? restaurants;
  List<Restaurant>? restaurantCusine;

  DineInRestaurantsModel({
    this.restaurants,
    this.restaurantCusine,
  });

  factory DineInRestaurantsModel.fromJson(Map<String, dynamic> json) =>
      DineInRestaurantsModel(
        restaurants: json["restaurants"] == null
            ? []
            : List<Restaurant>.from(
                json["restaurants"]!.map((x) => Restaurant.fromJson(x))),
        restaurantCusine: json["restaurantCusine"] == null
            ? []
            : List<Restaurant>.from(
                json["restaurantCusine"]!.map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "restaurants": restaurants == null
            ? []
            : List<dynamic>.from(restaurants!.map((x) => x.toJson())),
        "restaurantCusine": restaurantCusine == null
            ? []
            : List<dynamic>.from(restaurantCusine!.map((x) => x.toJson())),
      };
}

class Restaurant {
  int? restaurantId;
  String? restaurantName;
  String? description;
  String? image;
  String? menu;
  String? restaurantMenuImage;
  String? imageName;
  int? preferenceId;
  PreferenceName? preferenceName;
  DateTime? averageDeliveryTime;
  int? userId;
  int? restaurantOutletsId;
  String? cusineType;
  Address? address;
  DateTime? modifiedAt;
  dynamic updatedBy;
  DateTime? createdAt;
  String? restaurantBannerImage;
  String? bannerImageName;
  String? restaurantDistance;
  String? distance;
  double? rating;
  double? latitude;
  double? longitude;
  String? offersName;
  int? categoryId;
  String? data;

  Restaurant({
    this.restaurantId,
    this.restaurantName,
    this.description,
    this.image,
    this.menu,
    this.imageName,
    this.restaurantMenuImage,
    this.preferenceId,
    this.preferenceName,
    this.averageDeliveryTime,
    this.userId,
    this.restaurantOutletsId,
    this.cusineType,
    this.address,
    this.modifiedAt,
    this.updatedBy,
    this.createdAt,
    this.restaurantBannerImage,
    this.bannerImageName,
    this.restaurantDistance,
    this.distance,
    this.rating,
    this.latitude,
    this.longitude,
    this.offersName,
    this.categoryId,
    this.data,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        restaurantId: json["restaurantId"],
        restaurantName: json["restaurantName"],
        description: json["description"],
        image: json["image"],
        menu: json["menu"],
        imageName: json["imageName"],
        restaurantMenuImage:json["restaurantMenuImage"],
        preferenceId: json["preferenceId"],
        preferenceName: preferenceNameValues.map[json["preferenceName"]]!,
        averageDeliveryTime: json["averageDeliveryTime"] == null
            ? null
            : DateTime.parse(json["averageDeliveryTime"]),
        userId: json["userId"],
        restaurantOutletsId: json["restaurantOutletsId"],
        cusineType: json["cusineType"],
        address: addressValues.map[json["address"]]!,
        modifiedAt: json["modifiedAt"] == null
            ? null
            : DateTime.parse(json["modifiedAt"]),
        updatedBy: json["updatedBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        restaurantBannerImage: json["restaurantBannerImage"],
        bannerImageName: json["bannerImageName"],
        restaurantDistance: json["restaurantDistance"],
        distance: json["distance"],
        rating: json["rating"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        offersName: json["offersName"],
        categoryId: json["categoryId"],
        data: json["data"],
      );






  Map<String, dynamic> toJson() => {
        "restaurantId": restaurantId,
        "restaurantName": restaurantName,
        "description": description,
        "image": image,
        "menu": menu,
        "imageName": imageName,
        "restaurantMenuImage":restaurantMenuImage,
        "preferenceId": preferenceId,
        "preferenceName": preferenceNameValues.reverse[preferenceName],
        "averageDeliveryTime": averageDeliveryTime?.toIso8601String(),
        "userId": userId,
        "restaurantOutletsId": restaurantOutletsId,
        "cusineType": cusineType,
        "address": addressValues.reverse[address],
        "modifiedAt": modifiedAt?.toIso8601String(),
        "updatedBy": updatedBy,
        "createdAt": createdAt?.toIso8601String(),
        "restaurantBannerImage": restaurantBannerImage,
        "bannerImageName": bannerImageName,
        "restaurantDistance": restaurantDistance,
        "distance": distance,
        "rating": rating,
        "latitude": latitude,
        "longitude": longitude,
        "offersName": offersName,
        "categoryId": categoryId,
        "data":data,
      };
}

enum Address { CHROMPET_CHENNAI, EAST_TAMBARAM_CHENNAI, TAMBARAM_CHENNAI }

final addressValues = EnumValues({
  "Chrompet, Chennai": Address.CHROMPET_CHENNAI,
  "East Tambaram, Chennai": Address.EAST_TAMBARAM_CHENNAI,
  "Tambaram, Chennai": Address.TAMBARAM_CHENNAI
});

enum PreferenceName { NO_NUTRITION_RULES }

final preferenceNameValues =
    EnumValues({"No Nutrition Rules": PreferenceName.NO_NUTRITION_RULES});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
