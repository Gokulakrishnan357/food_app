// ignore: file_names
import 'package:get/get.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/precentation/cart/cart_controller.dart';
import 'package:zeroq/precentation/cart/cart_payment_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    // Initialize global dependencies
    Get.put(AuthController(), permanent: true);
    Get.put(CartPaymentController(), permanent: true);
    Get.put(CartController(), permanent: true);
  }
}
