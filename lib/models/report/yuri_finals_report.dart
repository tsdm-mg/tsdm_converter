import 'package:collection/collection.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/base.dart';

/// 百合表演赛 总决赛
final class YuriFinalsReport implements BaseReport {
  /// Constructor.
  const YuriFinalsReport._({
    required this.characters1st,
    required this.characters2nd,
    required this.characters3rd,
    required this.characters4th,
  });

  /// Instance builder.
  factory YuriFinalsReport.build({
    required List<CharacterPollResult> poll,
  }) {
    final characters = poll.sortedByEffective().toList();

    return YuriFinalsReport._(
      characters1st: characters.first,
      characters2nd: characters[1],
      characters3rd: characters[2],
      characters4th: characters[3],
    );
  }

  /// 第一名
  final CharacterPollResult characters1st;

  /// 第二名
  final CharacterPollResult characters2nd;

  /// 第三名
  final CharacterPollResult characters3rd;

  /// 第四名
  final CharacterPollResult characters4th;

  @override
  String toReport() {
    final content = [
      ('冠军', characters1st),
      ('第二名', characters2nd),
      ('第三名', characters3rd),
      ('第四名', characters4th),
    ].mapIndexed((idx, e) =>
        '[tr][td]${idx + 1}[/td][td]${"${e.$2.name}@${e.$2.bangumi}"}[/td][td]${e.$2.all}[/td][td]${e.$2.effective}[/td][td]${e.$1}[/td][/tr]');

    return '''
[b][color=Red][size=5][align=center][b]2025天使动漫萌战 百合表演赛总决赛票数统计[/b][/align][/size][/color][/b][table=98%]
[tr][td]排名[/td][td]角色[/td][td]得票[/td][td]有效得票[/td][td]晋级情况[/td][/tr]
$content
[/table]
''';
  }
}
