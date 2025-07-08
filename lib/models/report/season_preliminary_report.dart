import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 季节篇初赛战报
///
/// 包含初赛和复活赛。
final class SeasonPreliminaryReport implements BaseReport {
  /// Constructor.
  const SeasonPreliminaryReport({
    required this.stage,
    required this.groupAPoll,
    required this.groupBPoll,
    required this.groupCPoll,
    required this.groupDPoll,
    required this.groupAFinals,
    required this.groupBFinals,
    required this.groupCFinals,
    required this.groupDFinals,
    required this.groupARematch,
    required this.groupBRematch,
    required this.groupCRematch,
    required this.groupDRematch,
    required this.finalsBangumiResult,
    required this.rematchBangumiResult,
  }) : assert(
          stage != Stage.coda,
          'season finals can NOT be a final stage',
        );

  /// Build a season stage finals round report.
  factory SeasonPreliminaryReport.build({
    required Stage stage,
    required List<CharacterPollResult> groupAPoll,
    required List<CharacterPollResult> groupBPoll,
    required List<CharacterPollResult> groupCPoll,
    required List<CharacterPollResult> groupDPoll,
  }) {
    // 1st, 2nd
    const finalsPromoteLimit = 2;
    // 3rd, 4th, 5th
    const rematchPromoteLimit = 5;
    final groupAFinals = groupAPoll.takeWhile((e) => int.parse(e.ranking) <= finalsPromoteLimit).toList();
    final groupBFinals = groupBPoll.takeWhile((e) => int.parse(e.ranking) <= finalsPromoteLimit).toList();
    final groupCFinals = groupCPoll.takeWhile((e) => int.parse(e.ranking) <= finalsPromoteLimit).toList();
    final groupDFinals = groupDPoll.takeWhile((e) => int.parse(e.ranking) <= finalsPromoteLimit).toList();
    final groupARematch = groupAPoll
        .where((e) => int.parse(e.ranking) > finalsPromoteLimit && int.parse(e.ranking) <= rematchPromoteLimit)
        .toList();
    final groupBRematch = groupBPoll
        .where((e) => int.parse(e.ranking) > finalsPromoteLimit && int.parse(e.ranking) <= rematchPromoteLimit)
        .toList();
    final groupCRematch = groupCPoll
        .where((e) => int.parse(e.ranking) > finalsPromoteLimit && int.parse(e.ranking) <= rematchPromoteLimit)
        .toList();
    final groupDRematch = groupDPoll
        .where((e) => int.parse(e.ranking) > finalsPromoteLimit && int.parse(e.ranking) <= rematchPromoteLimit)
        .toList();

    final finalsBangumiResult =
        collectBangumiInfo([...groupAFinals, ...groupBFinals, ...groupCFinals, ...groupDFinals]);
    final rematchBangumiResult = collectBangumiInfo([
      ...groupARematch,
      ...groupBRematch,
      ...groupCRematch,
      ...groupDRematch,
    ]);

    return SeasonPreliminaryReport(
      stage: stage,
      groupAPoll: groupAPoll,
      groupBPoll: groupBPoll,
      groupCPoll: groupCPoll,
      groupDPoll: groupDPoll,
      groupAFinals: groupAFinals,
      groupBFinals: groupBFinals,
      groupCFinals: groupCFinals,
      groupDFinals: groupDFinals,
      groupARematch: groupARematch,
      groupBRematch: groupBRematch,
      groupCRematch: groupCRematch,
      groupDRematch: groupDRematch,
      finalsBangumiResult: finalsBangumiResult,
      rematchBangumiResult: rematchBangumiResult,
    );
  }

  /// 阶段
  ///
  /// Can not be [Stage.coda]
  final Stage stage;

  /// 初赛A组 角色投票结果
  final List<CharacterPollResult> groupAPoll;

  /// 初赛B组 角色投票结果
  final List<CharacterPollResult> groupBPoll;

  /// 初赛C组 角色投票结果
  final List<CharacterPollResult> groupCPoll;

  /// 初赛D组 角色投票结果
  final List<CharacterPollResult> groupDPoll;

  /// 初赛A组 晋级决赛的角色
  final List<CharacterPollResult> groupAFinals;

  /// 初赛B组 晋级决赛的角色
  final List<CharacterPollResult> groupBFinals;

  /// 初赛C组 晋级决赛的角色
  final List<CharacterPollResult> groupCFinals;

  /// 初赛D组 晋级决赛的角色
  final List<CharacterPollResult> groupDFinals;

  /// 初赛A组 晋级复活赛的角色
  final List<CharacterPollResult> groupARematch;

