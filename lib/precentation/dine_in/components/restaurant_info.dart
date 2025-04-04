import 'dart:convert';

import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/dine_in/dine_in_controller.dart';

class RestaurantInfo extends StatelessWidget {
  const RestaurantInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(
        375,
        812,
      ),
    );
    var dineInController = Get.put(DineInController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.whitetextColor,
          ),
        ),
        title: AmdText(
          text: 'Restaurant Info',
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: 732.0.w,
          width: 375.0.w,
          child: Stack(
            children: [
              Positioned(
                child: Obx(
                  () => dineInController
                              .getAllDineInRestaurantsSingle.value.dineInData !=
                          null
                      ? Container(
                          height: 250.0.w,
                          width: 375.0.w,
                          decoration: BoxDecoration(
                            image: dineInController
                                        .getAllDineInRestaurantsSingle
                                        .value
                                        .dineInData!
                                        .restaurant!
                                        .image !=
                                    null
                                ? DecorationImage(
                                    image: MemoryImage(
                                      base64Decode(
                                        dineInController
                                            .getAllDineInRestaurantsSingle
                                            .value
                                            .dineInData!
                                            .restaurant!
                                            .image!,
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage(
                                      "assets/icons/restaurant_info_barbeque_nation.png",
                                    ),
                                  ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
              Positioned(
                top: 204.0.w,
                child: Container(
                  height: 528.0.w,
                  width: 375.0.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        20.0.w,
                      ),
                      topRight: Radius.circular(
                        20.0.w,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 24.0.w,
                        top: 24.0.h,
                        // bottom: 480.0.h,
                        child: SizedBox(
                          width: 63.0.w,
                          height: 24.0.w,
                          child: AmdText(
                            text: 'About',
                            color: AppColors.greenColor,
                            size: 20.0.sp,
                            weight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24.0.w,
                        top: 60.0.w,
                        bottom: 370.0.w,
                        child: SizedBox(
                          width: 340.0.w,
                          height: 98.0.w,
                          child: AmdText(
                            text:
                                'Barbeque Nation pioneered the concept of live grills embedded under dining tables – allowing customers to grill their own barbecue’s right at their tables.',
                            color: AppColors.dineInTextLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w400,
                            height: 1.6.w,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24.0.w,
                        top: 178.0.w,
                        bottom: 330.0.w,
                        child: SizedBox(
                          width: 63.0.w,
                          height: 24.0.w,
                          child: AmdText(
                            text: 'Menu',
                            color: AppColors.dineInTextLabelColor,
                            size: 16.0.sp,
                            weight: FontWeight.w500,
                            height: 1.2.w,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24.0.w,
                        top: 210.0.w,
                        bottom: 248.0.w,
                        child: SizedBox(
                          width: 332.0.w,
                          height: 70.0.w,
                          child: Obx(
                            () => dineInController.getAllDineInRestaurantsSingle
                                        .value.dineInData !=
                                    null
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dineInController
                                        .getAllDineInRestaurantsSingle
                                        .value
                                        .dineInData!
                                        .menu!
                                        .length,
                                    itemBuilder: (context, index) {
                                      var restorantData = dineInController
                                          .getAllDineInRestaurantsSingle
                                          .value
                                          .dineInData!
                                          .menu![index];
                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.0.w),
                                        child: Container(
                                          width: 70.0.w,
                                          height: 70.0.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0.w),
                                            image: restorantData
                                                        .restaurantMenuImage !=
                                                    null
                                                ? DecorationImage(
                                                    image: MemoryImage(
                                                      base64Decode(
                                                        restorantData
                                                            .restaurantMenuImage!,
                                                      ),
                                                    ),
                                                    fit: BoxFit.cover)
                                                : const DecorationImage(
                                                    image: AssetImage(
                                                      "No_Image_Available.jpg",
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24.0.w,
                        top: 300.0.w,
                        bottom: 204.0.w,
                        child: SizedBox(
                          width: 220.0.w,
                          height: 24.0.w,
                          child: AmdText(
                            text: 'Restaurant facilities',
                            color: AppColors.dineInTextLabelColor,
                            size: 20.0.sp,
                            weight: FontWeight.w500,
                            height: 1.2.w,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24.0.w,
                        top: 336.0.w,
                        bottom: 95.0.w,
                        child: SizedBox(
                          width: 329.0.w,
                          height: 97.0.w,
                          child: Obx(
                            () => dineInController.getAllDineInRestaurantsSingle
                                        .value.dineInData !=
                                    null
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dineInController
                                        .getAllDineInRestaurantsSingle
                                        .value
                                        .dineInData!
                                        .facility!
                                        .length,
                                    itemBuilder: (context, index) {
                                      var restorantFacilitiesData =
                                          dineInController
                                              .getAllDineInRestaurantsSingle
                                              .value
                                              .dineInData!
                                              .facility![index];
                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.0.w),
                                        child: SizedBox(
                                          width: 73.0.w,
                                          height: 97.0.w,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: 70.0.w,
                                                height: 70.0.w,
                                                decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.all(23.0.w),
                                                  child: SizedBox(
                                                    height: 24.0.w,
                                                    width: 24.0.w,
                                                    child: Image.memory(
                                                      base64Decode(
                                                        restorantFacilitiesData
                                                            .facilityImage!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 73.0.w,
                                                height: 15.0.w,
                                                child: AmdText(
                                                  text: restorantFacilitiesData
                                                      .facilityDescription!,
                                                  textAlign: TextAlign.center,
                                                  color: AppColors
                                                      .dineInTextLabelColor,
                                                  size: 11.0.sp,
                                                  weight: FontWeight.w400,
                                                  height: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 458.0.w,
                        left: 47.0.w,
                        // bottom: 26.0.h,
                        child: AmdButton(
                          buttoncolor: AppColors.greenColor,
                          radius: 10.0.w,
                          press: () {
                            Get.toNamed(AmdRoutesClass.bookTablePage);
                          },
                          size: Size(
                            280.0.w,
                            44.0.w,
                          ),
                          child: AmdText(
                            text: 'Book a table',
                            color: AppColors.whitetextColor,
                            size: 20.0.sp,
                            textAlign: TextAlign.center,
                            weight: FontWeight.w500,
                          ),
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
    );
  }
}
