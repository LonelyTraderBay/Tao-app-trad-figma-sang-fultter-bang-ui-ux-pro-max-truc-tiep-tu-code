import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_accent_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inline_icon_action.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Suggested-next-step card: accent icon, title with optional status pill,
/// subtitle, and a trailing dismiss/CTA-chevron area.
class VitNextActionCard extends StatelessWidget {
  const VitNextActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.statusLabel,
    this.ctaLabel,
    this.onTap,
    this.onDismiss,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? statusLabel;
  final String? ctaLabel;
  final Color accentColor;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final hasTrailingAction = onDismiss != null || ctaLabel != null;
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsetsDirectional.all(
        SharedSpacingTokens.homeNextActionCardPadding,
      ),
      borderColor: accentColor.withValues(alpha: .28),
      child: Row(
        children: [
          SizedBox(
            width: SharedSpacingTokens.homeNextActionIconContainer,
            height: SharedSpacingTokens.homeNextActionIconContainer,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: accentColor.withValues(alpha: .14),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: accentColor,
                  size: SharedSpacingTokens.homeNextActionIconSize,
                ),
              ),
            ),
          ),
          const SizedBox(width: SharedSpacingTokens.homeCommandRowSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (statusLabel != null) ...[
                      const SizedBox(width: AppSpacing.x2),
                      VitAccentPill(
                        label: statusLabel!,
                        accentColor: accentColor,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: SharedSpacingTokens.homeSectionInnerGap),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          if (hasTrailingAction) ...[
            const SizedBox(width: AppSpacing.x3),
            if (onDismiss != null) ...[
              VitInlineIconAction(
                icon: Icons.close_rounded,
                tooltip: 'Ẩn gợi ý',
                color: AppColors.text3,
                onPressed: onDismiss!,
              ),
              const SizedBox(width: AppSpacing.x2),
            ],
            if (ctaLabel != null) ...[
              Text(
                ctaLabel!,
                style: AppTextStyles.caption.copyWith(
                  color: accentColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: SharedSpacingTokens.homeChevronGap),
              Icon(
                Icons.chevron_right_rounded,
                color: accentColor,
                size: SharedSpacingTokens.homeActionChevronSize,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
