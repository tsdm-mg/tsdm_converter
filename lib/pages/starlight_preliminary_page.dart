import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/starlight_preliminary_report.dart';
import 'package:tsdm_converter/pages/report_page.dart';
import 'package:tsdm_converter/widgets/group_form.dart';

/// 星耀初赛
class StarlightPreliminaryPage extends StatefulWidget {
  /// Constructor.
  const StarlightPreliminaryPage({super.key});

  @override
  State<StarlightPreliminaryPage> createState() => _StarlightPreliminaryPageState();
}

class _StarlightPreliminaryPageState extends State<StarlightPreliminaryPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _groupAController;
  late TextEditingController _groupBController;
  late TextEditingController _groupCController;
  late TextEditingController _groupDController;

  List<CharacterPollResult> _groupAResult = [];
  List<CharacterPollResult> _groupBResult = [];
  List<CharacterPollResult> _groupCResult = [];
  List<CharacterPollResult> _groupDResult = [];

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
        title: const Text('星耀初赛'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Form(
          key: _formKey,
          child: ListView(
                  cacheExtent: 10000,
                  children: [
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '初赛A组',
                      key: const ValueKey('GroupA'),
                      onSave: (characters) => _groupAResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '初赛B组',
                      key: const ValueKey('GroupB'),
                      onSave: (characters) => _groupBResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '初赛C组',
                      key: const ValueKey('GroupC'),
                      onSave: (characters) => _groupCResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '初赛D组',
                      key: const ValueKey('GroupD'),
                      onSave: (characters) => _groupDResult = characters,
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

          final result = StarlightPreliminaryReport.build(
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
