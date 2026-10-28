import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/presentation/components/program_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgramGridCard extends StatelessWidget {
  const ProgramGridCard({
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
    final isComplete = total > 0 && done == total;

    return AppCard(
      large: true,
      onTap: onTap,
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                child: Icon(programIcon(program.id)),
              ),
              if (isComplete)
                Icon(Icons.verified, color: scheme.primary, size: 22.r),
            ],
          ),
          const Spacer(),
          AppText(
            text: program.name.replaceAll(' Progression', ''),
            fFamily: AppTextStyles.fontFamily,
            fWeight: FontWeight.bold,
            fSize: 16.sp,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          AppText(
            text: AppStrings.programExercisesDone(done, total),
            fSize: 11.sp,
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: 6.h,
            ),
          ),
        ],
      ),
    );
  }
}
