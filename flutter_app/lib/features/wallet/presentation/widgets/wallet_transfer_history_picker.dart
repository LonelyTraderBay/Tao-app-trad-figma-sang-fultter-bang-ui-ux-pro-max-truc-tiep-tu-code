part of 'wallet_transfer_sections.dart';

class RecentTransfersList extends StatelessWidget {
  const RecentTransfersList({super.key, required this.transfers});

  final List<WalletRecentTransfer> transfers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'L\u1ecbch s\u1eed chuy\u1ec3n g\u1ea7n \u0111\u00e2y',
          style: AppTextStyles.baseMedium,
        ),
        const SizedBox(height: AppSpacing.rowGap),
        for (var i = 0; i < transfers.length; i++)
          _RecentTransferRow(
            transfer: transfers[i],
            showDivider: i != transfers.length - 1,
          ),
      ],
    );
  }
}

class _RecentTransferRow extends StatelessWidget {
  const _RecentTransferRow({required this.transfer, required this.showDivider});

  final WalletRecentTransfer transfer;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppSpacing.walletTransferHistoryRowPadding,
          child: Row(
            children: [
              VitCard(
                width: AppSpacing.transferListIcon,
                height: AppSpacing.transferListIcon,
                variant: VitCardVariant.ghost,
                background: ColoredBox(
                  color: _transferPrimary.withValues(alpha: .12),
                ),
                alignment: Alignment.center,
                clip: true,
                child: Icon(
                  Icons.swap_vert_rounded,
                  color: _transferPrimary,
                  size: AppSpacing.transferBadgeIcon,
                ),
              ),
              const SizedBox(
                width: AppSpacing.searchBarHorizontalTrailingPadding,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${transfer.fromWallet} \u2192 ${transfer.toWallet}',
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      transfer.time,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${formatTransferAssetAmount(transfer.amount)} ${transfer.asset}',
                style: AppTextStyles.numericMicro,
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: AppSpacing.walletHistoryDividerHeight,
            thickness: AppSpacing.walletHistoryDividerHeight,
            color: AppColors.dividerBlueSubtle,
          ),
      ],
    );
  }
}

class TransferWalletPickerRow extends StatelessWidget {
  const TransferWalletPickerRow({
    super.key,
    required this.wallet,
    required this.selected,
    required this.onTap,
  });

  final WalletTransferWallet wallet;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(wallet.colorHex);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.walletTransferHistoryRowPadding,
            child: Row(
              children: [
                _WalletIcon(wallet: wallet, color: color),
                const SizedBox(
                  width: AppSpacing.searchBarHorizontalTrailingPadding,
                ),
                Expanded(
                  child: Text(wallet.name, style: AppTextStyles.baseMedium),
                ),
                Text(
                  formatTransferUsd(wallet.balanceUsd),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
                const SizedBox(
                  width: AppSpacing.searchBarHorizontalTrailingPadding,
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: _transferPrimary,
                  ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.walletHistoryDividerHeight,
            thickness: AppSpacing.walletHistoryDividerHeight,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class TransferAssetPickerRow extends StatelessWidget {
  const TransferAssetPickerRow({
    super.key,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final WalletTransferAsset asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.walletTransferHistoryRowPadding,
            child: Row(
              children: [
                _AssetLogo(asset: asset, size: AppSpacing.transferListIcon),
                const SizedBox(
                  width: AppSpacing.searchBarHorizontalTrailingPadding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(asset.symbol, style: AppTextStyles.baseMedium),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        asset.name,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatTransferAssetAmount(asset.available),
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text2,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: _transferPrimary,
                  ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.walletHistoryDividerHeight,
            thickness: AppSpacing.walletHistoryDividerHeight,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class TransferSuccessBanner extends StatelessWidget {
  const TransferSuccessBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.transferSuccessPadding,
      borderColor: _transferGreen.withValues(alpha: .30),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: _transferGreen,
            size: AppSpacing.transferActionIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            'Chuy\u1ec3n th\u00e0nh c\u00f4ng!',
            style: AppTextStyles.control.copyWith(color: _transferGreen),
          ),
        ],
      ),
    );
  }
}
