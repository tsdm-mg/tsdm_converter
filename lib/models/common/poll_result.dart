part of 'models.dart';

/// Poll result for a given [name].
@MappableClass()
final class CharacterPollResult with CharacterPollResultMappable {
  /// Constructor.
  const CharacterPollResult({
    required this.name,
    required this.bangumi,
    required this.all,
    required this.effective,
    required this.ranking,
  });

  /// Construct from a raw poll result.
  factory CharacterPollResult.fromRaw(RawPollResult raw) => CharacterPollResult(
        name: raw.name,
        bangumi: raw.bangumi,
        all: raw.all,
        effective: raw.effective,
        ranking: '${raw.ranking}',
      );

  /// Character vote for.
  final String name;

  /// Bangumi came from.
  final String bangumi;

  /// All counts.
  final int all;

  /// All effective counts.
  final int effective;

  /// Ranking.
  final String ranking;

  /// Convert to bbcode.
  String toBBCode() =>
      '[td]$ranking[/td][td]$name@$bangumi[/td][td]$all[/td][td]$effective[/td][/tr]';
}

/// Extension of iterable poll result.
extension IterOfCharacterPollResultExt on Iterable<CharacterPollResult> {
  /// Sort by characters count.
  Iterable<CharacterPollResult> sortedByEffective() =>
      sortedByCompare((e) => e.effective, (e1, e2) {
        if (e1 < e2) {
          return 1;
        }
        if (e1 > e2) {
          return -1;
        }

        return 0;
      });
}

/// Poll result on a bangumi.
@MappableClass()
final class BangumiPollResult with BangumiPollResultMappable {
  /// Constructor.
  const BangumiPollResult({
    required this.name,
    required this.characters,
    required this.effective,
    required this.all,
    this.promotedCount = 0,
  }) : charactersCount = characters.length;

  /// Build from a set of character poll results.
  ///
  /// The caller MUST ensure all character in [characters] have the same
  /// bangumi name.
  factory BangumiPollResult.fromList(List<CharacterPollResult> characters) {
    assert(
      characters.isNotEmpty,
      'should NOT build a bangumi poll result from empty character groups',
    );

    return BangumiPollResult(
      name: characters.first.bangumi,
      characters: characters
          .map(
            (e) => Character(
              name: e.name,
              bangumi: e.bangumi,
              promoteStatus: PromoteStatus.empty(),
            ),
          )
          .toSet(),
      effective: characters.fold(0, (acc, e) => acc + e.effective),
      all: characters.fold(0, (acc, e) => acc + e.all),
    );
  }

  /// Name of bangumi.
  final String name;

  /// All characters in current bangumi.
  final Set<Character> characters;

  /// All characters count.
  final int charactersCount;

  /// 晋级的角色数
  ///
  /// 严格来说这个字段不代表晋级，只是为了存放流向某一个下一阶段的角色的数量，比如晋级到
  /// 决赛的角色数，晋级到排位赛第一场的角色数，直接获得并列第九名的角色数。
  ///
  /// 这个字段默认的0，然后，在需要用它展示数据的时候，用`calculateBangumiPromoteCount`把
  /// 一个完整的结果导入到这里面。
  final int promotedCount;

  /// 有效票数
  final int effective;

  /// 总票数
  final int all;

  /// Convert to report.
  String toReport() => '[td]$name[/td]'
      '[td]$promotedCount[color=#c0c0c0]/${characters.length}[/color][/td]'
      '[/tr]';
}

/// Extension on set of `BangumiPollResult`.
extension IterOfBangumiPollResultExt on Iterable<BangumiPollResult> {
  /// Sort by characters count.
  Iterable<BangumiPollResult> sortByCharacters() =>
      sortedByCompare((e) => (c: e.characters, p: e.promotedCount), (k1, k2) {
        // l1 == l2
        // 开始比较晋级的角色数，同样是多的在前面
        final p1 = k1.p;
        final p2 = k2.p;
        if (p1 < p2) {
          return 1;
        }
        if (p1 > p2) {
          return -1;
        }

        // 晋级的角色数相同，比较总角色数

        final l1 = k1.c.length;
        final l2 = k2.c.length;
        if (l1 < l2) {
          return 1;
        }

        if (l1 > l2) {
          return -1;
        }

        // 晋级的角色数和总角色数都相同
        return 0;
      });
}
