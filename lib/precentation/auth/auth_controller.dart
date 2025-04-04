
import 'dart:math';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/auth/components/registration.dart';
import 'package:zeroq/precentation/settings/profile/profile_controller.dart';
import 'package:zeroq/server/app_storage.dart';
import 'package:zeroq/server/network_handler.dart';

import '../../Model/UserModel.dart' as user_model;
import '../../models/restaurant_models/restaurant_search_model.dart';

class AuthController extends GetxController {
  final AppNetworkHandler networkHandler = AppNetworkHandler();

  late TextEditingController username, password, otp, email, phone, dob;

  RxBool valuefirst = false.obs;
  RxBool valuesecond = false.obs;
  RxString otpReceived = "".obs;
  RxInt userId = 0.obs;
  RxBool isLoading = false.obs;
  RxString currentCity = "Fetching city...".obs;
  RxString formattedAddress = "Fetching address...".obs;
  RxString errorMessage = "".obs;
  RxBool resentOTP = false.obs;
  RxString genderValue = ''.obs;

  var userDetails = Rxn<UserData>();

  var restaurantCuisine = "".obs;

  var userAddressDetails = Rxn<UserData>();

  final ProfileController profileController = Get.put(ProfileController());

  /// location initialization
  RxString latitude = 'Getting Latitude...'.obs;
  RxString longitude = 'Getting Longitude...'.obs;
  RxString currentAddress = 'Getting Address...'.obs;

  var getRestaurantSearch = GetRestaurantSearch().obs;

  Rx<user_model.UserData?> userData = Rx<user_model.UserData?>(null);

  RxBool isPhoneValid = false.obs;

  final GetStorage storage = GetStorage();

  RxBool isLoggedIn = false.obs;




  @override
  void onInit() {
    super.onInit();

    username = TextEditingController();
    password = TextEditingController();
    otp = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    dob = TextEditingController();

    getUserSession();
    fetchAndStoreLocation();
    fetchUserAddressDetails();
    fetchUserDetails();

  }

  /// Fetch user details from API and update profile
  Future<void> fetchUserDetails() async {
    try {
      if (userId.value == 0) {
        print("⚠️ Skipping fetchUserDetails() because userId is 0");
        return;
      }

      isLoading.value = true;
      print("🚀 Fetching user details for userId: ${userId.value}");

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.userDetails(userId.value),
      );

      print("📥 API Response: ${response.data}");

      if (response.data == null) {
        print("❌ Error: API response is null");
        return;
      }

      final userDetails = response.data?['userDetailsWithAddress'];
      print("📌 Extracted userDetails: $userDetails");

      if (userDetails == null) {
        print("❌ Error: userDetailsWithAddress is null");
        return;
      }

      // ✅ Extract `userId` safely
      int? fetchedUserId = userDetails['userId'];
      if (fetchedUserId == null || fetchedUserId == 0) {
        print("❌ Error: Fetched userId is invalid (Received: $fetchedUserId)");
        return;
      }
      print("✅ Successfully fetched userId: $fetchedUserId");

      // ✅ Ensure userId is updated
      userId.value = fetchedUserId;

      // ✅ Store userId as an integer in SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('userId', fetchedUserId);

      // ✅ Update `userData`
      userData.value = user_model.UserData.fromJson(response.data!);
      userData.refresh(); // Refresh GetX state

      print("✅ Updated userData: ${userData.value}");

    } catch (e) {
      print("❌ Error in fetchUserDetails: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // void checkLoginStatus() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //
  //   // ✅ Ensure userId is retrieved as an int safely
  //   int storedUserId = prefs.getInt('userId') ?? int.tryParse(prefs.getString('userId') ?? '') ?? 0;
  //
  //   if (storedUserId > 0) {
  //     userId.value = storedUserId;
  //   } else {
  //     debugPrint("❌ No user ID found in local storage!");
  //     userId.value = 0;
  //   }
  //
  //   if (isLoggedIn && userId.value > 0) {
  //     debugPrint("✅ User is logged in. Fetching user details...");
  //     await fetchUserDetails();
  //
  //     if (Get.context != null) {
  //       Get.offAllNamed('/pickUpPage');
  //     } else {
  //       debugPrint("⚠️ Navigation failed: No valid context.");
  //     }
  //   } else {
  //     if (Get.context != null) {
  //       Get.offAllNamed(AmdRoutesClass.authPage);
  //     }
  //   }
  // }

  void validatePhone(String value) {
    final invalidNumbersPattern = RegExp(r'^(.)\1*$');
    if (value.length == 10 && !invalidNumbersPattern.hasMatch(value)) {
      errorMessage.value = "";
      isPhoneValid.value = true;
    } else {
      errorMessage.value = "Enter a valid 10-digit Mobile number";
      isPhoneValid.value = false;
    }
    update();
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

        formattedAddress.value =
        '${place.subLocality ?? 'Unknown Area'}, ${place.locality ?? 'Unknown City'}';

        if (kDebugMode) {
          print("Updated Location: ${formattedAddress.value}");
        }
      }

      // Update UI based on location
      fetchSearchRestaurantsFromGraph(
        newLat: userLatitude,
        newLon: userLongitude,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching location: $e");
      }
    }
  }

