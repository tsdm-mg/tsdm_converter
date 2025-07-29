import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 燃战复赛
final class BurningRematchReport implements BaseReport {
  /// Constructor.
  const BurningRematchReport({
    required this.groupAPoll,
    required this.groupBPoll,
    required this.groupCPoll,
    required this.groupDPoll,
    required this.groupAPromoted,
    required this.groupBPromoted,
    required this.groupCPromoted,
    required this.groupDPromoted,
    required this.promotedBangumiResult,
  }) ;

  /// Build the report.
  factory BurningRematchReport.build({
    required List<CharacterPollResult> groupAPoll,
    required List<CharacterPollResult> groupBPoll,
    required List<CharacterPollResult> groupCPoll,
    required List<CharacterPollResult> groupDPoll,
  }) {
    const promoteLimit = 4;
    final groupAPromoted = groupAPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();
    final groupBPromoted = groupBPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();
    final groupCPromoted = groupCPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();
    final groupDPromoted = groupDPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();

    final finalsBangumiResult =
        collectBangumiInfo([...groupAPromoted, ...groupBPromoted, ...groupCPromoted, ...groupDPromoted]);

    return BurningRematchReport(
      groupAPoll: groupAPoll,
      groupBPoll: groupBPoll,
      groupCPoll: groupCPoll,
      groupDPoll: groupDPoll,
      groupAPromoted: groupAPromoted,
      groupBPromoted: groupBPromoted,
      groupCPromoted: groupCPromoted,
      groupDPromoted: groupDPromoted,
      promotedBangumiResult: finalsBangumiResult,
    );
  }

  /// 复赛A组 角色投票结果
  final List<CharacterPollResult> groupAPoll;

  /// 复赛B组 角色投票结果
  final List<CharacterPollResult> groupBPoll;

  /// 复赛C组 角色投票结果
  final List<CharacterPollResult> groupCPoll;

  /// 复赛D组 角色投票结果
  final List<CharacterPollResult> groupDPoll;

  /// 复赛A组 晋级复赛的角色
  final List<CharacterPollResult> groupAPromoted;

  /// 复赛B组 晋级复赛的角色
  final List<CharacterPollResult> groupBPromoted;

  /// 复赛C组 晋级复赛的角色
  final List<CharacterPollResult> groupCPromoted;

  /// 复赛D组 晋级复赛的角色
  final List<CharacterPollResult> groupDPromoted;

  /// 复赛 番剧晋级状况
  final List<BangumiPollResult> promotedBangumiResult;

  String _generateGroupInfo(
      {required String groupName,
      required List<CharacterPollResult> promoteFinals,
        required List<CharacterPollResult> notPromotedFinals,
      }) {
    return '''
[tr][td=1,${promoteFinals.length + notPromotedFinals.length}][color=#4169e1]$groupName[/color][/td]
${promoteFinals.map((e) => '[td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][td]半决赛[/td][/tr]').join('\n[tr]')}
[tr]
${notPromotedFinals.map((e) => '[td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][td][color=silver]淘汰[/color][/td][/tr]').join('\n[tr]')}
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
[align=center][b][size=5][color=#ff0000]燃战复赛角色票数统计[/color][/size][/b][/align][table=98%]
[tr][td][color=#4169e1][b][size=3]组别[/size][/b][/color][/td][td][color=#4169e1][b][size=3]排名[/size][/b][/color][/td][td][color=#4169e1][b][size=3]角色[/size][/b][/color][/td][td][color=#4169e1][b][size=3]得票[/size][/b][/color][/td][td][color=#4169e1][b][size=3]有效得票[/size][/b][/color][/td][td][color=#4169e1][b][size=3]晋级情况[/size][/b][/color][/td][/tr]
[tr=#add8e6][td=6,1][/td][/tr]
${_generateGroupInfo(groupName: 'A组', promoteFinals: groupAPromoted, notPromotedFinals: groupAPoll.where((e) => !groupAPromoted.contains(e)).toList())}
[tr=#fffacd][td=6,1][/td][/tr]
${_generateGroupInfo(groupName: 'B组', promoteFinals: groupBPromoted, notPromotedFinals: groupBPoll.where((e) => !groupBPromoted.contains(e)).toList())}
[tr=#fffacd][td=6,1][/td][/tr]
${_generateGroupInfo(groupName: 'C组', promoteFinals: groupCPromoted, notPromotedFinals: groupCPoll.where((e) => !groupCPromoted.contains(e)).toList())}
[tr=#fffacd][td=6,1][/td][/tr]
${_generateGroupInfo(groupName: 'D组', promoteFinals: groupDPromoted, notPromotedFinals: groupDPoll.where((e) => !groupDPromoted.contains(e)).toList())}
[/table]

[align=center][b][size=5][color=#ff0000]燃战复赛晋级状况[/color][/size][/b][/align][table=98%]
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
