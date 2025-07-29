import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printer_app/appsflyer.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import '../../../core/models/vip.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../bloc/vip_bloc.dart';

class VipSheet extends StatefulWidget {
  const VipSheet({super.key, required this.identifier});
  final String identifier;

  static void show(BuildContext context, {required String identifier}) {
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VipSheet(identifier: identifier),
          fullscreenDialog: true,
        ),
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  State<VipSheet> createState() => _VipSheetState();
}

class _VipSheetState extends State<VipSheet> {
  bool isClosed = false;
  bool visible = false;

  void showInfo(String title) {
    if (!isClosed) {
      isClosed = true;
      Navigator.of(context).pop();
    }
    DialogWidget.show(context, title: title);
    context.read<VipBloc>().add(CheckVip(identifier: widget.identifier));
  }

  @override
  void initState() {
    super.initState();
    context.read<VipBloc>().add(CheckVip(identifier: widget.identifier));
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        visible = true;
      });
      if (mounted && context.read<VipBloc>().state.offering == null) {
        Navigator.of(context).pop();
        DialogWidget.show(context, title: 'Error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        child: BlocBuilder<VipBloc, Vip>(
          builder: (context, state) {
            if (state.loading || state.offering == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return PaywallView(
              offering: state.offering,
              onDismiss: () {
                Navigator.of(context).pop();
              },
              onPurchaseCompleted: (customerInfo, storeTransaction) async {
                try {
                  final entitlement =
                      customerInfo.entitlements.active.values.firstOrNull;
                  final productId = entitlement?.productIdentifier;
                  final revenue = 0.0;
                  final currency = 'USD';
                  final transactionId = storeTransaction?.transactionIdentifier;

                  await AnalyticsService().logPurchaseCompleted(
                    subscriptionType: productId,
                    revenue: revenue,
                    currency: currency,
                    transactionId: transactionId,
                    productId: productId,
                  );

                  print(
                      'Purchase completed: $productId, Revenue: $revenue $currency'); // Для отладки

                  showInfo('Purchase Completed');
                } catch (e) {
                  print('Error in onPurchaseCompleted: $e');
                  showInfo('Purchase Completed');
                }
              },
              onPurchaseCancelled: () {
                // nothing
              },
              onPurchaseError: (e) {
                // nothing
              },
              onRestoreCompleted: (customerInfo) async {
                if (customerInfo.entitlements.active.isNotEmpty) {
                  await AnalyticsService().logPurchaseCompleted();
                }
                showInfo('Restore Completed!');
              },
              onRestoreError: (e) {
                // nothing
              },
            );
          },
        ),
      ),
    );
  }
}
