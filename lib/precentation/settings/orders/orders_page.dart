import 'package:shimmer/shimmer.dart';
import 'package:zeroq/const/app_exports.dart';

import './orders_controller.dart';

class OrdersPage extends GetView<OrdersController> {
  const OrdersPage({super.key});

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
        title: const Text('OrdersPage'),
      ),
      body: SizedBox(
        width: 375.0.w,
        height: 812.0.w,
        child: Padding(
          padding: EdgeInsets.all(
            16.0.w,
          ),
          child: Obx(
            () => controller.getAllOrders != null
                ? ListView.builder(
                    itemCount: controller.getAllOrders.length,
                    itemBuilder: (context, index) {
                      var ordersData = controller.getAllOrders[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 16.0.w,
                        ),
                        child: Container(
                          width: 355.0.w,
                          height: 100.0.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.headingtextColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              10.0.w,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10.0.w,
                                left: 10.0.w,
                                child: SizedBox(
                                  width: 60.0.w,
                                  height: 19.0.w,
                                  child: AmdText(
                                    text: "Ord.Id :",
                                    color: AppColors.blackColor,
                                    size: 14.0.sp,
                                    weight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10.0.w,
                                left: 71.0.w,
                                child: SizedBox(
                                  width: 55.0.w,
                                  height: 19.0.w,
                                  child: AmdText(
                                    text: ordersData.orderStatusId.toString(),
                                    color: AppColors.blackColor,
                                    size: 14.0.sp,
                                    weight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10.0.w,
                                left: 202.0.w,
                                child: SizedBox(
                                  width: 60.0.w,
                                  height: 19.0.w,
                                  child: AmdText(
                                    text: "Pay.Id :",
                                    color: AppColors.blackColor,
                                    size: 14.0.sp,
                                    weight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10.0.w,
                                right: 4.0.w,
                                child: SizedBox(
                                  width: 70.0.w,
                                  height: 19.0.w,
                                  child: AmdText(
                                    text: ordersData.paymentOrderId.toString(),
                                    color: AppColors.blackColor,
                                    size: 14.0.sp,
                                    weight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ),

                              /// Restarent name
                              Positioned(
                                top: 39.0.w,
                                left: 10.0.w,
                                child: SizedBox(
                                  width: 290.0.w,
                                  height: 19.0.w,
                                  child: AmdText(
                                    text:
                                        "restaurant Name: ${ordersData.restaurantName!}",
                                    color: AppColors.blackColor,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    size: 14.0.sp,
                                    weight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   top: 68.0.w,
                              //   left: 10.0.w,
                              //   child: InkWell(
                              //     onTap: () {
                              //       controller.makePhoneCall(
                              //         // ordersData.restaurantContact.toString(),
                              //       );
                              //     },
                              //     child: SizedBox(
                              //       width: 150.0.w,
                              //       height: 19.0.w,
                              //       child: Row(
                              //         children: [
                              //           Icon(
                              //             FontAwesomeIcons.phone,
                              //             color: AppColors.greenColor,
                              //             size: 14.0.sp,
                              //           ),
                              //           SizedBox(
                              //             width: 10.0.w,
                              //           ),
                              //           AmdText(
                              //             text: ordersData.restaurantContact
                              //                 .toString(),
                              //             color: AppColors.blackColor,
                              //             size: 14.0.sp,
                              //             weight: FontWeight.w600,
                              //             height: 1.2,
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Positioned(
                                top: 68.0.w,
                                left: 150.0.w,
                                child: SizedBox(
                                  width: 60.0.w,
                                  height: 19.0.w,
                                  child: AmdText(
                                    text: "Status :",
                                    color: AppColors.blackColor,
                                    size: 14.0.sp,
                                    weight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 68.0.w,
                                right: 4.0.w,
                                child: SizedBox(
                                  width: 120.0.w,
                                  height: 19.0.w,
                                  child: AmdText(
                                    text: ordersData.orderStatusId != null
                                        ? ordersData.orderStatusId == 1
                                            ? "Delivered"
                                            : ordersData.orderStatusId == 2
                                                ? "Accepted"
                                                : ordersData.orderStatusId == 3
                                                    ? "Waiting to Accept"
                                                    : ordersData.orderStatusId ==
                                                            4
                                                        ? "Food Preparing"
                                                        : ordersData.orderStatusId ==
                                                                5
                                                            ? "Not Accepted"
                                                            : "Pending"
                                        : "-",
                                    color: AppColors.blackColor,
                                    size: 14.0.sp,
                                    weight: FontWeight.w600,
                                    height: 1.2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 32.0.w,
                                right: 15.0.w,
                                child: InkWell(
                                  onTap: () {
                                    controller.openMap(
                                      ordersData.latitude.toString(),
                                      ordersData.longitude.toString(),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 20.0.w,
                                    height: 20.0.w,
                                    child: const Icon(
                                      FontAwesomeIcons.mapLocationDot,
                                      color: AppColors.greenColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 355.0.w,
                            height: 100.0.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.headingtextColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                10.0.w,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
            // ListView.builder(
            //   itemCount: 1,
            //   itemBuilder: (context, index) {
            //     return Padding(
            //       padding: EdgeInsets.only(
            //         left: 10.0.w,
            //       ),
            //       child: Container(
            //         width: 200.0.w,
            //         height: 100.0.w,
            //         color: AppColors.redColor,
            //       ),
            //     );
            //   },
            // ),
          ),
        ),
      ),
    );
  }
}
