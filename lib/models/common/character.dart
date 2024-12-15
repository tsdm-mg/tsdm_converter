import 'package:equatable/equatable.dart';

/// Character with [name] and [bangumi] where came from.
final class Character extends Equatable {
  /// Constructor.
  const Character({
    required this.name,
    required this.bangumi,
  });

  /// Character name.
  final String name;

  /// Work came from
  ///
  /// It is expected to not contains any special chars chat need to be escaped.
  final String bangumi;

  @override
  String toString() => '$name@$bangumi';

  @override
  List<Object?> get props => [name, bangumi];
}
