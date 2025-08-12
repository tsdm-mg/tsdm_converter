import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 星耀四分之一决赛
final class StarlightQuarterReport implements BaseReport {
  /// Constructor.
  const StarlightQuarterReport({
    required this.groupAPoll,
    required this.groupBPoll,
    required this.groupAPromoted,
    required this.groupAPromotedRanking,
    required this.groupBPromoted,
    required this.groupBPromotedRanking,
    required this.promotedBangumiResult,
  }) ;

  /// Build the report.
  factory StarlightQuarterReport.build({
    required List<CharacterPollResult> groupAPoll,
    required List<CharacterPollResult> groupBPoll,
  }) {
    const promoteLimit = 2;
    const promoteRankingLimit = 4;
    final groupAPromoted = groupAPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();
    final groupBPromoted = groupBPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();
    final groupAPromotedRanking = groupAPoll.skip(promoteLimit).takeWhile((e) => int.parse(e.ranking) <= promoteRankingLimit).toList();
    final groupBPromotedRanking = groupBPoll.skip(promoteLimit).takeWhile((e) => int.parse(e.ranking) <= promoteRankingLimit).toList();

    final finalsBangumiResult =
        collectBangumiInfo([...groupAPromoted, ...groupBPromoted]);

    return StarlightQuarterReport(
      groupAPoll: groupAPoll,
      groupBPoll: groupBPoll,
      groupAPromoted: groupAPromoted,
      groupAPromotedRanking: groupAPromotedRanking,
      groupBPromoted: groupBPromoted,
      groupBPromotedRanking: groupBPromotedRanking,
      promotedBangumiResult: finalsBangumiResult,
    );
  }

  /// 四分之一决赛A组 角色投票结果
  final List<CharacterPollResult> groupAPoll;

  /// 四分之一决赛B组 角色投票结果
  final List<CharacterPollResult> groupBPoll;

  /// 四分之一决赛A组 晋级半决赛的角色
  final List<CharacterPollResult> groupAPromoted;

  /// 四分之一决赛A组 晋级排位赛的角色
  final List<CharacterPollResult> groupAPromotedRanking;

  /// 四分之一决赛B组 晋级半决赛的角色
  final List<CharacterPollResult> groupBPromoted;

  /// 四分之一决赛B组 晋级排位赛的角色
  final List<CharacterPollResult> groupBPromotedRanking;

  /// 四分之一决赛 番剧晋级状况
  final List<BangumiPollResult> promotedBangumiResult;

  String _generateGroupInfo(
      {required String groupName,
      required List<CharacterPollResult> promoteFinals,
        required List<CharacterPollResult> promoteRanking,
        required List<CharacterPollResult> pinned9th,
      }) {
    return '''
[tr][td=1,${promoteFinals.length + promoteRanking.length + pinned9th.length}][color=#4169e1]$groupName[/color][/td]
${promoteFinals.map((e) => '[td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][td]半决赛[/td][/tr]').join('\n[tr]')}
[tr]
${promoteRanking.map((e) => '[td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][td]排位赛第一场[/td][/tr]').join('\n[tr]')}
[tr]
${pinned9th.map((e) => '[td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][td][color=silver]第九名[/color][/td][/tr]').join('\n[tr]')}
''';
  }

  @override
  String toReport() {
    final finalsResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: promotedBangumiResult,
      // all: collectBangumiInfo([...groupAPoll, ...groupBPoll, ...groupCPoll, ...groupDPoll]),
      all: promotedBangumiResult,
    );

    return '''
<pre>
[align=center][b][size=5][color=#ff0000]星耀萌战2025四分之一决赛角色票数统计[/color][/size][/b][/align][table=98%]
[tr][td][color=#4169e1][b][size=3]组别[/size][/b][/color][/td][td][color=#4169e1][b][size=3]排名[/size][/b][/color][/td][td][color=#4169e1][b][size=3]角色[/size][/b][/color][/td][td][color=#4169e1][b][size=3]得票[/size][/b][/color][/td][td][color=#4169e1][b][size=3]有效得票[/size][/b][/color][/td][td][color=#4169e1][b][size=3]晋级情况[/size][/b][/color][/td][/tr]
[tr=#add8e6][td=6,1][/td][/tr]
${_generateGroupInfo(groupName: '第1组', promoteFinals: groupAPromoted, promoteRanking: groupAPromotedRanking, pinned9th:  groupAPoll.where((e) => !groupAPromoted.contains(e) && !groupAPromotedRanking.contains(e)).toList())}
[tr=#fffacd][td=6,1][/td][/tr]
${_generateGroupInfo(groupName: '第2组', promoteFinals: groupBPromoted, promoteRanking: groupBPromotedRanking, pinned9th: groupBPoll.where((e) => !groupBPromoted.contains(e) && !groupBPromotedRanking.contains(e)).toList())}
[tr=#fffacd][td=6,1][/td][/tr]
[/table]

[align=center][b][size=5][color=#ff0000]星耀萌战2025四分之一决赛晋级状况[/color][/size][/b][/align][table=98%]
[tr][td=109][size=3][color=#4169e1]晋级赛事[/color][/size][/td][td=596][size=3][color=#4169e1]动画[/color][/size][/td][td=90][size=3][color=#4169e1]人数[/color][/size][/td][/tr]
[tr][td=1,${promotedBangumiResult.length}][size=3]半决赛[/size][/td]${finalsResultWithPromoteInfo.sortByCharacters().map((e) => e.toReportOnlyPromotedCount()).join('\n[tr]')}
[/td][/tr]
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
