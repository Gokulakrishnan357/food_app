import '../../const/app_exports.dart';

class AmdText extends StatelessWidget {
  const AmdText({
    super.key,
    required this.text,
    this.size,
    this.color,
    this.weight,
    this.textAlign,
    this.textScaleFactor,
    this.height,
    this.overflow,
    this.maxLines,
    this.letterSpacing,
    this.semanticsLabel,
    this.textDecoration,
    this.style,
    this.textStyle,
    this.softwrap,
  });
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? textAlign;
  final double? textScaleFactor;
  final double? height;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? letterSpacing;
  final String? semanticsLabel;
  final TextDecoration? textDecoration;
  final bool? softwrap;
  final TextStyle? textStyle;

  final FontStyle? style;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'text',
      child: Text(
        text,
        textAlign: textAlign,
        textScaler: const TextScaler.linear(1.0),
        overflow: overflow,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        softWrap: softwrap ?? false,
        style: GoogleFonts.montserrat(
          fontSize: size ?? 14.0,
          color: color ?? Colors.black,
          fontWeight: weight ?? FontWeight.w400,
          height: height,
          fontStyle: style,
          letterSpacing: letterSpacing,

        ),
      ),
    );
  }
}
