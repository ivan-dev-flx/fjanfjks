import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  static const routePath = '/EmailScreen';

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  int index = 0;
  final pageController = PageController();

  void onNext() async {
    if (index == 3) {
      pageController.jumpToPage(0);
      index = 0;
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      index++;
    }
    setState(() {});
  }

  void onPageChanged(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: const Appbar(title: 'Email'),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Learn how to print any email attachments with our app',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 14,
              fontFamily: AppFonts.inter400,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: const [
                _Phone(asset: Assets.phone2),
                _Phone(asset: Assets.phone3),
                _Phone(asset: Assets.phone4),
                _Phone(asset: Assets.phone5),
              ],
            ),
          ),
          Container(
            height: 224,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colors.bgOne,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(4, -4),
                  blurRadius: 37,
                  color: colors.textPrimary.withValues(alpha: 0.08),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Center(
                  child: SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 4,
                      dotColor: colors.tertiaryOne,
                      activeDotColor: colors.accentPrimary,
                    ),
                    controller: pageController,
                    count: 4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  index == 0
                      ? 'Open Your Email'
                      : index == 1
                          ? 'Find Doc & Tap'
                          : index == 2
                              ? 'Share Your Doc'
                              : 'Send & Print',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontFamily: AppFonts.inter700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  index == 0
                      ? 'Find an email with a file you’d like to print'
                      : index == 1
                          ? 'Scroll down the email and tap the attached document to open it'
                          : index == 2
                              ? 'Tap the icon to open the sharing menu'
                              : 'Select “Copy to App’s name” to open your file in the app and print it',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                    fontFamily: AppFonts.inter400,
                  ),
                ),
                const Spacer(),
                MainButton(
                  title: 'Next',
                  onPressed: onNext,
                ),
                const SizedBox(height: 44),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    // final isIpad = MediaQuery.sizeOf(context).width > 500;

    // bool first = asset == Assets.phone2;

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 300,
          height: 610,
          child: Stack(
            children: [
              Positioned(
                // top: first || isIpad ? 0 : null,
                // bottom: first ? null : 14,
                left: 0,
                right: 0,
                child: const ImageWidget(
                  Assets.phone1,
                  height: 610,
                  width: 300,
                ),
              ),
              Positioned(
                top: 12,
                // top: first || isIpad ? 12 : null,
                // bottom: first ? null : 26,
                left: 0,
                right: 0,
                child: ImageWidget(
                  asset,
                  height: 584,
                  width: 274,
                  cacheHeight: 584 * 2,
                  cacheWidth: 274 * 2,
                ),
              ),
              if (asset == Assets.phone3)
                const Positioned(
                  bottom: 64,
                  left: 128,
                  child: SvgWidget(Assets.connect5),
                )
              else if (asset == Assets.phone4)
                const Positioned(
                  bottom: 0,
                  left: 50,
                  child: SvgWidget(Assets.connect5),
                )
              else if (asset == Assets.phone5) ...[
                const Positioned(
                  // bottom: 324,
                  bottom: 314,
                  left: 28,
                  child: SvgWidget(Assets.icon),
                ),
                Positioned(
                  // bottom: 311,
                  bottom: 301,
                  left: 24,
                  child: Text(
                    'Smart Printer',
                    style: TextStyle(
                      color: colors.bgOne,
                      fontSize: 8,
                      fontFamily: AppFonts.inter500,
                    ),
                  ),
                ),
                Positioned(
                  // bottom: 267.5,
                  bottom: 257.5,
                  left: 82,
                  child: Text(
                    '“Smart Printer”',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 12,
                      fontFamily: AppFonts.inter500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
