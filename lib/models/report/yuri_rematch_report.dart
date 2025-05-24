import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/base.dart';
import 'package:tsdm_converter/utils/collect.dart';

/// 百合表演赛 复赛
final class YuriRematchReport implements BaseReport {
  /// Constructor.
  const YuriRematchReport._({
    required this.groupACharacters,
    required this.groupBCharacters,
    required this.groupCCharacters,
    required this.groupDCharacters,
    required this.semiFinalsBangumiResult,
    required this.promoteLimit,
  });

  /// Instance builder.
  factory YuriRematchReport.build({
    required int promoteLimit,
    required List<CharacterPollResult> groupAPoll,
    required List<CharacterPollResult> groupBPoll,
    required List<CharacterPollResult> groupCPoll,
    required List<CharacterPollResult> groupDPoll,
  }) {
    // 生成复赛每个分组的晋级角色名单
    final rematchACharacters = groupAPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();
    final rematchBCharacters = groupBPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();
    final rematchCCharacters = groupCPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();
    final rematchDCharacters = groupDPoll.takeWhile((e) => int.parse(e.ranking) <= promoteLimit).toList();

    // 生成复赛每个分组的番剧情况名单
    final groupAResult = collectBangumiInfo(rematchACharacters);
    final groupBResult = collectBangumiInfo(rematchBCharacters);
    final groupCResult = collectBangumiInfo(rematchCCharacters);
    final groupDResult = collectBangumiInfo(rematchDCharacters);
    // 生成复赛整个的番剧晋级情况名单
    final semiFinalsBangumiResult = mergeBangumiPromoteInfo([groupAResult, groupBResult, groupCResult, groupDResult]);

    return YuriRematchReport._(
      groupACharacters: groupAPoll,
      groupBCharacters: groupBPoll,
      groupCCharacters: groupCPoll,
      groupDCharacters: groupDPoll,
      semiFinalsBangumiResult: semiFinalsBangumiResult,
      promoteLimit: promoteLimit,
    );
  }

  /// A组投票结果
  final List<CharacterPollResult> groupACharacters;

  /// B组投票结果
  final List<CharacterPollResult> groupBCharacters;

  /// C组投票结果
  final List<CharacterPollResult> groupCCharacters;

  /// D组投票结果
  final List<CharacterPollResult> groupDCharacters;

  /// 半决赛 番剧晋级状况
  final List<BangumiPollResult> semiFinalsBangumiResult;

  /// 晋级名额
  final int promoteLimit;

  @override
  String toReport() {
    final allResult = mergeBangumiPromoteInfo([
      collectBangumiInfo(groupACharacters),
      collectBangumiInfo(groupBCharacters),
      collectBangumiInfo(groupCCharacters),
      collectBangumiInfo(groupDCharacters),
    ]);

    final rematchResultWithPromoteInfo = calculateBangumiPromoteCount(
      promoted: semiFinalsBangumiResult,
      all: allResult,
    );

    final content = [
      ('A组', groupACharacters),
      ('B组', groupBCharacters),
      ('C组', groupCCharacters),
      ('D组', groupDCharacters)
    ]
        .map((e) => '''[tr][td=5,1,965][size=3][color=#ffa500][b]${e.$1}[/b][/color][/size][/td][/tr]
[tr][td]排名[/td][td]角色[/td][td]得票[/td][td]有效得票[/td][td]晋级情况[/td][/tr]
${e.$2.map((ch) => '[tr][td]${ch.ranking}[/td][td]${ch.name + "@" + ch.bangumi}[/td][td]${ch.all}[/td][td]${ch.effective}[/td][td]${int.parse(ch.ranking) <= this.promoteLimit ? "半决赛" : "淘汰"}[/td][/tr]').join("\n")}''')
        .join('\n');

    return '''
[b][color=Red][size=5][align=center][b]2025天使动漫萌战 百合表演赛复赛票数统计[/b][/align][/size][/color][/b][table=98%]
$content
[/table]

[align=center][b][color=Red][size=5]2025天使动漫萌战 百合表演赛复赛晋级状况统计[/size][/color][/b][/align][table=98%]
[tr][td=202][size=2][color=#0000ff]晋级赛事[/color][/size][/td][td=488][size=2][color=#0000ff]动画[/color][/size][/td][td=69][size=2][color=#0000ff]人数[/color][/size][/td][/tr]
[tr][td=1,${rematchResultWithPromoteInfo.length}]半决赛[/td]${rematchResultWithPromoteInfo.map((e) => e.toReport()).join('\n[tr]')}
[/table]
''';
  }
}
