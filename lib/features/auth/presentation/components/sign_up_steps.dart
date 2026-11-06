import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/app_textfield.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/helpers/validators.dart';
import 'package:calistracker/features/auth/domain/entities/account_profile.dart';
import 'package:calistracker/features/auth/presentation/components/measure_input.dart';
import 'package:calistracker/features/auth/presentation/components/option_tile.dart';
import 'package:calistracker/features/auth/presentation/components/sign_up_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Everything the user picks while signing up (the account fields live in
/// text controllers on the page).
class SignUpDraft {
  const SignUpDraft({
    this.gender,
    this.age = 25,
    this.heightCm = 170,
    this.weightKg = 70,
    this.heightUnit = HeightUnit.cm,
    this.weightUnit = WeightUnit.kg,
    this.goals = const {},
    this.experience = ExperienceLevel.newbie,
    this.daysPerWeek = 3,
  });

  final Gender? gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final HeightUnit heightUnit;
  final WeightUnit weightUnit;
  final Set<FitnessGoal> goals;
  final ExperienceLevel experience;
  final int daysPerWeek;

  SignUpDraft copyWith({
    Gender? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    HeightUnit? heightUnit,
    WeightUnit? weightUnit,
    Set<FitnessGoal>? goals,
    ExperienceLevel? experience,
    int? daysPerWeek,
  }) {
    return SignUpDraft(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      heightUnit: heightUnit ?? this.heightUnit,
      weightUnit: weightUnit ?? this.weightUnit,
      goals: goals ?? this.goals,
      experience: experience ?? this.experience,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(text: title, fSize: 22.sp, fWeight: FontWeight.w700),
        SizedBox(height: 4.h),
        AppText(
          text: subtitle,
          fSize: 13.sp,
          textColor: scheme.onSurface.withValues(alpha: 0.7),
        ),
        SizedBox(height: 20.h),
        ...children,
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 10.h, top: 4.h),
    child: AppText(text: text, fSize: 14.sp, fWeight: FontWeight.w700),
  );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 8.h),
    child: AppText(
      text: text,
      fSize: 12.sp,
      textColor: Theme.of(context).colorScheme.error,
    ),
  );
}

