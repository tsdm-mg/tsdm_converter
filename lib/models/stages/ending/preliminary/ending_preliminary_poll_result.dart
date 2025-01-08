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
    groupA: {},
    groupB: {},
    groupC: {},
    groupD: {},
  );

  /// Group A
  final Set<CharacterPollResult> groupA;

  /// Group B
  final Set<CharacterPollResult> groupB;

  /// Group C
  final Set<CharacterPollResult> groupC;

  /// Group D
  final Set<CharacterPollResult> groupD;
}
