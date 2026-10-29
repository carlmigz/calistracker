import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<bool> _confirm(
  BuildContext context,
  String title,
  String message,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(AppStrings.reset),
        ),
      ],
    ),
  );
  return confirmed == true;
}

Future<void> confirmResetAll(BuildContext context) async {
  final progress = context.read<ProgressBloc>();
  final confirmed = await _confirm(
    context,
    AppStrings.settingsResetProgressTitle,
    AppStrings.settingsResetProgressMessage,
  );
  if (confirmed) progress.add(const ProgressReset());
}

Future<void> confirmResetProgram(BuildContext context, Program program) async {
  final progress = context.read<ProgressBloc>();
  final confirmed = await _confirm(
    context,
    AppStrings.profileResetProgramTitle(program.name),
    AppStrings.profileResetProgramMessage,
  );
  if (confirmed) {
    progress.add(ExercisesReset({for (final e in program.exercises) e.id}));
  }
}

Future<void> copySummary(BuildContext context, String summary) async {
  final messenger = ScaffoldMessenger.of(context);
  await Clipboard.setData(ClipboardData(text: summary));
  messenger.showSnackBar(
    const SnackBar(content: Text(AppStrings.settingsExportDone)),
  );
}
