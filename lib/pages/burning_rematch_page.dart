import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/burning_rematch_report.dart';
import 'package:tsdm_converter/pages/report_page.dart';
import 'package:tsdm_converter/widgets/group_form.dart';

/// 燃战复赛
class BurningRematchPage extends StatefulWidget {
  /// Constructor.
  const BurningRematchPage({super.key});

  @override
  State<BurningRematchPage> createState() => _BurningRematchPageState();
}

class _BurningRematchPageState extends State<BurningRematchPage> {
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
        title: const Text('星耀复赛'),
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
                      groupName: '复赛A组',
                      key: const ValueKey('GroupA'),
                      onSave: (characters) => _groupAResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '复赛B组',
                      key: const ValueKey('GroupB'),
                      onSave: (characters) => _groupBResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '复赛C组',
                      key: const ValueKey('GroupC'),
                      onSave: (characters) => _groupCResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '复赛D组',
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

          final result = BurningRematchReport.build(
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
