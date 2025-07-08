import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/season_preliminary_report.dart';
import 'package:tsdm_converter/pages/report_page.dart';
import 'package:tsdm_converter/widgets/group_form.dart';

/// 季节篇初赛
class SeasonPreliminaryPage extends StatefulWidget {
  /// Constructor.
  const SeasonPreliminaryPage({super.key});

  @override
  State<SeasonPreliminaryPage> createState() => _SeasonPreliminaryPageState();
}

class _SeasonPreliminaryPageState extends State<SeasonPreliminaryPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _groupAController;
  late TextEditingController _groupBController;
  late TextEditingController _groupCController;
  late TextEditingController _groupDController;

  List<CharacterPollResult> _groupAResult = [];
  List<CharacterPollResult> _groupBResult = [];
  List<CharacterPollResult> _groupCResult = [];
  List<CharacterPollResult> _groupDResult = [];

  Stage _stage = Stage.winter;

  @override
  void initState() {
    super.initState();
    _groupAController = TextEditingController();
    _groupBController = TextEditingController();
    _groupCController = TextEditingController();
    _groupDController = TextEditingController();
  }

  @override
  void dispose() {
    _groupAController.dispose();
    _groupBController.dispose();
    _groupCController.dispose();
    _groupDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('季节篇初赛'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              // Left control column.
              SizedBox(
                width: 160,
                child: Column(
                  children: [
                    ...[Stage.winter, Stage.spring, Stage.summer, Stage.autumn].map(
                      (e) => RadioListTile(
                        title: Text(e.name),
                        value: e,
                        groupValue: _stage,
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }
                          setState(() => _stage = v);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Right side content column.
              Expanded(
                child: ListView(
                  cacheExtent: 10000,
                  children: [
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '半决赛A组',
                      key: const ValueKey('GroupA'),
                      onSave: (characters) => _groupAResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '半决赛B组',
                      key: const ValueKey('GroupB'),
                      onSave: (characters) => _groupBResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '半决赛C组',
                      key: const ValueKey('GroupC'),
                      onSave: (characters) => _groupCResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '半决赛D组',
                      key: const ValueKey('GroupD'),
                      onSave: (characters) => _groupDResult = characters,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.flash_on_outlined),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          final result = SeasonPreliminaryReport.build(
            stage: _stage,
            groupAPoll: _groupAResult,
            groupBPoll: _groupBResult,
            groupCPoll: _groupCResult,
            groupDPoll: _groupDResult,
          );

          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ReportPage(
                report: result.toReport(),
                promoteReport: result.toReport(),
              ),
            ),
          );
        },
      ),
    );
  }
}
