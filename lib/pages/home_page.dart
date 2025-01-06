import 'package:flutter/material.dart';
import 'package:tsdm_converter/pages/finals/finals_page.dart';

/// Home of app.
class HomePage extends StatefulWidget {
  /// Constructor.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 200,
        ),
        children: [
          Card(
            child: InkWell(
              onTap: () async => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FinalsPage()),
              ),
              child: const Center(child: Text('完结篇')),
            ),
          ),
        ],
      ),
    );
  }
}
