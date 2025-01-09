import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tsdm_converter/constants/tags.dart';

/// 接口返回的投票结果
///
/// Every instance is expected to match a character's poll result.
final class RawPollResult extends Equatable {
  /// Constructor.
  const RawPollResult({
    required this.name,
    required this.bangumi,
    required this.all,
    required this.effective,
    required this.ranking,
  });

  static final _re = RegExp('$kTrHead'
      '$kTdHead($kAlignHead)?$kNotStart($kAlignTail)?$kTdTail'
      '$kTdHead($kAlignHead)?(?<character>$kNotAt)@(?<bangumi>$kNotStart)($kAlignTail)?$kTdTail'
      '$kTdHead($kAlignHead)?(?<all>$kNum)($kAlignTail)?$kTdTail'
      '$kTdHead($kAlignHead)?(?<effective>$kNum)($kAlignTail)?$kTdTail'
      '$kTdHead($kAlignHead)?(?<ranking>$kNum)($kAlignTail)?$kTdTail'
      '$kTrTail');

  /// Parse a result from data.
  static RawPollResult? parse(String data) {
    final match = _re.firstMatch(data);
    if (match == null) {
      debugPrint('data not matched: $data');
      return null;
    }

    final character = match.namedGroup('character')!;
    final bangumi = match.namedGroup('bangumi')!;
    final all = int.parse(match.namedGroup('all')!);
    final effective = int.parse(match.namedGroup('effective')!);
    final ranking = int.parse(match.namedGroup('ranking')!);

    return RawPollResult(
      name: character,
      bangumi: bangumi,
      all: all,
      effective: effective,
      ranking: ranking,
    );
  }

  /// Character name with bangumi name.
  final String name;

  /// Bangumi name.
  final String bangumi;

  /// All counts.
  final int all;

  /// Effective counts.
  final int effective;

  /// Ranking.
  final int ranking;

  @override
  List<Object?> get props => [name, bangumi];
}
