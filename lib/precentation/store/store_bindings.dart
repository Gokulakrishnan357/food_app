import 'package:get/get.dart';
import './store_controller.dart';

class StoreBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(StoreController());
    }
}