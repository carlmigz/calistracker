import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:calistracker/features/profile/presentation/components/avatar_color_picker.dart';
import 'package:calistracker/features/profile/presentation/components/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Edits the display name, avatar pose and avatar color. Changes are kept in
/// local state with a live preview and only saved on "Save".
class EditProfilePage extends HookWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.read<SettingsCubit>().state;
    final name = useTextEditingController(text: current.displayName);
    final colorIndex = useState(current.avatarColorIndex);
    final asset = useState(current.avatarAsset);
    final scheme = Theme.of(context).colorScheme;
    final color = SettingsState.avatarColors[colorIndex.value];

    Future<void> save() async {
      final cubit = context.read<SettingsCubit>();
      final router = GoRouter.of(context);
      await cubit.setDisplayName(name.text);
      await cubit.setAvatarColorIndex(colorIndex.value);
      await cubit.setAvatarAsset(asset.value);
      router.pop();
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profileEditTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppSizes.bodyPadding,
                children: [
                  Center(
                    child: ProfileAvatar(
                      size: 120.r,
                      color: color,
                      asset: asset.value.isEmpty ? null : asset.value,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: name,
                    maxLength: 20,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: AppStrings.profileDisplayName,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  AppText(
                    text: AppStrings.profileAvatar,
                    fWeight: FontWeight.bold,
                    fSize: 16.sp,
                  ),
                  SizedBox(height: 10.h),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    children: [
                      for (final option in SettingsState.avatarAssets)
                        GestureDetector(
                          onTap: () => asset.value = option,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: option == asset.value
                                    ? scheme.onSurface
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.r),
                              child: LayoutBuilder(
                                builder: (context, box) => ProfileAvatar(
                                  size: box.maxWidth,
                                  color: color,
                                  asset: option.isEmpty ? null : option,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  AvatarColorPicker(
                    selected: colorIndex.value,
                    onSelected: (i) => colorIndex.value = i,
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.bodyPadding,
              child: AppButton(
                text: AppStrings.save,
                icon: Icons.check,
                onPressed: save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
