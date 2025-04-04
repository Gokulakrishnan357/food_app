import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ToggleController extends GetxController {
  var isSelfPickup = true.obs;

  void toggleSwitch(int index) {
    isSelfPickup.value = (index == 0);
  }
}

class CustomToggleSwitch extends StatelessWidget {
  final ToggleController toggleController = Get.put(ToggleController());

  CustomToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 343.03,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(width: 1.5, color: const Color(0xFF418612)),
          color: Colors.white, // White background
        ),
        child: Obx(
              () => Row(
            children: [
              // Delivery Button
              Expanded(
                child: GestureDetector(
                  onTap: () => toggleController.toggleSwitch(1),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: !toggleController.isSelfPickup.value
                          ? const LinearGradient(
                        colors: [Color(0xFF418612), Color(0xFF6BCC29)],
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                      ) // Selected: Gradient
                          : null, // Unselected: White
                      color: toggleController.isSelfPickup.value
                          ? Colors.white
                          : null, // Unselected: White
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIcon(
                            "assets/images/delivery.svg",
                            !toggleController.isSelfPickup.value,
                          ),
                          const SizedBox(width: 5),
                          _buildGradientText(
                            "Delivery",
                            !toggleController.isSelfPickup.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Self-Pickup Button
              Expanded(
                child: GestureDetector(
                  onTap: () => toggleController.toggleSwitch(0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: toggleController.isSelfPickup.value
                          ? const LinearGradient(
                        colors: [Color(0xFF418612), Color(0xFF6BCC29)],
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                      ) // Selected: Gradient
                          : null, // Unselected: White
                      color: !toggleController.isSelfPickup.value
                          ? Colors.white
                          : null, // Unselected: White
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIcon(
                            "assets/images/selfpickup.svg",
                            toggleController.isSelfPickup.value,
                          ),
                          const SizedBox(width: 5),
                          _buildGradientText(
                            "Self-Pickup",
                            toggleController.isSelfPickup.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Method to apply correct color to an icon based on selection
  Widget _buildIcon(String assetPath, bool isSelected) {
    return SvgPicture.asset(
      assetPath,
      height: 24,
      width: 24,
      colorFilter: ColorFilter.mode(
        isSelected ? Colors.white : const Color(0xFF418612), // White when selected, Green when not
        BlendMode.srcIn,
      ),
    );
  }

  /// Method to apply gradient color to text
  Widget _buildGradientText(String text, bool isSelected) {
    return isSelected
        ? Text(
      text,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        fontSize: 14.5,
        color: Colors.white
      ),

    )
        : ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Color(0xFF418612), Color(0xFF6BCC29)],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 14.5,
            color: Colors.white
        ),
      ),
    );
  }
}