// splash_screen.dart

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:printer_app/src/features/home/screens/home_screen.dart';
import 'package:printer_app/src/features/onboard/data/onboard_repository.dart';
import 'package:printer_app/src/features/onboard/screens/onboard_screen.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/config/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    AppTrackingTransparency.requestTrackingAuthorization();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        _controller.stop();
        if (mounted) {
          if (context.read<OnboardRepository>().isOnboard()) {
            context.go(OnboardScreen.routePath);
          } else {
            context.go(HomeScreen.routePath);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    return Scaffold(
      backgroundColor: colors.accentPrimary,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: const SvgWidget(Assets.splash),
        ),
      ),
    );
  }
}
