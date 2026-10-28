import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/app_textfield.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends HookWidget {
  const LoginForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final passwordFocus = useFocusNode();

    return Form(
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: email,
              kType: TextInputType.emailAddress,
              hintText: AppStrings.loginEmail,
              prefixIcon: Icons.mail_outline,
              onFieldSubmitted: (_) => passwordFocus.requestFocus(),
            ),
            SizedBox(height: 12.h),
            AppTextField(
              controller: password,
              fNode: passwordFocus,
              kType: TextInputType.visiblePassword,
              obscureText: true,
              hintText: AppStrings.loginPassword,
              prefixIcon: Icons.lock_outline,
              onFieldSubmitted: (_) => onSubmit(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onForgotPassword,
                child: AppText(
                  text: AppStrings.loginForgotPassword,
                  fSize: 12.sp,
                  fWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            AppButton(
              onPressed: onSubmit,
              text: AppStrings.loginSignIn,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
