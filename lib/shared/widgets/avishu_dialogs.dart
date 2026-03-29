import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../models/order_model.dart';
import '../models/order_size_model.dart';
import '../models/payment_card_model.dart';
import '../models/saved_measurement_profile_model.dart';
import 'avishu_buttons.dart';
import 'avishu_motion.dart';

enum AvishuDialogAction { primary, secondary }

Future<AvishuDialogAction?> showAvishuActionDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String primaryLabel,
  String? secondaryLabel,
  bool primaryFilled = true,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<AvishuDialogAction>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'dialog',
    barrierColor: AppColors.black.withValues(alpha: 0.22),
    transitionDuration: AvishuMotion.medium,
    pageBuilder: (ctx, animation, secondaryAnimation) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stackedActions = constraints.maxWidth < 320;
                    final buttonWidth = stackedActions
                        ? constraints.maxWidth
                        : secondaryLabel == null
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 12) / 2;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (secondaryLabel != null)
                          SizedBox(
                            width: buttonWidth,
                            child: AvishuPressable(
                              onTap: () => Navigator.pop(
                                ctx,
                                AvishuDialogAction.secondary,
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 56,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 16,
                                ),
                                color: AppColors.lightGrey,
                                child: AvishuButtonLabel(
                                  text: secondaryLabel,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: buttonWidth,
                          child: AvishuPressable(
                            onTap: () =>
                                Navigator.pop(ctx, AvishuDialogAction.primary),
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 56),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: primaryFilled
                                    ? AppColors.black
                                    : AppColors.white,
                                border: primaryFilled
                                    ? null
                                    : Border.all(
                                        color: AppColors.black,
                                        width: 1,
                                      ),
                              ),
                              child: AvishuButtonLabel(
                                text: primaryLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: primaryFilled
                                      ? AppColors.white
                                      : AppColors.black,
                                ),
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
    ),
    transitionBuilder: (ctx, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: AvishuMotion.emphasis,
        reverseCurve: AvishuMotion.exit,
      );

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

Future<PaymentMethod?> showPaymentMethodSheet({
  required BuildContext context,
  required int amount,
  required String ctaLabel,
  List<PaymentCardModel> savedCards = const [],
}) {
  var selectedMethod = PaymentMethod.kaspi;
  var selectedCardId = savedCards.isNotEmpty ? savedCards.first.id : null;

  return showModalBottomSheet<PaymentMethod>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    builder: (ctx) => StatefulBuilder(
      builder: (context, setModalState) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    color: AppColors.divider,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Оплата',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 20),
                ...PaymentMethod.values.map(
                  (method) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PaymentMethodTile(
                      method: method,
                      selected: method == selectedMethod,
                      onTap: () => setModalState(() => selectedMethod = method),
                    ),
                  ),
                ),
                if (selectedMethod == PaymentMethod.card) ...[
                  const SizedBox(height: 4),
                  if (savedCards.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: AppColors.lightGrey,
                      child: Text(
                        'Сохранённых карт пока нет. Оплата картой всё ещё доступна, а карты можно добавить в профиле.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          color: AppColors.grey,
                        ),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Сохранённые карты',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...savedCards.map(
                          (card) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _SavedCardTile(
                              card: card,
                              selected: card.id == selectedCardId,
                              onTap: () =>
                                  setModalState(() => selectedCardId = card.id),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.lightGrey,
                  child: Row(
                    children: [
                      Text(
                        'Итого',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.grey,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₸$amount',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, selectedMethod),
                    child: AvishuButtonLabel(
                      text: ctaLabel,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Future<OrderSizeModel?> showOrderSizingSheet({
  required BuildContext context,
  required String title,
  required String ctaLabel,
  required List<String> measurementFields,
  SavedMeasurementProfileModel? savedProfile,
}) {
  var selectedMode = OrderSizeMode.standard;
  final standardController = TextEditingController();
  final measurementControllers = {
    for (final field in measurementFields) field: TextEditingController(),
  };
  String? errorText;

  return showModalBottomSheet<OrderSizeModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    builder: (ctx) => StatefulBuilder(
      builder: (context, setModalState) {
        void clearError() {
          if (errorText != null) {
            setModalState(() => errorText = null);
          }
        }

        void submit() {
          if (selectedMode == OrderSizeMode.standard) {
            final normalized = standardController.text.trim().toUpperCase();
            if (normalized.isEmpty) {
              setModalState(() => errorText = 'Укажите размер');
              return;
            }
            Navigator.pop(ctx, OrderSizeModel.standard(normalized));
            return;
          }

          if (selectedMode == OrderSizeMode.savedProfile &&
              savedProfile != null) {
            Navigator.pop(ctx, savedProfile.toOrderSizeModel());
            return;
          }

          final measurements = <String, String>{
            for (final entry in measurementControllers.entries)
              entry.key: entry.value.text.trim(),
          }..removeWhere((_, value) => value.isEmpty);

          if (measurements.length != measurementControllers.length) {
            setModalState(
              () => errorText = 'Заполните все параметры для кастомного пошива',
            );
            return;
          }

          Navigator.pop(ctx, OrderSizeModel.custom(measurements));
        }

        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                24,
                20,
                24,
                24 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        color: AppColors.divider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 12),
                    Text(
                      'Можно указать обычный размер или ввести мерки вручную по каждому параметру изделия.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: savedProfile == null
                              ? (constraints.maxWidth - 12) / 2
                              : (constraints.maxWidth - 24) / 3,
                          child: _SizingModeCard(
                            title: 'Стандартный',
                            subtitle: 'XS, M, XL, 42',
                            selected: selectedMode == OrderSizeMode.standard,
                            onTap: () => setModalState(() {
                              selectedMode = OrderSizeMode.standard;
                              errorText = null;
                            }),
                          ),
                        ),
                        SizedBox(
                          width: savedProfile == null
                              ? (constraints.maxWidth - 12) / 2
                              : (constraints.maxWidth - 24) / 3,
                          child: _SizingModeCard(
                            title: 'Кастомный',
                            subtitle: 'Мерки вручную',
                            selected: selectedMode == OrderSizeMode.custom,
                            onTap: () => setModalState(() {
                              selectedMode = OrderSizeMode.custom;
                              errorText = null;
                            }),
                          ),
                        ),
                        if (savedProfile != null)
                          SizedBox(
                            width: (constraints.maxWidth - 24) / 3,
                            child: _SizingModeCard(
                              title: 'Своя',
                              subtitle: 'Сохранённые мерки',
                              selected:
                                  selectedMode == OrderSizeMode.savedProfile,
                              onTap: () => setModalState(() {
                                selectedMode = OrderSizeMode.savedProfile;
                                errorText = null;
                              }),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: AvishuMotion.medium,
                      transitionBuilder: buildAvishuSwitcherTransition,
                      child: selectedMode == OrderSizeMode.standard
                          ? TextField(
                              key: const ValueKey('standard_size'),
                              controller: standardController,
                              autofocus: true,
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.done,
                              onChanged: (_) => clearError(),
                              onSubmitted: (_) => submit(),
                              decoration: InputDecoration(
                                labelText: 'Размер',
                                hintText: 'Например, M или 42',
                                errorText: errorText,
                              ),
                            )
                          : selectedMode == OrderSizeMode.savedProfile &&
                                savedProfile != null
                          ? Container(
                              key: const ValueKey('saved_profile'),
                              padding: const EdgeInsets.all(16),
                              color: AppColors.lightGrey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Будут использованы ваши сохранённые мерки',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    savedProfile.summary,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  if (savedProfile.figureFeatures
                                      .trim()
                                      .isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Особенности: ${savedProfile.figureFeatures.trim()}',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            )
                          : Column(
                              key: const ValueKey('custom_size'),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ...measurementControllers.entries.map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: TextField(
                                      controller: entry.value,
                                      textInputAction: TextInputAction.next,
                                      onChanged: (_) => clearError(),
                                      decoration: InputDecoration(
                                        labelText: entry.key,
                                        hintText: 'Введите вручную',
                                      ),
                                    ),
                                  ),
                                ),
                                if (errorText != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      errorText!,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: submit,
                        child: AvishuButtonLabel(
                          text: ctaLabel,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _SizingModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _SizingModeCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AvishuPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AvishuMotion.medium,
        curve: AvishuMotion.emphasis,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : AppColors.lightGrey,
          border: Border.all(
            color: selected ? AppColors.black : AppColors.divider,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: selected ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.white : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedCardTile extends StatelessWidget {
  final PaymentCardModel card;
  final bool selected;
  final VoidCallback onTap;

  const _SavedCardTile({
    required this.card,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AvishuPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AvishuMotion.medium,
        curve: AvishuMotion.emphasis,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : AppColors.lightGrey,
          border: Border.all(
            color: selected ? AppColors.black : AppColors.divider,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.cardholderName,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: selected ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    card.maskedNumber,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: selected ? AppColors.white : AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Срок ${card.expiry}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.white : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_sharp,
                size: 18,
                color: AppColors.white,
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AvishuPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AvishuMotion.medium,
        curve: AvishuMotion.emphasis,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : AppColors.lightGrey,
          border: Border.all(
            color: selected ? AppColors.black : AppColors.divider,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.checkoutTitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: selected ? AppColors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: AvishuMotion.medium,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.white : AppColors.black,
                  width: 1,
                ),
              ),
              child: selected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
