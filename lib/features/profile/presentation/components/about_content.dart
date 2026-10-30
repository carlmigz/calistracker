import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/profile/presentation/components/profile_data.dart';
import 'package:calistracker/features/progress/domain/entities/achievement.dart';
import 'package:calistracker/features/progress/domain/entities/user_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Body of the "About CalisTracker" screen.
class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  static const version = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.65);
    final data = ProfileData.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              PoseImage(height: 120.h),
              SizedBox(height: 8.h),
              AppText(
                text: AppStrings.appName,
                fSize: 24.sp,
                fWeight: FontWeight.bold,
              ),
              SizedBox(height: 4.h),
              AppText(text: 'Version $version', fSize: 12.sp, textColor: muted),
              SizedBox(height: 10.h),
              AppText(
                text: 'A free calisthenics app for beginners.',
                fSize: 14.sp,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        _Section(
          icon: Icons.flag_outlined,
          title: 'Our mission',
          child: AppText(
            text:
                'CalisTracker helps you start training with nothing but your '
                'bodyweight. Every movement begins at an easy variation and '
                'builds step by step, so you can get stronger without '
                'needing a gym or any equipment.',
            fSize: 13.sp,
          ),
        ),
        _Section(
          icon: Icons.insights_outlined,
          title: 'In the app',
          child: Row(
            children: [
              _Count(value: '${data.programs.length}', label: 'Programs'),
              _Count(value: '${data.totalExercises}', label: 'Exercises'),
              _Count(value: '${achievements.length}', label: 'Badges'),
              _Count(value: '${UserLevel.tiers.length}', label: 'Ranks'),
            ],
          ),
        ),
        _Section(
          icon: Icons.route_outlined,
          title: 'How it works',
          child: Column(
            children: const [
              _Point(
                icon: Icons.stairs_outlined,
                title: 'Programs',
                text:
                    'Each program is a progression, for example push-ups from '
                    'the wall to a full push-up. Exercises unlock in order '
                    'once you finish the one before.',
              ),
              _Point(
                icon: Icons.timer_outlined,
                title: 'Sets, holds and rest',
                text:
                    'Workouts guide you through each set or timed hold and '
                    'time your rest in between. Set your default rest in '
                    'Timer & feedback.',
              ),
              _Point(
                icon: Icons.local_fire_department_outlined,
                title: 'Streaks and goals',
                text:
                    'Train on consecutive days to build a streak, and set '
                    'daily and weekly goals to stay on track.',
              ),
              _Point(
                icon: Icons.military_tech_outlined,
                title: 'Ranks and badges',
                text:
                    'Completing different exercises raises your rank. '
                    'Badges reward streaks, volume and good habits.',
              ),
            ],
          ),
        ),
        _Section(
          icon: Icons.star_outline,
          title: 'Features',
          child: Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              for (final f in const [
                'Step-by-step programs',
                'Rep and hold workouts',
                'Rest timer',
                'Haptics and sound',
                'Activity heatmap',
                'Daily and weekly goals',
                'Streak tracking',
                'Ranks and badges',
                'Light and dark theme',
                'Custom avatar',
              ])
                Chip(visualDensity: VisualDensity.compact, label: Text(f)),
            ],
          ),
        ),
        _Section(
          icon: Icons.lock_outline,
          title: 'Your data',
          child: AppText(
            text:
                'Everything stays on this device. There is no account '
                'backend, no ads and no tracking. Your progress, settings and '
                'avatar are saved locally. You can copy a summary or reset '
                'your progress any time from the Data section of your '
                'profile. Uninstalling the app removes it all.',
            fSize: 13.sp,
          ),
        ),
        _Section(
          icon: Icons.health_and_safety_outlined,
          title: 'Train safely',
          child: AppText(
            text:
                'CalisTracker is not medical advice. Warm up, move with '
                'control and stop if something hurts. If you have an injury '
                'or a health condition, check with a doctor before you start '
                'a new routine.',
            fSize: 13.sp,
          ),
        ),
        _Section(
          icon: Icons.favorite_border,
          title: 'Credits',
          child: AppText(
            text:
                'Built with Flutter. The yellow guy is the CalisTracker '
                'mascot, and the program content is placeholder material '
                'that will keep improving.',
            fSize: 13.sp,
          ),
        ),
        SizedBox(height: 4.h),
        OutlinedButton.icon(
          onPressed: () => showLicensePage(
            context: context,
            applicationName: AppStrings.appName,
            applicationVersion: version,
            applicationLegalese: AppStrings.settingsLegalese,
          ),
          icon: const Icon(Icons.description_outlined),
          label: const Text('Open source licenses'),
        ),
        SizedBox(height: 12.h),
        Center(
          child: AppText(
            text: AppStrings.settingsLegalese,
            fSize: 11.sp,
            textColor: muted,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: AppCard(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20.r, color: scheme.primary),
                SizedBox(width: 8.w),
                AppText(text: title, fSize: 15.sp, fWeight: FontWeight.bold),
              ],
            ),
            SizedBox(height: 10.h),
            child,
          ],
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AppText(text: value, fSize: 20.sp, fWeight: FontWeight.bold),
          AppText(
            text: label,
            fSize: 11.sp,
            textColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ],
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: title, fSize: 13.sp, fWeight: FontWeight.w600),
                SizedBox(height: 2.h),
                AppText(text: text, fSize: 12.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
