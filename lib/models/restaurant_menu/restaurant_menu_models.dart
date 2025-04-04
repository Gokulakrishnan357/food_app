class RestaurantMenu {
  final int? status;
  final List<RestaurantMenuData>? restaurantMenuData;
  final dynamic error;
  final dynamic message;
  const RestaurantMenu(
      {this.status, this.restaurantMenuData, this.error, this.message});
  RestaurantMenu copyWith(
      {int? status,
      List<RestaurantMenuData>? restaurantMenuData,
      dynamic error,
      dynamic message}) {
    return RestaurantMenu(
        status: status ?? this.status,
        restaurantMenuData: restaurantMenuData ?? this.restaurantMenuData,
        error: error ?? this.error,
        message: message ?? this.message);
  }

  Map<String, Object?> toJson() {
    return {
      'status': status,
      'restaurantMenuData': restaurantMenuData
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'error': error,
      'message': message
    };
  }

  static RestaurantMenu fromJson(Map<String, Object?> json) {
    return RestaurantMenu(
        status: json['status'] == null ? null : json['status'] as int,
        restaurantMenuData: json['restaurantMenuData'] == null
            ? null
            : (json['restaurantMenuData'] as List)
                .map<RestaurantMenuData>((data) =>
                    RestaurantMenuData.fromJson(data as Map<String, Object?>))
                .toList(),
        error: json['error'] as dynamic,
        message: json['message'] as dynamic);
  }

  @override
  String toString() {
    return '''RestaurantMenu(
                status:$status,
restaurantMenuData:${restaurantMenuData.toString()},
error:$error,
message:$message
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is RestaurantMenu &&
        other.runtimeType == runtimeType &&
        other.status == status &&
        other.restaurantMenuData == restaurantMenuData &&
        other.error == error &&
        other.message == message;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, status, restaurantMenuData, error, message);
  }
}

class RestaurantMenuData {
  final int? restaurantMenuId;
  final String? restaurantMenuName;
  final String? description;
  final String? restaurantMenuImage;
  final String? imageName;
  final double? price;
  final bool? isAvailable;
  final int? preferenceId;
  final int? restaurantId;
  final int? gstSlabsId;
  final bool? isVegetarian;
  final String? categoryId;
  final int? rating;
  final String? modifiedAt;
  final dynamic updatedBy;
  final String? createdAt;
  final String? menuBannerImage;
  final String? bannerImageName;
  const RestaurantMenuData(
      {this.restaurantMenuId,
      this.restaurantMenuName,
      this.description,
      this.restaurantMenuImage,
      this.imageName,
      this.price,
      this.isAvailable,
      this.preferenceId,
      this.restaurantId,
      this.gstSlabsId,
      this.isVegetarian,
      this.categoryId,
      this.rating,
      this.modifiedAt,
      this.updatedBy,
      this.createdAt,
      this.menuBannerImage,
      this.bannerImageName});
  RestaurantMenuData copyWith(
      {int? restaurantMenuId,
      String? restaurantMenuName,
      String? description,
      String? restaurantMenuImage,
      String? imageName,
      double? price,
      bool? isAvailable,
      int? preferenceId,
      int? restaurantId,
      int? gstSlabsId,
      bool? isVegetarian,
      String? categoryId,
      int? rating,
      String? modifiedAt,
      dynamic updatedBy,
      String? createdAt,
      String? menuBannerImage,
      String? bannerImageName}) {
    return RestaurantMenuData(
        restaurantMenuId: restaurantMenuId ?? this.restaurantMenuId,
        restaurantMenuName: restaurantMenuName ?? this.restaurantMenuName,
        description: description ?? this.description,
        restaurantMenuImage: restaurantMenuImage ?? this.restaurantMenuImage,
        imageName: imageName ?? this.imageName,
        price: price ?? this.price,
        isAvailable: isAvailable ?? this.isAvailable,
        preferenceId: preferenceId ?? this.preferenceId,
        restaurantId: restaurantId ?? this.restaurantId,
        gstSlabsId: gstSlabsId ?? this.gstSlabsId,
        isVegetarian: isVegetarian ?? this.isVegetarian,
        categoryId: categoryId ?? this.categoryId,
        rating: rating ?? this.rating,
        modifiedAt: modifiedAt ?? this.modifiedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        menuBannerImage: menuBannerImage ?? this.menuBannerImage,
        bannerImageName: bannerImageName ?? this.bannerImageName);
  }

  Map<String, Object?> toJson() {
    return {
      'restaurantMenuId': restaurantMenuId,
      'restaurantMenuName': restaurantMenuName,
      'description': description,
      'restaurantMenuImage': restaurantMenuImage,
      'imageName': imageName,
      'price': price,
      'isAvailable': isAvailable,
      'preferenceId': preferenceId,
      'restaurantId': restaurantId,
      'gstSlabsId': gstSlabsId,
      'isVegetarian': isVegetarian,
      'categoryId': categoryId,
      'rating': rating,
      'modifiedAt': modifiedAt,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'menuBannerImage': menuBannerImage,
      'bannerImageName': bannerImageName
    };
  }

  static RestaurantMenuData fromJson(Map<String, Object?> json) {
    return RestaurantMenuData(
        restaurantMenuId: json['restaurantMenuId'] == null
            ? null
            : json['restaurantMenuId'] as int,
        restaurantMenuName: json['restaurantMenuName'] == null
            ? null
            : json['restaurantMenuName'] as String,
        description:
            json['description'] == null ? null : json['description'] as String,
        restaurantMenuImage: json['restaurantMenuImage'] == null
            ? null
            : json['restaurantMenuImage'] as String,
        imageName:
            json['imageName'] == null ? null : json['imageName'] as String,
        price: json['price'] == null ? null : json['price'] as double,
        isAvailable:
            json['isAvailable'] == null ? null : json['isAvailable'] as bool,
        preferenceId:
            json['preferenceId'] == null ? null : json['preferenceId'] as int,
        restaurantId:
            json['restaurantId'] == null ? null : json['restaurantId'] as int,
        gstSlabsId:
            json['gstSlabsId'] == null ? null : json['gstSlabsId'] as int,
        isVegetarian:
            json['isVegetarian'] == null ? null : json['isVegetarian'] as bool,
        categoryId:
            json['categoryId'] == null ? null : json['categoryId'] as String,
        rating: json['rating'] == null ? null : json['rating'] as int,
        modifiedAt:
            json['modifiedAt'] == null ? null : json['modifiedAt'] as String,
        updatedBy: json['updatedBy'] as dynamic,
        createdAt:
            json['createdAt'] == null ? null : json['createdAt'] as String,
        menuBannerImage: json['menuBannerImage'] == null
            ? null
            : json['menuBannerImage'] as String,
        bannerImageName: json['bannerImageName'] == null
            ? null
            : json['bannerImageName'] as String);
  }

  @override
  String toString() {
    return '''RestaurantMenuData(
                restaurantMenuId:$restaurantMenuId,
restaurantMenuName:$restaurantMenuName,
description:$description,
restaurantMenuImage:$restaurantMenuImage,
imageName:$imageName,
price:$price,
isAvailable:$isAvailable,
preferenceId:$preferenceId,
restaurantId:$restaurantId,
gstSlabsId:$gstSlabsId,
isVegetarian:$isVegetarian,
categoryId:$categoryId,
rating:$rating,
modifiedAt:$modifiedAt,
updatedBy:$updatedBy,
createdAt:$createdAt,
menuBannerImage:$menuBannerImage,
bannerImageName:$bannerImageName
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is RestaurantMenuData &&
        other.runtimeType == runtimeType &&
        other.restaurantMenuId == restaurantMenuId &&
        other.restaurantMenuName == restaurantMenuName &&
        other.description == description &&
        other.restaurantMenuImage == restaurantMenuImage &&
        other.imageName == imageName &&
        other.price == price &&
        other.isAvailable == isAvailable &&
        other.preferenceId == preferenceId &&
        other.restaurantId == restaurantId &&
        other.gstSlabsId == gstSlabsId &&
        other.isVegetarian == isVegetarian &&
        other.categoryId == categoryId &&
        other.rating == rating &&
        other.modifiedAt == modifiedAt &&
        other.updatedBy == updatedBy &&
        other.createdAt == createdAt &&
        other.menuBannerImage == menuBannerImage &&
        other.bannerImageName == bannerImageName;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        restaurantMenuId,
        restaurantMenuName,
        description,
        restaurantMenuImage,
        imageName,
        price,
        isAvailable,
        preferenceId,
        restaurantId,
        gstSlabsId,
        isVegetarian,
        categoryId,
        rating,
        modifiedAt,
        updatedBy,
        createdAt,
        menuBannerImage,
        bannerImageName);
  }
}
