import 'package:calistracker/core/components/pose_image.dart';
import 'package:flutter/material.dart';

/// Round avatar: a pose (or the default mascot) cropped to the face on a
/// colored background.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    required this.color,
    this.asset,
  });

  final double size;
  final Color color;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: ClipOval(
        child: Transform.scale(
          scale: 1.9,
          alignment: const Alignment(0, -0.85),
          child: PoseImage(asset: asset),
        ),
      ),
    );
  }
}