  void fetchSearchRestaurantsFromGraph({
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
          "Using New Address Location - Lat: $userLatitude, Lon: $userLongitude",
        );
      } else {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        );
        userLatitude = position.latitude;
        userLongitude = position.longitude;
        print(
          "Using Current Location - Lat: $userLatitude, Lon: $userLongitude",
        );
      }

      // Fetch restaurants from GraphQL
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.queryRestaurantByName(restaurantCuisine.value),
      );

      if (result.data == null || result.data!['restaurants'] == null) {
        print("No restaurant data found.");
        return;
      }

      List jsonString = result.data!['restaurants'] as List;
      print(
        "GraphQL Request Successful. Total Restaurants Found: ${jsonString.length}",
      );

      var temp = GetRestaurantSearch.fromList(jsonString);

      List<String> includedRestaurants = [];
      List<String> excludedRestaurants = [];

      var filteredRestaurants =
      temp.restaurantData?.where((restaurant) {
        if (restaurant.branches == null || restaurant.branches!.isEmpty) {
          return false;
        }

        for (var branch in restaurant.branches!) {
          double restaurantLat = branch.latitude ?? 0.0;
          double restaurantLon = branch.longitude ?? 0.0;

          double distanceFromNew = calculateDistance(
            userLatitude,
            userLongitude,
            restaurantLat,
            restaurantLon,
          );
          double distanceFromOld =
          (oldLat != null && oldLon != null)
              ? calculateDistance(
            oldLat,
            oldLon,
            restaurantLat,
            restaurantLon,
          )
              : double.infinity;

          if (distanceFromNew <= 5.0 || distanceFromOld <= 5.0) {
            includedRestaurants.add(
              "${restaurant.restaurantName} - ${distanceFromNew.toStringAsFixed(2)} km",
            );
            print(
              "Added: ${restaurant.restaurantName} | Distance: ${distanceFromNew.toStringAsFixed(2)} km",
            );
            return true;
          }
        }
        excludedRestaurants.add(
          restaurant.restaurantName ?? "Unknown Restaurant",
        );
        return false;
      }).toList();

      print("\n Restaurants Within 5 KM:");
      includedRestaurants.forEach(print);

      print("\n Restaurants Excluded (Beyond 5 KM):");
      excludedRestaurants.forEach(print);

      print(
        "\n Final Filtered Restaurants Count: ${filteredRestaurants?.length}",
      );

      // Update the restaurant list
      getRestaurantSearch.value = GetRestaurantSearch(
        restaurantData: filteredRestaurants,
      );
    } catch (error, stackTrace) {
      print("Error in fetchSearchRestaurantsFromGraph: $error");
      print("Stack Trace: $stackTrace");
    }
  }

  /// Resend OTP to user
  void resendOTP() async {
    try {
      if (!await validateInputs()) return;
      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.loginRegisterUser(phone.text),
      );
      if (result.data?["registerOrLoginUser"] != null &&
          result.data?['registerOrLoginUser']['success'] == true) {
        userId.value =
        result.data!['registerOrLoginUser']['data']['user']['userId'];

        print("User ID Retrieved from Backend: ${userId.value}");
        otpReceived.value =
        result.data!["registerOrLoginUser"]["data"]["otpCode"];
        resentOTP.value = true;
      }
    } catch (e) {
      debugPrint('Error in resendOTP: $e');
    }
  }

  Future<void> clearSessionData() async {
    await AmdStorage().clearAll();
    await storage.erase();
    userData.value = null;
    userId.value = 0;
    isLoggedIn.value = false;
    Get.offAllNamed(AmdRoutesClass.authPage);
  }


  Future<void> registerUser() async {
    try {
      if (!await validateInputs()) return;

      final result = await GraphQLClientService.fetchData(
        query: GraphQuery.loginRegisterUser(phone.text),
      );

      if (result.data?["registerOrLoginUser"] != null &&
          result.data?['registerOrLoginUser']['success'] == true) {
        userId.value =
        result.data!['registerOrLoginUser']['data']['user']['userId'];

        // Store user data in local storage
        await _storeUserSession(
          result.data!['registerOrLoginUser']['data']['user'],
        );

        if (result
            .data!['registerOrLoginUser']["data"]["user"]["isMobileVerified"]) {
          loginVerifiedUser();
          return;
        }

        otpReceived.value =
        result.data!["registerOrLoginUser"]["data"]["otpCode"];
        Get.to(() => Registration());
      } else {
        _showWarningAlert("E-Mail / User Name is already registered!");
      }
    } catch (e) {
      debugPrint('Error in registerUser: $e');
    }
  }

  // Show a warning alert
  void _showWarningAlert(String message) {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.warning,
      text: message,
      onConfirmBtnTap: () => Get.back(),
      headerBackgroundColor: AppColors.greenColor,
    );
  }

  // Retrieve user session from local storage
  void getUserSession() {
    final storage = GetStorage();

    int? storedUserId = storage.read('userId');
    if (storedUserId != null) {
      userId.value = storedUserId;
      debugPrint("User ID from local storage: $storedUserId");

      // Pass userId to ProfileController
      profileController.setUserId(storedUserId);
    } else {
      debugPrint("Error: No userId found in local storage!");
    }

    String? firstName = storage.read('firstName');
    String? lastName = storage.read('lastName');
    String? email = storage.read('email');
    String? phoneNumber = storage.read('phoneNumber');
    String? gender = storage.read('gender');
    String? dateOfBirth = storage.read('dateOfBirth');
    String? profilePictureUrl = storage.read('profilePictureUrl');

    // Output user session details
    debugPrint("User Details:");
    debugPrint("   - ID: $storedUserId");
    debugPrint("   - Name: $firstName $lastName");
    debugPrint("   - Email: $email");
    debugPrint("   - Phone: $phoneNumber");
    debugPrint("   - Gender: $gender");
    debugPrint("   - DOB: $dateOfBirth");
    debugPrint("   - Profile Pic: $profilePictureUrl");
  }

  // Store user session in local storage
  Future<void> _storeUserSession(Map<String, dynamic> userData) async {
    final storage = GetStorage();

    if (userData['userId'] == null) {
      debugPrint("Error: userId is null in userData, cannot store session.");
      return;
    }

    await storage.write('userId', userData['userId']);
    await storage.write('firstName', userData['firstName']);
    await storage.write('lastName', userData['lastName']);
    await storage.write('email', userData['email']);
    await storage.write('phoneNumber', userData['phoneNumber']);
    await storage.write('gender', userData['gender']);
    await storage.write('dateOfBirth', userData['dateOfBirth']);
    await storage.write('profilePictureUrl', userData['profilePictureUrl']);

    debugPrint("User session stored successfully!");
  }

  // Log in an already verified user
  void loginVerifiedUser() async {
    try {
      // Ensure we load the user session before proceeding
      getUserSession();

      await AmdStorage().createCache('userId', userId.value.toString());
      var userIdCache = await AmdStorage().readCache('userId');
      debugPrint("User ID retrieved from cache: $userIdCache");

      await fetchAndStoreLocation();

      phone.text = "";
      otp.text = "";
      Get.offAllNamed(AmdRoutesClass.dashboardPage);
    } catch (e) {
      debugPrint('Error in loginVerifiedUser: $e');
    }
  }

  // Future<void> fetchUserDetails() async {
  //   try {
  //     isLoading.value = true;
  //     final response = await GraphQLClientService.fetchData(
  //       query: GraphQuery.userDetails(userId.value),
  //     );
  //
  //     if (response.data?["userDetails"] != null) {
  //       userDetails.value = UserData.fromJson(response.data!["userDetails"]);
  //       // profileController.updateProfileFields(userDetails.value!);
  //     }
  //   } catch (e) {
  //     debugPrint('Error in fetchUserDetails: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> fetchUserAddressDetails() async {
    try {
      isLoading.value = true;

      if (userId.value == 0) {
        debugPrint("User ID is 0. Fetching from local storage...");
        final storage = GetStorage();
        int? storedUserId = storage.read('userId');
        if (storedUserId != null) {
          userId.value = storedUserId;
          debugPrint("User ID retrieved from local storage: $storedUserId");
        } else {
          debugPrint("No user ID found in local storage!");
          return;
        }
      }

      debugPrint("Fetching user details for ID: ${userId.value}");

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.userDetailsWithAddress(userId.value),
      );

      debugPrint("API Response: ${response.data}");

      if (response.data?["userDetailsWithAddress"] != null) {
        userAddressDetails.value = UserData.fromJson(
          response.data!["userDetailsWithAddress"],
        );
        debugPrint("User details with address fetched successfully!");
      } else {
        userAddressDetails.value = null;
        debugPrint("No user address data found in API response.");
      }
    } catch (e) {
      debugPrint('Error in fetchUserAddressDetails: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Log in using OTP
  void loginUser() async {
    try {
      if (otp.text.trim().isEmpty || otp.text.trim().length != 6) {
        errorMessage.value = "Please enter a valid OTP";
        userId.value = 0;
        return;
      }

      isLoading.value = true; // Show loader

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.verifyOTP(otp.text, phone.text),
      );

      if (response.data?["verifyOtp"]["success"] == true) {
        if (response.data?["verifyOtp"]["data"]["isVerified"] == true) {
          await AmdStorage().createCache('userId', userId.value.toString());

          print("User ID stored: ${userId.value}");

          // Save login status
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          var userIdCache = await AmdStorage().readCache('userId');
          debugPrint("Verified User ID: $userIdCache");

          await fetchAndStoreLocation();
          phone.text = "";
          otp.text = "";

          if (userIdCache == null || userIdCache.isEmpty || userIdCache == "0") {
            Get.offAllNamed(AmdRoutesClass.authPage);
          } else {
            Get.offAllNamed(AmdRoutesClass.pickUpPage);
          }
        }
      }
    } catch (e) {
      userId.value = 0;
      debugPrint('Error in loginUser: $e');
    } finally {
      isLoading.value = false;
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
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

  // Get the user's current geolocation
  Future<Position?> getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Validate phone number input
  Future<bool> validateInputs() async {
    if (phone.text.isEmpty || phone.text.trim().length != 10) {
      errorMessage.value = "Please enter a valid phone number";
      return false;
    }
    return true;
  }

  // Update DOB
  void updateDOB(DateTime date) {
    dob.text = "${date.year}-${date.month}-${date.day}";
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      // profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await AmdStorage().clearCache();
    print("Logging out user...");
    await storage.erase();
    isLoggedIn.value = false;
    Get.offAllNamed('/authPage');
  }

}
