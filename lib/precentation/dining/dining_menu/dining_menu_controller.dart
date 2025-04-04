import 'package:flutter/foundation.dart';
import 'package:zeroq/models/restaurant_models/restaurand_by_id_model.dart';
import 'package:zeroq/server/network_handler.dart';

import '../../../const/app_exports.dart';

class DiningMenuController extends GetxController {
  var menuIndex = 0.obs;
  var feedback = "".obs;
  final AppNetworkHandler networkHandler = AppNetworkHandler();
  var getRestaurant = GetRestaurantsById().obs;

  int get remainingChars => 500 - feedback.value.length;
  RxString restarendId = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurantById(restarendId.value);
  }

  void fetchRestaurantById(String? id) async {
    try {
      final response = await networkHandler.get(
        ApiConfig.getResaurantByIdEndpoint + id!,
      );
      print(response.statusCode);
      print(ApiConfig.getAllResaurantEndpoint);
      if (response.statusCode == 200) {
        var jsonString = response.data;
        getRestaurant.value = GetRestaurantsById.fromJson(jsonString);
      }
    } catch (error) {
      // Handle the error
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  final List<Map<String, dynamic>> foodCategory = [
    {
      "foodName": 'Paneer Tikka',
    },
    {
      "foodName": 'Samosa',
    },
    {
      "foodName": 'Pakoras',
    },
    {
      "foodName": 'Dahi Puri',
    },
    {
      "foodName": 'Tomato Shorba',
    },
    {
      "foodName": 'Tomato Shorba',
    },
    {
      "foodName": 'Kachumber Salad',
    },
    {
      "foodName": 'Sprout Salad',
    },
    {
      "foodName": 'Palak Paneer',
    },
    {
      "foodName": 'Chana Masala',
    },
    {
      "foodName": 'Vegetable Biryani',
    },
    {
      "foodName": 'Aloo Gobi',
    },
    {
      "foodName": 'Dal Makhani',
    },
    {
      "foodName": 'Mushroom Matar',
    },
    {
      "foodName": 'Naan',
    },
    {
      "foodName": 'Roti',
    },
    {
      "foodName": 'Jeera Rice',
    },
  ];
  final List<Map<String, dynamic>> restorentImages = [
    {
      "image": 'assets/images/dining/restorentimages1.png',
    },
    {
      "image": 'assets/images/dining/restorentimages2.png',
    },
    {
      "image": 'assets/images/dining/restorentimages3.png',
    },
    {
      "image": 'assets/images/dining/restorentimages2.png',
    },
  ];
  final List<Map<String, dynamic>> feedbackData = [
    {
      "title": "Courtney Henry",
      "description":
          "Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua",
      "time": "2 mins ago",
      "image": 'assets/images/dining/fb_img1.png',
      "rating": 5,
    },
    {
      "title": "Cameron Williamson",
      "description":
          "Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.",
      "time": "30 Days ago",
      "image": 'assets/images/dining/fb_img2.png',
      "rating": 4,
    },
    {
      "title": "Jane Cooper",
      "description":
          "Ullamco tempor adipisicing et voluptate duis sit esse aliqua esse ex.",
      "time": "1 months ago",
      "image": 'assets/images/dining/fb_img3.png',
      "rating": 3,
    },
  ];
  Color getStarColor(int ratingValue, int starPosition) {
    if (starPosition <= ratingValue) {
      return AppColors.yellowColor; // Filled star color
    } else {
      return AppColors.textFieldLabelColor; // Unfilled star color
    }
  }
}
