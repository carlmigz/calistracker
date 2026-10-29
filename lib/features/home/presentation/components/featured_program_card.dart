import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturedProgramCard extends StatelessWidget {
  const FeaturedProgramCard({
    super.key,
    required this.program,
    required this.completed,
    required this.onTap,
  });

  final Program program;
  final Set<String> completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final done = program.completedCount(completed);
    final total = program.exercises.length;

    return AppCard(
      large: true,
      onTap: onTap,
      padding: EdgeInsets.all(14.r),
      child: Row(
        spacing: 12.w,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: AppStrings.homeRecommended,
                  fSize: 11.sp,
                  textColor: scheme.onSurface.withValues(alpha: 0.7),
                ),
                SizedBox(height: 2.h),
                AppText(
                  text: program.name,
                  fFamily: AppTextStyles.fontFamily,
                  fWeight: FontWeight.bold,
                  fSize: 16.sp,
                ),
                SizedBox(height: 2.h),
                AppText(
                  text: program.description,
                  fSize: 12.sp,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : done / total,
                    minHeight: 6.h,
                    color: scheme.primary,
                    backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: scheme.primary),
        ],
      ),
    );
  }
}
