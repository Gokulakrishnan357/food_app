import 'package:flutter/material.dart';

class HorizontalDottedLine extends StatelessWidget {
  final double? width; // Optional custom width
  final double dotSize;
  final Color color;

  const HorizontalDottedLine({
    super.key,
    this.width, // Pass null to use the parent widget's width
    this.dotSize = 4.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Use the provided width or fall back to the parent's width
        final double effectiveWidth = width ?? constraints.maxWidth;

        return SizedBox(
          width: effectiveWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              (effectiveWidth / dotSize).floor(),
              (index) => Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
