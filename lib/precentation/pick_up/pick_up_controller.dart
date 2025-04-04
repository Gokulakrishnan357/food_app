import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:zeroq/models/restaurant_models/restaurant_models.dart';
import 'package:zeroq/models/restaurant_models/restaurant_search_model.dart';
import 'package:zeroq/Model/RestaurantCategoryModel.dart' as models;
import 'package:zeroq/server/network_handler.dart';
import 'package:zeroq/Model/MenuModel.dart' as menuModel;
import '../../Model/MenuModel.dart' as menuModelAlias;
import '../../Model/MenuModel.dart';
import '../../const/app_exports.dart';
import '../../models/delivery_restarurantmodel.dart';
import '../../models/user_data_model.dart';

class PickUpController extends GetxController {
  late final TextEditingController search;
  final AppNetworkHandler networkHandler = AppNetworkHandler();

  var getAllStore = ListRestaurants().obs;

  var restaurantCuisine = "".obs;
  var isToggled = false.obs;

  /// location initialization
  RxString latitude = 'Getting Latitude...'.obs;
  RxString longitude = 'Getting Longitude...'.obs;
  RxString currentAddress = 'Getting Address...'.obs;
  RxString currentCity = 'Getting City...'.obs;
  RxString formattedAddress = 'Getting City...'.obs;

  StreamSubscription<Position>? streamSubscription;

  RxBool isLoading = false.obs;
  RxString cartData = "".obs;
  RxString id = "".obs;
  RxString itemsCount = "0".obs;
  RxInt itemTotal = 0.obs;
  RxInt platformFee = 5.obs;
  RxInt gst = 0.obs;
  RxInt totalPay = 0.obs;
  RxString couponApplied = "".obs;

  RxInt restaurantId = 0.obs;
  RxInt restaurantMenuId = 0.obs;
  RxInt quantity = 0.obs;
  RxInt userId = 0.obs;
  RxDouble price = 0.0.obs;

  var getRestaurantSearch = GetRestaurantSearch().obs;
  var getRestaurants = GetRestaurantSearch().obs;
  var searchRestaurants = GetRestaurantSearch().obs;
  var getAllStore1 = RxList<Restaurants>([]);

  final userSearchQueryForCategories = ''.obs;

  Rx<RestaurantMenu> getRestaurantMenusById = RestaurantMenu().obs;
  final RxList<UserRegularAddress> userAddresses = <UserRegularAddress>[].obs;

  final RxList<models.Restaurant> getCategoryRestaurants =
      <models.Restaurant>[].obs;
  var getCategories = <menuModel.Category>[].obs;
  var categoryName = ''.obs;

  Timer? _locationTimer;

