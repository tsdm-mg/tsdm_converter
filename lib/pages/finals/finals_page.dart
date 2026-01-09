import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/stages/ending/preliminary/models.dart';
import 'package:tsdm_converter/pages/finals/finals_data_import_page.dart';
import 'package:tsdm_converter/utils/copy_clipboard.dart';
import 'package:tsdm_converter/utils/show_dialog.dart';

/// 完结篇
class FinalsPage extends StatefulWidget {
  /// Constructor.
  const FinalsPage({super.key});

  @override
  State<FinalsPage> createState() => _FinalsPageState();
}

class _FinalsPageState extends State<FinalsPage> {
  late PageController _pageController;

  /// Completed process percentage.
  final double _process = 0;

  EndingPreliminaryInfo _info = EndingPreliminaryInfo.empty;

  String _infoToString() {
    const encoder = JsonEncoder.withIndent('  ');
    final obj = jsonDecode(_info.toJson());
    return encoder.convert(obj);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('完结篇')),
      body: Row(
        children: [
          // Control column
          ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Column(
              spacing: 20,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('导出完整数据'),
                  onPressed: () async {
                    await copyToClipboard(context, _infoToString());
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_outlined),
                  label: const Text('导入完整数据'),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result == null) {
                      return;
                    }
                    final f =
                        await File(result.files.single.path!).readAsString();

                    if (!context.mounted) {
                      return;
                    }

                    try {
                      final x = EndingPreliminaryInfoMapper.fromJson(f);
                      setState(() {
                        _info = x;
                      });

                      // Fine to catch all.
                      // ignore: avoid_catches_without_on_clauses
                    } catch (e) {
                      await showMessageSingleButtonDialog(
                        context: context,
                        title: '导入失败',
                        message: '$e',
                      );
                    }
                  },
                ),
                ElevatedButton(
                  child: const Text('打印'),
                  onPressed: () async => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Data'),
                      content: SingleChildScrollView(
                        child: Text(_infoToString()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      FinalsDataImportPage(
                        initialValue: _info.groups,
                        onImported: (groups) => setState(
                          () => _info = _info.copyWith(groups: groups),
                        ),
                      ),
                      const Text('2'),
                      const Text('3'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        throw UnimplementedError();
                      },
                      child: const Text('下一步'),
                    ),
                  ],
                ),
                LinearProgressIndicator(
                  value: _process,
                  minHeight: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
