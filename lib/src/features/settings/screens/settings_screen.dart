import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/models/vip.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../onboard/screens/printer_model_screen.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_screen.dart';
import 'printer_wifi_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _sharePrinter() {
    const shareText = 'Print your documents with Smart Printer & Scan PDF';
    const appLink =
        'https://apps.apple.com/us/app/smart-printer-scan-master-pro/id6746067890';
    Share.share('$shareText $appLink');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        BlocBuilder<VipBloc, Vip>(
          builder: (context, state) {
            return state.isVip || state.loading
                ? const SizedBox()
                : const _Unlock();
          },
        ),
        const SizedBox(height: 16),
        const _Subscription(),
        const SizedBox(height: 12),
        _SettingsTile(
          title: 'Share App',
          onPressed: _sharePrinter,
        ),
        _SettingsTile(
          title: 'Printer Model',
          onPressed: () {
            context.push(
              PrinterModelScreen.routePath,
              extra: false,
            );
          },
        ),
        _SettingsTile(
          title: 'How to connect a printer to WIFI?',
          onPressed: () {
            context.push(PrinterWifiScreen.routePath);
          },
        ),
        _SettingsTile(
          title: 'Rate us',
          onPressed: () {
            InAppReview.instance.openStoreListing(appStoreId: '6746067890');
          },
        ),
        _SettingsTile(
          title: 'Terms of Use',
          onPressed: () async {
            try {
              if (!await launchUrl(
                Uri.parse(
                    'https://docs.google.com/document/d/11uY2wAqBkwhRYUXriLmHpgcxxF3phbGPeZec0nuFLNg/edit?usp=sharing'),
                mode: LaunchMode.inAppBrowserView,
              )) {
                throw 'Could not launch url';
              }
            } catch (e) {
              logger(e);
            }
          },
        ),
        _SettingsTile(
          title: 'Privacy Policy',
          onPressed: () async {
            try {
              if (!await launchUrl(
                Uri.parse(
                    'https://docs.google.com/document/d/11yrh35mfkEWHd2DNptRYTzVXfI34FxhRDnSVHey1VUo/edit?usp=sharing'),
                mode: LaunchMode.inAppWebView,
              )) {
                throw 'Could not launch url';
              }
            } catch (e) {
              logger(e);
            }
          },
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _Unlock extends StatelessWidget {
  const _Unlock();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return SizedBox(
      height: 182,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 166,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.gradient1,
                  colors.gradient2,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 100,
                  ),
                  child: Text(
                    'Unlock All Features',
                    style: TextStyle(
                      color: colors.bgOne,
                      fontSize: 18,
                      fontFamily: AppFonts.inter600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 100,
                  ),
                  child: Text(
                    'Print web pages, calendars, photos, and more — effortlessly',
                    style: TextStyle(
                      color: colors.bgOne,
                      fontSize: 14,
                      fontFamily: AppFonts.inter400,
                      height: 1.4,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    height: 56,
                    width: 186,
                    decoration: BoxDecoration(
                      color: colors.bgOne,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Button(
                      onPressed: () {
                        context.push(
                          VipScreen.routePath,
                          extra: Identifiers.paywall3,
                        );
                      },
                      child: Center(
                        child: Text(
                          'Unlock Now',
                          style: TextStyle(
                            color: colors.accentPrimary,
                            fontSize: 16,
                            fontFamily: AppFonts.inter700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Positioned(
            top: -14,
            right: -7,
            child: ImageWidget(
              Assets.allFeatures,
              height: 118,
            ),
          ),
        ],
      ),
    );
  }
}

class _Subscription extends StatelessWidget {
  const _Subscription();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const SizedBox(width: 32),
          Text(
            'Subscription',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 14,
              fontFamily: AppFonts.inter400,
            ),
          ),
          const Spacer(),
          BlocBuilder<VipBloc, Vip>(
            builder: (context, state) {
              return state.loading
                  ? const LoadingWidget()
                  : Text(
                      state.isVip ? 'PRO' : 'Free',
                      style: TextStyle(
                        color: colors.accentPrimary,
                        fontSize: 16,
                        fontFamily: AppFonts.inter600,
                      ),
                    );
            },
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Button(
        onPressed: onPressed,
        minSize: 48,
        child: Row(
          children: [
            const SizedBox(width: 32),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 14,
                  fontFamily: AppFonts.inter400,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const SvgWidget(Assets.right),
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }
}
