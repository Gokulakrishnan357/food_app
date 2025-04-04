import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:zeroq/models/cart/local_cart.dart';
import 'package:zeroq/models/cart/local_cart_items.dart';
import 'package:zeroq/models/cart_models.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/precentation/cart/cart_payment_controller.dart';
import 'package:zeroq/server/app_storage.dart';
import 'package:zeroq/server/network_handler.dart';
import 'package:http/http.dart' as http;
import '../../const/app_exports.dart';
import 'package:zeroq/Model/RestaurantCategoryModel.dart' as models;
import 'package:zeroq/Model/MenuModel.dart' as menuModel;

class CartController extends GetxController {
  final CartPaymentController paymentController =
      Get.find<CartPaymentController>();

  final AuthController authController = Get.find<AuthController>();

  var cartItem = <ProductCart>[].obs;
  bool get isCartEmpty => cartItem.isEmpty;
  RxDouble totalPrices = 0.0.obs;
  RxInt quantity = 0.obs;
  RxInt subTotal = 0.obs;
  RxInt deleveryCharge = 0.obs;
  RxInt discountAmount = 0.obs;
  RxInt totalAmount = 0.obs;

  final ScrollController scrollController = ScrollController();
  var showBottomContainer = false.obs;
  var fabLocation = FloatingActionButtonLocation.centerDocked.obs;
  final AppNetworkHandler networkHandler = AppNetworkHandler();
  var getAllCart = FoodCartModel().obs;

  Rx<Cart?> cart = Rx<Cart?>(null);
  RxInt restaurantIdState = 0.obs;
  RxList<CartItems> localCartItems = <CartItems>[].obs;

  final RxList<models.Restaurant> getCategoryRestaurants =
      <models.Restaurant>[].obs;
  var getCategories = <menuModel.Category>[].obs;
  var categoryName = ''.obs;
  RxBool isLoading = false.obs;

  Timer? _cartUpdateTimer;

  @override
  Future<void> onInit() async {
    super.onInit();
    scrollController.addListener(_onScroll);

    fetchCartByUserId();

    if (Get.arguments != null && Get.arguments is String) {
      categoryName.value = Get.arguments as String;
    }

    if (categoryName.isNotEmpty) {
      fetchRestaurantsByCategory(categoryName.value);
    }
  }

  /// Debounce cart update to avoid multiple API calls
  void debounceCartUpdate(
    int cartId,
    int menuItemId,
    int revisedQuantity,
    double revisedGstAmount,
    double discountAmount, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    // If there's an existing timer, cancel it
    _cartUpdateTimer?.cancel();

    // Ensure quantity is greater than 0 before making an API call
    if (revisedQuantity > 0) {
      // Set a new timer that waits before calling API
      _cartUpdateTimer = Timer(duration, () {
        updateCartAPI(
          cartId,
          menuItemId,
          revisedQuantity,
          revisedGstAmount,
          discountAmount,
        );
      });
    }
  }

