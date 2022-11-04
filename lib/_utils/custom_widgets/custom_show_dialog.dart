import 'package:flutter/material.dart';

class CustomShowDialog {
  static showDialogBox({
    required BuildContext context,
    required Widget builder,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return builder;
        });
  }
}
