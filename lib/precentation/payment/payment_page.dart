import 'package:zeroq/precentation/cart/cart_controller.dart';

import '../../const/app_exports.dart';
import './payment_controller.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(
        375,
        812,
      ),
    );
    var cartController = Get.put(CartController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.greenColor,
          ),
        ),
        title: AmdText(
          text: "Payment's",
          color: AppColors.blackColor,
          height: 0.8,
          size: 17.0.sp,
          weight: FontWeight.w400,
        ),
      ),
      body: SizedBox(
        width: 375.0.w,
        height: 812.0.w,
        child: Stack(
          children: [
            Positioned(
              left: 24.0.w,
              child: SizedBox(
                height: 100.0.w,
                width: 327.0.w,
                child: ListView.builder(
                  itemCount: controller.paymentCategory.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var paymentData = controller.paymentCategory[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: 8.0.w,
                      ),
                      child: SizedBox(
                        height: 100.0.w,
                        width: 86.0.w,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 7.0.w,
                              child: Container(
                                width: 85.0.w,
                                height: 72.0.w,
                                decoration: ShapeDecoration(
                                  color: const Color.fromRGBO(240, 245, 250, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10.0.w,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.all(
                                  16.0.w,
                                ),
                                child: SvgPicture.asset(
                                  paymentData['image'],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0.w,
                              child: SizedBox(
                                width: 85.0.w,
                                height: 17.0.w,
                                child: AmdText(
                                  text: paymentData['name'],
                                  color: AppColors.blackColor,
                                  textAlign: TextAlign.center,
                                  size: 12.0.sp,
                                  weight: FontWeight.w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FontStyle.normal,
                                  height: 1.2,
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
            ),
            Positioned(
              top: 163.0.w,
              left: 24.0.w,
              child: Container(
                height: 257.0.w,
                width: 327.0.w,
                decoration: ShapeDecoration(
                  color: const Color.fromRGBO(247, 248, 249, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10.0.w,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 79.69.w,
                      top: 29.0.w,
                      child: SizedBox(
                        height: 106.2.w,
                        width: 168.2.w,
                        child: SvgPicture.asset(
                          "assets/icons/card.svg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 64.0.w,
                      top: 159.0.w,
                      child: SizedBox(
                        height: 19.0.w,
                        width: 200.0.w,
                        child: AmdText(
                          text: 'No master card added',
                          color: AppColors.blackColor,
                          textAlign: TextAlign.center,
                          size: 16.0.sp,
                          weight: FontWeight.w700,
                          // maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                          style: FontStyle.normal,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 30.0.w,
                      top: 184.0.w,
                      child: SizedBox(
                        height: 61.0.w,
                        width: 266.0.w,
                        child: AmdText(
                          text:
                              'You can add a mastercard and save it for later',
                          color: AppColors.blackColor,
                          textAlign: TextAlign.center,
                          size: 15.0.sp,
                          weight: FontWeight.w400,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyle.normal,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 24.0.w,
              top: 430.0.w,
              child: InkWell(
                onTap: () {},
                child: SizedBox(
                  height: 17.0.w,
                  width: 100.0.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        FontAwesomeIcons.plus,
                        size: 15.0.sp,
                        color: AppColors.greenColor,
                      ),
                      AmdText(
                        text: 'Add New',
                        color: AppColors.greenColor,
                        textAlign: TextAlign.center,
                        size: 15.0.sp,
                        weight: FontWeight.w400,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyle.normal,
                        height: 1.2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30.0.w,
              left: 24.0.w,
              child: SizedBox(
                height: 112.0.w,
                width: 327.0.w,
                child: Stack(
                  children: [
                    Positioned(
                      child: SizedBox(
                        height: 36.0.w,
                        width: 250.0.w,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 6.0.w,
                              child: SizedBox(
                                height: 24.0.w,
                                width: 49.0.w,
                                child: AmdText(
                                  text: "Total:",
                                  size: 14.0.w,
                                  weight: FontWeight.w400,
                                  color: const Color.fromRGBO(160, 165, 186, 1),
                                  height: 1.0,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0.0.w,
                              left: 63.0.w,
                              child: SizedBox(
                                height: 36.0.w,
                                width: 187.0.w,
                                child: Obx(
                                  () => AmdText(
                                    text:
                                        "₹ ${cartController.totalAmount.value}",
                                    size: 30.0.w,
                                    weight: FontWeight.w400,
                                    color: AppColors.blackColor,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0.w,
                      child: AmdButton(
                        buttoncolor: AppColors.greenColor,
                        radius: 25.0.w,
                        press: () {
                          Get.toNamed(AmdRoutesClass.paymentSucessPage);
                        },
                        size: Size(
                          327.0.w,
                          48.0.w,
                        ),
                        child: AmdText(
                          text: "Pay & Confirm",
                          color: AppColors.whitetextColor,
                          size: 14.0.sp,
                          weight: FontWeight.w400,
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
    );
  }
}
