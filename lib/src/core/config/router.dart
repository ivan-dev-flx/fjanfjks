import 'dart:io';

import 'package:go_router/go_router.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/onboard/screens/printer_model_screen.dart';
import '../../features/printer/screens/camera_screen.dart';
import '../../features/printer/screens/printables_detail_screen.dart';
import '../../features/printer/screens/documents_screen.dart';
import '../../features/printer/screens/email_screen.dart';
import '../../features/photo/screens/photo_screen.dart';
import '../../features/printer/screens/printables_screen.dart';
import '../../features/printer/screens/web_pages_screen.dart';
import '../../features/onboard/screens/onboard_screen.dart';
import '../../features/onboard/screens/splash_screen.dart';
import '../../features/scanner/screens/scanner_screen.dart';
import '../../features/settings/screens/printer_wifi_screen.dart';
import '../../features/vip/screens/vip_screen.dart';
import '../models/printable.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: OnboardScreen.routePath,
      builder: (context, state) => const OnboardScreen(),
    ),
    GoRoute(
      path: HomeScreen.routePath,
      builder: (context, state) => const HomeScreen(),
    ),

    // PRINTER
    GoRoute(
      path: DocumentsScreen.routePath,
      builder: (context, state) => DocumentsScreen(
        file: state.extra as File,
      ),
    ),
    GoRoute(
      path: CameraScreen.routePath,
      builder: (context, state) => CameraScreen(
        file: state.extra as File,
      ),
    ),
    GoRoute(
      path: EmailScreen.routePath,
      builder: (context, state) => const EmailScreen(),
    ),
    GoRoute(
      path: WebPagesScreen.routePath,
      builder: (context, state) => const WebPagesScreen(),
    ),
    GoRoute(
      path: PrintablesScreen.routePath,
      builder: (context, state) => const PrintablesScreen(),
    ),
    GoRoute(
      path: PrintableDetailScreen.routePath,
      builder: (context, state) => PrintableDetailScreen(
        printable: state.extra as Printable,
      ),
    ),

    // PHOTO
    GoRoute(
      path: PhotoScreen.routePath,
      builder: (context, state) => const PhotoScreen(),
    ),

    // SCANNER
    GoRoute(
      path: ScannerScreen.routePath,
      builder: (context, state) => ScannerScreen(
        paths: state.extra as List<String>,
      ),
    ),

    // VIP
    GoRoute(
      path: VipScreen.routePath,
      builder: (context, state) => VipScreen(
        identifier: state.extra as String,
      ),
    ),

    // SETTINGS
    GoRoute(
      path: PrinterWifiScreen.routePath,
      builder: (context, state) => const PrinterWifiScreen(),
    ),
    GoRoute(
      path: PrinterModelScreen.routePath,
      builder: (context, state) => PrinterModelScreen(
        onboard: state.extra as bool,
      ),
    ),
  ],
);
