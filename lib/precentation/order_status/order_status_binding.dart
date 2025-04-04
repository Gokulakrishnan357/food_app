import 'package:get/get.dart';
import 'package:zeroq/precentation/order_status/order_status_controller.dart';

class OrderStatusBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(OrderStatusController());
  }
}
