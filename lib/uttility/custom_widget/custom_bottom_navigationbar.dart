import 'package:zeroq/precentation/dashboard/dashboard_controller.dart';

import '../../const/app_exports.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    // final HomeController controller = Get.put(HomeController());

    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        elevation: 0.0,
        selectedItemColor: AppColors.greenColor,
        unselectedItemColor: AppColors.headingtextColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/home.png",
              color: controller.currentIndex.value != 0
                  ? AppColors.textFieldLabelColor
                  : AppColors.greenColor,
              width: 28.0.w,
              height: 28.0.w,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/food.png",
              color: controller.currentIndex.value != 1
                  ? AppColors.textFieldLabelColor
                  : AppColors.greenColor,
              width: 28.0.w,
              height: 28.0.w,
            ),
            label: 'Restaurant',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/dining.png",
              color: controller.currentIndex.value != 2
                  ? AppColors.textFieldLabelColor
                  : AppColors.greenColor,
              width: 28.0.w,
              height: 28.0.w,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/sports.png",
              color: controller.currentIndex.value != 3
                  ? AppColors.textFieldLabelColor
                  : AppColors.greenColor,
              width: 28.0.w,
              height: 28.0.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
