import 'package:flutter/material.dart';
import 'package:tsdm_converter/pages/ending_quarter_finals_page.dart';
import 'package:tsdm_converter/pages/ending_semi_finals_page.dart';
import 'package:tsdm_converter/pages/finals/finals_page.dart';

class _Target {
  const _Target(
    this.name,
    this.builder,
  );

  final String name;

  final WidgetBuilder builder;
}

final _targets = [
  _Target('完结篇', (_) => const FinalsPage()),
  _Target('完结篇\n四分之一决赛战报', (_) => const EndingQuarterFinalsPage()),
  _Target('完结篇\n半决赛战报', (_) => const EndingSemiFinalsPage()),
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
                  onTap: () async => Navigator.of(context)
                      .push(MaterialPageRoute(builder: e.builder)),
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
