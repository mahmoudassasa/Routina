import 'package:flutter/material.dart';

class MainAlertDialog extends StatelessWidget {
  final Widget dialogTitle;
  final Widget dialogContent;
  final List<Widget> dialogActions;

  const MainAlertDialog({
    super.key,
    required this.dialogTitle,
    required this.dialogContent,
    required this.dialogActions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: dialogTitle,
      content: dialogContent,
      actions: dialogActions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
