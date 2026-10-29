import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One progress bar per program, each with a menu to reset just that program.
class ProgramProgressList extends StatelessWidget {
  const ProgramProgressList({
    super.key,
    required this.programs,
    required this.completed,
    required this.onReset,
  });

  final List<Program> programs;
  final Set<String> completed;
  final ValueChanged<Program> onReset;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      child: Column(
        children: [
          for (final program in programs)
            Builder(
              builder: (context) {
                final done = program.completedCount(completed);
                final total = program.exercises.length;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    spacing: 8.w,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  text: program.name,
                                  fSize: 13.sp,
                                  fWeight: FontWeight.w600,
                                ),
                                AppText(text: '$done / $total', fSize: 12.sp),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: LinearProgressIndicator(
                                value: total == 0 ? 0 : done / total,
                                minHeight: 6.h,
                                color: scheme.primary,
                                backgroundColor: scheme.onSurface.withValues(
                                  alpha: 0.12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: AppStrings.profileResetProgram,
                        visualDensity: VisualDensity.compact,
                        onPressed: done == 0 ? null : () => onReset(program),
                        icon: const Icon(Icons.restart_alt),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
