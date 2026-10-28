import 'package:calistracker/core/components/app_toast.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/session/app_session.dart';
import 'package:calistracker/features/auth/presentation/components/login_form.dart';
import 'package:calistracker/features/auth/presentation/components/login_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Local stub: marks the session as logged in.
class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    Future<void> submit() async {
      FocusScope.of(context).unfocus();

      isLoading.value = true;
      await context.read<AppSession>().logIn();
      if (context.mounted) isLoading.value = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: AppSizes.bodyPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(),
                  SizedBox(height: 28.h),
                  LoginForm(
                    isLoading: isLoading.value,
                    onSubmit: submit,
                    onForgotPassword: () => showAppToast(
                      context,
                      AppStrings.loginPasswordResetSoon,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
