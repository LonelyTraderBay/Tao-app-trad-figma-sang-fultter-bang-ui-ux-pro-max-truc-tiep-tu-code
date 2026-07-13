import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/theme/trade_core_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Status-banner hero for the regulatory/compliance archetype — an icon,
/// title, and description tinted by [accentColor]. Pairs with
/// [VitTradeComplianceSection] directly below it inside
/// [VitTradeHubScaffold] or [VitTradeDetailScaffold]; replaces a page-local
/// `Material`/`Stack` legal-tint wrapper.
class VitTradeComplianceHero extends StatelessWidget {
  const VitTradeComplianceHero({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.balance_rounded,
    this.accentColor = AppColors.primary,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      density: VitDensity.compact,
      borderColor: accentColor,
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSpacing.x4,
            backgroundColor: AppColors.surface2,
            child: Icon(
              icon,
              color: accentColor,
              size: TradeCoreSpacingTokens.regulatoryDisclosuresHeroIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: accentColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: accentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
