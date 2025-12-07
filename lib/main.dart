import 'package:calistracker/common/components/widget_bottom_nav.dart';
import 'package:calistracker/common/themes/app_theme.dart';
import 'package:calistracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          child: GetMaterialApp(
            title: 'CalisTracker',
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.cupertino,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const WidgetBottomNav(),
          ),
        ),
      ),
    );
  }
}
