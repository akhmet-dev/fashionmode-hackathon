import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
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
