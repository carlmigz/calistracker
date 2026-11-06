import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Welcome screen: a Create Account button, with a Sign In link as footer.
class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final signInTap = useMemoized(() => TapGestureRecognizer());
    useEffect(() => signInTap.dispose, [signInTap]);
    signInTap.onTap = () => context.push(AppRoutes.signIn);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: AppSizes.bodyPadding,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 0.55.sh),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PoseImage(height: 200.h),
                            SizedBox(height: 24.h),
                            AppText(
                              text: AppStrings.loginWelcomeTitle,
                              fFamily: AppTextStyles.headingFontFamily,
                              fSize: 26.sp,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.h),
                            AppText(
                              text: AppStrings.loginWelcomeSubtitle,
                              fSize: 13.sp,
                              textColor: scheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppButton(
                    height: 50.h,
                    text: AppStrings.loginCreateAccount,
                    onPressed: () => context.push(AppRoutes.signUp),
                  ),
                  SizedBox(height: 16.h),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                      children: [
                        const TextSpan(text: AppStrings.loginAlreadyMember),
                        TextSpan(
                          text: AppStrings.loginSignIn,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: signInTap,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
