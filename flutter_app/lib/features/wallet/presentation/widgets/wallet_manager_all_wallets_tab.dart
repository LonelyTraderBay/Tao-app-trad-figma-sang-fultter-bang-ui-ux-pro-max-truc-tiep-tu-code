import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_manager_common.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_manager_distribution_chart.dart';

class WalletAllWalletsTab extends StatelessWidget {
  const WalletAllWalletsTab({
    super.key,
    required this.snapshot,
    required this.selectedWalletId,
    required this.revealedWalletIds,
    required this.copiedWalletId,
    required this.onSelectWallet,
    required this.onRevealWallet,
    required this.onCopyWallet,
  });

  final WalletMultiManagerSnapshot snapshot;
  final String selectedWalletId;
  final Set<String> revealedWalletIds;
  final String? copiedWalletId;
  final ValueChanged<String> onSelectWallet;
  final ValueChanged<WalletManagerItem> onCopyWallet;
  final ValueChanged<String> onRevealWallet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PortfolioSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.walletManagerAllSummaryGap),
        WalletManagerDistributionCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.walletManagerAllDistributionGap),
        const WalletManagerSectionLabel(label: 'T\u1EA5t c\u1EA3 v\u00ED'),
        const SizedBox(height: AppSpacing.walletManagerAllSectionGap),
        for (var i = 0; i < snapshot.wallets.length; i++) ...[
          _WalletCard(
            wallet: snapshot.wallets[i],
            selected: selectedWalletId == snapshot.wallets[i].id,
            revealed: revealedWalletIds.contains(snapshot.wallets[i].id),
            copied: copiedWalletId == snapshot.wallets[i].id,
            onTap: () => onSelectWallet(snapshot.wallets[i].id),
            onReveal: () => onRevealWallet(snapshot.wallets[i].id),
            onCopy: () => onCopyWallet(snapshot.wallets[i]),
          ),
          if (i != snapshot.wallets.length - 1)
            const SizedBox(height: AppSpacing.walletManagerAllWalletGap),
        ],
        const SizedBox(height: AppSpacing.walletManagerAllAddTopGap),
        const WalletManagerAddWalletButton(),
        const SizedBox(height: AppSpacing.walletManagerAllSecurityTopGap),
        const WalletManagerSecurityNotice(),
      ],
    );
  }
}

