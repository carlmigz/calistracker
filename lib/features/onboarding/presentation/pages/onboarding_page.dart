import 'package:calistracker/core/components/widget_button.dart';
import 'package:calistracker/core/constants/sizes.dart';
import 'package:calistracker/core/components/widget_text.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void _handleContinue(BuildContext context) {
    context.push(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: Sizes.bodyPadding,
        child: WidgetButton(onPressed: () => _handleContinue(context), text: 'Continue'),
      ),
      body: Padding(
        padding: Sizes.bodyPadding,
        child: Column(
          spacing: 4.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash_yellow_guy.png'),
            WidgetText(
              text:
                  'Your Free Companion For Mastering Bodyweight Training With CALISTRACKER',
              fWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              fSize: 18.sp,
              textColor: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
