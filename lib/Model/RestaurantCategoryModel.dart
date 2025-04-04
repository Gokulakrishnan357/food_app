import '../../Model/MenuModel.dart';


class GetRestaurantsForMenu {
  Data? data;

  GetRestaurantsForMenu({this.data});

  factory GetRestaurantsForMenu.fromJson(Map<String, dynamic> json) {
    return GetRestaurantsForMenu(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class Data {
  List<Restaurant>? restaurants;

  Data({this.restaurants});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      restaurants: json['restaurants'] != null
          ? (json['restaurants'] as List)
          .map((e) => Restaurant.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (restaurants != null)
        'restaurants': restaurants!.map((e) => e.toJson()).toList(),
    };
  }
}

class Restaurant {
  double? averageRating;
  String? createdAt;
  bool? deliveryAvailable;
  String? imageUrl;
  bool? isActive;
  String? logourl;
  int? minimumLimitOfPerPerson;
  int? restaurantId;
  String? restaurantName;
  bool? selfPickUpAvailable;
  String? updatedAt;
  List<dynamic>? menus;
  List<Branch>? branches;
  List<Category>? categories;
  List<CuisineType>? cuisineTypes;

  Restaurant({
    this.averageRating,
    this.createdAt,
    this.deliveryAvailable,
    this.imageUrl,
    this.isActive,
    this.logourl,
    this.minimumLimitOfPerPerson,
    this.restaurantId,
    this.restaurantName,
    this.selfPickUpAvailable,
    this.updatedAt,
    this.menus,
    this.branches,
    this.categories,
    this.cuisineTypes,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      averageRating: json['averageRating'] is int
          ? (json['averageRating'] as int).toDouble()
          : json['averageRating'] as double?,
      createdAt: json['createdAt'],
      deliveryAvailable: json['deliveryAvailable'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'],
      logourl: json['logourl'],
      categories: (json['categories'] as List?)?.map((v) => Category.fromJson(v)).toList(),
      minimumLimitOfPerPerson: json['minimumLimitofPerPerson'] is double
          ? (json['minimumLimitofPerPerson'] as double).toInt()
          : json['minimumLimitofPerPerson'] as int?,
      restaurantId: json['restaurantId'] is double
          ? (json['restaurantId'] as double).toInt()
          : json['restaurantId'] as int?,
      restaurantName: json['restaurantName'],
      selfPickUpAvailable: json['selfPickUpAvailbale'],
      updatedAt: json['updatedAt'],
      menus: json['menus'] != null ? List<dynamic>.from(json['menus']) : [],
      branches: json['branches'] != null
          ? (json['branches'] as List).map((e) => Branch.fromJson(e)).toList()
          : [],
      cuisineTypes: json['cuisineTypes'] != null
          ? (json['cuisineTypes'] as List)
          .map((e) => CuisineType.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'createdAt': createdAt,
      'deliveryAvailable': deliveryAvailable,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'logourl': logourl,
      'minimumLimitofPerPerson': minimumLimitOfPerPerson,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'selfPickUpAvailbale': selfPickUpAvailable,
      'updatedAt': updatedAt,
      'categories': categories,
      if (menus != null) 'menus': menus,
      if (branches != null) 'branches': branches!.map((e) => e.toJson()).toList(),
      if (cuisineTypes != null) 'cuisineTypes': cuisineTypes!.map((e) => e.toJson()).toList(),
    };
  }
}


class Branch {
  String? address;
  double? longitude;
  String? locality;
  double? latitude;

  Branch({this.address, this.longitude, this.locality, this.latitude});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      address: json['address'],
      longitude: (json['longitude'] as num?)?.toDouble(),
      locality: json['locality'],
      latitude: (json['latitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'longitude': longitude,
      'locality': locality,
      'latitude': latitude,
    };
  }
}

class CuisineType {
  int? cuisineTypeId;
  String? name;

  CuisineType({this.cuisineTypeId, this.name});

  factory CuisineType.fromJson(Map<String, dynamic> json) {
    return CuisineType(
      cuisineTypeId: json['cuisineTypeId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cuisineTypeId': cuisineTypeId,
      'name': name,
    };
  }
}
