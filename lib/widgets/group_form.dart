import 'package:flutter/foundation.dart' show AsyncCallback;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard;
import 'package:html/dom.dart' as hd;
import 'package:html/parser.dart' as hp;
import 'package:super_clipboard/super_clipboard.dart';
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

  void _setText(String data) {
    final currText = _textController.text;
    final currSelection = _textController.selection;
    final start = currSelection.start >= 0 ? currSelection.start : currText.length;
    final end = currSelection.end >= 0 ? currSelection.end : currText.length;
    final newText = currText.replaceRange(start, end, data);
    final cursorPosition = start + data.length;
    _textController.value = TextEditingValue(
      text:newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  /// Fallback to internal clipboard.
  Future<void> _setFallbackInternalClipboardContent() async {
    final plainContent = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    if (plainContent == null) {
    return;
    }
    _setText(plainContent);
  }

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
    return Actions(
      actions: <Type, Action<Intent>>{
        PasteTextIntent: _PasteInterceptAction(
          onPaste: () async {
            final clipboardReader = await SystemClipboard.instance?.read();
            if (clipboardReader == null) {
              await _setFallbackInternalClipboardContent();
              return;
            }

            if (clipboardReader.canProvide(Formats.htmlText)) {
              final htmlContent = await clipboardReader.readValue(Formats.htmlText);
              if (htmlContent == null) {
                await _setFallbackInternalClipboardContent();
              } else{
                final bbcodeContent = htmlToBBCode(htmlContent);
                _setText(bbcodeContent);
              }
              return;
            }

            if (clipboardReader.canProvide(Formats.plainText)) {
              final plainText = await clipboardReader.readValue(Formats.plainText);
              if (plainText == null) {
                await _setFallbackInternalClipboardContent();
              } else {
                _setText(plainText);
              }
              return;
            }
          },
        ),
      },
      child: TextFormField(
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
      ),
    );
  }
}


class _PasteInterceptAction extends Action<PasteTextIntent> {
  // Super class not const.
  // ignore: prefer_const_constructor_declarations
  /// Constructor.
  _PasteInterceptAction({required this.onPaste});

  final AsyncCallback onPaste;

  @override
  Object? invoke(PasteTextIntent intent) async {
    await onPaste();
    return null;
  }

  @override
  bool consumesKey(PasteTextIntent intent) => true;
}


/// Convert html content to bbcode content.
String htmlToBBCode(String htmlContent )  {
  final allowedTags = <String, String> {
    'table': 'table',
    'tr': 'tr',
    'td': 'td',
    'th': 'th',
    'color': 'color',
    'align': 'align',
  };

  String walk(hd.Node node) {
    if (node.nodeType == hd.Node.TEXT_NODE) {
      return node.text?.trim() ?? '';
    }

    if (node.nodeType == hd.Node.ELEMENT_NODE) {
      final element = node as hd.Element;
      final htmlTagName = element.localName?.toLowerCase() ?? '';
      if (htmlTagName == 'tbody') {
        return element.nodes.map(walk).join();
      }

      final bbcodeTagName = allowedTags[htmlTagName];
      if (bbcodeTagName == null) {
        // Not allowed.
        // We do not execute html/js contents so it's safe to do without XSS check.
        return element.nodes.map(walk).join();
      }

      final childrenContent = element.nodes.map(walk).join();

      return '[$bbcodeTagName]$childrenContent[/$bbcodeTagName] ${bbcodeTagName == "tr" ? "\n" : ""}';
    }

    // Ignored.
    return '';
  }

  final doc = hp.parse(htmlContent);
  return doc.documentElement?.nodes.map(walk).join() ?? '';
}
