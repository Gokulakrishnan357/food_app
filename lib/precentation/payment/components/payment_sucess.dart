import 'package:confetti/confetti.dart';
import 'package:zeroq/precentation/order_status/order_status.dart';
import 'package:zeroq/precentation/order_status/order_status_binding.dart';
import '../../../const/app_exports.dart';
import '../../../precentation/payment/payment_controller.dart';

class PaymentSucess extends StatefulWidget {
  const PaymentSucess({super.key});

  @override
  _PaymentSucessState createState() => _PaymentSucessState();
}

class _PaymentSucessState extends State<PaymentSucess> {
  final PaymentController paymentController = Get.put(PaymentController());
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play(); // Start the confetti when the page loads
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
    );
    return Scaffold(
      body: Stack(
        children: [
          // Confetti widget
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              maxBlastForce: 10,
              minBlastForce: 5,
              gravity: 0.1,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow
              ],
            ),
          ),
          // Main content
          SizedBox(
            width: 375.0.w,
            height: 812.0.w,
            child: Stack(
              children: [
                Positioned(
                  top: 239.0.w,
                  left: 74.0.w,
                  child: SizedBox(
                    width: 226.0.w,
                    height: 207.0.w,
                    child: Image.asset(
                      "assets/icons/congratulation.png",
                    ),
                  ),
                ),
                Positioned(
                  top: 470.0.w,
                  left: 83.0.w,
                  child: SizedBox(
                    width: 220.0.w,
                    height: 32.0.w,
                    child: AmdText(
                      text: "Congratulations!",
                      color: AppColors.blackColor,
                      size: 24.0.sp,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  top: 526.0.w,
                  left: 63.0.w,
                  child: SizedBox(
                    width: 249.0.w,
                    height: 48.0.w,
                    child: AmdText(
                      text:
                          "You successfully made a payment, Enjoy our service...!",
                      color: AppColors.blackColor,
                      size: 14.0.sp,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w500,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 26.0.w,
                  left: 24.0.w,
                  child: AmdButton(
                    buttoncolor: AppColors.greenColor,
                    radius: 25.0.w,
                    press: () {
                      Get.to(() => OrderStatusPage(),
                          binding: OrderStatusBinding());
                    },
                    size: Size(327.0.w, 48.0.w),
                    child: AmdText(
                      text: "Track Order",
                      color: AppColors.whiteColor,
                      size: 14,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
