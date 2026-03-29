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
  String get catalogNavLabel => 'CATALOG';

  @override
  String get ordersNavLabel => 'ORDERS';

  @override
  String get cartNavLabel => 'CART';

  @override
  String get dashboardNavLabel => 'TOWER';

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
  String get clientShowroomLabel => 'CLIENT SHOWROOM';

  @override
  String get preorderBadge => 'PRE-ORDER';

  @override
  String get inStockLabel => 'IN STOCK';

  @override
  String get inStockDescription =>
      'This piece is available for immediate checkout. Once confirmed, the order enters the franchisee control tower and then the production queue.';

  @override
  String get preorderDescription =>
      'This piece is available on pre-order. Select a ready date to lock the production slot before sending it forward.';

  @override
  String get buyButton => 'BUY';

  @override
  String get addToCartButton => 'ADD TO CART';

  @override
  String get preorderButton => 'PRE-ORDER';

  @override
  String get selectDeliveryDate => 'SELECT DELIVERY DATE';

  @override
  String get addedToCartTitle => 'ADDED TO CART';

  @override
  String addedToCartMessage(String product) {
    return '$product is waiting in your cart for checkout.';
  }

  @override
  String get openCartButton => 'OPEN CART';

  @override
  String get continueShoppingButton => 'CONTINUE';

  @override
  String get orderPlacedTitle => 'ORDER PLACED';

  @override
  String orderPlacedMessage(String product) {
    return '$product is now in processing. The next step is franchisee confirmation.';
  }

  @override
  String orderPlacedMultipleMessage(int count) {
    return '$count items were placed and pushed into the live order flow.';
  }

  @override
  String get trackOrderButton => 'TRACK ORDER';

  @override
  String get myOrders => 'MY ORDERS';

  @override
  String get notificationsTitle => 'MESSAGES';

  @override
  String get notificationsEmpty => 'NO NOTIFICATIONS YET';

  @override
  String notificationsSummary(int count) {
    return 'NEW MESSAGES: $count';
  }

  @override
  String get loyaltyProgress => 'LOYALTY PROGRESS';

  @override
  String get loyaltyTapHint => 'TAP TO VIEW LEVELS';

  @override
  String loyaltyLevelLabel(String level) {
    return 'LEVEL: $level';
  }

  @override
  String loyaltyToNextLevel(int count, String level) {
    return '$count ORDERS TO LEVEL $level';
  }

  @override
  String get loyaltyMaxLevelMessage => 'MAXIMUM LEVEL REACHED';

  @override
  String get loyaltyDetailsTitle => 'LOYALTY LEVELS';

  @override
  String get loyaltyCurrentStatus => 'CURRENT LEVEL';

  @override
  String loyaltyUnlockedAt(int count) {
    return 'FROM $count ORDERS';
  }

  @override
  String loyaltyRangeBetween(int start, int end) {
    return 'FROM $start TO $end ORDERS';
  }

  @override
  String loyaltyRangeFrom(int start) {
    return 'FROM $start ORDERS';
  }

  @override
  String get loyaltyLevelNovice => 'NOVICE';

  @override
  String get loyaltyLevelStyleLover => 'STYLE LOVER';

  @override
  String get loyaltyLevelFashionista => 'FASHIONISTA';

  @override
  String get loyaltyLevelStylist => 'STYLIST';

  @override
  String get loyaltyLevelStyleExpert => 'STYLE EXPERT';

  @override
  String get loyaltyLevelStyleIcon => 'STYLE ICON';

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
  String clientOrderAcceptedNotification(String product) {
    return '$product was accepted and moved to sewing.';
  }

  @override
  String clientOrderReadyNotification(String product) {
    return '$product is ready. Open order tracking for the latest status.';
  }

  @override
  String get cartTitle => 'CART';

  @override
  String cartItemsCount(int count) {
    return '$count ITEMS';
  }

  @override
  String get cartSelectionTitle => 'SELECTION';

  @override
  String get cartSelectionHint =>
      'Mark the pieces you want to checkout, remove the rest, and place only the selected items.';

  @override
  String get cartEmptyMessage => 'YOUR CART IS EMPTY';

  @override
  String selectedItemsLabel(int count) {
    return 'SELECTED: $count';
  }

  @override
  String get buySelectedButton => 'BUY SELECTED';

  @override
  String get removeButton => 'REMOVE';

  @override
  String get dashboard => 'DASHBOARD';

  @override
  String get controlTowerTitle => 'CONTROL TOWER';

  @override
  String get controlTowerSubtitle => 'LIVE FRANCHISEE VIEW';

  @override
  String get todayRevenue => 'TODAY REVENUE';

  @override
  String dailyGoalLabel(String target) {
    return 'TODAY TARGET: ₸$target';
  }

  @override
  String get editPlanButton => 'EDIT TARGET';

  @override
  String get setPlanTitle => 'TODAY\'S TARGET';

  @override
  String get setPlanHint =>
      'Set your revenue target for the day so the control tower calculates progress against your real plan.';

  @override
  String get setPlanInputHint => 'FOR EXAMPLE, 250000';

  @override
  String get savePlanButton => 'SAVE TARGET';

  @override
  String get plan => 'PLAN';

  @override
  String get activeOrders => 'ACTIVE ORDERS';

  @override
  String get recentOrders => 'RECENT ORDERS';

  @override
  String get noOrders => 'NO ORDERS';

  @override
  String planProgressLabel(int percent, String target) {
    return '$percent% OF TARGET ₸$target';
  }

  @override
  String get completionRateLabel => 'READY RATE';

  @override
  String get averageCheckLabel => 'AVG CHECK';

  @override
  String get orderFlowTitle => 'ORDER FLOW';

  @override
  String get newOrdersLabel => 'NEW';

  @override
  String get sewingLoadLabel => 'SEWING';

  @override
  String get readyOrdersLabel => 'READY';

  @override
  String get liveOrdersTitle => 'LIVE FEED';

  @override
  String franchiseeNewOrderNotification(String product) {
    return 'New order: $product. Review and accept it.';
  }

  @override
  String franchiseeOrderReadyNotification(String product) {
    return '$product was completed by production and is ready to hand over.';
  }

  @override
  String get allOrders => 'ALL ORDERS';

  @override
  String get acceptSewing => 'ACCEPT → SEWING';

  @override
  String get searchHint => 'SEARCH BY NAME...';

  @override
  String get acceptOrderTitle => 'ACCEPT THIS ORDER?';

  @override
  String acceptOrderMessage(String product) {
    return '$product will move into sewing and instantly appear on the production tablet.';
  }

  @override
  String get production => 'PRODUCTION';

  @override
  String get productionSubtitle => 'MASTER TABLET';

  @override
  String get sewingQueue => 'SEWING QUEUE';

  @override
  String get noItems => 'NO ITEMS';

  @override
  String get queueEmpty => 'QUEUE IS EMPTY';

  @override
  String get complete => 'COMPLETE';

  @override
  String get completeOrderTitle => 'COMPLETE THIS ORDER?';

  @override
  String completeOrderMessage(String product) {
    return '$product will be marked ready and both client and franchisee will receive the status update.';
  }

  @override
  String productionTaskNotification(String product) {
    return 'New queue task: $product.';
  }
}
