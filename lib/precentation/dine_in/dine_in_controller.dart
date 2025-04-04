import 'package:flutter/foundation.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/dine_in/restaurant_model.dart';
import 'package:zeroq/models/dine_in/restaurant_single_model.dart';
import 'package:zeroq/server/network_handler.dart';

class DineInController extends GetxController {
  late TextEditingController dineInSearch;
  var getAllDineInRestaurants = DineInRestaurantsModel().obs;
  var getAllDineInRestaurantsSingle = DineInRestaurantsSingleModel().obs;
  final AppNetworkHandler networkHandler = AppNetworkHandler();
  RxInt restaurantId = 0.obs;
  RxString restaurantName = "".obs;
  @override
  void onInit() {
    super.onInit();
    dineInSearch = TextEditingController();
    fetchDineInRestaurants();
  }

  void fetchDineInRestaurants() async {
    try {
      final response = await networkHandler.get(
        ApiConfig.getAllDineinResaurantSearchEndpoint + restaurantName.value,
      );
      if (kDebugMode) {
        print(response.statusCode);
        print(
          ApiConfig.getAllDineinResaurantSearchEndpoint + restaurantName.value,
        );
      }

      if (response.statusCode == 200) {
        var jsonString = response.data;
        getAllDineInRestaurants.value =
            DineInRestaurantsModel.fromJson(jsonString);
      }
    } catch (error) {
      // Handle the error
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  void fetchDineInRestaurantsById() async {
    try {
      final response = await networkHandler.get(
        "${ApiConfig.getAllDineinResaurantByIdEndpoint}${restaurantId.value}",
      );
      if (kDebugMode) {
        print(response.statusCode);
        print(
          "${ApiConfig.getAllDineinResaurantByIdEndpoint}${restaurantId.value}",
        );
      }

      if (response.statusCode == 200) {
        var jsonString = response.data;
        getAllDineInRestaurantsSingle.value =
            DineInRestaurantsSingleModel.fromJson(jsonString);

        if (kDebugMode) {
          print('${response.data}');
        }
      }
    } catch (error) {
      // Handle the error
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }
}
