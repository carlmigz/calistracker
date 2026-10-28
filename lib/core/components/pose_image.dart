import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shows the yellow guy in the given pose, falling back to the default mascot.
class PoseImage extends StatelessWidget {
  const PoseImage({super.key, this.asset, this.height});

  static const fallbackAsset = 'assets/images/splash_yellow_guy.png';

  final String? asset;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final path = asset ?? fallbackAsset;

    if (path.endsWith('.svg')) {
      return SvgPicture.asset(path, height: height);
    }
    return Image.asset(
      path,
      height: height,
      errorBuilder: (_, _, _) => Image.asset(fallbackAsset, height: height),
    );
  }
}
