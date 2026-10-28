import 'package:calistracker/features/progress/domain/entities/completion.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProgressLocalDataSource {
  List<Completion> getCompletions();
  Future<List<Completion>> addCompletion(String exerciseId, DateTime at);
  Future<List<Completion>> clear();
}

/// Stores completions as `exerciseId|epochMillis` strings.
class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  const ProgressLocalDataSourceImpl(this._prefs);

  static const _completionsKey = 'completions';

  /// Old format: a plain list of completed exercise ids, without dates.
  static const _legacyKey = 'completed_exercises';

  final SharedPreferences _prefs;

  @override
  List<Completion> getCompletions() {
    final completions = <Completion>[];

    for (final raw in _prefs.getStringList(_completionsKey) ?? const []) {
      final separator = raw.lastIndexOf('|');
      final millis = int.tryParse(raw.substring(separator + 1));
      if (separator <= 0 || millis == null) continue;
      completions.add(
        Completion(
          exerciseId: raw.substring(0, separator),
          completedAt: DateTime.fromMillisecondsSinceEpoch(millis),
        ),
      );
    }

    final known = {for (final c in completions) c.exerciseId};
    for (final id in _prefs.getStringList(_legacyKey) ?? const <String>[]) {
      if (known.add(id)) {
        completions.add(
          Completion(
            exerciseId: id,
            completedAt: DateTime.fromMillisecondsSinceEpoch(0),
          ),
        );
      }
    }

    return completions;
  }

  @override
  Future<List<Completion>> addCompletion(String exerciseId, DateTime at) async {
    final completions = getCompletions()
      ..add(Completion(exerciseId: exerciseId, completedAt: at));

    await _prefs.setStringList(_completionsKey, [
      for (final c in completions)
        '${c.exerciseId}|${c.completedAt.millisecondsSinceEpoch}',
    ]);
    await _prefs.remove(_legacyKey);
    return completions;
  }

  @override
  Future<List<Completion>> clear() async {
    await _prefs.remove(_completionsKey);
    await _prefs.remove(_legacyKey);
    return const [];
  }
}
