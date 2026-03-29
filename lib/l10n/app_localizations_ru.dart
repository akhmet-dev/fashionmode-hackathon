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
  String get catalogNavLabel => 'КАТАЛОГ';

  @override
  String get ordersNavLabel => 'ЗАКАЗЫ';

  @override
  String get cartNavLabel => 'КОРЗИНА';

  @override
  String get dashboardNavLabel => 'БАШНЯ';

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
  String get clientShowroomLabel => 'КЛИЕНТСКАЯ ВИТРИНА';

  @override
  String get preorderBadge => 'ПРЕДЗАКАЗ';

  @override
  String get inStockLabel => 'В НАЛИЧИИ';

  @override
  String get inStockDescription =>
      'Товар доступен к немедленному оформлению. Заказ сразу попадает в башню управления франчайзи и далее в производство.';

  @override
  String get preorderDescription =>
      'Этот товар доступен по предзаказу. Выберите удобную дату готовности, чтобы зафиксировать выпуск изделия.';

  @override
  String get buyButton => 'КУПИТЬ';

  @override
  String get addToCartButton => 'В КОРЗИНУ';

  @override
  String get preorderButton => 'ПРЕДЗАКАЗ';

  @override
  String get selectDeliveryDate => 'ВЫБРАТЬ ДАТУ ДОСТАВКИ';

  @override
  String get addedToCartTitle => 'ДОБАВЛЕНО В КОРЗИНУ';

  @override
  String addedToCartMessage(String product) {
    return '$product уже в корзине и готов к оформлению.';
  }

  @override
  String get openCartButton => 'ОТКРЫТЬ КОРЗИНУ';

  @override
  String get continueShoppingButton => 'ПРОДОЛЖИТЬ';

  @override
  String get orderPlacedTitle => 'ЗАКАЗ ОФОРМЛЕН';

  @override
  String orderPlacedMessage(String product) {
    return '$product передан в обработку. Следующий шаг — подтверждение франчайзи.';
  }

  @override
  String orderPlacedMultipleMessage(int count) {
    return '$count товаров оформлены и уже отправлены в общий поток заказов.';
  }

  @override
  String get trackOrderButton => 'ОТСЛЕДИТЬ ЗАКАЗ';

  @override
  String get myOrders => 'МОИ ЗАКАЗЫ';

  @override
  String get notificationsTitle => 'СООБЩЕНИЯ';

  @override
  String get notificationsEmpty => 'УВЕДОМЛЕНИЙ ПОКА НЕТ';

  @override
  String notificationsSummary(int count) {
    return 'НОВЫХ СООБЩЕНИЙ: $count';
  }

  @override
  String get loyaltyProgress => 'ПРОГРЕСС ЛОЯЛЬНОСТИ';

  @override
  String get loyaltyTapHint => 'НАЖМИТЕ, ЧТОБЫ ПОСМОТРЕТЬ УРОВНИ';

  @override
  String loyaltyLevelLabel(String level) {
    return 'УРОВЕНЬ: $level';
  }

  @override
  String loyaltyToNextLevel(int count, String level) {
    return 'ЕЩЁ $count ЗАКАЗОВ ДО УРОВНЯ $level';
  }

  @override
  String get loyaltyMaxLevelMessage => 'МАКСИМАЛЬНЫЙ УРОВЕНЬ ДОСТИГНУТ';

  @override
  String get loyaltyDetailsTitle => 'УРОВНИ ЛОЯЛЬНОСТИ';

  @override
  String get loyaltyCurrentStatus => 'ТЕКУЩИЙ УРОВЕНЬ';

  @override
  String loyaltyUnlockedAt(int count) {
    return 'ОТ $count ЗАКАЗОВ';
  }

  @override
  String loyaltyRangeBetween(int start, int end) {
    return 'ОТ $start ДО $end ЗАКАЗОВ';
  }

  @override
  String loyaltyRangeFrom(int start) {
    return 'ОТ $start ЗАКАЗОВ';
  }

  @override
  String get loyaltyLevelNovice => 'НОВИЧОК';

  @override
  String get loyaltyLevelStyleLover => 'ЛЮБИТЕЛЬ СТИЛЯ';

  @override
  String get loyaltyLevelFashionista => 'МОДНИК';

  @override
  String get loyaltyLevelStylist => 'СТИЛИСТ';

  @override
  String get loyaltyLevelStyleExpert => 'ЭКСПЕРТ СТИЛЯ';

  @override
  String get loyaltyLevelStyleIcon => 'ИКОНА СТИЛЯ';

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
  String clientOrderAcceptedNotification(String product) {
    return '$product принят в работу и передан в пошив.';
  }

  @override
  String clientOrderReadyNotification(String product) {
    return '$product готов. Можно открывать трекинг заказа.';
  }

  @override
  String get cartTitle => 'КОРЗИНА';

  @override
  String cartItemsCount(int count) {
    return '$count ПОЗИЦИЙ';
  }

  @override
  String get cartSelectionTitle => 'ВЫБОР ПОЗИЦИЙ';

  @override
  String get cartSelectionHint =>
      'Отмечайте товары для оформления, снимайте лишние и удаляйте ненужное прямо из корзины.';

  @override
  String get cartEmptyMessage => 'КОРЗИНА ПОКА ПУСТА';

  @override
  String selectedItemsLabel(int count) {
    return 'ВЫБРАНО: $count';
  }

  @override
  String get buySelectedButton => 'КУПИТЬ ВЫБРАННОЕ';

  @override
  String get removeButton => 'УДАЛИТЬ';

  @override
  String get dashboard => 'ДАШБОРД';

  @override
  String get controlTowerTitle => 'БАШНЯ УПРАВЛЕНИЯ';

  @override
  String get controlTowerSubtitle => 'ПАНЕЛЬ ФРАНЧАЙЗИ';

  @override
  String get todayRevenue => 'ВЫРУЧКА СЕГОДНЯ';

  @override
  String dailyGoalLabel(String target) {
    return 'ЦЕЛЬ ДНЯ: ₸$target';
  }

  @override
  String get editPlanButton => 'ИЗМЕНИТЬ ЦЕЛЬ';

  @override
  String get setPlanTitle => 'ЦЕЛЬ НА СЕГОДНЯ';

  @override
  String get setPlanHint =>
      'Укажите план по выручке, чтобы башня управления считала выполнение от вашей реальной цели.';

  @override
  String get setPlanInputHint => 'НАПРИМЕР, 250000';

  @override
  String get savePlanButton => 'СОХРАНИТЬ ЦЕЛЬ';

  @override
  String get plan => 'ПЛАН';

  @override
  String get activeOrders => 'АКТИВНЫЕ ЗАКАЗЫ';

  @override
  String get recentOrders => 'НЕДАВНИЕ ЗАКАЗЫ';

  @override
  String get noOrders => 'НЕТ ЗАКАЗОВ';

  @override
  String planProgressLabel(int percent, String target) {
    return '$percent% ОТ ЦЕЛИ ₸$target';
  }

  @override
  String get completionRateLabel => 'ГОТОВО';

  @override
  String get averageCheckLabel => 'СРЕДНИЙ ЧЕК';

  @override
  String get orderFlowTitle => 'ПОТОК ЗАКАЗОВ';

  @override
  String get newOrdersLabel => 'НОВЫЕ';

  @override
  String get sewingLoadLabel => 'В ПОШИВЕ';

  @override
  String get readyOrdersLabel => 'ГОТОВО';

  @override
  String get liveOrdersTitle => 'ЖИВАЯ ЛЕНТА';

  @override
  String franchiseeNewOrderNotification(String product) {
    return 'Новый заказ: $product. Проверьте и примите в работу.';
  }

  @override
  String franchiseeOrderReadyNotification(String product) {
    return '$product завершён производством и готов к выдаче.';
  }

  @override
  String get allOrders => 'ВСЕ ЗАКАЗЫ';

  @override
  String get acceptSewing => 'ПРИНЯТЬ → ПОШИВ';

  @override
  String get searchHint => 'ПОИСК ПО НАЗВАНИЮ...';

  @override
  String get acceptOrderTitle => 'ПРИНЯТЬ ЗАКАЗ?';

  @override
  String acceptOrderMessage(String product) {
    return '$product будет переведён в пошив и сразу появится в очереди цеха.';
  }

  @override
  String get production => 'ПРОИЗВОДСТВО';

  @override
  String get productionSubtitle => 'ПЛАНШЕТ ЦЕХА';

  @override
  String get sewingQueue => 'ОЧЕРЕДЬ ПОШИВА';

  @override
  String get noItems => 'НЕТ ЗАДАЧ';

  @override
  String get queueEmpty => 'ОЧЕРЕДЬ ПУСТА';

  @override
  String get complete => 'ЗАВЕРШИТЬ';

  @override
  String get completeOrderTitle => 'ЗАВЕРШИТЬ ЗАКАЗ?';

  @override
  String completeOrderMessage(String product) {
    return '$product будет отмечен как готовый, а клиент и франчайзи получат обновление статуса.';
  }

  @override
  String productionTaskNotification(String product) {
    return 'Новая задача в очереди: $product.';
  }
}
