import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/my_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Center(
      child: CupertinoActivityIndicator(
        color: colors.accentPrimary,
      ),
    );
  }
}
