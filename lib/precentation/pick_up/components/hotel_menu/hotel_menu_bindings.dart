import 'package:get/get.dart';
import './hotel_menu_controller.dart';

class HotelMenuBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(HotelMenuController());
    }
}