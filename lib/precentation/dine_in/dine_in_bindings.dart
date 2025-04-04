import 'package:get/get.dart';
import './dine_in_controller.dart';

class DineInBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DineInController>(() => DineInController());
  }
}
