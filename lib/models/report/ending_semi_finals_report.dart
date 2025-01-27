import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/ending/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 完结篇半决赛战报
final class EndingSemiFinalsReport implements EndingsReport {
  /// Constructor.
  const EndingSemiFinalsReport({
    required this.groupSemiFinalsA,
    required this.groupSemiFinalsB,
    required this.groupQualifyingFirst,
    required this.quarterPromoteResult,
  });

  /// Build a report from poll results.
  factory EndingSemiFinalsReport.build({
    required List<CharacterPollResult> groupSemiFinalsAPolls,
    required List<CharacterPollResult> groupSemiFinalsBPolls,
    required List<CharacterPollResult> groupQualifyingFirstPolls,
    required String quarterPromoteResult,
  }) {
    final semiFinalsAPolls = groupSemiFinalsAPolls.sortedByEffective();
    final semiFinalsBPolls = groupSemiFinalsBPolls.sortedByEffective();
    final qualifyingFirstPolls = groupQualifyingFirstPolls.sortedByEffective();

    return EndingSemiFinalsReport(
      groupSemiFinalsA: EndingSemiFinalsPromoteResult(
        groupName: '半决赛第1组',
        promoteFinals: semiFinalsAPolls.first,
        promoteQualifyingSecond: semiFinalsAPolls.elementAt(1),
      ),
      groupSemiFinalsB: EndingSemiFinalsPromoteResult(
        groupName: '半决赛第1组',
        promoteFinals: semiFinalsBPolls.first,
        promoteQualifyingSecond: semiFinalsBPolls.elementAt(1),
      ),
      groupQualifyingFirst: EndingQualifyingFirstPromoteResult(
        groupName: '排位赛第一场',
        promoteQualifyingSecond: qualifyingFirstPolls.first,
        pinnedThe6Th: qualifyingFirstPolls.elementAt(1),
        pinnedThe7Th: qualifyingFirstPolls.elementAt(2),
        pinnedThe8Th: qualifyingFirstPolls.elementAt(3),
      ),
      quarterPromoteResult: quarterPromoteResult,
    );
  }

  /// 半决赛第1组晋级结果
  final EndingSemiFinalsPromoteResult groupSemiFinalsA;

  /// 半决赛第2组晋级结果
  final EndingSemiFinalsPromoteResult groupSemiFinalsB;

  /// 排位赛第一场晋级结果
  final EndingQualifyingFirstPromoteResult groupQualifyingFirst;

  /// 四分之一决赛晋级状况
  final String quarterPromoteResult;

  @override
  String toPromoteReport() => _generateBangumiStatisticsBody();

  @override
  String toReport() {
    return '''
${_generateNextRoundPreview()}
${_generateFinalsStatistics()}
${_generateQualifyingSecondStatistics()}
${_generatePinned678Statistics()}
${_generateBangumiStatistics()}
''';
  }

  String _generateNextRoundPreview() {
    const sep = ' VS ';

    final finalsPreview = [groupSemiFinalsA, groupSemiFinalsB]
        .map((e) => e.promoteFinals)
        .map((e) => '${e.name}@${e.bangumi}')
        .join(sep);
    final qualifyingSecondPreview = [
      groupSemiFinalsA.promoteQualifyingSecond,
      groupSemiFinalsB.promoteQualifyingSecond,
      groupQualifyingFirst.promoteQualifyingSecond,
    ].map((e) => '${e.name}@${e.bangumi}').join(sep);

    return '''
[color=DarkOrange]决赛对阵预告：[/color]
[color=DarkOrange]$finalsPreview[/color]


[color=DarkOrange]排位赛第二场对阵预告：[/color]
[color=DarkOrange]$qualifyingSecondPreview[/color]
''';
  }

  String _generateFinalsStatistics() {
    final content = [groupSemiFinalsA, groupSemiFinalsB]
        .map((e) => (n: e.groupName, c: e.promoteFinals))
        .map(
          (e) => '[tr][td]${e.n}[/td]'
              '[td]NO.1[/td]'
              '[td]${e.c.name}@${e.c.bangumi}[/td]'
              '[td][color=silver]${e.c.all}[/color]'
              '[/td][td]${e.c.effective}[/td]'
              '[/tr]',
        )
        .join('\n');

    return '''
[align=center][size=5][color=#ff0000][b]完结篇半决赛晋级角色票数[/b][/color][/size][/align][table]
[tr][td=55][size=3][color=#4169e1][b]组别[/b][/color][/size][/td][td=55][size=3][color=#4169e1][b]排名[/b][/color][/size][/td][td][size=3][color=#4169e1][b]角色[/b][/color][/size][/td][td=80][size=3][color=#4169e1][b]票数[/b][/color][/size][/td][td=80][size=3][color=#4169e1][b]有效票数[/b][/color][/size][/td][/tr]
[tr=rgb(173, 216, 230)][td=5,1][/td][/tr]
$content
[/table]''';
  }

