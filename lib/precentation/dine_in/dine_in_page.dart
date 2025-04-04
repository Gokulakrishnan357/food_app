import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/dine_in/components/restaurant_info.dart';

import './dine_in_controller.dart';

class DineInPage extends GetView<DineInController> {
  const DineInPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(
        375,
        812,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.whitetextColor,
          ),
        ),
        title: AmdText(
          text: 'Dine-in restaurants',
          color: AppColors.whitetextColor,
          size: 20.0.sp,
          weight: FontWeight.w500,
        ),
        elevation: 0.0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24.0.w),
            child: Container(
              width: 18.0.w,
              height: 18.0.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/icons/home.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.greenColor,
      ),
      body: SizedBox(
        height: 812.0.w,
        width: 375.0.w,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0.w,
            top: 26.0.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Search Restorents
                Container(
                  width: 327.0.w,
                  height: 40.0.w,
                  decoration: ShapeDecoration(
                    color: AppColors.whitetextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        18.0.w,
                      ),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: TextFormField(
                    controller: controller.dineInSearch,
                    decoration: InputDecoration(
                      labelText: 'Search for restaurants in Peelamedu',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(bottom: 16.0.w, left: 16.0.w),
                      // prefixIcon: const Icon(FontAwesomeIcons.barcode),
                      suffixIcon: const Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: AppColors.greenColor,
                      ),
                      labelStyle: GoogleFonts.montserrat(
                        color: AppColors.textFieldLabelColor,
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onChanged: (value) {
                      if (kDebugMode) {
                        print("The search value is $value");
                      }
                      controller.restaurantName.value = value;
                      controller.fetchDineInRestaurants();
                      if (kDebugMode) {
                        print("The search value is $value");
                      }
                    },
                  ),
                ),

                /// Restorents List
                Padding(
                  padding: EdgeInsets.only(
                    left: 0.0.w,
                    top: 26.0.w,
                  ),
                  child: Obx(
                    () => controller
                                .getAllDineInRestaurants.value.restaurants !=
                            null
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: controller.getAllDineInRestaurants.value
                                .restaurants!.length,
                            itemBuilder: (context, index) {
                              var dineInData = controller
                                  .getAllDineInRestaurants
                                  .value
                                  .restaurants![index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: 16.0.w,
                                  bottom: 16.0.w,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    controller.restaurantId.value =
                                        dineInData.restaurantId!;
                                    controller.fetchDineInRestaurantsById();
                                    Get.to(
                                      () => const RestaurantInfo(),
                                    );
                                  },
                                  child: Container(
                                    height: 185.0.w,
                                    width: 327.0.w,
                                    decoration: BoxDecoration(
                                      image: dineInData.image != null
                                          ? DecorationImage(
                                              image: MemoryImage(
                                                base64Decode(
                                                  dineInData.image!,
                                                ),
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : const DecorationImage(
                                              image: AssetImage(
                                                "assets/icons/No_Image_Available.jpg",
                                              ),
                                            ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          16.0.w,
                                        ),
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.25),
                                          offset: Offset(
                                            12.65,
                                            12.65,
                                          ),
                                          blurRadius: 26.65,
                                        )
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: 0.0.w,
                                          right: 0.0.w,
                                          left: 0.0.w,
                                          child: Container(
                                            height: 50.0.w,
                                            width: 327.0.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.whitetextColor,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(
                                                  16.0.w,
                                                ),
                                                bottomRight: Radius.circular(
                                                  16.0.w,
                                                ),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 12.0.w,
                                                  top: 7.0.w,
                                                  child: SizedBox(
                                                    height: 17.0.w,
                                                    width: 100.0.w,
                                                    child: AmdText(
                                                      text: dineInData
                                                          .restaurantName!,
                                                      size: 14.0.sp,
                                                      weight: FontWeight.w500,
                                                      color: AppColors
                                                          .dineInTextLabelColor,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 12.0.w,
                                                  top: 30.0.w,
                                                  child: SizedBox(
                                                    height: 12.0.w,
                                                    width: 142.0.w,
                                                    child: AmdText(
                                                      text: dineInData
                                                          .cusineType!,
                                                      size: 10.0.sp,
                                                      weight: FontWeight.w500,
                                                      color: AppColors
                                                          .dineInTextLabelColor,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 12.0.w,
                                                  top: 8.0.w,
                                                  child: Container(
                                                    height: 16.0.w,
                                                    width: 38.0.w,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.greenColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(
                                                          4.0.w,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 5.0.w,
                                                          top: 2.0.w,
                                                          child: SizedBox(
                                                            height: 12.0.w,
                                                            width: 15.0.w,
                                                            child: AmdText(
                                                              text: dineInData
                                                                  .rating
                                                                  .toString(),
                                                              size: 10.0.sp,
                                                              weight: FontWeight
                                                                  .w400,
                                                              color: AppColors
                                                                  .whitetextColor,
                                                              height: 1.2,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 5.0.w,
                                                          top: 3.0.w,
                                                          child: SizedBox(
                                                            height: 10.0.w,
                                                            width: 10.0.w,
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .solidStar,
                                                              size: 8.0.sp,
                                                              color: AppColors
                                                                  .whitetextColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 12.0.w,
                                                  top: 28.0.w,
                                                  child: SizedBox(
                                                    height: 12.0.w,
                                                    width: 83.0.w,
                                                    child: AmdText(
                                                      text:
                                                          '₹ ${dineInData.offersName}',
                                                      size: 10.0.sp,
                                                      weight: FontWeight.w500,
                                                      color: AppColors
                                                          .dineInTextLabelColor,
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Column(
                            children: [
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                              Center(
                                child: Image.asset(
                                  "assets/images/Coming-Soon.gif",
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
