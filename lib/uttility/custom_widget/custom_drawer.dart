import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/precentation/cart/cart_controller.dart';
import 'package:zeroq/server/app_storage.dart';
import 'package:zeroq/uttility/custom_widget/custom_dialog.dart';

class CustomDrawer extends StatelessWidget {
  final cartController = Get.find<CartController>();
  final authController = Get.find<AuthController>();

  CustomDrawer({super.key});

  void confirmLogout(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Confirmation",
            content: "Are you sure you want to Sign out?",
            onConfirm: () {
              Navigator.of(context).pop(); // Close the dialog
              AmdStorage().removeCache('userId');
              Get.toNamed(AmdRoutesClass.authPage);
              authController.userId.value = 0;
              authController.userDetails.value = null;
              cartController.cart.value = null;
            },
            onCancel: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(
        390,
        690,
      ),
    );
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(
          top: kToolbarHeight,
        ),
        width: 360.0.w,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20.0.w,
                top: 10.0.w,
              ),
              child: SizedBox(
                width: 330.0.w,
                height: 60.0.w,
                child: InkWell(
                  onTap: () {
                    Get.toNamed("/settingsPage");
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        child: SizedBox(
                          width: 60.0.w,
                          height: 60.0.w,
                          child: ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: (authController.userDetails.value
                                              ?.profilePictureUrl.isNotEmpty ??
                                          false)
                                      ? NetworkImage(authController.userDetails
                                          .value!.profilePictureUrl)
                                      : const AssetImage(AppImageStrings
                                          .appAppBarUserImage) as ImageProvider,
                                  fit: BoxFit
                                      .cover, // Adjust to fit the image properly
                                ),
                              ),
                              width:
                                  100.0, // Set width and height to create a round shape
                              height:
                                  100.0, // Set width and height to create a round shape
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 90.0.w,
                        top: 22.0.w,
                        child: SizedBox(
                          width: 266.0.w,
                          height: 60.0.w,
                          child: AmdText(
                            text: authController.userDetails.value?.firstName
                                        .isNotEmpty ==
                                    true
                                ? "Welcome ${authController.userDetails.value!.firstName}"
                                : "",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            size: 20.0.w,
                            textAlign: TextAlign.left,
                            color: AppColors.blackColor,
                            weight: FontWeight.w500,
                            height: 0.95,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w, left: 16.0.w),
              child: ListTile(
                leading: const Icon(
                  FontAwesomeIcons.bookOpenReader,
                ),
                title: const AmdText(
                  text: "My-Orders",
                ),
                onTap: () {
                  Get.toNamed(AmdRoutesClass.userOrdersPage);
                },
              ),
            ),
            // Conditionally show the Sign out button if userId is not 0
            Obx(() {
              return authController.userId.value != 0
                  ? Padding(
                      padding: EdgeInsets.only(top: 1.w, left: 16.0.w),
                      child: Column(
                        children: [
                          // My Profile ListTile
                          ListTile(
                            leading: const Icon(
                              FontAwesomeIcons.user,
                            ),
                            title: const AmdText(
                              text: "My Profile",
                            ),
                            onTap: () {
                              Get.offNamed(AmdRoutesClass.settingsPage);
                            },
                          ),
                          // Sign Out ListTile
                          ListTile(
                            leading: const Icon(
                              FontAwesomeIcons.signOut, // Icon for "Sign Out"
                            ),
                            title: const AmdText(
                              text: "Sign out",
                            ),
                            onTap: () {
                              confirmLogout(
                                  context); // Logout confirmation dialog
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(); // Empty container when userId is 0
            })
          ],
        ),
      ),
    );
  }
}


// class DrawerMobile extends StatelessWidget {
//   const DrawerMobile({
//     super.key,
//     required this.sidebarNavigationController,
//   });
//   final SidebarNavigationController sidebarNavigationController;
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(
//       context,
//       designSize: const Size(
//         390,
//         690,
//       ),
//     );
//     return Container(
//       margin: const EdgeInsets.only(
//         top: kToolbarHeight,
//       ),
//       width: 360.0.w,
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(
//               left: 20.0.w,
//               top: 10.0.w,
//             ),
//             child: SizedBox(
//               width: 330.0.w,
//               height: 90.0.w,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     child: Container(
//                       width: 90.0.w,
//                       height: 90.0.w,
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage(
//                             AppImageStrings.appLogo,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     left: 90.0.w,
//                     top: 18.0.w,
//                     child: SizedBox(
//                       width: 266.0.w,
//                       height: 90.0.w,
//                       child: AmdText(
//                         text: "Girish Badmittion Academy",
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                         size: 25.0.w,
//                         textAlign: TextAlign.left,
//                         color: AmdColor.appBlackColor,
//                         weight: FontWeight.w700,
//                         height: 0.95,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           buildList(
//             // indexOffset: itemfirst.length,
//             items: dashboard,

//             selectedIndex: sidebarNavigationController.selectedIndex.value,
//           ),
//         ],
//       ),
//     );
//   }
// }
