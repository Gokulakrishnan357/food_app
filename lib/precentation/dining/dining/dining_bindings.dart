import 'package:get/get.dart';
import './dining_controller.dart';

class DiningBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(DiningController());
    }
}