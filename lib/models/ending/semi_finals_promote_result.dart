part of 'models.dart';

/// 完结篇 半决赛晋级结果
///
/// 仅包含半决赛
@MappableClass()
final class EndingSemiFinalsPromoteResult
    with EndingSemiFinalsPromoteResultMappable {
  /// Constructor.
  const EndingSemiFinalsPromoteResult({
    required this.groupName,
    required this.promoteFinals,
    required this.promoteQualifyingSecond,
  });

  /// 分组名
  final String groupName;

  /// 晋级决赛
  final CharacterPollResult promoteFinals;

  /// 晋级排位赛第二场
  final CharacterPollResult promoteQualifyingSecond;
}
