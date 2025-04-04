import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/precentation/cart/cart_controller.dart';
import 'package:zeroq/precentation/pick_up/pick_up_controller.dart';
import 'package:zeroq/precentation/pick_up/toogleswitch.dart';
import '../../../../const/app_exports.dart';
import '../../../../models/cart/local_cart_items.dart';
import '../../../../models/restaurant_models/restaurand_by_id_model.dart';
import './hotel_menu_controller.dart';

class HotelMenuPage extends GetView<HotelMenuController> {
  // Initialize authController
  final HotelMenuController menuController = Get.put(HotelMenuController());
  @override
  final HotelMenuController controller = Get.put(HotelMenuController());
  final AuthController authController = Get.put(AuthController());
  final CartController cartController = Get.put(CartController());
  final PickUpController controller1 = Get.put(PickUpController());

  HotelMenuPage({super.key});

  String? _getMaxPreparationTime(RestaurantDatum? restaurantData) {
    if (restaurantData == null) return null;

    List<int> preparationTimes = [];

    for (var category in restaurantData.categories ?? []) {
      for (var menu in category.menus ?? []) {
        if (menu.preparationTime != null) {
          // Extract numbers from the preparationTime string
          final match = RegExp(r'\d+').firstMatch(menu.preparationTime!);
          final time =
              match?.group(0) != null ? int.tryParse(match!.group(0)!) : null;

          if (time != null) {
            preparationTimes.add(time);
          }
        }
      }
    }

    if (preparationTimes.isNotEmpty) {
      return "${preparationTimes.reduce((a, b) => a > b ? a : b)} MINS";
    }

    return null;
  }

  String? _getDeliveryTime(RestaurantDatum? restaurantData) {
    if (restaurantData == null) return null;

    List<int> preparationTimes = [];

    for (var category in restaurantData.categories ?? []) {
      for (var menu in category.menus ?? []) {
        if (menu.preparationTime != null) {
          // Extract numbers from the preparationTime string
          final match = RegExp(r'\d+').firstMatch(menu.preparationTime!);
          final time =
              match?.group(0) != null ? int.tryParse(match!.group(0)!) : null;

          if (time != null) {
            preparationTimes.add(time);
          }
        }
      }
    }

    if (preparationTimes.isNotEmpty) {
      return "${preparationTimes.reduce((a, b) => a > b ? a : b)} MINS";
    }

    return null;
  }

