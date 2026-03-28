import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/providers.dart';
import '../../shared/models/user_model.dart';
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
      // ── Client ──
      ShellRoute(
        builder: (context, state, child) =>
            _ClientShell(child: child, state: state),
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
      // ── Franchisee ──
      ShellRoute(
        builder: (context, state, child) =>
            _FranchiseeShell(child: child, state: state),
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
      // ── Production ──
      GoRoute(
        path: '/production/queue',
        builder: (context, state) => const QueueScreen(),
      ),
    ],
  );
});

// ── Role Redirect ────────────────────────────────────────

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
      error: (_, __) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
        });
        return const Scaffold(backgroundColor: Color(0xFFFFFFFF));
      },
    );
  }
}

// ── Client Shell with Bottom Nav ─────────────────────────

class _ClientShell extends StatelessWidget {
  // `child` comes from ShellRoute but is intentionally unused for rendering.
  // IndexedStack owns both screens directly so there is never a widget-swap
  // in the body — the overlap bug is impossible with this approach.
  // ignore: unused_field
  final Widget child;
  final GoRouterState state;

  const _ClientShell({required this.child, required this.state});

  int _indexOf(String location) {
    if (location.startsWith('/client/orders')) return 1;
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

// ── Franchisee Shell with Bottom Nav ─────────────────────

class _FranchiseeShell extends StatelessWidget {
  // Same pattern: `child` unused, IndexedStack renders both tabs directly.
  // ignore: unused_field
  final Widget child;
  final GoRouterState state;

  const _FranchiseeShell({required this.child, required this.state});

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
