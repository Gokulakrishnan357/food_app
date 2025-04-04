import 'package:get/get.dart';
import 'package:zeroq/precentation/user_orders/user_order_controller.dart';

class UserOrderBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(UserOrdersController());
  }
}
