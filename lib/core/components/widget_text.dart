import 'package:calistracker/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetText extends StatelessWidget {
  const WidgetText({
    super.key,
    required this.text,
    this.textSpan,
    this.fFamily,
    this.fSize,
    this.fWeight,
    this.textColor,
    this.overflow,
    this.textAlign,
    this.isItalic = false,
    this.maxLines,
    this.textUnderline,
  }) : assert(
         text != null || textSpan != null,
         'Either text or textSpan must be provided',
       );

  final String? text;
  final TextSpan? textSpan;
  final String? fFamily;
  final double? fSize;
  final FontWeight? fWeight;
  final Color? textColor;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool isItalic;
  final int? maxLines;
  final bool? textUnderline;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontFamily: fFamily ?? 'Poppins',
      fontSize: fSize ?? 14.sp,
      fontWeight: fWeight ?? FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      color: textColor ?? AppColors.white,
      overflow: overflow,
      decoration: (textUnderline == true)
          ? TextDecoration.underline
          : TextDecoration.none,
    );

    if (textSpan != null) {
      return RichText(
        textAlign: textAlign ?? TextAlign.start,
        text: TextSpan(style: defaultStyle, children: [textSpan!]),
      );
    }

    return Text(
      text ?? '',
      textAlign: textAlign ?? TextAlign.start,
      style: defaultStyle,
      maxLines: maxLines,
    );
  }
}
