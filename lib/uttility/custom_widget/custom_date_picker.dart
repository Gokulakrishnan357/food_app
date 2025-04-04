import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String dateFormat;
  final DateTime? initialDate;
  final DateTime? firstDate; // Optional
  final DateTime? lastDate; // Optional

  const DatePickerField({
    super.key,
    required this.controller,
    this.hintText = "Select Date",
    this.dateFormat = 'yyyy-MM-dd',
    this.initialDate, // Allow null value
    this.firstDate, // Optional
    this.lastDate, // Optional
  });

  // Function to open the date picker
  Future<void> _selectDate(BuildContext context) async {
    // Ensure firstDate is at least today's date
    DateTime safeFirstDate = firstDate ?? DateTime.now();
    DateTime selectedDate =
        initialDate ?? safeFirstDate; // Handle null initial date

    // If initialDate is before safeFirstDate, reset it to safeFirstDate
    if (initialDate != null && initialDate!.isBefore(safeFirstDate)) {
      selectedDate = safeFirstDate;
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: safeFirstDate, // Default to today's date if null
      lastDate: lastDate ?? DateTime.now(), // Default to today's date if null
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      controller.text = DateFormat(dateFormat).format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(fontSize: 17, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE3E3E3)),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE3E3E3)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE3E3E3)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      readOnly: true, // To make it read-only (date picker will update this)
      onTap: () => _selectDate(context), // Open date picker on tap
    );
  }
}
