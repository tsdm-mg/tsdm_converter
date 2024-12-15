import 'package:equatable/equatable.dart';
import 'package:tsdm_converter/constants/tags.dart';

/// 接口返回的投票结果
///
/// Every instance is expected to match a character's poll result.
final class RawPollResult extends Equatable {
  /// Constructor.
  const RawPollResult({
    required this.character,
    required this.bangumi,
    required this.all,
    required this.effective,
    required this.ranking,
  });

  static final _re = RegExp('$kTrHead'
      '$kTdHead$kNotStart$kTdTail'
      '$kTdHead(?<character>$kNotAt)@(?<bangumi>$kNotStart)$kTdTail'
      '$kTdHead(?<all>$kNum)$kTdTail'
      '$kTdHead(?<effective>$kNum)$kTdTail'
      '$kTdHead(?<ranking>$kNum)$kTdTail'
      '$kTrTail');

  /// Parse a result from data.
  static RawPollResult? parse(String data) {
    final match = _re.firstMatch(data);
    if (match == null) {
      return null;
    }

    final character = match.namedGroup('character')!;
    final bangumi = match.namedGroup('bangumi')!;
    final all = int.parse(match.namedGroup('all')!);
    final effective = int.parse(match.namedGroup('effective')!);
    final ranking = int.parse(match.namedGroup('ranking')!);

    return RawPollResult(
      character: character,
      bangumi: bangumi,
      all: all,
      effective: effective,
      ranking: ranking,
    );
  }

  /// Character name with bangumi name.
  final String character;

  /// Bangumi name.
  final String bangumi;

  /// All counts.
  final int all;

  /// Effective counts.
  final int effective;

  /// Ranking.
  final int ranking;

  @override
  List<Object?> get props => [character, bangumi];
}
