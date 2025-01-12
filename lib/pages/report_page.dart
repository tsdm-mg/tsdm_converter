import 'package:flutter/material.dart';
import 'package:tsdm_converter/utils/copy_clipboard.dart';

/// 复制战报
class ReportPage extends StatefulWidget {
  /// Constructor.
  const ReportPage({
    required this.report,
    required this.promoteReport,
    super.key,
  });

  /// 完整战报
  final String report;

  /// 本轮次晋级情况，用于复制到下一轮中
  final String promoteReport;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late TextEditingController _reportController;
  late TextEditingController _promoteController;

  @override
  void initState() {
    super.initState();
    _reportController = TextEditingController(text: widget.report);
    _promoteController = TextEditingController(text: widget.promoteReport);
  }

  @override
  void dispose() {
    _reportController.dispose();
    _promoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('完结篇 四分之一决赛战报 结果'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          spacing: 4,
          children: [
            // Report
            Expanded(
              child: Column(
                spacing: 12,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _reportController,
                      decoration: const InputDecoration(
                        labelText: '完整战报',
                      ),
                      maxLines: null,
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('复制完整战报'),
                    onPressed: () async =>
                        copyToClipboard(context, widget.report),
                  ),
                ],
              ),
            ),

            // Group report
            Expanded(
              child: Column(
                spacing: 12,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoteController,
                      decoration: const InputDecoration(
                        labelText: '晋级状况（用于下阶段战报）',
                      ),
                      maxLines: null,
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('复制晋级状况'),
                    onPressed: () async =>
                        copyToClipboard(context, widget.promoteReport),
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
