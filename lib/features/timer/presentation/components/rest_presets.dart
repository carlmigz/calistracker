import 'package:calistracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestPresets extends StatelessWidget {
  const RestPresets({
    super.key,
    required this.presets,
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  final List<int> presets;
  final int selected;
  final bool enabled;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.center,
      children: [
        for (final seconds in presets)
          ChoiceChip(
            showCheckmark: false,
            selected: seconds == selected,
            selectedColor: scheme.primary,
            label: Text(
              seconds >= 60 && seconds % 60 == 0
                  ? AppStrings.timerMinutes(seconds ~/ 60)
                  : AppStrings.timerSeconds(seconds),
              style: TextStyle(
                color: seconds == selected
                    ? scheme.onPrimary
                    : scheme.onSurface,
              ),
            ),
            onSelected: enabled ? (_) => onSelected(seconds) : null,
          ),
      ],
    );
  }
}
