// To parse this JSON data, do
//
//     final splahScreenModel = splahScreenModelFromJson(jsonString);

import 'dart:convert';

SplahScreenModel splahScreenModelFromJson(String str) =>
    SplahScreenModel.fromJson(json.decode(str));

String splahScreenModelToJson(SplahScreenModel data) =>
    json.encode(data.toJson());

class SplahScreenModel {
  int? status;
  List<SplashScreenDatum>? splashScreenData;
  dynamic error;
  dynamic message;

  SplahScreenModel({
    this.status,
    this.splashScreenData,
    this.error,
    this.message,
  });

  SplahScreenModel.fromList(List json) {
    splashScreenData = <SplashScreenDatum>[];
    for (var element in json) {
      splashScreenData!.add(SplashScreenDatum.fromJson(element));
    }
    }

  factory SplahScreenModel.fromJson(Map<String, dynamic> json) =>
      SplahScreenModel(
        status: json["status"],
        splashScreenData: json["splashScreenData"] == null
            ? []
            : List<SplashScreenDatum>.from(json["splashScreenData"]!
                .map((x) => SplashScreenDatum.fromJson(x))),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "splashScreenData": splashScreenData == null
            ? []
            : List<dynamic>.from(splashScreenData!.map((x) => x.toJson())),
        "error": error,
        "message": message,
      };
}

class SplashScreenDatum {
  int? splashId;
  String? title;
  String? description;
  int? branchId;
  String? branchName;
  String? imageUrl;
  int? displayOrder;
  DateTime? createdAt;
  bool? isActive;
  String? link;
  int? restaurantId;
  String? restaurantName;
  String? updatedAt;

  SplashScreenDatum({
    this.splashId,
    this.title,
    this.branchId,
    this.branchName,
    this.description,
    this.imageUrl,
    this.displayOrder,
    this.createdAt,
    this.isActive,
    this.link,
    this.restaurantId,
    this.restaurantName,
    this.updatedAt,
  });

  factory SplashScreenDatum.fromJson(Map<String, dynamic> json) =>
      SplashScreenDatum(
        title: json["title"],
        splashId: json["splashId"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        displayOrder: json["displayOrder"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        isActive: json["isActive"],
        link: json["link"],
        restaurantId: json["restaurantId"],
        restaurantName: json["restaurantName"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "splashId": splashId,
        "branchId": branchId,
        "branchName": branchName,
        "description": description,
        "imageUrl": imageUrl,
        "displayOrder": displayOrder,
        "createdAt": createdAt?.toIso8601String(),
        "isActive": isActive,
        "link": link,
        "restaurantId": restaurantId,
        "restaurantName": restaurantName,
        "updatedAt": updatedAt,
      };
}
