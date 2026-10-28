import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/core/components/widget_button.dart';
import 'package:calistracker/core/components/widget_text.dart';
import 'package:calistracker/core/components/widget_textfield.dart';
import 'package:calistracker/core/constants/sizes.dart';
import 'package:calistracker/core/helpers/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: Sizes.bodyPadding,
        child: Column(
          spacing: 8.h,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetButton(
              onPressed: () {
                context.go(AppRoutes.home);
              },
              text: 'Sign In',
            ),
            WidgetText(text: 'Forgot Password?', textUnderline: true),
          ],
        ),
      ),
      body: Padding(
        padding: Sizes.bodyPadding,
        child: Column(
          spacing: 8.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/app_icon.png', height: 100.h),
            WidgetTextField(
              controller: null,
              hintText: 'Email',
              validator: Validators.emailValidator,
            ),
            WidgetTextField(
              controller: null,
              kType: TextInputType.visiblePassword,
              obscureText: true,
              hintText: 'Password',
              validator: Validators.passwordValidator,
            ),
          ],
        ),
      ),
    );
  }
}
