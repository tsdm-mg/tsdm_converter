/// 萌战阶段
enum Stage {
  /// 冬季篇
  winter,

  /// 春季篇
  spring,

  /// 夏季篇
  summer,

  /// 秋季篇
  autumn,

  /// 完结篇
  coda;

  /// Get the name of stage.
  String get name => switch (this) {
        Stage.winter => '冬季篇',
        Stage.spring => '春季篇',
        Stage.summer => '夏季篇',
        Stage.autumn => '秋季篇',
        Stage.coda => '完结篇',
      };
}
