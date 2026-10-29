import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Shortcuts to other tabs.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        _Action(
          icon: Icons.timer_rounded,
          label: AppStrings.homeQuickTimer,
          onTap: () => context.go(AppRoutes.timer),
        ),
        _Action(
          icon: Icons.fitness_center_rounded,
          label: AppStrings.homeQuickWorkouts,
          onTap: () => context.go(AppRoutes.workouts),
        ),
        _Action(
          icon: Icons.bar_chart_rounded,
          label: AppStrings.homeQuickProgress,
          onTap: () => context.go(AppRoutes.progress),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: AppCard(
        onTap: onTap,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          spacing: 6.h,
          children: [
            Icon(icon, color: scheme.primary),
            AppText(text: label, fSize: 12.sp, fWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}
