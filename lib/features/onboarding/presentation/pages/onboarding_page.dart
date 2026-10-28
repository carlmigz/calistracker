import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/session/app_session.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.bodyPadding,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  spacing: 12.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(child: PoseImage()),
                    AppText(
                      text:
                          'Your free companion for mastering bodyweight training with CALISTRACKER',
                      fFamily: AppTextStyles.fontFamily,
                      fWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      fSize: 18.sp,
                    ),
                  ],
                ),
              ),
              AppButton(
                onPressed: () =>
                    context.read<AppSession>().completeOnboarding(),
                text: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
