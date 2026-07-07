import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_carousel_dots.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inline_icon_action.dart';

enum VitAnnouncementBannerVariant { standard, compact }

class VitAnnouncementBanner extends StatelessWidget {
  const VitAnnouncementBanner({
    super.key,
    required this.message,
    this.icon = Icons.card_giftcard_rounded,
    this.accentColor = AppColors.primary,
    this.itemCount = 1,
    this.activeIndex = 0,
    this.variant = VitAnnouncementBannerVariant.standard,
    this.showCompactDots = false,
    this.onTap,
    this.onDismiss,
  });

  final String message;
  final IconData icon;
  final Color accentColor;
  final int itemCount;
  final int activeIndex;
  final VitAnnouncementBannerVariant variant;
  final bool showCompactDots;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  bool get _showDots {
    return itemCount > 1 &&
        (variant == VitAnnouncementBannerVariant.standard || showCompactDots);
  }

  EdgeInsetsGeometry get _padding {
    return switch (variant) {
      VitAnnouncementBannerVariant.standard =>
        AppSpacing.homeCardPaddingDefault,
      VitAnnouncementBannerVariant.compact =>
        AppSpacing.homeAnnouncementCardPaddingCompact,
    };
  }

  @override
  Widget build(BuildContext context) {
    final banner = Column(
      children: [
        VitCard(
          radius: VitCardRadius.standard,
          borderColor: accentColor.withValues(alpha: .18),
          padding: _padding,
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                icon,
                color: accentColor,
                size: AppSpacing.homeAnnouncementIcon,
              ),
              const SizedBox(width: AppSpacing.homeAnnouncementIconGap),
              Expanded(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              const SizedBox(width: AppSpacing.homeAnnouncementArrowGap),
              if (onDismiss == null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.homeAnnouncementChevron,
                )
              else
                VitInlineIconAction(
                  icon: Icons.close_rounded,
                  tooltip: 'Dismiss announcement',
                  color: AppColors.text3,
                  onPressed: onDismiss!,
                ),
            ],
          ),
        ),
        if (_showDots) ...[
          const SizedBox(height: AppSpacing.x3),
          VitCarouselDots(itemCount: itemCount, activeIndex: activeIndex),
        ],
      ],
    );

    return Semantics(label: 'Announcement: $message', child: banner);
  }
}
