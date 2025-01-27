import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/ending_finals_report.dart';
import 'package:tsdm_converter/pages/report_page.dart';
import 'package:tsdm_converter/widgets/group_form.dart';

/// 分组
enum _Group {
  /// 决赛
  finals,

  /// 排位赛第二场
  qualifyingSecond,
}

/// 完结篇决赛
class EndingFinalsPage extends StatefulWidget {
  /// Constructor.
  const EndingFinalsPage({super.key});

  @override
  State<EndingFinalsPage> createState() => _EndingFinalsPageState();
}

class _EndingFinalsPageState extends State<EndingFinalsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _semiPromoteController;

  final _data = <_Group, List<CharacterPollResult>>{};

  @override
  void initState() {
    super.initState();
    _semiPromoteController = TextEditingController();
  }

  @override
  void dispose() {
    _semiPromoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('完结篇 决赛战报')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            GroupForm(
              groupName: '决赛',
              key: const ValueKey('SemiFinalsA'),
              onSave: (characters) => _data[_Group.finals] = characters,
            ),
            const SizedBox(height: 8),
            GroupForm(
              groupName: '排位赛第二场',
              key: const ValueKey('SemiFinalsB'),
              onSave: (characters) =>
                  _data[_Group.qualifyingSecond] = characters,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _semiPromoteController,
              decoration: const InputDecoration(
                labelText: '半决赛战报',
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

          final result = EndingFinalsReport.build(
            groupFinalPolls: _data[_Group.finals]!,
            groupQualifyingSecondPolls: _data[_Group.qualifyingSecond]!,
            semiPromoteResult: _semiPromoteController.text.trim(),
          );

          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ReportPage(
                report: result.toReport(),
                promoteReport: '',
              ),
            ),
          );
        },
      ),
    );
  }
}
