import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/raw/raw_poll_result.dart';
import 'package:tsdm_converter/models/report/ending_quarter_report.dart';
import 'package:tsdm_converter/utils/copy_clipboard.dart';

enum _Group {
  a,
  b,
  c,
  d,
}

/// 四分之一决赛
///
/// 仅仅生成战报
class EndingQuarterFinalsPage extends StatefulWidget {
  /// Constructor.
  const EndingQuarterFinalsPage({super.key});

  @override
  State<EndingQuarterFinalsPage> createState() =>
      _EndingQuarterFinalsPageState();
}

class _EndingQuarterFinalsPageState extends State<EndingQuarterFinalsPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  final _data = <_Group, List<CharacterPollResult>>{};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('完结篇 四分之一决赛战报')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            _GroupForm(
              groupName: '第1组',
              key: const ValueKey('A'),
              onSave: (characters) => _data[_Group.a] = characters,
            ),
            const SizedBox(height: 8),
            _GroupForm(
              groupName: '第2组',
              key: const ValueKey('B'),
              onSave: (characters) => _data[_Group.b] = characters,
            ),
            const SizedBox(height: 8),
            _GroupForm(
              groupName: '第3组',
              key: const ValueKey('C'),
              onSave: (characters) => _data[_Group.c] = characters,
            ),
            const SizedBox(height: 8),
            _GroupForm(
              groupName: '第4组',
              key: const ValueKey('D'),
              onSave: (characters) => _data[_Group.d] = characters,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.flash_on_outlined),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          final result = EndingQuarterReport.build(
            groupAPolls: _data[_Group.a]!,
            groupBPolls: _data[_Group.b]!,
            groupCPolls: _data[_Group.c]!,
            groupDPolls: _data[_Group.d]!,
          );

          await copyToClipboard(context, result.toReport());
        },
      ),
    );
  }
}

/// Form for each characters group.
class _GroupForm extends StatefulWidget {
  const _GroupForm({
    required this.groupName,
    required this.onSave,
    required super.key,
  });

  /// 分组名
  final String groupName;

  /// Callback when form saved.
  final void Function(List<CharacterPollResult> characters) onSave;

  @override
  State<_GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<_GroupForm> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      decoration: InputDecoration(
        labelText: '${widget.groupName} 投票结果',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLines: null,
      minLines: 7,
      validator: (v) {
        if (v == null) {
          return '投票结果不能为空';
        }

        final characters = _textController.text
            .trim()
            .split('\n')
            .map(RawPollResult.parse)
            .whereType<RawPollResult>()
            .map(CharacterPollResult.fromRaw);
        widget.onSave(characters.toList());

        return null;
      },
    );
  }
}