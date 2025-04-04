import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/userOrders/user_orders_model.dart'
    as userOrdersModel;
import 'package:zeroq/precentation/order_status/order_status_controller.dart';
import 'package:zeroq/precentation/payment/components/progress_container.dart';
import 'package:zeroq/precentation/user_orders/horizontal_dotted_line.dart';
import 'package:zeroq/precentation/user_orders/user_order_controller.dart';

class OrderDetailsPage extends StatelessWidget {
  final userOrdersModel.UserOrdersModel order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: AppColors.greenColor,
          ),
        ),
        title: AmdText(
          text: 'Order Details',
          color: AppColors.greenColor,
          size: 20.0.sp,
          weight: FontWeight.w500,
        ),
        backgroundColor: AppColors.whitetextColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0.w),
                child:
                    order.imageUrl.isNotEmpty
                        ? Image.network(
                          order.imageUrl,
                          width: double.infinity,
                          height: 120.0.w,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(
                          'assets/images/restaurant_illustration.png',
                          width: double.infinity,
                          height: 120.0.w,
                          fit: BoxFit.cover,
                        ),
              ),
              SizedBox(height: 8.0.w),
              Text(
                order.restaurantName,
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                order.restaurantAddress,
                style: TextStyle(fontSize: 16.0.sp, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0.w),
              Divider(),
              Text(
                'Bill Details',
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0.w),
              ...order.orderItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "${item.quantity} x ${item.menuName}",
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "₹${item.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0.w),
              HorizontalDottedLine(
                width: MediaQuery.of(context).size.width * 0.8,
                dotSize: 1.5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total: ₹ ${order.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0.w),
                    Text(
                      "Ordered at ${DateFormat('dd-MM-yyyy hh:mm a').format(order.orderDate)}",
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 20, left: 20),
                child: Text(
                  order.orderStatus,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    color: _getOrderStatusColor(order.orderStatus),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 20, left: 20),
                child: ProgressContainer(),
              ),
              SizedBox(height: 10.0.w),
            ],
          ),
        ),
      ),
    );
  }

  Color _getOrderStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Pickup":
        return Colors.blue;
      case "pending":
        return Colors.red;
      case "Pending":
        return Colors.orange; //  color for "PENDING"
      case "preparing":
        return Colors.yellow; //  color for "PREPARING"
      case "ReadyForPickup":
        return Colors.lightBlue; //  color for "READY_FOR_PICKUP"
      case "OutForDelivery":
        return Colors.purple; //  color for "OUT_FOR_DELIVERY"
      case "Confirmed":
        return Colors.teal; //  color for "CONFIRMED"
      case "Canceled":
        return Colors.grey; //  color for "CANCELED"
      case "Failed":
        return Colors.black; //  color for "FAILED"
      default:
        return Colors.orange; // Default color for unknown status
    }
  }
}
