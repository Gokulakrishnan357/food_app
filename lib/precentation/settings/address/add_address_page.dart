import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zeroq/const/app_colors.dart';
import 'package:zeroq/precentation/settings/address/address_controller.dart';

import '../../../server/app_storage.dart';
import '../../auth/auth_controller.dart';
import 'address_page.dart';
import 'map.dart';

class AddAddressScreen extends GetView<AddressController> {
  AddAddressScreen({super.key});

  @override
  AddressController controller = Get.put(AddressController());
  AuthController controller1 = Get.put(AuthController());
  // ✅ Declare all controllers
  TextEditingController aaddressController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  RxBool isLoading = false.obs;
  String selectedCategory = "";

  LatLng? selectedLocation;

  void _navigateToMap() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final result = await Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder:
              (context) => MapScreen(
                initialLocation: LatLng(position.latitude, position.longitude),
              ),
        ),
      );

      if (result != null && result is Map<String, String>) {
        aaddressController.text = result['address'] ?? '';
        houseNumberController.text = result['houseNumber'] ?? '';
        streetController.text = result['street'] ?? '';
        landmarkController.text = result['landmark'] ?? '';

        // ✅ Populate additional address fields if available
        localityController.text = result['locality'] ?? '';
        cityController.text = result['city'] ?? '';
        stateController.text = result['state'] ?? '';
        postalCodeController.text = result['postalCode'] ?? '';

        selectedLocation = LatLng(
          double.parse(result['latitude'] ?? '0'),
          double.parse(result['longitude'] ?? '0'),
        );

        controller.update();
      }
    } catch (e) {
      Get.snackbar(
        "Location Error",
        "Failed to fetch current location. Please enable location services.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    // ✅ Dispose of controllers to avoid memory leaks
    aaddressController.dispose();
    houseNumberController.dispose();
    streetController.dispose();
    landmarkController.dispose();
    localityController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Address"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: AppColors.greenColor,
          ),
          onPressed: () async {
            if (Get.context != null) {
              await controller.fetchUserDetails1(); // Ensure it completes first
            }
            if (context.mounted) {
              Get.back(); // Use Get.back() to ensure smooth transition
            }
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _navigateToMap,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.locationArrow,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Click here for your current location",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            _buildTextField("Enter the full Address", aaddressController),
            const SizedBox(height: 12),
            _buildTextField("Enter House Number", houseNumberController),
            const SizedBox(height: 12),
            _buildTextField("Enter Street Name", streetController),
            const SizedBox(height: 12),
            _buildTextField("Enter Landmark (Optional)", landmarkController),
            const SizedBox(height: 12),
            _buildTextField("Enter Locality", localityController),
            const SizedBox(height: 12),
            _buildTextField("Enter City", cityController),
            const SizedBox(height: 12),
            _buildTextField("Enter State", stateController),
            const SizedBox(height: 12),
            _buildTextField("Enter Postal Code", postalCodeController),
            const SizedBox(height: 20),

            // ✅ Category Buttons
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCategoryButton(Icons.home, "Home"),
                      const SizedBox(width: 10),
                      _buildCategoryButton(Icons.work, "Work"),
                      const SizedBox(width: 10),
                      _buildCategoryButton(Icons.hotel, "Hotels"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCategoryButton(Icons.people, "Friends & Family"),
                      const SizedBox(width: 10),
                      _buildCategoryButton(Icons.other_houses, "Others"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedLocation != null) {
                    isLoading.value = true;

                    bool isSuccess = await controller.createUserAddress(
                      context,
                      aaddressController.text,
                      controller.selectedCategory.value,
                      houseNumberController.text,
                      streetController.text,
                      landmarkController.text,
                      localityController.text,
                      cityController.text,
                      stateController.text,
                      postalCodeController.text,
                      Decimal.parse(
                        selectedLocation!.latitude.toStringAsFixed(6),
                      ),
                      Decimal.parse(
                        selectedLocation!.longitude.toStringAsFixed(6),
                      ),
                    );

                    if (isSuccess) {
                      if (context.mounted) {
                        controller.userAddressDetails();
                        isLoading.value = false;
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a location on the map!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Save Address",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return Obx(() {
      bool isSelected = controller.selectedCategory.value == label;
      return ElevatedButton.icon(
        onPressed: () {
          controller.updateCategory(label);
        },
        icon: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : Colors.green,
        ),
        label: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: isSelected ? Colors.green : Colors.green),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      );
    });
  }
}
