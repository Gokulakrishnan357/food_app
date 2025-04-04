import 'package:zeroq/AppBinding.dart';
import 'package:zeroq/Provider/RestaurantProvider.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/SplashScreen/SplashScreen.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/precentation/auth/auth_page.dart';
import 'package:zeroq/precentation/onboarding/onboarding_controller.dart';
import 'package:zeroq/precentation/pick_up/SearchBarScreen.dart';
import 'package:zeroq/precentation/pick_up/components/CategorySearch.dart';
import 'package:zeroq/precentation/pick_up/components/hotel_menu/hotel_menu_controller.dart';
import 'package:zeroq/precentation/pick_up/pick_up_controller.dart';
import 'package:zeroq/precentation/pick_up/pick_up_page.dart';
import 'package:zeroq/precentation/settings/address/address_controller.dart';
import 'package:zeroq/precentation/settings/profile/profile_controller.dart';
import 'package:provider/provider.dart';
import 'package:zeroq/server/app_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  AmdStorage storage = AmdStorage();

  // Save data
  await storage.saveUserState(true, false);

  // Retrieve data
  Map<String, bool> userState = await storage.getUserState();
  print("Has seen onboarding: ${userState['hasSeenOnboarding']}");
  print("Is logged in: ${userState['isLoggedIn']}");

  // Initialize controllers
  Get.put(OnboardingController());
  Get.put(AuthController(), permanent: true);
  Get.put(PickUpController(), permanent: true);
  Get.put(AddressController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
  Get.put(HotelMenuController(), permanent: true);
  Get.put(FilterChipController("categoryName"), permanent: true);

  Get.put(FilterChipController1(), permanent: true);

  // Determine initial route
  String initialRoute = await _determineInitialRoute();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),

      ],
      child: MainApp(initialRoute: initialRoute),
    ),
  );

}

// Define _determineInitialRoute function
Future<String> _determineInitialRoute() async {
  try {
    AmdStorage storage = AmdStorage();
    Map<String, bool> userState = await storage.getUserState();
    bool hasSeenOnboarding = userState['hasSeenOnboarding'] ?? false;
    bool isLoggedIn = userState['isLoggedIn'] ?? false;

    final getStorage = GetStorage();
    int? storedUserId = getStorage.read('userId');

    if (!hasSeenOnboarding) {
      return '/splash';
    }

    if (storedUserId != null) {
      return '/pickUpPage';
    }

    return '/authPage';
  } catch (e) {
    print("Error determining initial route: $e");
    return '/authPage';
  }
}






class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZeroQ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      defaultTransition: Transition.noTransition,
      initialRoute: initialRoute,
      initialBinding: AppBindings(),
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/authPage', page: () => const AuthPage()),
        GetPage(name: '/pickUpPage', page: () =>  PickUpPage()),
        ...AmdRoutesClass.amdRoutes,
      ],
      builder: (context, child) {
        return Obx(() {
          final authController = Get.find<AuthController>();

          if (authController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return child ?? const SizedBox.shrink();
        });
      },
    );
  }
}

