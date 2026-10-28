import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/features/library/domain/entities/library_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LibraryEntryTile extends StatelessWidget {
  const LibraryEntryTile({super.key, required this.entry});

  final LibraryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: AppCard(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: AppText(text: entry.title, fWeight: FontWeight.w600),
            childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [AppText(text: entry.body)],
          ),
        ),
      ),
    );
  }
}
