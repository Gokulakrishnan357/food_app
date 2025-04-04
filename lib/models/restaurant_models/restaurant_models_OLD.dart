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
      data['restaurantData'] = restaurantData!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    data['message'] = message;
    return data;
  }
}

class RestaurantData {
  int? restaurantId;
  String? restaurantName;
  String? image;
  String? imageName;
  int? preferenceId;
  String? preferenceName;
  String? averageDeliveryTime;
  int? userId;
  int? restaurantOutletsId;
  String? cusineType;
  String? address;
  String? modifiedAt;
  Null updatedBy;
  String? createdAt;
  String? restaurantBannerImage;
  String? bannerImageName;

  RestaurantData(
      {this.restaurantId,
      this.restaurantName,
      this.image,
      this.imageName,
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
      this.bannerImageName});

  RestaurantData.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    restaurantName = json['restaurantName'];
    image = json['image'];
    imageName = json['imageName'];
    preferenceId = json['preferenceId'];
    preferenceName = json['preferenceName'];
    averageDeliveryTime = json['averageDeliveryTime'];
    userId = json['userId'];
    restaurantOutletsId = json['restaurantOutletsId'];
    cusineType = json['cusineType'];
    address = json['address'];
    modifiedAt = json['modifiedAt'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    restaurantBannerImage = json['restaurantBannerImage'];
    bannerImageName = json['bannerImageName'];
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
    data['cusineType'] = cusineType;
    data['address'] = address;
    data['modifiedAt'] = modifiedAt;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt;
    data['restaurantBannerImage'] = restaurantBannerImage;
    data['bannerImageName'] = bannerImageName;
    return data;
  }
}
