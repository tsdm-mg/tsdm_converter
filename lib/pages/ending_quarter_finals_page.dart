import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/ending_quarter_report.dart';
import 'package:tsdm_converter/pages/report_page.dart';
import 'package:tsdm_converter/widgets/group_form.dart';

enum _Group {
  a,
  b,
  c,
  d,
}

/// 四分之一决赛
///
/// 仅仅生成战报
class EndingQuarterFinalsPage extends StatefulWidget {
  /// Constructor.
  const EndingQuarterFinalsPage({super.key});

  @override
  State<EndingQuarterFinalsPage> createState() =>
      _EndingQuarterFinalsPageState();
}

class _EndingQuarterFinalsPageState extends State<EndingQuarterFinalsPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  final _data = <_Group, List<CharacterPollResult>>{};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('完结篇 四分之一决赛战报')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            GroupForm(
              groupName: '第1组',
              key: const ValueKey('A'),
              onSave: (characters) => _data[_Group.a] = characters,
            ),
            const SizedBox(height: 8),
            GroupForm(
              groupName: '第2组',
              key: const ValueKey('B'),
              onSave: (characters) => _data[_Group.b] = characters,
            ),
            const SizedBox(height: 8),
            GroupForm(
              groupName: '第3组',
              key: const ValueKey('C'),
              onSave: (characters) => _data[_Group.c] = characters,
            ),
            const SizedBox(height: 8),
            GroupForm(
              groupName: '第4组',
              key: const ValueKey('D'),
              onSave: (characters) => _data[_Group.d] = characters,
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

          final result = EndingQuarterReport.build(
            groupAPolls: _data[_Group.a]!,
            groupBPolls: _data[_Group.b]!,
            groupCPolls: _data[_Group.c]!,
            groupDPolls: _data[_Group.d]!,
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
