// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/services.dart';

import '../../const/app_exports.dart';

class AmdTextField extends StatelessWidget {
  final String hinttext;
  final String? initial;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final Widget? iconButton;
  final void Function(String?)? changed;
  final FormFieldValidator<String>? validator;
  final void Function(String?)? onSave;
  bool? obscureText = false;
  bool? enableText = true;
  List<TextInputFormatter>? formatter;
  final VoidCallback? fieldclear;
  final VoidCallback? datepicker;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? inputaction;
  final void Function(String?)? fieldsubmit;
  final Widget? prefixIcon;
  final Color? fbColor;
  final Color? ebColor;
  final Color? lblColor;
  final Color? hintLblColor;
  final int? maxLength;
  final Widget? suffixicon;
  bool? passwordField = false;
  AmdTextField({
    super.key,
    required this.hinttext,
    this.changed,
    this.validator,
    this.onSave,
    this.controller,
    this.textInputType,
    this.textCapitalization,
    this.iconButton,
    required this.obscureText,
    this.formatter,
    this.fieldclear,
    this.datepicker,
    this.initial,
    this.maxLines,
    this.inputaction,
    this.fieldsubmit,
    this.minLines,
    this.prefixIcon,
    this.fbColor,
    this.lblColor,
    this.hintLblColor,
    this.ebColor,
    this.maxLength,
    this.suffixicon,
    this.passwordField,
    this.enableText,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enableText,
      decoration: InputDecoration(
        labelText: hinttext,
        hintText: hinttext,

        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: GoogleFonts.montserrat(
          color: lblColor ?? AppColors.dineInTextLabelColor,
        ),
        hintStyle: GoogleFonts.nunito(
          color: hintLblColor ?? AppColors.whitetextColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        border: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ebColor ?? AppColors.dineInTextLabelColor,
            width: 1.5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: fbColor ?? AppColors.greenColor,
            width: 3,
          ),
        ),
        // prefixIcon: Icon(Icons.add),
        suffixIcon: passwordField == false
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                color: AppColors.headingtextColor,
                onPressed: obscureText == false
                    ? () => controller!.clear()
                    : fieldclear,
                // color: AppColor.bluetextColor,
                // onPressed: () => controller!.clear(),
              )
            : suffixicon,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icon/Lock.svg"),
        prefixIcon: prefixIcon,
      ),
      // expands: true,
      onChanged: changed,
      validator: validator,
      onSaved: onSave,
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: formatter,
      onTap: datepicker,
      initialValue: initial,
      maxLength: maxLength,
      // maxLines: maxLines,
      // minLines: minLines,
      obscureText: obscureText!,
      textInputAction: inputaction,
      // autofocus: true,
      // textCapitalization: textCapitalization!,
      onFieldSubmitted: fieldsubmit,
    );
  }
}
