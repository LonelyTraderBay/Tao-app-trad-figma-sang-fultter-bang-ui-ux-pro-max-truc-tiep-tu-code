import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_top_header_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_instrument_hero.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

/// Reusable instrument header for trade chart/detail surfaces.
class VitTradeTerminalHeader extends StatelessWidget {
  const VitTradeTerminalHeader({
    super.key,
    required this.symbol,
    required this.onPairTap,
    this.showBack = false,
    this.onBack,
    this.backKey,
    this.pairTapKey,
    this.leading,
    this.trailing,
    this.subtitle,
    this.priceLabel,
    this.changePct,
    this.highLabel,
    this.lowLabel,
    this.volumeLabel,
  });

  final String symbol;
  final VoidCallback onPairTap;
  final bool showBack;
  final VoidCallback? onBack;
  final Key? backKey;
  final Key? pairTapKey;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;
  final String? priceLabel;
  final double? changePct;
  final String? highLabel;
  final String? lowLabel;
  final String? volumeLabel;

  bool get _hasMetrics => priceLabel != null && changePct != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTopChrome(
          type: VitTopChromeType.instrument,
          showBack: showBack,
          onBack: onBack,
          backKey: backKey,
          leading: leading,
          body: Semantics(
            button: true,
            label: 'Chọn cặp giao dịch $symbol',
            child: VitCard(
              key: pairTapKey,
              onTap: onPairTap,
              variant: VitCardVariant.ghost,
              radius: VitCardRadius.standard,
              padding: TradeSpacingTokens.tradeHeaderBodyPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          symbol,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.sectionTitle,
                        ),
                        ?subtitle,
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: TradeSpacingTokens.tradeHeaderChevronGap,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text2,
                    size: TradeSpacingTokens.tradeHeaderChevron,
                  ),
                ],
              ),
            ),
          ),
          trailing: trailing == null
              ? null
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: trailing,
                ),
        ),
        if (_hasMetrics)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppTopHeaderTokens.horizontalPadding,
              AppSpacing.x1,
              AppTopHeaderTokens.horizontalPadding,
              AppSpacing.x2,
            ),
            child: VitTradeHeaderMetricsRow(
              priceLabel: priceLabel!,
              changePct: changePct!,
              highLabel: highLabel,
              lowLabel: lowLabel,
              volumeLabel: volumeLabel,
            ),
          ),
      ],
    );
  }
}
