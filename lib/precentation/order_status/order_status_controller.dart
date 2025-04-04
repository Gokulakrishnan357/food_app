import 'dart:async';
import 'package:intl/intl.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/precentation/cart/cart_payment_controller.dart';

class OrderStatusController extends GetxController {
  final CartPaymentController cartPaymentController =
  Get.find<CartPaymentController>();
  final AuthController authController = Get.find<AuthController>();

  // Reactive variables
  var orderStage = 0.obs;
  final orderStatus = ''.obs;
  final orderDate = ''.obs;
  final isLoading = true.obs;

  Timer? _timer;
  int? _currentOrderId;

  @override
  void onInit() {
    super.onInit();

    final orderIdString = cartPaymentController.orderId.value;
    if (orderIdString.isEmpty || !_isNumeric(orderIdString)) {
      print('❌ Invalid orderId: $orderIdString');
      return;
    }

    final orderId = int.parse(orderIdString);
    if (_currentOrderId == orderId) {
      print('🔄 Skipping duplicate call for orderId: $orderId');
      return;
    }

    _currentOrderId = orderId;
    getOrderStatus(orderId);

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      getOrderStatus(orderId);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  bool _isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  Future<void> getOrderStatus(int selectedOrderId) async {
    try {
      isLoading.value = true;

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.getOrderStatus(
            authController.userId.value, selectedOrderId),
      );

      if (response.data == null ||
          response.data!['ordersStatusByUserId'] == null) {
        print('⚠️ No order data found.');
        return;
      }

      final List<dynamic>? ordersList = response.data!['ordersStatusByUserId'];
      if (ordersList == null || ordersList.isEmpty) {
        print('⚠️ No available orders.');
        return;
      }

      for (var orderData in ordersList) {
        final List<dynamic>? orders = orderData['orders'];

        if (orders == null || orders.isEmpty) {
          print('⚠️ No orders under this orderId: $selectedOrderId');
          continue;
        }

        for (var order in orders) {
          final int fetchedOrderId = order['orderId'] ?? 0;

          if (fetchedOrderId == selectedOrderId) {
            orderStatus.value = order['orderStatus'] ?? 'Unknown';

            final String orderDateRaw = order['orderDate'] ?? '';
            orderDate.value = orderDateRaw.isNotEmpty
                ? _formatOrderDate(DateTime.parse(orderDateRaw).toLocal())
                : 'Unknown';

            // Determine the order stage
            switch (orderStatus.value) {
              case "Pending":
                orderStage.value = 1;
                break;
              case "Confirmed":
                orderStage.value = 2;
                break;
              case "Preparing":
                orderStage.value = 3;
                break;
              case "ReadyForPickup":
              case "OutForDelivery":
                orderStage.value = 4;
                break;
              case "Delivered":
                orderStage.value = 5;
                print('✅ Order Delivered'); // Full tick for delivered
                break;
              case "Canceled":
                orderStage.value = 6;
                break;
              case "Failed":
                orderStage.value = 7;
                break;
              default:
                orderStage.value = 0;
                break;
            }

            print('🔹 Order ID: $fetchedOrderId');
            print('🔹 Order Status: ${orderStatus.value}');
            print('🔹 Order Date: ${orderDate.value}');
            print('🔹 Order Stage: ${orderStage.value}');
            print('--------------------------');

            break;
          }
        }
      }
    } catch (e) {
      print('❌ Error fetching orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _formatOrderDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  void updateOrderStage(int stage) {
    orderStage.value = stage;
  }
}