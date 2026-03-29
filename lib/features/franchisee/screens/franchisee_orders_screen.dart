import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:fashionmode_hackathon/l10n/app_localizations.dart';

import '../../../core/providers/providers.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/order_model.dart';
import '../../../shared/widgets/avishu_buttons.dart';
import '../../../shared/widgets/avishu_dialogs.dart';
import '../../../shared/widgets/avishu_motion.dart';

String _statusLabel(OrderStatus status, AppLocalizations l) => switch (status) {
  OrderStatus.placed => l.statusPlaced,
  OrderStatus.sewing => l.statusSewing,
  OrderStatus.ready => l.statusReady,
};

class FranchiseeOrdersScreen extends ConsumerStatefulWidget {
  const FranchiseeOrdersScreen({super.key});

  @override
  ConsumerState<FranchiseeOrdersScreen> createState() =>
      _FranchiseeOrdersScreenState();
}

class _FranchiseeOrdersScreenState
    extends ConsumerState<FranchiseeOrdersScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ordersAsync = ref.watch(allOrdersProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: AvishuReveal(
              child: Text(
                l.allOrders,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AvishuReveal(
              delay: const Duration(milliseconds: 60),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.black),
                decoration: InputDecoration(
                  hintText: l.searchHint,
                  prefixIcon: const Icon(
                    Icons.search_sharp,
                    size: 20,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                final filtered = _query.isEmpty
                    ? orders
                    : orders
                          .where(
                            (order) =>
                                order.productName.toLowerCase().contains(
                                  _query.toLowerCase(),
                                ) ||
                                order.clientName.toLowerCase().contains(
                                  _query.toLowerCase(),
                                ),
                          )
                          .toList();

                if (filtered.isEmpty) {
                  return AvishuReveal(
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

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _FranchiseeOrderCard(
                    order: filtered[index],
                    service: ref.read(firestoreServiceProvider),
                    index: index,
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
  final FirestoreService service;
  final int index;

  const _FranchiseeOrderCard({
    required this.order,
    required this.service,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final formatter = NumberFormat('#,###', 'en_US');

    return AvishuReveal(
      delay: Duration(milliseconds: 35 * (index % 8)),
      child: Container(
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
                      AnimatedContainer(
                        duration: AvishuMotion.medium,
                        curve: AvishuMotion.emphasis,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: order.status == OrderStatus.ready
                            ? AppColors.black
                            : AppColors.white,
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
                  const SizedBox(height: 8),
                  Text(
                    '${order.clientName} · ₸${formatter.format(order.price)}',
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
              AvishuPressable(
                onTap: () async {
                  final action = await showAvishuActionDialog(
                    context: context,
                    title: l.acceptOrderTitle,
                    message: l.acceptOrderMessage(order.productName),
                    primaryLabel: l.confirmButton,
                    secondaryLabel: l.dismissButton,
                  );
                  if (action == AvishuDialogAction.primary) {
                    await service.updateOrderStatus(
                      order.id,
                      OrderStatus.sewing,
                    );
                  }
                },
                child: Container(
                  constraints: const BoxConstraints(minHeight: 56),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  color: AppColors.black,
                  child: AvishuButtonLabel(
                    text: l.acceptSewing,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
