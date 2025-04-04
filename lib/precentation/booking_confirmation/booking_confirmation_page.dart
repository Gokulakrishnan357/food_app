import '../../const/app_exports.dart';
import './booking_confirmation_controller.dart';

class BookingConfirmationPage extends GetView<BookingConfirmationController> {
  const BookingConfirmationPage({super.key});

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
          text: 'Booking Confirmation',
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
        height: 732.0.w,
        width: 375.0.w,
        child: Stack(
          children: [
            Positioned(
              child: SizedBox(
                height: 605.0.w,
                width: 375.0.w,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // shrinkWrap: true,
                    // scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 92.0.w,
                          right: 92.0.w,
                        ),
                        child: SizedBox(
                          height: 192.0.w,
                          width: 192.0.w,
                          child: Image.asset(
                              "assets/icons/booking_conformation_conformed.png"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 7.0.w,
                          left: 46.0.w,
                          right: 46.0.w,
                        ),
                        child: SizedBox(
                          height: 24.0.w,
                          width: 283.0.w,
                          child: RichText(
                            text: TextSpan(
                              text: 'Booking Status - ',
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.dineInTextLabelColor,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Confirmed',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20.0.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.greenColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 7.0.w,
                          left: 119.0.w,
                        ),
                        child: AmdText(
                          text: "Booking ID : 8121193 ",
                          color: AppColors.dineInTextLabelColor,
                          size: 14.0.sp,
                          weight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0.w,
                          left: 28.0.w,
                          right: 27.0.w,
                        ),
                        child: const Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0.w,
                          left: 28.0.w,
                          right: 27.0.w,
                        ),
                        child: SizedBox(
                          width: 320.0.w,
                          height: 17.0.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AmdText(
                                text: "Booking Details",
                                color: AppColors.greenColor,
                                size: 14.0.sp,
                                weight: FontWeight.w500,
                                textAlign: TextAlign.center,
                                height: 1.0,
                              ),
                              Icon(
                                FontAwesomeIcons.shareNodes,
                                color: AppColors.greenColor,
                                size: 15.0.sp,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 14.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 39.0.w,
                          height: 17.0.w,
                          child: AmdText(
                            text: "DATE",
                            color: AppColors.textFieldLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w500,
                            textAlign: TextAlign.left,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 14.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 300.0.w,
                          height: 20.0.w,
                          child: AmdText(
                            text: "29 August, 2023 at 2.30 PM",
                            color: AppColors.dineInTextLabelColor,
                            size: 16.0.sp,
                            weight: FontWeight.w500,
                            textAlign: TextAlign.left,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 14.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 60.0.w,
                          height: 17.0.w,
                          child: AmdText(
                            text: "GUESTS",
                            color: AppColors.textFieldLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w500,
                            textAlign: TextAlign.left,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 14.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 218.0.w,
                          height: 20.0.w,
                          child: AmdText(
                            text: "4",
                            color: AppColors.dineInTextLabelColor,
                            size: 16.0.sp,
                            weight: FontWeight.w500,
                            textAlign: TextAlign.left,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 14.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 60.0.w,
                          height: 17.0.w,
                          child: AmdText(
                            text: "NAME",
                            color: AppColors.textFieldLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w500,
                            textAlign: TextAlign.left,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 14.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 307.0.w,
                          height: 20.0.w,
                          child: AmdText(
                            text: "ArunMozhiDevan",
                            color: AppColors.dineInTextLabelColor,
                            size: 16.0.sp,
                            weight: FontWeight.w500,
                            textAlign: TextAlign.left,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 14.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 100.0.w,
                          height: 17.0.w,
                          child: AmdText(
                            text: "Contact Details",
                            color: AppColors.textFieldLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w500,
                            textAlign: TextAlign.left,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 14.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 307.0.w,
                          height: 20.0.w,
                          child: AmdText(
                            text: "+91 7373949000",
                            color: AppColors.dineInTextLabelColor,
                            size: 16.0.sp,
                            weight: FontWeight.w500,
                            textAlign: TextAlign.left,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0.w,
                          left: 28.0.w,
                          right: 27.0.w,
                        ),
                        child: const Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 320.0.w,
                          height: 17.0.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AmdText(
                                text: "Restaurant Address",
                                color: AppColors.greenColor,
                                size: 14.0.sp,
                                weight: FontWeight.w500,
                                textAlign: TextAlign.left,
                                height: 1.0,
                              ),
                              Icon(
                                FontAwesomeIcons.locationDot,
                                color: AppColors.greenColor,
                                size: 15.0.sp,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0.w,
                          left: 28.0.w,
                        ),
                        child: SizedBox(
                          width: 249.0.w,
                          height: 40.0.w,
                          child: AmdText(
                            text:
                                "Fun Republic Mall, Avinashi Road, Peelamedu, Coimbatore - 641004",
                            color: AppColors.dineInTextLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            height: 1.4,
                            style: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 26.0.w,
              left: 28.0.w,
              child: SizedBox(
                height: 44.0.w,
                width: 312.0.w,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AmdButton(
                      press: () {
                        Get.bottomSheet(
                          Container(
                            height: 425.0.w,
                            width: 375.0.w,
                            decoration: BoxDecoration(
                              color: AppColors.whitetextColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  20.0.w,
                                ),
                                topRight: Radius.circular(
                                  20.0.w,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 26.0.w),
                                  child: SizedBox(
                                    height: 24.0.w,
                                    width: 304.0.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AmdText(
                                          text: "REASON TO CANCEL",
                                          color: AppColors.greenColor,
                                          size: 20.0.sp,
                                          weight: FontWeight.w500,
                                          textAlign: TextAlign.left,
                                          height: 1.2,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.xmark,
                                            color: AppColors.greenColor,
                                            size: 20.0.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 39.0.w),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.cancelMenuData.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 16.0.w,
                                          left: 47.0.w,
                                          right: 62.0.w,
                                        ),
                                        child: SizedBox(
                                          height: 24.0.w,
                                          width: 266.0.w,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Obx(
                                                () => Checkbox(
                                                  value: controller
                                                      .isChecked.value,
                                                  onChanged: (value) {
                                                    controller.isChecked.value =
                                                        value!;
                                                  },
                                                  activeColor:
                                                      AppColors.greenColor,
                                                  focusColor:
                                                      AppColors.greenColor,
                                                  side: MaterialStateBorderSide
                                                      .resolveWith(
                                                    (states) => BorderSide(
                                                      width: 1.0.w,
                                                      color:
                                                          AppColors.greenColor,
                                                    ),
                                                  ),
                                                  // checkColor: AppColors.greenColor,
                                                ),
                                              ),
                                              AmdText(
                                                text: controller
                                                        .cancelMenuData[index]
                                                    ['text'],
                                                color: AppColors
                                                    .dineInTextLabelColor,
                                                size: 16.0.sp,
                                                weight: FontWeight.w500,
                                                textAlign: TextAlign.left,
                                                height: 1.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 44.0.w,
                                    left: 0.0.w,
                                  ),
                                  child: AmdButton(
                                    press: () {
                                      Get.back();
                                    },
                                    buttoncolor: AppColors.greenColor,
                                    size: Size(
                                      280.0.w,
                                      44.0.w,
                                    ),
                                    child: AmdText(
                                      text: "Cancel",
                                      size: 20.0.sp,
                                      weight: FontWeight.w400,
                                      color: AppColors.whitetextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // barrierColor: Colors.red[50],
                          isDismissible: false,
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(35),
                          //     side: BorderSide(width: 5, color: Colors.black)),
                          enableDrag: false,
                        );
                      },
                      buttoncolor: AppColors.whitetextColor,
                      bordercolor: AppColors.greenColor,
                      size: Size(
                        150.0.w,
                        44.0.w,
                      ),
                      child: AmdText(
                        text: "Cancel",
                        color: AppColors.greenColor,
                        size: 20.0.sp,
                        weight: FontWeight.w500,
                        textAlign: TextAlign.left,
                        height: 1.0,
                      ),
                    ),
                    AmdButton(
                      press: () {},
                      buttoncolor: AppColors.greenColor,
                      size: Size(
                        150.0.w,
                        44.0.w,
                      ),
                      child: AmdText(
                        text: "Done",
                        color: AppColors.whitetextColor,
                        size: 20.0.sp,
                        weight: FontWeight.w500,
                        textAlign: TextAlign.left,
                        height: 1.0,
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
