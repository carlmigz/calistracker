import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({
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
    final defaultStyle = AppTextStyles.body.copyWith(
      fontFamily: fFamily,
      fontSize: fSize,
      fontWeight: fWeight,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      color: textColor ?? Theme.of(context).colorScheme.onSurface,
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
