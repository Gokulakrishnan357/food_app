import 'package:get/get.dart';
import './booking_details_controller.dart';

class BookingDetailsBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(BookingDetailsController());
    }
}