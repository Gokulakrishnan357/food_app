import 'dart:convert';

import '../../../const/app_exports.dart';
import './dining_menu_controller.dart';

class DiningMenuPage extends GetView<DiningMenuController> {
  const DiningMenuPage({super.key});

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
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            color: AppColors.greenColor,
            size: 20.0.sp,
          ),
        ),
        elevation: 0.0,
        backgroundColor: AppColors.whitetextColor,
      ),
      body: SizedBox(
        height: 812.0.w,
        width: 375.0.w,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0.w,
            right: 24.0.w,
            top: 0.0.w,
          ),
          child: Obx(
            () {
              var restorantData =
                  controller.getRestaurant.value.restaurantData![0];
              return controller.getRestaurant.value.restaurantData != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 180.0.w,
                            width: 327.0.w,
                            decoration: ShapeDecoration(
                              color: restorantData.image == null
                                  ? Colors.transparent
                                  : null,
                              image: restorantData.image != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                        base64Decode(
                                          restorantData.image != null
                                              ? restorantData.image.toString()
                                              : "",
                                        ),
                                      ),
                                      onError: (exception, stackTrace) {},
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage(
                                        "assets/icons/No_Image_Available.png",
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8.0.w,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 14.0.w,
                            ),
                            child: SizedBox(
                              width: 192.0.w,
                              height: 20.0.w,
                              child: AmdText(
                                text: restorantData.restaurantName ?? "",
                                color: AppColors.blackColor,
                                size: 20.0.sp,
                                weight: FontWeight.w700,
                                height: 1.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 14.0.w,
                            ),
                            child: SizedBox(
                              width: 245.0.w,
                              height: 15.0.w,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0.0.w,
                                    top: 0.0.w,
                                    child: SizedBox(
                                      width: 55.0.w,
                                      height: 15.0.w,
                                      child: AmdText(
                                        text: 'BIRIYANI',
                                        color: AppColors.blackColor,
                                        size: 12.0.sp,
                                        weight: FontWeight.w400,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5.5.w,
                                    left: 63.0.w,
                                    child: Container(
                                      width: 4.0.w,
                                      height: 4.0.w,
                                      decoration: const ShapeDecoration(
                                        color: AppColors.blackColor,
                                        shape: OvalBorder(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 75.0.w,
                                    top: 0.0.w,
                                    child: SizedBox(
                                      width: 56.0.w,
                                      height: 15.0.w,
                                      child: AmdText(
                                        text: 'Chinese',
                                        color: AppColors.blackColor,
                                        size: 12.0.sp,
                                        weight: FontWeight.w400,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5.5.w,
                                    left: 139.0.w,
                                    child: Container(
                                      width: 4.0.w,
                                      height: 4.0.w,
                                      decoration: const ShapeDecoration(
                                        color: AppColors.blackColor,
                                        shape: OvalBorder(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 151.0.w,
                                    top: 0.0.w,
                                    child: SizedBox(
                                      width: 94.0.w,
                                      height: 15.0.w,
                                      child: AmdText(
                                        text: '2000 for two',
                                        color: AppColors.blackColor,
                                        size: 12.0.sp,
                                        weight: FontWeight.w400,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 8.0.w,
                            ),
                            child: SizedBox(
                              width: 153.0.w,
                              height: 24.0.w,
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 0.0.w,
                                      left: 0.0.w,
                                      child: SizedBox(
                                        height: 24.0.w,
                                        width: 24.0.w,
                                        child: Icon(
                                          FontAwesomeIcons.clock,
                                          // FontAwesomeIcons.clock,
                                          color: AppColors.greenColor,
                                          size: 24.0.sp,
                                        ),
                                      )),
                                  Positioned(
                                    top: 4.5.w,
                                    right: 0.0.w,
                                    child: SizedBox(
                                      height: 15.0.w,
                                      width: 121.0.w,
                                      child: AmdText(
                                        text: '${restorantData.address} 1KM',
                                        size: 12.0.sp,
                                        weight: FontWeight.w400,
                                        color: AppColors.blackColor,
                                        textAlign: TextAlign.right,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 8.0.w,
                            ),
                            child: Container(
                              width: 327.0.w,
                              height: 49.0.w,
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: Color.fromRGBO(207, 207, 207, 1),
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 6.5.w,
                                    left: 38.2.w,
                                    child: InkWell(
                                      onTap: () {},
                                      child: SizedBox(
                                        width: 89.51.w,
                                        height: 36.0.w,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 9.0.w,
                                              left: 8.0.w,
                                              child: SizedBox(
                                                width: 13.51.w,
                                                height: 18.0.w,
                                                child: Icon(
                                                  FontAwesomeIcons.locationDot,
                                                  color: AppColors.greenColor,
                                                  size: 12.0.sp,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8.0.w,
                                              right: 4.0.w,
                                              child: SizedBox(
                                                height: 20.0.w,
                                                width: 60.0.w,
                                                child: AmdText(
                                                  text: 'Direction',
                                                  size: 12.0.sp,
                                                  weight: FontWeight.w400,
                                                  color: AppColors.blackColor,
                                                  textAlign: TextAlign.right,
                                                  height: 1.4.w,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6.5.w,
                                    right: 38.2.w,
                                    child: InkWell(
                                      onTap: () {},
                                      child: SizedBox(
                                        width: 61.51.w,
                                        height: 36.0.w,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 9.0.w,
                                              left: 8.0.w,
                                              child: SizedBox(
                                                width: 18.0.w,
                                                height: 18.0.w,
                                                child: Icon(
                                                  FontAwesomeIcons.phone,
                                                  color: AppColors.greenColor,
                                                  size: 12.0.sp,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8.0.w,
                                              right: 8.0.w,
                                              child: SizedBox(
                                                height: 20.0.w,
                                                width: 23.0.w,
                                                child: AmdText(
                                                  text: 'Call',
                                                  size: 12.0.sp,
                                                  weight: FontWeight.w400,
                                                  color: AppColors.blackColor,
                                                  textAlign: TextAlign.right,
                                                  height: 1.4.w,
                                                ),
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 8.0.w,
                            ),
                            child: SizedBox(
                              width: 327.0.w,
                              height: 28.0.w,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 40.5.w,
                                    child: Obx(
                                      () => InkWell(
                                        onTap: () {
                                          controller.menuIndex.value = 0;
                                        },
                                        child: Container(
                                          width: 58.0.w,
                                          height: 28.0.w,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1.0.w,
                                                color: controller
                                                            .menuIndex.value ==
                                                        0
                                                    ? AppColors.greenColor
                                                    : AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: AmdText(
                                              text: 'About',
                                              color: AppColors.greenColor,
                                              textAlign: TextAlign.center,
                                              size: 12.0.sp,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 98.5.w,
                                    child: Obx(
                                      () => InkWell(
                                        onTap: () {
                                          controller.menuIndex.value = 1;
                                        },
                                        child: Container(
                                          width: 55.0.w,
                                          height: 28.0.w,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1.0.w,
                                                color: controller
                                                            .menuIndex.value ==
                                                        1
                                                    ? AppColors.greenColor
                                                    : AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: AmdText(
                                              text: 'Menu',
                                              color: AppColors.greenColor,
                                              textAlign: TextAlign.center,
                                              size: 12.0.sp,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 153.5.w,
                                    child: Obx(
                                      () => InkWell(
                                        onTap: () {
                                          controller.menuIndex.value = 2;
                                        },
                                        child: Container(
                                          width: 63.0.w,
                                          height: 28.0.w,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1.0.w,
                                                color: controller
                                                            .menuIndex.value ==
                                                        2
                                                    ? AppColors.greenColor
                                                    : AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: AmdText(
                                              text: 'Photos',
                                              color: AppColors.greenColor,
                                              textAlign: TextAlign.center,
                                              size: 12.0.sp,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 216.5.w,
                                    child: Obx(
                                      () => InkWell(
                                        onTap: () {
                                          controller.menuIndex.value = 3;
                                        },
                                        child: Container(
                                          width: 69.0.w,
                                          height: 28.0.w,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1.0.w,
                                                color: controller
                                                            .menuIndex.value ==
                                                        3
                                                    ? AppColors.greenColor
                                                    : AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: AmdText(
                                              text: 'Reviews',
                                              color: AppColors.greenColor,
                                              textAlign: TextAlign.center,
                                              size: 12.0.sp,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 43.0.w,
                            ),
                            child: SizedBox(
                              height: controller.menuIndex.value != 3
                                  ? 273.0.w
                                  : 340.0.w,
                              width: 323.0.w,
                              child: Obx(
                                () => IndexedStack(
                                  index: controller.menuIndex.value,
                                  children: [
                                    SizedBox(
                                      height: 120.0.w,
                                      width: 260.0.w,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            child: SizedBox(
                                              width: 152.0.w,
                                              height: 20.0.w,
                                              child: AmdText(
                                                text: 'Facilities',
                                                size: 16.0.sp,
                                                weight: FontWeight.w600,
                                                color: AppColors.blackColor,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 28.0.w,
                                            child: SizedBox(
                                              width: 133.0.w,
                                              height: 20.0.w,
                                              child: AmdText(
                                                text: 'Home delivery',
                                                size: 12.0.sp,
                                                weight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 52.0.w,
                                            child: SizedBox(
                                              width: 133.0.w,
                                              height: 20.0.w,
                                              child: AmdText(
                                                text: 'Live Entertainment',
                                                size: 12.0.sp,
                                                weight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 76.0.w,
                                            child: SizedBox(
                                              width: 133.0.w,
                                              height: 20.0.w,
                                              child: AmdText(
                                                text: 'Outdoor seating',
                                                size: 12.0.sp,
                                                weight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 100.0.w,
                                            child: SizedBox(
                                              width: 133.0.w,
                                              height: 20.0.w,
                                              child: AmdText(
                                                text: 'Pet Friendly',
                                                size: 12.0.sp,
                                                weight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),

                                          /// right side
                                          Positioned(
                                            top: 28.0.w,
                                            right: 0.0.w,
                                            child: SizedBox(
                                              width: 120.0.w,
                                              height: 20.0.w,
                                              child: AmdText(
                                                text: 'Takeaway available',
                                                size: 12.0.sp,
                                                weight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 52.0.w,
                                            right: 0.0.w,
                                            child: SizedBox(
                                              width: 120.0.w,
                                              height: 20.0.w,
                                              child: AmdText(
                                                text: 'Live music',
                                                size: 12.0.sp,
                                                weight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 76.0.w,
                                            right: 0.0.w,
                                            child: SizedBox(
                                              width: 120.0.w,
                                              height: 20.0.w,
                                              child: AmdText(
                                                text: 'Indoor Seating',
                                                size: 12.0.sp,
                                                weight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 100.0.w,
                                            right: 0.0.w,
                                            child: SizedBox(
                                              width: 120.0.w,
                                              height: 20.0.w,
                                              child: AmdText(
                                                text: 'Romantic dining',
                                                size: 12.0.sp,
                                                weight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 273.0.w,
                                      width: 323.0.w,
                                      child: ListView.builder(
                                        itemCount:
                                            controller.foodCategory.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.all(8.0.w),
                                            child: AmdText(
                                              text:
                                                  controller.foodCategory[index]
                                                      ['foodName'],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 273.0.w,
                                      width: 323.0.w,
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12.0,
                                          mainAxisSpacing: 24.0,
                                          mainAxisExtent: 128.0
                                              .w, // here set custom Height You Want
                                        ),
                                        itemCount:
                                            controller.restorentImages.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            height: 128.0.w,
                                            width: 154.0.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                8.0.w,
                                              ),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  controller.restorentImages[
                                                      index]['image'],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 350.0.w,
                                      width: 323.0.w,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 43.0.w,
                                            top: 10.0.w,
                                            child: SizedBox(
                                              width: 270.0.w,
                                              height: 16.0.w,
                                              child: AmdText(
                                                text:
                                                    'Rate this restaurant and comment',
                                                size: 14.0.sp,
                                                weight: FontWeight.w600,
                                                color: AppColors
                                                    .textFieldLabelColor,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20.0.w,
                                            top: 10.0.w,
                                            child: SizedBox(
                                              height: 16.0.w,
                                              width: 16.0.w,
                                              child: Icon(
                                                FontAwesomeIcons.star,
                                                color: AppColors
                                                    .textFieldLabelColor,
                                                size: 16.0.sp,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20.0.w,
                                            top: 44.0.w,
                                            child: SizedBox(
                                              height: 24.0.w,
                                              width: 180.0.w,
                                              child: Center(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Icon(
                                                        FontAwesomeIcons.star,
                                                        color: AppColors
                                                            .textFieldLabelColor,
                                                        size: 16.0.sp,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Icon(
                                                        FontAwesomeIcons.star,
                                                        color: AppColors
                                                            .textFieldLabelColor,
                                                        size: 16.0.sp,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Icon(
                                                        FontAwesomeIcons.star,
                                                        color: AppColors
                                                            .textFieldLabelColor,
                                                        size: 16.0.sp,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Icon(
                                                        FontAwesomeIcons.star,
                                                        color: AppColors
                                                            .textFieldLabelColor,
                                                        size: 16.0.sp,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Icon(
                                                        FontAwesomeIcons.star,
                                                        color: AppColors
                                                            .textFieldLabelColor,
                                                        size: 16.0.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10.0.w,
                                            top: 72.0.w,
                                            child: Container(
                                              width: 303.0.w,
                                              height: 72.0.w,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1.50.w,
                                                      color:
                                                          const Color.fromRGBO(
                                                              158,
                                                              158,
                                                              158,
                                                              1)),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: TextFormField(
                                                  maxLines: null,
                                                  maxLength: 500,
                                                  style: TextStyle(
                                                    fontSize: 12.0.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Write your review of this recipe here',
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                      bottom: -10.0.w,
                                                      left: 16.0.w,
                                                      top: -5.0.w,
                                                    ),
                                                    labelStyle:
                                                        GoogleFonts.montserrat(
                                                      color: AppColors
                                                          .textFieldLabelColor,
                                                      fontSize: 12.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    controller.feedback.value =
                                                        value;
                                                  }
                                                  // controller.filterStore(value),
                                                  ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 154.0.w,
                                            right: 10.0.w,
                                            child: Obx(
                                              () => AmdButton(
                                                press:
                                                    controller.feedback.value !=
                                                            ""
                                                        ? () {}
                                                        : null,
                                                buttoncolor:
                                                    AppColors.greenColor,
                                                size: Size(
                                                  116.0.w,
                                                  24.0.w,
                                                ),
                                                child: AmdText(
                                                  text: 'Publish this review',
                                                  color:
                                                      AppColors.whitetextColor,
                                                  size: 10.0.sp,
                                                  weight: FontWeight.w100,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 164.0.w,
                                            left: 10.0.w,
                                            child: SizedBox(
                                              width: 120.0.w,
                                              height: 24.0.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.circleInfo,
                                                    size: 15.0.w,
                                                    color: AppColors
                                                        .textFieldLabelColor,
                                                  ),
                                                  Obx(
                                                    () => Center(
                                                      child: AmdText(
                                                        text:
                                                            '${controller.remainingChars} characters left',
                                                        color: AppColors
                                                            .whitetextColor,
                                                        size: 10.0.sp,
                                                        weight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 15.0.w,
                                            child: SizedBox(
                                              width: 343.0.w,
                                              height: 120.0.w,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  // physics:
                                                  //     const NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: controller
                                                      .feedbackData.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8.0.w,
                                                        top: 8.0.w,
                                                      ),
                                                      child: SizedBox(
                                                        width: 308.0.w,
                                                        height: 120.0.w,
                                                        child: Stack(
                                                          children: [
                                                            Positioned(
                                                              child: Container(
                                                                width: 38.0.w,
                                                                height: 38.0.w,
                                                                decoration:
                                                                    ShapeDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        AssetImage(
                                                                      controller
                                                                              .feedbackData[index]
                                                                          [
                                                                          'image'],
                                                                    ),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                  shape:
                                                                      const OvalBorder(),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0.0.w,
                                                              left: 46.0.w,
                                                              child: SizedBox(
                                                                width: 257.0.w,
                                                                height: 20.0.w,
                                                                child: AmdText(
                                                                  text: controller
                                                                              .feedbackData[
                                                                          index]
                                                                      ['title'],
                                                                  color: AppColors
                                                                      .blackColor,
                                                                  size: 16.0.w,
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 1.2,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 24.0.w,
                                                              left: 46.0.w,
                                                              child: SizedBox(
                                                                width: 257.0.w,
                                                                height: 18.0.w,
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            100.0.w,
                                                                        height:
                                                                            18.0.w,
                                                                        child: ListView
                                                                            .builder(
                                                                          itemCount: controller
                                                                              .feedbackData
                                                                              .length,
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            var myIndex =
                                                                                index + 1;

                                                                            int ratingValue =
                                                                                controller.feedbackData[index]['rating'];

                                                                            return Padding(
                                                                              padding: EdgeInsets.only(right: 2.0.w),
                                                                              child: SizedBox(
                                                                                height: 18.0.w,
                                                                                width: 18.0.w,
                                                                                child: Icon(
                                                                                  FontAwesomeIcons.star,
                                                                                  size: 16.0.sp,
                                                                                  color: myIndex <= ratingValue ? AppColors.yellowColor : AppColors.textFieldLabelColor,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 100.0
                                                                          .w,
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            100.0.w,
                                                                        height:
                                                                            18.0.w,
                                                                        child:
                                                                            AmdText(
                                                                          text: controller.feedbackData[index]
                                                                              [
                                                                              'time'],
                                                                          color:
                                                                              AppColors.blackColor,
                                                                          size:
                                                                              13.0.w,
                                                                          weight:
                                                                              FontWeight.w400,
                                                                          maxLines:
                                                                              3,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: 5.0.w,
                                                              left: 0.0.w,
                                                              child: SizedBox(
                                                                width: 310.0.w,
                                                                height: 57.0.w,
                                                                child: AmdText(
                                                                  text: controller
                                                                              .feedbackData[
                                                                          index]
                                                                      [
                                                                      'description'],
                                                                  color: AppColors
                                                                      .blackColor,
                                                                  size: 13.0.w,
                                                                  weight:
                                                                      FontWeight
                                                                          .w400,
                                                                  maxLines: 3,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
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
                          SizedBox(
                            height: 50.0.w,
                          ),
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: controller.menuIndex.value != 3
          ? Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: SizedBox(
                height: 27.0.w,
                width: 355.0.w,
                child: Stack(
                  children: [
                    Positioned(
                      left: 32.0.w,
                      top: 0.0.w,
                      bottom: 0.0.w,
                      child: AmdButton(
                        press: () {},
                        radius: 49.0.w,
                        buttoncolor: AppColors.greenColor,
                        size: Size(
                          101.0.w,
                          27.0.w,
                        ),
                        child: AmdText(
                          text: "Book Table",
                          color: AppColors.whitetextColor,
                          size: 12.0.w,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.0.w,
                      bottom: 0.0.w,
                      right: 32.0.w,
                      child: AmdButton(
                        press: () {},
                        radius: 49.0.w,
                        buttoncolor: AppColors.greenColor,
                        size: Size(
                          101.0.w,
                          27.0.w,
                        ),
                        child: AmdText(
                          text: "Pay",
                          color: AppColors.whitetextColor,
                          size: 12.0.w,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
