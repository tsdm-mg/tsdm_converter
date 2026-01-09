import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/raw/raw_poll_result.dart';
import 'package:tsdm_converter/models/report/yuri_finals_report.dart';
import 'package:tsdm_converter/utils/copy_clipboard.dart';

/// 百合表演赛 总决赛
class YuriFinalsPage extends StatefulWidget {
  /// Constructor.
  const YuriFinalsPage({super.key});

  @override
  State<YuriFinalsPage> createState() => _YuriFinalsPageState();
}

class _YuriFinalsPageState extends State<YuriFinalsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _controller;

  Future<void> _generateReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final poll = _controller.text
        .split('\n')
        .map(RawPollResult.parse)
        .whereType<RawPollResult>()
        .map(CharacterPollResult.fromRaw)
        .toList();

    final report = YuriFinalsReport.build(poll: poll);
    await copyToClipboard(context, report.toReport());
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('百合表演赛 总决赛'),
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
                      controller: _controller,
                      decoration:
                          const InputDecoration(labelText: '总决赛', floatingLabelBehavior: FloatingLabelBehavior.always),
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
