import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';



class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isReadOnly;
  final bool isNumberOnly;
  final bool isTextOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isReadOnly = false,
    this.isNumberOnly = false,
    this.isTextOnly = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorMessage;

  void _validateInput(String value) {
    if (widget.isTextOnly && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      setState(() {
        errorMessage = "Only letters are allowed!";
      });
    } else {
      setState(() {
        errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: widget.controller,
            readOnly: widget.isReadOnly,
            keyboardType:
            widget.isNumberOnly ? TextInputType.number : TextInputType.text,
            inputFormatters: [
              if (widget.isNumberOnly) FilteringTextInputFormatter.digitsOnly,
              if (widget.isTextOnly)
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
            ],
            onChanged: _validateInput,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F4F4),
              hintText: widget.hint,
              hintStyle: GoogleFonts.robotoFlex(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.robotoFlex(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 10),
            child: Text(
              errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}