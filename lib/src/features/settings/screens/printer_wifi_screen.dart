import 'package:flutter/material.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class PrinterWifiScreen extends StatelessWidget {
  const PrinterWifiScreen({super.key});

  static const routePath = '/PrinterWifiScreen';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: const Appbar(title: 'Printer Wi-Fi'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Connecting via WPS (if supported by your router)',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 24,
              fontFamily: AppFonts.inter600,
            ),
          ),
          const SizedBox(height: 34),
          const _Title('1. Turn on the printer'),
          const SizedBox(
            height: 214,
            child: Stack(
              children: [
                SvgWidget(Assets.connect1),
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: SvgWidget(Assets.connect2),
                ),
                Positioned(
                  right: 0,
                  bottom: 24,
                  child: SvgWidget(Assets.connect5),
                ),
              ],
            ),
          ),
          const _Title(
              '2. Press and hold the Wi-Fi or WPS button on the printer for 3-5 seconds until the indicator starts blinking'),
          const SizedBox(height: 18),
          const SizedBox(
            height: 214,
            child: Stack(
              children: [
                SvgWidget(Assets.connect1),
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: SvgWidget(Assets.connect3),
                ),
                Positioned(
                  right: 0,
                  bottom: 24,
                  child: SvgWidget(Assets.connect5),
                ),
              ],
            ),
          ),
          const _Title(
              '3. Press the WPS buttton on the router within 2 minutes after step 2'),
          const ImageWidget(
            Assets.router,
            height: 190,
          ),
          const _Title(
              '4. Wait for the printer to connect (the indicator should stop blinking once connected)'),
          const Center(
            child: SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Positioned(
                    left: -18,
                    child: SvgWidget(Assets.connect2),
                  ),
                  Positioned(
                    right: -18,
                    child: SvgWidget(Assets.connect4),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    child: SvgWidget(Assets.connect3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Text(
      title,
      style: TextStyle(
        color: colors.textSecondary,
        fontSize: 16,
        fontFamily: AppFonts.inter600,
      ),
    );
  }
}
