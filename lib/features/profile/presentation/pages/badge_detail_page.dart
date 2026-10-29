import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/features/profile/presentation/components/badge_grid.dart';
import 'package:calistracker/features/profile/presentation/components/profile_data.dart';
import 'package:calistracker/features/progress/domain/entities/achievement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One page per badge, swipe sideways to browse them all. Shows the status,
/// progress toward it, how to earn it and the other badges in its category.
class BadgeDetailPage extends StatefulWidget {
  const BadgeDetailPage({super.key, required this.initialIndex});

  final int initialIndex;

  /// Opens the badge at [index] of [achievements] above the tab bar.
  static Future<void> open(BuildContext context, int index) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => BadgeDetailPage(initialIndex: index)),
    );
  }

  @override
  State<BadgeDetailPage> createState() => _BadgeDetailPageState();
}

class _BadgeDetailPageState extends State<BadgeDetailPage> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) => _controller.animateToPage(
    index,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final statuses = ProfileData.watch(context).statuses;
    final unlocked = statuses.where((s) => s.unlocked).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Badge ${_index + 1} of ${statuses.length}'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: AppText(
                text: '$unlocked unlocked',
                fSize: 12.sp,
                fWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: statuses.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _BadgePage(
                  status: statuses[i],
                  siblings: [
                    for (var j = 0; j < statuses.length; j++)
                      if (statuses[j].achievement.category ==
                          statuses[i].achievement.category)
                        (j, statuses[j]),
                  ],
                  onSelect: _goTo,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _index > 0 ? () => _goTo(_index - 1) : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  IconButton(
                    onPressed: _index < statuses.length - 1
                        ? () => _goTo(_index + 1)
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgePage extends StatelessWidget {
  const _BadgePage({
    required this.status,
    required this.siblings,
    required this.onSelect,
  });

  final AchievementStatus status;
  final List<(int, AchievementStatus)> siblings;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final achievement = status.achievement;
    final progress = status.progress;
    final unlocked = status.unlocked;
    final muted = scheme.onSurface.withValues(alpha: 0.6);

    return ListView(
      padding: AppSizes.bodyPadding,
      children: [
        Center(
          child: Container(
            width: 120.r,
            height: 120.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha: 0.12),
              boxShadow: unlocked
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.4),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              unlocked ? achievementIcon(achievement.id) : Icons.lock,
              size: 56.r,
              color: unlocked
                  ? scheme.onPrimary
                  : scheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        AppText(
          text: achievement.title,
          fSize: 24.sp,
          fWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Center(
          child: Wrap(
            spacing: 8.w,
            children: [
              _Chip(
                icon: unlocked ? Icons.check_circle : Icons.lock_outline,
                label: unlocked ? 'Unlocked' : 'Locked',
                highlighted: unlocked,
              ),
              _Chip(
                icon: Icons.category_outlined,
                label: achievement.category.label,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        AppText(
          text: achievement.description,
          fSize: 15.sp,
          textAlign: TextAlign.center,
          textColor: muted,
        ),
        SizedBox(height: 20.h),
        AppCard(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText(
                    text: 'Progress',
                    fWeight: FontWeight.bold,
                    fSize: 15.sp,
                  ),
                  const Spacer(),
                  AppText(
                    text:
                        '${progress.shown} / ${progress.target} '
                        '${achievement.unit}',
                    fSize: 13.sp,
                    fWeight: FontWeight.w600,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: progress.fraction,
                  minHeight: 10.h,
                  backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
                ),
              ),
              SizedBox(height: 8.h),
              AppText(
                text: unlocked
                    ? 'Earned. Nice work!'
                    : '${progress.target - progress.shown} to go '
                          '(${(progress.fraction * 100).round()}% there)',
                fSize: 12.sp,
                textColor: muted,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        AppCard(
          padding: EdgeInsets.all(16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, color: scheme.primary),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: 'How to earn it',
                      fWeight: FontWeight.bold,
                      fSize: 15.sp,
                    ),
                    SizedBox(height: 4.h),
                    AppText(text: achievement.tip, fSize: 13.sp),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (siblings.length > 1) ...[
          SizedBox(height: 20.h),
          AppText(
            text: 'More in ${achievement.category.label}',
            fWeight: FontWeight.bold,
            fSize: 15.sp,
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final (index, other) in siblings)
                if (other.achievement.id != achievement.id)
                  ActionChip(
                    avatar: Icon(
                      other.unlocked ? Icons.check_circle : Icons.lock_outline,
                      size: 16.r,
                    ),
                    label: Text(other.achievement.title),
                    onPressed: () => onSelect(index),
                  ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: highlighted
            ? scheme.primary
            : scheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.r,
            color: highlighted ? scheme.onPrimary : scheme.onSurface,
          ),
          SizedBox(width: 4.w),
          AppText(
            text: label,
            fSize: 12.sp,
            fWeight: FontWeight.w600,
            textColor: highlighted ? scheme.onPrimary : null,
          ),
        ],
      ),
    );
  }
}
