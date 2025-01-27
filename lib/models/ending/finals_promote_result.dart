part of 'models.dart';

/// 决赛晋级结果
///
/// 只包含决赛
@MappableClass()
final class EndingFinalsPromoteResult with EndingFinalsPromoteResultMappable {
  /// Constructor.
  const EndingFinalsPromoteResult({
    required this.groupName,
    required this.pinnedThe1st,
    required this.pinnedThe2nd,
  });

  /// 分组名
  final String groupName;

  /// 萌王
  final CharacterPollResult pinnedThe1st;

  /// 准萌
  final CharacterPollResult pinnedThe2nd;
}
