import 'package:get/get.dart';
import 'package:zeroq/precentation/cart/cart_controller.dart';
import 'package:zeroq/precentation/pick_up/components/hotel_menu/hotel_menu_controller.dart';
import 'package:zeroq/precentation/pick_up/pick_up_controller.dart';
import './dashboard_controller.dart';

class DashboardBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<PickUpController>(() => PickUpController());
    Get.lazyPut<HotelMenuController>(() => HotelMenuController());
    Get.lazyPut<CartController>(() => CartController());
  }
}
