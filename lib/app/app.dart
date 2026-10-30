import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/app/app_dependencies.dart';
import 'package:calistracker/app/app_providers.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/core/themes/app_theme.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class CalisTrackerApp extends StatefulWidget {
  const CalisTrackerApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<CalisTrackerApp> createState() => _CalisTrackerAppState();
}

class _CalisTrackerAppState extends State<CalisTrackerApp> {
  late final AppDependencies _dependencies = AppDependencies(widget.prefs);
  late final GoRouter _router = createRouter(_dependencies.session);

  @override
  void dispose() {
    _router.dispose();
    _dependencies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      dependencies: _dependencies,
      child: ToastificationWrapper(
        config: ToastificationConfig(alignment: Alignment.topCenter),
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          splitScreenMode: true,
          minTextAdapt: true,
          builder: (context, _) => BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (a, b) => a.themeMode != b.themeMode,
            builder: (context, settings) => MaterialApp.router(
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: settings.themeMode,
              routerConfig: _router,
              builder: (context, child) => ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SafeArea(
                  top: false,
                  bottom: true,
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
