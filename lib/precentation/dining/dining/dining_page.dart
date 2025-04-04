
import 'package:zeroq/precentation/dining/dining_menu/dining_menu_controller.dart';
import '../../../const/app_exports.dart';
import './dining_controller.dart';

class DiningPage extends GetView<DiningController> {
  const DiningPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(
        375,
        812,
      ),
    );
    var diningController = Get.put(DiningMenuController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            FontAwesomeIcons.locationDot,
            color: AppColors.whitetextColor,
            size: 20.0.sp,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AmdText(
              text: "Chrompet",
              color: AppColors.whitetextColor,
              size: 15.0.sp,
              weight: FontWeight.w500,
            ),
            AmdText(
              text:
                  "No 2a, State Bank Colony,2nd St, ext,Chitlapakkam,Chennai - 64",
              color: AppColors.whitetextColor,
              size: 12.0.sp,
              weight: FontWeight.w500,
              maxLines: 1,
            ),
          ],
        ),
        elevation: 0.0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24.0.w),
            child: Container(
              width: 36.0.w,
              height: 36.0.w,
              decoration: const ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppImageStrings.appAppBarUserImage,
                  ),
                  fit: BoxFit.fill,
                ),
                shape: OvalBorder(),
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.greenColor,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              "assets/images/commingsoon.gif",
            ),
            Image.asset(
              "assets/images/Coming-Soon.gif",
            ),
          ],
        ),
      ),
      // SizedBox(
      //   height: 812.0.w,
      //   width: 375.0.w,
      //   child: Padding(
      //     padding: EdgeInsets.only(
      //       top: 26.0.w,
      //     ),
      //     child: SingleChildScrollView(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           /// Search Restorents
      //           Padding(
      //             padding: EdgeInsets.only(
      //               left: 24.0.w,
      //             ),
      //             child: SizedBox(
      //               width: 326.0.w,
      //               height: 46.0.w,
      //               child: Stack(
      //                 children: [
      //                   Positioned(
      //                     child: Container(
      //                       width: 269.0.w,
      //                       height: 46.0.w,
      //                       decoration: ShapeDecoration(
      //                         color: AppColors.whitetextColor,
      //                         shape: RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(
      //                             18.0.w,
      //                           ),
      //                         ),
      //                         shadows: const [
      //                           BoxShadow(
      //                             color: Color(0x3F000000),
      //                             blurRadius: 26.25,
      //                             offset: Offset(
      //                               5.65,
      //                               5.65,
      //                             ),
      //                             spreadRadius: 0,
      //                           )
      //                         ],
      //                       ),
      //                       child: TextFormField(
      //                         decoration: InputDecoration(
      //                           labelText: 'Search',
      //                           floatingLabelBehavior:
      //                               FloatingLabelBehavior.never,
      //                           border: InputBorder.none,
      //                           contentPadding: EdgeInsets.only(
      //                               bottom: 16.0.w, left: 16.0.w),
      //                           // prefixIcon: const Icon(FontAwesomeIcons.barcode),
      //                           prefixIcon: const Icon(
      //                             FontAwesomeIcons.magnifyingGlass,
      //                             color: Colors.black26,
      //                           ),
      //                           labelStyle: GoogleFonts.montserrat(
      //                             color: AppColors.textFieldLabelColor,
      //                             fontSize: 12.0.sp,
      //                             fontWeight: FontWeight.w400,
      //                           ),
      //                         ),
      //                         // onChanged: (value) => controller.filterStore(value),
      //                       ),
      //                     ),
      //                   ),
      //                   Positioned(
      //                     right: 0.0.w,
      //                     child: InkWell(
      //                       onTap: () {},
      //                       child: Container(
      //                         width: 48.0.w,
      //                         height: 46.0.w,
      //                         decoration: ShapeDecoration(
      //                           color: AppColors.whitetextColor,
      //                           shape: RoundedRectangleBorder(
      //                             borderRadius: BorderRadius.circular(
      //                               18.0.w,
      //                             ),
      //                           ),
      //                           shadows: const [
      //                             BoxShadow(
      //                               color: Color(0x3F000000),
      //                               blurRadius: 26.25,
      //                               offset: Offset(
      //                                 5.65,
      //                                 5.65,
      //                               ),
      //                               spreadRadius: 0,
      //                             )
      //                           ],
      //                         ),
      //                         child: Padding(
      //                           padding: EdgeInsets.symmetric(
      //                             horizontal: 11.0.w,
      //                             vertical: 11.0.w,
      //                           ),
      //                           child: Image.asset(
      //                             AppImageStrings.appDiningfilter,
      //                             width: 25.0.w,
      //                             height: 15.0.w,
      //                             color: AppColors.greenColor,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.only(
      //               right: 16.0.w,
      //               top: 24.0.w,
      //               left: 24.0.w,
      //             ),
      //             child: const Divider(
      //               color: Colors.grey,
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.only(
      //               top: 24.0.w,
      //               left: 24.0.w,
      //             ),
      //             child: SizedBox(
      //               height: 118.0.w,
      //               width: 327.0.w,
      //               child: Image.asset(
      //                 AppImageStrings.appDiningsliderImage1,
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //           ),

      //           Padding(
      //             padding: EdgeInsets.only(
      //               top: 24.0.w,
      //               left: 24.0.w,
      //             ),
      //             child: SizedBox(
      //               width: 327.0.w,
      //               height: 24.0.w,
      //               child: Stack(
      //                 children: [
      //                   Positioned(
      //                     top: 0.0.w,
      //                     left: 0.0.w,
      //                     child: SizedBox(
      //                       width: 185.0.w,
      //                       height: 24.0.w,
      //                       child: AmdText(
      //                         text: AppTextStrings.appDiningNearBLocation,
      //                         color: AppColors.blackColor,
      //                         size: 16.0.sp,
      //                         weight: FontWeight.w700,
      //                         height: 1.4,
      //                       ),
      //                     ),
      //                   ),
      //                   Positioned(
      //                     top: 0.0.w,
      //                     right: 0.0.w,
      //                     child: InkWell(
      //                       onTap: () {},
      //                       child: SizedBox(
      //                         width: 55.0.w,
      //                         height: 24.0.w,
      //                         child: AmdText(
      //                           text: AppTextStrings.appDiningSeeAll,
      //                           color: AppColors.darkBlueColor,
      //                           size: 14.0.sp,
      //                           weight: FontWeight.w400,
      //                           height: 1.8,
      //                           textAlign: TextAlign.right,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.only(
      //               top: 24.0.w,
      //               left: 24.0.w,
      //             ),
      //             child: SizedBox(
      //               width: 328.86.w,
      //               height: 28.0.w,
      //               child: ListView.builder(
      //                 itemCount: controller.filterCategory.length,
      //                 scrollDirection: Axis.horizontal,
      //                 itemBuilder: (context, index) {
      //                   var data = controller.filterCategory[index];
      //                   return Padding(
      //                     padding: EdgeInsets.only(
      //                       right: 20.0.w,
      //                       top: 1.0.w,
      //                       bottom: 1.0.w,
      //                     ),
      //                     child: Container(
      //                       width: 83.0.w,
      //                       height: 26.0.w,
      //                       padding: const EdgeInsets.symmetric(horizontal: 8),
      //                       decoration: ShapeDecoration(
      //                         color: AppColors.whitetextColor,
      //                         shape: RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(10.0.w),
      //                         ),
      //                         shadows: const [
      //                           BoxShadow(
      //                             color: Color(0x1E1B1F35),
      //                             blurRadius: 4,
      //                             offset: Offset(0, 1),
      //                             spreadRadius: 0,
      //                           )
      //                         ],
      //                       ),
      //                       child: Center(
      //                         child: AmdText(
      //                           text: data['title'],
      //                           color: AppColors.blackColor,
      //                           size: 12.0.sp,
      //                           weight: FontWeight.w400,
      //                           height: 1.0,
      //                           textAlign: TextAlign.center,
      //                         ),
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.only(
      //               left: 13.6.w,
      //               top: 26.0.w,
      //             ),
      //             child: Obx(() {
      //               // print("The data is ${controller.getAllStore.value.data}");
      //               return controller.getAllStore.value.restaurantData != null
      //                   ? GridView.builder(
      //                       gridDelegate:
      //                           SliverGridDelegateWithFixedCrossAxisCount(
      //                         crossAxisCount: 2,
      //                         crossAxisSpacing: 12.0,
      //                         mainAxisSpacing: 24.0,
      //                         mainAxisExtent:
      //                             257.0.w, // here set custom Height You Want

      //                         // childAspectRatio: (155.0.w / 190.0.w),
      //                         // childAspectRatio: (2 / 2),
      //                       ),
      //                       physics: const NeverScrollableScrollPhysics(),
      //                       scrollDirection: Axis.vertical,
      //                       shrinkWrap: true,
      //                       itemCount: controller
      //                           .getAllStore.value.restaurantData!.length,
      //                       padding: EdgeInsets.only(
      //                         right: 17.0.w,
      //                       ),
      //                       primary: true,
      //                       itemBuilder: (context, index) {
      //                         var foodCategorysData = controller
      //                             .getAllStore.value.restaurantData![index];
      //                         print(foodCategorysData);
      //                         return InkWell(
      //                           onTap: () {
      //                             Timer timer = Timer(Duration(seconds: 1), () {
      //                               Get.toNamed(
      //                                 AmdRoutesClass.diningMenuPage,
      //                               );
      //                             });
      //                             diningController.restarendId.value =
      //                                 foodCategorysData.imageName!;
      //                             diningController.fetchRestaurantById(
      //                                 foodCategorysData.imageName!);
      //                             print(foodCategorysData.imageName!);
      //                           },
      //                           child: SizedBox(
      //                             width: 168.0.w,
      //                             height: 257.0.w,
      //                             child: Stack(
      //                               children: [
      //                                 Positioned(
      //                                   bottom: 0.0.w,
      //                                   child: Container(
      //                                     width: 168.0.w,
      //                                     height: 128.0.w,
      //                                     decoration: ShapeDecoration(
      //                                       color: AppColors.whitetextColor,
      //                                       shape: RoundedRectangleBorder(
      //                                         borderRadius: BorderRadius.only(
      //                                           bottomLeft:
      //                                               Radius.circular(12.0.w),
      //                                           bottomRight:
      //                                               Radius.circular(12.0.w),
      //                                         ),
      //                                       ),
      //                                       shadows: const [
      //                                         BoxShadow(
      //                                           color: Color(0x0F121212),
      //                                           blurRadius: 16,
      //                                           offset: Offset(4, 4),
      //                                           spreadRadius: 0,
      //                                         )
      //                                       ],
      //                                     ),
      //                                     child: Stack(
      //                                       children: [
      //                                         Positioned(
      //                                           top: 12.0.w,
      //                                           left: 12.0.w,
      //                                           child: SizedBox(
      //                                             width: 144.0.w,
      //                                             height: 18.0.w,
      //                                             child: AmdText(
      //                                               text: foodCategorysData
      //                                                           .restaurantName !=
      //                                                       null
      //                                                   ? foodCategorysData
      //                                                       .restaurantName!
      //                                                   : "",
      //                                               color: AppColors.blackColor,
      //                                               size: 12.0.sp,
      //                                               weight: FontWeight.w400,
      //                                               maxLines: 1,
      //                                               overflow:
      //                                                   TextOverflow.ellipsis,
      //                                             ),
      //                                           ),
      //                                         ),
      //                                         Positioned(
      //                                           top: 34.0.w,
      //                                           left: 12.0.w,
      //                                           child: SizedBox(
      //                                             width: 46.0.w,
      //                                             height: 20.0.w,
      //                                             child: Row(
      //                                               mainAxisAlignment:
      //                                                   MainAxisAlignment
      //                                                       .spaceBetween,
      //                                               children: [
      //                                                 Icon(
      //                                                   FontAwesomeIcons.star,
      //                                                   color: AppColors
      //                                                       .yellowColor,
      //                                                   size: 18.0.sp,
      //                                                 ),
      //                                                 AmdText(
      //                                                   text: foodCategorysData
      //                                                               .restaurantId !=
      //                                                           null
      //                                                       ? foodCategorysData
      //                                                           .restaurantId
      //                                                           .toString()
      //                                                       : "",
      //                                                   color: AppColors
      //                                                       .blackColor,
      //                                                   size: 12.0.sp,
      //                                                   weight: FontWeight.w400,
      //                                                   maxLines: 1,
      //                                                   overflow: TextOverflow
      //                                                       .ellipsis,
      //                                                 ),
      //                                               ],
      //                                             ),
      //                                           ),
      //                                         ),
      //                                         Positioned(
      //                                           top: 58.0.w,
      //                                           left: 12.0.w,
      //                                           child: SizedBox(
      //                                             width: 144.0.w,
      //                                             height: 36.0.w,
      //                                             child: AmdText(
      //                                               text: "Chitlapakkam",
      //                                               color: const Color.fromRGBO(
      //                                                   135, 135, 135, 1),
      //                                               size: 12.0.sp,
      //                                               weight: FontWeight.w400,
      //                                               maxLines: 2,
      //                                               overflow:
      //                                                   TextOverflow.ellipsis,
      //                                             ),
      //                                           ),
      //                                         ),
      //                                         Positioned(
      //                                           top: 98.0.w,
      //                                           left: 12.0.w,
      //                                           child: SizedBox(
      //                                             width: 144.0.w,
      //                                             height: 18.0.w,
      //                                             child: RichText(
      //                                               text: TextSpan(
      //                                                   text: foodCategorysData
      //                                                               .image !=
      //                                                           null
      //                                                       ? foodCategorysData
      //                                                           .image!
      //                                                       : "",
      //                                                   style: GoogleFonts
      //                                                       .montserrat(
      //                                                     color: AppColors
      //                                                         .darkBlueColor,
      //                                                     fontSize: 12.0.sp,
      //                                                     fontWeight:
      //                                                         FontWeight.w400,
      //                                                   ),
      //                                                   children: [
      //                                                     TextSpan(
      //                                                       text: " /table",
      //                                                       style: GoogleFonts
      //                                                           .montserrat(
      //                                                         color: AppColors
      //                                                             .blackColor,
      //                                                         fontSize: 12.0.sp,
      //                                                         fontWeight:
      //                                                             FontWeight
      //                                                                 .w400,
      //                                                       ),
      //                                                     ),
      //                                                   ]),
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     ),
      //                                   ),
      //                                 ),
      //                                 Positioned(
      //                                   top: 0.0.w,
      //                                   left: 0.0.w,
      //                                   right: 0.0.w,
      //                                   child: Container(
      //                                     width: 168.0.w,
      //                                     height: 129.0.w,
      //                                     decoration: ShapeDecoration(
      //                                       image:
      //                                           foodCategorysData.image != null
      //                                               ? DecorationImage(
      //                                                   image: MemoryImage(
      //                                                     base64Decode(
      //                                                       foodCategorysData
      //                                                                   .image !=
      //                                                               null
      //                                                           ? foodCategorysData
      //                                                               .image
      //                                                               .toString()
      //                                                           : "",
      //                                                     ),
      //                                                   ),
      //                                                   onError: (exception,
      //                                                       stackTrace) {},
      //                                                   fit: BoxFit.contain,
      //                                                 )
      //                                               : const DecorationImage(
      //                                                   image: AssetImage(
      //                                                     "assets/icons/No_Image_Available.png",
      //                                                   ),
      //                                                   fit: BoxFit.contain,
      //                                                 ),
      //                                       shape: RoundedRectangleBorder(
      //                                         borderRadius: BorderRadius.only(
      //                                           topLeft:
      //                                               Radius.circular(12.0.w),
      //                                           topRight:
      //                                               Radius.circular(12.0.w),
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 )
      //                               ],
      //                             ),
      //                           ),
      //                         );
      //                       },
      //                     )
      //                   : const Center(
      //                       child: CircularProgressIndicator(
      //                       color: AppColors.greenColor,
      //                     ));
      //             }),
      //           ),
      //           SizedBox(
      //             height: 20.0.w,
      //           ),
      //           // /// Restorents List
      //           // Padding(
      //           //   padding: EdgeInsets.only(
      //           //     left: 0.0.w,
      //           //     top: 26.0.w,
      //           //   ),
      //           //   child: Obx(
      //           //     () => ListView.builder(
      //           //       physics: const NeverScrollableScrollPhysics(),
      //           //       // scrollDirection: Axis.horizontal,
      //           //       shrinkWrap: true,
      //           //       itemCount: controller.foundStores.value.length,
      //           //       itemBuilder: (context, index) {
      //           //         return Padding(
      //           //           padding: EdgeInsets.only(
      //           //             right: 16.0.w,
      //           //             bottom: 16.0.w,
      //           //           ),
      //           //           child: InkWell(
      //           //             onTap: () {},
      //           //             child: SizedBox(
      //           //               height: 150.0.w,
      //           //               width: 297.0.w,
      //           //               child: Stack(
      //           //                 children: [
      //           //                   Positioned(
      //           //                     child: Container(
      //           //                       height: 150.0.w,
      //           //                       width: 130.0.w,
      //           //                       decoration: BoxDecoration(
      //           //                         color: AppColors.whitetextColor,
      //           //                         borderRadius: BorderRadius.circular(
      //           //                           20.0.w,
      //           //                         ),
      //           //                         image: DecorationImage(
      //           //                           image: AssetImage(
      //           //                             controller.foundStores.value[index]
      //           //                                 ['image'],
      //           //                           ),
      //           //                         ),
      //           //                       ),
      //           //                     ),
      //           //                   ),
      //           //                   Positioned(
      //           //                     left: 156.0.w,
      //           //                     top: 30.5.w,
      //           //                     child: SizedBox(
      //           //                       height: 20.0.w,
      //           //                       width: 105.0.w,
      //           //                       child: AmdText(
      //           //                         text: controller.foundStores
      //           //                             .value[index]['storeName'],
      //           //                         size: 16.0.sp,
      //           //                         weight: FontWeight.w600,
      //           //                         color: AppColors.greenColor,
      //           //                       ),
      //           //                     ),
      //           //                   ),
      //           //                   Positioned(
      //           //                     left: 156.0.w,
      //           //                     top: 59.5.w,
      //           //                     child: SizedBox(
      //           //                       height: 10.0.w,
      //           //                       width: 10.0.w,
      //           //                       child: Icon(
      //           //                         FontAwesomeIcons.solidStar,
      //           //                         size: 8.0.sp,
      //           //                         color: AppColors.yellowColor,
      //           //                       ),
      //           //                     ),
      //           //                   ),
      //           //                   Positioned(
      //           //                     left: 174.0.w,
      //           //                     top: 58.5.w,
      //           //                     child: SizedBox(
      //           //                       height: 15.0.w,
      //           //                       width: 100.0.w,
      //           //                       child: AmdText(
      //           //                         text: controller.foundStores
      //           //                             .value[index]['storeRating'],
      //           //                         size: 12.0.sp,
      //           //                         weight: FontWeight.w400,
      //           //                         color: AppColors.blackColor,
      //           //                       ),
      //           //                     ),
      //           //                   ),
      //           //                   Positioned(
      //           //                     left: 156.0.w,
      //           //                     top: 81.5.w,
      //           //                     child: SizedBox(
      //           //                       height: 15.0.w,
      //           //                       width: 141.0.w,
      //           //                       child: AmdText(
      //           //                         text: controller
      //           //                             .foundStores.value[index]['dish'],
      //           //                         size: 12.0.sp,
      //           //                         weight: FontWeight.w400,
      //           //                         color: AppColors.blackColor,
      //           //                       ),
      //           //                     ),
      //           //                   ),
      //           //                   Positioned(
      //           //                     left: 156.0.w,
      //           //                     top: 104.5.w,
      //           //                     child: SizedBox(
      //           //                       height: 15.0.w,
      //           //                       width: 145.0.w,
      //           //                       child: AmdText(
      //           //                         text: controller.foundStores
      //           //                             .value[index]['storeDistance'],
      //           //                         size: 12.0.sp,
      //           //                         weight: FontWeight.w400,
      //           //                         color: AppColors.blackColor,
      //           //                       ),
      //           //                     ),
      //           //                   ),
      //           //                   Positioned(
      //           //                     left: 311.0.w,
      //           //                     top: 33.5.w,
      //           //                     child: SizedBox(
      //           //                       height: 10.0.w,
      //           //                       width: 10.0.w,
      //           //                       child: Icon(
      //           //                         FontAwesomeIcons.chevronRight,
      //           //                         size: 12.0.sp,
      //           //                         color: AppColors.blackColor,
      //           //                       ),
      //           //                     ),
      //           //                   ),
      //           //                 ],
      //           //               ),
      //           //             ),
      //           //           ),
      //           //         );
      //           //       },
      //           //     ),
      //           //   ),
      //           // ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
