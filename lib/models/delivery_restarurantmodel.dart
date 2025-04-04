class HotelDelivery {
  Data? data;

  HotelDelivery({this.data});

  HotelDelivery.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class Data {
  List<Restaurants>? restaurants;

  Data({this.restaurants});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      restaurants = (json['restaurants'] as List)
          .map((v) => Restaurants.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurants': restaurants?.map((v) => v.toJson()).toList(),
    };
  }
}

class Restaurants {
  int? averageRating;
  String? createdAt;
  int? rating;
  int? ratingsCount;
  int? restaurantId;
  String? restaurantName;
  String? updatedAt;
  String? imageUrl;
  List<Branches>? branches;
  List<CuisineTypes>? cuisineTypes;

  Restaurants({
    this.averageRating,
    this.createdAt,
    this.rating,
    this.ratingsCount,
    this.restaurantId,
    this.restaurantName,
    this.updatedAt,
    this.imageUrl,
    this.branches,
    this.cuisineTypes,
  });

  Restaurants.fromJson(Map<String, dynamic> json) {
    averageRating = json['averageRating'] != null
        ? (json['averageRating'] as num).toInt()
        : null;

    createdAt = json['createdAt'];
    rating = json['rating'] != null ? (json['rating'] as num).toInt() : null;
    ratingsCount = json['ratingsCount'] != null
        ? (json['ratingsCount'] as num).toInt()
        : null;

    restaurantId = json['restaurantId'] != null
        ? (json['restaurantId'] as num).toInt()
        : null;

    restaurantName = json['restaurantName'];
    updatedAt = json['updatedAt'];
    imageUrl = json['imageUrl'];

    if (json['branches'] != null) {
      branches = (json['branches'] as List)
          .map((v) => Branches.fromJson(v))
          .toList();
    }

    if (json['cuisineTypes'] != null) {
      cuisineTypes = (json['cuisineTypes'] as List)
          .map((v) => CuisineTypes.fromJson(v))
          .toList();
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'createdAt': createdAt,
      'rating': rating,
      'ratingsCount': ratingsCount,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'updatedAt': updatedAt,
      'imageUrl': imageUrl,
      'branches': branches?.map((v) => v.toJson()).toList(),
      'cuisineTypes': cuisineTypes?.map((v) => v.toJson()).toList(),
    };
  }
}

class Branches {
  String? address;
  int? branchId;
  String? createdAt;
  double? latitude;
  double? longitude;
  String? phoneNumber;
  String? updatedAt;

  Branches({
    this.address,
    this.branchId,
    this.createdAt,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.updatedAt,
  });

  Branches.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    branchId = json['branchId'];
    createdAt = json['createdAt'];
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
    phoneNumber = json['phoneNumber'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'branchId': branchId,
      'createdAt': createdAt,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'updatedAt': updatedAt,
    };
  }
}

class CuisineTypes {
  int? cuisineTypeId;
  String? name;

  CuisineTypes({this.cuisineTypeId, this.name});

  CuisineTypes.fromJson(Map<String, dynamic> json) {
    cuisineTypeId = json['cuisineTypeId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'cuisineTypeId': cuisineTypeId,
      'name': name,
    };
  }
}
