// ignore: file_names
import 'package:flutter/material.dart';
import 'package:zeroq/Model/RestaurantModel.dart';
import 'package:zeroq/Service/GraphQLService.dart';

class RestaurantProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  bool _isLoading = false;

  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;

  Future<void> fetchRestaurants() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<Restaurant> fetchedRestaurants =
          await GraphQLService().fetchRestaurants();

      _restaurants = fetchedRestaurants;
    } catch (e) {
      print("Error fetching restaurants: $e");
      _restaurants = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
