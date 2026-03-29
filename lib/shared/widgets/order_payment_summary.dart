import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../models/order_model.dart';

class OrderPaymentSummary extends StatelessWidget {
  final PaymentMethod? method;
  final PaymentStatus status;

  const OrderPaymentSummary({
    super.key,
    required this.method,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusIsPaid = status == PaymentStatus.paid;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _PaymentBadge(label: method?.checkoutTitle ?? 'Способ не указан'),
        _PaymentBadge(label: status.label, inverted: statusIsPaid),
      ],
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String label;
  final bool inverted;

  const _PaymentBadge({required this.label, this.inverted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: inverted ? AppColors.black : AppColors.white,
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: inverted ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }
}
