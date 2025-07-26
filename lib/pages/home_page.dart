import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/report/starlight_rematch_report.dart';
import 'package:tsdm_converter/pages/ending_finals_page.dart';
import 'package:tsdm_converter/pages/ending_quarter_finals_page.dart';
import 'package:tsdm_converter/pages/ending_semi_finals_page.dart';
import 'package:tsdm_converter/pages/finals/finals_page.dart';
import 'package:tsdm_converter/pages/season_finals_page.dart';
import 'package:tsdm_converter/pages/season_preliminary_page.dart';
import 'package:tsdm_converter/pages/starlight_preliminary_page.dart';
import 'package:tsdm_converter/pages/starlight_rematch_page.dart';
import 'package:tsdm_converter/pages/yuri/yuri_finals_page.dart';
import 'package:tsdm_converter/pages/yuri/yuri_preliminary_page.dart';
import 'package:tsdm_converter/pages/yuri/yuri_rematch_page.dart';
import 'package:tsdm_converter/pages/yuri/yuri_semi_finas_page.dart';

class _Target {
  const _Target(
    this.name,
    this.builder,
  );

  final String name;

  final WidgetBuilder builder;
}

final _targets = [
  _Target('季节篇初赛', (_) => const SeasonPreliminaryPage()),
  _Target('季节篇决赛', (_) => const SeasonFinalsPage()),
  _Target('完结篇', (_) => const FinalsPage()),
  _Target('完结篇\n四分之一决赛战报', (_) => const EndingQuarterFinalsPage()),
  _Target('完结篇\n半决赛战报', (_) => const EndingSemiFinalsPage()),
  _Target('完结篇\n决赛战报', (_) => const EndingFinalsPage()),
  _Target('百合表演赛\n初赛', (_) => const YuriPreliminaryPage()),
  _Target('百合表演赛\n复赛', (_) => const YuriRematchPage()),
  _Target('百合表演赛\n半决赛', (_) => const YuriSemiFinalsPage()),
  _Target('百合表演赛\n总决赛', (_) => const YuriFinalsPage()),
  _Target('星耀初赛', (_) => const StarlightPreliminaryPage()),
  _Target('星耀复赛', (_) => const StarlightRematchPage()),
];

/// Home of app.
class HomePage extends StatefulWidget {
  /// Constructor.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 200,
        ),
        children: _targets
            .map(
              (e) => Card(
                child: InkWell(
                  onTap: () async => Navigator.of(context).push(MaterialPageRoute(builder: e.builder)),
                  child: Center(
                    child: Text(
                      e.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
