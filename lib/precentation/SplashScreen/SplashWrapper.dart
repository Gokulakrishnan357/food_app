import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/precentation/onboarding/onboarding_controller.dart';
import 'package:zeroq/precentation/pick_up/components/hotel_menu/hotel_menu_controller.dart';
import 'package:zeroq/precentation/pick_up/pick_up_controller.dart';
import 'package:zeroq/precentation/settings/address/address_controller.dart';
import 'package:zeroq/precentation/settings/profile/profile_controller.dart';
import 'package:zeroq/server/app_storage.dart';

import '../../main.dart';
import 'SplashScreen.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  _SplashWrapperState createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  String? initialRoute;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initializeControllers();
    final route = await _determineInitialRoute();
    await _loadEssentialData();

    // Maintain minimum splash duration
    final startTime = DateTime.now();
    final elapsed = DateTime.now().difference(startTime).inSeconds;
    final remaining = 2 - elapsed;
    if (remaining > 0) await Future.delayed(Duration(seconds: remaining));

    setState(() {
      initialRoute = route;
      isLoading = false;
    });
  }

  Future<void> _initializeControllers() async {
    Get.put(OnboardingController());
    Get.put(AuthController(), permanent: true);
    Get.put(PickUpController(), permanent: true);
    Get.put(AddressController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(HotelMenuController(), permanent: true);
  }

  Future<void> _loadEssentialData() async {
    try {
      final pickUpController = Get.find<PickUpController>();
      await pickUpController.loadInitialData();
    } catch (e) {
      print("Error loading essential data: $e");
    }
  }

  Future<String> _determineInitialRoute() async {
    try {
      AuthController authController = Get.find<AuthController>();
      authController.isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

      if (!hasSeenOnboarding) {
        return AmdRoutesClass.onboardingPage;
      }

      var userIdCache = await AmdStorage().readCache('userId');

      if (userIdCache?.isNotEmpty ?? false) {
        authController.userId.value = int.parse(userIdCache!);
        print("Already registered userId is $userIdCache");
        await authController.fetchUserDetails();
        return AmdRoutesClass.dashboardPage;
      }

      return AmdRoutesClass.authPage;
    } catch (e) {
      print("Error determining route: $e");
      return AmdRoutesClass.authPage;
    } finally {
      AuthController authController = Get.find<AuthController>();
      authController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen())
        : MainApp(initialRoute: initialRoute!);
  }
}
