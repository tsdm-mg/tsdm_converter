import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 星耀剧场版表演赛初赛
final class StarlightMovieRoundReport implements BaseReport {
  /// Constructor.
  const StarlightMovieRoundReport({
    required this.groupAPoll,
    required this.groupBPoll,
    required this.groupAPromoted,
    required this.groupBPromoted,
    required this.promotedBangumiResult,
  }) ;

  /// Build the report.
  factory StarlightMovieRoundReport.build({
    required List<CharacterPollResult> groupAPoll,
    required List<CharacterPollResult> groupBPoll,
  }) {
    const promoteLimit = 6;
    final groupAPromoted = groupAPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();
    final groupBPromoted = groupBPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();

    final finalsBangumiResult =
        collectBangumiInfo([...groupAPromoted, ...groupBPromoted]);

    return StarlightMovieRoundReport(
      groupAPoll: groupAPoll,
      groupBPoll: groupBPoll,
      groupAPromoted: groupAPromoted,
      groupBPromoted: groupBPromoted,
      promotedBangumiResult: finalsBangumiResult,
    );
  }

  /// 剧场版表演赛初赛A组 角色投票结果
  final List<CharacterPollResult> groupAPoll;

  /// 剧场版表演赛初赛B组 角色投票结果
  final List<CharacterPollResult> groupBPoll;

  /// 剧场版表演赛初赛A组 晋级决赛的角色
  final List<CharacterPollResult> groupAPromoted;

  /// 剧场版表演赛初赛B组 晋级决赛的角色
  final List<CharacterPollResult> groupBPromoted;

  /// 剧场版表演赛初赛 番剧晋级状况
  final List<BangumiPollResult> promotedBangumiResult;

  String _generateGroupInfo(
      {required String groupName,
      required List<CharacterPollResult> promoteFinals,
        required List<CharacterPollResult> notPromoted,
      }) {
    return '''
[tr][td=1,${promoteFinals.length + notPromoted.length}][color=#4169e1]$groupName[/color][/td]
${promoteFinals.map((e) => '[td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][td]剧场版表演赛决赛[/td][/tr]').join('\n[tr]')}
[tr]
${notPromoted.map((e) => '[td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][td][color=silver]淘汰[/color][/td][/tr]').join('\n[tr]')}
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
[align=center][b][size=5][color=#ff0000]星耀萌战2025剧场版表演赛初赛角色票数统计[/color][/size][/b][/align][table=98%]
[tr][td][color=#4169e1][b][size=3]组别[/size][/b][/color][/td][td][color=#4169e1][b][size=3]排名[/size][/b][/color][/td][td][color=#4169e1][b][size=3]角色[/size][/b][/color][/td][td][color=#4169e1][b][size=3]得票[/size][/b][/color][/td][td][color=#4169e1][b][size=3]有效得票[/size][/b][/color][/td][td][color=#4169e1][b][size=3]晋级情况[/size][/b][/color][/td][/tr]
[tr=#add8e6][td=6,1][/td][/tr]
${_generateGroupInfo(groupName: 'A组', promoteFinals: groupAPromoted, notPromoted: groupAPoll.where((e) => !groupAPromoted.contains(e)).toList())}
[tr=#fffacd][td=6,1][/td][/tr]
${_generateGroupInfo(groupName: 'B组', promoteFinals: groupBPromoted, notPromoted: groupBPoll.where((e) => !groupBPromoted.contains(e)).toList())}
[tr=#fffacd][td=6,1][/td][/tr]
[/table]

[align=center][b][size=5][color=#ff0000]星耀萌战2025剧场版表演赛初赛晋级状况[/color][/size][/b][/align][table=98%]
[tr][td=109][size=3][color=#4169e1]晋级赛事[/color][/size][/td][td=596][size=3][color=#4169e1]动画[/color][/size][/td][td=90][size=3][color=#4169e1]人数[/color][/size][/td][/tr]
[tr][td=1,${promotedBangumiResult.length}][size=3]剧场版表演赛决赛[/size][/td]${finalsResultWithPromoteInfo.sortByCharacters().map((e) => e.toReportOnlyPromotedCount()).join('\n[tr]')}
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
