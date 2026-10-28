import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/session/app_session.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.themeMode});

  final ThemeMode themeMode;

  Future<void> _confirmReset(BuildContext context) async {
    final progress = context.read<ProgressBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.settingsResetProgressTitle),
        content: const Text(AppStrings.settingsResetProgressMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppStrings.reset),
          ),
        ],
      ),
    );
    if (confirmed == true) progress.add(const ProgressReset());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.settingsTheme),
              SizedBox(height: 8.h),
              SizedBox(
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
            ],
          ),
        ),
        SizedBox(height: 8.h),
        ListTile(
          leading: const Icon(Icons.restart_alt),
          title: const Text(AppStrings.settingsResetProgress),
          onTap: () => _confirmReset(context),
        ),
        SizedBox(height: 8.h),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text(AppStrings.settingsAbout),
          onTap: () => showAboutDialog(
            context: context,
            applicationName: AppStrings.appName,
            applicationVersion: '1.0.0',
            applicationLegalese: AppStrings.settingsLegalese,
          ),
        ),
        SizedBox(height: 16.h),
        AppButton(
          text: AppStrings.settingsLogOut,
          icon: Icons.logout,
          onPressed: () => context.read<AppSession>().logOut(),
        ),
      ],
    );
  }
}
