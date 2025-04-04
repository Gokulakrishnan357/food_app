import 'package:get/get.dart';
import 'package:zeroq/precentation/settings/address/address_controller.dart';


class AddressBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddressController());
  }
}