  String _generateQualifyingSecondStatistics() {
    final content = [
      (
        m: 'NO.2',
        n: groupSemiFinalsA.groupName,
        c: groupSemiFinalsA.promoteQualifyingSecond,
      ),
      (
        m: 'NO.2',
        n: groupSemiFinalsB.groupName,
        c: groupSemiFinalsB.promoteQualifyingSecond,
      ),
      (
        m: 'NO.1',
        n: groupQualifyingFirst.groupName,
        c: groupQualifyingFirst.promoteQualifyingSecond,
      ),
    ]
        .map(
          (e) => '[tr][td]${e.n}[/td]'
              '[td]${e.m}[/td]'
              '[td]${e.c.name}@${e.c.bangumi}[/td]'
              '[td][color=silver]${e.c.all}[/color]'
              '[/td][td]${e.c.effective}[/td]'
              '[/tr]',
        )
        .join('\n');

    return '''
[align=center][size=5][color=#ff0000][b]完结篇进入排位赛第二场角色票数[/b][/color][/size][/align][table]
[tr][td=55][size=3][color=#4169e1][b]组别[/b][/color][/size][/td][td=55][size=3][color=#4169e1][b]排名[/b][/color][/size][/td][td][size=3][color=#4169e1][b]角色[/b][/color][/size][/td][td=80][size=3][color=#4169e1][b]票数[/b][/color][/size][/td][td=80][size=3][color=#4169e1][b]有效票数[/b][/color][/size][/td][/tr]
[tr=rgb(173, 216, 230)][td=5,1][/td][/tr]
$content
[/table]''';
  }

  String _generatePinned678Statistics() {
    final content = [
      (
        n: 'NO.6',
        c: groupQualifyingFirst.pinnedThe6Th,
      ),
      (
        n: 'NO.7',
        c: groupQualifyingFirst.pinnedThe7Th,
      ),
      (
        n: 'NO.8',
        c: groupQualifyingFirst.pinnedThe8Th,
      ),
    ]
        .map(
          (e) => '[tr][td]排位赛第一场${e.n}[/td]'
              '[td]${e.n}[/td]'
              '[td]${e.c.name}@${e.c.bangumi}[/td]'
              '[td][color=silver]${e.c.all}[/color]'
              '[/td][td]${e.c.effective}[/td]'
              '[/tr]',
        )
        .join('\n');

    return '''
[align=center][size=5][color=#ff0000][b]完结篇最终排名6-8名角色票数[/b][/color][/size][/align][table]
[tr][td=55][size=3][color=#4169e1][b]组别及排名[/b][/color][/size][/td][td=55][size=3][color=#4169e1][b]完结篇最终排名[/b][/color][/size][/td][td][size=3][color=#4169e1][b]角色[/b][/color][/size][/td][td=80][size=3][color=#4169e1][b]票数[/b][/color][/size][/td][td=80][size=3][color=#4169e1][b]有效票数[/b][/color][/size][/td][/tr]
[tr=rgb(173, 216, 230)][td=5,1][/td][/tr]
$content
[/table]''';
  }

  String _generateBangumiStatistics() {
    return '''
[align=center][size=5][color=#ff0000][b]完结篇半决赛晋级状况[/b][/color][/size][/align][table]
[tr][td=100][size=3][color=#4169e1][b]赛事[/b][/color][/size][/td][td=100][size=3][color=#4169e1][b]晋级赛事[/b][/color][/size][/td][td][size=3][color=#4169e1][b]动画[/b][/color][/size][/td][td=80][size=3][color=#4169e1][b]人数[/b][/color][/size][/td][/tr]
${_generateBangumiStatisticsBody()}
[tr=rgb(255, 250, 205)][td=5,1][/td][/tr]
$quarterPromoteResult
[/table]''';
  }

  String _generateBangumiStatisticsBody() {
    ////////// Without promote info //////////
    final finalsPolls = [groupSemiFinalsA, groupSemiFinalsB]
        .map((e) => e.promoteFinals)
        .toList();
    final finalsResult = collectBangumiInfo(finalsPolls);

    final qualifyingSecondPolls = [
      groupSemiFinalsA.promoteQualifyingSecond,
      groupSemiFinalsB.promoteQualifyingSecond,
      groupQualifyingFirst.promoteQualifyingSecond,
    ].toList();
    final qualifyingSecondResult = collectBangumiInfo(qualifyingSecondPolls);

    final pinnedPolls = [
      groupQualifyingFirst.pinnedThe6Th,
      groupQualifyingFirst.pinnedThe7Th,
      groupQualifyingFirst.pinnedThe8Th,
    ].toList();
    final pinnedResult = collectBangumiInfo(pinnedPolls);

    /// For count only
    final allResult = mergeBangumiPromoteInfo([
      finalsResult,
      qualifyingSecondResult,
      pinnedResult,
    ]);

    ////////// WITH promote info //////////

    // 晋级决赛
    final finals = calculateBangumiPromoteCount(
      promoted: finalsResult,
      all: allResult,
    ).sortByCharacters().takeWhile((e) => e.promotedCount > 0);

    // 晋级排位赛第二场
    final qualifyingSecond = calculateBangumiPromoteCount(
      promoted: qualifyingSecondResult,
      all: allResult,
    ).sortByCharacters().takeWhile((e) => e.promotedCount > 0);

    return '''
[tr][td=1,${finals.length + qualifyingSecond.length}]半决赛[/td][td=1,${finals.length}]决赛[/td]${finals.map((e) => e.toReport()).join('\n[tr]')}
[tr][td=1,${qualifyingSecond.length}]排位赛第二场[/td]${qualifyingSecond.map((e) => e.toReport()).join('\n[tr]')}
''';
  }
}
