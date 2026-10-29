import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/progress/domain/entities/user_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Every rank tier with its requirement; reached tiers are filled in.
class LevelRoadmap extends StatelessWidget {
  const LevelRoadmap({super.key, required this.completed});

  final int completed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tiers = UserLevel.tiers;
    final current = UserLevel.forCompleted(completed).name;

    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Column(
        children: [
          for (var i = 0; i < tiers.length; i++)
            _Row(
              name: tiers[i].name,
              requirement: AppStrings.profileRoadmapAt(tiers[i].at),
              reached: completed >= tiers[i].at,
              isCurrent: tiers[i].name == current,
              isLast: i == tiers.length - 1,
              scheme: scheme,
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.name,
    required this.requirement,
    required this.reached,
    required this.isCurrent,
    required this.isLast,
    required this.scheme,
  });

  final String name;
  final String requirement;
  final bool reached;
  final bool isCurrent;
  final bool isLast;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final muted = scheme.onSurface.withValues(alpha: 0.5);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12.w,
        children: [
          Column(
            children: [
              SizedBox(height: 6.h),
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: reached ? scheme.primary : Colors.transparent,
                  border: Border.all(
                    color: reached ? scheme.primary : muted,
                    width: 2,
                  ),
                ),
                child: reached
                    ? Icon(Icons.check, size: 14.r, color: scheme.onPrimary)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: reached ? scheme.primary : muted,
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 6.h : 14.h, top: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: name,
                    fWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    fSize: 14.sp,
                    textColor: reached ? null : muted,
                  ),
                  AppText(
                    text: requirement,
                    fSize: 12.sp,
                    textColor: reached ? null : muted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
