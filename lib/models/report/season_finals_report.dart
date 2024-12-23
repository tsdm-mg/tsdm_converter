import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 季节篇决赛战报
///
/// 包含决赛和复活赛。
final class SeasonFinalsReport implements BaseReport {
  /// Constructor.
  const SeasonFinalsReport({
    required this.stage,
    required this.finalsCharacters,
    required this.finalsBangumiResult,
    required this.repechageCharacters,
    required this.repechageBangumiResult,
    required this.repechagePromoteLimit,
  }) : assert(
          stage != Stage.coda,
          'season finals can NOT be a final stage',
        );

  /// Build a season stage finals round report.
  factory SeasonFinalsReport.build(
    Stage stage,
    int promoteLimit,
    Set<CharacterPollResult> finalsPoll,
    Set<CharacterPollResult> repechagePoll,
  ) {
    final repechagePromoted = repechagePoll.take(promoteLimit).toSet();
    final finalsBangumiResult = collectBangumiInfo(finalsPoll);
    final repechageBangumiResult = collectBangumiInfo(repechagePromoted);

    return SeasonFinalsReport(
      stage: stage,
      finalsCharacters: finalsPoll,
      finalsBangumiResult: finalsBangumiResult,
      repechageCharacters: repechagePromoted,
      repechageBangumiResult: repechageBangumiResult,
      repechagePromoteLimit: promoteLimit,
    );
  }

  /// 阶段
  ///
  /// Can not be [Stage.coda]
  final Stage stage;

  /// 决赛 角色投票结果
  final Set<CharacterPollResult> finalsCharacters;

  /// 决赛 番剧晋级状况
  final Set<BangumiPollResult> finalsBangumiResult;

  /// 复活赛 角色投票结果
  final Set<CharacterPollResult> repechageCharacters;

  /// 复活赛 番剧晋级状况
  final Set<BangumiPollResult> repechageBangumiResult;

  /// 复活赛复活的角色数量
  ///
  /// 也就是前几名可以复活，晋级完结篇
  final int repechagePromoteLimit;

  @override
  String toReport() {
    final mergedBangumiResult =
        mergeBangumiPromoteInfo([finalsBangumiResult, repechageBangumiResult]);

    return '''
<pre>
[align=center][size=5][color=Red][b]${stage.name}晋级角色票数[/b][/color][/size][/align][table=98%]
[tr][td=90][size=3][color=#0000ff]组别[/color][/size][/td][td=109][size=3][color=#0000ff]排名[/color][/size][/td][td=596][size=3][color=#0000ff]角色[/color][/size][/td][td=90][size=3][color=#0000ff]票数[/color][/size][/td][td=162][size=3][color=#0000ff]有效得票[/color][/size][/td][/tr]
[tr][td=1,8][size=3]决赛[/size][/td]${finalsCharacters.map((e) => e.toBBCode()).join('\n[tr]')}
[tr=#fffacd][td=5,1]
[/td][/tr]
[tr][td][size=3][color=#0000ff]组别[/color][/size][/td][td][size=3][color=#0000ff]排名[/color][/size][/td][td][size=3][color=#0000ff]投票项目[/color][/size][/td][td][size=3][color=#0000ff]票数[/color][/size][/td][td][size=3][color=#0000ff]有效得票[/color][/size][/td][/tr]
[tr][td=1,$repechagePromoteLimit][size=3]复活赛[/size][/td]${repechageCharacters.map((e) => e.toBBCode()).join('\n[tr]')}
[/table]

[align=center][b][size=5][color=#ff0000]${stage.name}决赛晋级状况[/color][/size][/b][/align][table=98%]
[tr][td=109][size=3][color=#0000ff]晋级赛事[/color][/size][/td][td=596][size=3][color=#0000ff]角色[/color][/size][/td][td=90][size=3][color=#0000ff]人数[/color][/size][/td][/tr]
[tr][td=1,${finalsBangumiResult.length}][size=3]决赛[/size][/td]${finalsBangumiResult.sortByCharacters().map((e) => e.toReport()).join('\n[tr]')}
[tr=#fffacd][td=3,1]
[/td][/tr]
[tr][td][size=3][color=#0000ff]晋级赛事[/color][/size][/td][td][size=3][color=#0000ff]投票项目[/color][/size][/td][td][size=3][color=#0000ff]人数[/color][/size][/td][/tr]
[tr][td=1,${repechageBangumiResult.length}][size=3]复活赛[/size][/td]${repechageBangumiResult.map((e) => e.toReport()).join('\n[tr]')}
[tr=#fffacd][td=3,1]
[/td][/tr]
[tr][td][size=3][color=#0000ff]晋级赛事[/color][/size][/td][td][size=3][color=#0000ff]角色[/color][/size][/td][td][size=3][color=#0000ff]人数[/color][/size][/td][/tr]
[tr][td=1,${mergedBangumiResult.length}][size=3]完结篇[/size][/td]${mergedBangumiResult.map((e) => e.toReport()).join('\n[tr]')}
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
