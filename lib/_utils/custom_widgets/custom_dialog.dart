import 'package:flutter/material.dart';

class CustomDialog {
  static showDialogBox({
    required ShapeBorder shape,
    required Widget child,
  }) {
    return Dialog(
      shape: shape,
      child: child,
    );
  }
}
