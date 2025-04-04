class RestaurantMenu {
  Data? data;

  RestaurantMenu({this.data});

  RestaurantMenu.fromJson(Map<String, dynamic> json) {
    data = json.containsKey('data')
        ? Data.fromJson(json['data'])
        : Data.fromJson(json);
  }


  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class Data {
  List<Restaurant>? restaurants;

  Data({this.restaurants});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      restaurants = (json['restaurants'] as List)
          .map((v) => Restaurant.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {'restaurants': restaurants?.map((v) => v.toJson()).toList()};
  }
}

class Restaurant {
  int? averageRating;
  String? createdAt;
  bool? deliveryAvailable;
  String? deliveryPlatformFeeId;
  String? imagedata;
  String? imagename;
  String? imageUrl;
  bool? isActive;
  String? logo;
  String? logourl;
  int? minimumLimitofPerPerson;
  double? rating;
  int? ratingsCount;
  int? restaurantId;
  String? restaurantName;
  bool? selfPickUpAvailable;
  String? selfPickupPlatformFeeId;
  String? updatedAt;
  List<Category>? categories;

  Restaurant({
    this.averageRating,
    this.createdAt,
    this.deliveryAvailable,
    this.deliveryPlatformFeeId,
    this.imagedata,
    this.imagename,
    this.imageUrl,
    this.isActive,
    this.logo,
    this.logourl,
    this.minimumLimitofPerPerson,
    this.rating,
    this.ratingsCount,
    this.restaurantId,
    this.restaurantName,
    this.selfPickUpAvailable,
    this.selfPickupPlatformFeeId,
    this.updatedAt,
    this.categories,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    averageRating = json['averageRating'] != null
        ? (json['averageRating'] as num).toInt()
        : null;
    createdAt = json['createdAt'];
    deliveryAvailable = json['deliveryAvailable'];
    deliveryPlatformFeeId = json['deliveryPlatformFeeId'];
    imagedata = json['imagedata'];
    imagename = json['imagename'];
    imageUrl = json['imageUrl'];
    isActive = json['isActive'];
    logo = json['logo'];
    logourl = json['logourl'];
    minimumLimitofPerPerson = json['minimumLimitofPerPerson'];
    rating = json['rating']?.toDouble();
    ratingsCount = json['ratingsCount'] != null
        ? (json['ratingsCount'] as num).toInt()
        : null;
    restaurantId = json['restaurantId'];
    restaurantName = json['restaurantName'];
    selfPickUpAvailable = json['selfPickUpAvailable'];
    selfPickupPlatformFeeId = json['selfPickupPlatformFeeId'];
    updatedAt = json['updatedAt'];
    if (json['categories'] != null) {
      categories = (json['categories'] as List)
          .map((v) => Category.fromJson(v))
          .toList();
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'createdAt': createdAt,
      'deliveryAvailable': deliveryAvailable,
      'deliveryPlatformFeeId': deliveryPlatformFeeId,
      'imagedata': imagedata,
      'imagename': imagename,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'logo': logo,
      'logourl': logourl,
      'minimumLimitofPerPerson': minimumLimitofPerPerson,
      'rating': rating,
      'ratingsCount': ratingsCount,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'selfPickUpAvailable': selfPickUpAvailable,
      'selfPickupPlatformFeeId': selfPickupPlatformFeeId,
      'updatedAt': updatedAt,
      'categories': categories?.map((v) => v.toJson()).toList(),
    };
  }
}

class Category {
  int? categoryId;
  String? categoryName;
  String? imagedata;
  String? imagename;
  String? imageUrl;
  List<Menu>? menus;

  Category({
    this.categoryId,
    this.categoryName,
    this.imagedata,
    this.imagename,
    this.imageUrl,
    this.menus,
  });

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    imagedata = json['imagedata'];
    imagename = json['imagename'];
    imageUrl = json['imageUrl'];
    if (json['menus'] != null) {
      menus = (json['menus'] as List).map((v) => Menu.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imagedata': imagedata,
      'imagename': imagename,
      'imageUrl': imageUrl,
      'menus': menus?.map((v) => v.toJson()).toList(),
    };
  }
}

class Menu {
  String? availableTimeFrom;
  String? availableTimeTo;
  int? availableQuantityOfMenu;
  double? averageRating;
  String? cuisineType;
  String? description;
  String? imagedata;
  String? imagename;
  String? imageUrl;
  bool? isAvailable;
  bool? isVeg;
  int? menuId;
  String? name;
  String? preparationTime;
  double? price;
  double? rating;
  int? ratingsCount;
  int? restaurantId;

  Menu({
    this.availableTimeFrom,
    this.availableTimeTo,
    this.availableQuantityOfMenu,
    this.averageRating,
    this.cuisineType,
    this.description,
    this.imagedata,
    this.imagename,
    this.imageUrl,
    this.isAvailable,
    this.isVeg,
    this.menuId,
    this.name,
    this.preparationTime,
    this.price,
    this.rating,
    this.ratingsCount,
    this.restaurantId,
  });

  Menu.fromJson(Map<String, dynamic> json) {
    availableTimeFrom = json['availableTimeFrom'];
    availableTimeTo = json['availableTimeTo'];
    availableQuantityOfMenu = json['availableQuantityOfMenu'] != null
        ? (json['availableQuantityOfMenu'] as num).toInt()
        : null;
    averageRating = (json['averageRating'] as num?)?.toDouble();
    cuisineType = json['cuisineType'];
    description = json['description'];
    imagedata = json['imagedata'];
    imagename = json['imagename'];
    imageUrl = json['imageUrl'];
    isAvailable = json['isAvailable'];
    isVeg = json['isVeg'];
    menuId = json['menuId'];
    name = json['name'];
    preparationTime = json['preparationTime'];
    price = (json['price'] as num?)?.toDouble();
    rating = (json['rating'] as num?)?.toDouble();
    ratingsCount = json['ratingsCount'] != null
        ? (json['ratingsCount'] as num).toInt()
        : null;
    restaurantId = json['restaurantId'];
  }


  Map<String, dynamic> toJson() {
    return {
      'availableTimeFrom': availableTimeFrom,
      'availableTimeTo': availableTimeTo,
      'avalaibleQuatityofMenu': availableQuantityOfMenu,
      'averageRating': averageRating,
      'cuisineType': cuisineType,
      'description': description,
      'imagedata': imagedata,
      'imagename': imagename,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'isVeg': isVeg,
      'menuId': menuId,
      'name': name,
      'preparationTime': preparationTime,
      'price': price,
      'rating': rating,
      'ratingsCount': ratingsCount,
      'restaurantId': restaurantId,
    };
  }
}


