/// Functionality of report.
// ignore: one_member_abstracts
abstract interface class BaseReport {
  /// Convert to bbcode report.
  String toReport();
}

/// 完结篇战报
abstract interface class EndingsReport implements BaseReport {
  /// Promotion statistics, generated in current round and used in next round.
  String toPromoteReport();
}
