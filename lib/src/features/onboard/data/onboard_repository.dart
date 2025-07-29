import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/constants.dart';

abstract interface class OnboardRepository {
  const OnboardRepository();

  bool isOnboard();
  Future<void> removeOnboard();

  String getPrinterModel();
  Future<void> savePrinterModel(String value);
}

final class OnboardRepositoryImpl implements OnboardRepository {
  OnboardRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  bool isOnboard() {
    return _prefs.getBool(Keys.onboard) ?? true;
  }

  @override
  Future<void> removeOnboard() async {
    await _prefs.setBool(Keys.onboard, false);
  }

  @override
  String getPrinterModel() {
    return _prefs.getString(Keys.printerModel) ?? '';
  }

  @override
  Future<void> savePrinterModel(String value) async {
    await _prefs.setString(Keys.printerModel, value);
  }
}
