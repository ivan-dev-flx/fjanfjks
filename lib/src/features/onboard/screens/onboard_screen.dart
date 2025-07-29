import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/rotated_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../data/onboard_repository.dart';
import 'printer_model_screen.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  static const routePath = '/OnboardScreen';

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int index = 0;
  final pageController = PageController();

  void onNext() async {
    if (index == 1) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
    if (index == 2) {
      InAppReview.instance.requestReview();
    }
    if (index == 3) {
      await context.read<OnboardRepository>().removeOnboard();
      if (mounted) {
        context.go(
          PrinterModelScreen.routePath,
          extra: true,
        );
      }
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        index++;
      });
    }
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.gradient1,
                  colors.gradient2,
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  children: const [
                    _Phone(asset: Assets.onboard2),
                    _Phone(asset: Assets.onboard3),
                    _Phone(asset: Assets.onboard4),
                    _Phone(asset: Assets.onboard5),
                  ],
                ),
              ),
              Container(
                height: 288,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.bgOne,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 24),
                    Text(
                      index == 0
                          ? 'Instant Document Printing'
                          : index == 1
                              ? 'Scan Documents Quickly and Easy'
                              : index == 2
                                  ? 'Instant PDF Printing Made Simple'
                                  : '10,000+ Printers Supported',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 32,
                        fontFamily: AppFonts.inter700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      index == 0
                          ? 'Print to any AirPrint-compatible printer with ease'
                          : index == 1
                              ? 'Easily scan any document from your iPhone or iPad'
                              : index == 2
                                  ? 'Organize and Manage PDFs Effortlessly'
                                  : 'Easily print to any AirPrint-compatible printer',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 14,
                        fontFamily: AppFonts.inter400,
                      ),
                    ),
                    const Spacer(),
                    MainButton(
                      title: 'Continue',
                      onPressed: onNext,
                    ),
                    const SizedBox(height: 44),
                  ],
                ),
              ),
            ],
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
    return asset == Assets.onboard5
        ? Stack(
            children: const [
              Positioned(
                left: 16,
                bottom: -134,
                child: ImageWidget(
                  Assets.onboard5,
                  height: 458,
                ),
              ),
              Positioned(
                left: 27,
                bottom: 42,
                child: ImageWidget(
                  Assets.onboard6,
                  height: 280,
                ),
              ),
              Positioned(
                top: 76,
                right: 20,
                child: SvgWidget(
                  Assets.printer,
                  height: 185,
                ),
              ),
              Positioned(
                top: 50,
                left: 80,
                child: SvgWidget(
                  Assets.wifi,
                  height: 94,
                ),
              ),
              Positioned(
                top: 176,
                left: 10,
                child: RotatedWidget(
                  degree: 18,
                  child: SvgWidget(
                    Assets.wifi,
                    height: 80,
                  ),
                ),
              ),
              Positioned(
                top: 332,
                right: 100,
                child: SvgWidget(
                  Assets.wifi,
                  height: 72,
                ),
              ),
            ],
          )
        : SizedBox(
            // color: Colors.re,
            width: 360,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: 300,
                  height: 610,
                  child: Stack(
                    children: [
                      Positioned(
                        // top: 68,
                        left: 0,
                        right: 0,
                        bottom: -100,
                        child: const ImageWidget(
                          Assets.onboard1,
                          height: 610,
                          width: 300,
                        ),
                      ),
                      Positioned(
                        // top: 78,
                        left: 0,
                        right: 0,
                        bottom: -80,
                        child: ImageWidget(
                          asset,
                          height: 580,
                          width: 270,
                          cacheHeight: 580 * 2,
                          cacheWidth: 270 * 2,
                        ),
                      ),
                    ],
                  ),
                ),
                if (asset == Assets.onboard4) ...const [
                  Positioned(
                    top: 40,
                    right: 0,
                    child: SvgWidget(Assets.format1),
                  ),
                  Positioned(
                    top: 150,
                    left: 0,
                    child: SvgWidget(Assets.format2),
                  ),
                  Positioned(
                    top: 290,
                    left: 10,
                    child: SvgWidget(Assets.format3),
                  ),
                  Positioned(
                    top: 294,
                    right: -30,
                    child: SvgWidget(Assets.format4),
                  ),
                  Positioned(
                    top: 462,
                    left: 6,
                    child: SvgWidget(Assets.format5),
                  ),
                  Positioned(
                    top: 520,
                    right: 0,
                    child: SvgWidget(Assets.format6),
                  ),
                ],
              ],
            ),
          );
  }
}
