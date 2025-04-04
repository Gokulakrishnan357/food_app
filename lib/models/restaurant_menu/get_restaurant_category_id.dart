class ListCategoryById {
  int? status;
  List<CategoryData>? categoryData;
  Null error;
  Null message;

  ListCategoryById({this.status, this.categoryData, this.error, this.message});

  ListCategoryById.fromJson(Map<String, dynamic> json) {
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
  String? categoryName;
  String? description;
  String? categoryImage;
  String? imageName;

  CategoryData(
      {this.categoryName,
      this.description,
      this.categoryImage,
      this.imageName});

  CategoryData.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    description = json['description'];
    categoryImage = json['categoryImage'];
    imageName = json['imageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['description'] = description;
    data['categoryImage'] = categoryImage;
    data['imageName'] = imageName;
    return data;
  }
}
