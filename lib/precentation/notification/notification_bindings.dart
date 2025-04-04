import 'package:get/get.dart';
import './notification_controller.dart';

class NotificationBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(NotificationController());
    }
}