  String getNearestRestaurantDistance(
    double userLat,
    double userLng,
    RestaurantDatum restaurantData,
  ) {
    double minDistance = double.infinity;

    for (var branch in restaurantData.branches ?? []) {
      if (branch.latitude != null && branch.longitude != null) {
        double distance = _calculateDistance(
          userLat,
          userLng,
          branch.latitude!,
          branch.longitude!,
        );
        if (distance < minDistance) minDistance = distance;
      }
    }

    return minDistance != double.infinity
        ? "${minDistance.toStringAsFixed(1)} KM"
        : "3.0 KM";
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double R = 6371; // Radius of Earth in KM
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    controller.userSearchQueryForMenuItems.value = "";
    // var data = Get.arguments;
    ScreenUtil.init(context, designSize: const Size(375, 812));

    final ScrollController hotelMenuScrollController = ScrollController();
    // Make sure the menu data is fetched
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRestaurantsByIdFromGraph();
      controller.fetchRestaurantsMenuById();
    });

    final cartController = Get.put(CartController());
    final pickUpController = Get.put(PickUpController());
    // double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 55.0),
          child: SizedBox(
            height: 812.0.w,
            width: 375.0.w,
            child: SingleChildScrollView(
              controller: hotelMenuScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Use Obx to update the UI when data changes
                  Obx(() {
                    final restaurantData =
                        controller.getRestaurantById.value.restaurantData;

                    if (restaurantData == null || restaurantData.isEmpty) {
                      return const Center(child: Text('No restaurants found.'));
                    }

                    return Padding(
                      padding: EdgeInsets.only(top: 18.0.w, left: 24.0.w),
                      child: SizedBox(
                        width: 327.0.w,
                        height: 289.0.w,
                        child: Stack(
                          children: [
                            // hotel image section
                            Positioned(
                              child: Container(
                                width: 327.0.w,
                                height: 180.0.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0.w),
                                  image:
                                      controller
                                                  .getRestaurantById
                                                  .value
                                                  .restaurantData![0]
                                                  .imageUrl !=
                                              null
                                          ? DecorationImage(
                                            image: NetworkImage(
                                              controller
                                                  .getRestaurantById
                                                  .value
                                                  .restaurantData![0]
                                                  .imageUrl
                                                  .toString(),
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                          : const DecorationImage(
                                            image: AssetImage(
                                              "assets/icons/No_Image_Available.png",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 10.0.w,
                                      top: 10.0.w,
                                      child: InkWell(
                                        onTap: () {
                                          Future.delayed(
                                            Duration(milliseconds: 200),
                                            () {
                                              Get.offNamed(
                                                '/pickUpPage',
                                              ); // Redirects to pickUpPage after a short delay
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 30.0.w,
                                          height: 30.0.w,
                                          decoration: const ShapeDecoration(
                                            color: Colors.white,
                                            shape: OvalBorder(),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x26000000),
                                                blurRadius: 30,
                                                offset: Offset(12, 12),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.arrowLeft,
                                            size: 15.0.w,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // hotel name and offer section
                            Positioned(
                              bottom: 0.0.w,
                              child: SizedBox(
                                width: 320.0.w,
                                height: 100.0.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 🍽 Restaurant Name
                                    Flexible(
                                      child: Text(
                                        controller
                                                .getRestaurantById
                                                .value
                                                .restaurantData
                                                ?.first
                                                .restaurantName ??
                                            "Restaurant Name",
                                        maxLines: 3,
                                        softWrap: true,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.3,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 5.0.w),
                                    // 🍜 Cuisine Type & Price for Two
                                    Row(
                                      mainAxisSize:
                                          MainAxisSize
                                              .min, // Prevent Row from taking more space than needed
                                      children: [
                                        Icon(
                                          Icons.food_bank_outlined,
                                          size: 15.0.w,
                                          color: AppColors.greenColor,
                                        ),
                                        SizedBox(width: 5.0.w),
                                        Expanded(
                                          // Allow this to resize within available space
                                          child: RichText(
                                            text: TextSpan(
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12.0.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                height: 1.2,
                                              ),
                                              children: [
                                                // Cuisine Type
                                                TextSpan(
                                                  text:
                                                      controller
                                                                      .getRestaurantById
                                                                      .value
                                                                      .restaurantData
                                                                      ?.first
                                                                      .cuisineType !=
                                                                  null &&
                                                              controller
                                                                  .getRestaurantById
                                                                  .value
                                                                  .restaurantData!
                                                                  .first
                                                                  .cuisineType!
                                                                  .isNotEmpty
                                                          ? controller
                                                              .getRestaurantById
                                                              .value
                                                              .restaurantData!
                                                              .first
                                                              .cuisineType!
                                                              .map(
                                                                (cuisine) =>
                                                                    cuisine
                                                                        .name,
                                                              )
                                                              .join(", ")
                                                          : "Chinese",
                                                ),
                                                // Bigger Bullet Point
                                                TextSpan(
                                                  text: "  •  ",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 16.0.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // Minimum Limit Per Person
                                                TextSpan(
                                                  text:
                                                      "${controller.getRestaurantById.value.restaurantData?.first.minimumLimitofPerPerson ?? '200'} for one person",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10.0.w),

                                    // 🕒 Delivery Time & 📍 Distance
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_filled,
                                          size: 15.0.w,
                                          color: AppColors.greenColor,
                                        ),
                                        SizedBox(width: 5.0.w),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              text:
                                                  _getMaxPreparationTime(
                                                    restaurantData.first,
                                                  ) ??
                                                  "25-30 MINS",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 11.0.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        SizedBox(width: 15.0.w),

                                        // 📍 Distance
                                        FutureBuilder<Position?>(
                                          future:
                                              HotelMenuController.getUserLocation(),
                                          builder: (context, snapshot) {
                                            String distanceText =
                                                "Location Fetching..";

                                            if (snapshot.connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.hasData) {
                                              double userLat =
                                                  snapshot.data!.latitude;
                                              double userLng =
                                                  snapshot.data!.longitude;
                                              distanceText =
                                                  getNearestRestaurantDistance(
                                                    userLat,
                                                    userLng,
                                                    restaurantData.first,
                                                  );
                                            }

                                            return Row(
                                              children: [
                                                ColorFiltered(
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                        Color.fromARGB(
                                                          255,
                                                          83,
                                                          162,
                                                          34,
                                                        ),
                                                        BlendMode.srcIn,
                                                      ),
                                                  child: SvgPicture.asset(
                                                    "assets/images/delivery.svg",
                                                    width: 18,
                                                    height: 16,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4.0.w,
                                                ), // Space between icon and text
                                                Text(
                                                  distanceText,
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12.0.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    height: 1.2,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 15.0.w),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomToggleSwitch(),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ), // Move everything to the right
                    child: Row(
                      children: [
                        // Search bar with limited width
                        Container(
                          padding: const EdgeInsets.only(
                            left: 6,
                          ), // Inner padding

                          height: 50.0,
                          width: 276, // Reduced width
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Search your favorite food',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 5,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(
                                  12.0,
                                ), // Adjust padding as needed
                                child: Image.asset(
                                  'assets/images/search1.png', // Replace with your image path
                                  width: 16,
                                  height: 16,
                                  color: Color(
                                    0xFF858585,
                                  ), // Apply color if needed
                                ),
                              ),
                              hintStyle: GoogleFonts.montserrat(
                                color: const Color(0xFF555555),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onChanged: (value) {
                              controller.userSearchQueryForMenuItems.value =
                                  value;
                            },
                          ),
                        ),

                        const SizedBox(width: 10), // Add space between elements
                        // Menu Dropdown with fixed width
                        Container(
                          width: 80, // Adjust width as needed
                          height: 90,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: MenuDropdown(),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Divider(
                      color: Color(0xFFD4D4D4),
                      height: 2.0.w,
                      thickness: 2.0.w,
                    ),
                  ),

                  // List of Menu Items
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5.0.w,
                      left: 8.0.w,
                      right: 8.0.w,
                    ),
                    child: Obx(
                      () =>
                          controller
                                          .getRestaurantMenusById
                                          .value
                                          .data
                                          ?.restaurants !=
                                      null &&
                                  controller
                                      .getRestaurantMenusById
                                      .value
                                      .data!
                                      .restaurants!
                                      .isNotEmpty
                              ? controller.filteredMenuItem.isEmpty
                                  ? const Center(
                                    child: Text('No matching items found.'),
                                  )
                                  : ListView.builder(
                                    itemCount:
                                        controller.filteredMenuItem.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var data =
                                          controller.filteredMenuItem[index];
                                      return Column(
                                        children: [
                                          SingleChildScrollView(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SingleChildScrollView(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Food item details (name, description, price, and veg/non-veg logo)
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Dynamic logo for veg/non-veg
                                                        Container(
                                                          width: 15.0.w,
                                                          height: 25.0.w,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage(
                                                                data.isVeg
                                                                    ? "assets/icons/veg1.png"
                                                                    : "assets/icons/nonVeg.png",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.0.w),
                                                        // Food item name
                                                        AmdText(
                                                          text: data.name!,
                                                          color:
                                                              AppColors
                                                                  .blackColor,
                                                          size: 15.0.sp,
                                                          weight:
                                                              FontWeight.w700,
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style:
                                                              FontStyle.normal,
                                                          height: 1.2,
                                                        ),
                                                        SizedBox(height: 8.0.w),
                                                        // Food item description
                                                        AmdText(
                                                          text:
                                                              data.description!,
                                                          color:
                                                              AppColors
                                                                  .blackColor,
                                                          size: 13.0.sp,
                                                          weight:
                                                              FontWeight.w400,
                                                          maxLines: 3,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style:
                                                              FontStyle.normal,
                                                          height: 1.2,
                                                        ),
                                                        SizedBox(height: 8.0.w),
                                                        // Food item price
                                                        AmdText(
                                                          text:
                                                              "₹ ${data.price}",
                                                          color:
                                                              AppColors
                                                                  .blackColor,
                                                          size: 14.0.sp,
                                                          weight:
                                                              FontWeight.w700,
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style:
                                                              FontStyle.normal,
                                                          height: 1.2,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 16.0.w,
                                                  ), // Spacing between details and image
                                                  // Food item image from API
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width:
                                                            100.0
                                                                .w, // Set width to 100
                                                        height:
                                                            100.0
                                                                .h, // Set height to 100
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4.0.w,
                                                              ),
                                                          image:
                                                              data.imageUrl !=
                                                                          null &&
                                                                      data
                                                                          .imageUrl!
                                                                          .isNotEmpty
                                                                  ? DecorationImage(
                                                                    image: NetworkImage(
                                                                      data.imageUrl!
                                                                          .trim(),
                                                                    ),
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                    onError:
                                                                        (
                                                                          _,
                                                                          __,
                                                                        ) => print(
                                                                          "Failed to load image: ${data.imageUrl}",
                                                                        ),
                                                                  )
                                                                  : const DecorationImage(
                                                                    image: AssetImage(
                                                                      "assets/icons/No_Image_Available.png",
                                                                    ),
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                  ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8.0.w,
                                                      ), // Spacing between image and add button
                                                      // Add to cart button or quantity selector
                                                      Obx(() {
                                                        CartItems? foundItem;
                                                        int existingIndex =
                                                            cartController
                                                                .cart
                                                                .value
                                                                ?.cartItems
                                                                .indexWhere(
                                                                  (item) =>
                                                                      item.menuId ==
                                                                      data.menuId,
                                                                ) ??
                                                            -1;

                                                        if (existingIndex !=
                                                            -1) {
                                                          foundItem =
                                                              cartController
                                                                  .cart
                                                                  .value
                                                                  ?.cartItems[existingIndex];
                                                        }
                                                        return existingIndex !=
                                                                    -1 &&
                                                                foundItem !=
                                                                    null
                                                            ? Container(
                                                              height: 34.0.w,
                                                              width:
                                                                  90.0.w, // Ensuring a controlled width
                                                              decoration: BoxDecoration(
                                                                gradient: const LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                      0xFF428813,
                                                                    ),
                                                                    Color(
                                                                      0xFF6ACB29,
                                                                    ),
                                                                  ],
                                                                  begin:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  end:
                                                                      Alignment
                                                                          .centerRight,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                              child: SizedBox(
                                                                width:
                                                                    double
                                                                        .infinity, // Ensures Row does not exceed its parent
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Flexible(
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          cartController.decreaseQuantity(
                                                                            foundItem!,
                                                                            1,
                                                                          );
                                                                        },
                                                                        behavior:
                                                                            HitTestBehavior.opaque,
                                                                        child: Padding(
                                                                          padding: EdgeInsets.all(
                                                                            8.0,
                                                                          ), // Adjust touch area
                                                                          child: Icon(
                                                                            FontAwesomeIcons.minus,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                18.0.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Center(
                                                                        child: AmdText(
                                                                          text:
                                                                              '${foundItem.quantity}',
                                                                          size:
                                                                              16.0.sp,
                                                                          color:
                                                                              Colors.white,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          weight:
                                                                              FontWeight.w800,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          cartController.increaseQuantity(
                                                                            foundItem!,
                                                                            1,
                                                                          );
                                                                        },
                                                                        behavior:
                                                                            HitTestBehavior.opaque,
                                                                        child: Padding(
                                                                          padding: EdgeInsets.all(
                                                                            8.0,
                                                                          ), // Adjust touch area
                                                                          child: Icon(
                                                                            FontAwesomeIcons.plus,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                18.0.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                            : InkWell(
                                                              onTap: () {
                                                                if (authController
                                                                        .userId
                                                                        .value ==
                                                                    0) {
                                                                  Get.offAllNamed(
                                                                    AmdRoutesClass
                                                                        .authPage,
                                                                  );
                                                                  return;
                                                                }

                                                                final restaurants =
                                                                    controller
                                                                        .getRestaurantMenusById
                                                                        .value
                                                                        .data
                                                                        ?.restaurants;
                                                                if (restaurants ==
                                                                        null ||
                                                                    restaurants
                                                                        .isEmpty) {
                                                                  print(
                                                                    "No restaurant data found.",
                                                                  );
                                                                  return;
                                                                }

                                                                final restaurant =
                                                                    restaurants
                                                                        .first;
                                                                final restaurantName =
                                                                    restaurant
                                                                        .restaurantName ??
                                                                    "Unknown Restaurant";
                                                                final restaurantId =
                                                                    restaurant
                                                                        .restaurantId ??
                                                                    0;

                                                                final menu =
                                                                    data;
                                                                final restaurantMenuId =
                                                                    menu.menuId ??
                                                                    0;
                                                                final restaurantMenuName =
                                                                    menu.name ??
                                                                    "Unknown Menu";
                                                                final description =
                                                                    menu.description ??
                                                                    "";
                                                                final restaurantMenuImage =
                                                                    menu.imageUrl ??
                                                                    "";
                                                                final price =
                                                                    menu.price ??
                                                                    0.0;
                                                                final imageUrl =
                                                                    menu.imageUrl ??
                                                                    "";

                                                                if (restaurantId ==
                                                                        0 ||
                                                                    restaurantMenuId ==
                                                                        0) {
                                                                  print(
                                                                    "Invalid restaurant or menu ID, cannot proceed.",
                                                                  );
                                                                  return;
                                                                }

                                                                pickUpController
                                                                        .restaurantId
                                                                        .value =
                                                                    restaurantId;
                                                                pickUpController
                                                                        .restaurantMenuId
                                                                        .value =
                                                                    restaurantMenuId;
                                                                pickUpController
                                                                    .quantity
                                                                    .value = 1;
                                                                pickUpController
                                                                        .price
                                                                        .value =
                                                                    price;
                                                                pickUpController
                                                                    .addToCart();

                                                                cartController
                                                                        .restaurantIdState
                                                                        .value =
                                                                    restaurantId;
                                                                cartController.addToCart(
                                                                  restaurantMenuId,
                                                                  restaurantId,
                                                                  restaurantMenuName,
                                                                  description,
                                                                  restaurantMenuImage,
                                                                  price,
                                                                  1,
                                                                  0.0,
                                                                  0.0,
                                                                  imageUrl,
                                                                  restaurantName,
                                                                );
                                                              },
                                                              child: Container(
                                                                height: 30.0.w,
                                                                width: 85.0.w,
                                                                decoration: BoxDecoration(
                                                                  gradient:
                                                                      authController.userId.value ==
                                                                              0
                                                                          ? const LinearGradient(
                                                                            colors: [
                                                                              Color(
                                                                                0xFFD32F2F,
                                                                              ), // Red gradient for logged out
                                                                              Color(
                                                                                0xFFEF5350,
                                                                              ),
                                                                            ],
                                                                            begin:
                                                                                Alignment.centerLeft,
                                                                            end:
                                                                                Alignment.centerRight,
                                                                          )
                                                                          : const LinearGradient(
                                                                            colors: [
                                                                              Color(
                                                                                0xFF428813,
                                                                              ), // Green gradient for logged in
                                                                              Color(
                                                                                0xFF6ACB29,
                                                                              ),
                                                                            ],
                                                                            begin:
                                                                                Alignment.centerLeft,
                                                                            end:
                                                                                Alignment.centerRight,
                                                                          ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8.0,
                                                                      ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Add",
                                                                    style: GoogleFonts.montserrat(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                      }),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (index <
                                              controller
                                                      .filteredMenuItem
                                                      .length -
                                                  1)
                                            Divider(
                                              color: const Color.fromARGB(
                                                128,
                                                167,
                                                165,
                                                165,
                                              ),
                                              height: 2.0.w,
                                              thickness: 2.0.w,
                                            ),
                                        ],
                                      );
                                    },
                                  )
                              : Center(
                                child: Image.asset(
                                  "assets/images/load2.gif",
                                  width: 85, // Fixed width
                                  height: 85, // Fixed height
                                  fit: BoxFit.contain,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () =>
            cartController.cart.value != null &&
                    cartController.cart.value!.cartItems.isNotEmpty
                ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: InkWell(
                    child: Container(
                      width: double.infinity, // Full width
                      height: 65.0.w, // Adjust height
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF418612),
                            Color(0xFF6BCC29),
                          ], // ✅ Updated Gradient Colors
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          4.0.w,
                        ), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ✅ Cart Item Count
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: AmdText(
                              text:
                                  "${cartController.cart.value!.cartItems.length} Item${cartController.cart.value!.cartItems.length > 1 ? 's' : ''} Added",
                              color: Colors.white,
                              textStyle: GoogleFonts.manrope(),
                              size: 15.0.sp,
                              weight: FontWeight.w600,
                            ),
                          ),

                          // ✅ View Cart Button with Icon
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(AmdRoutesClass.cartPage);
                              },
                              borderRadius: BorderRadius.circular(10.0.w),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.0.w,
                                  vertical: 8.0.w,
                                ),
                                margin: EdgeInsets.only(right: 10.0.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0.w),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/Vector.png', // Replace with your image path
                                      width: 10.67.w, // Adjust width as needed
                                      height:
                                          13.33.w, // Adjust height as needed
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 5.0.w),
                                    AmdText(
                                      text: "View Cart",
                                      color: AppColors.greenColor,
                                      textStyle: GoogleFonts.manrope(),
                                      size: 12.0.sp,
                                      weight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : const SizedBox(), // Hide FAB if no items in cart
      ),
    );
  }

  Widget dividerContainer() {
    return SizedBox(
      height: 20.0.w,
      width: 327.0.w,
      child: Stack(
        children: [
          Positioned(
            top: 10.0.w,
            left: 0.0.w,
            child: SizedBox(
              width: 137.0.w,
              child: Divider(
                color: AppColors.textFieldLabelColor,
                height: 0.0.w,
                thickness: 1.0.w,
              ),
            ),
          ),
          Positioned(
            top: 10.0.w,
            right: 0.0.w,
            child: SizedBox(
              width: 137.0.w,
              child: Divider(
                color: AppColors.textFieldLabelColor,
                height: 0.0.w,
                thickness: 1.0.w,
              ),
            ),
          ),
          // Stack(
          //   children: [
          //     Positioned(
          //       left: 143.0.w,
          //       child: SizedBox(
          //         width: 42.0.w,
          //         height: 20.0.w,
          //         child: AmdText(
          //           text: "Menu",
          //           color: AppColors.blackColor,
          //           size: 14.0.sp,
          //           weight: FontWeight.w600,
          //           style: FontStyle.normal,
          //           height: 1.2,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class MenuDropdown extends StatefulWidget {
  const MenuDropdown({super.key});

  @override
  _MenuDropdownState createState() => _MenuDropdownState();
}

class _MenuDropdownState extends State<MenuDropdown> {
  OverlayEntry? overlayEntry;
  bool isMenuOpen = false;
  final HotelMenuController controller = Get.put(HotelMenuController());
  final RxString selectedCategory = "".obs;

  @override
  void initState() {
    super.initState();
    selectedCategory.value = "";
    controller.selectedCategory.value = "";
  }

  void _toggleMenu(BuildContext context) {
    if (isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu(context);
    }
  }

  void _openMenu(BuildContext context) {
    final overlay = Overlay.of(context);
    overlayEntry = _createOverlayEntry();
    overlay.insert(overlayEntry!);
    setState(() {
      isMenuOpen = true;
    });
  }

  void _closeMenu() {
    overlayEntry?.remove();
    overlayEntry = null;
    setState(() {
      isMenuOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeMenu,
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              ),
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 280,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _categoryItem("All", ""),
                            const Divider(color: Colors.white24),
                            ...controller
                                    .getRestaurantMenusById
                                    .value
                                    .data
                                    ?.restaurants
                                    ?.expand(
                                      (restaurant) =>
                                          restaurant.categories ?? [],
                                    )
                                    .map(
                                      (category) => _categoryItem(
                                        category.categoryName ?? "Unknown",
                                        category.categoryName ?? "",
                                      ),
                                    )
                                    .toList() ??
                                [],
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: _closeMenu,
                        child: Container(
                          width: 290,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              " Close",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _categoryItem(String title, String value) {
    return GestureDetector(
      onTap: () {
        selectedCategory.value = value;
        controller.selectedCategory.value = value;
        _closeMenu();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            color: selectedCategory.value == value ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Ensures the Stack has a bounded size
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => _toggleMenu(context),
              child: Container(
                height: 48,
                width: 49,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // Assign the gradient correctly
                    colors: [
                      Color(0xFF428813), // Green gradient for logged in
                      Color(0xFF6ACB29),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/menu.svg",
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Menu",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
