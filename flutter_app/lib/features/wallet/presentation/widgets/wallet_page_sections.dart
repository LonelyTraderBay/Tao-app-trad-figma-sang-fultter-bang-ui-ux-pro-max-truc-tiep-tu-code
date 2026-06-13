import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_search_bar.dart';

part 'wallet_page_balance_sections.dart';
part 'wallet_page_dca_tool_sections.dart';
part 'wallet_page_asset_sections.dart';
part 'wallet_page_allocation_sections.dart';

const _walletPanel = AppColors.surface;
const _walletPanel2 = AppColors.surface2;
const _walletPrimary = AppColors.primary;
const _walletGreen = AppColors.buy;
const _walletRed = AppColors.sell;
const _walletAmber = AppColors.caution;
const _walletPurple = AppColors.accent;

class WalletSectionHeader extends StatelessWidget {
  const WalletSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? AppColors.text1,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.homeSectionHeaderIconGap),
        ],
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.homeSectionHeaderTitleLineHeight,
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: AppSpacing.homeSectionHeaderChevronSize,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
