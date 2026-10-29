/// Rank based on how many distinct exercises have been completed.
class UserLevel {
  const UserLevel({
    required this.name,
    required this.completed,
    required this.nextName,
    required this.nextAt,
    required this.startAt,
  });

  static const _tiers = [
    (name: 'Beginner', at: 0),
    (name: 'Novice', at: 4),
    (name: 'Trained', at: 10),
    (name: 'Athlete', at: 16),
  ];

  static List<({String name, int at})> get tiers => _tiers;

  factory UserLevel.forCompleted(int completed) {
    var index = 0;
    for (var i = 0; i < _tiers.length; i++) {
      if (completed >= _tiers[i].at) index = i;
    }
    final hasNext = index + 1 < _tiers.length;
    return UserLevel(
      name: _tiers[index].name,
      completed: completed,
      startAt: _tiers[index].at,
      nextName: hasNext ? _tiers[index + 1].name : null,
      nextAt: hasNext ? _tiers[index + 1].at : null,
    );
  }

  final String name;
  final int completed;
  final int startAt;
  final String? nextName;
  final int? nextAt;

  bool get isMax => nextAt == null;

  int get remaining => isMax ? 0 : nextAt! - completed;

  /// Progress through the current tier, 0..1.
  double get progress =>
      isMax ? 1 : (completed - startAt) / (nextAt! - startAt);
}
