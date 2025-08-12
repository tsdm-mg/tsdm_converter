import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/starlight_movie_round_report.dart';
import 'package:tsdm_converter/pages/report_page.dart';
import 'package:tsdm_converter/widgets/group_form.dart';

/// 星耀剧场版表演赛初赛
class StarlightMovieRoundPage extends StatefulWidget {
  /// Constructor.
  const StarlightMovieRoundPage({super.key});

  @override
  State<StarlightMovieRoundPage> createState() => _StarlightMovieRoundPageState();
}

class _StarlightMovieRoundPageState extends State<StarlightMovieRoundPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _groupAController;
  late TextEditingController _groupBController;

  List<CharacterPollResult> _groupAResult = [];
  List<CharacterPollResult> _groupBResult = [];

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
        title: const Text('星耀剧场版表演赛初赛'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Form(
          key: _formKey,
          child: ListView(
                  cacheExtent: 10000,
                  children: [
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '剧场版表演赛初赛A组',
                      key: const ValueKey('GroupA'),
                      onSave: (characters) => _groupAResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '剧场版表演赛初赛B组',
                      key: const ValueKey('GroupB'),
                      onSave: (characters) => _groupBResult = characters,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.flash_on_outlined),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          final result = StarlightMovieRoundReport.build(
            groupAPoll: _groupAResult,
            groupBPoll: _groupBResult,
          );

          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ReportPage(
                report: result.toReport(),
                promoteReport: result.toReport(),
              ),
            ),
          );
        },
      ),
    );
  }
}