  @override
  void onInit() {
    super.onInit();

    fetchAndStoreLocation();
    startLocationTracking();

    // ✅ Pass a valid UserRegularAddress object
    if (userAddresses.isNotEmpty) {
      fetchAndStoreLocationFromAddress(userAddresses.first);
    }



    getUserLocation();

    streamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();

      print(
        "📍 Location Updated: Lat: ${latitude.value}, Lon: ${longitude.value}",
      );

      // Fetch updated restaurants list based on new location
      fetchSearchRestaurantsFromGraph(
        newLat: position.latitude,
        newLon: position.longitude,
      );
    });

    if (Get.arguments != null && Get.arguments is String) {
      categoryName.value = Get.arguments as String;
    }

    if (categoryName.isNotEmpty) {
      fetchRestaurantsByCategory(categoryName.value);
    }



    getUserLocation();

    fetchallRestaurants();
    fetchonlySearchRestaurants();
    fetchallRestaurantsFromGraph();
    fetchAllRestaurantCategories();
    fetchRestaurantsFromGraph();
    fetchRestaurantsMenuById();
    fetchSearchRestaurantsFromGraph();
    fetchHotelDeliveryRestaurants();

    fetchAndStoreLocation();
    fetchHotelDeliveryRestaurants();
    // loadInitialData();

    search = TextEditingController();

    // Initialize streamSubscription safely
    streamSubscription = Geolocator.getPositionStream().listen((
      Position position,
    ) {
      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();
    });
  }

  @override
  void onClose() {
    streamSubscription?.cancel();
    super.onClose();
  }


  void startLocationTracking() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      fetchAndStoreLocation(); // Automatically update location
    });
  }

  void stopAutoFetchLocation() {
    _locationTimer?.cancel();
  }

  Future<void> fetchAndStoreLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      double userLatitude = position.latitude;
      double userLongitude = position.longitude;

      latitude.value = userLatitude.toString();
      longitude.value = userLongitude.toString();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        userLatitude,
        userLongitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        currentCity.value = place.locality ?? 'Unknown City';

        // Update formattedAddress
        formattedAddress.value =
        '${place.subLocality ?? 'Unknown Area'}, ${place.locality ?? 'Unknown City'}';

        if (kDebugMode) {
          print("📍 Updated Location: ${formattedAddress.value}");
        }
      }

      // Update UI based on location
      fetchSearchRestaurantsFromGraph(
        newLat: userLatitude,
        newLon: userLongitude,
      );

    } catch (e) {
      if (kDebugMode) {
        print("🚨 Error fetching location: $e");
      }
    }
  }

  Future<void> loadInitialData() async {
    try {
      isLoading(true);
      await fetchAndStoreLocation();
      isLoading(false);
    } catch (e) {
      isLoading(false);
      rethrow;
    }
  }

  Future<void> fetchAndStoreLocationFromAddress(
      UserRegularAddress address,
      ) async {
    try {
      double lat = double.tryParse(address.latitude) ?? 0.0;
      double lon = double.tryParse(address.longitude) ?? 0.0;

      if (lat == 0.0 || lon == 0.0) {
        print("Invalid latitude or longitude values.");
        return;
      }

      // Store previous location before updating
      double oldLat = double.tryParse(latitude.value) ?? 0.0;
      double oldLon = double.tryParse(longitude.value) ?? 0.0;

      // Update current location
      latitude.value = address.latitude;
      longitude.value = address.longitude;

      // Fetch address details
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        currentCity.value = place.locality ?? 'Unknown City';

        // Update formattedAddress dynamically
        formattedAddress.value =
        '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}';
      }

      print("Selected Address Location: ${formattedAddress.value}");

      // Fetch restaurants based on both old and new location
      fetchSearchRestaurantsFromGraph(
        oldLat: oldLat,
        oldLon: oldLon,
        newLat: lat,
        newLon: lon,
      );

      // Navigate back to the pick-up page
      Get.offNamed('/pickUpPage');
    } catch (e) {
      print("Error fetching address location: $e");
    }
  }

  void fetchonlySearchRestaurants() async {
    try {
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryRestaurantByName(restaurantCuisine.value),
      );
      List jsonString = result.data!['restaurants'] as List;
      var temp = GetRestaurantSearch.fromList(jsonString);
      searchRestaurants.value = temp;
    } catch (error) {
      print("fetchSearchRestaurantsFromGraph Error: $error");
    }
  }

  void fetchallRestaurantsFromGraph() async {
    try {
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryRestaurantByName(restaurantCuisine.value),
      );
      List jsonString = result.data!['restaurants'] as List;
      var temp = GetRestaurantSearch.fromList(jsonString);
      getRestaurants.value = temp;
    } catch (error) {
      print("fetchSearchRestaurantsFromGraph Error: $error");
    }
  }

  Future<void> fetchSearchRestaurantsFromGraph({
    double? oldLat,
    double? oldLon,
    double? newLat,
    double? newLon,
  }) async {
    try {
      double userLatitude, userLongitude;

      if (newLat != null && newLon != null) {
        userLatitude = newLat;
        userLongitude = newLon;
        print(
            "📍 Using New Address Location - Lat: $userLatitude, Lon: $userLongitude");
      } else {
        // ✅ Check and request location permissions
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            print("🚨 Location permission denied.");
            return;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          print(
              "❌ Location permission permanently denied. Redirecting user to app settings...");
          await Geolocator.openAppSettings();
          return;
        }

        // ✅ Get the current position after ensuring permissions
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        );
        userLatitude = position.latitude;
        userLongitude = position.longitude;
        print(
            "📍 Using Current Location - Lat: $userLatitude, Lon: $userLongitude");
      }

      // Fetch restaurants from GraphQL
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryRestaurantByName(restaurantCuisine.value),
      );

      if (result.data == null || result.data!['restaurants'] == null) {
        print("⚠️ No restaurant data found.");
        return;
      }

      List jsonString = result.data!['restaurants'] as List;
      print("✅ GraphQL Request Successful. Total Restaurants Found: ${jsonString
          .length}");

      var temp = GetRestaurantSearch.fromList(jsonString);
      List<String> includedRestaurants = [];
      List<String> excludedRestaurants = [];

      var filteredRestaurants = temp.restaurantData?.where((restaurant) {
        if (restaurant.branches == null || restaurant.branches!.isEmpty) {
          return false;
        }

        for (var branch in restaurant.branches!) {
          double restaurantLat = branch.latitude ?? 0.0;
          double restaurantLon = branch.longitude ?? 0.0;

          double distanceFromNew = calculateDistance(
              userLatitude, userLongitude, restaurantLat, restaurantLon);
          double distanceFromOld = (oldLat != null && oldLon != null)
              ? calculateDistance(oldLat, oldLon, restaurantLat, restaurantLon)
              : double.infinity;

          if (distanceFromNew <= 5.0 || distanceFromOld <= 5.0) {
            includedRestaurants.add(
                "${restaurant.restaurantName} - ${distanceFromNew
                    .toStringAsFixed(2)} km");
            print("📌 Added: ${restaurant
                .restaurantName} | Distance: ${distanceFromNew.toStringAsFixed(
                2)} km");
            return true;
          }
        }
        excludedRestaurants.add(
            restaurant.restaurantName ?? "Unknown Restaurant");
        return false;
      }).toList();

      print("\n🍽️ ✅ Restaurants Within 5 KM:");
      includedRestaurants.forEach(print);

      print("\n❌ Restaurants Excluded (Beyond 5 KM):");
      excludedRestaurants.forEach(print);

      print("\n🍽️ Final Filtered Restaurants Count: ${filteredRestaurants
          ?.length}");

      // Update the restaurant list
      getRestaurantSearch.value =
          GetRestaurantSearch(restaurantData: filteredRestaurants);
    } catch (error, stackTrace) {
      print("🚨 Error in fetchSearchRestaurantsFromGraph: $error");
      print("🛠️ Stack Trace: $stackTrace");
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth radius in km
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in km
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  Future<void> fetchAllCategories() async {
    try {
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.getAllCategoriesQuery(),
      );

      if (result.data == null || result.data?['categories'] == null) {
        throw Exception("No categories data found");
      }

      List<dynamic> jsonCategories = result.data!['categories'] ?? [];

      getCategories.assignAll(
        jsonCategories.map((e) => menuModelAlias.Category.fromJson(e)).toList(),
      );
    } catch (e) {
      print("❌ fetchAllCategories error: $e");
      Get.snackbar("Error", "Failed to load categories. Please try again.");
    }
  }

  Future<void> fetchRestaurantsMenuById() async {
    try {
      if (restaurantId.value == 0) {
        // Correct check for integer
        print("Invalid restaurant ID: ${restaurantId.value}");
        return;
      }

      print("Fetching menu for restaurant ID: ${restaurantId.value}");

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.getRestaurantMenuById(
          restaurantId.value.toString(),
        ), // Convert to String
      );

      print("Raw API Response: ${response.data}");

      if (response.data != null && response.data!['data'] != null) {
        getRestaurantMenusById.value = RestaurantMenu.fromJson(response.data!);
        print("Parsed Menu Data: ${getRestaurantMenusById.value}");
      } else {
        print("No valid data received!");
      }
    } catch (error) {
      print('fetchRestaurantsMenuById Error: $error');
    }
  }

  void fetchRestaurantsFromGraph() async {
    try {
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryGetAllRestraunt,
      );
      List jsonString = result.data!['restaurants'] as List;
      var temp = ListRestaurants.fromMap(jsonString);
      getAllStore.value = temp;
    } catch (error) {
      // Handle the error
      if (kDebugMode) {
        print('fetchRestaurantsFromGraph Error: $error');
      }
    }
  }

  void fetchallRestaurants() async {
    try {
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryGetAllRestraunts,
      );
      List jsonString = result.data!['restaurants'] as List;
      var temp = ListRestaurants.fromMap(jsonString);
      getAllStore.value = temp;
    } catch (error) {
      // Handle the error
      if (kDebugMode) {
        print('fetchRestaurantsFromGraph Error: $error');
      }
    }
  }

  void fetchHotelDeliveryRestaurants() async {
    try {
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryGetHotelDelivery(),
      );

      if (result.data != null && result.data!['restaurants'] != null) {
        var hotelDeliveryData = HotelDelivery.fromJson({
          'data': {'restaurants': result.data!['restaurants']},
        });

        // ✅ Assigning a List<Restaurants> to getAllStore
        getAllStore1.value = List<Restaurants>.from(
          hotelDeliveryData.data?.restaurants ?? [],
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print('fetchHotelDeliveryRestaurants Error: $error');
      }
    }
  }

  void addToCart() async {
    isLoading.value = true;
    final cartData = json.encode({
      "restaurantId": restaurantId.value,
      "restaurantMenuId": restaurantMenuId.value,
      "quantity": quantity.value,
      "userId": userId.value,
      "price": price.value,
    });
    if (kDebugMode) {}
    try {
      final response = await networkHandler.post(
        ApiConfig.addToCartEndpoint,
        cartData,
      );
      print(response.statusCode);
      print(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  void fetchRestaurantsByCategory(String categoryName) async {
    print("Fetching restaurants for category: $categoryName");

    isLoading.value = true;

    try {
      getCategoryRestaurants.clear();

      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.querygetRestaurantByName(categoryName),
      );

      print("GraphQL Raw Response: ${result.data}");

      if (result.data == null ||
          result.data?['data'] == null ||
          result.data?['data']?['restaurants'] == null) {
        print("No data found or incorrect structure");
        isLoading.value = false;
        return;
      }

      List<dynamic> jsonRestaurants = result.data!['data']['restaurants'];

      if (jsonRestaurants.isEmpty) {
        print("No restaurants found for this category");
        isLoading.value = false;
        return;
      }

      List<models.Restaurant> temp =
          jsonRestaurants.map((e) => models.Restaurant.fromJson(e)).toList();

      getCategoryRestaurants.assignAll(temp);
    } catch (error) {
      print("fetchRestaurantsByCategory Error: $error");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchRestaurantsByPreparationTime(String preparationTime) async {
    print("Fetching restaurants for preparation time: $preparationTime");

    isLoading.value = true;

    try {
      getCategoryRestaurants.clear();

      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.querygetRestaurantByName(preparationTime),
      );

      print("GraphQL Raw Response: \${result.data}");

      if (result.data == null ||
          result.data?['data'] == null ||
          result.data?['data']?['restaurants'] == null) {
        print("No data found or incorrect structure");
        isLoading.value = false;
        return;
      }

      List<dynamic> jsonRestaurants = result.data!['data']['restaurants'];

      if (jsonRestaurants.isEmpty) {
        print("No restaurants found for this preparation time");
        isLoading.value = false;
        return;
      }

      List<models.Restaurant> temp =
          jsonRestaurants.map((e) => models.Restaurant.fromJson(e)).toList();

      getCategoryRestaurants.assignAll(temp);
    } catch (error) {
      print("fetchRestaurantsByPreparationTime Error: $error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getgoogleaddress() async {
    const String googleApiKey = 'AIzaSyAZfVOYVhlWRHa0axRxuQlsXZ5G2n1A0F8';
    const bool isDebugMode = true;

    final api = GoogleGeocodingApi(googleApiKey, isLogged: isDebugMode);

    try {

      if (latitude.value != "Gettting Latitude..." &&
          longitude.value != "Gettting Longitude...") {
        // Pass the coordinates in a format the API expects (probably as a string or map)
        final reversedSearchResults = await api.reverse(
          '${latitude.value},${longitude.value}', // Coordinates formatted as "latitude,longitude"\
          // '12.934459293210573 80.14206936782546',
          language: 'en',
        );

        // Check if results are returned
        if (reversedSearchResults.results.isNotEmpty) {
          formattedAddress.value =
              reversedSearchResults.results.first.formattedAddress;
          // var area = reversedSearchResults
          //     .results.first.addressComponents.first.types.first;
          // print("The google API types are: $area");
          // print("The google API results are: ${reversedSearchResults.results.first.formattedAddress}");
        } else {
          if (kDebugMode) {
            print("No results found");
          }
        }
      } else {
        if (kDebugMode) {
          print("Invalid latitude or longitude values");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching address: $e");
      }
    }
  }

  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission are permanently denied, we cannot request permissions',
      );
    }

    // When we reach here, permissions are granted, and we can
    // continue accessing the position of the device
    streamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) async {
      latitude.value = '${position.latitude}';
      longitude.value = '${position.longitude}';
      await getAddressFromLatLang(position);
      await getgoogleaddress();

      // Formatting address based on place values
      final place = await getPlaceFromCoordinates(
        position.latitude,
        position.longitude,
      );
      formattedAddress.value = '${place.subLocality}, ${place.locality}';
      print(formattedAddress);
    });
  }

  Future<Placemark> getPlaceFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      return placemarks.first;
    } catch (e) {
      print("Error getting place: $e");
      return Placemark();
    }
  }

  Future<void> getAddressFromLatLang(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        currentCity.value = place.locality ?? 'Unknown City';
        formattedAddress.value =
            '${place.name}, ${place.locality}, ${place.country}';
        print(formattedAddress);
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  Future<String> getAddressFromCoordinates(Position position) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final Placemark placemark = placemarks.first;
    return '${placemark.street}, ${placemark.locality}, ${placemark.country}';
  }

  final List<Map<String, dynamic>> storeData = [
    {
      "storeName": 'ELite Marriage Biriyani ',
      "storeAddress":
          "Le Stay inn, Cricket Club, #122, Bells Rd, Chepauk, Near, Chennai, Tamil Nadu 600005",
      "dish": "South Asian",
      "dish1": "Chinese",
      "storeDistance": "Peelamedu  |  2.5 km ",
      "storeRating": "4.5  |  34 mins ",
      "distance": "25 - 40 mins 2 KM",
      "image": "assets/images/food/chicken.webp",
      "offer": "1500 for five",
    },
    {
      "storeName": 'Pizza Hut',
      "storeAddress":
          "Le Stay inn, Cricket Club, #122, Bells Rd, Chepauk, Near, Chennai, Tamil Nadu 600005",
      "dish": "Italian",
      "dish1": "Briyani",
      "storeDistance": "Gandhipuram  |  5.0 km ",
      "storeRating": "4.7  |  40 mins ",
      "distance": "25 - 30 mins 1 KM",
      "image": "assets/images/food/chicken.webp",
      "offer": "750 for one",
    },
    {
      "storeName": 'Kites Cafe',
      "storeAddress":
          "Le Stay inn, Cricket Club, #122, Bells Rd, Chepauk, Near, Chennai, Tamil Nadu 600005",
      "dish": "Mexican",
      "dish1": "Thanduri",
      "storeDistance": "Peelamedu  |  1.0 km ",
      "storeRating": "4.0  |  20 mins ",
      "distance": "40 - 1HR mins 5 KM",
      "image": "assets/images/food/chicken.webp",
      "offer": "2000 for two",
    },
    {
      "storeName": 'Kites Cafe',
      "storeAddress":
          "Le Stay inn, Cricket Club, #122, Bells Rd, Chepauk, Near, Chennai, Tamil Nadu 600005",
      "dish": "American",
      "dish1": "Mexican",
      "storeDistance": "Peelamedu  |  1.0 km ",
      "storeRating": "4.0  |  20 mins ",
      "distance": "10 - 15 mins 0.5 KM",
      "image": "assets/images/food/chicken.webp",
      "offer": "500 for three",
    },
  ];

  final List<Map<String, dynamic>> foodCategory = [
    {"foodName": 'Offers'},
    {"foodName": 'Nearest'},
    {"foodName": 'Pure Veg'},
    {"foodName": 'rated 4+'},
  ];

  Rx<List<Map<String, dynamic>>> foundStores = Rx<List<Map<String, dynamic>>>(
    [],
  );

  void filterStore(String storeName) {
    List<Map<String, dynamic>> results = [];
    if (storeName.isEmpty) {
      results = storeData;
    } else {
      results =
          storeData
              .where(
                (element) => element["storeName"]
                    .toString()
                    .toLowerCase()
                    .contains(storeName.toLowerCase()),
              )
              .toList();
    }

    foundStores.value = results;
  }

  void changeLocationManually() {
    // Logic to change location manually
    currentCity.value = 'Manual Location'; // Example change
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
          "Parsed Restaurant Categories List: ${categoryList.map((c) => c.toJson())}",
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
}
