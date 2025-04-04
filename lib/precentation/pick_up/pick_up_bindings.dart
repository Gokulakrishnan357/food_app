import 'package:get/get.dart';
import './pick_up_controller.dart';

class PickUpBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(PickUpController());
    }
}