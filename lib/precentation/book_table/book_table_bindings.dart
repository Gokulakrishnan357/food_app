import 'package:get/get.dart';
import './book_table_controller.dart';

class BookTableBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(BookTableController());
    }
}