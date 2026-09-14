import 'package:firebase_analytics/firebase_analytics.dart'
    show
        AnalyticsCallOptions,
        AnalyticsEventItem,
        FirebaseAnalyticsObserver,
        ScreenNameExtractor,
        defaultNameExtractor,
        defaultRouteFilter;
import 'package:firebase_analytics/observer.dart' show RouteFilter;
import 'package:flutter/services.dart' show PlatformException;

abstract interface class AnalyticsGateway {
  const AnalyticsGateway();

  FirebaseAnalyticsObserver observer({
    ScreenNameExtractor nameExtractor = defaultNameExtractor,
    RouteFilter routeFilter = defaultRouteFilter,
    void Function(PlatformException error)? onError,
  });

  Future<bool> isSupported();

  Future<String?> get appInstanceId;

  Future<int?> getSessionId();

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
    List<AnalyticsEventItem>? items,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> setConsent({
    bool? adStorageConsentGranted,
    bool? analyticsStorageConsentGranted,
    bool? adPersonalizationSignalsConsentGranted,
    bool? adUserDataConsentGranted,
    bool? functionalityStorageConsentGranted,
    bool? personalizationStorageConsentGranted,
    bool? securityStorageConsentGranted,
  });

  Future<void> setDefaultEventParameters(
    Map<String, Object?>? defaultParameters,
  );

  Future<void> setAnalyticsCollectionEnabled(bool enabled);

  Future<void> setUserId({
    String? id,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> setUserProperty({
    required String name,
    required String? value,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> resetAnalyticsData();

  Future<void> logAddPaymentInfo({
    String? coupon,
    String? currency,
    String? paymentType,
    double? value,
    List<AnalyticsEventItem>? items,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logAddShippingInfo({
    String? coupon,
    String? currency,
    double? value,
    String? shippingTier,
    List<AnalyticsEventItem>? items,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logAddToCart({
    List<AnalyticsEventItem>? items,
    double? value,
    String? currency,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logAddToWishlist({
    List<AnalyticsEventItem>? items,
    double? value,
    String? currency,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logAdImpression({
    String? adPlatform,
    String? adSource,
    String? adFormat,
    String? adUnitName,
    double? value,
    String? currency,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logAppOpen({
    AnalyticsCallOptions? callOptions,
    Map<String, Object>? parameters,
  });

  Future<void> logBeginCheckout({
    double? value,
    String? currency,
    List<AnalyticsEventItem>? items,
    String? coupon,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logCampaignDetails({
    required String source,
    required String medium,
    required String campaign,
    String? term,
    String? content,
    String? aclid,
    String? cp1,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logEarnVirtualCurrency({
    required String virtualCurrencyName,
    required num value,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logGenerateLead({
    String? currency,
    double? value,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logJoinGroup({
    required String groupId,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logLevelUp({
    required int level,
    String? character,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logLevelStart({
    required String levelName,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logLevelEnd({
    required String levelName,
    int? success,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logLogin({
    String? loginMethod,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logPostScore({
    required int score,
    int? level,
    String? character,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logPurchase({
    String? currency,
    String? coupon,
    double? value,
    List<AnalyticsEventItem>? items,
    double? tax,
    double? shipping,
    String? transactionId,
    String? affiliation,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logRemoveFromCart({
    String? currency,
    double? value,
    List<AnalyticsEventItem>? items,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logScreenView({
    String? screenClass,
    String? screenName,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logSelectItem({
    String? itemListId,
    String? itemListName,
    List<AnalyticsEventItem>? items,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logSelectPromotion({
    String? creativeName,
    String? creativeSlot,
    List<AnalyticsEventItem>? items,
    String? locationId,
    String? promotionId,
    String? promotionName,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logViewCart({
    String? currency,
    double? value,
    List<AnalyticsEventItem>? items,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logSearch({
    required String searchTerm,
    int? numberOfNights,
    int? numberOfRooms,
    int? numberOfPassengers,
    String? origin,
    String? destination,
    String? startDate,
    String? endDate,
    String? travelClass,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
    Map<String, Object>? parameters,
  });

  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
    Map<String, Object>? parameters,
  });

  Future<void> logSignUp({
    required String signUpMethod,
    Map<String, Object>? parameters,
  });

  Future<void> logSpendVirtualCurrency({
    required String itemName,
    required String virtualCurrencyName,
    required num value,
    Map<String, Object>? parameters,
  });

  Future<void> logTutorialBegin({
    Map<String, Object>? parameters,
  });

  Future<void> logTutorialComplete({
    Map<String, Object>? parameters,
  });

  Future<void> logUnlockAchievement({
    required String id,
    Map<String, Object>? parameters,
  });

  Future<void> logViewItem({
    String? currency,
    double? value,
    List<AnalyticsEventItem>? items,
    Map<String, Object>? parameters,
  });

  Future<void> logViewItemList({
    List<AnalyticsEventItem>? items,
    String? itemListId,
    String? itemListName,
    Map<String, Object>? parameters,
  });

  Future<void> logViewPromotion({
    String? creativeName,
    String? creativeSlot,
    List<AnalyticsEventItem>? items,
    String? locationId,
    String? promotionId,
    String? promotionName,
    Map<String, Object>? parameters,
  });

  Future<void> logViewSearchResults({
    required String searchTerm,
    Map<String, Object>? parameters,
  });

  Future<void> logRefund({
    String? currency,
    String? coupon,
    double? value,
    double? tax,
    double? shipping,
    String? transactionId,
    String? affiliation,
    List<AnalyticsEventItem>? items,
    Map<String, Object>? parameters,
  });

  Future<void> logInAppPurchase({
    String? currency,
    bool? freeTrial,
    double? price,
    bool? priceIsDiscounted,
    String? productID,
    String? productName,
    int? quantity,
    bool? subscription,
    num? value,
  });

  Future<void> logTransaction(String transactionId);

  Future<void> setSessionTimeoutDuration(Duration timeout);

  Future<void> initiateOnDeviceConversionMeasurementWithEmailAddress(
    String emailAddress,
  );

  Future<void> initiateOnDeviceConversionMeasurementWithPhoneNumber(
    String phoneNumber,
  );

  Future<void> initiateOnDeviceConversionMeasurementWithHashedEmailAddress(
    String hashedEmailAddress,
  );

  Future<void> initiateOnDeviceConversionMeasurementWithHashedPhoneNumber(
    String hashedPhoneNumber,
  );
}