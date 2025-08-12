import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 星耀决赛
final class StarlightFinalsReport implements BaseReport {
  /// Constructor.
  const StarlightFinalsReport({
    required this.groupFinalsPoll,
    required this.groupQualifyingPoll,
    required this.groupMoviePoll,
    required this.pinnedThe1st,
    required this.pinnedThe2nd,
    required this.pinnedThe3rd,
    required this.pinnedThe4th,
    required this.pinnedThe5th,
    required this.promotedFinalsResult,
    required this.promotedQualifyingResult,
    required this.promotedMovieResult,
  }) ;

  /// Build the report.
  factory StarlightFinalsReport.build({
    required List<CharacterPollResult> groupFinalsPoll,
    required List<CharacterPollResult> groupQualifyingPoll,
    required List<CharacterPollResult> groupMoviePoll,
  }) {
    final pinnedThe1st = groupFinalsPoll.firstWhere((e) => e.ranking == '1');
    final pinnedThe2rd = groupFinalsPoll.firstWhere((e) => e.ranking == '2');
    final pinnedThe3nd = groupQualifyingPoll.firstWhere((e) => e.ranking == '1');
    final pinnedThe4th = groupQualifyingPoll.firstWhere((e) => e.ranking == '2');
    final pinnedThe5th = groupQualifyingPoll.firstWhere((e) => e.ranking == '3');

    final promotedFinalsResult = collectBangumiInfo(groupFinalsPoll);
    final promotedQualifyingResult = collectBangumiInfo(groupQualifyingPoll);
    final promotedMovieResult = collectBangumiInfo(groupMoviePoll);


    return StarlightFinalsReport(
      groupFinalsPoll: groupFinalsPoll,
      groupQualifyingPoll: groupQualifyingPoll,
      groupMoviePoll: groupMoviePoll,
      pinnedThe1st: pinnedThe1st,
      pinnedThe2nd: pinnedThe2rd,
      pinnedThe3rd: pinnedThe3nd,
      pinnedThe4th: pinnedThe4th,
      pinnedThe5th: pinnedThe5th,
      promotedFinalsResult:promotedFinalsResult,
      promotedQualifyingResult: promotedQualifyingResult,
      promotedMovieResult: promotedMovieResult,
    );
  }

  /// 决赛 角色投票结果
  final List<CharacterPollResult> groupFinalsPoll;

  /// 排位赛决赛 角色投票结果
  final List<CharacterPollResult> groupQualifyingPoll;

  /// 剧场版动画表演赛决赛 角色投票结果
  final List<CharacterPollResult> groupMoviePoll;

  /// 冠军
  final CharacterPollResult pinnedThe1st;

  /// 准萌
  final CharacterPollResult pinnedThe2nd;

  /// 季军
  final CharacterPollResult pinnedThe3rd;

  /// 殿军
  final CharacterPollResult pinnedThe4th;

  /// 第五
  final CharacterPollResult pinnedThe5th;

  /// 决赛 番剧晋级状况
  final List<BangumiPollResult> promotedFinalsResult;

  /// 排位赛决赛 番剧晋级状况
  final List<BangumiPollResult> promotedQualifyingResult;

  /// 剧场版动画表演赛决赛 番剧晋级状况
  final List<BangumiPollResult> promotedMovieResult;

  String _generateGroupInfo(
      {required List<CharacterPollResult> polls,
      }) {
    return '''
[tr][td=1,${polls.length},109][color=#4169e1]星耀萌战剧场版表演赛决赛[/color][/td]
${polls.map((e) => '[td]${e.ranking}[/td][td]${e.name}@${e.bangumi}[/td][td][color=silver]${e.all}[/color][/td][td]${e.effective}[/td][/tr]').join('\n[tr]')}
''';
  }

