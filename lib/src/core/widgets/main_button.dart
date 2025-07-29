import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../config/my_colors.dart';
import 'button.dart';
import 'svg_widget.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.title,
    this.asset = '',
    this.width,
    this.horizontal = 0,
    this.color,
    this.active = true,
    required this.onPressed,
  });

  final String title;
  final String asset;
  final double? width;
  final double horizontal;
  final Color? color;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 56,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: horizontal),
      decoration: BoxDecoration(
        color: color ?? (active ? colors.accentPrimary : colors.tertiaryOne),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Button(
        onPressed: active ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (asset.isNotEmpty) ...[
              SvgWidget(
                asset,
                color: colors.tertiaryFour,
              ),
              const SizedBox(width: 10),
            ],
            Text(
              title,
              style: TextStyle(
                color: colors.bgOne,
                fontSize: 16,
                fontFamily: AppFonts.inter700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
