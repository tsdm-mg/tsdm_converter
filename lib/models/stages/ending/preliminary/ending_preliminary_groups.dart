part of 'models.dart';

/// Group name
enum GroupType {
  /// A组
  groupA,

  /// B组
  groupB,

  /// C组
  groupC,

  /// D组
  groupD,
}

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

  /// Build empty instance.
  static const EndingPreliminaryGroups empty = EndingPreliminaryGroups(
    groupA: [],
    groupB: [],
    groupC: [],
    groupD: [],
  );

  /// A组
  final List<Character> groupA;

  /// B组
  final List<Character> groupB;

  /// C组
  final List<Character> groupC;

  /// D组
  final List<Character> groupD;
}
