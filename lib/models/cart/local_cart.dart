import 'package:zeroq/models/cart/local_cart_items.dart';
import 'package:decimal/decimal.dart';

class Cart {
  int? cartId;
  final DateTime createdAt;
  final double discountAmount;
  double finalAmount;
  double gstAmount;
  final double itemTotal;
  final double packagingCharges;
  late final int restaurantId;
  final String restaurantName;
  final double serviceCharge;
  final String status;
  final DateTime updatedAt;
  final int userId;
  final List<CartItems> cartItems;
  final String? feeType;
  final String? imageUrl;
  final dynamic platformFee;
  final dynamic fixedAmount;
  final int? rating;
  final int? ratingsCount;
  final bool? selfPickUpAvailable;
  Decimal? selfPickupPlatformFee;
  final String? userName;
  int? deliveryPlatformFee;
  int? platformFeeId; // ✅ Add this field

  Cart({
    required this.cartId,
    required this.createdAt,
    required this.discountAmount,
    required this.finalAmount,
    required this.gstAmount,
    required this.itemTotal,
    required this.packagingCharges,
    required this.restaurantId,
    required this.restaurantName,
    required this.serviceCharge,
    required this.status,
    required this.updatedAt,
    required this.userId,
    required this.cartItems,
    required this.feeType,
    required this.imageUrl,
    required this.platformFee,
    required this.fixedAmount,
    required this.rating,
    required this.ratingsCount,
    required this.selfPickUpAvailable,
    required this.selfPickupPlatformFee,
    required this.userName,
    required this.deliveryPlatformFee,
    // ✅ Add this here
    required this.platformFeeId, // ✅ Add it here
  });

  factory Cart.emptyCart(int cartId) {
    return Cart(
      cartId: cartId,
      createdAt: DateTime.now(),
      discountAmount: 0,
      finalAmount: 0,
      gstAmount: 0,
      itemTotal: 0,
      packagingCharges: 0,
      restaurantId: 0,
      restaurantName: '',
      serviceCharge: 0,
      status: '',
      updatedAt: DateTime.now(),
      userId: 0,
      cartItems: [],
      imageUrl: null,
      platformFee: null,
      fixedAmount: null,
      rating: null,
      ratingsCount: null,
      selfPickUpAvailable: null,
      selfPickupPlatformFee: null,
      userName: null,
      deliveryPlatformFee: null,
      feeType: '', // Added missing field
      platformFeeId: null, // Added missing field
    );
  }

  // Factory constructor for Cart from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cartId'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      finalAmount: (json['finalAmount'] ?? 0).toDouble(),
      gstAmount: (json['gstamount'] ?? 0).toDouble(), // ✅ Correct field name
      itemTotal: (json['itemTotal'] ?? 0).toDouble(),
      packagingCharges: (json['packagingCharges'] ?? 0).toDouble(),
      restaurantId: int.tryParse(json['restaurantId'].toString()) ??
          0, // Ensures integer parsing
      restaurantName: json['restaurantName'] ?? '',
      serviceCharge: (json['serviceCharge'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      userId: json['userId'] ?? 0,
      cartItems: (json['cartItems'] as List<dynamic>?)
          ?.map(
            (item) => CartItems.fromJson(
          item,
          int.tryParse(json['restaurantId'].toString()) ?? 0,
        ),
      )
          .toList() ??
          [],
      imageUrl: json['imageUrl'],
      platformFee: json['platformFee'],
      fixedAmount: json['fixedAmount'],
      rating: json['rating'],
      ratingsCount: json['ratingsCount'],
      selfPickUpAvailable: json['selfPickUpAvailable'],
      selfPickupPlatformFee: json['selfPickupPlatformFee'],
      userName: json['userName'],
      deliveryPlatformFee: json['deliveryPlatformFee'],
      feeType: json['feeType'] ?? '', // Added missing field
      platformFeeId: json['platformFeeId'], // Added missing field
    );
  }
}
