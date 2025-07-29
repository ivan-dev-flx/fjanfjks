import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/constants.dart';
import '../config/my_colors.dart';

class TxtField extends StatelessWidget {
  const TxtField({
    super.key,
    required this.controller,
    required this.hintText,
    this.number = false,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final bool number;
  final bool readOnly;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return TextField(
      controller: controller,
      keyboardType: number ? TextInputType.number : null,
      readOnly: readOnly,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
        if (number) FilteringTextInputFormatter.digitsOnly,
      ],
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(
        color: colors.textPrimary,
        fontSize: 14,
        fontFamily: AppFonts.inter400,
      ),
      decoration: InputDecoration(hintText: hintText),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
