import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/ending_semi_finals_report.dart';
import 'package:tsdm_converter/pages/report_page.dart';
import 'package:tsdm_converter/widgets/group_form.dart';

enum _Group {
  semiFinalsA,
  semiFinalsB,
  qualifyingFirst,
}

/// 完结篇半决赛
///
/// 第三轮，包含半决赛和排位赛第一场
///
/// 仅仅生成战报
class EndingSemiFinalsPage extends StatefulWidget {
  /// Constructor.
  const EndingSemiFinalsPage({super.key});

  @override
  State<EndingSemiFinalsPage> createState() => _EndingSemiFinalsPageState();
}

class _EndingSemiFinalsPageState extends State<EndingSemiFinalsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quartarPromoteController;

  final _data = <_Group, List<CharacterPollResult>>{};

  @override
  void initState() {
    super.initState();
    _quartarPromoteController = TextEditingController();
  }

  @override
  void dispose() {
    _quartarPromoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('完结篇 半决赛战报')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            GroupForm(
              groupName: '半决赛第1组',
              key: const ValueKey('SemiFinalsA'),
              onSave: (characters) => _data[_Group.semiFinalsA] = characters,
            ),
            const SizedBox(height: 8),
            GroupForm(
              groupName: '半决赛第2组',
              key: const ValueKey('SemiFinalsB'),
              onSave: (characters) => _data[_Group.semiFinalsB] = characters,
            ),
            const SizedBox(height: 8),
            GroupForm(
              groupName: '排位赛第一场',
              key: const ValueKey('QualifyingFirst'),
              onSave: (characters) =>
                  _data[_Group.qualifyingFirst] = characters,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _quartarPromoteController,
              decoration: const InputDecoration(
                labelText: '上一轮晋级状况',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              maxLines: null,
              minLines: 7,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.flash_on_outlined),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          final result = EndingSemiFinalsReport.build(
            groupSemiFinalsAPolls: _data[_Group.semiFinalsA]!,
            groupSemiFinalsBPolls: _data[_Group.semiFinalsB]!,
            groupQualifyingFirstPolls: _data[_Group.qualifyingFirst]!,
            quarterPromoteResult: _quartarPromoteController.text.trim(),
          );

          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ReportPage(
                report: result.toReport(),
                promoteReport: result.toPromoteReport(),
              ),
            ),
          );
        },
      ),
    );
  }
}
