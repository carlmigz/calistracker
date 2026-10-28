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
        title: const Text('Reset progress?'),
        content: const Text(
          'This clears every completed exercise, your streak and badges. '
          'It cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) progress.add(const ProgressReset());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Theme'),
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                    ),
                    ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          tileColor: scheme.surfaceContainerHighest,
          leading: const Icon(Icons.restart_alt),
          title: const Text('Reset progress'),
          onTap: () => _confirmReset(context),
        ),
        SizedBox(height: 8.h),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          tileColor: scheme.surfaceContainerHighest,
          leading: const Icon(Icons.info_outline),
          title: const Text('About CalisTracker'),
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'CalisTracker',
            applicationVersion: '1.0.0',
            applicationLegalese: 'A free beginner calisthenics companion.',
          ),
        ),
        SizedBox(height: 16.h),
        AppButton(
          text: 'Log out',
          icon: Icons.logout,
          onPressed: () => context.read<AppSession>().logOut(),
        ),
      ],
    );
  }
}
