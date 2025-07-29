import 'dart:async';
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_asa_attribution/flutter_asa_attribution.dart';
import 'package:http/http.dart' as http;
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'src/core/config/constants.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._();
  static bool _isInitialized = false;
  static AttributionData _attributionData =
      const AttributionData(mediaSource: 'organic');
  static const String _appsFlyerDevKey = 'VssG3LNA5NwZpCZ3Dd5YhQ';
  static const String _appsFlyerAppId = '6746067890';
  static const String _oneSignalAppId = '3910bd9d-2d92-4c2b-84d9-fb6913e515de';
  static Completer<void>? _initCompleter;
  static AppsflyerSdk? _appsFlyer;
  static bool _attributionDataReceived = false;
  static String? _cachedUserId;

  factory AnalyticsService() => _instance;

  AnalyticsService._();

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (_initCompleter != null) return _initCompleter!.future;

    _initCompleter = Completer<void>();
    try {
      await _initializeServices().timeout(const Duration(seconds: 20));
    } catch (e) {
      _attributionData = const AttributionData(mediaSource: 'organic');
    } finally {
      _isInitialized = true;
      _initCompleter?.complete();
      _initCompleter = null;
    }
  }

  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedUserId = prefs.getString(Keys.userID) ?? 'undefined';

    if (_cachedUserId == null) return;

    final isFirstInstall = prefs.getBool('first_install_processed') != true;

    await _loadCachedAttributionData(prefs);

    await _initFirebase();
    await _initOneSignal();

    if (isFirstInstall) {
      await _initAppsFlyer();
      await _waitForAttributionData();
      await _handleFirstInstall(prefs);
    }
  }

  Future<void> _waitForAttributionData() async {
    final asaData = await _fetchAppleSearchAdsData();
    if (asaData != null && asaData['campaignId'] != null) {
      _attributionData = AttributionData(
        mediaSource: 'ASA',
        campaignId: asaData['campaignId']?.toString(),
        adGroupId: asaData['adGroupId']?.toString(),
        keywordId: asaData['keywordId']?.toString(),
        creativeSetId: asaData['creativeSetId']?.toString(),
      );
      _attributionDataReceived = true;
      await _saveAttributionDataToCache(_attributionData);
      return;
    }

    const maxWaitTime = Duration(seconds: 50);
    final startTime = DateTime.now();

    while (!_attributionDataReceived &&
        DateTime.now().difference(startTime) < maxWaitTime) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (!_attributionDataReceived) {
      _attributionData = const AttributionData(mediaSource: 'organic');
      await _saveAttributionDataToCache(_attributionData);
    }
  }

  Future<void> _initFirebase() async {
    if (_cachedUserId != null) {
      await FirebaseAnalytics.instance.setUserId(id: _cachedUserId!);
    }
  }

  Future<void> _initAppsFlyer() async {
    await AppTrackingTransparency.requestTrackingAuthorization();

    _appsFlyer = AppsflyerSdk(AppsFlyerOptions(
      afDevKey: _appsFlyerDevKey,
      appId: _appsFlyerAppId,
      showDebug: false,
      timeToWaitForATTUserAuthorization: 50,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
    ));

    await _appsFlyer!.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    _appsFlyer!.onInstallConversionData((data) {
      final payload = data['payload'] as Map<String, dynamic>?;
      if (payload == null ||
          payload['af_status'] == 'Organic' ||
          payload['media_source'] == null) {
        if (_attributionData.mediaSource == 'organic') {
          _attributionData = const AttributionData(mediaSource: 'organic');
        }
      } else {
        _attributionData = AttributionData(
          mediaSource: payload['media_source'],
          campaignId: payload['campaign_id'],
          adGroupId: payload['adgroup_id'],
          keywordId: payload['keyword_id'],
          creativeSetId: payload['creative_set_id'],
        );
      }
      _attributionDataReceived = true;
      _saveAttributionDataToCache(_attributionData);
    });

    _appsFlyer!.onAppOpenAttribution((data) {
      FirebaseAnalytics.instance.logEvent(
        name: 'app_open_attribution',
        parameters: {
          'open_time': DateTime.now().toIso8601String(),
          ...data.map((k, v) => MapEntry(k, v.toString())),
        },
      );
    });

    _appsFlyer!.onDeepLinking((result) {
      if (result.status == Status.FOUND && result.deepLink != null) {
        FirebaseAnalytics.instance.logEvent(
          name: 'deep_link_opened',
          parameters: {
            'deep_link_url': result.deepLink!.toString(),
            'deep_link_time': DateTime.now().toIso8601String(),
            ...result.deepLink!.clickEvent
                .map((k, v) => MapEntry('dl_$k', v.toString())),
          },
        );
      }
    });

    _appsFlyer!.startSDK();
  }

  Future<void> _initOneSignal() async {
    OneSignal.initialize(_oneSignalAppId);
    await OneSignal.Notifications.requestPermission(true);
    if (_cachedUserId != null) {
      await OneSignal.login(_cachedUserId!);
    }
  }

  String _getDisplayMediaSource() {
    if (_attributionData.mediaSource == 'organic') {
      return 'organic';
    } else if (_attributionData.mediaSource == 'ASA') {
      return 'ASA';
    } else if (_attributionData.mediaSource.isNotEmpty) {
      return _attributionData.mediaSource;
    } else {
      return 'non-organic';
    }
  }

  Future<void> _handleFirstInstall(SharedPreferences prefs) async {
    if (_cachedUserId == null) return;

    final attributionData = _attributionData;
    final displayMediaSource = _getDisplayMediaSource();

    final tags = {
      'subscription_type': 'unpaid',
      'media_source': displayMediaSource,
      'user_id': _cachedUserId!,
      if (attributionData.campaignId != null)
        'campaignId': attributionData.campaignId!,
      if (attributionData.adGroupId != null)
        'adGroupId': attributionData.adGroupId!,
      if (attributionData.keywordId != null)
        'keywordId': attributionData.keywordId!,
      if (attributionData.creativeSetId != null)
        'creativeSetId': attributionData.creativeSetId!,
    };

    await Future.wait([
      OneSignal.User.addTags(tags),
      FirebaseAnalytics.instance.logEvent(
        name: 'first_install',
        parameters: {
          'user_id': _cachedUserId!,
          'install_time': DateTime.now().toIso8601String(),
          'media_source': displayMediaSource,
          if (attributionData.campaignId != null)
            'campaign_id': attributionData.campaignId!,
          if (attributionData.adGroupId != null)
            'adgroup_id': attributionData.adGroupId!,
          if (attributionData.keywordId != null)
            'keyword_id': attributionData.keywordId!,
          if (attributionData.creativeSetId != null)
            'creative_set_id': attributionData.creativeSetId!,
        },
      ),
    ]);

    prefs.setBool('first_install_processed', true);
  }

  Future<Map<String, dynamic>?> _fetchAppleSearchAdsData() async {
    try {
      final token = await FlutterAsaAttribution.instance.attributionToken();
      if (token == null) return null;

      final response = await http
          .post(
            Uri.parse('https://api-adservices.apple.com/api/v1/'),
            headers: {'Content-Type': 'text/plain'},
            body: token,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['campaignId'] != null) {
          return data;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveAttributionDataToCache(AttributionData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = {
        'mediaSource': data.mediaSource,
        'campaignId': data.campaignId,
        'adGroupId': data.adGroupId,
        'keywordId': data.keywordId,
        'creativeSetId': data.creativeSetId,
      };
      await prefs.setString('attribution_data', json.encode(jsonData));
    } catch (e) {}
  }

  Future<void> _loadCachedAttributionData(SharedPreferences prefs) async {
    try {
      final cachedData = prefs.getString('attribution_data');
      if (cachedData != null) {
        final jsonData = json.decode(cachedData) as Map<String, dynamic>;
        _attributionData = AttributionData(
          mediaSource: jsonData['mediaSource'] ?? 'organic',
          campaignId: jsonData['campaignId'],
          adGroupId: jsonData['adGroupId'],
          keywordId: jsonData['keywordId'],
          creativeSetId: jsonData['creativeSetId'],
        );
        _attributionDataReceived = true;
      }
    } catch (e) {
      _attributionData = const AttributionData(mediaSource: 'organic');
    }
  }

  Future<void> updateOneSignalTags() async {
    if (_cachedUserId == null) return;

    final attributionData = _attributionData;
    final displayMediaSource = _getDisplayMediaSource();

    final tags = {
      'media_source': displayMediaSource,
      'user_id': _cachedUserId!,
      if (attributionData.campaignId != null)
        'campaignId': attributionData.campaignId!,
      if (attributionData.adGroupId != null)
        'adGroupId': attributionData.adGroupId!,
      if (attributionData.keywordId != null)
        'keywordId': attributionData.keywordId!,
      if (attributionData.creativeSetId != null)
        'creativeSetId': attributionData.creativeSetId!,
    };

    await OneSignal.User.addTags(tags);
  }

  Future<void> logPurchaseCompleted(
      {String? subscriptionType,
      double? revenue,
      String? currency,
      String? transactionId,
      String? productId}) async {
    if (_cachedUserId == null) return;

    final currentAttributionData = _attributionData;
    final displayMediaSource = _getDisplayMediaSource();

    // OneSignal tags
    final tags = {
      'subscription_type': 'paid',
      'media_source': displayMediaSource,
      'user_id': _cachedUserId!,
      if (currentAttributionData.campaignId != null)
        'campaignId': currentAttributionData.campaignId!,
      if (currentAttributionData.adGroupId != null)
        'adGroupId': currentAttributionData.adGroupId!,
      if (currentAttributionData.keywordId != null)
        'keywordId': currentAttributionData.keywordId!,
      if (currentAttributionData.creativeSetId != null)
        'creativeSetId': currentAttributionData.creativeSetId!,
    };

    // AppsFlyer parameters
    final appsFlyerParams = <String, dynamic>{
      'af_revenue': revenue ?? 0.0,
      'af_currency': currency ?? 'USD',
      'af_content_type': subscriptionType ?? 'subscription',
      'media_source': displayMediaSource,
      if (currentAttributionData.campaignId != null)
        'campaign_id': currentAttributionData.campaignId!,
      if (currentAttributionData.adGroupId != null)
        'adgroup_id': currentAttributionData.adGroupId!,
      if (currentAttributionData.keywordId != null)
        'keyword_id': currentAttributionData.keywordId!,
      if (currentAttributionData.creativeSetId != null)
        'creative_set_id': currentAttributionData.creativeSetId!,
    };

    try {
      await Future.wait([
        FirebaseAnalytics.instance.logPurchase(
          currency: currency ?? 'USD',
          value: revenue ?? 0.0,
          transactionId: transactionId,
          parameters: {
            'media_source': displayMediaSource,
            if (currentAttributionData.campaignId != null)
              'campaign_id': currentAttributionData.campaignId!,
            if (currentAttributionData.adGroupId != null)
              'adgroup_id': currentAttributionData.adGroupId!,
            if (currentAttributionData.keywordId != null)
              'keyword_id': currentAttributionData.keywordId!,
            if (currentAttributionData.creativeSetId != null)
              'creative_set_id': currentAttributionData.creativeSetId!,
            if (subscriptionType != null) 'subscription_type': subscriptionType,
            if (productId != null) 'item_id': productId,
            'item_category': 'subscription',
            'quantity': 1,
          },
        ),

        // Дополнительно логируем кастомное событие
        FirebaseAnalytics.instance.logEvent(
          name: 'purchase_completed',
          parameters: {
            'media_source': displayMediaSource,
            'revenue': revenue ?? 0.0,
            'currency': currency ?? 'USD',
            if (currentAttributionData.campaignId != null)
              'campaign_id': currentAttributionData.campaignId!,
            if (currentAttributionData.adGroupId != null)
              'adgroup_id': currentAttributionData.adGroupId!,
            if (currentAttributionData.keywordId != null)
              'keyword_id': currentAttributionData.keywordId!,
            if (currentAttributionData.creativeSetId != null)
              'creative_set_id': currentAttributionData.creativeSetId!,
            if (subscriptionType != null) 'subscription_type': subscriptionType,
            if (productId != null) 'product_id': productId,
            if (transactionId != null) 'transaction_id': transactionId,
          },
        ),

        OneSignal.User.addTags(tags),

        if (_appsFlyer != null)
          _appsFlyer!.logEvent('af_purchase', appsFlyerParams),
      ]);

      print('Purchase logged successfully'); // Для отладки
    } catch (e) {
      print('Error logging purchase: $e'); // Для отладки
    }
  }

  AttributionData get attributionData => _attributionData;
  String? get userId => _cachedUserId;
}

class AttributionData {
  final String mediaSource;
  final String? campaignId;
  final String? adGroupId;
  final String? keywordId;
  final String? creativeSetId;

  const AttributionData({
    required this.mediaSource,
    this.campaignId,
    this.adGroupId,
    this.keywordId,
    this.creativeSetId,
  });
}
