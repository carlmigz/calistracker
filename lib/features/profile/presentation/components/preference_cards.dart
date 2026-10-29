import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Light / dark / system choice.
class ThemeCard extends StatelessWidget {
  const ThemeCard({super.key, required this.themeMode});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(12.r),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: ThemeMode.system,
              label: Text(AppStrings.settingsThemeSystem),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              label: Text(AppStrings.settingsThemeLight),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text(AppStrings.settingsThemeDark),
            ),
          ],
          selected: {themeMode},
          onSelectionChanged: (s) =>
              context.read<SettingsCubit>().setThemeMode(s.first),
        ),
      ),
    );
  }
}

/// Vibration, sound and default rest time used by the timer.
class TimerPreferencesCard extends StatelessWidget {
  const TimerPreferencesCard({super.key, required this.settings});

  final SettingsState settings;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return AppCard(
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: const Text(AppStrings.settingsHaptics),
            subtitle: const Text(AppStrings.settingsHapticsHint),
            value: settings.hapticsEnabled,
            onChanged: cubit.setHapticsEnabled,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: const Text(AppStrings.settingsSound),
            subtitle: const Text(AppStrings.settingsSoundHint),
            value: settings.soundEnabled,
            onChanged: cubit.setSoundEnabled,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.settingsDefaultRest),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  children: [
                    for (final seconds in SettingsCubit.restPresets)
                      ChoiceChip(
                        label: Text('${seconds}s'),
                        selected: settings.defaultRestSeconds == seconds,
                        onSelected: (_) =>
                            cubit.setDefaultRestSeconds(seconds),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
