part of 'models.dart';

/// 初赛分组
@MappableClass()
final class EndingPreliminaryGroups with EndingPreliminaryGroupsMappable {
  /// Constructor.
  const EndingPreliminaryGroups({
    required this.groupA,
    required this.groupB,
    required this.groupC,
    required this.groupD,
  });

  /// A组
  final Set<Character> groupA;

  /// B组
  final Set<Character> groupB;

  /// C组
  final Set<Character> groupC;

  /// D组
  final Set<Character> groupD;
}
