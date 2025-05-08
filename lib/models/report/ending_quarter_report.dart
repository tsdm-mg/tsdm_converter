import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/ending/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 完结篇四分之一决赛战报
final class EndingQuarterReport implements EndingsReport {
  /// Constructor.
  const EndingQuarterReport({
    required this.groupA,
    required this.groupB,
    required this.groupC,
    required this.groupD,
  });

  /// Build a report from poll results.
  factory EndingQuarterReport.build({
    required List<CharacterPollResult> groupAPolls,
    required List<CharacterPollResult> groupBPolls,
    required List<CharacterPollResult> groupCPolls,
    required List<CharacterPollResult> groupDPolls,
  }) {
    final aPolls = groupAPolls.sortedByEffective();
    final bPolls = groupBPolls.sortedByEffective();
    final cPolls = groupCPolls.sortedByEffective();
    final dPolls = groupDPolls.sortedByEffective();

    return EndingQuarterReport(
      groupA: EndingQuarterPromoteResult(
        groupName: '第1组',
        promoteSemiFinals: aPolls.first,
        promoteQualifyingFirst: aPolls.elementAt(1),
        pinnedThe9th: aPolls.elementAt(2),
      ),
      groupB: EndingQuarterPromoteResult(
        groupName: '第2组',
        promoteSemiFinals: bPolls.first,
        promoteQualifyingFirst: bPolls.elementAt(1),
        pinnedThe9th: bPolls.elementAt(2),
      ),
      groupC: EndingQuarterPromoteResult(
        groupName: '第3组',
        promoteSemiFinals: cPolls.first,
        promoteQualifyingFirst: cPolls.elementAt(1),
        pinnedThe9th: cPolls.elementAt(2),
      ),
      groupD: EndingQuarterPromoteResult(
        groupName: '第4组',
        promoteSemiFinals: dPolls.first,
        promoteQualifyingFirst: dPolls.elementAt(1),
        pinnedThe9th: dPolls.elementAt(2),
      ),
    );
  }

  /// A组晋级结果
  final EndingQuarterPromoteResult groupA;

  /// B组晋级结果
  final EndingQuarterPromoteResult groupB;

  /// C组晋级结果
  final EndingQuarterPromoteResult groupC;

  /// D组晋级结果
  final EndingQuarterPromoteResult groupD;

  @override
  String toReport() {
    return '''
${_generateSemiFinalsStatistics()}
${_generateQualifyingFirstStatistics()}
${_generatePinned9thStatistics()}
${_generateBangumiStatistics()}
''';
  }

  String _generateSemiFinalsStatistics() {
    final content = [groupA, groupB, groupC, groupD]
        .map((e) => (n: e.groupName, c: e.promoteSemiFinals))
        .map(
          (e) => '[tr][td]${e.n}[/td]'
              '[td]NO.1[/td]'
              '[td]${e.c.name}@${e.c.bangumi}[/td]'
              '[td][color=#c0c0c0]${e.c.all}[/color]'
              '[/td][td]${e.c.effective}[/td]'
              '[/tr]',
        )
        .join('\n');

    return '''
[align=center][color=#ff00][size=5][b]完结篇四分之一决赛晋级角色票数[/b][/size][/color][/align][table]
[tr][td=103][size=3][color=#0000ff][b]组别[/b][/color][/size][/td][td=91][size=3][color=#0000ff][b]本轮排名[/b][/color][/size][/td][td=470][size=3][color=#0000ff][b]角色[/b][/color][/size][/td][td=90][size=3][color=#0000ff][b]票数[/b][/color][/size][/td][td=101][size=3][color=#0000ff][b]有效票数[/b][/color][/size][/td][/tr]
$content
[/table]''';
  }

  String _generateQualifyingFirstStatistics() {
    final content = [groupA, groupB, groupC, groupD]
        .map((e) => (n: e.groupName, c: e.promoteQualifyingFirst))
        .map(
          (e) => '[tr][td]${e.n}[/td]'
              '[td]NO.2[/td]'
              '[td]${e.c.name}@${e.c.bangumi}[/td]'
              '[td][color=#c0c0c0]${e.c.all}[/color]'
              '[/td][td]${e.c.effective}[/td]'
              '[/tr]',
        )
        .join('\n');

    return '''
[align=center][size=5][color=#ff0000][b]完结篇进入排位赛第一场角色票数[/b][/color][/size][/align][table]
[tr][td=103][size=3][color=#0000ff][b]组别[/b][/color][/size][/td][td=91][size=3][color=#0000ff][b]本轮排名[/b][/color][/size][/td][td=470][size=3][color=#0000ff][b]角色[/b][/color][/size][/td][td=90][size=3][color=#0000ff][b]票数[/b][/color][/size][/td][td=101][size=3][color=#0000ff][b]有效票数[/b][/color][/size][/td][/tr]
$content
[/table]''';
  }

