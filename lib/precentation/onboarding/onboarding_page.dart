
import '../../const/app_exports.dart';
import './onboarding_controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(
        375,
        812,
      ),
    );
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    const mobilemockupHeight = 812;
    const mobilemockupWidth = 375;
    var mobilescale = mobilemockupWidth / width;
    // final _controller = Get.put(OnboardingController());
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 812.0.h,
          width: 375.0.w,
          child: Stack(
            children: [
              Positioned(
                left: 22.0.w,
                top: 125.0.w,
                child: SizedBox(
                  width: 332.0.w,
                  height: 645.0.h,
                  child: Obx(
                    () {
                      return controller
                                  .getAllOnboarding.value.splashScreenData !=
                              null
                          ? Stack(
                              children: [
                                PageView.builder(
                                    controller: controller.pageController,
                                    onPageChanged: (index) {
                                      controller.selectedPageIndex.value =
                                          index;
                                    },
                                    itemCount: controller.getAllOnboarding.value
                                        .splashScreenData!.length,
                                    itemBuilder: (context, index) {
                                      var page = controller.getAllOnboarding
                                          .value.splashScreenData![index];
                                      return Stack(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Positioned(
                                            left: 24.0.w,
                                            top: 0.0.h,
                                            child: SizedBox(
                                              height: 300.0.h,
                                              width: 300.0.w,
                                              child: Image.network(
                                                page.imageUrl!,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 338.0.h,
                                            left: 49.0.w,
                                            child: SizedBox(
                                              height: 29.0.h,
                                              width: 234.0.w,
                                              child: AmdText(
                                                text: page.title!,
                                                size: 23.0.sp,
                                                weight: FontWeight.w600,
                                                color: AppColors.greenColor,
                                                textAlign: TextAlign.center,
                                                height: 1.2.h,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 405.0.h,
                                            left: 0.0.w,
                                            child: SizedBox(
                                              height: 102.0.h,
                                              width: 332.0.w,
                                              child: AmdText(
                                                text: page.description!,
                                                size: 18.0.sp,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                weight: FontWeight.w400,
                                                color: AppColors.greenColor,
                                                textAlign: TextAlign.center,
                                                height: 1.8.h,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                Positioned(
                                  top: 545.0.h,
                                  left: 20.0.w,
                                  child: Row(
                                    children: List.generate(
                                      controller.getAllOnboarding.value
                                          .splashScreenData!.length,
                                      (index) => Obx(() {
                                        return Padding(
                                          padding:
                                              EdgeInsets.only(right: 12.0.w),
                                          child: Container(
                                            // margin: const EdgeInsets.all(4),
                                            width: 20.0.w,
                                            height: 6.0.h,
                                            decoration: BoxDecoration(
                                                color: controller
                                                            .selectedPageIndex
                                                            .value ==
                                                        index
                                                    ? AppColors.greenColor
                                                    : Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(6.0.w)
                                                // shape: BoxShape.circle,
                                                ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 20.0.w,
                                  bottom: 0.0.h,
                                  child: FloatingActionButton(
                                    shape: const OvalBorder(),
                                    elevation: 0,
                                    onPressed: controller.forwardAction,
                                    backgroundColor: AppColors.greenColor,
                                    child: Obx(() {
                                      print(controller.isLastPage);
                                      return Icon(
                                        controller.isLastPage
                                            ? Icons.check_rounded
                                            : Icons.arrow_right_alt_sharp,
                                        // Icons.navigate_next,
                                        color: AppColors.whitetextColor,
                                        size: 30.0.w,
                                      );
                                      // Text(_controller.isLastPage ? 'Start' : 'Next');
                                    }),
                                  ),
                                ),
                              ],
                            )
                          : const Center(child: SingleChildScrollView());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
