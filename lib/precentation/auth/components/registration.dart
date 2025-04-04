import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeroq/const/app_exports.dart';

import '../../pick_up/pick_up_controller.dart';
import '../auth_controller.dart';

class Registration extends StatelessWidget {
  Registration({super.key});

  // OTP Controllers and Focus Nodes
  final List<TextEditingController> _otpControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
        (index) => FocusNode(),
  );
  final TextEditingController _combinedOtpController = TextEditingController();
  final _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(412, 812));

    AuthController authController = Get.find<AuthController>();
    final controller = Get.find<PickUpController>();

    // Get stored phone number
    final phoneNumber = _storage.read('phoneNumber') ?? '';
    final formattedPhoneNumber =
    phoneNumber.isNotEmpty
        ? '${phoneNumber.substring(0, 3)} ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}'
        : '';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.0.h),
              Text(
                "VERIFY OTP",
                style: GoogleFonts.montserrat(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.0.h),

              // Phone number and Edit in one line
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedPhoneNumber,
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 102, 101, 101),
                    ),
                  ),
                  SizedBox(width: 8.0.w),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 4.0.w),
                        Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 13.0.sp,
                            color: Color(
                              0xFF0066FF,
                            ), // This is the RGB equivalent of hsla(212, 100%, 50%, 1) // Changed to match your theme
                            height: 1.36,
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          size: 12.0.sp,
                          color: Color(
                            0xFF0066FF,
                          ), // This is the RGB equivalent of hsla(212, 100%, 50%, 1) // Changed to match your theme
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0.h),

              // 6-Digit OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40.0.w,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _otpFocusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 24.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.greenColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          if (index < 5) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_otpFocusNodes[index + 1]);
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                          _combinedOtpController.text =
                              _otpControllers
                                  .map((controller) => controller.text)
                                  .join();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_otpFocusNodes[index - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),

              // Didn't receive and Resend - Aligned properly below OTP field
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: SizedBox(
                  width: 358.0.w, // Match OTP field width
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Didn't receive the OTP?",
                        style: GoogleFonts.montserrat(
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 102, 101, 101),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Resend OTP logic here
                        },
                        child: Text(
                          "Resend",
                          style: GoogleFonts.montserrat(
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Verify Button
              Padding(
                padding: EdgeInsets.only(top: 24.0.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final otp = _combinedOtpController.text.trim();

                      if (otp.length < 6) {
                        Get.snackbar(
                          "Invalid OTP",
                          "Please enter the correct OTP",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return; // Stop execution if OTP is invalid
                      }

                      // ✅ Proceed with OTP verification
                      print("Verifying OTP: $otp for phone: $phoneNumber");
                      authController.loginUser();
                      Get.offAllNamed(AmdRoutesClass.pickUpPage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenColor,
                      padding: EdgeInsets.symmetric(vertical: 16.0.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0.w),
                      ),
                    ),
                    child: Text(
                      "Verify OTP",
                      style: GoogleFonts.montserrat(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0.h),
            ],
          ),
        ),
      ),
    );
  }
}