class ListRestaurantById {
  int? status;
  List<RestaurantData>? restaurantData;
  Null error;
  Null message;

  ListRestaurantById(
      {this.status, this.restaurantData, this.error, this.message});

  ListRestaurantById.fromJson(Map<String, dynamic> json) {
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
  String? restaurantName;
  Null image;
  String? imageName;
  int? preferenceId;
  Null preferenceName;
  int? restaurantOutletsId;
  Null cusineType;
  Null address;
  String? averageDeliveryTime;
  int? userId;
  String? bannerImageName;
  Null restaurantDistance;
  Null distance;
  int? rating;
  Null offersName;
  int? longitude;
  int? latitude;

  RestaurantData(
      {this.restaurantName,
      this.image,
      this.imageName,
      this.preferenceId,
      this.preferenceName,
      this.restaurantOutletsId,
      this.cusineType,
      this.address,
      this.averageDeliveryTime,
      this.userId,
      this.bannerImageName,
      this.restaurantDistance,
      this.distance,
      this.rating,
      this.offersName,
      this.longitude,
      this.latitude});

  RestaurantData.fromJson(Map<String, dynamic> json) {
    restaurantName = json['restaurantName'];
    image = json['image'];
    imageName = json['imageName'];
    preferenceId = json['preferenceId'];
    preferenceName = json['preferenceName'];
    restaurantOutletsId = json['restaurantOutletsId'];
    cusineType = json['cusineType'];
    address = json['address'];
    averageDeliveryTime = json['averageDeliveryTime'];
    userId = json['userId'];
    bannerImageName = json['bannerImageName'];
    restaurantDistance = json['restaurantDistance'];
    distance = json['distance'];
    rating = json['rating'];
    offersName = json['offersName'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurantName'] = restaurantName;
    data['image'] = image;
    data['imageName'] = imageName;
    data['preferenceId'] = preferenceId;
    data['preferenceName'] = preferenceName;
    data['restaurantOutletsId'] = restaurantOutletsId;
    data['cusineType'] = cusineType;
    data['address'] = address;
    data['averageDeliveryTime'] = averageDeliveryTime;
    data['userId'] = userId;
    data['bannerImageName'] = bannerImageName;
    data['restaurantDistance'] = restaurantDistance;
    data['distance'] = distance;
    data['rating'] = rating;
    data['offersName'] = offersName;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}
