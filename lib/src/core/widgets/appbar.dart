import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/constants.dart';
import '../utils.dart';
import 'button.dart';
import 'svg_widget.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({
    super.key,
    this.title = '',
    this.right,
    this.child,
  });

  final String title;
  final Widget? right;
  final Widget? child;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: child ?? Text(title),
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
        ),
        child: Button(
          onPressed: () {
            try {
              context.pop();
            } catch (e) {
              logger(e);
            }
          },
          child: SvgWidget(Assets.left),
        ),
      ),
      actions: [right ?? const SizedBox()],
    );
  }
}
