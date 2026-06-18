import 'package:flutter/material.dart';

class MainDialog extends StatelessWidget {
  final Widget dialogContent;

  const MainDialog({super.key, required this.dialogContent});
  @override
  Widget build(BuildContext context) {
    return Dialog(child: dialogContent);
  }
}
