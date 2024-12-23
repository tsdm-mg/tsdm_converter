part of 'models.dart';

/// Character with [name] and [bangumi] where came from.
@MappableClass()
final class Character extends Equatable with CharacterMappable {
  /// Constructor.
  const Character({
    required this.name,
    required this.bangumi,
    required this.promoteStatus,
  });

  /// Build a character from raw poll data.
  factory Character.fromRawPoll({
    required String name,
    required String bangumi,
  }) =>
      Character(
        name: name,
        bangumi: bangumi,
        promoteStatus: PromoteStatus.empty(),
      );

  /// Character name.
  final String name;

  /// Work came from
  ///
  /// It is expected to not contains any special chars chat need to be escaped.
  final String bangumi;

  /// Promotion history.
  final PromoteStatus promoteStatus;

  @override
  String toString() => '$name@$bangumi';

  @override
  List<Object?> get props => [name, bangumi];
}
