// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'AVISHU';

  @override
  String get appSubtitle => 'СУПЕРАПП';

  @override
  String get logout => 'ВЫЙТИ';

  @override
  String get emailLabel => 'ЭЛ. ПОЧТА';

  @override
  String get emailHint => 'ваш@email.com';

  @override
  String get passwordLabel => 'ПАРОЛЬ';

  @override
  String get passwordHint => '••••••';

  @override
  String get signIn => 'ВОЙТИ';

  @override
  String get authFailed => 'Ошибка авторизации';

  @override
  String get newCollection => 'НОВАЯ КОЛЛЕКЦИЯ';

  @override
  String get season => 'ВЕСНА / ЛЕТО 2026';

  @override
  String get preorderBadge => 'ПРЕДЗАКАЗ';

  @override
  String get buyButton => 'КУПИТЬ';

  @override
  String get preorderButton => 'ПРЕДЗАКАЗ';

  @override
  String get selectDeliveryDate => 'ВЫБРАТЬ ДАТУ ДОСТАВКИ';

  @override
  String get myOrders => 'МОИ ЗАКАЗЫ';

  @override
  String get loyaltyProgress => 'ПРОГРЕСС ЛОЯЛЬНОСТИ';

  @override
  String ordersToNextTier(int count) {
    return '$count / 10 ЗАКАЗОВ ДО СЛЕДУЮЩЕГО УРОВНЯ';
  }

  @override
  String get noOrdersYet => 'ЗАКАЗОВ ЕЩЁ НЕТ';

  @override
  String get statusPlaced => 'ПРИНЯТО';

  @override
  String get statusSewing => 'ПОШИВ';

  @override
  String get statusReady => 'ГОТОВО';

  @override
  String get cancelButton => 'ОТМЕНИТЬ ЗАКАЗ';

  @override
  String get cancelConfirmTitle => 'ОТМЕНИТЬ ЗАКАЗ?';

  @override
  String get cancelConfirmMessage => 'Это действие нельзя отменить.';

  @override
  String get confirmButton => 'ПОДТВЕРДИТЬ';

  @override
  String get dismissButton => 'ЗАКРЫТЬ';

  @override
  String get orderReadyBanner => 'Ваш заказ готов! 🎉';

  @override
  String get dashboard => 'ДАШБОРД';

  @override
  String get todayRevenue => 'ВЫРУЧКА СЕГОДНЯ';

  @override
  String get plan => 'ПЛАН';

  @override
  String get activeOrders => 'АКТИВНЫЕ ЗАКАЗЫ';

  @override
  String get recentOrders => 'НЕДАВНИЕ ЗАКАЗЫ';

  @override
  String get noOrders => 'НЕТ ЗАКАЗОВ';

  @override
  String get allOrders => 'ВСЕ ЗАКАЗЫ';

  @override
  String get acceptSewing => 'ПРИНЯТЬ → ПОШИВ';

  @override
  String get searchHint => 'ПОИСК ПО НАЗВАНИЮ...';

  @override
  String get production => 'ПРОИЗВОДСТВО';

  @override
  String get sewingQueue => 'ОЧЕРЕДЬ ПОШИВА';

  @override
  String get noItems => 'НЕТ ЗАДАЧ';

  @override
  String get queueEmpty => 'ОЧЕРЕДЬ ПУСТА';

  @override
  String get complete => 'ЗАВЕРШИТЬ';
}
