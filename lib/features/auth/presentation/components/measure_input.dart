import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A large value readout with a unit toggle, a slider and -/+ buttons.
/// [value] and the range are expressed in the currently selected unit.
class MeasureInput extends StatelessWidget {
  const MeasureInput({
    super.key,
    required this.label,
    required this.units,
    required this.unitIndex,
    required this.onUnitChanged,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.caption,
  });

  final String label;
  final List<String> units;
  final int unitIndex;
  final ValueChanged<int> onUnitChanged;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  /// Small extra line under the value, e.g. 5′ 7″.
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final shown = value.clamp(min, max).roundToDouble();

    void step(int delta) => onChanged((shown + delta).clamp(min, max));

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusLarge.r),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  text: label,
                  fSize: 15.sp,
                  fWeight: FontWeight.w700,
                ),
              ),
              SegmentedButton<int>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  selectedBackgroundColor: scheme.primary,
                  selectedForegroundColor: scheme.onPrimary,
                ),
                segments: [
                  for (var i = 0; i < units.length; i++)
                    ButtonSegment(value: i, label: Text(units[i])),
                ],
                selected: {unitIndex},
                onSelectionChanged: (s) => onUnitChanged(s.first),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                tooltip: 'Decrease $label',
                onPressed: shown > min ? () => step(-1) : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 140.w,
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: shown.toStringAsFixed(0),
                        style: TextStyle(
                          fontFamily: AppTextStyles.headingFontFamily,
                          fontSize: 32.sp,
                          color: scheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: ' ${units[unitIndex]}',
                            style: TextStyle(
                              fontFamily: null,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (caption != null)
                      AppText(
                        text: caption,
                        fSize: 12.sp,
                        textColor: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Increase $label',
                onPressed: shown < max ? () => step(1) : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Slider(
            value: shown,
            min: min,
            max: max,
            divisions: (max - min).round(),
            label: '${shown.toStringAsFixed(0)} ${units[unitIndex]}',
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
