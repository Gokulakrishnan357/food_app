import '../../const/app_exports.dart';
import './book_table_controller.dart';

class BookTablePage extends GetView<BookTableController> {
  const BookTablePage({super.key});

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
          text: 'Book a table',
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
        child: Stack(
          children: [
            Positioned(
              child: SizedBox(
                height: 600.0.w,
                width: 375.0.w,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24.0.w,
                    top: 24.0.w,
                  ),
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
                          top: 24.0.w,
                        ),
                        child: SizedBox(
                          width: 91.0.w,
                          height: 17.0.w,
                          child: AmdText(
                            text: 'WHAT DAY ?',
                            color: AppColors.dineInTextLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w500,
                            height: 1.1.w,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0.w,
                        ),
                        child: SizedBox(
                          width: 350.0.w,
                          height: 4.0.w,
                          child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: 16.0.w,
                                  top: 2.0.w,
                                  bottom: 2.0.w,
                                  left: 2.0.w,
                                ),
                                child: Container(
                                  width: 100.0.w,
                                  height: 85.0.w,
                                  decoration: ShapeDecoration(
                                    color: AppColors.whitetextColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8.0.w,
                                      ),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 22.0.w,
                                        child: SizedBox(
                                          width: 100.0.w,
                                          height: 15.0.w,
                                          child: AmdText(
                                            text: 'Today',
                                            color:
                                                AppColors.dineInTextLabelColor,
                                            size: 12.0.sp,
                                            weight: FontWeight.w500,
                                            height: 1.1.w,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 22.0.w,
                                        child: SizedBox(
                                          width: 100.0.w,
                                          height: 17.0.w,
                                          child: AmdText(
                                            text: '29 Aug',
                                            color:
                                                AppColors.dineInTextLabelColor,
                                            size: 14.0.sp,
                                            weight: FontWeight.w500,
                                            height: 1.1.w,
                                            textAlign: TextAlign.center,
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
                      Padding(
                        padding: EdgeInsets.only(
                          top: 32.0.w,
                        ),
                        child: SizedBox(
                          width: 161.0.w,
                          height: 17.0.w,
                          child: AmdText(
                            text: 'HOW MANY PEOPLE ?',
                            color: AppColors.dineInTextLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w500,
                            height: 1.1.w,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0.w,
                        ),
                        child: SizedBox(
                          width: 350.0.w,
                          height: 54.0.w,
                          child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: 16.0.w,
                                  top: 2.0.w,
                                  bottom: 2.0.w,
                                  left: 2.0.w,
                                ),
                                child: Container(
                                  width: 50.0.w,
                                  height: 50.0.w,
                                  decoration: ShapeDecoration(
                                    color: AppColors.whitetextColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8.0.w,
                                      ),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 15.0.w,
                                        child: SizedBox(
                                          width: 50.0.w,
                                          height: 20.0.w,
                                          child: AmdText(
                                            text: '1',
                                            color:
                                                AppColors.dineInTextLabelColor,
                                            size: 16.0.sp,
                                            weight: FontWeight.w500,
                                            height: 1.1.w,
                                            textAlign: TextAlign.center,
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
                      Padding(
                        padding: EdgeInsets.only(
                          top: 32.0.w,
                        ),
                        child: SizedBox(
                          width: 161.0.w,
                          height: 17.0.w,
                          child: AmdText(
                            text: 'WHAT SESSION ?',
                            color: AppColors.dineInTextLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w500,
                            height: 1.1.w,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0.w,
                        ),
                        child: SizedBox(
                          width: 264.0.w,
                          height: 42.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AmdButton(
                                radius: 10.0.w,
                                press: () {},
                                buttoncolor: AppColors.whitetextColor,
                                size: Size(
                                  125.0.w,
                                  44.0.w,
                                ),
                                child: AmdText(
                                  text: 'Lunch',
                                  textAlign: TextAlign.center,
                                  color: AppColors.blackColor,
                                  size: 16.0.sp,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              AmdButton(
                                radius: 10.0.w,
                                press: () {},
                                buttoncolor: AppColors.whitetextColor,
                                size: Size(
                                  125.0.w,
                                  44.0.w,
                                ),
                                child: AmdText(
                                  text: 'Dinner',
                                  textAlign: TextAlign.center,
                                  color: AppColors.blackColor,
                                  size: 16.0.sp,
                                  weight: FontWeight.w500,
                                ),
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
                          width: 96.0.w,
                          height: 17.0.w,
                          child: AmdText(
                            text: 'WHAT TIME ?',
                            color: AppColors.dineInTextLabelColor,
                            size: 14.0.sp,
                            weight: FontWeight.w500,
                            height: 1.1.w,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0.w,
                        ),
                        child: SizedBox(
                          width: 354.0.w,
                          height: 50.0.w,
                          child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: 16.0.w,
                                  top: 2.0.w,
                                  bottom: 2.0.w,
                                  left: 2.0.w,
                                ),
                                child: Container(
                                  width: 100.0.w,
                                  height: 50.0.w,
                                  decoration: ShapeDecoration(
                                    color: AppColors.whitetextColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8.0.w,
                                      ),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 15.0.w,
                                        child: SizedBox(
                                          width: 100.0.w,
                                          height: 20.0.w,
                                          child: AmdText(
                                            text: '12.30 PM',
                                            color:
                                                AppColors.dineInTextLabelColor,
                                            size: 16.0.sp,
                                            weight: FontWeight.w500,
                                            height: 1.1.w,
                                            textAlign: TextAlign.center,
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
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 26.0.w,
              left: 48.0.w,
              child: AmdButton(
                radius: 10.0.w,
                press: () {
                  Get.toNamed(AmdRoutesClass.bookingDetailsPage);
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
    );
  }
}
