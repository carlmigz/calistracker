import 'package:calistracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterChipRow<T> extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.values,
    required this.selected,
    required this.label,
    required this.onChanged,
  });

  final List<T> values;
  final T? selected;
  final String Function(T) label;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget chip(String text, bool isSelected, VoidCallback onTap) => ChoiceChip(
      showCheckmark: false,
      selected: isSelected,
      selectedColor: scheme.primary,
      label: Text(
        text,
        style: TextStyle(
          color: isSelected ? scheme.onPrimary : scheme.onSurface,
        ),
      ),
      onSelected: (_) => onTap(),
    );

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        itemCount: values.length + 1,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          if (i == 0) {
            return chip(
              AppStrings.workoutsFilterAll,
              selected == null,
              () => onChanged(null),
            );
          }
          final value = values[i - 1];
          return chip(
            label(value),
            value == selected,
            () => onChanged(value == selected ? null : value),
          );
        },
      ),
    );
  }
}