  String _generatePinned9thStatistics() {
    final content = [groupA, groupB, groupC, groupD]
        .map((e) => (n: e.groupName, c: e.pinnedThe9th))
        .map(
          (e) => '[tr][td]${e.n}[/td]'
              '[td]NO.9[/td]'
              '[td]${e.c.name}@${e.c.bangumi}[/td]'
              '[td][color=#c0c0c0]${e.c.all}[/color]'
              '[/td][td]${e.c.effective}[/td]'
              '[/tr]',
        )
        .join('\n');

    return '''
[align=center][size=5][color=#ff0000][b]本届萌战最终排名第9名[/b][/color][/size][/align][table]
[tr][td=103][size=3][color=#0000ff][b]组别[/b][/color][/size][/td][td=91][size=3][color=#0000ff][b]最终排名[/b][/color][/size][/td][td=470][size=3][color=#0000ff][b]角色[/b][/color][/size][/td][td=90][size=3][color=#0000ff][b]票数[/b][/color][/size][/td][td=101][size=3][color=#0000ff][b]有效票数[/b][/color][/size][/td][/tr]
$content
[/table]''';
  }

  String _generateBangumiStatisticsBody() {
    ////////// Without promote info //////////
    final semiFinalsPolls = [groupA, groupB, groupC, groupD].map((e) => e.promoteSemiFinals).toList();
    final semiFinalsResult = collectBangumiInfo(semiFinalsPolls);

    final qualifyingFirstPolls = [groupA, groupB, groupC, groupD].map((e) => e.promoteQualifyingFirst).toList();
    final qualifyingFirstResult = collectBangumiInfo(qualifyingFirstPolls);

    final pinnedPolls = [groupA, groupB, groupC, groupD].map((e) => e.pinnedThe9th).toList();
    final pinnedResult = collectBangumiInfo(pinnedPolls);

    /// For count only
    final allResult = mergeBangumiPromoteInfo([
      semiFinalsResult,
      qualifyingFirstResult,
      pinnedResult,
    ]);

    ////////// WITH promote info //////////

    // 晋级半决赛
    final semiFinalsResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: semiFinalsResult,
      all: allResult,
    );

    // 晋级排位赛第一场
    final qualifyFirstResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: qualifyingFirstResult,
      all: allResult,
    );

    // 总的晋级：半决赛 + 排位赛第一场
    final promotedResult = mergeBangumiPromoteInfo([
      semiFinalsResult,
      qualifyingFirstResult,
    ]);

    final allResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: promotedResult,
      all: allResult,
    );

    //////

    final semiFinals = semiFinalsResultWithPromoteInfo.sortByCharacters().takeWhile((e) => e.promotedCount > 0);
    final qualifyFirst = qualifyFirstResultWithPromoteInfo.sortByCharacters().takeWhile((e) => e.promotedCount > 0);
    final all = allResultWithPromoteInfo.sortByCharacters();

    return '''
[tr][td=1,${semiFinals.length + qualifyFirst.length}]四分之一决赛[/td][td=1,${semiFinals.length}]半决赛[/td]${semiFinals.map((e) => e.toReport()).join('\n[tr]')}
[tr][td=1,${qualifyFirst.length}]排位赛[/td]${qualifyFirst.map((e) => e.toReport()).join('\n[tr]')}
[tr=rgb(255, 250, 205)][td=5,1][/td][/tr]
[tr][td=1,${all.length}]初赛[/td][td=1,${all.length}]四分之一决赛[/td]${all.map((e) => e.toReport()).join('\n[tr]')}
''';
  }

  String _generateBangumiStatistics() {
    return '''
[align=center][size=5][color=#ff0000][b]完结篇四分之一决赛晋级状况[/b][/color][/size][/align][table=98%]
[tr][td=100][size=3][color=#0000ff][b]赛事[/b][/color][/size][/td][td=100][size=3][color=#0000ff][b]晋级赛事[/b][/color][/size][/td][td][size=3][color=#0000ff][b]动画[/b][/color][/size][/td][td][size=3][color=#0000ff][b]人数[/b][/color][/size][/td][/tr]
${_generateBangumiStatisticsBody()}
[/table]''';
  }

  @override
  String toPromoteReport() => _generateBangumiStatisticsBody();
}
