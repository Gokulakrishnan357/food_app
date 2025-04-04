class UserOrdersModel {
  final String restaurantName;
  final String restaurantAddress;
  final String locality;
  final String imageUrl;
  final DateTime actualDeliveryTime;
  final DateTime createdAt;
  final String deliveryAddress;
  final DateTime estimatedDeliveryTime;
  final DateTime orderDate;
  final int orderId;
  final String orderStatus;
  final String paymentMethod;
  final double totalAmount;
  final DateTime updatedAt;
  final int userId;
  final List<OrderItems> orderItems;

  UserOrdersModel({
    required this.restaurantName,
    required this.restaurantAddress,
    required this.locality,
    required this.imageUrl,
    required this.actualDeliveryTime,
    required this.createdAt,
    required this.deliveryAddress,
    required this.estimatedDeliveryTime,
    required this.orderDate,
    required this.orderId,
    required this.orderStatus,
    required this.paymentMethod,
    required this.totalAmount,
    required this.updatedAt,
    required this.userId,
    required this.orderItems,
  });

  // Static method to map the response to UserOrdersModel
  static UserOrdersModel fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurant'];
    final branch = restaurant['branch'] ?? {};
    return UserOrdersModel(
      restaurantName: restaurant['restaurantName'] ?? "",
      restaurantAddress: branch['address'] ?? "",
      locality: branch['locality'] ?? "",
      imageUrl: restaurant['imageUrl'] ?? "",
      actualDeliveryTime: json['actualDeliveryTime'] != null
          ? DateTime.parse(json['actualDeliveryTime'])
          : DateTime(0),
      createdAt: DateTime.parse(json['createdAt']),
      deliveryAddress: json['deliveryAddress'] ?? "",
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.parse(json['estimatedDeliveryTime'])
          : DateTime(0),
      orderDate: DateTime.parse(json['orderDate']),
      orderId: json['orderId'],
      orderStatus: json['orderStatus'] ?? "",
      paymentMethod: json['paymentMethod'] ?? "",
      totalAmount: (json['totalAmount'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt']),
      userId: json['userId'],
      orderItems: (json['orderDetails'] as List)
          .map((item) => OrderItems.fromJson(item))
          .toList(),
    );
  }
}

class OrderItems {
  final int menuId;
  final String menuName;
  final String menuDescription;
  final double price;
  final int quantity;
  final double discountAmount;
  final double gstAmount;

  OrderItems({
    required this.menuId,
    required this.menuName,
    required this.menuDescription,
    required this.price,
    required this.quantity,
    required this.discountAmount,
    required this.gstAmount,
  });

  // Static method to map order details to OrderItems
  static OrderItems fromJson(Map<String, dynamic> json) {
    final menu = json['menu'];
    return OrderItems(
      menuId: menu['menuId'],
      menuName: menu['itemName'] ?? "",
      menuDescription: "", // Assuming description is not available
      price: (menu['price'] as num).toDouble(),
      quantity: json['quantity'],
      discountAmount: 0.0, // Assuming it's not available in the response
      gstAmount: 0.0, // Assuming it's not available in the response
    );
  }
}