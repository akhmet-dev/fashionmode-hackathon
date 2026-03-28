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
  String get preorderBadge => 'АЛДЫН АЛА';

  @override
  String get buyButton => 'САТЫП АЛУ';

  @override
  String get preorderButton => 'АЛДЫН АЛА ТАПСЫРЫС';

  @override
  String get selectDeliveryDate => 'ЖЕТКІЗУ КҮНІН ТАҢДАҢЫЗ';

  @override
  String get myOrders => 'МЕНІҢ ТАПСЫРЫСТАРЫМ';

  @override
  String get loyaltyProgress => 'АДАЛДЫҚ ПРОГРЕСІ';

  @override
  String ordersToNextTier(int count) {
    return '$count / 10 КЕЛЕСІ ДЕҢГЕЙГЕ ТАПСЫРЫС';
  }

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
  String get dashboard => 'БАСҚАРУ ТАҚТАСЫ';

  @override
  String get todayRevenue => 'БҮГІНГІ ТҮСІМ';

  @override
  String get plan => 'ЖОСПАР';

  @override
  String get activeOrders => 'БЕЛСЕНДІ ТАПСЫРЫСТАР';

  @override
  String get recentOrders => 'СОҢҒЫ ТАПСЫРЫСТАР';

  @override
  String get noOrders => 'ТАПСЫРЫСТАР ЖОҚ';

  @override
  String get allOrders => 'БАРЛЫҚ ТАПСЫРЫСТАР';

  @override
  String get acceptSewing => 'ҚАБЫЛДАУ → ТІГУ';

  @override
  String get searchHint => 'АТЫ БОЙЫНША ІЗДЕУ...';

  @override
  String get production => 'ӨНДІРІС';

  @override
  String get sewingQueue => 'ТІГІН КЕЗЕГІ';

  @override
  String get noItems => 'ТАПСЫРМА ЖОҚ';

  @override
  String get queueEmpty => 'КЕЗЕК БОС';

  @override
  String get complete => 'АЯҚТАУ';
}
