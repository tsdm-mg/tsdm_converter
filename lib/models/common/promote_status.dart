part of 'models.dart';

/// 角色的历史晋级情况
///
/// 记录到当前阶段，角色历来每轮中获得的票数，用于在
/// 平票时排序名次
///
/// 各阶段的历史票数优先以近期的票数比较，如果依然
/// 平票，再比较旧的
///
/// Partial order:
///
/// 1. endingSemiFinals & endingQualifyingFirst
/// 2. endingQuarterFinals
/// 3. endingPreliminary
/// 4. seasonFinals
/// 5. seasonRepechage
@MappableClass()
final class PromoteStatus with PromoteStatusMappable {
  /// Constructor.
  const PromoteStatus({
    required this.seasonFinals,
    required this.seasonRepechage,
    required this.endingPreliminary,
    required this.endingQuarterFinals,
    required this.endingSemiFinals,
    required this.endingQualifyingFirst,
    required this.endingFinals,
    required this.endingQualifyingSecond,
  });

  /// Get an empty promotion status.
  factory PromoteStatus.empty() => const PromoteStatus(
        seasonFinals: null,
        seasonRepechage: null,
        endingPreliminary: null,
        endingQuarterFinals: null,
        endingSemiFinals: null,
        endingQualifyingFirst: null,
        endingFinals: null,
        endingQualifyingSecond: null,
      );

  /* Inherited from season stage */

  /// 季节篇决赛票数
  final int? seasonFinals;

  /// 季节篇复活赛票数
  final int? seasonRepechage;

  /* The first round */

  /// 完结篇初赛
  final int? endingPreliminary;

  /* The second round */

  /// 完结篇四分之一决赛
  final int? endingQuarterFinals;

  /* The third round */

  /// 完结篇半决赛
  final int? endingSemiFinals;

  /// 完结篇排位赛第一场
  final int? endingQualifyingFirst;

  /* The fourth round */

  /// 完结篇决赛
  final int? endingFinals;

  /// 完结篇排位赛第二场
  final int? endingQualifyingSecond;
}
