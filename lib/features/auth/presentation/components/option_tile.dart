import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A tappable card used for single and multi choice questions.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.hint,
    this.compact = false,
  });

  final String label;
  final String? hint;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  /// Vertical layout for grids; otherwise a full-width row.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppSizes.cardRadius.r);

    final iconBadge = Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected
            ? scheme.primary
            : scheme.onSurface.withValues(alpha: 0.08),
      ),
      child: Icon(
        icon,
        size: 20.r,
        color: selected ? scheme.onPrimary : scheme.onSurface,
      ),
    );

    final text = Column(
      crossAxisAlignment: compact
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          fSize: 13.sp,
          fWeight: FontWeight.w600,
          textAlign: compact ? TextAlign.center : TextAlign.start,
        ),
        if (hint != null)
          AppText(
            text: hint,
            fSize: 11.sp,
            textColor: scheme.onSurface.withValues(alpha: 0.6),
          ),
      ],
    );

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected
            ? scheme.primary.withValues(alpha: 0.16)
            : scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: selected
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.18),
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: compact
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconBadge,
                      SizedBox(height: 8.h),
                      text,
                    ],
                  )
                : Row(
                    children: [
                      iconBadge,
                      SizedBox(width: 12.w),
                      Expanded(child: text),
                      if (selected)
                        Icon(Icons.check_circle, color: scheme.primary),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