  @override
  String toReport() {
    final finalsResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: promotedFinalsResult,
      all: promotedFinalsResult,
    );
    final qualifyingResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: promotedQualifyingResult,
      all: promotedQualifyingResult,
    );
    final movieResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: promotedMovieResult,
      all: promotedMovieResult,
    );

    return '''
<pre>
[align=center][b][size=5][color=#ff0000]星耀萌战2025决赛角色票数统计[/color][/size][/b][/align][table=98%]
[tr][td][color=#4169e1][b][size=3]组别[/size][/b][/color][/td][td][color=#4169e1][b][size=3]排名[/size][/b][/color][/td][td][color=#4169e1][b][size=3]角色[/size][/b][/color][/td][td][color=#4169e1][b][size=3]得票[/size][/b][/color][/td][td][color=#4169e1][b][size=3]有效得票[/size][/b][/color][/td][/tr]
[tr=#add8e6][td=5,1][/td][/tr]
[tr][td=1,2][color=#4169e1]决赛[/color][/td]
[td]萌王[/td][td]${pinnedThe1st.name}@${pinnedThe1st.bangumi}[/td][td][color=silver]${pinnedThe1st.all}[/color][/td][td]${pinnedThe1st.effective}[/td][/tr]
[tr]
[td]准萌[/td][td]${pinnedThe2nd.name}@${pinnedThe2nd.bangumi}[/td][td][color=silver]${pinnedThe2nd.all}[/color][/td][td]${pinnedThe2nd.effective}[/td][/tr]
[/table]

[align=center][b][size=5][color=#ff0000]星耀萌战2025排位赛第二场晋级状况[/color][/size][/b][/align][table=98%]
[tr][td][color=#4169e1][b][size=3]组别[/size][/b][/color][/td][td][color=#4169e1][b][size=3]排名[/size][/b][/color][/td][td][color=#4169e1][b][size=3]角色[/size][/b][/color][/td][td][color=#4169e1][b][size=3]得票[/size][/b][/color][/td][td][color=#4169e1][b][size=3]有效得票[/size][/b][/color][/td][/tr]
[tr=#add8e6][td=5,1][/td][/tr]
[tr][td=1,3][color=#4169e1]排位赛第二场[/color][/td]
[td]季军[/td][td]${pinnedThe3rd.name}@${pinnedThe3rd.bangumi}[/td][td][color=silver]${pinnedThe3rd.all}[/color][/td][td]${pinnedThe3rd.effective}[/td][/tr]
[tr]
[td]殿军[/td][td]${pinnedThe4th.name}@${pinnedThe4th.bangumi}[/td][td][color=silver]${pinnedThe4th.all}[/color][/td][td]${pinnedThe4th.effective}[/td][/tr]
[tr]
[td]第五[/td][td]${pinnedThe5th.name}@${pinnedThe5th.bangumi}[/td][td][color=silver]${pinnedThe5th.all}[/color][/td][td]${pinnedThe5th.effective}[/td][/tr]
[/table]

[align=center][b][size=5][color=#ff0000]作品晋级情况[/color][/size][/b][/align][table=98%]
[tr=#add8e6][td=3,1][/td][/tr]
[tr][td=109][size=3][color=#4169e1]晋级赛事[/color][/size][/td][td=596][size=3][color=#4169e1]动画[/color][/size][/td][td=90][size=3][color=#4169e1]人数[/color][/size][/td][/tr]
[tr][td=1,${finalsResultWithPromoteInfo.length}][size=3]星耀萌战决赛[/size][/td]${finalsResultWithPromoteInfo.sortByCharacters().map((e) => e.toReportOnlyPromotedCount()).join('\n[tr]')}
[tr=#add8e6][td=3,1][/td][/tr]
[tr][td=1,${qualifyingResultWithPromoteInfo.length}][size=3]星耀萌战排位赛第二场[/size][/td]${qualifyingResultWithPromoteInfo.sortByCharacters().map((e) => e.toReportOnlyPromotedCount()).join('\n[tr]')}
[/td][/tr]
[/table]

[align=center][b][size=5][color=#ff0000]星耀萌战2025剧场版表演赛决赛角色票数[/color][/size][/b][/align][table=98%]
[tr][td][color=#4169e1][b][size=3]组别[/size][/b][/color][/td][td][color=#4169e1][b][size=3]排名[/size][/b][/color][/td][td][color=#4169e1][b][size=3]角色[/size][/b][/color][/td][td][color=#4169e1][b][size=3]得票[/size][/b][/color][/td][td][color=#4169e1][b][size=3]有效得票[/size][/b][/color][/td][/tr]
[tr=#add8e6][td=5,1][/td][/tr]
${_generateGroupInfo(polls: groupMoviePoll)}
[/table]

[align=center][b][size=5][color=#ff0000]星耀萌战2025剧场版表演赛决赛作品参与情况[/color][/size][/b][/align][table=98%]
[tr=#add8e6][td=3,1][/td][/tr]
[tr][td=109][size=3][color=#4169e1]晋级赛事[/color][/size][/td][td=596][size=3][color=#4169e1]动画[/color][/size][/td][td=90][size=3][color=#4169e1]人数[/color][/size][/td][/tr]
[tr][td=1,${movieResultWithPromoteInfo.length}][size=3]星耀萌战剧场版表演赛决赛[/size][/td]${movieResultWithPromoteInfo.sortByCharacters().map((e) => e.toReportOnlyPromotedCount()).join('\n[tr]')}
[/td][/tr]
[/table]
</pre>

<style>
#postlist div:nth-of-type(-n+2) .tsdm_post_t {background: none !important;}
#postlist>div:nth-of-type(-n+2) .pstatus,#postlist>div:nth-of-type(-n+2) .pstatus+br,#postlist>div:nth-of-type(-n+2) .pstatus+br+br {display: none !important;}
pre {margin-top: 0; font-family: initial; white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word;}
</style>
'''
        .trim();
  }
}
