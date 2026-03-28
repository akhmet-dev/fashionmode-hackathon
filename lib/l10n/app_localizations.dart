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

  /// No description provided for @preorderBadge.
  ///
  /// In en, this message translates to:
  /// **'PRE-ORDER'**
  String get preorderBadge;

  /// No description provided for @buyButton.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get buyButton;

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

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'MY ORDERS'**
  String get myOrders;

  /// No description provided for @loyaltyProgress.
  ///
  /// In en, this message translates to:
  /// **'LOYALTY PROGRESS'**
  String get loyaltyProgress;

  /// No description provided for @ordersToNextTier.
  ///
  /// In en, this message translates to:
  /// **'{count} / 10 ORDERS TO NEXT TIER'**
  String ordersToNextTier(int count);

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

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'DASHBOARD'**
  String get dashboard;

  /// No description provided for @todayRevenue.
  ///
  /// In en, this message translates to:
  /// **'TODAY REVENUE'**
  String get todayRevenue;

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

  /// No description provided for @production.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTION'**
  String get production;

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
