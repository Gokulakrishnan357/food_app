import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/restaurant_models/restaurant_menu_by_id.dart';
import 'package:zeroq/server/network_handler.dart';
import '../../../../Model/MenuModel.dart';
import 'package:zeroq/models/restaurant_models/restaurant_search_model.dart';
import 'package:zeroq/Model/MenuModel.dart' as menuModel;
import 'package:zeroq/Model/RestaurantCategoryModel.dart' as models;
import '../../../../models/restaurant_models/restaurand_by_id_model.dart';
import '../../pick_up_controller.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

class HotelMenuController extends GetxController {
  final AppNetworkHandler networkHandler = AppNetworkHandler();
  var getRestaurantById = GetRestaurantsById().obs;
  var getRestaurantMenuById = GetRestaurantMenuById().obs;

  var restaurantId = "0".obs;
  RxString userSearchQueryForMenuItems = "".obs;

  Rx<RestaurantMenu> getRestaurantMenusById = RestaurantMenu().obs;

  final RxList<models.Restaurant> getCategoryRestaurants =
      <models.Restaurant>[].obs;
  final RxBool isLoading = false.obs;
  var categoryName = ''.obs;

  var getCategories = <menuModel.Category>[].obs;

  var restaurantCuisine = "".obs;

  var getRestaurantSearch = GetRestaurantSearch().obs;

  var searchRestaurants = GetRestaurantSearch().obs;

  var getRestaurants = GetRestaurantSearch().obs;

  var selectedCategory = "".obs;

  String selectedMode = 'Self Pick-up';

  bool get deliveryAvailable => selectedMode == 'Delivery';

  @override
  Future<void> onInit() async {
    super.onInit();


    // Get user location and fetch delivery restaurants
    determineUserLocation().then((position) {
      fetchRestaurantsdeliveryByCategory(categoryName.value, position.latitude, position.longitude);
    });


    // Ensure Get.arguments is not null and is a String
    if (Get.arguments != null && Get.arguments is String) {
      categoryName.value = Get.arguments as String;
      print("Received Category: ${categoryName.value}"); // Debug log
    }

    // Only fetch restaurants if categoryName is not empty
    if (categoryName.value.isNotEmpty &&
        categoryName.value != "Default Category") {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      fetchRestaurantsByCategory(categoryName.value,position.latitude, position.longitude);
    } else {
      print("Invalid Category, skipping fetch!");
    }

    fetchRestaurantsByName('');
    fetchonlySearchRestaurants();
    fetchAllRestaurantCategories();
    fetchSearchRestaurantsFromGraph();
    fetchRestaurantsMenuById();
    fetchRestaurantsByIdFromGraph();
    fetchRestaurantsMenuByIdFromGraph();
    fetchallRestaurantsFromGraph();
  }


  Future<Position> determineUserLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getUserLocationAndFetchRestaurants() async {
    try {
      // Request permission if needed
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print("Location permissions are denied.");
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double userLat = position.latitude;
      double userLong = position.longitude;

      print("User's Location: Lat: $userLat, Long: $userLong");

      // Call the function with user location
      fetchSearchRestaurantsByCategory(userLat, userLong);
    } catch (e) {
      print("Error getting location: $e");
    }
  }


  Future<void> fetchQuerycategoryWithPrepTime(
      String categoryName,
      bool isDeliverySelected,
      double userLat,
      double userLong,
      ) async {
    List<models.Restaurant> allRestaurants = List<models.Restaurant>.from(
      PickUpController().getRestaurantSearch.value.restaurantData ?? [],
    );

    List<models.Restaurant> filteredRestaurants =
    allRestaurants.where((restaurant) {
      int? prepTime = int.tryParse(
        _getMaxPreparationTime(restaurant) ?? '',
      );
      return prepTime != null && prepTime < 30;
    }).toList();

    // Use the filtered list instead
    if (isDeliverySelected) {
      fetchRestaurantsdeliveryByCategory(categoryName, userLat, userLong);
    } else {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      fetchRestaurantsByCategory(categoryName,position.latitude, position.longitude);
    }
  }


