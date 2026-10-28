import 'package:calistracker/core/themes/app_colors.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AppButton extends StatelessWidget {
  const AppButton({
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
  final String text;
  final double? height;
  final double? width;
  final IconData? icon;
  final double? textSize;
  final FontWeight? weight;
  final Color? lineColor;
  final Color? textColor;
  final BorderRadius? buttonRadius;
  final bool isLoading;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height ?? 44.h,
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: buttonRadius ?? BorderRadius.circular(50.r),
          ),
          backgroundColor: btnColor ?? scheme.primary,
          side: BorderSide(color: lineColor ?? AppColors.transparent),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: scheme.onPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: iconColor ?? scheme.onPrimary),
                    Gap(8.w),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.button.copyWith(
                        color: textColor ?? scheme.onPrimary,
                        fontSize: textSize,
                        fontWeight: weight,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
