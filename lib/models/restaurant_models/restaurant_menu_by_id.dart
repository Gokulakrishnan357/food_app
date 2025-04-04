// To parse this JSON data, do
//
//     final getRestaurantMenuById = getRestaurantMenuByIdFromJson(jsonString);

import 'dart:convert';
import 'dart:core';

GetRestaurantMenuById getRestaurantMenuByIdFromJson(String str) =>
    GetRestaurantMenuById.fromJson(json.decode(str));

String getRestaurantMenuByIdToJson(GetRestaurantMenuById data) =>
    json.encode(data.toJson());

class GetRestaurantMenuById {
  int? status;
  List<RestaurantMenuDatum>? restaurantMenuData;
  dynamic error;
  dynamic message;

  GetRestaurantMenuById({
    this.status,
    this.restaurantMenuData,
    this.error,
    this.message,
  });

  factory GetRestaurantMenuById.fromMap(List jsonString) {
    try {
      if (jsonString.isNotEmpty && jsonString[0] != null) {
        List<RestaurantMenuDatum> restaurantMenuData = [];

        // Ensure "menus" key exists and is a list
        List? allMenuItems = jsonString[0]["menus"] as List?;

        if (allMenuItems != null) {
          for (var menuItem in allMenuItems) {
            restaurantMenuData.add(RestaurantMenuDatum.fromJson(menuItem));
          }
        }

        return GetRestaurantMenuById(
            status: 200, restaurantMenuData: restaurantMenuData);
      } else {
        return GetRestaurantMenuById(
          status: 400, // Error status code
          restaurantMenuData: [],
        );
      }
    } catch (error) {
      print('Error restaurant_menu_by_id.dart:fromMap: $error');
      return GetRestaurantMenuById(
        status: 400,
        restaurantMenuData: [],
        error: error.toString(), // Capture error message
      );
    }
  }

  factory GetRestaurantMenuById.fromJson(Map<String, dynamic> json) =>
      GetRestaurantMenuById(
        status: json["status"],
        restaurantMenuData: json["restaurantMenuData"] == null
            ? []
            : List<RestaurantMenuDatum>.from(json["restaurantMenuData"]!
            .map((x) => RestaurantMenuDatum.fromJson(x))),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "restaurantMenuData": restaurantMenuData == null
        ? []
        : List<dynamic>.from(restaurantMenuData!.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}


class MenuImage {
  String? imageType;
  String? imageUrl;
  bool? isActive;
  int? menuImageId;
  String? uploadDate;

  MenuImage(
      {this.imageType,
        this.imageUrl,
        this.isActive,
        this.menuImageId,
        this.uploadDate});

  factory MenuImage.fromJson(Map<String, dynamic> json) {
    return MenuImage(
      imageType: json['imageType'],
      imageUrl: json['imageUrl'] as String,
      isActive: json['isActive'] as bool,
      menuImageId: json['menuImageId'] as int,
      uploadDate: json['uploadDate'] as String,
    );
  }

  static List<MenuImage>? parseMenuImage(List<dynamic>? response) {
    if (response == null) return null;

    return response
        .map((item) => MenuImage.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class Category {
  int? categoryId;
  String? categoryName;

  Category({this.categoryId, this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'],
    );
  }
}

class RestaurantMenuDatum {
  int? restaurantMenuId;
  String? restaurantMenuName;
  String? description;
  List<MenuImage>? restaurantMenuImage;
  String? imageName;
  String? imageUrl;
  double? price;
  bool? isAvailable;
  int? preferenceId;
  int? restaurantId;
  int? gstSlabsId;
  bool? isVegetarian;
  Category? category;
  double? rating;
  DateTime? modifiedAt;
  dynamic updatedBy;
  DateTime? createdAt;
  String? menuBannerImage;
  String? bannerImageName;

  RestaurantMenuDatum({
    this.restaurantMenuId,
    this.restaurantMenuName,
    this.description,
    this.imageUrl,
    this.restaurantMenuImage,
    this.imageName,
    this.price,
    this.isAvailable,
    this.preferenceId,
    this.restaurantId,
    this.gstSlabsId,
    this.isVegetarian,
    this.category,
    this.rating,
    this.modifiedAt,
    this.updatedBy,
    this.createdAt,
    this.menuBannerImage,
    this.bannerImageName,
  });

  factory RestaurantMenuDatum.fromJson(Map<String, dynamic> json) =>
      RestaurantMenuDatum(
        restaurantMenuId: json["menuId"],
        restaurantId: json["restaurantId"],
        restaurantMenuName: json["name"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        restaurantMenuImage: MenuImage.parseMenuImage(json["images"] as List),
        imageName: json["imageName"],
        price: json["price"]?.toDouble(),
        isAvailable: json["isAvailable"],
        isVegetarian: json["isVegetarian"],
        category: Category.fromJson(json["category"]),
        rating: json["averageRating"],
        //FIX : not being used fields
        modifiedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        updatedBy: json["updatedBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        menuBannerImage: json["menuBannerImage"],
        bannerImageName: json["bannerImageName"],
      );

  Map<String, dynamic> toJson() => {
    "restaurantMenuId": restaurantMenuId,
    "restaurantMenuName": restaurantMenuName,
    "description": description,
    "restaurantMenuImage": restaurantMenuImage,
    "imageName": imageName,
    "price": price,
    "isAvailable": isAvailable,
    "preferenceId": preferenceId,
    "restaurantId": restaurantId,
    "gstSlabsId": gstSlabsId,
    "isVegetarian": isVegetarian,
    "category": category,
    "rating": rating,
    "modifiedAt": modifiedAt?.toIso8601String(),
    "updatedBy": updatedBy,
    "createdAt": createdAt?.toIso8601String(),
    "menuBannerImage": menuBannerImage,
    "bannerImageName": bannerImageName,
  };
}