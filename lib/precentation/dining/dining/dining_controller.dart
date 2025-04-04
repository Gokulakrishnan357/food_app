import 'package:flutter/foundation.dart';

import '../../../const/app_exports.dart';
import '../../../models/restaurant_models/restaurant_models.dart';
import '../../../server/network_handler.dart';

class DiningController extends GetxController {
  final AppNetworkHandler networkHandler = AppNetworkHandler();
  var getAllStore = ListRestaurants().obs;
  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  void fetchRestaurants() async {
    try {
      final response = await networkHandler.get(
        ApiConfig.getAllResaurantEndpoint,
      );
      // print(response.statusCode);
      // print(ApiConfig.getAllResaurantEndpoint);
      if (response.statusCode == 200) {
        var jsonString = response.data;
        getAllStore.value = ListRestaurants.fromJson(jsonString);
      }
    } catch (error) {
      // Handle the error
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  final List<Map<String, dynamic>> filterCategory = [
    {
      "title": 'Filters',
    },
    {
      "title": 'Book Table',
    },
    {
      "title": 'Delight',
    },
    {
      "title": 'Nearest',
    },
    {
      "title": 'pure veg',
    },
    {
      "title": 'Open now',
    },
    {
      "title": 'Rating',
    },
  ];
  final List<Map<String, dynamic>> restorentName = [
    {
      "name": 'Saravana bhavan',
      "rating": "5.0",
      "address": "Chengalpetu NT 0870, Chennai",
      "price": "₹200,7",
      "image": "assets/images/dining/saravanabhavan.png"
    },
    {
      "name": 'Saravana bhavan',
      "rating": "5.0",
      "address": "Chengalpetu NT 0870, Chennai",
      "price": "₹200,7",
      "image": "assets/images/dining/saravanabhavan.png"
    },
  ];
}
