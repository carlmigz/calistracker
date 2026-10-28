import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgramExerciseTile extends StatelessWidget {
  const ProgramExerciseTile({
    super.key,
    required this.exercise,
    required this.number,
    required this.isDone,
    required this.isUnlocked,
    required this.onTap,
  });

  final Exercise exercise;
  final int number;
  final bool isDone;
  final bool isUnlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Opacity(
      opacity: isUnlocked ? 1 : 0.5,
      child: ListTile(
        enabled: isUnlocked,
        onTap: isUnlocked ? onTap : null,
        leading: CircleAvatar(
          backgroundColor: isDone ? scheme.primary : scheme.surface,
          foregroundColor: isDone ? scheme.onPrimary : scheme.onSurface,
          child: isDone ? const Icon(Icons.check) : Text('$number'),
        ),
        title: AppText(
          text: exercise.name,
          fFamily: AppTextStyles.fontFamily,
          fWeight: FontWeight.w600,
        ),
        subtitle: AppText(text: exercise.target, fSize: 12.sp),
        trailing: Icon(isUnlocked ? Icons.chevron_right : Icons.lock),
      ),
    );
  }
}
