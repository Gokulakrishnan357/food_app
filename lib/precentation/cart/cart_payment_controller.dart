import 'dart:convert';

// import 'package:razorpay_web/razorpay_web.dart';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/server/app_storage.dart';
import 'package:zeroq/server/network_handler.dart';
import 'package:intl/intl.dart';

class CartPaymentController extends GetxController {
  late Razorpay _razorpay;
  final AppNetworkHandler networkHandler = AppNetworkHandler();
  RxBool isLoading = false.obs;
  RxString orderId = "".obs;
  RxString razorPayId = "".obs;
  RxString userId = "".obs;
  RxDouble amount = 0.0.obs;
  RxString currency = "INR".obs;
  RxString receipt = "".obs;
  RxString paymentId = "".obs;
  RxString signatureId = "".obs;
  RxString paymentStatus = "".obs;
  RxInt restorantId = 0.obs;

  RxString razorpayOrderId = "".obs;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    final storage = GetStorage();
    String? phoneNumber = storage.read('phoneNumber');
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    paymentId.value = response.paymentId!;

    if (response.paymentId != "") {
      paymentStatus.value = "success";
      String payOrderId = response.data!["razorpay_order_id"];

      await completePayment(response.paymentId ?? "", payOrderId);
      if (paymentStatus.value == "success") {
        isLoading.value = false;
        Get.offAllNamed(AmdRoutesClass.paymentSucessPage);
      } else {
        Get.snackbar(
          "Failed",
          "Your Order got stuck somewhere",
          backgroundColor: AppColors.redColor,
          colorText: AppColors.whitetextColor,
        );
      }
    }
  }




  void _handlePaymentError(PaymentFailureResponse response) async {
    Get.snackbar(
      "Failed",
      "Please to Process payment.",
      backgroundColor: AppColors.redColor,
      colorText: AppColors.whitetextColor,
    );
    print('Payment failed: ${response.code}');
    print('Payment failed message: ${response.message}');
    paymentStatus.value = "failure";

    // createPayments();
    // Get.offNamed(AmdRoutesClass.dashboardPage);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Payment using external wallet: ${response.walletName}');
    Get.toNamed(AmdRoutesClass.dashboardPage);
  }

  void startPayment(
    double amount,
    String razorpayOrderId,
    String phoneNumber,
    email,
    name,
    // orderId,
  ) {
    isLoading.value = true;
    var options = {
      'key': 'rzp_test_sqlgh4Ta7LYOqu',
      'amount': amount * 200, // Amount in paisa (e.g., Rs. 100 = 10000 paisa)
      'order_id': razorpayOrderId,
      'name': 'Click N Pick',
      'description': 'Payment for Foods',
      'timeout': 150,
      "prefill": {"name": name, "email": email, "contact": phoneNumber},
      'external': {
        'wallets': ['paytm'],
      },
    };
    print("ZeroQ : RazorPay start : Options : $options");
    _razorpay.open(options);
  }

  Future<void> completePayment(String razorPayId, String orderId) async {
    try {
      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.completePayment(razorPayId, orderId),
      );

      if (response.data!["completePayment"] != null &&
          response.data!["completePayment"]["status"] == "Success") {
        paymentStatus.value = "success";
        if (kDebugMode) {
          print("Payment Successfull");
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  // void createPayments() async {
  //   isLoading.value = true;
  //   final cartData = json.encode({
  //     "orderId": orderId.value,
  //     "razorPayId": razorPayId.value,
  //     "userId": userId.value,
  //     "amount": amount.value,
  //     "currency": currency.value,
  //     "receipt": receipt.value,
  //     "paymentId": paymentId.value,
  //     "signatureId": signatureId.value,
  //     "paymentStatus": paymentStatus.value,
  //   });
  //   if (kDebugMode) {
  //     print(ApiConstants.createpaymentUrl());
  //     print(cartData);
  //   }
  //   try {
  //     final response = await networkHandler.post(
  //       ApiConstants.createpaymentUrl(),
  //       cartData,
  //     );
  //     if (kDebugMode) {
  //       print('Payment Successful');
  //       print('Response: ${response.statusCode}');
  //       print('Response: ${response.data}');
  //     }
  //     if (response.statusCode == 201) {
  //       ScaffoldMessenger.of(Get.context!).showSnackBar(
  //         paymentStatus.value == "sucess"
  //             ? const SnackBar(
  //                 width: 400.0,
  //                 elevation: 0.0,
  //                 behavior: SnackBarBehavior.floating,
  //                 backgroundColor: Colors.transparent,
  //                 content: AppSnackBar(
  //                   description: "Payment Sucessfully.......",
  //                   contentType: "sucess",
  //                 ),
  //               )
  //             : const SnackBar(
  //                 width: 400.0,
  //                 elevation: 0.0,
  //                 behavior: SnackBarBehavior.floating,
  //                 backgroundColor: Colors.transparent,
  //                 content: AppSnackBar(
  //                   description: "Payment Failed...",
  //                   contentType: "error",
  //                 ),
  //               ),
  //       );
  //       // cartController.fetchCarts();
  //     } else {
  //       // ScaffoldMessenger.of(Get.context!).showSnackBar(
  //       //   SnackBar(
  //       //     width: 400.0,
  //       //     elevation: 0.0,
  //       //     behavior: SnackBarBehavior.floating,
  //       //     backgroundColor: Colors.transparent,
  //       //     content: AppSnackBar(
  //       //       description: "cart Update Failed... ${response.data['message']}",
  //       //       contentType: "warning",
  //       //     ),
  //       //   ),
  //       // );
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error: $e');
  //     }
  //   }
  // }

  /// payment responce api
  void paymentResponseApi(
    String orderId,
    razorPayOrderId,
    razorPayPaymentId,
    signature,
    status,
  ) async {
    isLoading.value = true;
    var userId = await AmdStorage().readCache('userId');
    final paymentResponseData = json.encode({
      "UserId": userId,
      "OrderStatusId": 3,
      "OrderId": orderId,
      "RazorPayOrderId": 0,
      "RazorPayPaymentId": razorPayPaymentId,
      "Signature": 0,
      "Status": status,
    });
    try {
      final response = await networkHandler.post(
        ApiConfig.paymentResponseEndpoint,
        paymentResponseData,
      );
      print("The payment responce is amdtechno : ${response.data}");
      print("The payment responce is amdtechno post : $paymentResponseData");
      print("The payment responce is amdtechno : ${response.statusCode}");
      if (response.statusCode == 200) {
        print("The payment responce is amdtechno : ${response.data}");
      }
    } catch (error) {}
  }

  void orderCreation() async {
    var userId = await AmdStorage().readCache('userId');
    DateTime now = DateTime.now();
    String convertedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(now);
    print(convertedDateTime);
    final orderCreationData = json.encode({
      "userId": userId,
      "orderStatusId": 3,
      "deliveryStatus": false,
      "orderTime": convertedDateTime,
      "orderPaymentId": 1,
      "restaurantId": restorantId.value,
    });
    print("The order post data is $orderCreationData");
    try {
      final response = await networkHandler.post(
        ApiConfig.orderCreationEndpoint,
        orderCreationData,
      );
      print("The order post responce code is ${response.statusCode}");
      print("The order post responce code is ${response.data}");
      if (response.statusCode == 200) {
        print("The order post responce data is ${response.data}");
      }
    } catch (error) {}
  }
}