class _PortfolioSummaryCard extends StatelessWidget {
  const _PortfolioSummaryCard({required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final positive = snapshot.totalChangeUsd >= 0;
    return Container(
      height: AppSpacing.walletManagerSummaryHeight,
      padding: AppSpacing.walletManagerSummaryPadding,
      decoration: BoxDecoration(
        color: walletManagerPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: walletManagerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.badge.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.walletManagerSummaryTitleGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formatWalletManagerUsd(snapshot.totalBalance, decimals: 0),
                style: AppTextStyles.amountMd.copyWith(height: 1),
              ),
              const SizedBox(width: AppSpacing.walletManagerSummaryValueGap),
              Icon(
                positive
                    ? Icons.arrow_outward_rounded
                    : Icons.south_east_rounded,
                color: positive ? walletManagerGreen : walletManagerRed,
                size: AppSpacing.walletManagerSummaryTrendIcon,
              ),
              const SizedBox(width: AppSpacing.walletManagerSummaryTrendGap),
              Text(
                formatWalletManagerPct(snapshot.totalChangePct),
                style: AppTextStyles.caption.copyWith(
                  color: positive ? walletManagerGreen : walletManagerRed,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _SummaryMetric(
                label: 'Wallets',
                value: '${snapshot.wallets.length}',
              ),
              _SummaryMetric(
                label: '24h Change',
                value: formatWalletManagerSignedUsd(
                  snapshot.totalChangeUsd,
                  decimals: 0,
                ),
                valueColor: positive ? walletManagerGreen : walletManagerRed,
              ),
              _SummaryMetric(
                label: 'Groups',
                value: '${snapshot.groups.length}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.walletManagerSummaryMetricGap),
          Text(
            value,
            style: AppTextStyles.control.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({
    required this.wallet,
    required this.selected,
    required this.revealed,
    required this.copied,
    required this.onTap,
    required this.onReveal,
    required this.onCopy,
  });

  final WalletManagerItem wallet;
  final bool selected;
  final bool revealed;
  final bool copied;
  final VoidCallback onTap;
  final VoidCallback onReveal;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final accent = Color(wallet.accentColorHex);
    final typeColor = Color(wallet.typeColorHex);
    final positive = wallet.change24hPct >= 0;
    return GestureDetector(
      key: Key('sc148_multi_manager_wallet_${wallet.id}'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.walletManagerWalletCardHeight,
        padding: AppSpacing.walletManagerWalletCardPadding,
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: .045) : walletManagerPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: selected ? accent : walletManagerBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WalletTypeIcon(wallet: wallet),
                const SizedBox(width: AppSpacing.walletManagerWalletIconGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              wallet.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.control.copyWith(
                                fontWeight: AppTextStyles.bold,
                                height: 1,
                              ),
                            ),
                          ),
                          if (wallet.isDefault) ...[
                            const SizedBox(
                              width: AppSpacing.walletManagerWalletBadgeGap,
                            ),
                            const WalletManagerDefaultBadge(),
                          ],
                          if (wallet.isFavorite) ...[
                            const SizedBox(
                              width: AppSpacing.walletManagerWalletBadgeGap,
                            ),
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.caution,
                              size: AppSpacing.walletManagerWalletFavoriteIcon,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(
                        height: AppSpacing.walletManagerWalletAddressGap,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              revealed ? wallet.address : wallet.maskedAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: AppSpacing.walletManagerWalletInlineGap,
                          ),
                          WalletManagerTinyIconButton(
                            buttonKey: Key(
                              'sc148_multi_manager_reveal_${wallet.id}',
                            ),
                            icon: revealed
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.text3,
                            onTap: onReveal,
                          ),
                          const SizedBox(
                            width: AppSpacing.walletManagerWalletActionGap,
                          ),
                          WalletManagerTinyIconButton(
                            buttonKey: Key(
                              'sc148_multi_manager_copy_${wallet.id}',
                            ),
                            icon: copied
                                ? Icons.check_circle_outline_rounded
                                : Icons.copy_rounded,
                            color: copied
                                ? walletManagerGreen
                                : AppColors.text3,
                            onTap: onCopy,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.walletManagerWalletMoreGap),
                const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.walletManagerWalletMoreIcon,
                ),
              ],
            ),
            const SizedBox(
              height: AppSpacing.walletManagerWalletBalanceBlockGap,
            ),
            Text(
              'Balance',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1,
              ),
            ),
            const SizedBox(
              height: AppSpacing.walletManagerWalletBalanceLabelGap,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formatWalletManagerUsd(wallet.balanceUsd, decimals: 0),
                  style: AppTextStyles.sectionTitle.copyWith(height: 1),
                ),
                const SizedBox(
                  width: AppSpacing.walletManagerWalletBalanceValueGap,
                ),
                Icon(
                  positive
                      ? Icons.trending_up_rounded
                      : Icons.south_east_rounded,
                  color: positive ? walletManagerGreen : walletManagerRed,
                  size: AppSpacing.walletManagerWalletTrendIcon,
                ),
                const SizedBox(width: AppSpacing.walletManagerWalletTrendGap),
                Text(
                  formatWalletManagerPct(wallet.change24hPct, decimals: 1),
                  style: AppTextStyles.badge.copyWith(
                    color: positive ? walletManagerGreen : walletManagerRed,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.walletManagerWalletAssetTopGap),
            Row(
              children: [
                for (final asset in wallet.assets.take(3)) ...[
                  WalletManagerAssetChip(symbol: asset.symbol),
                  const SizedBox(width: AppSpacing.walletManagerWalletAssetGap),
                ],
              ],
            ),
            const Spacer(),
            Container(
              height: AppSpacing.walletManagerWalletDividerHeight,
              color: AppColors.border,
            ),
            const SizedBox(height: AppSpacing.walletManagerWalletFooterGap),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.walletManagerWalletFooterIcon,
                ),
                const SizedBox(
                  width: AppSpacing.walletManagerWalletFooterIconGap,
                ),
                Expanded(
                  child: Text(
                    wallet.lastActiveLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1,
                    ),
                  ),
                ),
                WalletManagerTypeBadge(
                  label: wallet.type.toUpperCase(),
                  color: typeColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletTypeIcon extends StatelessWidget {
  const _WalletTypeIcon({required this.wallet});

  final WalletManagerItem wallet;

  @override
  Widget build(BuildContext context) {
    final color = Color(wallet.typeColorHex);
    final icon = wallet.type == 'hot'
        ? Icons.account_balance_wallet_outlined
        : Icons.shield_outlined;
    return Container(
      width: AppSpacing.walletManagerWalletTypeIconBox,
      height: AppSpacing.walletManagerWalletTypeIconBox,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.smRadius,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: color,
        size: AppSpacing.walletManagerWalletTypeIcon,
      ),
    );
  }
}
