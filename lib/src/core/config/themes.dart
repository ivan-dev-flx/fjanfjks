import 'package:flutter/material.dart';

import 'constants.dart';
import 'my_colors.dart';

final _colors = MyColors.light();

final theme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  fontFamily: AppFonts.inter400,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: _colors.accentPrimary,
    selectionColor: _colors.accentPrimary,
    selectionHandleColor: _colors.accentPrimary,
  ),

  // OVERSCROLL
  colorScheme: ColorScheme.light(
    surface: _colors.bgOne, // bg color when push
    secondary: _colors.tertiaryThree, // overscroll
  ),

  // SCAFFOLD
  scaffoldBackgroundColor: _colors.bgOne,

  // APPBAR
  appBarTheme: AppBarTheme(
    backgroundColor: _colors.bgOne,
    centerTitle: true,
    toolbarHeight: 60, // app bar size
    elevation: 0,
    actionsPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    titleTextStyle: TextStyle(
      color: _colors.textPrimary,
      fontSize: 18,
      fontFamily: AppFonts.inter600,
    ),
    shape: Border(
      bottom: BorderSide(
        width: 1,
        color: _colors.tertiaryThree,
      ),
    ),
  ),

  // DIALOG
  dialogTheme: const DialogThemeData(
    insetPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),

  // TEXTFIELD
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    // fillColor: _colors.tertiaryOne,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 16,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    hintStyle: TextStyle(
      color: _colors.textSecondary,
      fontSize: 14,
      fontFamily: AppFonts.inter400,
    ),
  ),

  // BOTTOM SHEET
  // bottomSheetTheme: BottomSheetThemeData(
  //   backgroundColor: _colors.bg,
  // ),
  extensions: [_colors],
);
