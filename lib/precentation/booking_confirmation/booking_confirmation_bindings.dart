import 'package:get/get.dart';
import './booking_confirmation_controller.dart';

class BookingConfirmationBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(BookingConfirmationController());
    }
}