import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:printer_app/appsflyer.dart';
import '../../../core/utils.dart';
import '../../../core/config/constants.dart';
import '../../printer/screens/documents_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../printer/screens/printer_screen.dart';
import '../../share/bloc/share_bloc.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_sheet.dart';
import '../widgets/home_appbar.dart';
import '../widgets/nav_bar.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routePath = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _paywallShown = false;

  @override
  void initState() {
    super.initState();
    initApp();
    final state = context.read<VipBloc>().state;
    if (!_paywallShown && !state.isVip) {
      _paywallShown = true;
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          VipSheet.show(
            context,
            identifier: Identifiers.paywall1,
          );
        }
      });
    }
  }

  Future<void> initApp() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await AnalyticsService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareBloc, ShareState>(
      listener: (context, state) {
        if (state is ShareLoaded) {
          context.push(
            DocumentsScreen.routePath,
            extra: File(state.files[0].path),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const HomeAppbar(),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 62 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  logger(state.runtimeType);
                },
                buildWhen: (previous, current) {
                  return previous.runtimeType != current.runtimeType;
                },
                builder: (context, state) {
                  int index = state is HomePrinter ? 0 : 1;

                  return IndexedStack(
                    index: index,
                    children: const [
                      PrinterScreen(),
                      SettingsScreen(),
                    ],
                  );
                },
              ),
            ),
            const NavBar(),
          ],
        ),
      ),
    );
  }
}
