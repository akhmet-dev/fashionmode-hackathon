import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:fashionmode_hackathon/l10n/app_localizations.dart';

import '../../../core/providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/order_model.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/avishu_motion.dart';

String _statusLabel(OrderStatus status, AppLocalizations l) => switch (status) {
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
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final formatter = NumberFormat('#,###', 'en_US');

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: AvishuReveal(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.controlTowerTitle,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l.controlTowerSubtitle,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AvishuPressable(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) context.go('/login');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.black, width: 1),
                      ),
                      child: Text(
                        l.logout,
                        style: GoogleFonts.inter(
                          fontSize: 10,
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
            const SizedBox(height: 24),
            ordersAsync.when(
              data: (orders) {
                final now = DateTime.now();
                final placed = orders
                    .where((order) => order.status == OrderStatus.placed)
                    .length;
                final sewing = orders
                    .where((order) => order.status == OrderStatus.sewing)
                    .length;
                final ready = orders
                    .where((order) => order.status == OrderStatus.ready)
                    .length;
                final todayRevenue = orders
                    .where(
                      (order) =>
                          order.status == OrderStatus.ready &&
                          (order.completedAt ?? order.createdAt).day ==
                              now.day &&
                          (order.completedAt ?? order.createdAt).month ==
                              now.month &&
                          (order.completedAt ?? order.createdAt).year ==
                              now.year,
                    )
                    .fold<int>(0, (sum, order) => sum + order.price);
                final revenueTarget = currentUser?.dailyRevenueTarget ?? 180000;
                final planPercent = ((todayRevenue / revenueTarget) * 100)
                    .clamp(0, 100)
                    .round();
                final completionPercent = orders.isEmpty
                    ? 0
                    : ((ready / orders.length) * 100).round();
                final averageCheck = orders.isEmpty
                    ? 0
                    : (orders.fold<int>(0, (sum, order) => sum + order.price) /
                              orders.length)
                          .round();
                final recent = orders.take(5).toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AvishuReveal(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          color: AppColors.black,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.todayRevenue,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AnimatedSwitcher(
                                duration: AvishuMotion.medium,
                                transitionBuilder:
                                    buildAvishuSwitcherTransition,
                                child: Text(
                                  '₸${formatter.format(todayRevenue)}',
                                  key: ValueKey(todayRevenue),
                                  style: GoogleFonts.inter(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      l.dailyGoalLabel(
                                        formatter.format(revenueTarget),
                                      ),
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.4,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  AvishuPressable(
                                    onTap: () => _showTargetSheet(
                                      context,
                                      ref,
                                      l,
                                      currentUser,
                                      revenueTarget,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        l.editPlanButton,
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.4,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _ProgressLine(
                                progress: planPercent / 100,
                                foreground: AppColors.white,
                                background: AppColors.divider,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l.planProgressLabel(
                                  planPercent,
                                  formatter.format(revenueTarget),
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              label: l.plan,
                              value: '$planPercent%',
                              delay: const Duration(milliseconds: 40),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              label: l.completionRateLabel,
                              value: '$completionPercent%',
                              delay: const Duration(milliseconds: 80),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              label: l.averageCheckLabel,
                              value: '₸${formatter.format(averageCheck)}',
                              delay: const Duration(milliseconds: 120),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              label: l.activeOrders,
                              value: '${placed + sewing}',
                              delay: const Duration(milliseconds: 160),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 20),
                      Text(
                        l.orderFlowTitle,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _FlowCard(
                              label: l.newOrdersLabel,
                              value: '$placed',
                              delay: const Duration(milliseconds: 200),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _FlowCard(
                              label: l.sewingLoadLabel,
                              value: '$sewing',
                              delay: const Duration(milliseconds: 240),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _FlowCard(
                              label: l.readyOrdersLabel,
                              value: '$ready',
                              delay: const Duration(milliseconds: 280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 20),
                      Text(
                        l.liveOrdersTitle,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (recent.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
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
                        )
                      else
                        Column(
                          children: List.generate(recent.length, (index) {
                            final order = recent[index];
                            return AvishuReveal(
                              delay: Duration(milliseconds: 40 * index),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                color: AppColors.lightGrey,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            const SizedBox(height: 4),
                                            Text(
                                              '${order.clientName} · ${order.sizing.hasDetailedMeasurements ? order.sizing.summary : 'Размер: ${order.sizing.summary}'}',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: AppColors.grey,
                                              ),
                                            ),
                                            if (order
                                                .sizing
                                                .hasDetailedMeasurements) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                order.sizing.details,
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 4),
                                            Text(
                                              DateFormat(
                                                'HH:mm',
                                              ).format(order.createdAt),
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: AppColors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: AvishuMotion.medium,
                                        curve: AvishuMotion.emphasis,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
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
                                            color:
                                                order.status ==
                                                    OrderStatus.ready
                                                ? AppColors.white
                                                : AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 240,
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
          ],
        ),
      ),
    );
  }

  Future<void> _showTargetSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    AppUser? currentUser,
    int revenueTarget,
  ) async {
    final controller = TextEditingController(text: revenueTarget.toString());

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => Padding(
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
            Text(
              l.setPlanTitle,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 16),
            Text(
              l.setPlanHint,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: l.setPlanInputHint,
                suffixText: '₸',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AvishuPressable(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: AppColors.lightGrey,
                      child: Center(
                        child: Text(
                          l.dismissButton,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AvishuPressable(
                    onTap: () async {
                      final value = int.tryParse(controller.text.trim());
                      if (value == null || value <= 0 || currentUser == null) {
                        return;
                      }
                      await ref
                          .read(firestoreServiceProvider)
                          .updateDailyRevenueTarget(value);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: AppColors.black,
                      child: Center(
                        child: Text(
                          l.savePlanButton,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    controller.dispose();
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Duration delay;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AvishuReveal(
      delay: delay,
      child: Container(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 10),
            AnimatedSwitcher(
              duration: AvishuMotion.medium,
              transitionBuilder: buildAvishuSwitcherTransition,
              child: Text(
                value,
                key: ValueKey(value),
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowCard extends StatelessWidget {
  final String label;
  final String value;
  final Duration delay;

  const _FlowCard({
    required this.label,
    required this.value,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AvishuReveal(
      delay: delay,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        color: AppColors.lightGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: AvishuMotion.medium,
              transitionBuilder: buildAvishuSwitcherTransition,
              child: Text(
                value,
                key: ValueKey(value),
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final double progress;
  final Color foreground;
  final Color background;

  const _ProgressLine({
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
