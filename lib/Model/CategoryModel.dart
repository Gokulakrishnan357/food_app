class AllCategory {
  Data? data;

  AllCategory({this.data});

  AllCategory.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class Data {
  List<Categorys>? categorys;

  Data({this.categorys});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categorys'] != null) {
      categorys = (json['categorys'] as List)
          .map((v) => Categorys.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (categorys != null)
        'categorys': categorys!.map((v) => v.toJson()).toList(),
    };
  }
}

class Categorys {
  int? categoryId;
  String? categoryName;
  String? imageUrl;

  Categorys({this.categoryId, this.categoryName, this.imageUrl});

  Categorys.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'] as int?;
    categoryName = json['categoryName'] as String?;
    imageUrl = json['imageUrl'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      if (categoryId != null) 'categoryId': categoryId,
      if (categoryName != null) 'categoryName': categoryName,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
