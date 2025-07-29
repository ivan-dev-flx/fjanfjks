import 'package:flutter/material.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/main_button.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Internet Connection',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontFamily: AppFonts.inter700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check your network and tap Retry to try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 14,
                fontFamily: AppFonts.inter400,
              ),
            ),
            const SizedBox(height: 16),
            MainButton(
              title: 'Retry',
              width: 180,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
