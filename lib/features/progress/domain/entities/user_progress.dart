import 'package:calistracker/features/progress/domain/entities/completion.dart';
import 'package:equatable/equatable.dart';

class UserProgress extends Equatable {
  const UserProgress([this.completions = const []]);

  final List<Completion> completions;

  Set<String> get completedIds => {for (final c in completions) c.exerciseId};

  List<Completion> get _dated =>
      completions.where((c) => c.hasKnownDate).toList();

  /// Midnight of [date], shifted by [offsetDays].
  static DateTime dayOf(DateTime date, [int offsetDays = 0]) =>
      DateTime(date.year, date.month, date.day + offsetDays);

  /// Consecutive days with a completion, ending today (or yesterday, so the
  /// streak isn't lost before the user has trained today).
  int currentStreak(DateTime now) {
    final days = {for (final c in _dated) dayOf(c.completedAt)};
    var day = dayOf(now);
    if (!days.contains(day)) day = dayOf(now, -1);

    var streak = 0;
    while (days.contains(day)) {
      streak++;
      day = dayOf(day, -1);
    }
    return streak;
  }

  /// Longest run of consecutive days with a completion, ever.
  int get longestStreak {
    final days = {for (final c in _dated) dayOf(c.completedAt)}.toList()
      ..sort();

    var longest = 0;
    var run = 0;
    DateTime? previous;
    for (final day in days) {
      run = previous != null && dayOf(previous, 1) == day ? run + 1 : 1;
      if (run > longest) longest = run;
      previous = day;
    }
    return longest;
  }

  /// Completion counts for the last 7 days, oldest first (last entry = today).
  List<int> activityLast7Days(DateTime now) {
    final counts = <DateTime, int>{};
    for (final c in _dated) {
      counts.update(dayOf(c.completedAt), (n) => n + 1, ifAbsent: () => 1);
    }
    return [for (var i = 6; i >= 0; i--) counts[dayOf(now, -i)] ?? 0];
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