  void fetchCategory200({
    required String categoryName,
    required bool? deliveryAvailable,
  }) async {
    print("🔍 Fetching Restaurants Under ₹200");
    print("📌 Category: $categoryName | Delivery: $deliveryAvailable");

    isLoading.value = true;

    try {
      getCategoryRestaurants.clear(); // Reset previous data

      // Fetch user location
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double userLat = position.latitude;
      double userLong = position.longitude;

      // Generate GraphQL Query
      String query = GraphQuery.querycategory200(
        categoryName,
        deliveryAvailable.toString(),
      );
      print("📡 Query Generated: $query");

      // Fetch Data
      final result = await GraphQLClientService.fetchData(query: query);
      print("🔄 GraphQL Response: ${result.data}");

      // Validate Response
      if (result.data == null || !result.data!.containsKey('restaurants')) {
        print("⚠️ No data found or incorrect structure");
        showNoRestaurantsMessage();
        return;
      }

      // Extract Restaurants
      List<dynamic> jsonRestaurants = result.data!['restaurants'];

      // Check if No Restaurants Found
      if (jsonRestaurants.isEmpty) {
        print("🚫 No restaurants found under ₹200");
        showNoRestaurantsMessage();
        return;
      }

      // Convert Response to Model
      List<models.Restaurant> temp =
      jsonRestaurants.map((e) => models.Restaurant.fromJson(e)).toList();

      // Sort restaurants by nearest first
      temp.sort((a, b) {
        double distanceA = _calculateDistance(userLat, userLong, a.branches?.first.latitude, a.branches?.first.longitude);
        double distanceB = _calculateDistance(userLat, userLong, b.branches?.first.latitude, b.branches?.first.longitude);
        return distanceA.compareTo(distanceB); // Nearest first
      });

      // Assign sorted restaurants
      getCategoryRestaurants.assignAll(temp);
      print("✅ Loaded: ${getCategoryRestaurants.length} Restaurants (Sorted by Distance)");
    } catch (error) {
      print("❌ Error Fetching Restaurants: $error");
    } finally {
      isLoading.value = false;
    }
  }


  void showNoRestaurantsMessage() {
    getCategoryRestaurants.clear();
    print("🚫 No restaurants available for the selected filter.");
  }

  void fetchAndSortcategoryRestaurants({
    required String categoryName,
    bool sortHighToLow = true,
    required bool isDelivery,
  }) async {
    print("Fetching and sorting restaurants for category: $categoryName...");
    isLoading.value = true;

    try {
      String query =
          isDelivery
              ? GraphQuery.querygetdeliveryByName(
                categoryName,
              ) // Delivery query
              : GraphQuery.querygetRestaurantByName(
                categoryName,
              ); // Self-pickup query

      print("Executing Query: $query");

      final result = await GraphQLClientService.fetchData(query: query);
      print("GraphQL Raw Response: ${result.data}");

      if (result.data == null || !result.data!.containsKey('restaurants')) {
        print("Invalid response structure or no restaurants found");
        isLoading.value = false;
        return;
      }

      // Convert response to model list
      List<models.Restaurant> restaurants =
          (result.data!['restaurants'] as List)
              .map((v) => models.Restaurant.fromJson(v))
              .toList();

      print("Parsed Restaurants Count: ${restaurants.length}");

      if (restaurants.isEmpty) {
        print("No restaurants found for category: $categoryName");
        isLoading.value = false;
        return;
      }

      // Sort by minimumLimitOfPerPerson
      restaurants.sort((a, b) {
        int aValue = a.minimumLimitOfPerPerson ?? 0;
        int bValue = b.minimumLimitOfPerPerson ?? 0;
        return sortHighToLow
            ? bValue.compareTo(aValue)
            : aValue.compareTo(bValue);
      });

      getCategoryRestaurants.assignAll(restaurants);
      print("Final Sorted Restaurants Count: ${getCategoryRestaurants.length}");
    } catch (error, stackTrace) {
      print("fetchAndSortRestaurants Error: $error");
      print("StackTrace: $stackTrace");
    } finally {
      isLoading.value = false;
      print("Fetching process completed.");
    }
  }

