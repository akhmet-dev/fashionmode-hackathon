import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AVISHU'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'SUPERAPP'**
  String get appSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT'**
  String get logout;

  /// No description provided for @catalogNavLabel.
  ///
  /// In en, this message translates to:
  /// **'CATALOG'**
  String get catalogNavLabel;

  /// No description provided for @ordersNavLabel.
  ///
  /// In en, this message translates to:
  /// **'ORDERS'**
  String get ordersNavLabel;

  /// No description provided for @cartNavLabel.
  ///
  /// In en, this message translates to:
  /// **'CART'**
  String get cartNavLabel;

  /// No description provided for @dashboardNavLabel.
  ///
  /// In en, this message translates to:
  /// **'TOWER'**
  String get dashboardNavLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••'**
  String get passwordHint;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signIn;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authFailed;

  /// No description provided for @newCollection.
  ///
  /// In en, this message translates to:
  /// **'NEW COLLECTION'**
  String get newCollection;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'SPRING / SUMMER 2026'**
  String get season;

  /// No description provided for @clientShowroomLabel.
  ///
  /// In en, this message translates to:
  /// **'CLIENT SHOWROOM'**
  String get clientShowroomLabel;

  /// No description provided for @preorderBadge.
  ///
  /// In en, this message translates to:
  /// **'PRE-ORDER'**
  String get preorderBadge;

  /// No description provided for @inStockLabel.
  ///
  /// In en, this message translates to:
  /// **'IN STOCK'**
  String get inStockLabel;

  /// No description provided for @inStockDescription.
  ///
  /// In en, this message translates to:
  /// **'This piece is available for immediate checkout. Once confirmed, the order enters the franchisee control tower and then the production queue.'**
  String get inStockDescription;

  /// No description provided for @preorderDescription.
  ///
  /// In en, this message translates to:
  /// **'This piece is available on pre-order. Select a ready date to lock the production slot before sending it forward.'**
  String get preorderDescription;

  /// No description provided for @buyButton.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get buyButton;

  /// No description provided for @addToCartButton.
  ///
  /// In en, this message translates to:
  /// **'ADD TO CART'**
  String get addToCartButton;

  /// No description provided for @preorderButton.
  ///
  /// In en, this message translates to:
  /// **'PRE-ORDER'**
  String get preorderButton;

  /// No description provided for @selectDeliveryDate.
  ///
  /// In en, this message translates to:
  /// **'SELECT DELIVERY DATE'**
  String get selectDeliveryDate;

  /// No description provided for @addedToCartTitle.
  ///
  /// In en, this message translates to:
  /// **'ADDED TO CART'**
  String get addedToCartTitle;

  /// No description provided for @addedToCartMessage.
  ///
  /// In en, this message translates to:
  /// **'{product} is waiting in your cart for checkout.'**
  String addedToCartMessage(String product);

  /// No description provided for @openCartButton.
  ///
  /// In en, this message translates to:
  /// **'OPEN CART'**
  String get openCartButton;

  /// No description provided for @continueShoppingButton.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueShoppingButton;

  /// No description provided for @orderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'ORDER PLACED'**
  String get orderPlacedTitle;

  /// No description provided for @orderPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'{product} is now in processing. The next step is franchisee confirmation.'**
  String orderPlacedMessage(String product);

  /// No description provided for @orderPlacedMultipleMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} items were placed and pushed into the live order flow.'**
  String orderPlacedMultipleMessage(int count);

  /// No description provided for @trackOrderButton.
  ///
  /// In en, this message translates to:
  /// **'TRACK ORDER'**
  String get trackOrderButton;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'MY ORDERS'**
  String get myOrders;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'MESSAGES'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'NO NOTIFICATIONS YET'**
  String get notificationsEmpty;

  /// No description provided for @notificationsSummary.
  ///
  /// In en, this message translates to:
  /// **'NEW MESSAGES: {count}'**
  String notificationsSummary(int count);

  /// No description provided for @loyaltyProgress.
  ///
  /// In en, this message translates to:
  /// **'LOYALTY PROGRESS'**
  String get loyaltyProgress;

  /// No description provided for @loyaltyTapHint.
  ///
  /// In en, this message translates to:
  /// **'TAP TO VIEW LEVELS'**
  String get loyaltyTapHint;

  /// No description provided for @loyaltyLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'LEVEL: {level}'**
  String loyaltyLevelLabel(String level);

  /// No description provided for @loyaltyToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'{count} ORDERS TO LEVEL {level}'**
  String loyaltyToNextLevel(int count, String level);

  /// No description provided for @loyaltyMaxLevelMessage.
  ///
  /// In en, this message translates to:
  /// **'MAXIMUM LEVEL REACHED'**
  String get loyaltyMaxLevelMessage;

  /// No description provided for @loyaltyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'LOYALTY LEVELS'**
  String get loyaltyDetailsTitle;

  /// No description provided for @loyaltyCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'CURRENT LEVEL'**
  String get loyaltyCurrentStatus;

  /// No description provided for @loyaltyUnlockedAt.
  ///
  /// In en, this message translates to:
  /// **'FROM {count} ORDERS'**
  String loyaltyUnlockedAt(int count);

  /// No description provided for @loyaltyRangeBetween.
  ///
  /// In en, this message translates to:
  /// **'FROM {start} TO {end} ORDERS'**
  String loyaltyRangeBetween(int start, int end);

  /// No description provided for @loyaltyRangeFrom.
  ///
  /// In en, this message translates to:
  /// **'FROM {start} ORDERS'**
  String loyaltyRangeFrom(int start);

  /// No description provided for @loyaltyLevelNovice.
  ///
  /// In en, this message translates to:
  /// **'NOVICE'**
  String get loyaltyLevelNovice;

  /// No description provided for @loyaltyLevelStyleLover.
  ///
  /// In en, this message translates to:
  /// **'STYLE LOVER'**
  String get loyaltyLevelStyleLover;

  /// No description provided for @loyaltyLevelFashionista.
  ///
  /// In en, this message translates to:
  /// **'FASHIONISTA'**
  String get loyaltyLevelFashionista;

  /// No description provided for @loyaltyLevelStylist.
  ///
  /// In en, this message translates to:
  /// **'STYLIST'**
  String get loyaltyLevelStylist;

  /// No description provided for @loyaltyLevelStyleExpert.
  ///
  /// In en, this message translates to:
  /// **'STYLE EXPERT'**
  String get loyaltyLevelStyleExpert;

  /// No description provided for @loyaltyLevelStyleIcon.
  ///
  /// In en, this message translates to:
  /// **'STYLE ICON'**
  String get loyaltyLevelStyleIcon;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'NO ORDERS YET'**
  String get noOrdersYet;

  /// No description provided for @statusPlaced.
  ///
  /// In en, this message translates to:
  /// **'PLACED'**
  String get statusPlaced;

  /// No description provided for @statusSewing.
  ///
  /// In en, this message translates to:
  /// **'SEWING'**
  String get statusSewing;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get statusReady;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'CANCEL ORDER'**
  String get cancelButton;

  /// No description provided for @cancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'CANCEL ORDER?'**
  String get cancelConfirmTitle;

  /// No description provided for @cancelConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cancelConfirmMessage;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM'**
  String get confirmButton;

  /// No description provided for @dismissButton.
  ///
  /// In en, this message translates to:
  /// **'DISMISS'**
  String get dismissButton;

  /// No description provided for @orderReadyBanner.
  ///
  /// In en, this message translates to:
  /// **'Your order is ready! 🎉'**
  String get orderReadyBanner;

  /// No description provided for @clientOrderAcceptedNotification.
  ///
  /// In en, this message translates to:
  /// **'{product} was accepted and moved to sewing.'**
  String clientOrderAcceptedNotification(String product);

  /// No description provided for @clientOrderReadyNotification.
  ///
  /// In en, this message translates to:
  /// **'{product} is ready. Open order tracking for the latest status.'**
  String clientOrderReadyNotification(String product);

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'CART'**
  String get cartTitle;

  /// No description provided for @cartItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ITEMS'**
  String cartItemsCount(int count);

  /// No description provided for @cartSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'SELECTION'**
  String get cartSelectionTitle;

  /// No description provided for @cartSelectionHint.
  ///
  /// In en, this message translates to:
  /// **'Mark the pieces you want to checkout, remove the rest, and place only the selected items.'**
  String get cartSelectionHint;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'YOUR CART IS EMPTY'**
  String get cartEmptyMessage;

  /// No description provided for @selectedItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'SELECTED: {count}'**
  String selectedItemsLabel(int count);

  /// No description provided for @buySelectedButton.
  ///
  /// In en, this message translates to:
  /// **'BUY SELECTED'**
  String get buySelectedButton;

  /// No description provided for @removeButton.
  ///
  /// In en, this message translates to:
  /// **'REMOVE'**
  String get removeButton;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'DASHBOARD'**
  String get dashboard;

  /// No description provided for @controlTowerTitle.
  ///
  /// In en, this message translates to:
  /// **'CONTROL TOWER'**
  String get controlTowerTitle;

  /// No description provided for @controlTowerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'LIVE FRANCHISEE VIEW'**
  String get controlTowerSubtitle;

  /// No description provided for @todayRevenue.
  ///
  /// In en, this message translates to:
  /// **'TODAY REVENUE'**
  String get todayRevenue;

  /// No description provided for @dailyGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'TODAY TARGET: ₸{target}'**
  String dailyGoalLabel(String target);

  /// No description provided for @editPlanButton.
  ///
  /// In en, this message translates to:
  /// **'EDIT TARGET'**
  String get editPlanButton;

  /// No description provided for @setPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S TARGET'**
  String get setPlanTitle;

  /// No description provided for @setPlanHint.
  ///
  /// In en, this message translates to:
  /// **'Set your revenue target for the day so the control tower calculates progress against your real plan.'**
  String get setPlanHint;

  /// No description provided for @setPlanInputHint.
  ///
  /// In en, this message translates to:
  /// **'FOR EXAMPLE, 250000'**
  String get setPlanInputHint;

  /// No description provided for @savePlanButton.
  ///
  /// In en, this message translates to:
  /// **'SAVE TARGET'**
  String get savePlanButton;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'PLAN'**
  String get plan;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE ORDERS'**
  String get activeOrders;

  /// No description provided for @recentOrders.
  ///
  /// In en, this message translates to:
  /// **'RECENT ORDERS'**
  String get recentOrders;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'NO ORDERS'**
  String get noOrders;

  /// No description provided for @planProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}% OF TARGET ₸{target}'**
  String planProgressLabel(int percent, String target);

  /// No description provided for @completionRateLabel.
  ///
  /// In en, this message translates to:
  /// **'READY RATE'**
  String get completionRateLabel;

  /// No description provided for @averageCheckLabel.
  ///
  /// In en, this message translates to:
  /// **'AVG CHECK'**
  String get averageCheckLabel;

  /// No description provided for @orderFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'ORDER FLOW'**
  String get orderFlowTitle;

  /// No description provided for @newOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newOrdersLabel;

  /// No description provided for @sewingLoadLabel.
  ///
  /// In en, this message translates to:
  /// **'SEWING'**
  String get sewingLoadLabel;

  /// No description provided for @readyOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get readyOrdersLabel;

  /// No description provided for @liveOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'LIVE FEED'**
  String get liveOrdersTitle;

  /// No description provided for @franchiseeNewOrderNotification.
  ///
  /// In en, this message translates to:
  /// **'New order: {product}. Review and accept it.'**
  String franchiseeNewOrderNotification(String product);

  /// No description provided for @franchiseeOrderReadyNotification.
  ///
  /// In en, this message translates to:
  /// **'{product} was completed by production and is ready to hand over.'**
  String franchiseeOrderReadyNotification(String product);

  /// No description provided for @allOrders.
  ///
  /// In en, this message translates to:
  /// **'ALL ORDERS'**
  String get allOrders;

  /// No description provided for @acceptSewing.
  ///
  /// In en, this message translates to:
  /// **'ACCEPT → SEWING'**
  String get acceptSewing;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'SEARCH BY NAME...'**
  String get searchHint;

  /// No description provided for @acceptOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'ACCEPT THIS ORDER?'**
  String get acceptOrderTitle;

  /// No description provided for @acceptOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'{product} will move into sewing and instantly appear on the production tablet.'**
  String acceptOrderMessage(String product);

  /// No description provided for @production.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTION'**
  String get production;

  /// No description provided for @productionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'MASTER TABLET'**
  String get productionSubtitle;

  /// No description provided for @sewingQueue.
  ///
  /// In en, this message translates to:
  /// **'SEWING QUEUE'**
  String get sewingQueue;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'NO ITEMS'**
  String get noItems;

  /// No description provided for @queueEmpty.
  ///
  /// In en, this message translates to:
  /// **'QUEUE IS EMPTY'**
  String get queueEmpty;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'COMPLETE'**
  String get complete;

  /// No description provided for @completeOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'COMPLETE THIS ORDER?'**
  String get completeOrderTitle;

  /// No description provided for @completeOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'{product} will be marked ready and both client and franchisee will receive the status update.'**
  String completeOrderMessage(String product);

  /// No description provided for @productionTaskNotification.
  ///
  /// In en, this message translates to:
  /// **'New queue task: {product}.'**
  String productionTaskNotification(String product);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
