import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/raw/raw_poll_result.dart';
import 'package:tsdm_converter/models/report/yuri_rematch_report.dart';
import 'package:tsdm_converter/utils/copy_clipboard.dart';

/// 百合表演赛 复赛
class YuriRematchPage extends StatefulWidget {
  /// Constructor.
  const YuriRematchPage({super.key});

  @override
  State<YuriRematchPage> createState() => _YuriRematchPageState();
}

class _YuriRematchPageState extends State<YuriRematchPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _groupAController;
  late TextEditingController _groupBController;
  late TextEditingController _groupCController;
  late TextEditingController _groupDController;

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
    final groupC = _groupCController.text
        .split('\n')
        .map(RawPollResult.parse)
        .whereType<RawPollResult>()
        .map(CharacterPollResult.fromRaw)
        .toList();
    final groupD = _groupDController.text
        .split('\n')
        .map(RawPollResult.parse)
        .whereType<RawPollResult>()
        .map(CharacterPollResult.fromRaw)
        .toList();

    final report = YuriRematchReport.build(
      promoteLimit: 3,
      groupAPoll: groupA,
      groupBPoll: groupB,
      groupCPoll: groupC,
      groupDPoll: groupD,
    );

    await copyToClipboard(context, report.toReport());
  }

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
        title: const Text('百合表演赛 复赛'),
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
                      child: const Text('生成战报'),
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
                      decoration:
                          const InputDecoration(labelText: '复赛A组', floatingLabelBehavior: FloatingLabelBehavior.always),
                      expands: true,
                      maxLines: null,
                    ),
                    TextFormField(
                      controller: _groupBController,
                      decoration:
                          const InputDecoration(labelText: '复赛B组', floatingLabelBehavior: FloatingLabelBehavior.always),
                      expands: true,
                      maxLines: null,
                    ),
                    TextFormField(
                      controller: _groupCController,
                      decoration:
                          const InputDecoration(labelText: '复赛C组', floatingLabelBehavior: FloatingLabelBehavior.always),
                      expands: true,
                      maxLines: null,
                    ),
                    TextFormField(
                      controller: _groupDController,
                      decoration:
                          const InputDecoration(labelText: '复赛D组', floatingLabelBehavior: FloatingLabelBehavior.always),
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
