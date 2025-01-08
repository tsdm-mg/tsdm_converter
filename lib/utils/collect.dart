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
        );
      } else {
        mergedPoll[p.name] = BangumiPollResult(
          name: p.name,
          characters: p.characters,
        );
      }
    }
  }

  return mergedPoll.values.sortByCharacters().toList();
}
