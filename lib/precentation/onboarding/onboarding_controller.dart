import 'package:flutter/foundation.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/splash_screen/get_all_splash_model.dart';
import 'package:zeroq/server/network_handler.dart';

import '../../server/app_storage.dart';
// import 'package:zeroq/server/localstorage.dart';

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage =>
      selectedPageIndex.value ==
      getAllOnboarding.value.splashScreenData!.length - 1;
  var pageController = PageController();
  var getAllOnboarding = SplahScreenModel().obs;
  final AppNetworkHandler networkHandler = AppNetworkHandler();

  @override
  void onInit() {
    super.onInit();
    fetchOnboarding();
    // print(date);
  }

  void fetchOnboarding() async {
    try {
      final result = await GraphQLClientService.fetchData(
          query: GraphQuery.getSplashScreen);
      List jsonString = result.data!['splashDetails'] as List;
      getAllOnboarding.value = SplahScreenModel.fromList(jsonString);
    } catch (error) {
      // Handle the error
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  forwardAction() {
    if (isLastPage == true) {
      AmdStorage().createCache(
        "onboarding",
        true.toString(),
      );
      Get.toNamed(
        AmdRoutesClass.authPage,
      );
    } else {
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    }
  }

  // List<OnboardingInfo> onboardingPages = [
  //   OnboardingInfo(
  //     AppImageStrings.appOnboarding1Image,
  //     AppTextStrings.appOnboarding1Title,
  //     AppTextStrings.appOnboarding1Description,
  //   ),
  //   OnboardingInfo(
  //     AppImageStrings.appOnboarding2Image,
  //     AppTextStrings.appOnboarding2Title,
  //     AppTextStrings.appOnboarding2Description,
  //   ),
  //   OnboardingInfo(
  //     AppImageStrings.appOnboarding3Image,
  //     AppTextStrings.appOnboarding3Title,
  //     AppTextStrings.appOnboarding3Description,
  //   ),
  // ];
}
