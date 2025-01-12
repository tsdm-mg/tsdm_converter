part of 'models.dart';

/// 排位赛第一场晋级结果
@MappableClass()
final class EndingQualifyingFirstPromoteResult
    with EndingQualifyingFirstPromoteResultMappable {
  /// Constructor.
  const EndingQualifyingFirstPromoteResult({
    required this.groupName,
    required this.promoteQualifyingSecond,
    required this.pinnedThe6Th,
    required this.pinnedThe7Th,
    required this.pinnedThe8Th,
  });

  /// 分组名
  final String groupName;

  /// 晋级排位赛第二场
  final CharacterPollResult promoteQualifyingSecond;

  /// 最终排名第6名
  final CharacterPollResult pinnedThe6Th;

  /// 最终排名第7名
  final CharacterPollResult pinnedThe7Th;

  /// 最终排名第8名
  final CharacterPollResult pinnedThe8Th;
}
