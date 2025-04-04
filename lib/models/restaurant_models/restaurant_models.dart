class ListRestaurants {
  int? status;
  List<RestaurantData>? restaurantData;
  Null error;
  Null message;

  ListRestaurants({this.status, this.restaurantData, this.error, this.message});

  ListRestaurants.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['restaurantData'] != null) {
      restaurantData = <RestaurantData>[];
      json['restaurantData'].forEach((v) {
        restaurantData!.add(RestaurantData.fromJson(v));
      });
    }
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (restaurantData != null) {
      data['restaurantData'] =
          restaurantData!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    data['message'] = message;
    return data;
  }

  ListRestaurants.fromMap(List jsonString) {
    restaurantData = <RestaurantData>[];
    for (var item in jsonString) {
      restaurantData!.add(RestaurantData.fromJson(item));
    }
    }
}

fromMap(List list) {
  return list.map((item) => RestaurantData.fromJson(item));
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
  // int? restaurantId;
  String? updatedAt;

  RestaurantBranches(
      {this.address,
      this.branchId,
      this.createdAt,
      this.latitude,
      this.longitude,
      this.phoneNumber,
      // this.restaurantId,
      this.updatedAt});

  factory RestaurantBranches.fromJson(Map<String, dynamic> json) {
    return RestaurantBranches(
      address: json['address'] as String,
      branchId: json['branchId'] as int,
      createdAt: json['createdAt'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      phoneNumber: json['phoneNumber'] ?? "",
      // restaurantId: json['restaurantId'] as int,
      updatedAt: json['updatedAt'] as String,
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
  String? address;
  String? modifiedAt;
  Null updatedBy;
  String? createdAt;
  String? restaurantBannerImage;
  String? bannerImageName;
  String? restaurantDistance;
  String? distance;
  double? rating;
  double? latitude;
  double? longitude;
  String? offersName;

  RestaurantData(
      {this.restaurantId,
      this.restaurantName,
      this.image,
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
      this.updatedBy,
      this.createdAt,
      this.restaurantBannerImage,
      this.bannerImageName,
      this.restaurantDistance,
      this.distance,
      this.rating,
      this.latitude,
      this.longitude,
      this.offersName});

  RestaurantData.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    restaurantName = json['restaurantName'];
    image = json['image']; //TODO : required from api
    imageName = json['imageName']; //TODO : required from api
    imageUrl = json['imageUrl'];
    preferenceId = json['preferenceId']; //TODO : required from api
    preferenceName = json['preferenceName'];
    averageDeliveryTime = json['averageDeliveryTime'];
    userId = json['userId'];
    restaurantOutletsId = json['restaurantOutletsId'];
    cuisineType =
        cuisineType = CuisineTypeData.parseCuisineTypes(json['cuisineTypes']);
    branches = RestaurantBranches.parseBranchTypes(json['branches']);
    address = json['address'];
    modifiedAt = json['modifiedAt']; //INFO : not using
    updatedBy = json['updatedBy']; //INFO : not using
    createdAt = json['createdAt'];
    restaurantBannerImage = json['restaurantBannerImage'];
    bannerImageName = json['bannerImageName'];
    restaurantDistance = json['restaurantDistance'];
    // distance = json['distance'];
    rating = json['rating'];
    // latitude = json['latitude'];
    // longitude = json['longitude'];
    offersName = json['offersName'];
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
    data['cuisineType'] = cuisineType;
    data['address'] = address;
    data['modifiedAt'] = modifiedAt;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt;
    data['restaurantBannerImage'] = restaurantBannerImage;
    data['bannerImageName'] = bannerImageName;
    data['restaurantDistance'] = restaurantDistance;
    data['distance'] = distance;
    data['rating'] = rating;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['offersName'] = offersName;
    return data;
  }
}
