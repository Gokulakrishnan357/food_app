import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/cart/cart_controller.dart';
import 'package:zeroq/precentation/order_status/order_status_controller.dart';

import '../payment/components/progress_container.dart';

class OrderStatusPage extends GetView<OrderStatusController> {
  OrderStatusPage({super.key});

  final CartController cartController = Get.find<CartController>();

  Widget restaurantCard() {
    return Obx(() {
      final cart = cartController.cart.value;
      if (cart == null || cart.cartItems.isEmpty) {
        return SizedBox(); // Return an empty widget if the cart is empty
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.0.w, horizontal: 12.0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cart.restaurantName,
                style: GoogleFonts.montserrat(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: 8.0.w),

            // Display multiple cart items dynamically
            Column(
              children:
                  cart.cartItems.map((cartItem) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0.w,
                      ), // Spacing between items
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0.w),
                            child: Image.network(
                              cartItem.imageUrl,
                              height: 60.0.w,
                              width: 60.0.w,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image, size: 50.0.w);
                              },
                            ),
                          ),

                          SizedBox(width: 10.0.w),

                          // Item Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.menuName,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2.0.w),
                                Text(
                                  "Qty: ${cartItem.quantity}  |  ₹${cartItem.price}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),

            // Order Date
            SizedBox(height: 5.0.w),
            Obx(() {
              return Text(
                "Ordered at ${controller.orderDate.value}",
                style: GoogleFonts.montserrat(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(
          '/pickUpPage',
        ); // Redirect to pickUpPage when back is pressed
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // Order Status Image (Background)
              SizedBox(
                width: 500.0.w,
                height: 400.0.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20.0.w,
                  ), // Adjust the radius as needed
                  child: Image.asset(
                    "assets/images/OrderConfirmed.gif",
                    fit:
                        BoxFit
                            .cover, // Ensures it covers the entire area properly
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

              // Back Button (Positioned Over Image)
              // Positioned(
              //   top: 16.0.w,
              //   left: 16.0.w,
              //   child: InkWell(
              //     onTap: () => Get.offNamed('/pickUpPage'),
              //     child: Container(
              //       width: 30.0.w,
              //       height: 30.0.w,
              //       decoration: const BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Colors.white,
              //         boxShadow: [
              //           BoxShadow(
              //             color: Color(0x26000000),
              //             blurRadius: 30,
              //             offset: Offset(12, 12),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              // Content Below
              SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 278.0.w),
                    restaurantCard(),
                    SizedBox(height: 15.0.w),

                    // Delivery Time Section
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AmdText(
                        text: "30 Mins",
                        color: AppColors.blackColor,
                        size: 26.0.sp,
                        weight: FontWeight.w800,
                        height: 1.2,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    AmdText(
                      text: "Estimated delivery time",
                      color: AppColors.blackColor,
                      size: 14.0.sp,
                      weight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 15.0.w),

                    // Progress Indicator
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        top: 10,
                        right: 10,
                      ),
                      child: ProgressContainer(),
                    ),

                    SizedBox(height: 30.0.w),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
