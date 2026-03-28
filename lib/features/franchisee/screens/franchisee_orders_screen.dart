import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../shared/models/order_model.dart';

class FranchiseeOrdersScreen extends ConsumerWidget {
  const FranchiseeOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allOrdersProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Text(
              'ALL ORDERS',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return Center(
                    child: Text(
                      'NO ORDERS',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: AppColors.grey,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: orders.length,
                  itemBuilder: (context, i) => _FranchiseeOrderCard(
                    order: orders[i],
                    service: ref.read(firestoreServiceProvider),
                  ),
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
}

class _FranchiseeOrderCard extends StatelessWidget {
  final OrderModel order;
  final dynamic service;

  const _FranchiseeOrderCard({required this.order, required this.service});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'en_US');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.lightGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      color: order.status == OrderStatus.ready
                          ? AppColors.black
                          : AppColors.white,
                      child: Text(
                        order.status.name.toUpperCase(),
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
                const SizedBox(height: 8),
                Text(
                  '${order.clientName}  ·  ₸${formatter.format(order.price)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (order.status == OrderStatus.placed) ...[
            const Divider(height: 1, color: AppColors.divider),
            GestureDetector(
              onTap: () => service.updateOrderStatus(
                  order.id, OrderStatus.sewing),
              child: Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.black,
                child: Center(
                  child: Text(
                    'ACCEPT → SEWING',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
