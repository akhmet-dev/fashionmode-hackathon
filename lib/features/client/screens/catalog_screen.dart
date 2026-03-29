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
                    Positioned.fill(child: _ProductArtwork(product: product)),
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
    final currentUser = ref.read(currentUserProvider).valueOrNull;
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
                SizedBox(
                  height: 220,
                  child: _ProductArtwork(product: product, isLarge: true),
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
                              final sizing = await showOrderSizingSheet(
                                context: context,
                                title: 'Размер клиента',
                                ctaLabel: 'Продолжить',
                                measurementFields: product.measurementFields,
                                savedProfile: currentUser?.savedMeasurements,
                              );
                              if (sizing == null) return;
                              if (!context.mounted) return;

                              final paymentMethod =
                                  await showPaymentMethodSheet(
                                    context: context,
                                    amount: product.price,
                                    ctaLabel: 'Подтвердить предзаказ',
                                    savedCards:
                                        currentUser?.savedCards ?? const [],
                                  );
                              if (paymentMethod == null) return;

                              await ref
                                  .read(firestoreServiceProvider)
                                  .placeOrder(
                                    productName: product.name,
                                    price: product.price,
                                    clientName: clientName,
                                    sizing: sizing,
                                    paymentMethod: paymentMethod,
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
                                final sizing = await showOrderSizingSheet(
                                  context: context,
                                  title: 'Размер клиента',
                                  ctaLabel: 'Добавить в корзину',
                                  measurementFields: product.measurementFields,
                                  savedProfile: currentUser?.savedMeasurements,
                                );
                                if (sizing == null) return;

                                ref
                                    .read(cartProvider.notifier)
                                    .addProduct(product, sizing: sizing);
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
                                final sizing = await showOrderSizingSheet(
                                  context: context,
                                  title: 'Размер клиента',
                                  ctaLabel: 'Продолжить',
                                  measurementFields: product.measurementFields,
                                  savedProfile: currentUser?.savedMeasurements,
                                );
                                if (sizing == null) return;
                                if (!context.mounted) return;

                                final paymentMethod =
                                    await showPaymentMethodSheet(
                                      context: context,
                                      amount: product.price,
                                      ctaLabel: 'Подтвердить оплату',
                                      savedCards:
                                          currentUser?.savedCards ?? const [],
                                    );
                                if (paymentMethod == null) return;

                                await ref
                                    .read(firestoreServiceProvider)
                                    .placeOrder(
                                      productName: product.name,
                                      price: product.price,
                                      clientName: clientName,
                                      sizing: sizing,
                                      paymentMethod: paymentMethod,
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

class _ProductArtwork extends StatelessWidget {
  final ProductModel product;
  final bool isLarge;

  const _ProductArtwork({required this.product, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    // If real photo uploaded — show it
    final url = product.imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildArtwork(),
      );
    }
    return _buildArtwork();
  }

  Widget _buildArtwork() {
    final palette = _artworkPalette(product.imageKey);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.backgroundTop, palette.backgroundBottom],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: isLarge ? -24 : -18,
            top: isLarge ? -18 : -10,
            child: _BackdropBlur(
              size: isLarge ? 130 : 90,
              color: palette.accent.withValues(alpha: 0.28),
            ),
          ),
          Positioned(
            right: isLarge ? -20 : -12,
            bottom: isLarge ? -28 : -20,
            child: _BackdropBlur(
              size: isLarge ? 150 : 100,
              color: AppColors.white.withValues(alpha: 0.16),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(isLarge ? 12 : 8),
              child: AspectRatio(
                aspectRatio: 0.78,
                child: CustomPaint(painter: _GarmentPainter(palette: palette)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropBlur extends StatelessWidget {
  final double size;
  final Color color;

  const _BackdropBlur({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _ArtworkPalette {
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color garment;
  final Color garmentHighlight;
  final Color seam;
  final Color accent;
  final bool longSleeves;

  const _ArtworkPalette({
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.garment,
    required this.garmentHighlight,
    required this.seam,
    required this.accent,
    required this.longSleeves,
  });
}

_ArtworkPalette _artworkPalette(String imageKey) {
  return switch (imageKey) {
    'white_tshirt' => const _ArtworkPalette(
      backgroundTop: Color(0xFFF8F7F3),
      backgroundBottom: Color(0xFFE9E5DE),
      garment: Color(0xFFFDFDFB),
      garmentHighlight: Color(0xFFFFFFFF),
      seam: Color(0xFFCBC6BE),
      accent: Color(0xFFD9D2C7),
      longSleeves: false,
    ),
    'black_tshirt' => const _ArtworkPalette(
      backgroundTop: Color(0xFF1F2024),
      backgroundBottom: Color(0xFF0E1014),
      garment: Color(0xFF101215),
      garmentHighlight: Color(0xFF2A2E34),
      seam: Color(0xFF5A5F68),
      accent: Color(0xFF3D434B),
      longSleeves: false,
    ),
    'grey_tshirt' => const _ArtworkPalette(
      backgroundTop: Color(0xFFE9EAEC),
      backgroundBottom: Color(0xFFD4D7DB),
      garment: Color(0xFFB8BEC6),
      garmentHighlight: Color(0xFFD8DCE1),
      seam: Color(0xFF8A919A),
      accent: Color(0xFFC8CDD3),
      longSleeves: false,
    ),
    'black_sweater' => const _ArtworkPalette(
      backgroundTop: Color(0xFF24262A),
      backgroundBottom: Color(0xFF121417),
      garment: Color(0xFF15181C),
      garmentHighlight: Color(0xFF2D3238),
      seam: Color(0xFF636A73),
      accent: Color(0xFF3F454D),
      longSleeves: true,
    ),
    _ => const _ArtworkPalette(
      backgroundTop: Color(0xFFF4F4F4),
      backgroundBottom: Color(0xFFE7E7E7),
      garment: Color(0xFFEFEFEF),
      garmentHighlight: Color(0xFFFFFFFF),
      seam: Color(0xFFBDBDBD),
      accent: Color(0xFFD9D9D9),
      longSleeves: false,
    ),
  };
}

class _GarmentPainter extends CustomPainter {
  final _ArtworkPalette palette;

  const _GarmentPainter({required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    final garmentPath = _buildGarmentPath(size, palette.longSleeves);
    canvas.drawShadow(
      garmentPath,
      Colors.black.withValues(alpha: 0.28),
      18,
      false,
    );

    final garmentPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [palette.garmentHighlight, palette.garment],
      ).createShader(Offset.zero & size);

    canvas.drawPath(garmentPath, garmentPaint);

    final foldPaint = Paint()
      ..color = palette.seam.withValues(alpha: 0.34)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.015;

    final leftFold = Path()
      ..moveTo(size.width * 0.39, size.height * 0.34)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.56,
        size.width * 0.42,
        size.height * 0.84,
      );
    final rightFold = Path()
      ..moveTo(size.width * 0.61, size.height * 0.34)
      ..quadraticBezierTo(
        size.width * 0.66,
        size.height * 0.56,
        size.width * 0.58,
        size.height * 0.84,
      );

    canvas.drawPath(leftFold, foldPaint);
    canvas.drawPath(rightFold, foldPaint);

    final collarPaint = Paint()..color = palette.seam.withValues(alpha: 0.42);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.19),
        width: size.width * 0.18,
        height: size.height * 0.08,
      ),
      0,
      3.14,
      false,
      collarPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.018,
    );
  }

  Path _buildGarmentPath(Size size, bool longSleeves) {
    final centerX = size.width / 2;
    final topY = size.height * 0.12;
    final shoulderY = size.height * 0.21;
    final sleeveStartY = size.height * 0.29;
    final sleeveEndY = longSleeves ? size.height * 0.7 : size.height * 0.44;
    final hemY = size.height * 0.9;
    final bodyHalfWidth = size.width * 0.22;
    final sleeveOuter = size.width * (longSleeves ? 0.42 : 0.36);

    return Path()
      ..moveTo(centerX - size.width * 0.08, topY)
      ..quadraticBezierTo(
        centerX,
        size.height * 0.17,
        centerX + size.width * 0.08,
        topY,
      )
      ..lineTo(centerX + bodyHalfWidth * 0.86, shoulderY)
      ..lineTo(centerX + sleeveOuter, sleeveStartY)
      ..lineTo(centerX + sleeveOuter * 0.88, sleeveEndY)
      ..lineTo(centerX + bodyHalfWidth * 0.95, sleeveEndY + size.height * 0.02)
      ..lineTo(centerX + bodyHalfWidth * 0.82, hemY)
      ..lineTo(centerX - bodyHalfWidth * 0.82, hemY)
      ..lineTo(centerX - bodyHalfWidth * 0.95, sleeveEndY + size.height * 0.02)
      ..lineTo(centerX - sleeveOuter * 0.88, sleeveEndY)
      ..lineTo(centerX - sleeveOuter, sleeveStartY)
      ..lineTo(centerX - bodyHalfWidth * 0.86, shoulderY)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _GarmentPainter oldDelegate) {
    return oldDelegate.palette != palette;
  }
}
