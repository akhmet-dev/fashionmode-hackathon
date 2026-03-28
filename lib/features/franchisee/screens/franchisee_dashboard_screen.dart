import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../shared/models/order_model.dart';

String _statusLabel(OrderStatus s, AppLocalizations l) => switch (s) {
      OrderStatus.placed => l.statusPlaced,
      OrderStatus.sewing => l.statusSewing,
      OrderStatus.ready => l.statusReady,
    };

class FranchiseeDashboardScreen extends ConsumerWidget {
  const FranchiseeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final ordersAsync = ref.watch(allOrdersProvider);
    final formatter = NumberFormat('#,###', 'en_US');

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.dashboard,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) context.go('/login');
                    },
                    child: Text(
                      l.logout,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ordersAsync.when(
              data: (orders) {
                final activeOrders =
                    orders.where((o) => o.status != OrderStatus.ready).length;
                final todayRevenue = orders
                    .where((o) =>
                        o.createdAt.day == DateTime.now().day &&
                        o.createdAt.month == DateTime.now().month &&
                        o.createdAt.year == DateTime.now().year)
                    .fold<int>(0, (sum, o) => sum + o.price);
                final planPercent = orders.isEmpty
                    ? 0
                    : ((activeOrders / orders.length) * 100).round();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _MetricCard(
                        label: l.todayRevenue,
                        value: '₸${formatter.format(todayRevenue)}',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              label: l.plan,
                              value: '$planPercent%',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              label: l.activeOrders,
                              value: '$activeOrders',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 160,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.black,
                  ),
                ),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text('ERROR: $e'),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                l.recentOrders,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ordersAsync.when(
              data: (orders) {
                final recent = orders.take(5).toList();
                if (recent.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        l.noOrders,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: recent.map((order) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.productName,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      order.clientName,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                color: order.status == OrderStatus.ready
                                    ? AppColors.black
                                    : AppColors.lightGrey,
                                child: Text(
                                  _statusLabel(order.status, l),
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    color: order.status == OrderStatus.ready
                                        ? AppColors.white
                                        : AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: AppColors.divider),
                      ],
                    );
                  }).toList(),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: AppColors.lightGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
