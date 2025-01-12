import 'package:tsdm_converter/models/common/models.dart';

/// Collect bangumi poll result info from a set of characters poll result
/// [poll].
List<BangumiPollResult> collectBangumiInfo(List<CharacterPollResult> poll) =>
    poll
        .fold(<String, List<CharacterPollResult>>{}, (acc, e) {
          final key = e.bangumi;
          if (acc.containsKey(key)) {
            acc[key]!.add(e);
          } else {
            acc[key] = [e];
          }
          return acc;
        })
        .values
        .map(BangumiPollResult.fromList)
        .toList();

/// Merge two bangumi promote result and sort with characters count.
List<BangumiPollResult> mergeBangumiPromoteInfo(
  List<List<BangumiPollResult>> polls,
) {
  final mergedPoll = <String, BangumiPollResult>{};

  for (final poll in polls) {
    for (final p in poll) {
      if (mergedPoll.containsKey(p.name)) {
        mergedPoll[p.name] = BangumiPollResult(
          name: p.name,
          characters: {...mergedPoll[p.name]!.characters, ...p.characters},
          effective: p.effective,
          all: p.all,
        );
      } else {
        mergedPoll[p.name] = BangumiPollResult(
          name: p.name,
          characters: p.characters,
          effective: p.effective,
          all: p.all,
        );
      }
    }
  }

  return mergedPoll.values.sortByCharacters().toList();
}

/// 计算番剧的角色晋级数目
///
/// 会把一个值赋给[BangumiPollResult]的`promotedCount`字段。
/// 用于生成战报中最后一列的人数的格式"x/y"，其中x是流下某一下一步骤的角色的数量，y是番剧角色
/// 总数
///
/// 调用者必须保证[all]包含[promoted]中所有的同名番剧
///
/// 用法：
///
/// * 计算晋级到半决赛的角色的数量：[promoted]填晋级到半决赛的那些角色组成的report list，
///   同时[all]填写参加当前轮次的所有角色组成的report list
/// * 计算获得最终第9名成绩的角色的数量：[promoted]填拿到最终第9名的那些角色组成的
///   report list，
///   同时[all]填写参加当前轮次的所有角色组成的report list
List<BangumiPollResult> calculateBangumiPromoteCount({
  required List<BangumiPollResult> promoted,
  required List<BangumiPollResult> all,
}) {
  final mergedResult = Map.fromEntries(all.map((e) => MapEntry(e.name, e)));
  for (final p in promoted) {
    if (mergedResult.containsKey(p.name)) {
      mergedResult[p.name] =
          mergedResult[p.name]!.copyWith(promotedCount: p.charactersCount);
    } else {
      // all里不存在时当作全部晋级
      mergedResult[p.name] = p.copyWith(promotedCount: p.charactersCount);
    }
  }

  return mergedResult.values.sortByCharacters().toList();
}
