import 'package:calistracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Asks for a new display name; resolves to null when cancelled.
Future<String?> showEditNameDialog(BuildContext context, String name) =>
    showDialog<String>(
      context: context,
      builder: (_) => _EditNameDialog(name: name),
    );

/// Owns its controller so it is disposed together with the dialog, not while
/// the dialog's closing animation is still running.
class _EditNameDialog extends HookWidget {
  const _EditNameDialog({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: name);

    return AlertDialog(
      title: const Text(AppStrings.profileYourName),
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
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text(AppStrings.save),
        ),
      ],
    );
  }
}
