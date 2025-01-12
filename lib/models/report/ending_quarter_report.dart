import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/ending/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 完结篇四分之一决赛战报
final class EndingQuarterReport implements BaseReport {
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
[align=center][color=#ff00][size=5]完结篇四分之一决赛晋级角色票数[/size][/color][/align]
[table]
[tr][td=103][size=3][color=#0000ff]组别[/color][/size][/td][td=91][size=3][color=#0000ff]本轮排名[/color][/size][/td][td=470][size=3][color=#0000ff]角色[/color][/size][/td][td=90][size=3][color=#0000ff]票数[/color][/size][/td][td=101][size=3][color=#0000ff]有效票数[/color][/size][/td][/tr]
$content
[/table]
''';
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
[align=center][size=5][color=#ff0000]完结篇进入排位赛第一场角色票数[/color][/size][/align]
[table]
[tr][td=103][size=3][color=#0000ff]组别[/color][/size][/td][td=91][size=3][color=#0000ff]本轮排名[/color][/size][/td][td=470][size=3][color=#0000ff]角色[/color][/size][/td][td=90][size=3][color=#0000ff]票数[/color][/size][/td][td=101][size=3][color=#0000ff]有效票数[/color][/size][/td][/tr]
$content
[/table]
''';
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
[align=center][size=5][color=#ff0000]本届萌战最终排名第9名[/color][/size][/align]
[table]
[tr][td=103][size=3][color=#0000ff]组别[/color][/size][/td][td=91][size=3][color=#0000ff]最终排名[/color][/size][/td][td=470][size=3][color=#0000ff]角色[/color][/size][/td][td=90][size=3][color=#0000ff]票数[/color][/size][/td][td=101][size=3][color=#0000ff]有效票数[/color][/size][/td][/tr]
$content
[/table]
''';
  }

  String _generateBangumiStatistics() {
    ////////// Without promote info //////////
    final semiFinalsPolls = [groupA, groupB, groupC, groupD]
        .map((e) => e.promoteSemiFinals)
        .toList();
    final semiFinalsResult = collectBangumiInfo(semiFinalsPolls);

    final qualifyingFirstPolls = [groupA, groupB, groupC, groupD]
        .map((e) => e.promoteQualifyingFirst)
        .toList();
    final qualifyingFirstResult = collectBangumiInfo(qualifyingFirstPolls);

    final pinnedPolls =
        [groupA, groupB, groupC, groupD].map((e) => e.pinnedThe9th).toList();
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

    return '''
[align=center][size=5][color=#ff0000]完结篇四分之一决赛晋级状况[/color][/size][/align][table=98%]
[tr][td][size=3][color=#0000ff]晋级赛事[/color][/size][/td][td][size=3][color=#0000ff]动画[/color][/size][/td][td][size=3][color=#0000ff]人数[/color][/size][/td][/tr]
[tr][td=1,3]半决赛[/td]${semiFinalsResultWithPromoteInfo.sortByCharacters().take(3).map((e) => e.toReport()).join('\n[tr]')}
[tr=rgb(255, 250, 205)][td=5,1]
[/td][/tr]
[tr][td=1,4]排位赛[/td]${qualifyFirstResultWithPromoteInfo.sortByCharacters().take(4).map((e) => e.toReport()).join('\n[tr]')}
[tr=rgb(255, 250, 205)][td=5,1]
[/td][/tr]
[tr][td=1,8,103]四分之一决赛[/td]${allResultWithPromoteInfo.sortByCharacters().map((e) => e.toReport()).join('\n[tr]')}
[/table]
''';
  }
}
