import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgramGroupHeader extends StatelessWidget {
  const ProgramGroupHeader({
    super.key,
    required this.program,
    required this.done,
  });

  final Program program;
  final int done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 16.h, 2.w, 8.h),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              text: program.name.replaceAll(' Progression', ''),
              fFamily: AppTextStyles.fontFamily,
              fWeight: FontWeight.bold,
              fSize: 16.sp,
            ),
          ),
          AppText(
            text: '$done / ${program.exercises.length}',
            fSize: 12.sp,
            fWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
