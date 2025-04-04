import 'package:get/get.dart';
import './dining_menu_controller.dart';

class DiningMenuBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(DiningMenuController());
    }
}