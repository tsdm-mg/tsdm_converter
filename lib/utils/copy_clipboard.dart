import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsdm_converter/utils/show_snack_bar.dart';

/// Copy [data] into system clipboard and show a snack bar.
Future<void> copyToClipboard(
  BuildContext context,
  String data,
) async {
  await Clipboard.setData(ClipboardData(text: data));
  if (!context.mounted) {
    return;
  }
  showSnackBar(context: context, message: '已复制到剪切板');
}
