import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fashionmode_hackathon/l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../services/notification_service.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/order_model.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/client/screens/catalog_screen.dart';
import '../../features/client/screens/client_orders_screen.dart';
import '../../features/franchisee/screens/franchisee_dashboard_screen.dart';
import '../../features/franchisee/screens/franchisee_orders_screen.dart';
import '../../features/production/screens/queue_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final isOnLogin = state.matchedLocation == '/login';

      if (firebaseUser == null && !isOnLogin) return '/login';
      if (firebaseUser != null && isOnLogin) return '/loading';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const _RoleRedirectScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            _ClientShell(state: state, child: child),
        routes: [
          GoRoute(
            path: '/client/catalog',
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(
            path: '/client/orders',
            builder: (context, state) => const ClientOrdersScreen(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) =>
            _FranchiseeShell(state: state, child: child),
        routes: [
          GoRoute(
            path: '/franchisee/dashboard',
            builder: (context, state) => const FranchiseeDashboardScreen(),
          ),
          GoRoute(
            path: '/franchisee/orders',
            builder: (context, state) => const FranchiseeOrdersScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/production/queue',
        builder: (context, state) => const QueueScreen(),
      ),
    ],
  );
});

class _RoleRedirectScreen extends ConsumerWidget {
  const _RoleRedirectScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (user.role) {
              case UserRole.client:
                context.go('/client/catalog');
              case UserRole.franchisee:
                context.go('/franchisee/dashboard');
              case UserRole.production:
                context.go('/production/queue');
            }
          });
        }
        return const Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF000000),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF000000),
            ),
          ),
        ),
      ),
      error: (e, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
        });
        return const Scaffold(backgroundColor: Color(0xFFFFFFFF));
      },
    );
  }
}

class _ClientShell extends ConsumerStatefulWidget {
  final GoRouterState state;

  const _ClientShell({required Widget child, required this.state});

  @override
  ConsumerState<_ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends ConsumerState<_ClientShell> {
  final Set<String> _seenReadyIds = {};
  bool _initialized = false;
  String _orderReadyBody = '';

  int _indexOf(String location) {
    if (location.startsWith('/client/orders')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    _orderReadyBody = AppLocalizations.of(context).orderReadyBanner;

    ref.listen<AsyncValue<List<OrderModel>>>(clientOrdersProvider, (_, next) {
      final orders = next.valueOrNull;
      if (orders == null) return;

      if (!_initialized) {
        _initialized = true;
        for (final order in orders) {
          if (order.status == OrderStatus.ready) {
            _seenReadyIds.add(order.id);
          }
        }
        return;
      }

      for (final order in orders) {
        if (order.status == OrderStatus.ready &&
            !_seenReadyIds.contains(order.id)) {
          _seenReadyIds.add(order.id);
          NotificationService().showOrderReady(_orderReadyBody);
        }
      }
    });

    final index = _indexOf(widget.state.matchedLocation);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: IndexedStack(
        index: index,
        children: const [
          CatalogScreen(),
          ClientOrdersScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, color: Color(0xFF333333)),
          BottomNavigationBar(
            currentIndex: index,
            onTap: (i) {
              if (i == 0) context.go('/client/catalog');
              if (i == 1) context.go('/client/orders');
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_sharp),
                label: 'CATALOG',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_sharp),
                label: 'ORDERS',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FranchiseeShell extends StatelessWidget {
  final GoRouterState state;

  const _FranchiseeShell({required Widget child, required this.state});

  int _indexOf(String location) {
    if (location.startsWith('/franchisee/orders')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _indexOf(state.matchedLocation);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: IndexedStack(
        index: index,
        children: const [
          FranchiseeDashboardScreen(),
          FranchiseeOrdersScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, color: Color(0xFF333333)),
          BottomNavigationBar(
            currentIndex: index,
            onTap: (i) {
              if (i == 0) context.go('/franchisee/dashboard');
              if (i == 1) context.go('/franchisee/orders');
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_sharp),
                label: 'DASHBOARD',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_sharp),
                label: 'ORDERS',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
