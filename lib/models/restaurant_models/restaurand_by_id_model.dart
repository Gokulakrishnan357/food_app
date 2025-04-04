import 'dart:convert';

import '../../Model/MenuModel.dart';

GetRestaurantsById getRestaurantsByIdFromJson(String str) =>
    GetRestaurantsById.fromJson(json.decode(str));

String getRestaurantsByIdToJson(GetRestaurantsById data) =>
    json.encode(data.toJson());

class GetRestaurantsById {
  int? status;
  List<RestaurantDatum>? restaurantData;
  dynamic error;
  dynamic message;

  GetRestaurantsById({
    this.status,
    this.restaurantData,
    this.error,
    this.message,
  });

  factory GetRestaurantsById.fromList(List json) {
    List<RestaurantDatum> restaurantData = [];
    try {
      if (json[0] != null) {
        restaurantData.add(RestaurantDatum.fromJson(json[0]));
      }
      return GetRestaurantsById(status: 200, restaurantData: restaurantData);
    } catch (error) {
      print(error);
      return GetRestaurantsById(status: 200, restaurantData: restaurantData);
    }
  }

  factory GetRestaurantsById.fromJson(Map<String, dynamic> json) =>
      GetRestaurantsById(
        status: json["status"],
        restaurantData: json["restaurantData"] == null
            ? []
            : List<RestaurantDatum>.from(json["restaurantData"]!
            .map((x) => RestaurantDatum.fromJson(x))),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "restaurantData": restaurantData == null
        ? []
        : List<dynamic>.from(restaurantData!.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class CuisineTypeData {
  int? cuisineTypeId;
  String? name;

  CuisineTypeData({this.cuisineTypeId, this.name});

  factory CuisineTypeData.fromJson(Map<String, dynamic> json) {
    return CuisineTypeData(
      cuisineTypeId: json['cuisineTypeId'] as int,
      name: json['name'] as String,
    );
  }

  static List<CuisineTypeData>? parseCuisineTypes(List<dynamic>? response) {
    if (response == null) return null;

    return response
        .map((item) => CuisineTypeData.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class RestaurantBranches {
  String? address;
  int? branchId;
  String? createdAt;
  double? latitude;
  double? longitude;
  String? phoneNumber;
  String? updatedAt;

  RestaurantBranches(
      {this.address,
        this.branchId,
        this.createdAt,
        this.latitude,
        this.longitude,
        this.phoneNumber,
        this.updatedAt});

  factory RestaurantBranches.fromJson(Map<String, dynamic> json) {
    return RestaurantBranches(
      address: json['address'] as String?,
      branchId: json['branchId'] as int?,
      createdAt: json['createdAt'] as String?,
      latitude: (json['latitude'] != null) ? json['latitude'].toDouble() : null,
      longitude:
      (json['longitude'] != null) ? json['longitude'].toDouble() : null,
      phoneNumber: json['phoneNumber'] as String?, // Handle null safely
      updatedAt: json['updatedAt'] as String?,
    );
  }

  static List<RestaurantBranches>? parseBranchTypes(List<dynamic>? response) {
    if (response == null) return null;

    return response
        .map(
            (item) => RestaurantBranches.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class RestaurantDatum {
  String? restaurantName;
  String? image;
  String? imageUrl;
  String? imageName;
  int? preferenceId;
  dynamic preferenceName;
  int? restaurantOutletsId;
  List<CuisineTypeData>? cuisineType;
  List<RestaurantBranches>? branches;
  String? address;
  DateTime? averageDeliveryTime;
  int? userId;
  String? bannerImageName;
  String? restaurantDistance;
  String? distance;
  double? rating;
  String? offersName;
  double? longitude;
  double? latitude;
  bool? isVeg;
  int? restaurantId;
  List<Category>? categories;
  String? modifiedAt;
  String? createdAt;
  String? restaurantBannerImage;
  int? minimumLimitofPerPerson;
  int? categoryId;
  String? city;
  String? locality;
  double? minimumPerPerson;
  String? logoUrl;
  int? menuPreparationTime; // Added new field

  RestaurantDatum(
      {this.restaurantName,
        this.image,
        this.imageUrl,
        this.imageName,
        this.preferenceId,
        this.preferenceName,
        this.restaurantOutletsId,
        this.cuisineType,
        this.branches,
        this.address,
        this.averageDeliveryTime,
        this.userId,
        this.bannerImageName,
        this.restaurantDistance,
        this.distance,
        this.rating,
        this.offersName,
        this.longitude,
        this.latitude,
        this.minimumLimitofPerPerson,
        this.categories,
        this.isVeg,
        this.menuPreparationTime}); // Added new field});

  factory RestaurantDatum.fromJson(Map<String, dynamic> json) =>
      RestaurantDatum(
          restaurantName: json["restaurantName"],
          image: json["image"],
          imageUrl: json["imageUrl"],
          imageName: json["imageName"],
          preferenceId: json["preferenceId"],
          preferenceName: json["preferenceName"],
          restaurantOutletsId: json["restaurantOutletsId"],
          cuisineType: CuisineTypeData.parseCuisineTypes(json['cuisineTypes']),
          branches: RestaurantBranches.parseBranchTypes(json['branches']),
          categories: (json['categories'] as List?)
              ?.map((v) => Category.fromJson(v))
              .toList(),
          address: json["address"],
          averageDeliveryTime: json["averageDeliveryTime"] == null
              ? null
              : DateTime.parse(json["averageDeliveryTime"]),
          userId: json["userId"],
          bannerImageName: json["bannerImageName"],
          restaurantDistance: json["restaurantDistance"],
          distance: json["distance"],
          rating: json["rating"]?.toDouble(),
          offersName: json["offersName"],
          minimumLimitofPerPerson: json["minimumLimitofPerPerson"],
          longitude: json["longitude"]?.toDouble(),
          latitude: json["latitude"]?.toDouble(),
          isVeg: json["isVeg"],
          menuPreparationTime: json["menuPreparationTime"] // Added new field
      );

  Map<String, dynamic> toJson() => {
    "restaurantName": restaurantName,
    "image": image,
    "imageName": imageName,
    "preferenceId": preferenceId,
    "preferenceName": preferenceName,
    "restaurantOutletsId": restaurantOutletsId,
    "cusineType": cuisineType,
    "address": address,
    "averageDeliveryTime": averageDeliveryTime?.toIso8601String(),
    "userId": userId,
    "bannerImageName": bannerImageName,
    "restaurantDistance": restaurantDistance,
    "distance": distance,
    "rating": rating,
    "offersName": offersName,
    "longitude": longitude,
    "latitude": latitude,
    "categories": categories,
    'minimumLimitofPerPerson': minimumLimitofPerPerson,
    "menuPreparationTime": menuPreparationTime,
  };
}