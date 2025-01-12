import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/raw/raw_poll_result.dart';

/// Form for each characters group.
class GroupForm extends StatefulWidget {
  /// Constructor.
  const GroupForm({
    required this.groupName,
    required this.onSave,
    required super.key,
  });

  /// 分组名
  final String groupName;

  /// Callback when form saved.
  final void Function(List<CharacterPollResult> characters) onSave;

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
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
