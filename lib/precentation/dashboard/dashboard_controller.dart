import 'package:flutter/foundation.dart';
import 'package:zeroq/models/restaurant_models/restaurant_search_model.dart';
import 'package:zeroq/precentation/pick_up/pick_up_controller.dart';
import 'package:zeroq/server/network_handler.dart';

import '../../const/app_exports.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  RxBool favouriteValue = false.obs;
  final GlobalKey<ScaffoldState> dashboardKey = GlobalKey<ScaffoldState>();
  final pickUpController = Get.find<PickUpController>();
  var isToggled = false.obs;
  final AppNetworkHandler networkHandler = AppNetworkHandler();

  var getRestaurantSearch = GetRestaurantSearch().obs;
  var restaurantCuisine = "".obs;

  @override
  void onInit() {
    super.onInit();
    // INFO : Uncomment below
    pickUpController.getCurrentLocation();
    pickUpController.getgoogleaddress();
  }

  void changePage(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.toNamed(
          AmdRoutesClass.dashboardPage,
        );
        break;
      case 1:
        Get.toNamed(
          AmdRoutesClass.pickUpPage,
        );
        break;
      case 2:
        Get.toNamed(
          AmdRoutesClass.cartPage,
        );
        break;
      case 3:
        Get.toNamed(
          AmdRoutesClass.settingsPage,
        );
        break;
      // Add more cases for additional screens
      default:
        break;
    }
  }

  void fetchSearchRestaurantsFromGraph(dynamic restaurantCuisine) async {
    try {
      final result = await GraphQLClientService.fetchData(
          query: GraphQuery.queryRestaurantByName(restaurantCuisine.value));
      List jsonString = result.data!['restaurants'] as List;
      var temp = GetRestaurantSearch.fromList(jsonString);
      getRestaurantSearch.value = temp;
    } catch (error) {
      print("fetchSearchRestaurantsFromGraph Error: $error");
    }
  }

  void fetchSearchRestaurants() async {
    try {
      final response = await networkHandler.get(
        ApiConfig.getResaurantSearchEndpoint + restaurantCuisine.value,
      );

      if (response.statusCode == 200) {
        print(response.data);
        var jsonString = response.data;
        getRestaurantSearch.value = GetRestaurantSearch.fromJson(jsonString);
      }
    } catch (error) {
      // Handle the error
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }
}
