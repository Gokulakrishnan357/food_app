import 'package:zeroq/const/app_exports.dart';

class AppSnackBar extends StatelessWidget {
  const AppSnackBar({
    super.key,
    required this.description,
    required this.contentType,
  });
  final String description;
  final String contentType;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          // padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: contentType == "sucess"
                ? AppColors.appSnackBarGreenColor
                : contentType == "warning"
                    ? AppColors.appSnackBarOrangeColor
                    : AppColors.appSnackBarRedColor,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          height: 90.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 68.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    const AmdText(
                      text: "Oh Snap....",
                      color: AppColors.whitetextColor,
                      size: 18.0,
                    ),
                    AmdText(
                      text: description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.whitetextColor,
                      size: 12.0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(
                20.0,
              ),
            ),
            child: SvgPicture.asset(
              contentType == "sucess"
                  ? "assets/icons/greenbubbles.svg"
                  : contentType == "warning"
                      ? "assets/icons/yellowbubbles.svg"
                      : "assets/icons/bubbles.svg",
              height: 48.0,
              width: 40.0,
            ),
          ),
        ),
        Positioned(
          top: -13.0,
          left: 0.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                contentType == "sucess"
                    ? "assets/icons/sucesssym.svg"
                    : contentType == "warning"
                        ? "assets/icons/warningsym.svg"
                        : "assets/icons/errorsym.svg",
                height: 30.0,
              ),
              // Positioned(
              //   top: 8.0,
              //   // left: 0.0.w,
              //   child: SvgPicture.asset(
              //     contentType == "sucess"
              //         ? "assets/icons/check.svg"
              //         : contentType == "warning"
              //             ? "assets/icons/question.svg"
              //             : "assets/icons/close.svgg",

              //     height: 10.0,
              //     // color: Color.fromRGBO(252, 166, 82, 1),
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }
}
































// import 'package:flutter_svg/flutter_svg.dart';

// import '../utils/my_package.dart';

// class AppSnackBar {
//   static void show(BuildContext context, String message,
//       {Color? backgroundColor}) {
//     final snackBar = SnackBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0.0,
//       content: CustomSnackBarContent(message, backgroundColor),
//       padding: EdgeInsets.symmetric(horizontal: 600.0),
//       // padding: const EdgeInsets.only(left: 500.0, right: 400.0, bottom: 50.0),
//       duration: const Duration(seconds: 3), // Adjust the duration as needed
//       behavior: SnackBarBehavior.floating,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }

// class CustomSnackBarContent extends StatelessWidget {
//   final String message;
//   final Color? backgroundColor;

//   const CustomSnackBarContent(this.message, this.backgroundColor, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(
//       context,
//       designSize: const Size(
//         1440,
//         1024,
//       ),
//     );
//     return SizedBox(
//       height: 100.0.w,
//       width: 350.0.w,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             bottom: 0.0.w,
//             child: Container(
//               height: 90.0.w,
//               width: 350.0.w,
//               padding: EdgeInsets.all(16.0.w),
//               decoration: BoxDecoration(
//                   color: backgroundColor ??
//                       Theme.of(context).snackBarTheme.backgroundColor,
//                   borderRadius: BorderRadius.circular(20.0.w)),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 48.0.w,
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Icon(
//                         //   Icons.info_outline,
//                         //   color: Theme.of(context).snackBarTheme.actionTextColor,
//                         // ),
//                         // SizedBox(width: 8.0.W),
//                         // SizedBox(
//                         //   width: MediaQuery.of(context).size.width * 0.4 -
//                         //       48.0.W, // Adjust width as needed
//                         //   child: Text(
//                         //     message,
//                         //     style: TextStyle(
//                         //         color: Theme.of(context).snackBarTheme.actionTextColor),
//                         //   ),
//                         // ),
//                         AppText(
//                           text: "Oh Snap....",
//                           color: AmdColor.whitetextColor,
//                           size: 18.0.sp,
//                         ),
//                         AppText(
//                           text: "App Default snack bar is showing....",
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           color: AmdColor.whitetextColor,
//                           size: 12.0.sp,
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0.0.w,
//             child: ClipRRect(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(
//                   20.0.w,
//                 ),
//               ),
//               child: SvgPicture.asset(
//                 "assets/icons/bubbles.svg",
//                 height: 48.0.w,
//                 width: 40.0.w,
//                 // // ignore: deprecated_member_use
//                 // color: Color(0xFF801336),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0.0.w,
//             left: 0.0.w,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 SvgPicture.asset(
//                   "assets/icons/fail.svg",
//                   height: 30.0.w,
//                 ),
//                 Positioned(
//                   top: 8.0.w,
//                   // left: 0.0.w,
//                   child: SvgPicture.asset(
//                     "assets/icons/close.svg",
//                     height: 10.0.w,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// //  Positioned(
// //             bottom: 0.0.w,
// //             child: ClipRRect(
// //               borderRadius: BorderRadius.only(
// //                 bottomLeft: Radius.circular(
// //                   20.0.w,
// //                 ),
// //               ),
// //               child: SvgPicture.asset(
// //                 "assets/icons/bubbles.svg",
// //                 height: 48.0.w,
// //                 width: 40.0.w,
// //                 // // ignore: deprecated_member_use
// //                 // color: Color(0xFF801336),
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             top: -20.0.w,
// //             left: 0.0.w,
// //             child: SvgPicture.asset(
// //               "assets/icons/fail.svg",
// //               height: 48.0.w,
// //               width: 40.0.w,
// //               // // ignore: deprecated_member_use
// //               // color: Color(0xFF801336),
// //             ),
// //           )
        