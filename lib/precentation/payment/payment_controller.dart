import 'package:get/get.dart';

class PaymentController extends GetxController {
  RxBool isSuccessDetailsVisible = false.obs;

  final List<Map<String, dynamic>> paymentCategory = [
    {
      "name": 'Cash',
      "image": "assets/icons/payment_cash.svg",
    },
    {
      "name": 'Visa',
      "image": "assets/icons/payment_visa.svg",
    },
    {
      "name": 'Master Card',
      "image": "assets/icons/payment_master_card.svg",
    },
    {
      "name": 'PayPal',
      "image": "assets/icons/payment_paypal.svg",
    },
  ];

  void toggleSuccessDetails() =>
      isSuccessDetailsVisible.value = !isSuccessDetailsVisible.value;
}
