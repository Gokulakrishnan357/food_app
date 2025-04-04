import 'package:zeroq/const/app_exports.dart';

class VerificationMail extends StatelessWidget {
  const VerificationMail({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(
        412,
        812,
      ),
    );
    return Scaffold(
      body: SizedBox(
        height: 812.0.w,
        width: 412.0.w,
        child: Stack(
          children: [
            Positioned(
              left: 90.5.w,
              top: 158.0.w,
              child: AmdText(
                text: "Verification OTP Sent",
                color: AppColors.greenColor,
                size: 20.3.w,
                weight: FontWeight.w600,
                height: 1.0,
              ),
            ),
            Positioned(
              left: 16.0.w,
              top: 212.0.w,
              child: Container(
                height: 350.0.w,
                width: 380.0.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/icons/verificationMail.png",
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16.0.w,
              top: 616.0.w,
              child: SizedBox(
                width: 380.0.w,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        "To complete your registration, please check your phone for a verification message.",
                    style: GoogleFonts.lato(
                      color: AppColors.blackColor,
                      fontSize: 22.0.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    // children: [
                    //   TextSpan(
                    //     text: 'ZeroQ',
                    //     style: GoogleFonts.lato(
                    //       color: AppColors.greenColor,
                    //       fontSize: 22.0.sp,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '. If you don’t see the email in your inbox, please check your spam or junk folder.',
                    //     style: GoogleFonts.lato(
                    //       color: AppColors.blackColor,
                    //       fontSize: 22.0.sp,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 744.0.w,
              left: 27.0.w,
              child: AmdButton(
                press: () {
                  Get.offAllNamed(
                    AmdRoutesClass.authPage,
                  );
                },
                buttoncolor: AppColors.greenColor,
                radius: 28.0.w,
                size: Size(
                  358.0.w,
                  56.0.w,
                ),
                child: AmdText(
                  text: "Ok",
                  size: 24.0.w,
                  weight: FontWeight.w400,
                  color: AppColors.whitetextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
