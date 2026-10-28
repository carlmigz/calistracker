import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: ToastificationConfig(alignment: Alignment.center),
      child: ScreenUtilInit(
        designSize: ScreenUtil.defaultSize,
        splitScreenMode: true,
        ensureScreenSize: true,
        minTextAdapt: true,
        child: SafeArea(
          top: false,
          child: MaterialApp.router(
            title: 'CalisTracker',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            routerConfig: appRouter,
          ),
        ),
      ),
    );
  }
}
