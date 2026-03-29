// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appName => 'AVISHU';

  @override
  String get appSubtitle => 'СУПЕРҚОСЫМША';

  @override
  String get logout => 'ШЫҒУ';

  @override
  String get catalogNavLabel => 'CATALOG';

  @override
  String get ordersNavLabel => 'ORDERS';

  @override
  String get cartNavLabel => 'CART';

  @override
  String get dashboardNavLabel => 'TOWER';

  @override
  String get emailLabel => 'ЭМЕЙЛ';

  @override
  String get emailHint => 'сіздің@email.com';

  @override
  String get passwordLabel => 'ҚҰПИЯ СӨЗ';

  @override
  String get passwordHint => '••••••';

  @override
  String get signIn => 'КІРУ';

  @override
  String get authFailed => 'Авторизация қатесі';

  @override
  String get newCollection => 'ЖАҢА КОЛЛЕКЦИЯ';

  @override
  String get season => 'КӨКТЕМ / ЖАЗ 2026';

  @override
  String get clientShowroomLabel => 'CLIENT SHOWROOM';

  @override
  String get preorderBadge => 'АЛДЫН АЛА';

  @override
  String get inStockLabel => 'ҚОЛДА БАР';

  @override
  String get inStockDescription =>
      'Бұл өнімді бірден рәсімдеуге болады. Тапсырыс бірден франчайзи басқару мұнарасына және кейін өндіріс кезегіне түседі.';

  @override
  String get preorderDescription =>
      'Бұл өнім алдын ала тапсырыспен беріледі. Өндіріс слотын бекіту үшін дайын болу күнін таңдаңыз.';

  @override
  String get buyButton => 'САТЫП АЛУ';

  @override
  String get addToCartButton => 'СЕБЕТКЕ';

  @override
  String get preorderButton => 'АЛДЫН АЛА ТАПСЫРЫС';

  @override
  String get selectDeliveryDate => 'ЖЕТКІЗУ КҮНІН ТАҢДАҢЫЗ';

  @override
  String get addedToCartTitle => 'СЕБЕТКЕ ҚОСЫЛДЫ';

  @override
  String addedToCartMessage(String product) {
    return '$product себетке қосылды және рәсімдеуге дайын.';
  }

  @override
  String get openCartButton => 'СЕБЕТТІ АШУ';

  @override
  String get continueShoppingButton => 'ЖАЛҒАСТЫРУ';

  @override
  String get orderPlacedTitle => 'ТАПСЫРЫС РӘСІМДЕЛДІ';

  @override
  String orderPlacedMessage(String product) {
    return '$product өңдеуге жіберілді. Келесі қадам — франчайзи растауы.';
  }

  @override
  String orderPlacedMultipleMessage(int count) {
    return '$count өнім рәсімделіп, ортақ тапсырыс ағынына жіберілді.';
  }

  @override
  String get trackOrderButton => 'ТАПСЫРЫСТЫ ҚАДАҒАЛАУ';

  @override
  String get myOrders => 'МЕНІҢ ТАПСЫРЫСТАРЫМ';

  @override
  String get notificationsTitle => 'ХАБАРЛАМАЛАР';

  @override
  String get notificationsEmpty => 'ХАБАРЛАМАЛАР ӘЗІРГЕ ЖОҚ';

  @override
  String notificationsSummary(int count) {
    return 'ЖАҢА ХАБАРЛАМАЛАР: $count';
  }

  @override
  String get loyaltyProgress => 'АДАЛДЫҚ ПРОГРЕСІ';

  @override
  String get loyaltyTapHint => 'ДЕҢГЕЙЛЕРДІ КӨРУ ҮШІН БАСЫҢЫЗ';

  @override
  String loyaltyLevelLabel(String level) {
    return 'ДЕҢГЕЙ: $level';
  }

  @override
  String loyaltyToNextLevel(int count, String level) {
    return '$level ДЕҢГЕЙІНЕ ДЕЙІН ТАҒЫ $count ТАПСЫРЫС';
  }

  @override
  String get loyaltyMaxLevelMessage => 'ЕҢ ЖОҒАРЫ ДЕҢГЕЙГЕ ЖЕТТІҢІЗ';

  @override
  String get loyaltyDetailsTitle => 'АДАЛДЫҚ ДЕҢГЕЙЛЕРІ';

  @override
  String get loyaltyCurrentStatus => 'ҚАЗІРГІ ДЕҢГЕЙ';

  @override
  String loyaltyUnlockedAt(int count) {
    return '$count ТАПСЫРЫСТАН БАСТАП';
  }

  @override
  String loyaltyRangeBetween(int start, int end) {
    return '$start-ТЕН $end-КЕ ДЕЙІН ТАПСЫРЫС';
  }

  @override
  String loyaltyRangeFrom(int start) {
    return '$start ТАПСЫРЫСТАН БАСТАП';
  }

  @override
  String get loyaltyLevelNovice => 'ЖАҢАДАН БАСТАУШЫ';

  @override
  String get loyaltyLevelStyleLover => 'СТИЛЬ СҮЙЕР';

  @override
  String get loyaltyLevelFashionista => 'СӘНҚОЙ';

  @override
  String get loyaltyLevelStylist => 'СТИЛИСТ';

  @override
  String get loyaltyLevelStyleExpert => 'СТИЛЬ САРАПШЫСЫ';

  @override
  String get loyaltyLevelStyleIcon => 'СТИЛЬ ИКОНАСЫ';

  @override
  String get noOrdersYet => 'ТАПСЫРЫСТАР ЖОҚ';

  @override
  String get statusPlaced => 'ҚАБЫЛДАНДЫ';

  @override
  String get statusSewing => 'ТІГІЛУДЕ';

  @override
  String get statusReady => 'ДАЙЫН';

  @override
  String get cancelButton => 'ТАПСЫРЫСТЫ БОЛДЫРМАУ';

  @override
  String get cancelConfirmTitle => 'БОЛДЫРМАУ?';

  @override
  String get cancelConfirmMessage => 'Бұл әрекетті қайтара алмайсыз.';

  @override
  String get confirmButton => 'РАСТАУ';

  @override
  String get dismissButton => 'ЖАБУ';

  @override
  String get orderReadyBanner => 'Тапсырысыңыз дайын! 🎉';

  @override
  String clientOrderAcceptedNotification(String product) {
    return '$product қабылданып, тігуге жіберілді.';
  }

  @override
  String clientOrderReadyNotification(String product) {
    return '$product дайын. Соңғы статусты көру үшін трекингті ашыңыз.';
  }

  @override
  String get cartTitle => 'СЕБЕТ';

  @override
  String cartItemsCount(int count) {
    return '$count ӨНІМ';
  }

  @override
  String get cartSelectionTitle => 'ТАҢДАУ';

  @override
  String get cartSelectionHint =>
      'Рәсімдейтін өнімдерді белгілеңіз, артықтарын алып тастаңыз және тек таңдалғандарын сатып алыңыз.';

  @override
  String get cartEmptyMessage => 'СЕБЕТ ӘЗІРГЕ БОС';

  @override
  String selectedItemsLabel(int count) {
    return 'ТАҢДАЛДЫ: $count';
  }

  @override
  String get buySelectedButton => 'ТАҢДАЛҒАНДЫ САТЫП АЛУ';

  @override
  String get removeButton => 'ӨШІРУ';

  @override
  String get dashboard => 'БАСҚАРУ ТАҚТАСЫ';

  @override
  String get controlTowerTitle => 'БАСҚАРУ МҰНАРАСЫ';

  @override
  String get controlTowerSubtitle => 'LIVE FRANCHISEE VIEW';

  @override
  String get todayRevenue => 'БҮГІНГІ ТҮСІМ';

  @override
  String dailyGoalLabel(String target) {
    return 'КҮНДІК МАҚСАТ: ₸$target';
  }

  @override
  String get editPlanButton => 'МАҚСАТТЫ ӨЗГЕРТУ';

  @override
  String get setPlanTitle => 'БҮГІНГІ МАҚСАТ';

  @override
  String get setPlanHint =>
      'Басқару мұнарасы орындалуды нақты жоспарыңызға қатысты есептеуі үшін күндік түсім мақсатын енгізіңіз.';

  @override
  String get setPlanInputHint => 'МЫСАЛЫ, 250000';

  @override
  String get savePlanButton => 'МАҚСАТТЫ САҚТАУ';

  @override
  String get plan => 'ЖОСПАР';

  @override
  String get activeOrders => 'БЕЛСЕНДІ ТАПСЫРЫСТАР';

  @override
  String get recentOrders => 'СОҢҒЫ ТАПСЫРЫСТАР';

  @override
  String get noOrders => 'ТАПСЫРЫСТАР ЖОҚ';

  @override
  String planProgressLabel(int percent, String target) {
    return 'МАҚСАТТЫҢ $percent% ₸$target';
  }

  @override
  String get completionRateLabel => 'ДАЙЫН';

  @override
  String get averageCheckLabel => 'ОРТА ЧЕК';

  @override
  String get orderFlowTitle => 'ТАПСЫРЫС АҒЫНЫ';

  @override
  String get newOrdersLabel => 'ЖАҢА';

  @override
  String get sewingLoadLabel => 'ТІГІЛУДЕ';

  @override
  String get readyOrdersLabel => 'ДАЙЫН';

  @override
  String get liveOrdersTitle => 'ТІКЕЛЕЙ ЛЕНТА';

  @override
  String franchiseeNewOrderNotification(String product) {
    return 'Жаңа тапсырыс: $product. Қарап, жұмысқа қабылдаңыз.';
  }

  @override
  String franchiseeOrderReadyNotification(String product) {
    return '$product өндірісте аяқталып, беруге дайын.';
  }

  @override
  String get allOrders => 'БАРЛЫҚ ТАПСЫРЫСТАР';

  @override
  String get acceptSewing => 'ҚАБЫЛДАУ → ТІГУ';

  @override
  String get searchHint => 'АТЫ БОЙЫНША ІЗДЕУ...';

  @override
  String get acceptOrderTitle => 'ТАПСЫРЫСТЫ ҚАБЫЛДАУ?';

  @override
  String acceptOrderMessage(String product) {
    return '$product тігуге өтеді және бірден өндіріс планшетінде көрінеді.';
  }

  @override
  String get production => 'ӨНДІРІС';

  @override
  String get productionSubtitle => 'MASTER TABLET';

  @override
  String get sewingQueue => 'ТІГІН КЕЗЕГІ';

  @override
  String get noItems => 'ТАПСЫРМА ЖОҚ';

  @override
  String get queueEmpty => 'КЕЗЕК БОС';

  @override
  String get complete => 'АЯҚТАУ';

  @override
  String get completeOrderTitle => 'ТАПСЫРЫСТЫ АЯҚТАУ?';

  @override
  String completeOrderMessage(String product) {
    return '$product дайын деп белгіленеді, ал клиент пен франчайзи статус жаңартуын алады.';
  }

  @override
  String productionTaskNotification(String product) {
    return 'Кезекте жаңа тапсырма: $product.';
  }
}
