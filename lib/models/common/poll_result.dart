import 'package:collection/collection.dart';
import 'package:tsdm_converter/models/common/character.dart';
import 'package:tsdm_converter/models/raw/raw_poll_result.dart';

/// Poll result for a given [character].
final class CharacterPollResult {
  /// Constructor.
  const CharacterPollResult({
    required this.character,
    required this.all,
    required this.effective,
    required this.ranking,
  });

  /// Construct from a raw poll result.
  factory CharacterPollResult.fromRaw(RawPollResult raw) => CharacterPollResult(
        character: Character(
          name: raw.character,
          bangumi: raw.bangumi,
        ),
        all: raw.all,
        effective: raw.effective,
        ranking: raw.ranking,
      );

  /// Character vote for.
  final Character character;

  /// All counts.
  final int all;

  /// All effective counts.
  final int effective;

  /// Ranking.
  final int ranking;

  /// Convert to bbcode.
  String toBBCode() =>
      '[td]$ranking[/td][td]$character[/td][td]$all[/td][td]$effective[/td][/tr]';
}

/// Poll result on a bangumi.
final class BangumiPollResult {
  /// Constructor.
  const BangumiPollResult({
    required this.name,
    required this.characters,
  });

  /// Build from a set of character poll results.
  ///
  /// The caller MUST ensure all character in [characters] have the same
  /// bangumi name.
  factory BangumiPollResult.fromSet(Set<CharacterPollResult> characters) {
    assert(
      characters.isNotEmpty,
      'should NOT build a bangumi poll result from empty character groups',
    );

    return BangumiPollResult(
      name: characters.first.character.bangumi,
      characters: characters.map((e) => e.character).toSet(),
    );
  }

  /// Name of bangumi.
  final String name;

  /// All characters in current bangumi.
  final Set<Character> characters;

  /// Convert to report.
  String toReport() => '[td]$name[/td][td]${characters.length}[/td][/tr]';
}

/// Extension on set of `BangumiPollResult`.
extension IterOfBangumiPollResultExt on Iterable<BangumiPollResult> {
  /// Sort by characters count.
  Iterable<BangumiPollResult> sortByCharacters() =>
      sortedByCompare((e) => e.characters, (k1, k2) {
        final l1 = k1.length;
        final l2 = k2.length;
        if (l1 < l2) {
          return 1;
        }

        if (l1 > l2) {
          return -1;
        }

        return 0;
      });
}
