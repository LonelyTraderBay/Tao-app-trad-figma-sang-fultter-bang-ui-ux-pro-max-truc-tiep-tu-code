import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/theme/trade_core_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Home-aligned 2-KPI hero strip for hub/list archetype pages (spot,
/// futures, margin, copy-trading, and bots hubs) — pairs with
/// [VitTradeHubScaffold].
class VitTradeHubHero extends StatelessWidget {
  const VitTradeHubHero({
    super.key,
    required this.primaryLabel,
    required this.primaryValue,
    required this.secondaryLabel,
    required this.secondaryValue,
    this.primaryColor,
    this.secondaryColor,
  });

  final String primaryLabel;
  final String primaryValue;
  final String secondaryLabel;
  final String secondaryValue;
  final Color? primaryColor;
  final Color? secondaryColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  primaryValue,
                  style: AppTextStyles.heroNumber.copyWith(
                    color: primaryColor ?? AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 1,
            height: AppSpacing.x6,
            child: ColoredBox(color: AppColors.border),
          ),
          Expanded(
            child: Padding(
              padding: TradeCoreSpacingTokens.tradeBotHeroSecondaryPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    secondaryLabel,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    secondaryValue,
                    style: AppTextStyles.heroNumber.copyWith(
                      color: secondaryColor ?? AppColors.text1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
