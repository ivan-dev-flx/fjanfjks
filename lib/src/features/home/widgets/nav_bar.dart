import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/button.dart';
import '../../scanner/screens/scanner_screen.dart';
import '../bloc/home_bloc.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 62 + MediaQuery.of(context).viewPadding.bottom,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ).copyWith(top: 4),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: colors.bgOne,
          border: Border(
            top: BorderSide(
              width: 1,
              color: colors.tertiaryThree,
            ),
          ),
        ),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Scanner(
                  title: 'Scanner',
                  asset: Assets.scanner,
                  onPressed: () async {
                    if (await Permission.camera.status.isGranted) {
                      await CunningDocumentScanner.getPictures().then((value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            context.mounted) {
                          context.push(
                            ScannerScreen.routePath,
                            extra: value,
                          );
                        }
                      });
                    } else {
                      final result = await Permission.camera.request();
                      if (result.isPermanentlyDenied) {
                        openAppSettings();
                      }
                    }
                  },
                ),
                _NavBarButton(
                  index: 1,
                  title: 'Printer',
                  asset: Assets.print,
                  active: state is HomePrinter,
                ),
                _NavBarButton(
                  index: 2,
                  title: 'Settings',
                  asset: Assets.settings,
                  active: state is HomeSettings,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  const _NavBarButton({
    required this.index,
    required this.asset,
    required this.title,
    required this.active,
  });

  final String title;
  final String asset;
  final int index;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Expanded(
      child: Container(
        height: 54,
        decoration: active
            ? BoxDecoration(
                color: colors.tertiaryTwo,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Button(
          onPressed: active
              ? null
              : () {
                  context.read<HomeBloc>().add(ChangePage(index: index));
                },
          child: Column(
            children: [
              const SizedBox(height: 4),
              SvgWidget(
                asset,
                height: 24,
                color: active ? colors.accentPrimary : colors.tertiaryOne,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: active ? colors.accentPrimary : colors.tertiaryOne,
                  fontSize: 12,
                  fontFamily: AppFonts.inter500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Scanner extends StatelessWidget {
  const _Scanner({
    required this.title,
    required this.asset,
    required this.onPressed,
  });

  final String title;
  final String asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Expanded(
      child: SizedBox(
        height: 54,
        child: Button(
          onPressed: onPressed,
          child: Column(
            children: [
              const SizedBox(height: 4),
              SvgWidget(
                asset,
                height: 24,
                color: colors.tertiaryOne,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: colors.tertiaryOne,
                  fontSize: 12,
                  fontFamily: AppFonts.inter500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
