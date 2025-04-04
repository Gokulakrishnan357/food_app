import 'package:get/get.dart';

class BookingConfirmationController extends GetxController {
  var isChecked = false.obs;
  final List<Map<String, dynamic>> cancelMenuData = [
    {
      "text": "Did not get confirmation",
    },
    {
      "text": "Went somewhere else",
    },
    {
      "text": "Plan got cancelled",
    },
    {
      "text": "Got better offer",
    },
    {
      "text": "Others",
    },
  ];
}
