import 'package:flutter/material.dart';
import 'package:tsdm_converter/pages/home_page.dart';
import 'package:tsdm_converter/theme/theme.dart';

void main() {
  runApp(const App());
}

/// App instance class.
class App extends StatefulWidget {
  /// Constructor.
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TSDM Converter'),
          // bottom: TabBar(
          //   controller: _tabController,
          //   tabAlignment: TabAlignment.start,
          //   isScrollable: true,
          //   tabs: const [
          //     Tab(text: '季节篇决赛'),
          //   ],
          // ),
        ),
        // body: TabBarView(
        //   controller: _tabController,
        //   children: const [
        //     SeasonFinalsPage(),
        //   ],
        // ),
        body: const HomePage(),
      ),
    );
  }
}
