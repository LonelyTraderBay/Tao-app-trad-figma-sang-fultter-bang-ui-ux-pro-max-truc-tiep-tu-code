import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_manager_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class WalletActivityTab extends StatelessWidget {
  const WalletActivityTab({super.key, required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Recent Activity',
      headerIcon: Icons.history_rounded,
      accentColor: walletManagerPrimary,
      innerGap: AppSpacing.pageRhythmStandardInnerGap,
      children: [
        for (var i = 0; i < snapshot.wallets.length; i++) ...[
          _ActivityRow(wallet: snapshot.wallets[i]),
          if (i != snapshot.wallets.length - 1)
            const SizedBox(
              height: WalletSpacingTokens.walletManagerActivityRowGap,
            ),
        ],
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.wallet});

  final WalletManagerItem wallet;

  @override
  Widget build(BuildContext context) {
    final color = Color(wallet.typeColorHex);
    final parts = wallet.lastActiveLabel.split(' ');
    final time = parts.isNotEmpty ? parts.first : wallet.lastActiveLabel;
    final date = parts.length > 1 ? parts.skip(1).join(' ') : '';
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: WalletSpacingTokens.walletManagerActivityRowHeight,
      padding: WalletSpacingTokens.walletManagerActivityRowPadding,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: walletManagerBorder,
      background: const ColoredBox(color: walletManagerPanel),
      clip: true,
      child: Row(
        children: [
          SizedBox(
            width: WalletSpacingTokens.walletManagerActivityIconBox,
            height: WalletSpacingTokens.walletManagerActivityIconBox,
            child: ClipRRect(
              borderRadius: AppRadii.smRadius,
              child: ColoredBox(
                color: color.withValues(alpha: .16),
                child: Center(
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: color,
                    size: WalletSpacingTokens.walletManagerActivityIcon,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: WalletSpacingTokens.walletManagerActivityIconGap,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: TradeSpacingTokens.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(
                  height: WalletSpacingTokens.walletManagerActivityTextGap,
                ),
                Text(
                  wallet.maskedAddress,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: TradeSpacingTokens.tradeBotLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.text2,
                  height: TradeSpacingTokens.tradeBotLineHeightTight,
                ),
              ),
              const SizedBox(
                height: WalletSpacingTokens.walletManagerActivityTimeGap,
              ),
              Text(
                time,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: TradeSpacingTokens.tradeBotLineHeightTight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
