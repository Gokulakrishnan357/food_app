

import '../../Model/MenuModel.dart';

class GetRestaurantSearch {
  int? status;
  List<RestaurantData>? restaurantData;
  String? error;
  String? message;

  GetRestaurantSearch({
    this.status,
    this.restaurantData,
    this.error,
    this.message,
  });

  GetRestaurantSearch.fromList(List<dynamic> json) {
    restaurantData = json.map((e) => RestaurantData.fromJson(e)).toList();
  }

  factory GetRestaurantSearch.fromJson(Map<String, dynamic> json) {
    return GetRestaurantSearch(
      status: json['status'] as int?,
      restaurantData: (json['restaurantData'] as List<dynamic>?)?.map((e) => RestaurantData.fromJson(e)).toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'restaurantData': restaurantData?.map((e) => e.toJson()).toList(),
    'error': error,
    'message': message,
  };
}

class CuisineTypeData {
  int? cuisineTypeId;
  String? name;

  CuisineTypeData({this.cuisineTypeId, this.name});

  factory CuisineTypeData.fromJson(Map<String, dynamic> json) {
    return CuisineTypeData(
      cuisineTypeId: json['cuisineTypeId'] as int?,
      name: json['name'] as String?,
    );
  }

  static List<CuisineTypeData>? parseCuisineTypes(List<dynamic>? response) {
    return response?.map((item) => CuisineTypeData.fromJson(item)).toList();
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
  String? city;
  String? locality;

  RestaurantBranches({
    this.address,
    this.branchId,
    this.createdAt,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.updatedAt,
    this.city,
    this.locality,
  });

  factory RestaurantBranches.fromJson(Map<String, dynamic> json) {
    return RestaurantBranches(
      address: json['address'] as String?,
      branchId: json['branchId'] as int?,
      createdAt: json['createdAt'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phoneNumber: json['phoneNumber'] as String? ?? "",
      updatedAt: json['updatedAt'] as String?,
      city: json['city'] as String?,
      locality: json['locality'] as String?,
    );
  }

  static List<RestaurantBranches>? parseBranchTypes(List<dynamic>? response) {
    return response?.map((item) => RestaurantBranches.fromJson(item)).toList();
  }
}

class RestaurantData {

  int? restaurantId;
  String? restaurantName;
  String? image;
  String? imageName;
  String? imageUrl;
  int? preferenceId;
  String? preferenceName;
  String? averageDeliveryTime;
  int? userId;
  int? restaurantOutletsId;
  List<CuisineTypeData>? cuisineType;
  List<RestaurantBranches>? branches;
  List<Category>? categories;
  String? address;
  String? modifiedAt;
  String? createdAt;
  String? restaurantBannerImage;
  String? bannerImageName;
  String? restaurantDistance;
  String? distance;
  double? rating;
  double? averageRating;
  double? latitude;
  double? longitude;

  String? offersName;
  int? categoryId;
  String? city;
  String? locality;
  double? minimumPerPerson;
  String? logoUrl;

  RestaurantData({
    this.restaurantId,
    this.averageRating,
    this.restaurantName,
    this.image,
    this.categories,
    this.imageName,
    this.imageUrl,
    this.preferenceId,
    this.preferenceName,
    this.averageDeliveryTime,
    this.userId,
    this.restaurantOutletsId,
    this.cuisineType,
    this.branches,
    this.address,
    this.modifiedAt,
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
    this.city,
    this.locality,
    this.minimumPerPerson,
    this.logoUrl,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      restaurantId: json['restaurantId'] as int?,
      restaurantName: json['restaurantName'] as String?,
      image: json['image'] as String?,
      imageName: json['imageName'] as String?,

      imageUrl: json['imageUrl'] as String? ??"",
      preferenceId: json['preferenceId'] as int?,
      preferenceName: json['preferenceName'] as String?,
      averageDeliveryTime: json['averageDeliveryTime'] as String?,
      userId: json['userId'] as int?,
      restaurantOutletsId: json['restaurantOutletsId'] as int?,
      cuisineType: CuisineTypeData.parseCuisineTypes(json['cuisineTypes']),
      branches: RestaurantBranches.parseBranchTypes(json['branches']),
      address: json['address'] as String?,
      modifiedAt: json['modifiedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      restaurantBannerImage: json['restaurantBannerImage'] as String?,
      bannerImageName: json['bannerImageName'] as String?,
      restaurantDistance: json['restaurantDistance'] as String?,
      distance: json['distance'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      averageRating: (json['averageRating'] as num?)?.toDouble()?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      offersName: json['offersName'] as String?,
      categoryId: json['categoryId'] as int?,
      city: json['branches']?.isNotEmpty == true ? json['branches'][0]['city'] as String? : null,
      locality: json['branches']?.isNotEmpty == true ? json['branches'][0]['locality'] as String? : null,
      minimumPerPerson: (json['minimumLimitofPerPerson'] as num?)?.toDouble(),
      logoUrl: json['logourl'] as String?,
      categories: (json['categories'] as List?)?.map((v) => Category.fromJson(v)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurantId'] = restaurantId;
    data['restaurantName'] = restaurantName;
    data['image'] = image;
    data['imageName'] = imageName;
    data['preferenceId'] = preferenceId;
    data['preferenceName'] = preferenceName;
    data['averageDeliveryTime'] = averageDeliveryTime;
    data['userId'] = userId;
    data['restaurantOutletsId'] = restaurantOutletsId;
    data['cusineType'] = cuisineType;
    data['address'] = address;
    data['modifiedAt'] = modifiedAt;
    data['averageRating'] = averageRating;
    data['createdAt'] = createdAt;
    data['restaurantBannerImage'] = restaurantBannerImage;
    data['bannerImageName'] = bannerImageName;
    data['restaurantDistance'] = restaurantDistance;
    data['distance'] = distance;
    data['rating'] = rating;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['offersName'] = offersName;
    data['categoryId'] = categoryId;

    // Newly added fields
    data['city'] = city;
    data['locality'] = locality;
    data['minimumPerPerson'] = minimumPerPerson;
    data['logoUrl'] = logoUrl;
    data['branches'] = branches;
    data['categories'] = categories;



    return data;
  }

}


