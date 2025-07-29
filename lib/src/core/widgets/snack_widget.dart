import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../config/my_colors.dart';

class SnackWidget {
  static void show(BuildContext context, String message) {
    final colors = Theme.of(context).extension<MyColors>()!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 100),
        behavior: SnackBarBehavior.floating,
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: colors.tertiaryThree,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 14,
                fontFamily: AppFonts.inter600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
