import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:fashionmode_hackathon/l10n/app_localizations.dart';

import '../../../core/providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/cart_item_model.dart';
import '../../../shared/widgets/avishu_buttons.dart';
import '../../../shared/widgets/avishu_dialogs.dart';
import '../../../shared/widgets/avishu_motion.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final items = ref.watch(cartProvider);
    final selectedItems = ref.watch(selectedCartItemsProvider);
    final user = ref.watch(currentUserProvider).valueOrNull;
    final formatter = NumberFormat('#,###', 'en_US');
    final selectedTotal = selectedItems.fold<int>(
      0,
      (sum, item) => sum + item.price,
    );

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: AvishuReveal(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.cartTitle,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: AppColors.black,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: AvishuMotion.medium,
                    transitionBuilder: buildAvishuSwitcherTransition,
                    child: Text(
                      l.cartItemsCount(items.length),
                      key: ValueKey(items.length),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AvishuReveal(
              delay: const Duration(milliseconds: 50),
              child: Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.lightGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.cartSelectionTitle,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.cartSelectionHint,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: items.isEmpty
                ? _EmptyCartState(message: l.cartEmptyMessage)
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: items.length,
                    itemBuilder: (context, index) => _CartItemCard(
                      item: items[index],
                      formatter: formatter,
                      index: index,
                    ),
                  ),
          ),
          if (items.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.divider, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedSwitcher(
                        duration: AvishuMotion.medium,
                        transitionBuilder: buildAvishuSwitcherTransition,
                        child: Text(
                          l.selectedItemsLabel(selectedItems.length),
                          key: ValueKey(selectedItems.length),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: AvishuMotion.medium,
                        transitionBuilder: buildAvishuSwitcherTransition,
                        child: Text(
                          '₸${formatter.format(selectedTotal)}',
                          key: ValueKey(selectedTotal),
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: selectedItems.isEmpty
                          ? null
                          : () async {
                              await ref
                                  .read(firestoreServiceProvider)
                                  .placeCartOrders(
                                    items: selectedItems,
                                    clientName: user?.name ?? 'CLIENT',
                                  );
                              ref
                                  .read(cartProvider.notifier)
                                  .removeItems(selectedItems.map((e) => e.id));

                              if (!context.mounted) return;
                              final action = await showAvishuActionDialog(
                                context: context,
                                title: l.orderPlacedTitle,
                                message: l.orderPlacedMultipleMessage(
                                  selectedItems.length,
                                ),
                                primaryLabel: l.trackOrderButton,
                                secondaryLabel: l.continueShoppingButton,
                              );
                              if (action == AvishuDialogAction.primary &&
                                  context.mounted) {
                                context.go('/client/orders');
                              }
                            },
                      child: AvishuButtonLabel(
                        text: l.buySelectedButton,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  final CartItemModel item;
  final NumberFormat formatter;
  final int index;

  const _CartItemCard({
    required this.item,
    required this.formatter,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final notifier = ref.read(cartProvider.notifier);

    return AvishuReveal(
      delay: Duration(milliseconds: 35 * (index % 8)),
      child: AnimatedContainer(
        duration: AvishuMotion.medium,
        curve: AvishuMotion.emphasis,
        margin: const EdgeInsets.only(bottom: 16),
        color: item.isSelected ? const Color(0xFFEDEDED) : AppColors.lightGrey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvishuPressable(
                onTap: () => notifier.toggleSelection(item.id),
                child: AnimatedContainer(
                  duration: AvishuMotion.medium,
                  curve: AvishuMotion.emphasis,
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: item.isSelected ? AppColors.black : AppColors.white,
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: AnimatedSwitcher(
                    duration: AvishuMotion.fast,
                    child: item.isSelected
                        ? const Icon(
                            Icons.check,
                            key: ValueKey(true),
                            size: 14,
                            color: AppColors.white,
                          )
                        : const SizedBox.shrink(key: ValueKey(false)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₸${formatter.format(item.price)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              AvishuPressable(
                onTap: () => notifier.removeItem(item.id),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 88,
                    minHeight: 44,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: AvishuButtonLabel(
                    text: l.removeButton,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  final String message;

  const _EmptyCartState({required this.message});

  @override
  Widget build(BuildContext context) {
    return AvishuReveal(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '00',
                style: GoogleFonts.inter(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: AppColors.divider,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
