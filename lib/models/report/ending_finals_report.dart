import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/ending/models.dart';
import 'package:tsdm_converter/models/report/base.dart';

/// 决赛战报
///
/// 包含决赛和排位赛第二场
final class EndingFinalsReport implements EndingsReport {
  /// Constructor.
  const EndingFinalsReport._({
    required this.groupFinals,
    required this.groupQualifyingSecond,
    required this.semiPromoteResult,
  });

  /// Build an instance.
  factory EndingFinalsReport.build({
    required List<CharacterPollResult> groupFinalPolls,
    required List<CharacterPollResult> groupQualifyingSecondPolls,
    required String semiPromoteResult,
  }) {
    final finalsPolls = groupFinalPolls.sortedByEffective();
    final qualifyingSecondPolls =
        groupQualifyingSecondPolls.sortedByEffective();

    return EndingFinalsReport._(
      groupFinals: EndingFinalsPromoteResult(
        groupName: '总决赛',
        pinnedThe1st: finalsPolls.first,
        pinnedThe2nd: finalsPolls.elementAt(1),
      ),
      groupQualifyingSecond: EndingQualifyingSecondPromoteResult(
        groupName: '排位赛第二场',
        pinnedThe3rd: qualifyingSecondPolls.first,
        pinnedThe4th: qualifyingSecondPolls.elementAt(1),
        pinnedThe5th: qualifyingSecondPolls.elementAt(2),
      ),
      semiPromoteResult: semiPromoteResult,
    );
  }

  /// 决赛晋级结果
  final EndingFinalsPromoteResult groupFinals;

  /// 排位赛第二场晋级结果
  final EndingQualifyingSecondPromoteResult groupQualifyingSecond;

  /// 半决赛晋级状况
  final String semiPromoteResult;

  String _generateFinalsStatistics() {
    return '''
[align=center][b][size=5][color=#ff0000]完结篇总决赛角色票数[/color][/size][/b][/align][table=98%]
[tr][td=55][b][size=3][color=#4169e1]组别[/color][/size][/b][/td][td=55][b][size=3][color=#4169e1]排名[/color][/size][/b][/td][td][b][size=3][color=#4169e1]角色[/color][/size][/b][/td][td=80][b][size=3][color=#4169e1]票数[/color][/size][/b][/td][td=80][b][size=3][color=#4169e1]有效票数[/color][/size][/b][/td][/tr]
[tr=rgb(173, 216, 230)][td=5,1]
[/td][/tr]
[tr][td=1,2]总决赛[/td]${groupFinals.pinnedThe1st.copyWith(ranking: '萌王').toBBCode()}
[tr]${groupFinals.pinnedThe2nd.copyWith(ranking: '准萌').toBBCode()}
[/table]
''';
  }

  String _generateQualifyingSecondStatistics() {
    return '''
[align=center][b][size=5][color=#ff0000]排位赛第二场角色票数[/color][/size][/b][/align][table=98%]
[tr][td=55][b][size=3][color=#4169e1]组别[/color][/size][/b][/td][td=55][b][size=3][color=#4169e1]排名[/color][/size][/b][/td][td][b][size=3][color=#4169e1]角色[/color][/size][/b][/td][td=80][b][size=3][color=#4169e1]票数[/color][/size][/b][/td][td=80][b][size=3][color=#4169e1]有效票数[/color][/size][/b][/td][/tr]
[tr=rgb(173, 216, 230)][td=5,1]
[/td][/tr]
[tr][td=1,3]排位赛第二场[/td]${groupQualifyingSecond.pinnedThe3rd.copyWith(ranking: '季军').toBBCode()}
[tr]${groupQualifyingSecond.pinnedThe4th.copyWith(ranking: '殿军').toBBCode()}
[tr]${groupQualifyingSecond.pinnedThe5th.copyWith(ranking: '第五').toBBCode()}
[/table]
''';
  }

  @override
  String toPromoteReport() =>
      throw UnimplementedError('finals do not have next round');

  @override
  String toReport() {
    return '''
${_generateFinalsStatistics()}
${_generateQualifyingSecondStatistics()}
''';
  }
}
