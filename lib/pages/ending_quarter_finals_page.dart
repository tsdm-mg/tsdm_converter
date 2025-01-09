import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/raw/raw_poll_result.dart';

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

  final _data = <_Group, List<Character>>{};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _data[_Group.a] = [];
    _data[_Group.b] = [];
    _data[_Group.c] = [];
    _data[_Group.d] = [];
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
          children: [
            _GroupForm(
              groupName: 'A组',
              key: const ValueKey('A'),
              onSave: (characters) => _data[_Group.a] = characters,
            ),
            _GroupForm(
              groupName: 'B组',
              key: const ValueKey('B'),
              onSave: (characters) => _data[_Group.b] = characters,
            ),
            _GroupForm(
              groupName: 'C组',
              key: const ValueKey('C'),
              onSave: (characters) => _data[_Group.c] = characters,
            ),
            _GroupForm(
              groupName: 'D组',
              key: const ValueKey('D'),
              onSave: (characters) => _data[_Group.d] = characters,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.generating_tokens_outlined),
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }
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
  final void Function(List<Character> characters) onSave;

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
      decoration: const InputDecoration(
        labelText: '投票结果',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLines: null,
      minLines: 7,
      validator: (v) {
        if (v == null) {
          return '投票结果不能为空';
        }

        final polls = _textController.text
            .trim()
            .split('\n')
            .map(RawPollResult.parse)
            .whereType<RawPollResult>()
            .map(CharacterPollResult.fromRaw);
        print('>>> ${widget.groupName} GROUP POLLS: $polls');

        return null;
      },
    );
  }
}
