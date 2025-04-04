import 'dart:math';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zeroq/models/restaurant_models/restaurant_search_model.dart';
import '../../../Model/RestaurantCategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zeroq/const/app_colors.dart';
import 'package:zeroq/precentation/pick_up/components/hotel_menu/hotel_menu_controller.dart';
import 'package:zeroq/uttility/routing/routes.dart';
import '../../../uttility/custom_widget/custom_text.dart';
import '../pick_up_controller.dart';

class SearchBarScreen2 extends StatelessWidget {
  final String categoryName;

  const SearchBarScreen2({super.key, required this.categoryName});

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
      Restaurant storeData,
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
    double a = sin(dLat / 2) * sin(dLat / 2) +
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
    final HotelMenuController controller = Get.find<HotelMenuController>();
    final FilterChipController controller1 = Get.find<FilterChipController>();
    // Fetch all restaurants when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      controller.fetchRestaurantsByCategory(categoryName, position.latitude, position.longitude);
    });


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true, // Keeps it fixed at the top
                  floating: false,
                  delegate: _HeaderDelegate(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 35),
                        _buildSearchBox(controller),
                        Padding(
                          padding: const EdgeInsets.only(right: 13.0, left: 0.5),
                          child: buildFilterChips(
                            FilterChipController(categoryName),
                            controller,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ];
            },

            body: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              var restaurants = controller.getCategoryRestaurants;

              if (restaurants.isEmpty) {
                return const Center(
                  child: Text(
                    "No restaurants found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: restaurants.length,
                padding: const EdgeInsets.only(
                  right: 15.0,
                  left: 12.0,
                  top: 15.0,
                ),
                  itemBuilder: (context, index) {
                    var storeData = restaurants[index];
                    var storeData1 = controller.getRestaurantSearch.value.restaurantData;

                    if (storeData1 == null || index >= storeData1.length) {
                      print("No data found for index: $index");
                    }

                    return InkWell(
                      onTap: () {
                        controller.restaurantId.value = storeData.restaurantId.toString();
                        controller.fetchRestaurantsMenuByIdFromGraph();
                        controller.fetchRestaurantsByIdFromGraph();
                        Get.toNamed(AmdRoutesClass.hotelMenuPage);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant Image
                          Container(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  storeData.imageUrl?.isNotEmpty == true
                                      ? storeData.imageUrl!
                                      : "https://via.placeholder.com/150",
                                  width: 375,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/icons/No_Image_Available.png",
                                      width: 375,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Restaurant Details (Logo, Name, Rating)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Image.network(
                                    storeData.logourl?.isNotEmpty == true
                                        ? storeData.logourl!
                                        : "http://food.crestclimbers.com/images/restaurant/1.png",
                                    width: 24,
                                    height: 24,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.error,
                                        size: 24,
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      storeData.restaurantName?.isNotEmpty == true
                                          ? storeData.restaurantName!
                                          : "Restaurant Name",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 43,
                                height: 20,
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E5D25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                        (storeData.averageRating ?? 0.0).toStringAsFixed(1),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          height: 1.2,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Cuisine Type and Minimum Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 13.0, right: 12.0),
                                child: Text(
                                  storeData.cuisineTypes != null && storeData.cuisineTypes!.isNotEmpty
                                      ? storeData.cuisineTypes!.map((cuisine) => cuisine.name).join(", ")
                                      : "Biryani, Arabian, Chinese",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: const Color.fromRGBO(94, 94, 94, 1),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.brightness_1,
                                    size: 6,
                                    color: Color.fromRGBO(125, 125, 125, 1),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${storeData.minimumLimitOfPerPerson ?? 0} for one person",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: const Color.fromRGBO(94, 94, 94, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Location and Distance
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Text(
                                    storeData.branches != null && storeData.branches!.isNotEmpty
                                        ? storeData.branches!.first.locality ?? "Location Not Available"
                                        : "Location Not Available",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(81, 81, 81, 1),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.brightness_1,
                                    size: 7,
                                    color: Color.fromRGBO(125, 125, 125, 1),
                                  ),
                                  const SizedBox(width: 3),
                                  FutureBuilder<Position?>(
                                    future: PickUpController.getUserLocation(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return AmdText(
                                          text: "",
                                          color: AppColors.blackColor,
                                          size: 8.0,
                                          weight: FontWeight.w600,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }
                                      if (snapshot.hasData && snapshot.data != null) {
                                        double userLatitude = snapshot.data!.latitude;
                                        double userLongitude = snapshot.data!.longitude;

                                        return AmdText(
                                          text: getNearestRestaurantDistance(
                                            userLatitude,
                                            userLongitude,
                                            storeData,
                                          ),
                                          color: const Color.fromRGBO(81, 81, 81, 1),
                                          size: 11,
                                          weight: FontWeight.w500,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      } else {
                                        return AmdText(
                                          text: "",
                                          color: const Color.fromRGBO(81, 81, 81, 1),
                                          size: 8.0,
                                          weight: FontWeight.w500,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),

                              // Delivery Time
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    controller1.deliveryAvailable
                                        ? SvgPicture.asset(
                                      "assets/images/delivery.svg",
                                      width: 12,
                                      height: 12,
                                      fit: BoxFit.contain,
                                      color: const Color(0xFF2E5D25),
                                    )
                                        : Icon(
                                      Icons.access_time_filled,
                                      size: 12.5,
                                      color: AppColors.greenColor,
                                    ),
                                    const SizedBox(width: 4),

                                    Text(
                                      _getMaxPreparationTime(storeData1!.first) ?? "30 MINS",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Divider between items
                          if (index != restaurants.length - 1)
                            const Divider(
                              height: 20,
                              thickness: 0.1,
                              color: Colors.grey,
                              indent: 10,
                              endIndent: 10,
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  }

              );
            }),
          ),
        ),
      ),
    );
  }
}

Widget _buildSearchBox(HotelMenuController controller) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Container(
      width: 370,
      height: 56, // Increased slightly for better vertical centering
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Search for food',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16), // Adjusted
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ), // Balanced padding
            child: Image.asset(
              'assets/images/search1.png',
              width: 22,
              height: 22,
              color: const Color(0xFF858585),
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ), // Matched prefix icon padding
            child: Icon(
              Icons.mic_none_outlined,
              color: const Color(0xFF858585),
              size: 24,
            ),
          ),
          hintStyle: GoogleFonts.montserrat(
            color: const Color(0xFF555555),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: GoogleFonts.montserrat(
          fontSize: 16,
          color: const Color(0xFF555555),
        ),
        onChanged: (value) {
          controller.fetchRestaurantsByName(value);
        },
      ),
    ),
  );
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _HeaderDelegate({required this.child});

  @override
  double get minExtent => 180;
  @override
  double get maxExtent => 180;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 4,
      child: Container(
        color: Colors.white,
        child: SizedBox(
          height: maxExtent,
          child: child,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class FilterChipController extends ChangeNotifier {
  final String categoryName;
  FilterChipController(this.categoryName);
  String selectedMode = 'Self Pick-up';
  String? additionalFilter;
  String? sortOrder;

  bool get deliveryAvailable => selectedMode == 'Delivery';

  Future<void> toggleFilter(String filter, HotelMenuController menuController) async {
    if (filter == 'Delivery' || filter == 'Self Pick-up') {
      if (selectedMode == filter) {
        return;
      }
      selectedMode = filter;
      // Preserve additionalFilter and sortOrder when toggling between Delivery and Self Pick-up
    } else if (filter == 'Less than ₹200' || filter == 'Less than 30 min') {
      // Preserve existing filters while applying new ones
      if (additionalFilter == filter) {
        additionalFilter = null;
      } else {
        additionalFilter = filter;
      }
    }

    notifyListeners();

    // Introduce a small delay to ensure smooth UI updates
    await Future.delayed(const Duration(milliseconds: 300));

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    fetchFilteredRestaurants(menuController, position.latitude, position.longitude);
  }


  void updateSortOrder(String order, HotelMenuController menuController) {
    additionalFilter = null;
    sortOrder = order;
    bool sortHighToLow = order == 'highToLow';

    notifyListeners();


    menuController.fetchAndSortcategoryRestaurants(
      categoryName: categoryName,
      sortHighToLow: sortHighToLow,
      isDelivery: deliveryAvailable,
    );
  }

  Future<void> fetchFilteredRestaurants(HotelMenuController menuController, double userLat, double userLong) async {



    if (deliveryAvailable) {
      menuController.fetchRestaurantsdeliveryByCategory(categoryName, userLat, userLong);
    } else {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      menuController.fetchRestaurantsByCategory(categoryName,position.latitude, position.longitude);
    }

    if (additionalFilter == 'Less than ₹200') {
      menuController.fetchCategory200(
        categoryName: categoryName,
        deliveryAvailable: deliveryAvailable,
      );
    } else if (additionalFilter == 'Less than 30 min') {
      menuController.fetchQuerycategoryWithPrepTime(
        categoryName,
        deliveryAvailable,
        userLat,
        userLong,
      );
    }
  }

}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final FilterChipController controller;
  final HotelMenuController menuController;

  const FilterChipWidget(
      this.label,
      this.controller,
      this.menuController, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        bool isActive =
            (label == controller.selectedMode) ||
                (label == controller.additionalFilter) ||
                (label == 'Sort by' && controller.sortOrder != null);
        bool isSort = label == 'Sort by';

        return GestureDetector(
          onTap: () {
            if (isSort) {
              controller.additionalFilter = null; // Reset filters when sorting
              _showSortingOptions(context);
            } else {
              controller.toggleFilter(label, menuController);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color:
              isActive
                  ? const Color.fromARGB(
                255,
                57,
                135,
                6,
              ) // Green when selected
                  : const Color.fromRGBO(
                251,
                255,
                249,
                1,
              ), // Default background
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color.fromRGBO(194, 224, 174, 1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSort)
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 14,
                    color: isActive ? Colors.white : const Color(0xFF666666),
                  ),
                const SizedBox(width: 6),
                Text(
                  isSort && controller.sortOrder != null
                      ? 'Sort by (${controller.sortOrder == 'highToLow' ? 'High to Low' : 'Low to High'})'
                      : label,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSortingOptions(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double left = offset.dx;
    final double top = offset.dy + renderBox.size.height;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        left,
        top,
        left + renderBox.size.width,
        top + 100,
      ),
      items: [
        const PopupMenuItem<String>(
          value: 'highToLow',
          child: Text('Price: High to Low'),
        ),
        const PopupMenuItem<String>(
          value: 'lowToHigh',
          child: Text('Price: Low to High'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        controller.updateSortOrder(value, menuController);
      }
    });
  }
}

Widget buildFilterChips(
    FilterChipController controller,
    HotelMenuController menuController,
    ) {
  return Padding(
    padding: const EdgeInsets.only(left: 13.0, right: 9),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          const SizedBox(width: 6),
          FilterChipWidget('Sort by', controller, menuController),
          const SizedBox(width: 6),
          FilterChipWidget('Self Pick-up', controller, menuController),
          const SizedBox(width: 6),
          FilterChipWidget('Delivery', controller, menuController),
          const SizedBox(width: 6),
          FilterChipWidget('Less than 30 min', controller, menuController),
          const SizedBox(width: 6),
          FilterChipWidget('Less than ₹200', controller, menuController),
        ],
      ),
    ),
  );

}