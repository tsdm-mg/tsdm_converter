import 'package:flutter/material.dart';
import 'package:tsdm_converter/pages/finals/finals_data_import_page.dart';

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
                  onPressed: () {
                    throw UnimplementedError();
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_outlined),
                  label: const Text('导入完整数据'),
                  onPressed: () {
                    throw UnimplementedError();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: const [
                      FinalsDataImportPage(),
                      Text('2'),
                      Text('3'),
                    ],
                  ),
                ),
                LinearProgressIndicator(
                  value: _process,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
