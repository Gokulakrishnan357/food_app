import 'package:get/get.dart';
import './orders_controller.dart';

class OrdersBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(OrdersController());
    }
}