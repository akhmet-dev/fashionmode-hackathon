// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AVISHU';

  @override
  String get appSubtitle => 'SUPERAPP';

  @override
  String get logout => 'LOGOUT';

  @override
  String get emailLabel => 'EMAIL';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get passwordLabel => 'PASSWORD';

  @override
  String get passwordHint => '••••••';

  @override
  String get signIn => 'SIGN IN';

  @override
  String get authFailed => 'Authentication failed';

  @override
  String get newCollection => 'NEW COLLECTION';

  @override
  String get season => 'SPRING / SUMMER 2026';

  @override
  String get preorderBadge => 'PRE-ORDER';

  @override
  String get buyButton => 'BUY';

  @override
  String get preorderButton => 'PRE-ORDER';

  @override
  String get selectDeliveryDate => 'SELECT DELIVERY DATE';

  @override
  String get myOrders => 'MY ORDERS';

  @override
  String get loyaltyProgress => 'LOYALTY PROGRESS';

  @override
  String ordersToNextTier(int count) {
    return '$count / 10 ORDERS TO NEXT TIER';
  }

  @override
  String get noOrdersYet => 'NO ORDERS YET';

  @override
  String get statusPlaced => 'PLACED';

  @override
  String get statusSewing => 'SEWING';

  @override
  String get statusReady => 'READY';

  @override
  String get cancelButton => 'CANCEL ORDER';

  @override
  String get cancelConfirmTitle => 'CANCEL ORDER?';

  @override
  String get cancelConfirmMessage => 'This action cannot be undone.';

  @override
  String get confirmButton => 'CONFIRM';

  @override
  String get dismissButton => 'DISMISS';

  @override
  String get orderReadyBanner => 'Your order is ready! 🎉';

  @override
  String get dashboard => 'DASHBOARD';

  @override
  String get todayRevenue => 'TODAY REVENUE';

  @override
  String get plan => 'PLAN';

  @override
  String get activeOrders => 'ACTIVE ORDERS';

  @override
  String get recentOrders => 'RECENT ORDERS';

  @override
  String get noOrders => 'NO ORDERS';

  @override
  String get allOrders => 'ALL ORDERS';

  @override
  String get acceptSewing => 'ACCEPT → SEWING';

  @override
  String get searchHint => 'SEARCH BY NAME...';

  @override
  String get production => 'PRODUCTION';

  @override
  String get sewingQueue => 'SEWING QUEUE';

  @override
  String get noItems => 'NO ITEMS';

  @override
  String get queueEmpty => 'QUEUE IS EMPTY';

  @override
  String get complete => 'COMPLETE';
}
