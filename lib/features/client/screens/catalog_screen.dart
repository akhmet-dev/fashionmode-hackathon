import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:fashionmode_hackathon/l10n/app_localizations.dart';

import '../../../core/providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/widgets/avishu_buttons.dart';
import '../../../shared/widgets/avishu_dialogs.dart';
import '../../../shared/widgets/avishu_motion.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final productsAsync = ref.watch(productsProvider);
    final user = ref.watch(currentUserProvider).valueOrNull;
    final cartCount = ref.watch(cartItemCountProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compactHeader = constraints.maxWidth < 430;

                return compactHeader
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _CatalogHeaderTitle(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _HeaderAction(
                                  label:
                                      '${l.cartNavLabel} ${cartCount.toString()}',
                                  onTap: () => context.go('/client/cart'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _HeaderAction(
                                  label: l.logout,
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                    if (context.mounted) context.go('/login');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(child: _CatalogHeaderTitle()),
                          const SizedBox(width: 12),
                          _HeaderAction(
                            label: '${l.cartNavLabel} ${cartCount.toString()}',
                            onTap: () => context.go('/client/cart'),
                          ),
                          const SizedBox(width: 8),
                          _HeaderAction(
                            label: l.logout,
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              if (context.mounted) context.go('/login');
                            },
                          ),
                        ],
                      );
              },
            ),
          ),
          const SizedBox(height: 24),
          AvishuReveal(
            delay: const Duration(milliseconds: 60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              color: AppColors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.newCollection,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.season,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      Text(
                        user?.name ?? 'CLIENT',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: productsAsync.when(
              data: (products) => GridView.builder(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.62,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => _ProductCard(
                  product: products[index],
                  clientName: user?.name ?? 'CLIENT',
                  index: index,
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.black,
                ),
              ),
              error: (e, _) => Center(
                child: Text(
                  'ERROR: $e',
                  style: GoogleFonts.inter(color: AppColors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogHeaderTitle extends StatelessWidget {
  const _CatalogHeaderTitle();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return AvishuReveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.appName,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.clientShowroomLabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _HeaderAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AvishuPressable(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black, width: 1),
        ),
        child: AvishuButtonLabel(
          text: label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  final ProductModel product;
  final String clientName;
  final int index;

  const _ProductCard({
    required this.product,
    required this.clientName,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final formatter = NumberFormat('#,###', 'en_US');

    return AvishuReveal(
      delay: Duration(milliseconds: 40 * (index % 6)),
      child: AvishuPressable(
        onTap: () => _showProductModal(context, ref),
        child: Container(
          color: AppColors.lightGrey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(color: AppColors.lightGrey),
                    ),
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        color: AppColors.white,
                        child: Text(
                          product.isPreorder ? l.preorderBadge : l.inStockLabel,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        product.name.substring(0, 1),
                        style: GoogleFonts.inter(
                          fontSize: 58,
                          fontWeight: FontWeight.w900,
                          color: AppColors.divider,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: AppColors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₸${formatter.format(product.price)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showProductModal(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final formatter = NumberFormat('#,###', 'en_US');
    DateTime? selectedDate;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AvishuReveal(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              24 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      product.isPreorder ? l.preorderBadge : l.inStockLabel,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₸${formatter.format(product.price)}',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 20),
                Text(
                  product.isPreorder
                      ? l.preorderDescription
                      : l.inStockDescription,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                    color: AppColors.grey,
                  ),
                ),
                if (product.isPreorder) ...[
                  const SizedBox(height: 20),
                  AvishuPressable(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now().add(
                          const Duration(days: 14),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 180)),
                        builder: (pickerContext, child) => Theme(
                          data: Theme.of(pickerContext).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.black,
                              onPrimary: AppColors.white,
                              surface: AppColors.white,
                              onSurface: AppColors.black,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (date != null) {
                        setModalState(() => selectedDate = date);
                      }
                    },
                    child: AnimatedContainer(
                      duration: AvishuMotion.medium,
                      curve: AvishuMotion.emphasis,
                      padding: const EdgeInsets.all(16),
                      color: AppColors.lightGrey,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_sharp,
                            size: 18,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              selectedDate != null
                                  ? DateFormat(
                                      'dd.MM.yyyy',
                                    ).format(selectedDate!)
                                  : l.selectDeliveryDate,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: selectedDate != null
                                    ? AppColors.black
                                    : AppColors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (product.isPreorder)
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: selectedDate == null
                          ? null
                          : () async {
                              await ref
                                  .read(firestoreServiceProvider)
                                  .placeOrder(
                                    productName: product.name,
                                    price: product.price,
                                    clientName: clientName,
                                    preorderDate: selectedDate,
                                  );
                              if (ctx.mounted) Navigator.pop(ctx);
                              if (!context.mounted) return;
                              final action = await showAvishuActionDialog(
                                context: context,
                                title: l.orderPlacedTitle,
                                message: l.orderPlacedMessage(
                                  product.productNameSafe,
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
                        text: l.preorderButton,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stackedActions = constraints.maxWidth < 360;
                      final buttonWidth = stackedActions
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 12) / 2;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: buttonWidth,
                            height: 60,
                            child: OutlinedButton(
                              onPressed: () async {
                                ref
                                    .read(cartProvider.notifier)
                                    .addProduct(product);
                                if (ctx.mounted) Navigator.pop(ctx);
                                if (!context.mounted) return;
                                final action = await showAvishuActionDialog(
                                  context: context,
                                  title: l.addedToCartTitle,
                                  message: l.addedToCartMessage(product.name),
                                  primaryLabel: l.openCartButton,
                                  secondaryLabel: l.continueShoppingButton,
                                  primaryFilled: false,
                                );
                                if (action == AvishuDialogAction.primary &&
                                    context.mounted) {
                                  context.go('/client/cart');
                                }
                              },
                              child: AvishuButtonLabel(
                                text: l.addToCartButton,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: buttonWidth,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                await ref
                                    .read(firestoreServiceProvider)
                                    .placeOrder(
                                      productName: product.name,
                                      price: product.price,
                                      clientName: clientName,
                                    );
                                if (ctx.mounted) Navigator.pop(ctx);
                                if (!context.mounted) return;
                                final action = await showAvishuActionDialog(
                                  context: context,
                                  title: l.orderPlacedTitle,
                                  message: l.orderPlacedMessage(product.name),
                                  primaryLabel: l.trackOrderButton,
                                  secondaryLabel: l.continueShoppingButton,
                                );
                                if (action == AvishuDialogAction.primary &&
                                    context.mounted) {
                                  context.go('/client/orders');
                                }
                              },
                              child: AvishuButtonLabel(
                                text: l.buyButton,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on ProductModel {
  String get productNameSafe => name;
}
