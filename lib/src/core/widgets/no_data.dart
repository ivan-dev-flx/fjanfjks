import 'package:flutter/material.dart';

import '../config/constants.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No data',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.inter700,
        ),
      ),
    );
  }
}
