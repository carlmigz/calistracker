import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.highlighted = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = highlighted ? scheme.onPrimary : scheme.onSurface;

    return AppCard(
      padding: EdgeInsets.all(16.r),
      color: highlighted ? scheme.primary : null,
      large: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foreground),
          SizedBox(height: 8.h),
          AppText(
            text: value,
            fFamily: AppTextStyles.headingFontFamily,
            fSize: 28.sp,
            textColor: foreground,
          ),
          AppText(text: label, fSize: 12.sp, textColor: foreground),
        ],
      ),
    );
  }
}
