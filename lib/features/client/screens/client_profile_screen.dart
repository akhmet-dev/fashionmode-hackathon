import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/providers.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_notification_model.dart';
import '../../../shared/models/saved_measurement_profile_model.dart';
import '../../../shared/widgets/avishu_buttons.dart';
import '../../../shared/widgets/avishu_motion.dart';

class ClientProfileScreen extends ConsumerWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final orders = ref.watch(clientOrdersProvider).valueOrNull ?? const [];
    final notifications = ref.watch(notificationInboxProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final loyalty = _resolveLoyalty(orders.length);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        children: [
          AvishuReveal(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ПРОФИЛЬ',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.name ?? 'CLIENT',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
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
                      'ВЫЙТИ',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AvishuReveal(
            delay: const Duration(milliseconds: 40),
            child: Row(
              children: [
                Expanded(
                  child: _QuickActionTile(
                    title: 'Корзина',
                    subtitle: 'Перейти к оформлению',
                    badge: '${ref.watch(cartItemCountProvider)}',
                    onTap: () => context.go('/client/cart'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionTile(
                    title: 'Сообщения',
                    subtitle: unreadCount > 0
                        ? 'Новых: $unreadCount'
                        : 'Открыть inbox',
                    badge: unreadCount > 0 ? '$unreadCount' : '0',
                    onTap: () =>
                        _showNotificationInbox(context, ref, notifications),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AvishuReveal(
            delay: const Duration(milliseconds: 70),
            child: Container(
              padding: const EdgeInsets.all(18),
              color: AppColors.lightGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'ПРОГРЕСС ЛОЯЛЬНОСТИ',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.black, width: 1),
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
                  const SizedBox(height: 14),
                  _ProfileProgressBar(progress: loyalty.progress),
                  const SizedBox(height: 12),
                  Text(
                    loyalty.message,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Всего заказов: ${orders.length}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _ProfileSectionTitle(
            title: 'СОХРАНЁННЫЕ КАРТЫ',
            actionLabel: 'ДОБАВИТЬ',
            onTap: () => _showAddCardSheet(context, ref),
          ),
          const SizedBox(height: 12),
          if (user == null || user.savedCards.isEmpty)
            const _EmptyProfileBlock(
              message:
                  'Карт пока нет. Сохраните карту один раз, чтобы не вводить её заново при оплате.',
            )
          else
            ...List.generate(user.savedCards.length, (index) {
              final card = user.savedCards[index];
              return AvishuReveal(
                delay: Duration(milliseconds: 35 * index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  color: AppColors.lightGrey,
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
                                color: AppColors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              card.maskedNumber,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Срок действия: ${card.expiry}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      AvishuPressable(
                        onTap: () async {
                          await ref
                              .read(firestoreServiceProvider)
                              .removeSavedCard(card.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'УДАЛИТЬ',
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
              );
            }),
          const SizedBox(height: 12),
          _ProfileSectionTitle(
            title: 'МОИ МЕРКИ',
            actionLabel: user?.savedMeasurements == null
                ? 'ДОБАВИТЬ'
                : 'ИЗМЕНИТЬ',
            onTap: () =>
                _showMeasurementSheet(context, ref, user?.savedMeasurements),
          ),
          const SizedBox(height: 12),
          if (user?.savedMeasurements == null)
            const _EmptyProfileBlock(
              message:
                  'Сохраните рост, обхваты и другие мерки один раз. Потом их можно будет выбирать при заказе как «Своя».',
            )
          else
            AvishuReveal(
              child: Container(
                padding: const EdgeInsets.all(18),
                color: AppColors.lightGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.savedMeasurements!.summary,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...user.savedMeasurements!.toMeasurementMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                entry.key,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          _ProfileSectionTitle(title: 'ПОСЛЕДНИЕ СООБЩЕНИЯ'),
          const SizedBox(height: 12),
          if (notifications.isEmpty)
            const _EmptyProfileBlock(message: 'Сообщений пока нет.')
          else
            ...List.generate(
              notifications.length > 3 ? 3 : notifications.length,
              (index) {
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
                                  letterSpacing: 1,
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
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification.body,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Future<void> _showNotificationInbox(
    BuildContext context,
    WidgetRef ref,
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
              'СООБЩЕНИЯ',
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
                  'УВЕДОМЛЕНИЙ ПОКА НЕТ',
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
              ...notifications.map(
                (notification) => Container(
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
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddCardSheet(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    String? errorText;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> submit() async {
            final name = nameController.text.trim();
            final digits = numberController.text.replaceAll(RegExp(r'\D'), '');
            final expiry = expiryController.text.trim();
            final cvv = cvvController.text.replaceAll(RegExp(r'\D'), '');
            if (name.isEmpty ||
                digits.length < 12 ||
                expiry.isEmpty ||
                cvv.length < 3) {
              setModalState(
                () => errorText =
                    'Укажите имя владельца, номер карты, срок действия и CVV / CVC',
              );
              return;
            }

            await ref
                .read(firestoreServiceProvider)
                .addSavedCard(
                  cardholderName: name,
                  cardNumber: digits,
                  expiry: expiry,
                );
            if (ctx.mounted) Navigator.pop(ctx);
          }

          return Padding(
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
                  'НОВАЯ КАРТА',
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
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Имя владельца карты',
                    hintText: 'Например, CLIENT USER',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Номер карты',
                    hintText: '0000 0000 0000 0000',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: expiryController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Срок действия',
                    hintText: 'MM/YY',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'CVV / CVC',
                    hintText: '123',
                  ),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    errorText!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: submit,
                    child: AvishuButtonLabel(
                      text: 'СОХРАНИТЬ КАРТУ',
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
          );
        },
      ),
    );
  }

  Future<void> _showMeasurementSheet(
    BuildContext context,
    WidgetRef ref,
    SavedMeasurementProfileModel? current,
  ) async {
    final heightController = TextEditingController(text: current?.height ?? '');
    final bustController = TextEditingController(text: current?.bust ?? '');
    final waistController = TextEditingController(text: current?.waist ?? '');
    final hipsController = TextEditingController(text: current?.hips ?? '');
    final shouldersController = TextEditingController(
      text: current?.shoulderWidth ?? '',
    );
    final sleeveController = TextEditingController(
      text: current?.sleeveLength ?? '',
    );
    final featuresController = TextEditingController(
      text: current?.figureFeatures ?? '',
    );
    String? errorText;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> submit() async {
            final requiredValues = [
              heightController.text,
              bustController.text,
              waistController.text,
              hipsController.text,
              shouldersController.text,
              sleeveController.text,
            ];

            if (requiredValues.any((value) => value.trim().isEmpty)) {
              setModalState(
                () => errorText = 'Заполните все обязательные мерки',
              );
              return;
            }

            final profile = SavedMeasurementProfileModel(
              height: heightController.text.trim(),
              bust: bustController.text.trim(),
              waist: waistController.text.trim(),
              hips: hipsController.text.trim(),
              shoulderWidth: shouldersController.text.trim(),
              sleeveLength: sleeveController.text.trim(),
              figureFeatures: featuresController.text.trim(),
            );

            await ref
                .read(firestoreServiceProvider)
                .saveMeasurementProfile(profile);
            if (ctx.mounted) Navigator.pop(ctx);
          }

          Widget buildField(
            TextEditingController controller,
            String label, {
            String? hint,
            int maxLines = 1,
          }) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(labelText: label, hintText: hint),
                onChanged: (_) {
                  if (errorText != null) {
                    setModalState(() => errorText = null);
                  }
                },
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              24 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'МОИ МЕРКИ',
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
                  buildField(heightController, 'Рост'),
                  buildField(bustController, 'Обхват груди'),
                  buildField(waistController, 'Обхват талии'),
                  buildField(hipsController, 'Обхват бёдер'),
                  buildField(shouldersController, 'Ширина плеч'),
                  buildField(sleeveController, 'Длина рукава'),
                  buildField(
                    featuresController,
                    'Особенности фигуры',
                    hint: 'живот, сутулость и т.д.',
                    maxLines: 3,
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      errorText!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: submit,
                      child: AvishuButtonLabel(
                        text: 'СОХРАНИТЬ МЕРКИ',
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
}

class _QuickActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AvishuPressable(
      onTap: onTap,
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
                    title.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  color: AppColors.black,
                  child: Text(
                    badge,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  const _ProfileSectionTitle({
    required this.title,
    this.actionLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.grey,
            ),
          ),
        ),
        if (actionLabel != null && onTap != null)
          AvishuPressable(
            onTap: onTap!,
            child: Text(
              actionLabel!,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
                color: AppColors.black,
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyProfileBlock extends StatelessWidget {
  final String message;

  const _EmptyProfileBlock({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      color: AppColors.lightGrey,
      child: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: AppColors.grey,
        ),
      ),
    );
  }
}

class _LoyaltyData {
  final String title;
  final String message;
  final double progress;

  const _LoyaltyData({
    required this.title,
    required this.message,
    required this.progress,
  });
}

_LoyaltyData _resolveLoyalty(int orderCount) {
  if (orderCount >= 100) {
    return const _LoyaltyData(
      title: 'ИКОНА',
      message: 'Максимальный уровень достигнут.',
      progress: 1,
    );
  }
  if (orderCount >= 75) {
    return _LoyaltyData(
      title: 'ЭКСПЕРТ',
      message: 'До уровня ИКОНА осталось ${100 - orderCount} заказов.',
      progress: (orderCount - 75) / 25,
    );
  }
  if (orderCount >= 50) {
    return _LoyaltyData(
      title: 'СТИЛИСТ',
      message: 'До уровня ЭКСПЕРТ осталось ${75 - orderCount} заказов.',
      progress: (orderCount - 50) / 25,
    );
  }
  if (orderCount >= 30) {
    return _LoyaltyData(
      title: 'МОДНИК',
      message: 'До уровня СТИЛИСТ осталось ${50 - orderCount} заказов.',
      progress: (orderCount - 30) / 20,
    );
  }
  if (orderCount >= 15) {
    return _LoyaltyData(
      title: 'ЛЮБИТЕЛЬ',
      message: 'До уровня МОДНИК осталось ${30 - orderCount} заказов.',
      progress: (orderCount - 15) / 15,
    );
  }
  return _LoyaltyData(
    title: 'НОВИЧОК',
    message: 'До уровня ЛЮБИТЕЛЬ осталось ${15 - orderCount} заказов.',
    progress: orderCount / 15,
  );
}

class _ProfileProgressBar extends StatelessWidget {
  final double progress;

  const _ProfileProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: AppColors.divider)),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
