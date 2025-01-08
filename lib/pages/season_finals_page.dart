import 'package:flutter/material.dart';
import 'package:tsdm_converter/constants/constants.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/raw/raw_poll_result.dart';
import 'package:tsdm_converter/models/report/season_finals_report.dart';
import 'package:tsdm_converter/utils/copy_clipboard.dart';
import 'package:tsdm_converter/utils/show_snack_bar.dart';
import 'package:tsdm_converter/widgets/section_title.dart';

/// 季节篇决赛
class SeasonFinalsPage extends StatefulWidget {
  /// Constructor.
  const SeasonFinalsPage({super.key});

  @override
  State<SeasonFinalsPage> createState() => _SeasonFinalsPageState();
}

class _SeasonFinalsPageState extends State<SeasonFinalsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _finalsController;
  late TextEditingController _repechageController;
  late TextEditingController _reportController;
  late TextEditingController _repechagePromoteLimitController;

  Stage _stage = Stage.winter;

  void _generateReport() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final finals = _finalsController.text
        .split('\n')
        .map(RawPollResult.parse)
        .whereType<RawPollResult>()
        .map(CharacterPollResult.fromRaw);
    final repechage = _repechageController.text
        .split('\n')
        .map(RawPollResult.parse)
        .whereType<RawPollResult>()
        .map(CharacterPollResult.fromRaw);
    final repechagePromoteLimit =
        int.parse(_repechagePromoteLimitController.text);

    if (finals.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('决赛投票结果无效')));
      return;
    }
    if (repechage.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('复活赛投票结果无效')));
      return;
    }

    final calculated = SeasonFinalsReport.build(
      _stage,
      repechagePromoteLimit,
      finals.toList(),
      repechage.toList(),
    );

    setState(() {
      _reportController.text = calculated.toReport();
    });

    showSnackBar(
      context: context,
      message: '已生成战报',
    );
  }

  @override
  void initState() {
    super.initState();
    _finalsController = TextEditingController();
    _repechageController = TextEditingController();
    _reportController = TextEditingController();
    _repechagePromoteLimitController = TextEditingController(text: '4');
  }

  @override
  void dispose() {
    _finalsController.dispose();
    _repechageController.dispose();
    _reportController.dispose();
    _repechagePromoteLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  ...[Stage.winter, Stage.spring, Stage.summer, Stage.autumn]
                      .map(
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _repechagePromoteLimitController,
                    decoration: const InputDecoration(labelText: '复活赛晋级角色数'),
                    validator: (v) {
                      if (v == null) {
                        return kInvalidValue;
                      }

                      final vv = int.tryParse(v);
                      if (vv == null || vv < 1) {
                        return kInvalidValue;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: FilledButton(
                          onPressed: _generateReport,
                          child: const Text('生成战报'),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () async => copyToClipboard(
                            context,
                            _reportController.text,
                          ),
                          child: const Text('复制战报'),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Right side content column.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '输入投票结果，计算决赛战报',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Input
                  const SectionTitle('投票结果'),
                  const SizedBox(height: 8),
                  Flexible(
                    child: TextField(
                      controller: _finalsController,
                      decoration: const InputDecoration(
                        labelText: '决赛投票结果',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      maxLines: null,
                      minLines: 7,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: TextField(
                      controller: _repechageController,
                      decoration: const InputDecoration(
                        labelText: '复活赛投票结果',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      maxLines: null,
                      minLines: 7,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Output
                  const SectionTitle('决赛战报'),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _reportController,
                      readOnly: true,
                      maxLines: null,
                      minLines: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
