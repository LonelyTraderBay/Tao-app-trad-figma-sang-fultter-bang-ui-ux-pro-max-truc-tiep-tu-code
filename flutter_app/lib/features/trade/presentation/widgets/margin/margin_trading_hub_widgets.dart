import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

/// Genuinely user-facing status badge (e.g. `LIVE`) — never a dev/roadmap
/// phase number.
class MarginHubStatusBadge extends StatelessWidget {
  const MarginHubStatusBadge({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class MarginHubComplianceInfoBanner extends StatelessWidget {
  const MarginHubComplianceInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      clip: true,
      padding: TradeSpacingTokens.marginTradingHubComplianceInfoPadding,
      background: ColoredBox(color: AppColors.accent.withValues(alpha: .10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.accent,
            size: TradeSpacingTokens.marginTradingHubComplianceIcon,
          ),
          const SizedBox(
            width: TradeSpacingTokens.marginTradingHubComplianceGap,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compliance controls',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                    height: TradeSpacingTokens.marginTradingHubLineHeightTight,
                  ),
                ),
                const SizedBox(
                  height: TradeSpacingTokens.marginTradingHubComplianceBodyGap,
                ),
                Text(
                  'Appropriateness checks, leverage limits, liquidation risk, and cost disclosure stay visible before margin actions.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: TradeSpacingTokens.marginTradingHubLineHeightBody,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
