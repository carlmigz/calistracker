import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton({
    super.key,
    this.btnColor,
    required this.onPressed,
    required this.text,
    this.height,
    this.width,
    this.icon,
    this.textSize,
    this.weight,
    this.lineColor,
    this.buttonRadius,
    this.textColor,
    this.isLoading = false,
    this.iconColor,
  });
  final Color? btnColor;
  final VoidCallback? onPressed;
  final String? text;
  final double? height;
  final double? width;
  final IconData? icon;
  final double? textSize;
  final FontWeight? weight;
  final Color? lineColor;
  final Color? textColor;
  final BorderRadius? buttonRadius;
  final bool? isLoading;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 40.h,
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: buttonRadius ?? BorderRadius.circular(50.r),
          ),
          backgroundColor: btnColor ?? Theme.of(context).colorScheme.primary,
          side: BorderSide(color: lineColor ?? Colors.transparent),
        ),
        onPressed: isLoading! ? null : onPressed,
        child: isLoading!
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, color: iconColor), Gap(8.w)],
                  Flexible(
                    child: Text(
                      text!,
                      style: TextStyle(
                        color:
                            textColor ??
                            Theme.of(context).colorScheme.secondary,
                        fontSize: textSize ?? 16.sp,
                        fontWeight: weight ?? FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
