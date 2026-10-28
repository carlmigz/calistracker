import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:calistracker/features/progress/domain/entities/user_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.name, required this.level});

  final String name;
  final UserLevel level;

  Future<void> _editName(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();
    final controller = TextEditingController(text: name);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 20,
          textCapitalization: TextCapitalization.words,
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result != null) cubit.setDisplayName(result);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 112.r,
          height: 112.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primary,
            border: Border.all(color: scheme.primary, width: 3),
          ),
          child: ClipOval(
            child: Transform.scale(
              scale: 1.9,
              alignment: const Alignment(0, -0.85),
              child: const PoseImage(),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: AppText(
                text: name,
                fFamily: AppTextStyles.headingFontFamily,
                fSize: 20.sp,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: 'Edit name',
              onPressed: () => _editName(context),
              icon: const Icon(Icons.edit_outlined, size: 20),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: AppText(
            text: level.name,
            fWeight: FontWeight.w600,
            fSize: 12.sp,
            textColor: scheme.onPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(value: level.progress, minHeight: 8.h),
        ),
        SizedBox(height: 6.h),
        AppText(
          text: level.isMax
              ? 'Top level reached'
              : '${level.remaining} more exercise${level.remaining == 1 ? '' : 's'} to ${level.nextName}',
          fSize: 12.sp,
        ),
      ],
    );
  }
}
