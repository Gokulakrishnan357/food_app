import 'package:cached_network_image/cached_network_image.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:zeroq/models/cart/local_cart_items.dart';
import 'package:zeroq/precentation/cart/cart_payment_controller.dart';
import 'package:zeroq/precentation/pick_up/components/hotel_menu/hotel_menu_controller.dart';
import 'package:zeroq/server/app_storage.dart';

import '../../const/app_exports.dart';
import './cart_controller.dart';

class CartPage extends GetView<CartController> {
  CartPage({super.key});

  final hotalMenuController = Get.find<HotelMenuController>();
  final CartPaymentController cartPaymentController =
      Get.find<CartPaymentController>();
  final HotelMenuController controller1 = Get.put(HotelMenuController());

  void addItems() async {
    hotalMenuController.restaurantId.value =
        controller.cart.value!.restaurantId.toString();
    await hotalMenuController.fetchRestaurantsMenuByIdFromGraph();
    await hotalMenuController.fetchRestaurantsByIdFromGraph();
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.toNamed(AmdRoutesClass.hotelMenuPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: AppColors.greenColor,
          ),
        ),
        title: AmdText(
          text: 'Your Cart',
          color: AppColors.blackColor,
          height: 0.8,
          size: 17.0.sp,
          weight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final cart = controller.cart.value;
        if (cart == null || cart.cartItems.isEmpty) {
          return Column(
            children: [
              Image.asset("assets/icons/emptycart1.png"),
              AmdButton(
                press: () {
                  final categories = controller.getCategories;
                  categories.forEach((category) {
                    print("Category Image URLs:");
                    print(category.imageUrl);
                  });
                  Get.offNamed(AmdRoutesClass.pickUpPage);
                },
                size: Size(200.0.w, 50.0.w),
                buttoncolor: AppColors.greenColor,
                child: const AmdText(
                  text: "Browse Restaurants",
                  color: AppColors.whitetextColor,
                ),
              ),
            ],
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Cart Items List
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cart.cartItems.length,
                      itemBuilder: (context, index) {
                        var product = cart.cartItems[index];
                        var data = controller1.filteredMenuItem[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.0.w),
                          child: Container(
                            width: 343.w,
                            height: 184.8.w,
                            padding: EdgeInsets.symmetric(vertical: 20.0.w),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      data.isVeg
                                          ? 'assets/icons/veg1.png'
                                          : 'assets/icons/nonVeg.png',
                                      width: 14.w,
                                      height: 14.w,
                                    ),
                                    SizedBox(height: 10.w),
                                    SizedBox(
                                      width: 180.0.w,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4.0.w),
                                        child: RichText(
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "${product.menuName}  ",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "(₹${product.price} per item)",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    119,
                                                    130,
                                                    119,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.w),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6.0,
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.indianRupeeSign,
                                            size: 13.w,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          "${product.totalPrice}",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      mainAxisSize:
                                          MainAxisSize
                                              .min, // Prevents column from expanding unnecessarily
                                      children: [
                                        // Image Container
                                        Container(
                                          width: 90.w,
                                          height: 90.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.w,
                                            ),
                                            color: Colors.grey[200],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8.w,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: product.imageUrl.trim(),
                                              fit: BoxFit.cover,
                                              width: 130.w,
                                              height: 130.w,
                                              placeholder:
                                                  (context, url) => Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.grey,
                                                        ),
                                                  ),
                                              errorWidget: (
                                                context,
                                                url,
                                                error,
                                              ) {
                                                print(
                                                  "Image failed to load: $url",
                                                );
                                                return const Icon(
                                                  Icons.image_not_supported,
                                                  size: 40,
                                                  color: Colors.grey,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5.w),

                                        // Button Container (centered horizontally)
                                        Container(
                                          height: 30.w, // Same height
                                          width: 85.w, // Same width
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF428813),
                                                Color(0xFF6ACB29),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8.0.w,
                                            ), // Same border radius
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap:
                                                    () => controller
                                                        .decreaseQuantity(
                                                          product,
                                                          1,
                                                        ),
                                                child: Icon(
                                                  FontAwesomeIcons.minus,
                                                  color: Colors.white,
                                                  size:
                                                      18.0.sp, // Adjusted for consistency
                                                ),
                                              ),
                                              AmdText(
                                                text: '${product.quantity}',
                                                size: 14.0.sp, // Same size
                                                color: Colors.white,
                                                textAlign: TextAlign.center,
                                                weight: FontWeight.w700,
                                              ),
                                              InkWell(
                                                onTap:
                                                    () => controller
                                                        .increaseQuantity(
                                                          product,
                                                          1,
                                                        ),
                                                child: Icon(
                                                  FontAwesomeIcons.plus,
                                                  color: Colors.white,
                                                  size:
                                                      18.0.sp, // Adjusted for consistency
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Add More Items Button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0.w,
                      vertical: 20.w,
                    ),
                    child: TextButton(
                      onPressed: addItems,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColors.greenColor.withOpacity(0.1),
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          AppColors.greenColor,
                        ),
                        side: MaterialStateProperty.all(
                          const BorderSide(
                            color: AppColors.greenColor,
                            width: 1.5,
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add,
                            color: AppColors.greenColor,
                            size: 18,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Add More Items",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Billing Section
                  Container(
                    width: 380.0.w,
                    padding: EdgeInsets.all(16.0.w),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0.w),
                          topRight: Radius.circular(24.0.w),
                        ),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x145A6CEA),
                          blurRadius: 50,
                          offset: Offset(12, 26),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Bill Details Heading
                        SizedBox(
                          width: 332.0.w,
                          child: AmdText(
                            text: 'Bill Details',
                            color: Colors.black,
                            size: 18.0.sp,
                            weight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 30.w),

                        // Item Total
                        SizedBox(
                          width: 332.0.w,
                          height: 30.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AmdText(
                                text: 'Item Total',
                                color: Colors.black,
                                size: 16.0.sp,
                                weight: FontWeight.w500,
                              ),
                              AmdText(
                                text: '₹ ${controller.totalCartPrice}',
                                textAlign: TextAlign.right,
                                color: Colors.black,
                                size: 16.0.sp,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.w),

                        // Delivery Fee
                        SizedBox(
                          width: 332.0.w,
                          height: 30.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AmdText(
                                text: 'Delivery Fee',
                                color: Colors.black,
                                size: 16.0.sp,
                                weight: FontWeight.w500,
                              ),
                              AmdText(
                                text:
                                    controller.subTotal.value != 0 &&
                                            controller.localCartItems.isNotEmpty
                                        ? '₹ ${controller.deleveryCharge.value}'
                                        : '₹ 0',
                                textAlign: TextAlign.right,
                                color: Colors.black,
                                size: 16.0.sp,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.w),

                        // GST & Taxes
                        SizedBox(
                          width: 332.0.w,
                          height: 30.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AmdText(
                                text: 'GST & Taxes',
                                color: Colors.black,
                                size: 16.0.sp,
                                weight: FontWeight.w500,
                              ),
                              AmdText(
                                text: '₹ ${cart.gstAmount.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                                color: Colors.black,
                                size: 16.0.sp,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.w),

                        // Platform Fee
                        SizedBox(
                          width: 332.0.w,
                          height: 30.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AmdText(
                                text: 'Platform Fee',
                                color: Colors.black,
                                size: 16.0.sp,
                                weight: FontWeight.w500,
                              ),
                              AmdText(
                                text:
                                    '₹ ${cart.selfPickupPlatformFee?.toStringAsFixed(2) ?? '0.00'}',
                                textAlign: TextAlign.right,
                                color: Colors.black,
                                size: 16.0.sp,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.w),

                        // Divider
                        Divider(color: Colors.black, height: 2.0.w),
                        SizedBox(height: 20.w),

                        // To Pay
                        SizedBox(
                          width: 332.0.w,
                          height: 30.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AmdText(
                                text: 'To Pay',
                                color: Colors.black,
                                size: 18.0.sp,
                                weight: FontWeight.w600,
                              ),
                              AmdText(
                                text:
                                    "₹ ${(controller.totalCartPrice.toDouble() + controller.deleveryCharge.value.toDouble() + cart.gstAmount + (cart.selfPickupPlatformFee?.toDouble() ?? 0.0)).toStringAsFixed(2)}",
                                textAlign: TextAlign.right,
                                color: Colors.black,
                                size: 18.0.sp,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.w),

                        // Continue Button
                        ClipRRect(
                          borderRadius: BorderRadius.circular(45.0.w),
                          child: SizedBox(
                            width: 327.0.w,
                            height: 41.0.w,
                            child: AmdButton(
                              press: () async {
                                var userId = await AmdStorage().readCache(
                                  'userId',
                                );
                                if (userId != null && userId.isNotEmpty) {
                                  controller.createOrderGraphQL();
                                } else {
                                  await QuickAlert.show(
                                    context: Get.context!,
                                    type: QuickAlertType.warning,
                                    text: 'Please Register / SignIn!',
                                    onConfirmBtnTap: () {
                                      Get.back();
                                      Get.toNamed(AmdRoutesClass.authPage);
                                    },
                                    headerBackgroundColor: Colors.green,
                                  );
                                }
                              },
                              size: Size(327.0.w, 42.0.w),
                              buttoncolor: Colors.green,
                              radius: 45.0.w,
                              child: AmdText(
                                text: "Continue",
                                color: Colors.white,
                                size: 14.0.sp,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Loading Indicator
            if (cartPaymentController.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