  void fetchRestaurantsdeliveryByCategory(String categoryName, double userLat, double userLong) async {
    print("Category Name before query: '$categoryName'");

    if (categoryName.isEmpty || categoryName == "Default Category") {
      print("Invalid category, skipping fetch.");
      return;
    }

    print("Fetching restaurants for category: $categoryName");
    isLoading.value = true;

    try {
      getCategoryRestaurants.clear();

      // Trim category name to avoid formatting issues
      String formattedCategoryName = categoryName.trim();

      print("Formatted Category Name: '$formattedCategoryName'");

      // Generate query dynamically
      String query = GraphQuery.querygetRestaurantByName(formattedCategoryName);
      print("Executing Query: $query");

      final result = await GraphQLClientService.fetchData(query: query);

      print("GraphQL Raw Response: ${result.data}");

      // Validate response
      if (result.data == null || !result.data!.containsKey('restaurants')) {
        print("No data found or incorrect structure");
        isLoading.value = false;
        return;
      }

      List<dynamic> jsonRestaurants = result.data!['restaurants'];

      if (jsonRestaurants.isEmpty) {
        print("No restaurants found for this category: $formattedCategoryName");
        isLoading.value = false;
        return;
      }

      // Convert response to restaurant models
      List<models.Restaurant> temp =
      jsonRestaurants.map((e) => models.Restaurant.fromJson(e)).toList();

      // Sort restaurants by distance (nearest first)
      temp.sort((a, b) {
        double distanceA = _calculateDistance(
            userLat, userLong, a.branches?.first.latitude, a.branches?.first.longitude);
        double distanceB = _calculateDistance(
            userLat, userLong, b.branches?.first.latitude, b.branches?.first.longitude);
        return distanceA.compareTo(distanceB); // Nearest first
      });

      getCategoryRestaurants.assignAll(temp);
      print("Restaurants Loaded: ${getCategoryRestaurants.length}");
    } catch (error) {
      print("fetchRestaurantsdeliveryByCategory Error: $error");
    } finally {
      isLoading.value = false;
    }
  }



  void fetchRestaurantsByName(String name) async {
    print("Searching restaurants by name: '$name'"); // Debug log

    if (name.isEmpty) {
      // If the search query is empty, reset the list to show all restaurants
      getUserLocationAndFetchRestaurants();
      return;
    }

    isLoading.value = true;

    try {
      // Filter the existing list of restaurants by name
      List<models.Restaurant> filteredRestaurants =
          getCategoryRestaurants
              .where(
                (restaurant) => restaurant.restaurantName!
                    .toLowerCase()
                    .contains(name.toLowerCase()),
              )
              .toList();

      // Update the observable list with the filtered results
      getCategoryRestaurants.assignAll(filteredRestaurants);

      print("Filtered Restaurants Loaded: ${getCategoryRestaurants.length}");
    } catch (error) {
      print("fetchRestaurantsByName Error: $error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchallRestaurantsFromGraph() async {
    try {
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryRestaurantByName(restaurantCuisine.value),
      );

      if (result.data != null && result.data!['restaurants'] != null) {
        List jsonString = result.data!['restaurants'] as List;
        var temp = GetRestaurantSearch.fromList(jsonString);
        getRestaurantSearch.value = temp;
      } else {
        getRestaurantSearch.value = GetRestaurantSearch();
      }
    } catch (error) {
      if (kDebugMode) {
        print("fetchSearchRestaurantsFromGraph Error: $error");
      }
      getRestaurantSearch.value = GetRestaurantSearch();
    }
  }


  void fetchSearchRestaurantsFromGraph() async {
    try {
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryRestaurantByName(restaurantCuisine.value),
      );

      if (result.data != null && result.data!['restaurants'] != null) {
        List jsonString = result.data!['restaurants'] as List;
        var temp = GetRestaurantSearch.fromList(jsonString);
        getRestaurantSearch.value = temp;
      } else {
        getRestaurantSearch.value = GetRestaurantSearch();
      }
    } catch (error) {
      print("fetchSearchRestaurantsFromGraph Error: $error");
      getRestaurantSearch.value = GetRestaurantSearch();
    }
  }


