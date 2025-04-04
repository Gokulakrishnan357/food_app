class AllRestaurantLists {
  final List<Restaurant>? restaurants;

  AllRestaurantLists({this.restaurants});

  factory AllRestaurantLists.fromJson(Map<String, dynamic> json) {
    return AllRestaurantLists(
      restaurants: (json['restaurants'] as List?)
          ?.map((e) => Restaurant.fromJson(e))
          .toList(),
    );
  }
}

class Restaurant {
  final String? restaurantName;
  final int? restaurantId;
  final List<CuisineType>? cuisineTypes;
  final List<Category>? categories;
  final String? imageUrl;
  final String? logo;
  final int? minimumLimitofPerPerson;
  final int? averageRating;
  final bool? selfPickUpAvailable;
  final bool? deliveryAvailable;
  final List<Branch>? branches;

  Restaurant({
    this.restaurantName,
    this.restaurantId,
    this.cuisineTypes,
    this.categories,
    this.imageUrl,
    this.logo,
    this.minimumLimitofPerPerson,
    this.averageRating,
    this.selfPickUpAvailable,
    this.deliveryAvailable,
    this.branches,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantName: json['restaurantName'],
      restaurantId: json['restaurantId'],
      cuisineTypes: (json['cuisineTypes'] as List?)
          ?.map((e) => CuisineType.fromJson(e))
          .toList(),
      categories: (json['categories'] as List?)
          ?.map((e) => Category.fromJson(e))
          .toList(),
      imageUrl: json['imageUrl'],
      logo: json['logo'],
      minimumLimitofPerPerson: json['minimumLimitofPerPerson'],
      averageRating: json['averageRating'],
      selfPickUpAvailable: json['selfPickUpAvailbale'],
      deliveryAvailable: json['deliveryAvailable'],
      branches:
          (json['branches'] as List?)?.map((e) => Branch.fromJson(e)).toList(),
    );
  }
}

class CuisineType {
  final int? cuisineTypeId;
  final String? name;

  CuisineType({this.cuisineTypeId, this.name});

  factory CuisineType.fromJson(Map<String, dynamic> json) {
    return CuisineType(
      cuisineTypeId: json['cuisineTypeId'],
      name: json['name'],
    );
  }
}

class Category {
  final List<Menu>? menus;

  Category({this.menus});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      menus: (json['menus'] as List?)?.map((e) => Menu.fromJson(e)).toList(),
    );
  }
}

class Menu {
  final String? name;
  final int? menuId;
  final String? preparationTime;

  Menu({this.name, this.menuId, this.preparationTime});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      name: json['name'],
      menuId: json['menuId'],
      preparationTime: json['preparationTime'],
    );
  }
}

class Branch {
  final double? longitude;
  final double? latitude;
  final String? locality;
  final String? city;

  Branch({this.longitude, this.latitude, this.locality, this.city});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      longitude: json['longitude'].toDouble(),
      latitude: json['latitude'].toDouble(),
      locality: json['locality'],
      city: json['city'],
    );
  }
}
