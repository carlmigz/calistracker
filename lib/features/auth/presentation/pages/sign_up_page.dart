import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/session/app_session.dart';
import 'package:calistracker/features/auth/domain/entities/account_profile.dart';
import 'package:calistracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:calistracker/features/auth/presentation/components/sign_up_steps.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Four-step sign up: account, about you, body stats, goals.
/// Local stub: nothing leaves the device and the password is not stored.
class SignUpPage extends HookWidget {
  const SignUpPage({super.key});

  static const _stepCount = 4;

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final name = useTextEditingController();
    final email = useTextEditingController();
    final password = useTextEditingController();
    final confirm = useTextEditingController();
    final step = useState(0);
    final draft = useState(const SignUpDraft());
    final showErrors = useState(false);
    final saving = useState(false);
    final scheme = Theme.of(context).colorScheme;

    bool stepIsValid() {
      switch (step.value) {
        case 0:
          return formKey.currentState?.validate() ?? false;
        case 1:
          return draft.value.gender != null;
        case 3:
          return draft.value.goals.isNotEmpty;
        default:
          return true;
      }
    }

    Future<void> finish() async {
      final settings = context.read<SettingsCubit>();
      final auth = context.read<AuthRepository>();
      final session = context.read<AppSession>();
      final d = draft.value;

      saving.value = true;
      await settings.setDisplayName(name.text);
      await settings.setWeeklyGoal(d.daysPerWeek);
      await auth.saveProfile(
        AccountProfile(
          email: email.text.trim(),
          gender: d.gender!,
          age: d.age,
          heightCm: d.heightCm,
          weightKg: d.weightKg,
          heightUnit: d.heightUnit,
          weightUnit: d.weightUnit,
          goals: d.goals,
          experience: d.experience,
          daysPerWeek: d.daysPerWeek,
        ),
      );
      // The router redirects to home once the session is logged in.
      await session.logIn();
      if (context.mounted) saving.value = false;
    }

    void next() {
      FocusScope.of(context).unfocus();
      if (!stepIsValid()) {
        showErrors.value = true;
        return;
      }
      showErrors.value = false;
      if (step.value == _stepCount - 1) {
        finish();
      } else {
        step.value++;
      }
    }

    void back() {
      FocusScope.of(context).unfocus();
      showErrors.value = false;
      step.value--;
    }

    final steps = [
      AccountStep(
        formKey: formKey,
        name: name,
        email: email,
        password: password,
        confirm: confirm,
      ),
      AboutStep(
        draft: draft.value,
        onChanged: (v) => draft.value = v,
        showErrors: showErrors.value,
      ),
      BodyStep(draft: draft.value, onChanged: (v) => draft.value = v),
      GoalsStep(
        draft: draft.value,
        onChanged: (v) => draft.value = v,
        showErrors: showErrors.value,
      ),
    ];
    final isLast = step.value == _stepCount - 1;

    return PopScope(
      canPop: step.value == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) back();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.signUpTitle),
          leading: BackButton(
            onPressed: () =>
                step.value == 0 ? Navigator.of(context).maybePop() : back(),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(end: (step.value + 1) / _stepCount),
                            duration: const Duration(milliseconds: 250),
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                                  value: value,
                                  minHeight: 6.h,
                                  color: scheme.primary,
                                  backgroundColor: scheme.onSurface.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        AppText(
                          text: AppStrings.signUpStepCount(
                            step.value + 1,
                            _stepCount,
                          ),
                          fSize: 11.sp,
                          textColor: scheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.all(16.r),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: KeyedSubtree(
                          key: ValueKey(step.value),
                          child: steps[step.value],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                    child: Column(
                      children: [
                        AppButton(
                          height: 50.h,
                          text: isLast
                              ? AppStrings.signUpFinish
                              : AppStrings.signUpNext,
                          icon: isLast ? Icons.check : null,
                          isLoading: saving.value,
                          onPressed: next,
                        ),
                        if (isLast) ...[
                          SizedBox(height: 8.h),
                          AppText(
                            text: AppStrings.signUpPrivacy,
                            fSize: 11.sp,
                            textColor: scheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ],
                      ],
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
