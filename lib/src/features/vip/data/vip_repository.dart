import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/constants.dart';

abstract interface class VipRepository {
  const VipRepository();

  int getShowCount();
  Future<void> saveShowCount(int value);
  Future<bool> getVip();
  Future<Offering?> getOffering(String identifier);
}

final class VipRepositoryImpl implements VipRepository {
  VipRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  int getShowCount() {
    return _prefs.getInt(Keys.showCount) ?? 0;
  }

  @override
  Future<void> saveShowCount(int value) async {
    await _prefs.setInt(Keys.showCount, value);
  }

  @override
  Future<bool> getVip() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo().timeout(
      const Duration(seconds: 2),
    );
    return customerInfo.entitlements.active.isNotEmpty;
  }

  @override
  Future<Offering?> getOffering(String identifier) async {
    Offerings offerings = await Purchases.getOfferings().timeout(
      const Duration(seconds: 2),
    );
    return offerings.getOffering(identifier);
  }
}
