import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/app_textfield.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/session/app_session.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

/// Local stub: validates the form, then marks the session as logged in.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    await context.read<AppSession>().logIn();
    if (mounted) setState(() => _isLoading = false);
  }

  void _forgotPassword() {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      title: const Text('Password reset is coming soon'),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: AppSizes.bodyPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: PoseImage(height: 140.h)),
                      SizedBox(height: 16.h),
                      AppText(
                        text: 'Welcome back',
                        fFamily: AppTextStyles.headingFontFamily,
                        fSize: 24.sp,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      AppText(
                        text: 'Sign in to continue your training',
                        fSize: 13.sp,
                        textColor: scheme.onSurface.withValues(alpha: 0.7),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 28.h),
                      AppTextField(
                        controller: _emailController,
                        kType: TextInputType.emailAddress,
                        hintText: 'Email',
                        prefixIcon: Icons.mail_outline,
                        onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _passwordController,
                        fNode: _passwordFocus,
                        kType: TextInputType.visiblePassword,
                        obscureText: true,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _forgotPassword,
                          child: AppText(
                            text: 'Forgot password?',
                            fSize: 12.sp,
                            fWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      AppButton(
                        onPressed: _submit,
                        text: 'Sign In',
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
