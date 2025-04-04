import 'package:get/get.dart';
import 'restaurant_info_controller.dart';

class RestaurantInfoBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(RestaurantInfoController());
    }
}