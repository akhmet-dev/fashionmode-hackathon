import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:fashionmode_hackathon/l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'shared/models/order_model.dart';
import 'shared/models/user_model.dart';
import 'core/services/firestore_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/notification_service.dart';
import 'core/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirestoreService().seedDataIfNeeded();
  await NotificationService().init();
  await FcmService().init();

  runApp(const ProviderScope(child: AvishuApp()));
}

class AvishuApp extends ConsumerWidget {
  const AvishuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final currentUser = ref.watch(currentUserProvider).valueOrNull;

    ref.listen<AsyncValue<AppUser?>>(currentUserProvider, (_, next) {
      FcmService().syncUser(next.valueOrNull);
      unawaited(
        ref.read(notificationInboxProvider.notifier).syncUser(
              next.valueOrNull,
            ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FcmService().syncUser(currentUser);
      unawaited(ref.read(notificationInboxProvider.notifier).syncUser(currentUser));
    });

    return MaterialApp.router(
      title: 'AVISHU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: const Locale('ru'),
      routerConfig: router,
      builder: (context, child) => _RealtimeNotificationBridge(
        child: child ?? const SizedBox.shrink(),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class _RealtimeNotificationBridge extends ConsumerStatefulWidget {
  final Widget child;

  const _RealtimeNotificationBridge({required this.child});

  @override
  ConsumerState<_RealtimeNotificationBridge> createState() =>
      _RealtimeNotificationBridgeState();
}

class _RealtimeNotificationBridgeState
    extends ConsumerState<_RealtimeNotificationBridge> {
  final Map<String, OrderStatus> _clientStatuses = {};
  final Map<String, OrderStatus> _franchiseeStatuses = {};
  final Set<String> _productionIds = <String>{};

  UserRole? _lastRole;
  bool _clientPrimed = false;
  bool _franchiseePrimed = false;
  bool _productionPrimed = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final role = currentUser?.role;

    ref.listen<AsyncValue<AppUser?>>(currentUserProvider, (_, next) {
      final nextRole = next.valueOrNull?.role;
      if (_lastRole == nextRole) return;
      _resetCaches();
      _lastRole = nextRole;
    });

    ref.listen<AsyncValue<List<OrderModel>>>(clientOrdersProvider, (_, next) {
      if (role != UserRole.client) return;
      final orders = next.valueOrNull;
      if (orders == null) return;

      if (!_clientPrimed) {
        _clientPrimed = true;
        for (final order in orders) {
          _clientStatuses[order.id] = order.status;
        }
        return;
      }

      final currentIds = orders.map((order) => order.id).toSet();
      _clientStatuses.removeWhere((id, _) => !currentIds.contains(id));

      for (final order in orders) {
        final previous = _clientStatuses[order.id];
        if (previous != null && previous != order.status) {
          final body = switch (order.status) {
            OrderStatus.sewing => l.clientOrderAcceptedNotification(
              order.productName,
            ),
            OrderStatus.ready => l.clientOrderReadyNotification(
              order.productName,
            ),
            OrderStatus.placed => '',
          };
          if (body.isNotEmpty) {
            unawaited(
              ref.read(notificationInboxProvider.notifier).addNotification(
                    title: l.appName,
                    body: body,
                    id: '${order.id}_${order.status.name}',
                  ),
            );
            NotificationService().showUpdate(
              title: l.appName,
              body: body,
              id: order.id.hashCode ^ order.status.name.hashCode,
            );
          }
        }
        _clientStatuses[order.id] = order.status;
      }
    });

    ref.listen<AsyncValue<List<OrderModel>>>(allOrdersProvider, (_, next) {
      if (role != UserRole.franchisee) return;
      final orders = next.valueOrNull;
      if (orders == null) return;

      if (!_franchiseePrimed) {
        _franchiseePrimed = true;
        for (final order in orders) {
          _franchiseeStatuses[order.id] = order.status;
        }
        return;
      }

      final currentIds = orders.map((order) => order.id).toSet();
      _franchiseeStatuses.removeWhere((id, _) => !currentIds.contains(id));

      for (final order in orders) {
        final previous = _franchiseeStatuses[order.id];
        if (previous == null) {
          unawaited(
            ref.read(notificationInboxProvider.notifier).addNotification(
                  title: l.appName,
                  body: l.franchiseeNewOrderNotification(order.productName),
                  id: '${order.id}_new',
                ),
          );
          NotificationService().showUpdate(
            title: l.appName,
            body: l.franchiseeNewOrderNotification(order.productName),
            id: order.id.hashCode ^ 11,
          );
        } else if (previous != order.status && order.status == OrderStatus.ready) {
          unawaited(
            ref.read(notificationInboxProvider.notifier).addNotification(
                  title: l.appName,
                  body: l.franchiseeOrderReadyNotification(order.productName),
                  id: '${order.id}_${order.status.name}',
                ),
          );
          NotificationService().showUpdate(
            title: l.appName,
            body: l.franchiseeOrderReadyNotification(order.productName),
            id: order.id.hashCode ^ order.status.name.hashCode,
          );
        }
        _franchiseeStatuses[order.id] = order.status;
      }
    });

    ref.listen<AsyncValue<List<OrderModel>>>(sewingOrdersProvider, (_, next) {
      if (role != UserRole.production) return;
      final orders = next.valueOrNull;
      if (orders == null) return;

      if (!_productionPrimed) {
        _productionPrimed = true;
        _productionIds.addAll(orders.map((order) => order.id));
        return;
      }

      final currentIds = orders.map((order) => order.id).toSet();
      _productionIds.removeWhere((id) => !currentIds.contains(id));

      for (final order in orders) {
        if (_productionIds.add(order.id)) {
          unawaited(
            ref.read(notificationInboxProvider.notifier).addNotification(
                  title: l.appName,
                  body: l.productionTaskNotification(order.productName),
                  id: '${order.id}_production',
                ),
          );
          NotificationService().showUpdate(
            title: l.appName,
            body: l.productionTaskNotification(order.productName),
            id: order.id.hashCode ^ 29,
          );
        }
      }
    });

    return widget.child;
  }

  void _resetCaches() {
    _clientStatuses.clear();
    _franchiseeStatuses.clear();
    _productionIds.clear();
    _clientPrimed = false;
    _franchiseePrimed = false;
    _productionPrimed = false;
  }
}
