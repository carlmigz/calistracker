import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

/// Full-screen detail page for one profile list tile. [builder] runs inside the
/// page, so anything it watches rebuilds the page.
class ProfileSectionPage extends StatelessWidget {
  const ProfileSectionPage({
    super.key,
    required this.title,
    required this.builder,
  });

  final String title;
  final WidgetBuilder builder;

  /// Opens a section above the tab bar.
  static Future<void> open(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => ProfileSectionPage(title: title, builder: builder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: AppSizes.bodyPadding,
        children: [Builder(builder: builder)],
      ),
    );
  }
}
