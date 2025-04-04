import 'package:zeroq/uttility/custom_widget/custom_text_field.dart';

import '../../const/app_exports.dart';
import './booking_details_controller.dart';

class BookingDetailsPage extends GetView<BookingDetailsController> {
  const BookingDetailsPage({super.key});

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
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.whitetextColor,
          ),
        ),
        title: AmdText(
          text: 'Add Booking Details',
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
        height: 732.0.h,
        width: 375.0.w,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0.w,
            top: 24.0.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 330.0.w,
                  height: 24.0.w,
                  child: AmdText(
                    text: 'Barbeque Nation ',
                    color: AppColors.dineInTextLabelColor,
                    size: 20.0.sp,
                    weight: FontWeight.w500,
                    height: 1.1.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0.w,
                  ),
                  child: SizedBox(
                    width: 330.0.w,
                    height: 24.0.w,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 24.0.w,
                          width: 16.0.w,
                          child: const Icon(
                            FontAwesomeIcons.locationDot,
                            color: AppColors.textFieldLabelColor,
                          ),
                        ),
                        SizedBox(
                          width: 10.0.w,
                        ),
                        AmdText(
                          text: 'Peelamedu, Coimbatore',
                          color: AppColors.dineInTextLabelColor,
                          size: 14.0.sp,
                          weight: FontWeight.w400,
                          height: 1.1.w,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 32.0.w,
                  ),
                  child: SizedBox(
                    width: 210.0.w,
                    height: 17.0.w,
                    child: AmdText(
                      text: 'SELECTED DATE AND TIME',
                      color: AppColors.dineInTextLabelColor,
                      size: 14.0.sp,
                      weight: FontWeight.w500,
                      height: 1.1.w,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 14.0.w,
                  ),
                  child: SizedBox(
                    width: 264.0.w,
                    height: 20.0.w,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 24.0.w,
                          width: 16.0.w,
                          child: const Icon(
                            FontAwesomeIcons.calendarDay,
                            color: AppColors.textFieldLabelColor,
                          ),
                        ),
                        SizedBox(
                          width: 10.0.w,
                        ),
                        AmdText(
                          text: 'Tue 29 Aug, 4 people, 2.30 PM',
                          color: AppColors.dineInTextLabelColor,
                          size: 14.0.sp,
                          weight: FontWeight.w500,
                          height: 1.1.w,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 50.0.w,
                  ),
                  child: SizedBox(
                    width: 123.0.w,
                    height: 20.0.w,
                    child: AmdText(
                      text: 'Full Name',
                      color: AppColors.dineInTextLabelColor,
                      size: 16.0.sp,
                      weight: FontWeight.w400,
                      height: 1.1.w,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0.w,
                  ),
                  child: SizedBox(
                    width: 327.0.w,
                    height: 40.0.w,
                    child: AmdTextField(
                      hinttext: 'Enter the name',
                      obscureText: false,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 30.0.w,
                  ),
                  child: SizedBox(
                    width: 130.0.w,
                    height: 20.0.w,
                    child: AmdText(
                      text: 'Email',
                      color: AppColors.dineInTextLabelColor,
                      size: 16.0.sp,
                      weight: FontWeight.w400,
                      height: 1.1.w,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0.w,
                  ),
                  child: SizedBox(
                    width: 327.0.w,
                    height: 40.0.w,
                    child: AmdTextField(
                      textInputType: TextInputType.emailAddress,
                      hinttext: 'Enter the E-Mail',
                      obscureText: false,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 30.0.w,
                  ),
                  child: SizedBox(
                    width: 130.0.w,
                    height: 20.0.w,
                    child: AmdText(
                      text: 'Phone number',
                      color: AppColors.dineInTextLabelColor,
                      size: 16.0.sp,
                      weight: FontWeight.w400,
                      height: 1.1.w,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0.w,
                  ),
                  child: SizedBox(
                    width: 327.0.w,
                    height: 40.0.w,
                    child: AmdTextField(
                      hinttext: 'Enter the Mobile-No',
                      obscureText: false,
                      textInputType: TextInputType.number,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: AmdText(
                          text: "+91",
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 100.0.w,
                    left: 24.0.w,
                  ),
                  child: AmdButton(
                    radius: 10.0.w,
                    press: () {
                      Get.toNamed(AmdRoutesClass.bookingConfirmationPage);
                    },
                    buttoncolor: AppColors.greenColor,
                    size: Size(
                      280.0.w,
                      44.0.w,
                    ),
                    child: AmdText(
                      text: 'Next',
                      textAlign: TextAlign.center,
                      color: AppColors.whitetextColor,
                      size: 20.0.sp,
                      weight: FontWeight.w500,
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
