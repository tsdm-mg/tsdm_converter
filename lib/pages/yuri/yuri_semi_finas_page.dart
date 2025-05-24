import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/raw/raw_poll_result.dart';
import 'package:tsdm_converter/models/report/yuri_semi_finals_report.dart';
import 'package:tsdm_converter/utils/copy_clipboard.dart';

/// 百合表演赛 半决赛
class YuriSemiFinalsPage extends StatefulWidget {
  /// Constructor.
  const YuriSemiFinalsPage({super.key});

  @override
  State<YuriSemiFinalsPage> createState() => _YuriSemiFinalsPageState();
}

class _YuriSemiFinalsPageState extends State<YuriSemiFinalsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _groupAController;
  late TextEditingController _groupBController;

  Future<void> _generateReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final groupA = _groupAController.text
        .split('\n')
        .map(RawPollResult.parse)
        .whereType<RawPollResult>()
        .map(CharacterPollResult.fromRaw)
        .toList();
    final groupB = _groupBController.text
        .split('\n')
        .map(RawPollResult.parse)
        .whereType<RawPollResult>()
        .map(CharacterPollResult.fromRaw)
        .toList();

    final report = YuriSemiFinalsReport.build(
      promoteLimit: 2,
      groupAPoll: groupA,
      groupBPoll: groupB,
    );

    await copyToClipboard(context, report.toReport());
  }

  @override
  void initState() {
    super.initState();
    _groupAController = TextEditingController();
    _groupBController = TextEditingController();
  }

  @override
  void dispose() {
    _groupAController.dispose();
    _groupBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百合表演赛 半决赛'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              SizedBox(
                width: 160,
                child: Column(
                  children: [
                    TextButton(
                      child: Text('生成战报'),
                      onPressed: () async => _generateReport(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 200,
                  ),
                  children: [
                    TextFormField(
                      controller: _groupAController,
                      decoration: const InputDecoration(
                          labelText: '半决赛A组', floatingLabelBehavior: FloatingLabelBehavior.always),
                      expands: true,
                      maxLines: null,
                    ),
                    TextFormField(
                      controller: _groupBController,
                      decoration: const InputDecoration(
                          labelText: '半决赛B组', floatingLabelBehavior: FloatingLabelBehavior.always),
                      expands: true,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
