import 'package:flutter/material.dart';

import '../res/colors.dart';

class CustomSnackbar {
  static showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    var snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
