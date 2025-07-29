import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/txt_field.dart';
import '../../home/screens/home_screen.dart';
import '../data/onboard_repository.dart';

class PrinterModelScreen extends StatefulWidget {
  const PrinterModelScreen({super.key, required this.onboard});

  final bool onboard;

  static const routePath = '/PrinterModelScreen';

  @override
  State<PrinterModelScreen> createState() => _PrinterModelScreenState();
}

class _PrinterModelScreenState extends State<PrinterModelScreen> {
  final controller = TextEditingController();
  String model = '';

  List<String> models = [
    'HP Envy',
    'HP LaserJet',
    'HP OfficeJetPro',
    'Canon MAXIFY',
    'HP DeskJet',
    'Canon PIXMA',
    'Epson EcoTank',
    'Brother MFC',
    'Other',
  ];

  void onChanged(String value) {
    setState(() {});
  }

  void onModel(String value) {
    setState(() {
      model = value;
      if (value == 'Other') {
        controller.clear();
      } else {
        controller.text = value;
      }
    });
  }

  void onContinue() async {
    await context.read<OnboardRepository>().savePrinterModel(controller.text);
    if (mounted) {
      context.go(HomeScreen.routePath);
    }
  }

  @override
  void initState() {
    super.initState();
    final value = context.read<OnboardRepository>().getPrinterModel();
    if (models.contains(value)) {
      model = value;
    } else {
      controller.text = value;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: widget.onboard ? null : Appbar(title: 'Printer Model'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 44),
            const Expanded(
              child: Center(
                child: FittedBox(
                  child: SvgWidget(Assets.printer),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your printer model',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 32,
                fontFamily: AppFonts.inter700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your printer model to continue',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 14,
                fontFamily: AppFonts.inter400,
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: List.generate(
                models.length,
                (index) {
                  return _Model(
                    title: models[index],
                    current: model,
                    onPressed: onModel,
                  );
                },
              ),
            ),
            if (model == 'Other') ...[
              const SizedBox(height: 8),
              TxtField(
                controller: controller,
                hintText: 'Enter printer model',
                onChanged: onChanged,
              ),
            ],
            const SizedBox(height: 24),
            MainButton(
              title: 'Continue',
              active: model == 'Other'
                  ? controller.text.isNotEmpty
                  : model.isNotEmpty,
              onPressed: onContinue,
            ),
            const SizedBox(height: 44),
          ],
        ),
      ),
    );
  }
}

class _Model extends StatelessWidget {
  const _Model({
    required this.title,
    required this.current,
    required this.onPressed,
  });

  final String title;
  final String current;
  final void Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    final active = title == current;

    return Button(
      onPressed: active
          ? null
          : () {
              onPressed(title);
            },
      minSize: 36,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: active ? colors.tertiaryTwo : colors.tertiaryFour,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.textPrimary.withValues(alpha: 0.08),
              blurRadius: 37,
              offset: const Offset(4, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? colors.accentPrimary : colors.textPrimary,
            fontSize: 14,
            fontFamily: AppFonts.inter400,
          ),
        ),
      ),
    );
  }
}
