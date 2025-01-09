part of 'models.dart';

/// 完结篇四分之一决赛小组晋级结果
///
/// 一个分组中的晋级结果
@MappableClass()
final class EndingQuarterPromoteResult with EndingQuarterPromoteResultMappable {
  /// Constructor.
  const EndingQuarterPromoteResult({
    required this.groupName,
    required this.promoteSemiFinals,
    required this.promoteQualifyingFirst,
    required this.pinnedThe9th,
  });

  /// 分组名
  final String groupName;

  /// 晋级半决赛
  final CharacterPollResult promoteSemiFinals;

  /// 晋级排位赛第一场
  final CharacterPollResult promoteQualifyingFirst;

  /// 最终成绩第九名
  final CharacterPollResult pinnedThe9th;
}
