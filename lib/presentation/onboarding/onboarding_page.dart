import 'package:calistracker/common/components/widget_button.dart';
import 'package:calistracker/common/const/sizes.dart';
import 'package:calistracker/common/components/widget_text.dart';
import 'package:calistracker/presentation/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void _handleContinue() {
    Get.to(() => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: Sizes.bodyPadding,
        child: WidgetButton(onPressed: _handleContinue, text: 'Continue'),
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
