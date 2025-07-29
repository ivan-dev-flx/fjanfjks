import 'package:purchases_flutter/purchases_flutter.dart';

class Vip {
  Vip({
    this.isVip = false,
    this.loading = false,
    this.offering,
  });

  final bool isVip;
  final bool loading;
  final Offering? offering;
}
