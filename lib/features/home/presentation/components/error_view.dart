import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSizes.bodyPadding,
        child: Column(
          spacing: 12.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: message ?? AppStrings.somethingWentWrong,
              textAlign: TextAlign.center,
            ),
            AppButton(
              width: 160.w,
              text: AppStrings.homeTryAgain,
              onPressed: () =>
                  context.read<ProgramsBloc>().add(const ProgramsRequested()),
            ),
          ],
        ),
      ),
    );
  }
}
