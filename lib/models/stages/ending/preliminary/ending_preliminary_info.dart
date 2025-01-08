part of 'models.dart';

/// 初赛比赛情况，包括分组情况和投票情况
@MappableClass()
final class EndingPreliminaryInfo with EndingPreliminaryInfoMappable {
  /// Constructor.
  const EndingPreliminaryInfo({
    required this.groups,
    required this.polls,
  });

  /// Build empty instance.
  static const empty = EndingPreliminaryInfo(
    groups: EndingPreliminaryGroups.empty,
    polls: EndingPreliminaryPollResult.empty,
  );

  /// 初赛分组情况
  final EndingPreliminaryGroups groups;

  /// 初赛投票情况
  final EndingPreliminaryPollResult polls;
}
