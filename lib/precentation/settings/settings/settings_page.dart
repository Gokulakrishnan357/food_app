import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/precentation/cart/cart_controller.dart';
import 'package:zeroq/precentation/settings/profile/profile_controller.dart';
import 'package:zeroq/uttility/custom_widget/custom_dialog.dart';
import '../../../Model/UserModel.dart';
import '../../../server/app_storage.dart';
import './settings_controller.dart';


class SettingsPage extends GetView<SettingsController> {
  SettingsPage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final ProfileController profileController = Get.find<ProfileController>();

  final cartController = Get.find<CartController>();
  final storage = GetStorage();

  Future<void> confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Confirmation",
          content: "Are you sure you want to Sign out?",
          onConfirm: () async {
            Navigator.of(context).pop();

            // Clear user data
            await storage.erase();
            await AmdStorage().clearAll();

            // Reset Controllers
            authController.userId.value = 0;
            authController.userDetails.value = null;
            profileController.clearUserData();
            cartController.cart.value = null;

            // Remove login flag
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('isLoggedIn');
            await prefs.remove('userId');

            // Navigate to login page after clearing data
            Get.offAllNamed(AmdRoutesClass.authPage);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    String? phoneNumber = storage.read('phoneNumber');
    return WillPopScope(
      onWillPop: () async {
        // Navigate to pickUpPage when back button is pressed
        Get.offNamed(AmdRoutesClass.pickUpPage);
        // Return false to prevent the app from closing
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 72, 176, 7),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: IconButton(
            onPressed: () {
              Get.offNamed(AmdRoutesClass.pickUpPage);
            },
            icon: const Icon(FontAwesomeIcons.chevronLeft, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            // Green User Card
            // Green User Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 72, 176, 7),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              child: Row(
                children: [
                  // ✅ User Avatar with Shadow
                  Obx(() {
                    String profilePicUrl =
                        profileController
                                .cachedProfilePictureUrl
                                .value
                                .isNotEmpty
                            ? profileController.cachedProfilePictureUrl.value
                            : '';

                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50.0, // Increased size
                        backgroundImage:
                            profileController.profileImage.value != null
                                ? FileImage(
                                      profileController.profileImage.value!,
                                    )
                                    as ImageProvider
                                : (profilePicUrl.isNotEmpty
                                    ? NetworkImage(profilePicUrl)
                                    : const NetworkImage(
                                      "https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fHx8&auto=format&fit=crop&w=880&q=80",
                                    )),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    );
                  }),

                  const SizedBox(width: 15.0), // Space between avatar and text
                  // ✅ User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ User Name
                        Obx(() {
                          // Fetching user profiles
                          List<UserProfiles>? profiles =
                              profileController
                                  .userData
                                  .value
                                  ?.data
                                  ?.userDetailsWithAddress
                                  ?.userProfiles;

                          // Get the first available profile
                          UserProfiles? profile =
                          profiles != null && profiles.isNotEmpty
                              ? profiles.first
                              : null;

                          // Extract firstName & lastName
                          String firstName =
                              profile?.firstName ??
                                  profileController.cachedFirstName.value;
                          String lastName =
                              profile?.lastName ??
                                  profileController.cachedLastName.value;

                          String fullName = '$firstName $lastName'.trim();

                          return Text(
                            fullName.isNotEmpty ? fullName : "Welcome, User..!",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),

                        const SizedBox(height: 8.0),

                        // ✅ Phone Number with Icon
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              color: Colors.white70,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              phoneNumber ?? "",
                              style: GoogleFonts.montserrat(
                                fontSize: 16.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 375.0.w,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        menuItem(
                          "My Profile",
                          FontAwesomeIcons.user,
                          AmdRoutesClass.profilePage,
                          iconSize: 20,
                        ),
                        menuItem(
                          "Your Cart",
                          FontAwesomeIcons.cartShopping,
                          AmdRoutesClass.cartPage,
                          iconSize: 20,
                        ),
                        menuItem(
                          "Your Address",
                          FontAwesomeIcons.house,
                          AmdRoutesClass.addressPage,
                          iconSize: 20,
                        ),
                        menuItem(
                          "Your Orders",
                          FontAwesomeIcons.burger,
                          AmdRoutesClass.userOrdersPage,
                          iconSize: 18,
                        ),
                        menuItem(
                          "Notification",
                          FontAwesomeIcons.bell,
                          "",
                          iconSize: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Sign Out Button
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextButton(
                  onPressed: () => confirmLogout(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Sign Out Icon with Border
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Light grey background
                          borderRadius: BorderRadius.circular(
                            20,
                          ), // Circular border
                        ),
                        child: Icon(
                          Icons.logout,
                          size: 20,
                          color: const Color.fromARGB(255, 34, 179, 48),
                        ),
                      ),
                      const SizedBox(width: 8), // Spacing between icon and text
                      // Sign Out Text (Bold)
                      Text(
                        "Sign Out",
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500, // Bold text
                          color: const Color.fromARGB(255, 70, 70, 70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItem(
    String title,
    IconData icon,
    String route, {
    double iconSize = 20,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: 50.0.h,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () => route.isNotEmpty ? Get.toNamed(route) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      icon,
                      color: const Color.fromARGB(255, 72, 176, 7),
                      size: iconSize,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