  Future<void> updateCartAPI(
    int cartId,
    int menuItemId,
    int quantity,
    double gstAmount,
    double discountAmount,
  ) async {
    try {
      if (cartId == -1 || quantity <= 0) {
        return; // Prevent unnecessary API calls
      }

      print("📡 Sending GraphQL request...");

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.updateCartDetails(
          cartId,
          menuItemId,
          quantity,
          gstAmount,
          discountAmount,
        ),
      );

      final updateCartData = response.data?["updateCartNew"];

      if (updateCartData == null || updateCartData["success"] != true) {
        String errorMessage = updateCartData?["message"] ?? "Unknown error";
        Get.snackbar("Error", errorMessage);
        return;
      }

      final cartData = updateCartData["data"]?["cart"];
      if (cartData == null) {
        throw Exception("Cart data is missing from API response.");
      }

      double apiFinalAmount =
          (cartData["finalAmount"] as num?)?.toDouble() ?? 0.0;
      double apiGstAmount =
          cartData["cartItems"]?.fold(
            0.0,
            (sum, item) => sum + (item["gstamount"] ?? 0.0),
          ) ??
          0.0;

      print("✅ API Final Amount: $apiFinalAmount");
      print("✅ API GST Amount: $apiGstAmount");

      // Ensure GetX detects the change
      cart.update((cartValue) {
        cartValue?.finalAmount = apiFinalAmount;
        cartValue?.gstAmount = apiGstAmount;
      });
      cart.refresh(); // Ensure UI rebuilds
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('❌ Error in updateCartAPI: $error');
        print(stackTrace);
      }
      Get.snackbar("Error", "Something went wrong. Please try again.");
    }
  }

  void increaseQuantity(CartItems item, int quantityToAdd) {
    int index = cart.value!.cartItems.indexOf(item);
    if (index == -1) return;

    CartItems cartItem = cart.value!.cartItems[index];
    int revisedQuantity = cartItem.quantity + quantityToAdd;
    double revisedPrice = cartItem.price * revisedQuantity;
    double revisedGstAmount =
        (cartItem.gstAmount / cartItem.quantity) * revisedQuantity;

    // ✅ Optimistic UI update
    cart.value!.cartItems[index] = CartItems(
      menuId: cartItem.menuId,
      restaurantId: cartItem.restaurantId,
      menuName: cartItem.menuName,
      menuDescription: cartItem.menuDescription,
      imageUrl: cartItem.imageUrl,
      price: cartItem.price,
      quantity: revisedQuantity,
      discountAmount: cartItem.discountAmount,
      gstAmount: revisedGstAmount,
      totalPrice: revisedPrice + revisedGstAmount,
    );

    cart.refresh(); // Immediate UI update

    // ✅ Ensure the UI updates quickly
    Future.delayed(Duration(milliseconds: 100), () {
      cart.refresh();
    });

    // 🔄 Call API instantly
    updateCartAPI(
      cart.value!.cartId ?? -1,
      item.menuId,
      revisedQuantity,
      revisedGstAmount,
      item.discountAmount,
    );
  }

  void decreaseQuantity(CartItems item, int quantityToRemove) {
    int index = cart.value!.cartItems.indexOf(item);
    if (index == -1) return;

    CartItems cartItem = cart.value!.cartItems[index];
    int revisedQuantity = cartItem.quantity - quantityToRemove;
    double revisedGstAmount =
        (cartItem.gstAmount / cartItem.quantity) * revisedQuantity;

    if (revisedQuantity <= 0) {
      // ✅ Remove the item immediately (Optimistic UI)
      cart.value!.cartItems.removeAt(index);
    } else {
      double revisedPrice = cartItem.price * revisedQuantity;

      // ✅ Update cart optimistically
      cart.value!.cartItems[index] = CartItems(
        menuId: cartItem.menuId,
        restaurantId: cartItem.restaurantId,
        menuName: cartItem.menuName,
        menuDescription: cartItem.menuDescription,
        imageUrl: cartItem.imageUrl,
        price: cartItem.price,
        quantity: revisedQuantity,
        discountAmount: cartItem.discountAmount,
        gstAmount: revisedGstAmount,
        totalPrice: revisedPrice + revisedGstAmount,
      );
    }

    cart.refresh();

    // 🔄 Call API instantly (remove debounce)
    updateCartAPI(
      cart.value!.cartId ?? -1,
      item.menuId,
      revisedQuantity,
      revisedGstAmount,
      item.discountAmount,
    );
  }

  /// Scroll event listener
  void _onScroll() {
    final double maxScroll = scrollController.position.maxScrollExtent;
    final double currentScroll = scrollController.position.pixels;

    if (currentScroll == 0) {
      showBottomContainer.value = true;
      print("User is at the top: ${showBottomContainer.value}");
    } else if (currentScroll >= maxScroll) {
      showBottomContainer.value = false;
      print("User reached the bottom: ${showBottomContainer.value}");
    } else {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        showBottomContainer.value = false;
        print("Scrolling down: ${showBottomContainer.value}");
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showBottomContainer.value = true;
        print("Scrolling up: ${showBottomContainer.value}");
      }
    }
  }

  /// start api cart
  void fetchCartByUserId() async {
    try {
      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.getCartByUserId(authController.userId.value),
      );
      if (response.data!["cartByUserId"] != null) {
        Map<String, dynamic> jsonList = response.data!['cartByUserId'];

        Cart mappedCart = Cart.fromJson(jsonList);
        cart.value = mappedCart;
      }
    } catch (error) {
      cart.value = Cart.emptyCart(-1);
      // Handle the error
      if (kDebugMode) {
        print('fetchCartById Error: $error');
      }
    }
  }

  void fetchRestaurantsByCategory(String categoryName) async {
    print("Fetching restaurants for category: $categoryName");

    isLoading.value = true;

    try {
      getCategoryRestaurants.clear();

      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.querygetRestaurantByName(categoryName),
      );

      print("GraphQL Raw Response: ${result.data}");

      if (result.data == null ||
          result.data?['data'] == null ||
          result.data?['data']?['restaurants'] == null) {
        print("No data found or incorrect structure");
        isLoading.value = false;
        return;
      }

      List<dynamic> jsonRestaurants = result.data!['data']['restaurants'];

      if (jsonRestaurants.isEmpty) {
        print("No restaurants found for this category");
        isLoading.value = false;
        return;
      }

      List<models.Restaurant> temp =
          jsonRestaurants.map((e) => models.Restaurant.fromJson(e)).toList();

      getCategoryRestaurants.assignAll(temp);
    } catch (error) {
      print("fetchRestaurantsByCategory Error: $error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrderGraphQL() async {
    try {
      try {
        final response = await GraphQLClientService.fetchData(
          query: GraphQuery.createOrder(
            cart.value!.cartId.toString(),
            "address",
            "cash",
            authController.userId.value.toString(),
          ),
        ); //TODO : change the address, payment method
        if (response.data!["createOrder"] != null &&
            response.data!["createOrder"]["success"]) {
          await AmdStorage().createCache(
            'orderid',
            response.data!["createOrder"]["data"]["order"]["orderId"]
                .toString(),
          );
          var orderId = await AmdStorage().readCache('orderid') ?? ''; // Default to an empty string if null
          paymentController.orderId.value = orderId;

          paymentController.amount.value = cart.value!.finalAmount;
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error : $e");
        }
        Get.snackbar(
          "Error",
          "Your Order got stuck somewhere",
          backgroundColor: AppColors.redColor,
          colorText: AppColors.whitetextColor,
          isDismissible: true,
        );

        return;
      }

      await handlePayment();
      paymentController.startPayment(
        paymentController.amount.value,
        paymentController.razorpayOrderId.value,
        "1234567890",
        "dev@zeroq.com",
        "mobDev",
      );
      if (kDebugMode) {
        print("My order id is shown : ${paymentController.orderId.value}");
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  Future<void> handlePayment() async {
    try {
      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.handlePayment(
          paymentController.amount.value,
          int.parse(paymentController.orderId.value),
        ),
      );
      if (response.data!["handlePayment"] != null) {
        paymentController.razorpayOrderId.value =
            response.data!["handlePayment"]["razorpayOrderId"].toString();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  Future<void> createNewCart(
    int restaurantId,
    int userId,
    CartItems itemToAdd,
    String restaurantName,
  ) async {
    try {
      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.createCart(restaurantId, userId, itemToAdd),
      );

      final cartData = response.data?["createCart"]?["data"]?["cart"];

      if (cartData != null && response.data!["createCart"]["success"]) {
        int cartId = cartData["cartId"];
        double gstAmount = (cartData["gstamount"] ?? 0.0).toDouble();
        double finalAmount =
            (cartData["finalAmount"] as num?)?.toDouble() ?? 0.0;

        print("Final Amount from API: $finalAmount");

        // Extract missing fields safely from API response
        String? imageUrl = cartData["imageUrl"];
        dynamic platformFee = cartData["platformFee"];
        dynamic fixedAmount = cartData["fixedAmount"];
        int? rating = (cartData["rating"] as num?)?.toInt();
        int? ratingsCount = (cartData["ratingsCount"] as num?)?.toInt();
        bool? selfPickUpAvailable = cartData["selfPickUpAvailable"];
        String? userName = cartData["userName"];
        int? deliveryPlatformFee =
            (cartData["deliveryPlatformFee"] as num?)?.toInt();

        int? platformFeeId = (cartData["platformFeeId"] as num?)?.toInt();

        Decimal? selfPickupPlatformFee =
            cartData["selfPickupPlatformFee"] != null
                ? Decimal.parse(cartData["selfPickupPlatformFee"].toString())
                : null;

        cart.value = Cart(
          restaurantId: restaurantId,
          cartItems: [],
          discountAmount: itemToAdd.discountAmount,
          gstAmount: gstAmount,
          restaurantName: restaurantName,
          cartId: cartId,
          createdAt: DateTime.now(),
          finalAmount: (cartData["finalAmount"] as num?)?.toDouble() ?? 0.0,
          itemTotal: (cartData["itemTotal"] as num?)?.toDouble() ?? 0.0,
          serviceCharge: 0,
          packagingCharges: 0,
          status: "active",
          updatedAt: DateTime.now(),
          userId: userId,
          feeType: "SELF_PICKUP",
          imageUrl: imageUrl,
          platformFee: platformFee,
          fixedAmount: fixedAmount,
          rating: rating,
          ratingsCount: ratingsCount,
          selfPickUpAvailable: selfPickUpAvailable,
          selfPickupPlatformFee: selfPickupPlatformFee,
          userName: userName,
          deliveryPlatformFee: deliveryPlatformFee,
          platformFeeId: platformFeeId,
        );

        cart.value!.cartItems.add(itemToAdd);
        cart.refresh();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  Future<void> deleteCart(int cartId) async {
    try {
      if (cartId == -1) return;
      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.deleteCart(cartId),
      );
      if (response.data!["deleteCart"]["success"]) {
        cart.value = Cart.emptyCart(-1);
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  /// start of local cart items.
  void addToCart(
    int menuId,
    int restaurantId,
    String menuName,
    menuDescription,
    menuImage,
    dynamic price,
    int qty,
    double discountAmount,
    double gstAmount,
    String imageUrl,
    String restaurantName,
  ) async {
    List<CartItems> localCartItemsGraph = cart.value?.cartItems ?? [];
    //When cart is not available and cartItems is empty, Create new cart
    if (cart.value?.cartId == -1 && cart.value?.cartItems.isEmpty == true) {
      CartItems itemToAdd = CartItems(
        menuId: menuId,
        restaurantId: restaurantId,
        menuName: menuName,
        menuDescription: menuDescription,
        imageUrl: imageUrl,
        price: price,
        quantity: qty,
        discountAmount: discountAmount,
        gstAmount: gstAmount,
        totalPrice: price * qty + gstAmount,
      );
      await createNewCart(
        restaurantId,
        authController.userId.value,
        itemToAdd,
        restaurantName,
      );

      return;
    }

    int existingIndex = localCartItemsGraph.indexWhere(
      (item) => item.menuId == menuId,
    );

    if (existingIndex != -1) {
      int revisedQty = localCartItemsGraph[existingIndex].quantity + qty;
      localCartItemsGraph[existingIndex] = CartItems(
        discountAmount: discountAmount,
        gstAmount: gstAmount,
        totalPrice: revisedQty * price + gstAmount,
        menuId: menuId,
        menuName: menuName,
        quantity: revisedQty,
        price: price,
        restaurantId: restaurantId,
        menuDescription: menuDescription,
        imageUrl: imageUrl,
      );
      await updateCartAPI(
        cart.value!.cartId ?? -1,
        menuId,
        revisedQty,
        gstAmount,
        discountAmount,
      );
    } else {
      bool isSameRestaurantGraph =
          localCartItemsGraph.isEmpty ||
          cart.value?.restaurantId == restaurantId;

      if (!isSameRestaurantGraph) {
        Get.dialog(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Replace Cart item",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Your Cart contains dishes from Another Restaurants, Do you want to discard the selection and add dishes.",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          //Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 45),
                                    backgroundColor: Colors.amber,
                                    // onPrimary: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('NO'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 45),
                                    backgroundColor: Colors.amber,
                                    // onPrimary: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await deleteCart(cart.value!.cartId ?? -1);

                                    CartItems itemToAdd = CartItems(
                                      menuId: menuId,
                                      restaurantId: restaurantId,
                                      menuName: menuName,
                                      menuDescription: menuDescription,
                                      imageUrl: imageUrl,
                                      price: price,
                                      quantity: qty,
                                      discountAmount: discountAmount,
                                      gstAmount: gstAmount,
                                      totalPrice: price * qty + gstAmount,
                                    );
                                    // Create new cart with new items
                                    await createNewCart(
                                      restaurantId,
                                      authController.userId.value,
                                      itemToAdd,
                                      restaurantName,
                                    );
                                    Get.back();
                                  },
                                  child: const Text('YES'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        //If the new item is from a same restaurant, add in the existing cart
        localCartItemsGraph.add(
          CartItems(
            menuId: menuId,
            restaurantId: restaurantId,
            menuName: menuName,
            menuDescription: menuDescription,
            imageUrl: imageUrl,
            price: price,
            quantity: qty,
            discountAmount: discountAmount,
            gstAmount: gstAmount,
            totalPrice: qty * price + gstAmount,
          ),
        );
        updateCartAPI(
          cart.value?.cartId ?? -1,
          menuId,
          qty,
          gstAmount,
          discountAmount,
        );
        double revisedCartPrice = 0.0;
        for (var element in localCartItemsGraph) {
          revisedCartPrice += element.totalPrice;
        }
        Cart? updatedCart = cart.value;
        updatedCart?.finalAmount = revisedCartPrice;
        cart.value = updatedCart;
        cart.refresh();
      }
    }
  }

  void calculateFinalCartPrice() {
    double revisedCartPrice = 0.0;
    for (var element in cart.value!.cartItems) {
      revisedCartPrice += element.totalPrice;
    }
    cart.value!.finalAmount = revisedCartPrice;
    cart.refresh();
  }

  void removeFromCart(CartItems item) {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.warning,
      text: 'Confirm Remove the ${item.menuName}!',
      onConfirmBtnTap: () {
        cart.value!.finalAmount -= item.totalPrice;
        cart.value!.cartItems.remove(item);
        cart.refresh();
        if (cart.value!.cartItems.isEmpty) {
          deleteCart(cart.value!.cartId ?? -1);
        }

        Get.back();
      },
      onCancelBtnTap: () {
        Get.back();
      },
      headerBackgroundColor: AppColors.greenColor,
    );
  }

  int get totalItems => cart.value?.cartItems.length ?? 0;

  // Calculate total quantity
  int get totalQuantity {
    return cart.value?.cartItems.fold(0, (sum, item) => sum! + item.quantity) ??
        0;
  }

  double get totalCartPrice =>
      cart.value?.cartItems.fold(
        0,
        (total, current) => total! + (current.price * current.quantity),
      ) ??
      0;

  createOrderId(amount, description, id, userId) async {
    http.Response response = await http.post(
      Uri.parse("https://api.razorpay.com/v1/orders"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Basic ${base64Encode(utf8.encode('rzp_test_sqlgh4Ta7LYOqu'))} ",
      },
      body: json.encode({
        "amount": amount,
        "currency": "INR",
        "receipt": "OrderId_$id",
        "notes": {"userId": "$userId", "packageId": "$id"},
      }),
    );
    if (response.statusCode == 200) {
      jsonDecode(response.body);
    }
    print("Razorpay order id = ${response.body}");
  }
}
