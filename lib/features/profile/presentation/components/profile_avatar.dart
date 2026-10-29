import 'package:calistracker/core/components/pose_image.dart';
import 'package:flutter/material.dart';

/// Round avatar on a colored background.
///
/// Library avatars (`assets/icons/avatar_*.png`) are already cropped circles,
/// so they are shown whole inside a ring of [color]. Any other asset, or the
/// default mascot, is a full-body pose cropped to the face on [color].
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    required this.color,
    this.asset,
  });

  static const libraryPrefix = 'assets/icons/avatar_';

  final double size;
  final Color color;
  final String? asset;

  bool get _isLibraryAvatar => asset?.startsWith(libraryPrefix) ?? false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      padding: _isLibraryAvatar ? EdgeInsets.all(size * 0.05) : null,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: ClipOval(
        child: _isLibraryAvatar
            ? Image.asset(asset!, fit: BoxFit.cover)
            : Transform.scale(
                scale: 1.9,
                alignment: const Alignment(0, -0.85),
                child: PoseImage(asset: asset),
              ),
      ),
    );
  }
}
