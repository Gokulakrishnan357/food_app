import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeroq/precentation/order_status/order_status_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressContainer extends StatelessWidget {
  final OrderStatusController orderStatusController =
      Get.find<OrderStatusController>();

  ProgressContainer({super.key});

  Widget _buildStage(String text, int stage, int currentStage) {
    bool isCompleted = currentStage >= stage;
    bool isActive = currentStage == stage;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Animated Status Icon
        Padding(
          padding: const EdgeInsets.all(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              gradient:
                  isCompleted
                      ? LinearGradient(
                        colors: [Colors.green, Colors.lightGreen],
                      )
                      : (isActive
                          ? LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                          )
                          : LinearGradient(
                            colors: [Colors.grey[400]!, Colors.grey[500]!],
                          )),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child:
                  isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 20.0)
                      : (isActive
                          ? const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : const Icon(
                            Icons.radio_button_unchecked,
                            color: Colors.white,
                            size: 18.0,
                          )),
            ),
          ),
        ),
        const SizedBox(width: 14.0),

        // Status Text with Animation
        Expanded(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isCompleted || isActive ? Colors.black87 : Colors.grey,
            ),
            child: Text(text),
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isCompleted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 3.5,
      height: 40.0,
      margin: const EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        gradient:
            isCompleted
                ? LinearGradient(colors: [Colors.green, Colors.lightGreen])
                : LinearGradient(
                  colors: [Colors.grey[400]!, Colors.grey[500]!],
                ),
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      int currentStage = orderStatusController.orderStage.value;

      if (currentStage == 6 || currentStage == 7) {
        return Center(
          child: Container(
            width: screenWidth * 0.9,
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              "🚨 Order Canceled or Failed",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      return Center(
        child: Container(
          width: screenWidth * 0.9, // Responsive width
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 26.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStage("📝 Order Pending", 1, currentStage),
              _buildLine(currentStage > 1),
              _buildStage("✅ Order Confirmed", 2, currentStage),
              _buildLine(currentStage > 2),
              _buildStage("👨‍🍳 Food is Being Prepared", 3, currentStage),
              _buildLine(currentStage > 3),
              _buildStage("📦 Ready for Pickup", 4, currentStage),
              _buildLine(currentStage > 4),
              _buildStage("🚚 Out for Delivery", 5, currentStage),
            ],
          ),
        ),
      );
    });
  }
}
