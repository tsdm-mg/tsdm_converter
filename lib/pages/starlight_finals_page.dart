import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/report/starlight_finals_report.dart';
import 'package:tsdm_converter/pages/report_page.dart';
import 'package:tsdm_converter/widgets/group_form.dart';

/// 星耀决赛
class StarlightFinalsPage extends StatefulWidget {
  /// Constructor.
  const StarlightFinalsPage({super.key});

  @override
  State<StarlightFinalsPage> createState() => _StarlightFinalsPageState();
}

class _StarlightFinalsPageState extends State<StarlightFinalsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _groupFinalsController;
  late TextEditingController _groupQualifyingController;
  late TextEditingController _groupMovieController;

  List<CharacterPollResult> _groupFinalsResult = [];
  List<CharacterPollResult> _groupQualifyingResult = [];
  List<CharacterPollResult> _groupMovieResult = [];

  @override
  void initState() {
    super.initState();
    _groupFinalsController = TextEditingController();
    _groupQualifyingController = TextEditingController();
    _groupMovieController = TextEditingController();
  }

  @override
  void dispose() {
    _groupFinalsController.dispose();
    _groupQualifyingController.dispose();
    _groupMovieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('星耀决赛'),
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
                      groupName: '决赛',
                      key: const ValueKey('Finals'),
                      onSave: (characters) => _groupFinalsResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '排位赛第二场',
                      key: const ValueKey('Qualifying'),
                      onSave: (characters) => _groupQualifyingResult = characters,
                    ),
                    const SizedBox(height: 8),
                    GroupForm(
                      groupName: '剧场版动画表演赛决赛',
                      key: const ValueKey('Movies'),
                      onSave: (characters) => _groupMovieResult = characters,
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

          final result = StarlightFinalsReport.build(
            groupFinalsPoll: _groupFinalsResult,
            groupQualifyingPoll: _groupQualifyingResult,
            groupMoviePoll: _groupMovieResult,
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