/// Step 1: name, email and password.
class AccountStep extends StatelessWidget {
  const AccountStep({
    super.key,
    required this.formKey,
    required this.name,
    required this.email,
    required this.password,
    required this.confirm,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirm;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: AppStrings.signUpAccountTitle,
      subtitle: AppStrings.signUpAccountSubtitle,
      children: [
        Form(
          key: formKey,
          child: AutofillGroup(
            child: Column(
              children: [
                AppTextField(
                  controller: name,
                  hintText: AppStrings.signUpFirstName,
                  prefixIcon: Icons.person_outline,
                  textCaps: TextCapitalization.words,
                  maxLength: 20,
                  validator: Validators.firstNameValidator,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: email,
                  kType: TextInputType.emailAddress,
                  hintText: AppStrings.loginEmail,
                  prefixIcon: Icons.mail_outline,
                  validator: Validators.emailValidator,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: password,
                  kType: TextInputType.visiblePassword,
                  obscureText: true,
                  hintText: AppStrings.loginPassword,
                  prefixIcon: Icons.lock_outline,
                  validator: Validators.passwordValidator,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: confirm,
                  kType: TextInputType.visiblePassword,
                  obscureText: true,
                  hintText: AppStrings.signUpConfirmPassword,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) =>
                      Validators.confirmPasswordValidator(v, password.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Step 2: gender and age.
class AboutStep extends StatelessWidget {
  const AboutStep({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.showErrors,
  });

  final SignUpDraft draft;
  final ValueChanged<SignUpDraft> onChanged;
  final bool showErrors;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: AppStrings.signUpAboutTitle,
      subtitle: AppStrings.signUpAboutSubtitle,
      children: [
        const _SectionLabel(AppStrings.signUpGender),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 1.35,
          children: [
            for (final e in SignUpOptions.genders.entries)
              OptionTile(
                compact: true,
                label: e.value.label,
                icon: e.value.icon,
                selected: draft.gender == e.key,
                onTap: () => onChanged(draft.copyWith(gender: e.key)),
              ),
          ],
        ),
        if (showErrors && draft.gender == null)
          const _ErrorText(AppStrings.signUpGenderRequired),
        SizedBox(height: 20.h),
        MeasureInput(
          label: AppStrings.signUpAge,
          units: const ['yrs'],
          unitIndex: 0,
          onUnitChanged: (_) {},
          value: draft.age.toDouble(),
          min: 13,
          max: 90,
          onChanged: (v) => onChanged(draft.copyWith(age: v.round())),
        ),
      ],
    );
  }
}

/// Step 3: height (cm / in) and weight (kg / lb).
class BodyStep extends StatelessWidget {
  const BodyStep({super.key, required this.draft, required this.onChanged});

  final SignUpDraft draft;
  final ValueChanged<SignUpDraft> onChanged;

  static String _feetInches(double cm) {
    final totalInches = (cm / AccountProfile.cmPerInch).round();
    return '${totalInches ~/ 12}′ ${totalInches % 12}″';
  }

  @override
  Widget build(BuildContext context) {
    final heightInInches = draft.heightUnit == HeightUnit.inch;
    final weightInLb = draft.weightUnit == WeightUnit.lb;

    return _StepScaffold(
      title: AppStrings.signUpBodyTitle,
      subtitle: AppStrings.signUpBodySubtitle,
      children: [
        MeasureInput(
          label: AppStrings.signUpHeight,
          units: const ['cm', 'in'],
          unitIndex: draft.heightUnit.index,
          onUnitChanged: (i) =>
              onChanged(draft.copyWith(heightUnit: HeightUnit.values[i])),
          value: heightInInches
              ? draft.heightCm / AccountProfile.cmPerInch
              : draft.heightCm,
          min: heightInInches ? 47 : 120,
          max: heightInInches ? 91 : 230,
          caption: _feetInches(draft.heightCm),
          onChanged: (v) => onChanged(
            draft.copyWith(
              heightCm: heightInInches ? v * AccountProfile.cmPerInch : v,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        MeasureInput(
          label: AppStrings.signUpWeight,
          units: const ['kg', 'lb'],
          unitIndex: draft.weightUnit.index,
          onUnitChanged: (i) =>
              onChanged(draft.copyWith(weightUnit: WeightUnit.values[i])),
          value: weightInLb
              ? draft.weightKg * AccountProfile.lbPerKg
              : draft.weightKg,
          min: weightInLb ? 66 : 30,
          max: weightInLb ? 440 : 200,
          caption: weightInLb
              ? '${draft.weightKg.round()} kg'
              : '${(draft.weightKg * AccountProfile.lbPerKg).round()} lb',
          onChanged: (v) => onChanged(
            draft.copyWith(
              weightKg: weightInLb ? v / AccountProfile.lbPerKg : v,
            ),
          ),
        ),
      ],
    );
  }
}

/// Step 4: goals, experience and weekly training days.
class GoalsStep extends StatelessWidget {
  const GoalsStep({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.showErrors,
  });

  final SignUpDraft draft;
  final ValueChanged<SignUpDraft> onChanged;
  final bool showErrors;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _StepScaffold(
      title: AppStrings.signUpGoalsTitle,
      subtitle: AppStrings.signUpGoalsSubtitle,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 1.35,
          children: [
            for (final e in SignUpOptions.goals.entries)
              OptionTile(
                compact: true,
                label: e.value.label,
                icon: e.value.icon,
                selected: draft.goals.contains(e.key),
                onTap: () {
                  final next = {...draft.goals};
                  if (!next.remove(e.key)) next.add(e.key);
                  onChanged(draft.copyWith(goals: next));
                },
              ),
          ],
        ),
        if (showErrors && draft.goals.isEmpty)
          const _ErrorText(AppStrings.signUpGoalsRequired),
        SizedBox(height: 20.h),
        const _SectionLabel(AppStrings.signUpExperience),
        for (final e in SignUpOptions.experience.entries) ...[
          OptionTile(
            label: e.value.label,
            hint: e.value.hint,
            icon: e.value.icon,
            selected: draft.experience == e.key,
            onTap: () => onChanged(draft.copyWith(experience: e.key)),
          ),
          SizedBox(height: 8.h),
        ],
        SizedBox(height: 12.h),
        const _SectionLabel(AppStrings.signUpDaysPerWeek),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var d = 1; d <= 7; d++)
              Semantics(
                button: true,
                selected: draft.daysPerWeek == d,
                label: '$d days per week',
                child: GestureDetector(
                  onTap: () => onChanged(draft.copyWith(daysPerWeek: d)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 40.r,
                    height: 40.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: draft.daysPerWeek == d
                          ? scheme.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: draft.daysPerWeek == d
                            ? scheme.primary
                            : scheme.onSurface.withValues(alpha: 0.25),
                      ),
                    ),
                    child: AppText(
                      text: '$d',
                      fSize: 14.sp,
                      fWeight: FontWeight.w700,
                      textColor: draft.daysPerWeek == d
                          ? scheme.onPrimary
                          : scheme.onSurface,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
