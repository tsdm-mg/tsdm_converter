part of 'models.dart';

/// 决赛排位赛第二场晋级结果
@MappableClass()
final class EndingQualifyingSecondPromoteResult
    with EndingQualifyingSecondPromoteResultMappable {
  /// Constructor.
  const EndingQualifyingSecondPromoteResult({
    required this.groupName,
    required this.pinnedThe3rd,
    required this.pinnedThe4th,
    required this.pinnedThe5th,
  });

  /// 分组名
  final String groupName;

  /// 季军
  final CharacterPollResult pinnedThe3rd;

  /// 殿军
  final CharacterPollResult pinnedThe4th;

  /// 第五
  final CharacterPollResult pinnedThe5th;
}
