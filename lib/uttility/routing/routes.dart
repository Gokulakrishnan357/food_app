import 'package:zeroq/precentation/auth/auth_bindings.dart';
import 'package:zeroq/precentation/auth/auth_page.dart';
import 'package:zeroq/precentation/book_table/book_table_bindings.dart';
import 'package:zeroq/precentation/book_table/book_table_page.dart';
import 'package:zeroq/precentation/booking_confirmation/booking_confirmation_bindings.dart';
import 'package:zeroq/precentation/booking_confirmation/booking_confirmation_page.dart';
import 'package:zeroq/precentation/booking_details/booking_details_bindings.dart';
import 'package:zeroq/precentation/booking_details/booking_details_page.dart';
import 'package:zeroq/precentation/dine_in/dine_in_bindings.dart';
import 'package:zeroq/precentation/dine_in/dine_in_page.dart';
import 'package:zeroq/precentation/dining/dining/dining_bindings.dart';
import 'package:zeroq/precentation/dining/dining/dining_page.dart';
import 'package:zeroq/precentation/dining/dining_menu/dining_menu_bindings.dart';
import 'package:zeroq/precentation/dining/dining_menu/dining_menu_page.dart';
import 'package:zeroq/precentation/order_status/order_status.dart';
import 'package:zeroq/precentation/order_status/order_status_binding.dart';
import 'package:zeroq/precentation/payment/components/payment_sucess.dart';
import 'package:zeroq/precentation/payment/payment_bindings.dart';
import 'package:zeroq/precentation/payment/payment_page.dart';
import 'package:zeroq/precentation/pick_up/components/hotel_menu/hotel_menu_bindings.dart';
import 'package:zeroq/precentation/pick_up/components/hotel_menu/hotel_menu_page.dart';
import 'package:zeroq/precentation/pick_up/pick_up_bindings.dart';
import 'package:zeroq/precentation/pick_up/pick_up_page.dart';
import 'package:zeroq/precentation/restaurant_info/restaurant_info_bindings.dart';
import 'package:zeroq/precentation/restaurant_info/restaurant_info_page.dart';
import 'package:zeroq/precentation/settings/address/address_bindings.dart';
import 'package:zeroq/precentation/settings/address/address_page.dart';
import 'package:zeroq/precentation/settings/orders/orders_bindings.dart';
import 'package:zeroq/precentation/settings/orders/orders_page.dart';
import 'package:zeroq/precentation/settings/profile/profile_bindings.dart';
import 'package:zeroq/precentation/settings/profile/profile_page.dart';
import 'package:zeroq/precentation/settings/settings/settings_bindings.dart';
import 'package:zeroq/precentation/settings/settings/settings_page.dart';
import 'package:zeroq/precentation/user_orders/user_order_bindings.dart';
import 'package:zeroq/precentation/user_orders/user_orders_page.dart';
// import 'package:zeroq/server/auth_middleware.dart.dart';

import '../../const/app_exports.dart';
import '../../precentation/SplashScreen/SplashScreen.dart';



class AmdRoutesClass {

  // Admin Routes

  static String authPage = '/authPage';
  static String dashboardPage = '/dashboardPage';
  static String onboardingPage = '/onboardingPage';
  static String storePage = '/storePage';
  static String cartPage = '/cartPage';
  static String notificationPage = '/notificationPage';
  static String dineInPage = '/dineInPage';
  static String pickUpPage = '/pickUpPage';
  static String splashScreen = '/splash';
  static String restaurantInfoPage = '/restaurantInfoPage';
  static String bookTablePage = '/bookTablePage';
  static String bookingDetailsPage = '/bookingDetailsPage';
  static String bookingConfirmationPage = '/bookingConfirmationPage';
  static String hotelMenuPage = '/hotelMenuPage';
  static String paymentPage = '/paymentPage';
  static String paymentSucessPage = '/paymentSucessPage';
  static String orderStatusPage = '/orderStatusPage';
  static String loginPage = '/login';

  /// settings routes
  static String settingsPage = '/settingsPage';
  static String ordersPage = '/ordersPage';
  static String profilePage = '/profilePage';
  static String addressPage = '/addressPage';

  ///dining routes
  static String diningPage = '/diningPage';
  static String diningMenuPage = '/diningMenuPage';

  //user routes
  static String userOrdersPage = '/userOrders';



  static List<GetPage> amdRoutes = [
    GetPage(
      name: authPage,
      page: () => const AuthPage(),
      binding: AuthBindings(),
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: dashboardPage,
      page: () => PickUpPage(),
      binding: PickUpBindings(),
      //transition: Transition.fade,
      transitionDuration: const Duration(seconds: 1),
      bindings: [
        DashboardBindings(),
        PickUpBindings(),
        DiningBindings(),
        CartBindings(),
      ],
      // middlewares: const [
      //   // AuthMiddleware(),
      // ]
    ),
    GetPage(
      name: onboardingPage,
      page: () => const OnboardingPage(),
      binding: OnboardingBindings(),
      //transition: Transition.fade,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: cartPage,
      page: () => CartPage(),
      binding: CartBindings(),
      //transition: Transition.fade,
      transitionDuration: const Duration(seconds: 1),
    ),

    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      binding: AuthBindings(),
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: notificationPage,
      page: () => const NotificationPage(),
      binding: NotificationBindings(),
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: storePage,
      page: () => const StorePage(),
      binding: StoreBindings(),
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: dineInPage,
      page: () => const DineInPage(),
      binding: DineInBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(

      name: pickUpPage,

      page: () => PickUpPage(),
      binding: PickUpBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: restaurantInfoPage,
      page: () => const RestaurantInfoPage(),
      binding: RestaurantInfoBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: bookTablePage,
      page: () => const BookTablePage(),
      binding: BookTableBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: bookingDetailsPage,
      page: () => const BookingDetailsPage(),
      binding: BookingDetailsBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: bookingConfirmationPage,
      page: () => const BookingConfirmationPage(),
      binding: BookingConfirmationBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: hotelMenuPage,
      page: () => HotelMenuPage(),
      binding: HotelMenuBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: paymentPage,
      page: () => const PaymentPage(),
      binding: PaymentBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: paymentSucessPage,
      page: () => const PaymentSucess(),
      binding: PaymentBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: orderStatusPage,
      page: () => OrderStatusPage(),
      binding: OrderStatusBinding(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),

    ///dining routes
    GetPage(
      name: diningPage,
      page: () => const DiningPage(),
      binding: DiningBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: diningMenuPage,
      page: () => const DiningMenuPage(),
      binding: DiningMenuBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: settingsPage,
      page: () => SettingsPage(),
      binding: SettingsBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: ordersPage,
      page: () => const OrdersPage(),
      binding: OrdersBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: profilePage,
      page: () => ProfilePage(),
      binding: ProfileBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: addressPage,
      page: () => AddressPage(),
      binding: AddressBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: userOrdersPage,
      page: () => UserOrders(),
      binding: UserOrderBindings(),
      transitionDuration: const Duration(milliseconds: 1000),
    ),
  ];
}
