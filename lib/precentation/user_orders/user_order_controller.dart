import 'package:flutter/foundation.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/userOrders/user_orders_model.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';

class UserOrdersController extends GetxController {
  RxList<UserOrdersModel> userOrders = RxList<UserOrdersModel>();
  RxBool isLoading = true.obs;

  final authController = Get.put(AuthController());

  @override
  void onInit() async {
    super.onInit();
    await fetchOrderHistory();
  }

  Future<void> fetchOrderHistory() async {
    try {
      isLoading.value = true;
      final response = await GraphQLClientService.fetchData(
          query: GraphQuery.userAllOrderDetails(authController.userId.value));

      if (response.data != null && response.data!["userDetails"] != null) {
        Map<String, dynamic> jsonList = response.data!['userDetails'];

        // Assuming the response contains a list of orders, map each one
        userOrders.value = (jsonList['orders'] as List)
            .map((order) => UserOrdersModel.fromJson(order))
            .toList();

        // Handle your userOrders here
      } else {
        print("No user details found in the response.");
      }
    } catch (error) {
      if (kDebugMode) {
        print('fetchOrderHistory Error: $error');
      }
    } finally {
      isLoading.value = false; // Set loading to false after fetching
    }
  }
}
