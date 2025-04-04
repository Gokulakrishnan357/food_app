import 'package:zeroq/const/app_exports.dart';

import './pick_up_controller.dart';

class PickUpPage extends GetView<PickUpController> {
  const PickUpPage({super.key});

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
          text: 'Pick-up Food',
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
        height: 732.0.w,
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
                      borderRadius: BorderRadius.circular(18),
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
                    onChanged: (value) => controller.filterStore(value),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: 0.0.w,
                    top: 26.0.w,
                  ),
                  child: SizedBox(
                    height: 26.0.w,
                    width: 324.0.w,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: controller.foodCategory.length,
                      itemBuilder: (context, index) {
                        var foodCategoryData = controller.foodCategory[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: 8.0.w,
                            bottom: 2.0.w,
                            top: 2.0.w,
                          ),
                          child: Container(
                            width: 75.0.w,
                            height: 24.0.w,
                            decoration: ShapeDecoration(
                              color: AppColors.whitetextColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0.w),
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
                            child: Center(
                              child: AmdText(
                                text: foodCategoryData['foodName'],
                                color: AppColors.dineInTextLabelColor,
                                size: 12.0.sp,
                                weight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                /// Restorents List
                Padding(
                  padding: EdgeInsets.only(
                    left: 0.0.w,
                    top: 26.0.w,
                  ),
                  child: Obx(
                    () => ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      // scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: controller.foundStores.value.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: 16.0.w,
                            bottom: 16.0.w,
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: SizedBox(
                              height: 150.0.w,
                              width: 297.0.w,
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Container(
                                      height: 150.0.w,
                                      width: 130.0.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.whitetextColor,
                                        borderRadius: BorderRadius.circular(
                                          20.0.w,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            controller.foundStores.value[index]
                                                ['image'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 156.0.w,
                                    top: 30.5.w,
                                    child: SizedBox(
                                      height: 20.0.w,
                                      width: 105.0.w,
                                      child: AmdText(
                                        text: controller.foundStores
                                            .value[index]['storeName'],
                                        size: 16.0.sp,
                                        weight: FontWeight.w600,
                                        color: AppColors.greenColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 156.0.w,
                                    top: 59.5.w,
                                    child: SizedBox(
                                      height: 10.0.w,
                                      width: 10.0.w,
                                      child: Icon(
                                        FontAwesomeIcons.solidStar,
                                        size: 8.0.sp,
                                        color: AppColors.yellowColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 174.0.w,
                                    top: 58.5.w,
                                    child: SizedBox(
                                      height: 15.0.w,
                                      width: 100.0.w,
                                      child: AmdText(
                                        text: controller.foundStores
                                            .value[index]['storeRating'],
                                        size: 12.0.sp,
                                        weight: FontWeight.w400,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 156.0.w,
                                    top: 81.5.w,
                                    child: SizedBox(
                                      height: 15.0.w,
                                      width: 141.0.w,
                                      child: AmdText(
                                        text: controller
                                            .foundStores.value[index]['dish'],
                                        size: 12.0.sp,
                                        weight: FontWeight.w400,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 156.0.w,
                                    top: 104.5.w,
                                    child: SizedBox(
                                      height: 15.0.w,
                                      width: 145.0.w,
                                      child: AmdText(
                                        text: controller.foundStores
                                            .value[index]['storeDistance'],
                                        size: 12.0.sp,
                                        weight: FontWeight.w400,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 311.0.w,
                                    top: 33.5.w,
                                    child: SizedBox(
                                      height: 10.0.w,
                                      width: 10.0.w,
                                      child: Icon(
                                        FontAwesomeIcons.chevronRight,
                                        size: 12.0.sp,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