  /// 初赛B组 晋级复活赛的角色
  final List<CharacterPollResult> groupBRematch;

  /// 初赛C组 晋级复活赛的角色
  final List<CharacterPollResult> groupCRematch;

  /// 初赛D组 晋级复活赛的角色
  final List<CharacterPollResult> groupDRematch;

  /// 决赛 番剧晋级状况
  final List<BangumiPollResult> finalsBangumiResult;

  /// 复活赛 番剧晋级状况
  final List<BangumiPollResult> rematchBangumiResult;

  String _generateGroupInfo(
      {required String groupName,
      required List<CharacterPollResult> promoteFinals,
      required List<CharacterPollResult> promoteRematch}) {
    return '''
[tr][td=5,1][align=left][size=4][color=#ffa500][b]$groupName[/b][/color][/size][/align][/td][/tr]
[tr][td]排名[/td][td]角色[/td][td]得票[/td][td]有效得票[/td][td]晋级情况[/td][/tr]
${promoteFinals.map((e) => '[tr][td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][td]决赛[/td][/tr]').join('\n')}
${promoteRematch.map((e) => '[tr][td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][td]复活赛[/td][/tr]').join('\n')}
''';
  }

  @override
  String toReport() {
    final finalsResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: finalsBangumiResult,
      all: finalsBangumiResult,
    );

    final rematchResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: rematchBangumiResult,
      all: rematchBangumiResult,
    );

    final mergedResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: mergeBangumiPromoteInfo([rematchResultWithPromoteInfo, finalsResultWithPromoteInfo]),
      all: collectBangumiInfo([...groupAPoll, ...groupBPoll, ...groupCPoll, ...groupDPoll]),
    );

    return '''
<pre>
[align=center][b][size=5][color=#ff0000]${stage.name}初赛角色票数统计[/color][/size][/b][/align][table=98%]
${_generateGroupInfo(groupName: 'A组', promoteFinals: groupAFinals, promoteRematch: groupARematch)}
${_generateGroupInfo(groupName: 'B组', promoteFinals: groupBFinals, promoteRematch: groupBRematch)}
${_generateGroupInfo(groupName: 'C组', promoteFinals: groupCFinals, promoteRematch: groupCRematch)}
${_generateGroupInfo(groupName: 'D组', promoteFinals: groupDFinals, promoteRematch: groupDRematch)}
[/table]

[align=center][b][size=5][color=#ff0000]${stage.name}初赛晋级状况[/color][/size][/b][/align][table=98%]
[tr][td=109][size=3][color=#0000ff]晋级赛事[/color][/size][/td][td=596][size=3][color=#0000ff]动画[/color][/size][/td][td=90][size=3][color=#0000ff]人数[/color][/size][/td][/tr]
[tr][td=1,${finalsBangumiResult.length}][size=3]决赛[/size][/td]${finalsResultWithPromoteInfo.sortByCharacters().map((e) => e.toReportOnlyPromotedCount()).join('\n[tr]')}
[tr=#fffacd][td=3,1]
[/td][/tr]
[tr][td][size=3][color=#0000ff]晋级赛事[/color][/size][/td][td][size=3][color=#0000ff]动画[/color][/size][/td][td][size=3][color=#0000ff]人数[/color][/size][/td][/tr]
[tr][td=1,${rematchBangumiResult.length}][size=3]复活赛[/size][/td]${rematchResultWithPromoteInfo.sortByCharacters().map((e) => e.toReportOnlyPromotedCount()).join('\n[tr]')}
[tr=#fffacd][td=3,1]
[/td][/tr]
[tr][td][size=3][color=#0000ff]晋级赛事[/color][/size][/td][td][size=3][color=#0000ff]动画[/color][/size][/td][td][size=3][color=#0000ff]人数[/color][/size][/td][/tr]
[tr][td=1,${mergedResultWithPromoteInfo.length}][size=3]决赛+复活赛[/size][/td]${mergedResultWithPromoteInfo.sortByCharacters().where((e) => e.promotedCount > 0).map((e) => e.toReportOnlyPromotedCount()).join('\n[tr]')}
[/table]
</pre>

<style>
#postlist div:nth-of-type(-n+2) .tsdm_post_t {background: none !important;}
#postlist>div:nth-of-type(-n+2) .pstatus,#postlist>div:nth-of-type(-n+2) .pstatus+br,#postlist>div:nth-of-type(-n+2) .pstatus+br+br {display: none !important;}
pre {margin-top: 0; font-family: initial; white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: -pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word;}
</style>
'''
        .trim();
  }
}
