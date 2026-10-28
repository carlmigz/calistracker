import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Rounded surface used for cards and grouped tiles across the app.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.large = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  /// Defaults to `surfaceContainerHighest`.
  final Color? color;

  /// Uses the larger corner radius, for prominent cards.
  final bool large;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    return Material(
      color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(
        (large ? AppSizes.cardRadiusLarge : AppSizes.cardRadius).r,
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
