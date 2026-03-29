import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:fashionmode_hackathon/l10n/app_localizations.dart';

import '../../../core/providers/providers.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_notification_model.dart';
import '../../../shared/models/order_model.dart';
import '../../../shared/widgets/avishu_dialogs.dart';
import '../../../shared/widgets/avishu_motion.dart';

String _statusLabel(OrderStatus s, AppLocalizations l) => switch (s) {
  OrderStatus.placed => l.statusPlaced,
  OrderStatus.sewing => l.statusSewing,
  OrderStatus.ready => l.statusReady,
};

class ClientOrdersScreen extends ConsumerWidget {
  const ClientOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final ordersAsync = ref.watch(clientOrdersProvider);
    final notifications = ref.watch(notificationInboxProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final orderCount = ordersAsync.valueOrNull?.length ?? 0;
    final loyalty = _resolveLoyalty(orderCount, l);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: AvishuReveal(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.myOrders,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AvishuPressable(
                    onTap: () => _showNotificationInbox(
                      context,
                      ref,
                      l,
                      notifications,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_sharp,
                            size: 20,
                            color: AppColors.black,
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 22,
                                minHeight: 22,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              color: AppColors.black,
                              child: Center(
                                child: Text(
                                  unreadCount > 99 ? '99+' : '$unreadCount',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AvishuReveal(
                delay: const Duration(milliseconds: 20),
                child: Text(
                  l.notificationsSummary(unreadCount),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AvishuReveal(
              delay: const Duration(milliseconds: 60),
              child: AvishuPressable(
                onTap: () => _showLoyaltyDetails(context, l, loyalty),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.lightGrey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l.loyaltyProgress,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: AvishuMotion.medium,
                            curve: AvishuMotion.emphasis,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.black,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              loyalty.title,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _AnimatedProgressBar(
                        progress: loyalty.progress,
                        foreground: AppColors.black,
                        background: AppColors.divider,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l.loyaltyLevelLabel(loyalty.title),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedSwitcher(
                        duration: AvishuMotion.medium,
                        transitionBuilder: buildAvishuSwitcherTransition,
                        child: Text(
                          loyalty.message,
                          key: ValueKey(loyalty.message),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.loyaltyTapHint,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return AvishuReveal(
                    child: Center(
                      child: Text(
                        l.noOrdersYet,
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
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, i) =>
                      _OrderCard(order: orders[i], index: i),
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

  Future<void> _showNotificationInbox(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    List<AppNotificationModel> notifications,
  ) async {
    await ref.read(notificationInboxProvider.notifier).markAllRead();
    await NotificationService().clearPresentedNotifications();

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.74,
        minChildSize: 0.48,
        maxChildSize: 0.94,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            Center(
              child: Container(width: 44, height: 4, color: AppColors.divider),
            ),
            const SizedBox(height: 20),
            Text(
              l.notificationsTitle,
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
            if (notifications.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  l.notificationsEmpty,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: AppColors.grey,
                  ),
                ),
              )
            else
              ...List.generate(notifications.length, (index) {
                final notification = notifications[index];
                return AvishuReveal(
                  delay: Duration(milliseconds: 30 * index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: AppColors.lightGrey,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat(
                                'dd.MM HH:mm',
                              ).format(notification.createdAt),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification.body,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  void _showLoyaltyDetails(
    BuildContext context,
    AppLocalizations l,
    _LoyaltyProgress loyalty,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.52,
        maxChildSize: 0.94,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            Center(
              child: Container(width: 44, height: 4, color: AppColors.divider),
            ),
            const SizedBox(height: 20),
            Text(
              l.loyaltyDetailsTitle,
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
            ...List.generate(loyalty.tiers.length, (index) {
              final tier = loyalty.tiers[index];
              final isActive = tier.title == loyalty.title;
              return AvishuReveal(
                delay: Duration(milliseconds: 35 * index),
                child: AnimatedContainer(
                  duration: AvishuMotion.medium,
                  curve: AvishuMotion.emphasis,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isActive ? AppColors.black : AppColors.lightGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tier.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: isActive
                                      ? AppColors.white
                                      : AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                tier.rangeLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: isActive
                                      ? AppColors.white
                                      : AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 12),
                          Text(
                            l.loyaltyCurrentStatus,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color foreground;
  final Color background;

  const _AnimatedProgressBar({
    required this.progress,
    required this.foreground,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: Stack(
        children: [
          Positioned.fill(child: ColoredBox(color: background)),
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
              duration: AvishuMotion.slow,
              curve: AvishuMotion.emphasis,
              builder: (context, value, _) => Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: value,
                  child: ColoredBox(color: foreground),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoyaltyTier {
  final String title;
  final int minOrders;
  final String rangeLabel;
  final int? nextThreshold;

  const _LoyaltyTier({
    required this.title,
    required this.minOrders,
    required this.rangeLabel,
    required this.nextThreshold,
  });
}

class _LoyaltyProgress {
  final String title;
  final String message;
  final double progress;
  final List<_LoyaltyTier> tiers;

  const _LoyaltyProgress({
    required this.title,
    required this.message,
    required this.progress,
    required this.tiers,
  });
}

_LoyaltyProgress _resolveLoyalty(int orderCount, AppLocalizations l) {
  final tiers = [
    _LoyaltyTier(
      title: l.loyaltyLevelNovice,
      minOrders: 0,
      rangeLabel: l.loyaltyRangeBetween(0, 15),
      nextThreshold: 15,
    ),
    _LoyaltyTier(
      title: l.loyaltyLevelStyleLover,
      minOrders: 15,
      rangeLabel: l.loyaltyRangeBetween(15, 30),
      nextThreshold: 30,
    ),
    _LoyaltyTier(
      title: l.loyaltyLevelFashionista,
      minOrders: 30,
      rangeLabel: l.loyaltyRangeBetween(30, 50),
      nextThreshold: 50,
    ),
    _LoyaltyTier(
      title: l.loyaltyLevelStylist,
      minOrders: 50,
      rangeLabel: l.loyaltyRangeBetween(50, 75),
      nextThreshold: 75,
    ),
    _LoyaltyTier(
      title: l.loyaltyLevelStyleExpert,
      minOrders: 75,
      rangeLabel: l.loyaltyRangeBetween(75, 100),
      nextThreshold: 100,
    ),
    _LoyaltyTier(
      title: l.loyaltyLevelStyleIcon,
      minOrders: 100,
      rangeLabel: l.loyaltyRangeFrom(100),
      nextThreshold: null,
    ),
  ];

  _LoyaltyTier current = tiers.first;
  for (final tier in tiers) {
    if (orderCount >= tier.minOrders) {
      current = tier;
    }
  }

  if (current.nextThreshold == null) {
    return _LoyaltyProgress(
      title: current.title,
      message: l.loyaltyMaxLevelMessage,
      progress: 1,
      tiers: tiers,
    );
  }

  final span = current.nextThreshold! - current.minOrders;
  final progress = ((orderCount - current.minOrders) / span).clamp(0.0, 1.0);
  final nextTier = tiers.firstWhere(
    (tier) => tier.minOrders == current.nextThreshold,
  );
  final ordersLeft = current.nextThreshold! - orderCount;

  return _LoyaltyProgress(
    title: current.title,
    message: l.loyaltyToNextLevel(ordersLeft, nextTier.title),
    progress: progress,
    tiers: tiers,
  );
}

class _OrderCard extends ConsumerWidget {
  final OrderModel order;
  final int index;

  const _OrderCard({required this.order, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final formatter = NumberFormat('#,###', 'en_US');

    return AvishuReveal(
      delay: Duration(milliseconds: 35 * (index % 8)),
      child: Container(
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
            if (order.status == OrderStatus.placed) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              AvishuPressable(
                onTap: () => _confirmCancel(context, ref, l),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      l.cancelButton,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.black,
                      ),
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

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) async {
    final action = await showAvishuActionDialog(
      context: context,
      title: l.cancelConfirmTitle,
      message: l.cancelConfirmMessage,
      primaryLabel: l.confirmButton,
      secondaryLabel: l.dismissButton,
    );

    if (action == AvishuDialogAction.primary && context.mounted) {
      await ref.read(firestoreServiceProvider).deleteOrder(order.id);
    }
  }
}

class _StatusProgressBar extends StatelessWidget {
  final OrderStatus status;

  const _StatusProgressBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
                  AnimatedContainer(
                    duration: AvishuMotion.medium,
                    curve: AvishuMotion.emphasis,
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.black : AppColors.white,
                      border: Border.all(
                        color: isActive ? AppColors.black : AppColors.grey,
                        width: 1,
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: AvishuMotion.fast,
                      child: isActive
                          ? const Icon(
                              Icons.check,
                              key: ValueKey(true),
                              size: 12,
                              color: AppColors.white,
                            )
                          : const SizedBox.shrink(key: ValueKey(false)),
                    ),
                  ),
                  if (i < steps.length - 1)
                    Expanded(
                      child: AnimatedContainer(
                        duration: AvishuMotion.medium,
                        curve: AvishuMotion.emphasis,
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
              child: AnimatedDefaultTextStyle(
                duration: AvishuMotion.medium,
                curve: AvishuMotion.emphasis,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: s == status ? FontWeight.w700 : FontWeight.w400,
                  letterSpacing: 1,
                  color: s.index <= currentIndex
                      ? AppColors.black
                      : AppColors.grey,
                ),
                child: Text(_statusLabel(s, l)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
