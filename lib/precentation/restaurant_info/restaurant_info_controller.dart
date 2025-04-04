import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/dine_in/restaurant_model.dart';
import 'package:zeroq/server/network_handler.dart';

class RestaurantInfoController extends GetxController {
  final AppNetworkHandler networkHandler = AppNetworkHandler();
  Rx<Restaurant?> getAllDineInRestaurantsSingle = Rx<Restaurant?>(null);
  

  final List<Map<String, dynamic>> restorentMenuData = [
    {
      "image": "assets/icons/restaurant_info_menu_dishes1.png",
    },
    {
      "image": "assets/icons/restaurant_info_menu_dishes2.png",
    },
    {
      "image": "assets/icons/restaurant_info_menu_dishes3.png",
    },
    {
      "image": "assets/icons/restaurant_info_menu_dishes3.png",
    },
  ];
  
  final List<Map<String, dynamic>> restorentFacilitiesData = [
    {
      "image": "assets/icons/restaurant_info_ac_rooms.png",
      "text": "AC rooms",
    },
    {
      "image": "assets/icons/restaurant_info_wifi.png",
      "text": "Wifi",
    },
    {
      "image": "assets/icons/restaurant_info_parking.png",
      "text": "Parking",
    },
    {
      "image": "assets/icons/restaurant_info_credit_card.png",
      "text": "Credit cards",
    },
  ];
  
  String restaurantName ="";

  // Method to update restaurant data
  void updateRestaurantDetails(Restaurant data) {
    getAllDineInRestaurantsSingle.value = data;
  }
  
  // Method to fetch restaurant data from the API
  Future<void> fetchRestaurantData() async {
  try {
    var response = await networkHandler.getRestaurantDataByName(restaurantName);
    if (response != null) {
      updateRestaurantDetails(response);
    } else {
      getAllDineInRestaurantsSingle.value = null; // Set explicitly if no data
    }
  } catch (e) {
    print("Error fetching restaurant data: $e");
    getAllDineInRestaurantsSingle.value = null;
  }
}

}
