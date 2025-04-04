import 'dart:convert';

GetRestaurantMenusById getRestaurantMenuByIdFromJson(String str) =>
    GetRestaurantMenusById.fromJson(json.decode(str));

String getRestaurantMenuByIdToJson(GetRestaurantMenusById data) =>
    json.encode(data.toJson());

class GetRestaurantMenusById {
  RestaurantMenuData data;

  GetRestaurantMenusById({
    required this.data,
  });

  factory GetRestaurantMenusById.fromJson(Map<String, dynamic> json) =>
      GetRestaurantMenusById(
        data: RestaurantMenuData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class RestaurantMenuData {
  List<Restaurant> restaurants;

  RestaurantMenuData({
    required this.restaurants,
  });

  factory RestaurantMenuData.fromJson(Map<String, dynamic> json) =>
      RestaurantMenuData(
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "restaurants":
    List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}


class Restaurant {
  int averageRating;
  DateTime createdAt;
  bool deliveryAvailable;
  dynamic deliveryPlatformFeeId;
  dynamic imagedata;
  dynamic imagename;
  String imageUrl;
  bool isActive;
  dynamic logo;
  String logourl;
  int minimumLimitofPerPerson;
  dynamic rating;
  dynamic ratingsCount;
  int restaurantId;
  String restaurantName;
  bool selfPickUpAvailable;
  dynamic selfPickupPlatformFeeId;
  DateTime updatedAt;
  List<Category> categories;

  Restaurant({
    required this.averageRating,
    required this.createdAt,
    required this.deliveryAvailable,
    required this.deliveryPlatformFeeId,
    required this.imagedata,
    required this.imagename,
    required this.imageUrl,
    required this.isActive,
    required this.logo,
    required this.logourl,
    required this.minimumLimitofPerPerson,
    required this.rating,
    required this.ratingsCount,
    required this.restaurantId,
    required this.restaurantName,
    required this.selfPickUpAvailable,
    required this.selfPickupPlatformFeeId,
    required this.updatedAt,
    required this.categories,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    averageRating: json["averageRating"],
    createdAt: DateTime.parse(json["createdAt"]),
    deliveryAvailable: json["deliveryAvailable"],
    deliveryPlatformFeeId: json["deliveryPlatformFeeId"],
    imagedata: json["imagedata"],
    imagename: json["imagename"],
    imageUrl: json["imageUrl"],
    isActive: json["isActive"],
    logo: json["logo"],
    logourl: json["logourl"],
    minimumLimitofPerPerson: json["minimumLimitofPerPerson"],
    rating: json["rating"],
    ratingsCount: json["ratingsCount"],
    restaurantId: json["restaurantId"],
    restaurantName: json["restaurantName"],
    selfPickUpAvailable: json["selfPickUpAvailable"],
    selfPickupPlatformFeeId: json["selfPickupPlatformFeeId"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    categories: List<Category>.from(
        json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "averageRating": averageRating,
    "createdAt": createdAt.toIso8601String(),
    "deliveryAvailable": deliveryAvailable,
    "deliveryPlatformFeeId": deliveryPlatformFeeId,
    "imagedata": imagedata,
    "imagename": imagename,
    "imageUrl": imageUrl,
    "isActive": isActive,
    "logo": logo,
    "logourl": logourl,
    "minimumLimitofPerPerson": minimumLimitofPerPerson,
    "rating": rating,
    "ratingsCount": ratingsCount,
    "restaurantId": restaurantId,
    "restaurantName": restaurantName,
    "selfPickUpAvailable": selfPickUpAvailable,
    "selfPickupPlatformFeeId": selfPickupPlatformFeeId,
    "updatedAt": updatedAt.toIso8601String(),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  int categoryId;
  String categoryName;
  dynamic imagedata;
  dynamic imagename;
  String imageUrl;
  List<Menu> menus;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.imagedata,
    required this.imagename,
    required this.imageUrl,
    required this.menus,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    imagedata: json["imagedata"],
    imagename: json["imagename"],
    imageUrl: json["imageUrl"],
    menus: List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "categoryName": categoryName,
    "imagedata": imagedata,
    "imagename": imagename,
    "imageUrl": imageUrl,
    "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
  };
}

class Menu {
  dynamic availableTimeFrom;
  dynamic availableTimeTo;
  dynamic availableQuantityofMenu;
  double averageRating;
  String cuisineType;
  String description;
  dynamic imagedata;
  dynamic imagename;
  String imageUrl;
  bool isAvailable;
  bool isVeg;
  int menuId;
  String name;
  dynamic preparationTime;
  double price;
  dynamic rating;
  dynamic ratingsCount;
  int restaurantId;

  Menu({
    required this.availableTimeFrom,
    required this.availableTimeTo,
    required this.availableQuantityofMenu,
    required this.averageRating,
    required this.cuisineType,
    required this.description,
    required this.imagedata,
    required this.imagename,
    required this.imageUrl,
    required this.isAvailable,
    required this.isVeg,
    required this.menuId,
    required this.name,
    required this.preparationTime,
    required this.price,
    required this.rating,
    required this.ratingsCount,
    required this.restaurantId,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    availableTimeFrom: json["availableTimeFrom"],
    availableTimeTo: json["availableTimeTo"],
    availableQuantityofMenu: json["availableQuantityofMenu"],
    averageRating: json["averageRating"].toDouble(),
    cuisineType: json["cuisineType"],
    description: json["description"],
    imagedata: json["imagedata"],
    imagename: json["imagename"],
    imageUrl: json["imageUrl"],
    isAvailable: json["isAvailable"],
    isVeg: json["isVeg"],
    menuId: json["menuId"],
    name: json["name"],
    preparationTime: json["preparationTime"],
    price: json["price"].toDouble(),
    rating: json["rating"],
    ratingsCount: json["ratingsCount"],
    restaurantId: json["restaurantId"],
  );

  Map<String, dynamic> toJson() => {
    "availableTimeFrom": availableTimeFrom,
    "availableTimeTo": availableTimeTo,
    "availableQuantityofMenu": availableQuantityofMenu,
    "averageRating": averageRating,
    "cuisineType": cuisineType,
    "description": description,
    "imagedata": imagedata,
    "imagename": imagename,
    "imageUrl": imageUrl,
    "isAvailable": isAvailable,
    "isVeg": isVeg,
    "menuId": menuId,
    "name": name,
    "preparationTime": preparationTime,
    "price": price,
    "rating": rating,
    "ratingsCount": ratingsCount,
    "restaurantId": restaurantId,
  };
}