  void fetchonlySearchRestaurants() async {
    try {
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryRestaurantByName(restaurantCuisine.value),
      );

      if (result.data != null && result.data!['restaurants'] != null) {
        List jsonString = result.data!['restaurants'] as List;
        var temp = GetRestaurantSearch.fromList(jsonString);
        searchRestaurants.value = temp;
      } else {
        searchRestaurants.value = GetRestaurantSearch();
      }
    } catch (error) {
      print("fetchSearchRestaurantsFromGraph Error: $error");
      searchRestaurants.value = GetRestaurantSearch();
    }
  }

  Future<void> fetchAllRestaurantCategories() async {
    try {
      isLoading.value = true;
      print("Fetching all restaurant categories...");

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.getCategory(),
      );

      print("Raw API Categories Response 2 : ${response.data}");

      if (response.data != null && response.data!["categorys"] != null) {
        List<dynamic> categoryData = response.data!["categorys"];

        // ✅ Use alias to avoid Flutter's built-in 'Category'
        List<menuModel.Category> categoryList =
            categoryData
                .map((category) => menuModel.Category.fromJson(category))
                .toList();

        print(
          "Parsed Restaurant Categories List: ${categoryList.map((c) => c?.toJson())}",
        );

        // ✅ Update getCategories correctly
        getCategories.value = categoryList;
      } else {
        print("No valid data received!");
        getCategories.value = [];
      }
    } catch (error) {
      print('fetchAllRestaurantCategories Error: $error');
      getCategories.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllSearchRestaurantCategories() async {
    try {
      isLoading.value = true;
      print("Fetching all restaurant categories...");

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.getCategory(),
      );

      print("Raw API Categories Response 2 : ${response.data}");

      if (response.data != null && response.data!["categorys"] != null) {
        List<dynamic> categoryData = response.data!["categorys"];

        // ✅ Use alias to avoid Flutter's built-in 'Category'
        List<menuModel.Category> categoryList =
            categoryData
                .map((category) => menuModel.Category.fromJson(category))
                .toList();

        print(
          "Parsed Restaurant Categories List: ${categoryList.map((c) => c?.toJson())}",
        );

        // ✅ Update getCategories correctly
        getCategories.value = categoryList;
      } else {
        print("No valid data received!");
        getCategories.value = [];
      }
    } catch (error) {
      print('fetchAllRestaurantCategories Error: $error');
      getCategories.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void fetchRestaurantsByCategory(String categoryName, double userLat, double userLong) async {
    print("Category Name before query: '$categoryName'"); // Debug log

    if (categoryName.isEmpty || categoryName == "Default Category") {
      print("Invalid category, skipping fetch.");
      return;
    }

    print("Fetching restaurants for category: $categoryName");
    isLoading.value = true;

    try {
      getCategoryRestaurants.clear();

      // Trim category name to avoid formatting issues
      String formattedCategoryName = categoryName.trim();

      print("Formatted Category Name: '$formattedCategoryName'");

      // Generate query dynamically
      String query = GraphQuery.querygetRestaurantByName(formattedCategoryName);
      print("Executing Query: $query");

      final result = await GraphQLClientService.fetchData(query: query);

      print("GraphQL Raw Response: ${result.data}");

      // Validate response
      if (result.data == null || !result.data!.containsKey('restaurants')) {
        print("No data found or incorrect structure");
        isLoading.value = false;
        return;
      }

      List<dynamic> jsonRestaurants = result.data!['restaurants'];

      if (jsonRestaurants.isEmpty) {
        print("No restaurants found for this category: $formattedCategoryName");
        isLoading.value = false;
        return;
      }

      // Convert response to restaurant models
      List<models.Restaurant> temp =
      jsonRestaurants.map((e) => models.Restaurant.fromJson(e)).toList();

      // Sort restaurants by distance (nearest first)
      temp.sort((a, b) {
        double distanceA = _calculateDistance(
            userLat, userLong,
            a.branches?.first.latitude, a.branches?.first.longitude
        );
        double distanceB = _calculateDistance(
            userLat, userLong,
            b.branches?.first.latitude, b.branches?.first.longitude
        );
        return distanceA.compareTo(distanceB); // Sort nearest first
      });

      getCategoryRestaurants.assignAll(temp);
      print("Sorted Restaurants Loaded: ${getCategoryRestaurants.length}");
    } catch (error) {
      print("fetchRestaurantsByCategory Error: $error");
    } finally {
      isLoading.value = false;
    }
  }




  void fetchSearchRestaurantsByCategory(double userLat, double userLong) async {
    print("Fetching all restaurants");
    isLoading.value = true;

    try {
      getCategoryRestaurants.clear();

      // Generate query to fetch all restaurants
      String query = GraphQuery.querygetSearchRestaurant();
      print("Executing Query: $query");

      final result = await GraphQLClientService.fetchData(query: query);

      print("GraphQL Raw Response: ${result.data}");

      if (result.data == null || !result.data!.containsKey('restaurants')) {
        print("No data found or incorrect structure");
        isLoading.value = false;
        return;
      }

      List<dynamic> jsonRestaurants = result.data!['restaurants'];

      if (jsonRestaurants.isEmpty) {
        print("No restaurants found");
        isLoading.value = false;
        return;
      }

      // Convert response to restaurant models
      List<models.Restaurant> temp = jsonRestaurants
          .map((e) => models.Restaurant.fromJson(e))
          .toList();

      // Sort by distance
      temp.sort((a, b) {
        double distanceA = _calculateDistance(
            userLat, userLong, a.branches?.first.latitude, a.branches?.first.longitude);
        double distanceB = _calculateDistance(
            userLat, userLong, b.branches?.first.latitude, b.branches?.first.longitude);
        return distanceA.compareTo(distanceB); // Sort nearest first
      });

      getCategoryRestaurants.assignAll(temp);
      print("Restaurants Loaded: ${getCategoryRestaurants.length}");
    } catch (error) {
      print("fetchAllRestaurants Error: $error");
    } finally {
      isLoading.value = false;
    }
  }

// Haversine formula to calculate distance
  double _calculateDistance(double userLat, double userLong, double? restLat, double? restLong) {
    if (restLat == null || restLong == null) return double.infinity; // Handle missing values

    const double R = 6371; // Earth's radius in km
    double dLat = _degToRad(restLat - userLat);
    double dLon = _degToRad(restLong - userLong);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(userLat)) * cos(_degToRad(restLat)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in km
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }


  /// Fetch Restaurant Details By ID
  Future<void> fetchRestaurantsByIdFromGraph() async {
    try {
      if (restaurantId.value.isEmpty || restaurantId.value == "0") {
        print("🚨 Invalid restaurant ID: ${restaurantId.value}");
        return;
      }

      print("Fetching restaurant details for ID: ${restaurantId.value}");
      isLoading.value = true;

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.queryRestaurantById(restaurantId.value),
      );

      if (response.data != null && response.data!["restaurants"] is List) {
        getRestaurantById.value = GetRestaurantsById.fromList(
          response.data!["restaurants"],
        );
        print("✅ Restaurant data fetched successfully.");
      } else {
        print("🚨 Invalid response structure for restaurant details.");
      }
    } catch (error) {
      print('❌ fetchRestaurantsByIdFromGraph Error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch Restaurant Menu By ID
  Future<void> fetchRestaurantsMenuByIdFromGraph() async {
    try {
      if (restaurantId.value.isEmpty || restaurantId.value == "0") {
        print("🚨 Invalid restaurant ID: ${restaurantId.value}");
        return;
      }

      print("Fetching restaurant menu for ID: ${restaurantId.value}");
      isLoading.value = true;

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.getRestaurantMenuById(restaurantId.value),
      );

      if (response.data != null && response.data!["restaurants"] is List) {
        getRestaurantMenuById.value = GetRestaurantMenuById.fromMap(
          response.data!["restaurants"],
        );
        print("✅ Restaurant menu fetched successfully.");
      } else {
        print("🚨 Invalid menu response structure.");
      }
    } catch (error) {
      print('❌ fetchRestaurantsMenuByIdFromGraph Error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  /// Filtered Menu Items Based on User Search
  List<RestaurantMenuDatum> get filteredMenuItems {
    if (userSearchQueryForMenuItems.value.isEmpty) {
      return getRestaurantMenuById.value.restaurantMenuData ?? [];
    } else {
      return getRestaurantMenuById.value.restaurantMenuData
              ?.where(
                (menuItem) =>
                    menuItem.restaurantMenuName?.toLowerCase().contains(
                      userSearchQueryForMenuItems.value.toLowerCase(),
                    ) ??
                    false,
              )
              .toList() ??
          [];
    }
  }

  /// Fetch Restaurants Menu By ID with JSON Parsing
  Future<void> fetchRestaurantsMenuById() async {
    try {
      if (restaurantId.value.isEmpty || restaurantId.value == "0") {
        print("🚨 Invalid restaurant ID: ${restaurantId.value}");
        return;
      }

      print("Fetching menu for restaurant ID: ${restaurantId.value}");
      isLoading.value = true;

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.getRestaurantMenuById(restaurantId.value),
      );

      print("📥 Raw API Response: ${response.data}"); // Debugging

      if (response.data != null && response.data!["restaurants"] != null) {
        final parsedData = RestaurantMenu.fromJson(response.data!);
        getRestaurantMenusById.value = parsedData;
        print("✅ Parsed Menu Data: ${parsedData.toJson()}");
      } else {
        print("🚨 No valid menu data received!");
        getRestaurantMenusById.value = RestaurantMenu();
      }
    } catch (error) {
      print('❌ fetchRestaurantsMenuById Error: $error');
      getRestaurantMenusById.value = RestaurantMenu();
    } finally {
      isLoading.value = false;
    }
  }

  List get filteredMenuItem {
    return getRestaurantMenusById.value.data?.restaurants
            ?.expand((restaurant) => restaurant.categories ?? [])
            .where(
              (category) =>
                  selectedCategory.isEmpty ||
                  category.categoryName == selectedCategory.value,
            ) // Filter by category
            .expand((category) => category.menus ?? [])
            .where(
              (menuItem) =>
                  menuItem.name?.toLowerCase().contains(
                    userSearchQueryForMenuItems.value.toLowerCase(),
                  ) ??
                  false,
            )
            .toList() ??
        [];
  }

  static Future<Position?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Future<void> fetchQueryDeliveryRestaurant(double userLat, double userLong) async {
    print("Fetching delivery restaurants");
    isLoading.value = true;

    try {
      getCategoryRestaurants.clear();

      // Generate query to fetch delivery restaurants
      String query = GraphQuery.querydeliveryRestaurant();
      print("Executing Query: $query");

      final result = await GraphQLClientService.fetchData(query: query);

      print("GraphQL Raw Response: \${result.data}");

      // Validate response
      if (result.data == null || !result.data!.containsKey('restaurants')) {
        print("No data found or incorrect structure");
        isLoading.value = false;
        return;
      }

      List<dynamic> jsonRestaurants = result.data!['restaurants'];

      if (jsonRestaurants.isEmpty) {
        print("No restaurants found");
        isLoading.value = false;
        return;
      }

      // Convert response to restaurant models
      List<models.Restaurant> temp = jsonRestaurants
          .map((e) => models.Restaurant.fromJson(e))
          .toList();

      // Sort by distance
      temp.sort((a, b) {
        double distanceA = _calculateDistance(
            userLat, userLong, a.branches?.first.latitude, a.branches?.first.longitude);
        double distanceB = _calculateDistance(
            userLat, userLong, b.branches?.first.latitude, b.branches?.first.longitude);
        return distanceA.compareTo(distanceB); // Sort nearest first
      });

      getCategoryRestaurants.assignAll(temp);
      print("Restaurants Loaded: \${getCategoryRestaurants.length}");
    } catch (error) {
      print("fetchQueryDeliveryRestaurant Error: $error");
    } finally {
      isLoading.value = false;
    }
  }


  void fetchLessThan200({required bool deliveryAvailable}) async {
    print("Fetching restaurants with price < 200 and deliveryAvailable: $deliveryAvailable");
    isLoading.value = true;

    try {
      // Fetch GraphQL data and user location simultaneously
      final fetchFuture = GraphQLClientService.fetchData(query: GraphQuery.querygetlessthan200());
      final positionFuture = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      final results = await Future.wait([fetchFuture, positionFuture]);

      final QueryResult result = results[0] as QueryResult;
      final Position position = results[1] as Position;

      double userLat = position.latitude;
      double userLong = position.longitude;

      // Check for errors in GraphQL result
      if (result.hasException) {
        print("GraphQL Error: ${result.exception.toString()}");
        return;
      }

      final jsonData = result.data;
      if (jsonData == null || !jsonData.containsKey('restaurants')) {
        print("No data found or incorrect structure");
        return;
      }

      // Parse restaurants and filter by `deliveryAvailable`
      List<models.Restaurant> temp = (jsonData['restaurants'] as List)
          .where((r) => r['deliveryAvailable'] == deliveryAvailable)
          .map((r) => models.Restaurant.fromJson(r))
          .toList();

      // Sort restaurants by nearest first
      temp.sort((a, b) {
        double distanceA = _calculateDistance(userLat, userLong, a.branches?.first.latitude, a.branches?.first.longitude);
        double distanceB = _calculateDistance(userLat, userLong, b.branches?.first.latitude, b.branches?.first.longitude);
        return distanceA.compareTo(distanceB); // Nearest first
      });

      // Only update if new data is available
      if (temp.isNotEmpty) {
        getCategoryRestaurants.assignAll(temp);
        print("Restaurants Loaded (Sorted by Distance): ${getCategoryRestaurants.length}");
      } else {
        print("No restaurants found");
      }
    } catch (error) {
      print("fetchLessThan200WithDelivery Error: $error");
    } finally {
      isLoading.value = false;
    }
  }



  void fetchQueryRestaurantsWithPrepTime({
    required bool deliveryAvailable,
  }) async {
    isLoading.value = true;
    try {
      final positionFuture = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final fetchFuture = GraphQLClientService.fetchData(query: GraphQuery.querygetSearchRestaurant());

      final results = await Future.wait([positionFuture, fetchFuture]);

      final position = results[0] as Position;
      final QueryResult result = results[1] as QueryResult;

      if (result.hasException) {
        print("GraphQL Error: ${result.exception.toString()}");
        return;
      }

      final Map<String, dynamic>? jsonData = result.data;

      if (jsonData == null || !jsonData.containsKey('restaurants')) {
        print("No data found or incorrect structure");
        return;
      }

      var jsonRestaurants = jsonData['restaurants']
          .where((r) => r['deliveryAvailable'] == deliveryAvailable)
          .map((e) => models.Restaurant.fromJson(e))
          .where((r) {
        int? timeValue = int.tryParse(
          RegExp(r'\d+').firstMatch(r.maxPreparationTime ?? '')?.group(0) ?? '',
        );
        return timeValue != null && timeValue < 30;
      })
          .toList();

      getCategoryRestaurants.assignAll(jsonRestaurants);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String? _getMaxPreparationTime(models.Restaurant storeData) {
    List<int> preparationTimes = [];

    for (var category in storeData.categories ?? []) {
      for (var menu in category.menus ?? []) {
        if (menu.preparationTime != null) {
          final match = RegExp(r'\d+').firstMatch(menu.preparationTime!);
          if (match != null) {
            final time = int.tryParse(match.group(0)!);
            if (time != null) {
              preparationTimes.add(time);
            }
          }
        }
      }
    }

    if (preparationTimes.isNotEmpty) {
      return "${preparationTimes.reduce((a, b) => a > b ? a : b)} MINS";
    }

    return null;
  }

  void fetchAndSortRestaurants({
    bool sortHighToLow = true,
    required bool isDelivery,
  }) async {
    print("Fetching and sorting restaurants...");
    isLoading.value = true;

    double? userLat;
    double? userLong;

    // Fetch user location if delivery mode is selected
    if (isDelivery) {
      try {
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        userLat = position.latitude;
        userLong = position.longitude;
      } catch (e) {
        print("Error fetching location: $e");
        isLoading.value = false;
        return;
      }
    }

    try {
      if (isDelivery && userLat != null && userLong != null) {
        await fetchQueryDeliveryRestaurant(userLat, userLong);

        // Ensure sorting happens after fetching
        getCategoryRestaurants.sort((a, b) {
          int aValue = a.minimumLimitOfPerPerson ?? 0;
          int bValue = b.minimumLimitOfPerPerson ?? 0;
          return sortHighToLow
              ? bValue.compareTo(aValue)
              : aValue.compareTo(bValue);
        });

        print(
          "Sorted Delivery Restaurants Count: ${getCategoryRestaurants.length}",
        );
        return;
      }

      // Fetch all restaurants for self-pickup mode
      String query = GraphQuery.querygetSearchRestaurant();
      print("Executing Query: $query");

      final result = await GraphQLClientService.fetchData(query: query);
      print("GraphQL Raw Response: ${result.data}");

      if (result.data == null || !result.data!.containsKey('restaurants')) {
        print("Invalid response structure");
        isLoading.value = false;
        return;
      }

      // Convert response to models
      List<models.Restaurant> restaurants =
      (result.data!['restaurants'] as List)
          .map((v) => models.Restaurant.fromJson(v))
          .toList();

      print("Parsed Restaurants Count: ${restaurants.length}");

      if (restaurants.isEmpty) {
        print("No restaurants found");
        isLoading.value = false;
        return;
      }

      // Apply sorting before assignment
      restaurants.sort((a, b) {
        int aValue = a.minimumLimitOfPerPerson ?? 0;
        int bValue = b.minimumLimitOfPerPerson ?? 0;
        return sortHighToLow
            ? bValue.compareTo(aValue)
            : aValue.compareTo(bValue);
      });

      getCategoryRestaurants.assignAll(restaurants);
      print("Final Sorted Restaurants Count: ${getCategoryRestaurants.length}");
    } catch (error, stackTrace) {
      print("fetchAndSortRestaurants Error: $error");
      print("StackTrace: $stackTrace");
    } finally {
      isLoading.value = false;
      print("Fetching process completed.");
    }
  }


}
