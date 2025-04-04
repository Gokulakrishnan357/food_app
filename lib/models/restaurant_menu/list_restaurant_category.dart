class ListRestaurantCategory {
  int? status;
  List<CategoryData>? categoryData;
  Null error;
  Null message;

  ListRestaurantCategory(
      {this.status, this.categoryData, this.error, this.message});

  ListRestaurantCategory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['categoryData'] != null) {
      categoryData = <CategoryData>[];
      json['categoryData'].forEach((v) {
        categoryData!.add(CategoryData.fromJson(v));
      });
    }
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (categoryData != null) {
      data['categoryData'] = categoryData!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    data['message'] = message;
    return data;
  }
}

class CategoryData {
  int? categoryId;
  String? categoryName;
  String? description;
  String? categoryImage;
  String? imageName;
  String? modifiedAt;
  String? updatedBy;
  String? createdAt;

  CategoryData(
      {this.categoryId,
      this.categoryName,
      this.description,
      this.categoryImage,
      this.imageName,
      this.modifiedAt,
      this.updatedBy,
      this.createdAt});

  CategoryData.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    description = json['description'];
    categoryImage = json['categoryImage'];
    imageName = json['imageName'];
    modifiedAt = json['modifiedAt'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['description'] = description;
    data['categoryImage'] = categoryImage;
    data['imageName'] = imageName;
    data['modifiedAt'] = modifiedAt;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt;
    return data;
  }
}
