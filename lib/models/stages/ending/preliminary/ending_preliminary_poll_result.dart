part of 'models.dart';

/// 初赛投票情况
@MappableClass()
final class EndingPreliminaryPollResult
    with EndingPreliminaryPollResultMappable {
  /// Constructor.
  const EndingPreliminaryPollResult({
    required this.groupA,
    required this.groupB,
    required this.groupC,
    required this.groupD,
  });

  /// Build empty instance.
  static const empty = EndingPreliminaryPollResult(
    groupA: [],
    groupB: [],
    groupC: [],
    groupD: [],
  );

  /// Group A
  final List<CharacterPollResult> groupA;

  /// Group B
  final List<CharacterPollResult> groupB;

  /// Group C
  final List<CharacterPollResult> groupC;

  /// Group D
  final List<CharacterPollResult> groupD;
}
