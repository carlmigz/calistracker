import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/features/library/data/library_entries.dart';
import 'package:calistracker/features/library/domain/entities/library_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: AppSizes.bodyPadding,
      children: [
        for (final category in LibraryCategory.values) ...[
          Padding(
            padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
            child: AppText(
              text: category.label,
              fWeight: FontWeight.bold,
              fSize: 18.sp,
            ),
          ),
          for (final entry in libraryEntries.where(
            (e) => e.category == category,
          ))
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: ColoredBox(
                  color: scheme.surfaceContainerHighest,
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: AppText(
                        text: entry.title,
                        fWeight: FontWeight.w600,
                      ),
                      childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [AppText(text: entry.body)],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
