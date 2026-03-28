import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../shared/models/order_model.dart';

class ClientOrdersScreen extends ConsumerWidget {
  const ClientOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(clientOrdersProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Text(
              'MY ORDERS',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // ── Loyalty Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.lightGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOYALTY PROGRESS',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLoyaltyBar(ordersAsync.valueOrNull?.length ?? 0),
                  const SizedBox(height: 8),
                  Text(
                    '${ordersAsync.valueOrNull?.length ?? 0} / 10 ORDERS TO NEXT TIER',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.divider),
          // ── Orders List ──
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return Center(
                    child: Text(
                      'NO ORDERS YET',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: AppColors.grey,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) => _OrderCard(order: orders[i]),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.black,
                ),
              ),
              error: (e, _) => Center(child: Text('ERROR: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyBar(int orderCount) {
    final progress = (orderCount / 10).clamp(0.0, 1.0);
    return Container(
      height: 6,
      color: AppColors.divider,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress,
          child: Container(color: AppColors.black),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'en_US');

    return Container(
      color: AppColors.lightGrey,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.productName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.black,
                  ),
                ),
              ),
              Text(
                '₸${formatter.format(order.price)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ── Status Progress Bar ──
          _StatusProgressBar(status: order.status),
          const SizedBox(height: 12),
          Text(
            DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusProgressBar extends StatelessWidget {
  final OrderStatus status;

  const _StatusProgressBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = OrderStatus.values;
    final currentIndex = steps.indexOf(status);

    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (i) {
            final isActive = i <= currentIndex;
            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.black : AppColors.white,
                      border: Border.all(
                        color: isActive ? AppColors.black : AppColors.grey,
                        width: 1,
                      ),
                    ),
                    child: isActive
                        ? const Icon(Icons.check,
                            size: 12, color: AppColors.white)
                        : null,
                  ),
                  if (i < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 1,
                        color: i < currentIndex
                            ? AppColors.black
                            : AppColors.grey,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          children: steps.map((s) {
            return Expanded(
              child: Text(
                s.name.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: s == status ? FontWeight.w700 : FontWeight.w400,
                  letterSpacing: 1,
                  color: s.index <= currentIndex
                      ? AppColors.black
                      : AppColors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
