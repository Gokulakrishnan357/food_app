import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/models/user_data_model.dart';

import '../../../Model/UserAddress.dart';

class AddressController extends GetxController {
  var selectedCategory = ''.obs;

  RxBool valuefirst = false.obs;
  RxBool valuesecond = false.obs;
  RxString otpReceived = "".obs;
  RxInt userId = 0.obs;

  RxString currentCity = "Fetching city...".obs;
  RxString formattedAddress = "Fetching address...".obs;
  RxString errorMessage = "".obs;
  RxBool resentOTP = false.obs;
  RxString genderValue = ''.obs;

  RxBool isLoading = false.obs;

  var userDetails = Rxn<UserData>();

  StreamSubscription<Position>? streamSubscription;

  final userAddress = Rx<UserRegularAddress?>(null);

  Timer? _timer;

  final AuthController authController = Get.find<AuthController>();

  var userAddressDetails = Rxn<UserData>();

  @override
  void onInit() {
    super.onInit();
    fetchUserDetails1();
  }

  Future<void> fetchUserDetails1() async {
    try {
      isLoading.value = true;
      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.userDetails(userId.value),
      );

      if (response.data?["userDetails"] != null) {
        var updatedDetails = UserData.fromJson(response.data!["userDetails"]);
        userDetails.value = updatedDetails;
        authController.userAddressDetails.value = updatedDetails;
      }
    } catch (e) {
      debugPrint('Error in fetchUserDetails: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch user address details
  Future<void> fetchUserDetails() async {
    try {
      isLoading.value = true;

      if (authController.userId.value == 0) {
        debugPrint("🚨 User ID is 0, fetching from local storage...");
        final storage = GetStorage();
        int? storedUserId = storage.read('userId');
        if (storedUserId != null) {
          authController.userId.value = storedUserId;
          debugPrint("✅ User ID retrieved: $storedUserId");
        } else {
          debugPrint("❌ No user ID found in local storage!");
          isLoading.value = false;
          return;
        }
      }

      debugPrint(
        "🔍 Fetching address details for user ID: ${authController.userId.value}",
      );

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.userDetailsWithAddress(authController.userId.value),
      );

      debugPrint("📌 API Response: ${response.data}");

      if (response.data?["userDetailsWithAddress"] != null) {
        userAddressDetails.value = UserData.fromJson(
          response.data!["userDetailsWithAddress"],
        );
        debugPrint("✅ Address details fetched successfully!");
      } else {
        userAddressDetails.value = null;
        debugPrint("❌ No address data found.");
      }
    } catch (e) {
      debugPrint('❌ Error fetching address details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserAddressDetails(
    BuildContext context, {
    bool skipRedirection = false,
  }) async {
    try {
      isLoading.value = true;

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.getUserAddressDetails(userId.value),
      );

      if (response.data?['data'] != null) {
        // ✅ Correct JSON parsing
        UserAddress userAddressData = UserAddress.fromJson(
          response.data!['data'],
        );

        // ✅ Assign user details properly
        if (userAddressData.data?.userDetails != null) {
          userDetails.value = UserData.fromJson(
            response.data!['data']['userDetails'],
          );
        } else {
          userDetails.value = null;
        }

        // ✅ Ensure `userRegularAddresses` is initialized
        userDetails.value?.userRegularAddresses =
            (response.data!['data']['userDetails']['userRegularAddresses']
                    as List?)
                ?.map((e) => UserRegularAddress.fromJson(e))
                .toList() ??
            [];

        // ✅ Update `userAddress` only if addresses exist
        userAddress.value =
            userDetails.value!.userRegularAddresses.isNotEmpty
                ? userDetails.value!.userRegularAddresses.first
                : null;

        // ✅ Redirect if user details are missing
        if (!skipRedirection && userDetails.value?.userId == null) {
          Get.offAllNamed('/onboardingPage');
        }

        update();
        userDetails.refresh();
      }
    } catch (e) {
      debugPrint('Error in fetchUserAddressDetails: $e');
    } finally {
      isLoading.value = false; // ✅ Ensure loading state updates correctly
    }
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
    streamSubscription?.cancel();
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> deleteUserAddress(int addressId) async {
    try {
      isLoading.value = true; // Show loading indicator
      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.deleteUserAddress(addressId),
      );
      if (response.data!["deleteUserRegularAddress"]["success"]) {
        Get.snackbar(
          "Success",
          "Address deleted successfully.!",
          backgroundColor: AppColors.greenColor,
          colorText: AppColors.whitetextColor,
        );
        fetchUserDetails();
        isLoading.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<bool> createUserAddress(
    BuildContext context,
    String address,
    String addressType,
    String houseNumber,
    String street,
    String landmark,
    String locality,
    String city,
    String state,
    String postalCode,
    Decimal latitude,
    Decimal longitude,
  ) async {
    try {
      final storage = GetStorage();
      int? storedUserId = storage.read('userId');

      if (storedUserId == null || storedUserId == 0) {
        debugPrint("❌ Invalid userId from storage: $storedUserId");
        return false;
      }

      isLoading.value = true;

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.createUserRegularAddress(
          storedUserId,
          address,
          addressType,
          houseNumber,
          street,
          landmark,
          locality,
          city,
          state,
          postalCode,
          latitude,
          longitude,
        ),
      );

      if (response.data?["createUserRegularAddress"]["success"] == true) {
        final newAddress = UserRegularAddress.fromJson(
          response.data?["createUserRegularAddress"]["data"],
        );

        userDetails.value?.userRegularAddresses.add(newAddress);
        userAddress.value = newAddress;

        if (Get.isSnackbarOpen == false && context.mounted) {
          Get.snackbar(
            "Success",
            "Address added successfully!",
            backgroundColor: AppColors.greenColor,
            colorText: AppColors.whitetextColor,
          );
        }

        Future.delayed(const Duration(seconds: 1), () {
          userDetails();
          userAddressDetails();
        });

        return true;
      } else {
        String message =
            response.data?["createUserRegularAddress"]["message"] ??
            "Failed to add address!";
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error in createUserAddress: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred while adding the address!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserAddress(
    int addressId,
    String address,
    String addressType,
    String houseNumber,
    String houseName,
    String street,
    String landmark,
    String locality,
    String city,
    String state,
    String postalCode,
    Decimal latitude,
    Decimal longitude,
  ) async {
    try {
      isLoading.value = true;

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.updateUserRegularAddress(
          addressId,
          address,
          addressType,
          houseNumber,
          houseName,
          street,
          landmark,
          locality,
          city,
          state,
          postalCode,
          latitude,
          longitude,
        ),
      );

      if (response.data?["updateUserRegularAddress"]["success"] == true) {
        // ✅ Find the address in the list and update it
        int index =
            userDetails.value?.userRegularAddresses.indexWhere(
              (e) => e.addressId == addressId,
            ) ??
            -1;

        if (index != -1) {
          userDetails
              .value
              ?.userRegularAddresses[index] = UserRegularAddress.fromJson(
            response.data?["updateUserRegularAddress"]["data"],
          );
        }

        // ✅ Force GetX to refresh UI
        userDetails.refresh();
        update();

        Get.snackbar(
          "Success",
          "Address updated successfully!",
          backgroundColor: AppColors.greenColor,
          colorText: AppColors.whitetextColor,
        );
      } else {
        String message =
            response.data?["updateUserRegularAddress"]["message"] ??
            "Failed to update address!";
        Get.snackbar("Error", message, backgroundColor: Colors.red);
      }
    } catch (e) {
      debugPrint('Error: $e');
      Get.snackbar(
        "Error",
        "An error occurred while updating address!",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
