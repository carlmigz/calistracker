import 'package:calistracker/features/progress/domain/entities/completion.dart';
import 'package:equatable/equatable.dart';

class UserProgress extends Equatable {
  const UserProgress([this.completions = const []]);

  final List<Completion> completions;

  Set<String> get completedIds => {for (final c in completions) c.exerciseId};

  List<Completion> get _dated =>
      completions.where((c) => c.hasKnownDate).toList();

  static DateTime _day(DateTime date, [int offsetDays = 0]) =>
      DateTime(date.year, date.month, date.day + offsetDays);

  /// Consecutive days with a completion, ending today (or yesterday, so the
  /// streak isn't lost before the user has trained today).
  int currentStreak(DateTime now) {
    final days = {for (final c in _dated) _day(c.completedAt)};
    var day = _day(now);
    if (!days.contains(day)) day = _day(now, -1);

    var streak = 0;
    while (days.contains(day)) {
      streak++;
      day = _day(day, -1);
    }
    return streak;
  }

  /// Completion counts for the last 7 days, oldest first (last entry = today).
  List<int> activityLast7Days(DateTime now) {
    final dated = _dated;
    return [
      for (var i = 6; i >= 0; i--)
        dated.where((c) => _day(c.completedAt) == _day(now, -i)).length,
    ];
  }

  /// Newest first.
  List<Completion> recent(int count) {
    final sorted = _dated
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return sorted.take(count).toList();
  }

  @override
  List<Object?> get props => [completions];
}
