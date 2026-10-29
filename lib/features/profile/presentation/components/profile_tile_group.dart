import 'package:calistracker/core/components/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One row of the profile menu.
class ProfileTile {
  const ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.destructive = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool destructive;
  final bool showChevron;
}

/// Titled card holding a list of [ProfileTile]s separated by dividers.
class ProfileTileGroup extends StatelessWidget {
  const ProfileTileGroup({super.key, required this.tiles});

  final List<ProfileTile> tiles;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0)
              Divider(height: 1, indent: 64.w, color: scheme.outlineVariant),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
              leading: CircleAvatar(
                radius: 18.r,
                backgroundColor: tiles[i].destructive
                    ? scheme.error.withValues(alpha: 0.15)
                    : scheme.primary,
                foregroundColor: tiles[i].destructive
                    ? scheme.error
                    : scheme.onPrimary,
                child: Icon(tiles[i].icon, size: 18.r),
              ),
              title: Text(
                tiles[i].title,
                style: tiles[i].destructive
                    ? TextStyle(color: scheme.error)
                    : null,
              ),
              subtitle: tiles[i].subtitle == null
                  ? null
                  : Text(tiles[i].subtitle!),
              trailing: tiles[i].showChevron
                  ? const Icon(Icons.chevron_right_rounded)
                  : null,
              onTap: tiles[i].onTap,
            ),
          ],
        ],
      ),
    );
  }
}
