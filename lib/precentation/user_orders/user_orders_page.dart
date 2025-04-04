import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/userOrders/user_orders_model.dart';
import 'package:zeroq/precentation/cart/cart_payment_controller.dart';
import 'package:zeroq/precentation/order_status/order_status.dart';
import 'package:zeroq/precentation/order_status/order_status_controller.dart';
import 'package:zeroq/precentation/user_orders/horizontal_dotted_line.dart';
import 'package:zeroq/precentation/user_orders/order_detail.dart';
import 'package:zeroq/precentation/user_orders/user_order_controller.dart';

class UserOrders extends GetView<UserOrdersController> {
  UserOrders({super.key});

  final CartPaymentController cartPaymentController =
  Get.find<CartPaymentController>();

  final OrderStatusController orderStatusController =
  Get.put(OrderStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: AppColors.greenColor,
          ),
        ),
        title: AmdText(
          text: 'Your Orders',
          color: AppColors.greenColor,
          size: 20.0.sp,
          weight: FontWeight.w500,
        ),
        backgroundColor: AppColors.whitetextColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.0.w),
        child: Obx(() {
          if (controller.isLoading.value) {
            return loadingWidget();
          }

          if (controller.userOrders.isEmpty) {
            return const Center(child: Text('No orders available'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.userOrders.length,
            itemBuilder: (context, index) {
              var order = controller.userOrders[index];
              return orderRow(
                order.orderId,
                order.restaurantName,
                order
                    .restaurantAddress, // Use restaurantAddress instead of deliveryAddress
                formatDate(order.orderDate),
                order.orderStatus,
                order.orderItems,
                order.totalAmount,
                order.imageUrl, // Pass the imageUrl from the model
                context,
              );
            },
          );
        }),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
  }

  Widget loadingWidget() {
    return Column(
      children: List.generate(
        3,
            (index) => Padding(
          padding: EdgeInsets.only(bottom: 16.0.w),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 50.0.w,
              decoration: BoxDecoration(
                color: AppColors.whitetextColor,
                borderRadius: BorderRadius.circular(10.0.w),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget orderRow(
      int orderId,
      String restaurantName,
      String restaurantAddress,
      String orderDate,
      String orderStatus,
      List<OrderItems> orderItems,
      double totalAmount,
      String imageUrl,
      BuildContext context,
      ) {
    return InkWell(
      onTap: () {
        print("📌 Selected Order ID: $orderId"); // Debugging
        cartPaymentController.orderId.value = orderId.toString();
        orderStatusController.getOrderStatus(orderId);

        // Find the order from the list
        var order =
        controller.userOrders.firstWhere((o) => o.orderId == orderId);

        // Navigate to the OrderDetailsPage
        Get.to(() => OrderDetailsPage(order: order));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0.w),
        padding: EdgeInsets.all(12.0.w),
        decoration: BoxDecoration(
          color: AppColors.whitetextColor,
          borderRadius: BorderRadius.circular(12.0.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Use the imageUrl from the model to display the restaurant image
                imageUrl.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0.w),
                  child: Image.network(
                    imageUrl,
                    width: 40.0.w,
                    height: 40.0.w,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(
                  FontAwesomeIcons.burger,
                  color: AppColors.greenColor,
                ),
                SizedBox(width: 12.0.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AmdText(
                        text: restaurantName,
                        color: Colors.black,
                        size: 16.0.sp,
                        weight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AmdText(
                        text: restaurantAddress, // Display restaurantAddress
                        color: Colors.black,
                        size: 13.0.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: AppColors.greenColor,
                ),
              ],
            ),
            SizedBox(height: 8.0.w),
            ...orderItems.map((item) => Padding(
              padding: EdgeInsets.only(left: 20.0.w, top: 4.0.w),
              child: AmdText(
                text: "${item.quantity} x ${item.menuName}",
                color: Colors.black,
                size: 14.0.sp,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )),
            SizedBox(height: 10.0.w),
            HorizontalDottedLine(
              width: MediaQuery.of(context).size.width * 0.8,
              dotSize: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: AmdText(
                      text: "Order Placed on $orderDate",
                      size: 12.0,
                      color: Colors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FittedBox(
                    child: AmdText(
                      text: '₹ ${totalAmount.toStringAsFixed(2)}',
                      size: 12.0,
                      color: Colors.green.shade700,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AmdText(
                text: orderStatus,
                size: 12.0,
                color: _getOrderStatusColor(orderStatus),
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getOrderStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Pending":
        return Colors.blue;
      case "Canceled":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}