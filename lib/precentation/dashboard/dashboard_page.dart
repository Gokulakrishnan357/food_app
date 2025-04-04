import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/restaurant_models/restaurant_search_model.dart';
import 'package:zeroq/precentation/pick_up/toogleswitch.dart';
import 'package:zeroq/uttility/custom_widget/custom_drawer.dart';
import '../pick_up/SearchBarScreen.dart';
import '../pick_up/components/CategorySearch.dart';
import '../pick_up/components/hotel_menu/hotel_menu_controller.dart';
import '../pick_up/pick_up_controller.dart';
import '../settings/address/LiveLocationMap.dart';
import '../settings/profile/profile_controller.dart';
import 'package:zeroq/precentation/pick_up/SearchBarScreen.dart' as search_screen;
import 'package:zeroq/precentation/pick_up/components/CategorySearch.dart' as category_search;


class DashboardPage extends GetView<PickUpController> {
  DashboardPage({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _navigateToMap() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final result = await Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder:
              (context) => LiveLocationMap(
            initialLocation: LatLng(position.latitude, position.longitude),
          ),
        ),
      );

      if (result != null && result is Map<String, String>) {
        // Handle the selected location result
        debugPrint("Selected Location: ${result['address']}");
        debugPrint(
          "Latitude: ${result['latitude']}, Longitude: ${result['longitude']}",
        );

        // You can store or update the selected location accordingly
      }
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  Widget twoRowSlidingGrid(
      BuildContext context,
      List<Map<String, dynamic>> items,
      Function(String) onCategorySelected,
      ) {
    return SizedBox(
      height: 210, // Adjusted height for compact layout
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 rows
          crossAxisSpacing: 5, // Reduced spacing between columns
          mainAxisSpacing: 9.5, // Reduced vertical spacing
          mainAxisExtent: 85, // Adjusted width for tighter fit
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          final categoryName =
              item["categoryName"]?.trim() ?? "Default Category";

          return GestureDetector(
            onTap: () {
              if (categoryName.isNotEmpty &&
                  categoryName != "Default Category") {
                Get.to(() => SearchBarScreen2(categoryName: categoryName,));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centering items
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child:
                  item["image"].contains("http")
                      ? CachedNetworkImage(
                    imageUrl: item["image"],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF58B01F),
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget:
                        (context, url, error) => Image.asset(
                      "assets/icons/No_Image_Available.png",
                      width: 70,
                      height: 70,
                    ),
                  )
                      : Image.asset(
                    item["image"],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ), // Reduced spacing between image & text
                SizedBox(
                  width: 85, // Increased text box width
                  child: Text(
                    item["name"] ?? "Unknown",
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String? _getMaxPreparationTime(RestaurantData storeData) {
    List<int> preparationTimes = [];

    for (var category in storeData.categories ?? []) {
      for (var menu in category.menus ?? []) {
        if (menu.preparationTime != null) {
          // Extract numbers from the preparationTime string
          final time = int.tryParse(
            RegExp(r'\d+').firstMatch(menu.preparationTime!)?.group(0) ?? '',
          );
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
      double userLong,
      RestaurantData storeData,
      ) {
    double minDistance = double.infinity;

    for (var branch in storeData.branches ?? []) {
      if (branch.latitude != null && branch.longitude != null) {
        double distance = _calculateDistance(
          userLat,
          userLong,
          branch.latitude!,
          branch.longitude!,
        );
        if (distance < minDistance) {
          minDistance = distance;
        }
      }
    }

    // If a valid distance was found, format it with one decimal place
    return minDistance != double.infinity
        ? "${minDistance.toStringAsFixed(1)} KM"
        : "2.5 KM";
  }

  double _calculateDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const double R = 6371; // Earth's radius in KM
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
    final ProfileController profileController = Get.find<ProfileController>();

    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    // Ensure fresh instance of controller
    if (!Get.isRegistered<PickUpController>()) {
      Get.put(PickUpController());
    }

    final controller = Get.find<PickUpController>();
    final hotelMenuController = Get.put(HotelMenuController());

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.whitetextColor,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.fromLTRB(9, 2, 2, 2),
          child: IconButton(
            onPressed: () {
              controller.fetchAndStoreLocation();
            },
            icon: Image.asset('assets/icons/locationicon.png'),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
                  () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AmdText(
                    text: controller.currentCity.value,
                    size: 15.0.sp,
                    color: const Color(0xFF2D2A2A),
                    weight: FontWeight.w600,
                  ),
                  SizedBox(width: 8.0.w),
                  GestureDetector(
                    onTap: _navigateToMap,
                    behavior: HitTestBehavior.translucent,
                    child: Image.asset(
                      'assets/icons/Downarrow.png',
                      width: 14.0.w,
                      height: 14.0.w,
                      fit: BoxFit.contain,
                    ),
                  ),

                ],
              ),
            ),
            Obx(
                  () => AmdText(
                text:
                controller.formattedAddress.value, // Automatically updates
                color: const Color(0xFF5D5B5B),
                weight: FontWeight.w600,
                size: 10.0.sp,
                maxLines: 1,
              ),
            ),
          ],
        ),
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Get.offNamed(
                AmdRoutesClass.settingsPage,
              ); //Profile image click button
            },
            child: Padding(
              padding: EdgeInsets.only(right: 25.0.w),
              child: Container(
                width: 34.0.w,
                height: 34.0.w,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image:
                    profileController.profileImage.value != null
                        ? FileImage(profileController.profileImage.value!)
                    as ImageProvider
                        : (profileController
                        .cachedProfilePictureUrl
                        .value
                        .isNotEmpty)
                        ? NetworkImage(
                      profileController.cachedProfilePictureUrl.value,
                    )
                        : const AssetImage(
                      AppImageStrings.appAppBarUserImage,
                    )
                    as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
              MediaQuery.of(context).size.width *
                  0.025, // Responsive padding
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                            MediaQuery.of(context).size.width *
                                0.025, // Responsive padding
                          ), // Decrease width on both sides
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchBarScreen(
                                    categoryName: '',
                                    controller: Get.find<search_screen.FilterChipController1>(), // Using alias here
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F4),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // Reduced corner radius
                              ),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  style: GoogleFonts.montserrat(
                                    color: Color(0xFF858585),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search your food',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 10.0,
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'assets/images/search1.png',
                                        width: 16,
                                        height: 16,
                                        color: Color(0xFF858585),
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.mic_none_outlined,
                                        color: Color(0xFF858585),
                                      ),
                                      onPressed: () {
                                        // Implement voice search functionality here
                                      },
                                    ),
                                    hintStyle: GoogleFonts.montserrat(
                                      color: const Color(0xFF555555),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    controller.restaurantCuisine.value = value;
                                    controller.fetchallRestaurantsFromGraph();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomToggleSwitch(),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: EdgeInsets.only(top: 26.0.w, bottom: 20.w),
                  child: Obx(() {
                    // Fetch categories
                    final categories = controller.getCategories;

                    // Debugging: Print category details
                    print(
                      categories
                          .map(
                            (category) =>
                        "Category: ${category.categoryName}, Image: ${category.imageUrl}",
                      )
                          .toList(),
                    );

                    if (categories.isEmpty) {
                      return Center(
                        child: Image.asset("assets/images/load.gif"),
                      );
                    }

                    // Convert API categories to expected format

                    List<Map<String, String>> categoryItems =
                    categories
                        .map(
                          (category) => {
                        "categoryName":
                        category.categoryName ?? "Default Category",
                        "name": category.categoryName ?? "Unknown",
                        "image":
                        (category.imageUrl?.isNotEmpty == true)
                            ? category.imageUrl!.startsWith("http")
                            ? category.imageUrl!
                            : "https://foodapp.digipintechnology.com/images/categories/${category.imageUrl!}" // Ensure full URL
                            : "assets/icons/No_Image_Available.png",
                      },
                    )
                        .toList();

                    print("Category Image URLs:");
                    categories.forEach((category) {
                      print(category.imageUrl);
                    });

                    print(
                      "Mapped categoryItems: ${categoryItems.map((item) => item.toString()).toList()}",
                    );
                    return Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              "Top food for you",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xFF777E90),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                                indent: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: twoRowSlidingGrid(context, categoryItems, (
                              selectedCategory,
                              ) {
                            print("Selected Category: $selectedCategory");

                            // Clear previous restaurant list before fetching
                            controller.getCategoryRestaurants.clear();

                            // Fetch restaurants based on selected category
                            if (selectedCategory.isNotEmpty &&
                                selectedCategory != "Default Category") {
                              controller.fetchRestaurantsByCategory(
                                selectedCategory,
                              );
                            } else {
                              print(
                                "Invalid category selected, skipping fetch!",
                              );
                            }
                          }),
                        ),
                      ],
                    );
                  }),
                ),

                SizedBox(height: 10.0.w),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      "Top Restaurants",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: const Color(0xFF777E90),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        indent: 10,
                      ),
                    ),
                  ],
                ),

                // Restaurant Grid
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 30.0.w, 1.w, 5.w),
                  child: Obx(() {
                    return controller
                        .getRestaurantSearch
                        .value
                        .restaurantData ==
                        null
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.greenColor,
                      ),
                    )
                        : controller
                        .getRestaurantSearch
                        .value
                        .restaurantData!
                        .isEmpty
                        ? Center(
                      child: Text(
                        "No Restaurants found for this location",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF777E90),
                        ),
                      ),
                    )
                        : GridView.builder(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 24.0,
                        mainAxisSpacing: 24.0,
                        mainAxisExtent: 220.0.w,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                      controller
                          .getRestaurantSearch
                          .value
                          .restaurantData!
                          .length,
                      padding: EdgeInsets.only(right: 17.0.w),
                      primary: true,
                      itemBuilder: (context, index) {
                        var storeData =
                        controller
                            .getRestaurantSearch
                            .value
                            .restaurantData![index];

                        return InkWell(
                          onTap: () {
                            hotelMenuController.restaurantId.value =
                                storeData.restaurantId.toString();
                            hotelMenuController
                                .fetchRestaurantsMenuByIdFromGraph();
                            hotelMenuController
                                .fetchRestaurantsByIdFromGraph();

                            Future.delayed(
                              const Duration(milliseconds: 500),
                                  () {
                                Get.toNamed(AmdRoutesClass.hotelMenuPage);
                              },
                            );
                          },
                          child: SizedBox(
                            width: 155.0.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image Container
                                Container(
                                  width: 155.0.w,
                                  height: 112.0.w,
                                  decoration: ShapeDecoration(
                                    color: AppColors.textFieldLabelColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12.0.w,
                                      ),
                                    ),
                                    image:
                                    storeData.imageUrl != null
                                        ? DecorationImage(
                                      image: NetworkImage(
                                        storeData.imageUrl
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
                                ),
                                SizedBox(
                                  height: 8.0.w,
                                ), // Spacing between image and text
                                // Restaurant Name
                                SizedBox(
                                  width: 155.0.w,
                                  child: AmdText(
                                    text: storeData.restaurantName ?? "",
                                    color: AppColors.blackColor,
                                    size: 13.0.sp,
                                    weight: FontWeight.w700,
                                    maxLines:
                                    4, // Allow up to 2 lines for the name
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                SizedBox(height: 8.0.w),

                                // Cuisine Type
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 2.0,
                                      ),
                                      child: Container(
                                        width: 4.0.w,
                                        height: 4.0.w,
                                        decoration: const ShapeDecoration(
                                          color: AppColors.blackColor,
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5.0.w),
                                    SizedBox(
                                      width: 95.0.w,
                                      child: AmdText(
                                        text:
                                        storeData.cuisineType != null &&
                                            storeData
                                                .cuisineType!
                                                .isNotEmpty
                                            ? storeData.cuisineType!
                                            .map(
                                              (cuisine) =>
                                          cuisine.name,
                                        )
                                            .join(", ")
                                            : "Chinese",
                                        color: AppColors.blackColor,
                                        size: 10.0.sp,
                                        weight: FontWeight.w600,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 8.0.w),

                                SizedBox(width: 8.0.w),

                                // Delivery Time and Distance
                                Row(
                                  children: [
                                    // Delivery Time
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_filled,
                                            size: 10.0.w,
                                            color: AppColors.greenColor,
                                          ),
                                          SizedBox(width: 4.0.w),
                                          Flexible(
                                            child: AmdText(
                                              text:
                                              _getMaxPreparationTime(
                                                storeData,
                                              ) ??
                                                  "30 MINS",
                                              color: AppColors.blackColor,
                                              size: 8.0.sp,
                                              weight: FontWeight.w600,
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      width: 8.0.w,
                                    ), // Spacing between the two data points
                                    // Distance (Text Only, No Icon)
                                    Container(
                                      width: 4.0.w,
                                      height: 4.0.w,
                                      decoration: const ShapeDecoration(
                                        color: AppColors.blackColor,
                                        shape: OvalBorder(),
                                      ),
                                    ),

                                    SizedBox(width: 5.0.w),
                                    Flexible(
                                      child: FutureBuilder<Position?>(
                                        future:
                                        PickUpController.getUserLocation(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return AmdText(
                                              text: "",
                                              color: AppColors.blackColor,
                                              size: 8.0.sp,
                                              weight: FontWeight.w600,
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                            );
                                          }

                                          if (snapshot.hasData &&
                                              snapshot.data != null) {
                                            double userLatitude =
                                                snapshot.data!.latitude;
                                            double userLongitude =
                                                snapshot.data!.longitude;

                                            return AmdText(
                                              text:
                                              getNearestRestaurantDistance(
                                                userLatitude,
                                                userLongitude,
                                                storeData,
                                              ),
                                              color: AppColors.blackColor,
                                              size: 8.0.sp,
                                              weight: FontWeight.w600,
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                            );
                                          } else {
                                            return AmdText(
                                              text:
                                              "Location not available",
                                              color: AppColors.blackColor,
                                              size: 8.0.sp,
                                              weight: FontWeight.w600,
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300, // Light gray line
                          thickness: 1,
                          endIndent: 10, // Space between line and text
                        ),
                      ),
                      Text(
                        "Thank You",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF777E90),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                          indent: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity, // Full width
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFEEFFE9),
                      ], // Updated gradient colors
                    ),
                  ),

                  padding: const EdgeInsets.all(20.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ESCAPE',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          height: 1.0,
                          letterSpacing: 0.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'QUEUE..!',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          height: 1.0,
                          letterSpacing: 0.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ESCAPE...!',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          height: 1.0,
                          letterSpacing: 0.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'WAITING...!',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          height: 1.0, // Line height 8px equivalent
                          letterSpacing: 0.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontSize: 18, // Font size 18px
                            height: 1.33, // Line height 24px equivalent
                            letterSpacing: 0.0,
                            color: Colors.grey, // Text color
                          ),
                          children: [
                            TextSpan(
                              text: 'MADE IN ',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 18, // Font size 18px
                                height: 1.33, // Line height 24px equivalent
                                letterSpacing: 0.0,
                                color: Colors.grey, // Text color
                              ),
                            ),
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0.0),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.green, // Green icon
                                  size: 20,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: 'WITH PEOPLE',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 18, // Font size 18px
                                height: 1.33, // Line height 24px equivalent
                                letterSpacing: 0.0,
                                color: Colors.grey, // Text color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(),
      endDrawer: CustomDrawer(),
    );
  }


}