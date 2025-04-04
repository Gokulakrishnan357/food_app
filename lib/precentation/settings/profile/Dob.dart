import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateOfBirthField extends StatelessWidget {
  final TextEditingController controller;

  const DateOfBirthField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        }
      },

      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Select your Date of Birth",
              hintStyle: GoogleFonts.robotoFlex(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              filled: true,
              fillColor: const Color(0xFFF4F4F4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.robotoFlex(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

