class CartItems {
  int menuId;
  final String menuName;
  final String menuDescription;
  final int restaurantId;
  final dynamic price;
  final int quantity;
  final double discountAmount;
  final double gstAmount;
  final double totalPrice;
  final String imageUrl;
  int? cartItemId;
  int? menuItemId;
  String? menuItemName;
  int? unitPrice;
  String? preparationTime;
  String? preparationTimeFormatted;

  CartItems({
    required this.discountAmount,
    required this.gstAmount,
    required this.totalPrice,
    required this.menuId,
    required this.menuName,
    required this.quantity,
    required this.price,
    required this.restaurantId,
    required this.menuDescription,
    required this.imageUrl,
    this.cartItemId,
    this.menuItemId,
    this.menuItemName,
    this.unitPrice,
    this.preparationTime,
    this.preparationTimeFormatted,
  });

  // Factory constructor for CartItems from JSON
  factory CartItems.fromJson(Map<String, dynamic> json, int restaurantId) {
    return CartItems(
      menuId: json['menuItemId'],
      menuName: json['menuItemName'],
      menuDescription: "", // TODO: json['menuDescription'],
      restaurantId: restaurantId,
      price: json['unitPrice'],
      quantity: json['quantity'],
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      gstAmount: (json['gstAmount'] ?? 0.0).toDouble(),

      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? "",
      cartItemId: json['cartItemId'],
      menuItemId: json['menuItemId'],
      menuItemName: json['menuItemName'],
      unitPrice: json['unitPrice'],
      preparationTime: json['preparationTime'],
      preparationTimeFormatted: json['preparationTimeFormatted'],
    );
  }
}