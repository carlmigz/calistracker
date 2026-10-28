import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showAppToast(
  BuildContext context,
  String title, {
  String? description,
  ToastificationType type = ToastificationType.info,
}) {
  toastification.show(
    context: context,
    type: type,
    title: Text(title),
    description: description == null ? null : Text(description),
    autoCloseDuration: const Duration(seconds: 3),
  );
}
