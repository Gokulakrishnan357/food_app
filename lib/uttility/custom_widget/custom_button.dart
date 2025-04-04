// ignore_for_file: deprecated_member_use

import '../../const/app_exports.dart';

class AmdButton extends StatelessWidget {
  const AmdButton({
    super.key,
    this.press,
    required this.child,
    this.onHover,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.buttoncolor,
    this.size,
    this.radius,
    this.bordercolor,
  });
  final FocusNode? focusNode;
  final bool? autofocus;
  final VoidCallback? press;
  final ValueChanged<bool>? onHover;
  final Widget child;
  final ButtonStyle? style;
  final Color? buttoncolor;
  final Color? bordercolor;
  final Size? size;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'button',
      child: ElevatedButton(
        focusNode: focusNode,
        autofocus: autofocus!,
        onPressed: press,
        onHover: onHover,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: buttoncolor,
          fixedSize: size,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 5.0),
            side: BorderSide(
              color: bordercolor ?? Colors.transparent,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
