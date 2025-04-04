// To parse this JSON data, do
//
//     final orderCreationByIdModel = orderCreationByIdModelFromJson(jsonString);

import 'dart:convert';

List<OrderCreationByIdModel> orderCreationByIdModelFromJson(String str) =>
    List<OrderCreationByIdModel>.from(
        json.decode(str).map((x) => OrderCreationByIdModel.fromJson(x)));

String orderCreationByIdModelToJson(List<OrderCreationByIdModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderCreationByIdModel {
  int? userId;
  int? orderStatusId;
  String? restaurantName;
  dynamic longitude;
  dynamic latitude;
  bool? deliveryStatus;
  DateTime? orderTime;
  String? paymentOrderId;
  int? restaurantId;

  OrderCreationByIdModel({
    this.userId,
    this.orderStatusId,
    this.restaurantName,
    this.longitude,
    this.latitude,
    this.deliveryStatus,
    this.orderTime,
    this.paymentOrderId,
    this.restaurantId,
  });

  factory OrderCreationByIdModel.fromJson(Map<String, dynamic> json) =>
      OrderCreationByIdModel(
        userId: json["userId"],
        orderStatusId: json["orderStatusId"],
        restaurantName: json["restaurantName"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        deliveryStatus: json["deliveryStatus"],
        orderTime: json["orderTime"] == null
            ? null
            : DateTime.parse(json["orderTime"]),
        paymentOrderId: json["paymentOrderId"],
        restaurantId: json["restaurantId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "orderStatusId": orderStatusId,
        "restaurantName": restaurantName,
        "longitude": longitude,
        "latitude": latitude,
        "deliveryStatus": deliveryStatus,
        "orderTime": orderTime?.toIso8601String(),
        "paymentOrderId": paymentOrderId,
        "restaurantId": restaurantId,
      };
}
