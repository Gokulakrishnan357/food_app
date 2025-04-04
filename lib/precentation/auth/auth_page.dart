import 'package:flutter/services.dart';
import 'package:zeroq/const/app_exports.dart';
import '../pick_up/pick_up_controller.dart';
import './auth_controller.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(412, 892));
    final pickUpController = Get.find<PickUpController>();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // ✅ Fixed Full-Screen Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/Login.png',
                fit: BoxFit.cover, // Ensures it covers the entire screen
              ),
            ),

            // ✅ Moving Container
            KeyboardAwareContainer(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.48,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Text
                    Center(
                      child: AmdText(
                        text: "LOGIN",
                        size: 24.sp,
                        weight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: AmdText(
                        text: "Enter your Phone Number",
                        size: 14.sp,
                        weight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 60.h),

                    // Phone Number Input
                    GetBuilder<AuthController>(
                      builder: (controller) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // 🇮🇳 Indian Flag
                                Padding(
                                  padding: const EdgeInsets.only(bottom:10.0),
                                  child: Image.asset(
                                    'assets/images/indianflag.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                const SizedBox(width: 5),

                                // 📞 Country Code (Fixed Width)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 23.0),
                                  child: SizedBox(
                                    width:
                                        50, // Adjust width to ensure proper spacing
                                    child: TextFormField(
                                      initialValue: "+91",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      readOnly: true,
                                      textAlign:
                                          TextAlign.center, // Keep text centered
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // 📱 Phone Number Input (Takes Remaining Space)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: controller.phone,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "Mobile Number",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  controller
                                                          .errorMessage
                                                          .isEmpty
                                                      ? Colors.green
                                                      : Colors.red,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 4,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          pickUpController.fetchAndStoreLocation();
                                          controller.validatePhone(value);
                                          controller.update();
                                        },
                                      ),

                                      // ✅ Fixed-Height Error Message Container (Prevents Shifting)
                                      const SizedBox(height: 4), // Add spacing
                                      Container(
                                        height:
                                            20, // Keep a fixed height to prevent shifting
                                        alignment: Alignment.centerLeft,
                                        child:
                                            controller.errorMessage.isNotEmpty
                                                ? Text(
                                                  controller.errorMessage.value,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12.sp,
                                                  ),
                                                )
                                                : null, // Keep empty space if no error
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 60.h),

                    // Confirm Button
              ElevatedButton(
                onPressed: controller.isPhoneValid.value
                    ? () async {
                  // Show "Please wait..." SnackBar
                  Get.snackbar(
                    "Please wait...",
                    "",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black54,
                    colorText: Colors.white,
                    duration: Duration(days: 1),
                    margin: EdgeInsets.all(6),
                    borderRadius: 8,
                    snackStyle: SnackStyle.FLOATING,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    overlayBlur: 1,
                    shouldIconPulse: false,
                  );

                  // Perform the actions
                  await controller.registerUser();
                  await controller.fetchAndStoreLocation();

                  // Dismiss the SnackBar
                  Get.closeAllSnackbars();

                  // Optionally, show success message
                  Get.snackbar(
                    "Success",
                    "Registration completed!",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isPhoneValid.value
                      ? AppColors.greenColor
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: AmdText(
                  text: "Confirm",
                  size: 16.sp,
                  weight: FontWeight.w600,
                  color: Colors.white,
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
  }
}

// ✅ Updated `KeyboardAwareContainer` to move up when keyboard appears
class KeyboardAwareContainer extends StatefulWidget {
  final Widget child;

  const KeyboardAwareContainer({super.key, required this.child});

  @override
  State<KeyboardAwareContainer> createState() => _KeyboardAwareContainerState();
}

class _KeyboardAwareContainerState extends State<KeyboardAwareContainer>
    with WidgetsBindingObserver {
  double _bottomPosition = 0; // Initially at the bottom

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _bottomPosition = 0; // Start at the bottom
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      _bottomPosition =
          keyboardHeight > 0
              ? keyboardHeight
              : 0; // Move up when keyboard appears
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      bottom: _bottomPosition, // Moves up when keyboard appears
      left: 0,
      right: 0,
      child: widget.child,
    );
  }
}
