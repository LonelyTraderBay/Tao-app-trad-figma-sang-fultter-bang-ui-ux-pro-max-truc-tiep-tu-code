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
          'Lịch sử chuyển gần đây',
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: AppColors.dividerBlueSubtle),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _transferPrimary.withValues(alpha: .12),
              borderRadius: AppRadii.cardRadius,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.swap_vert_rounded,
              color: _transferPrimary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transfer.fromWallet} → ${transfer.toWallet}',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  transfer.time,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${formatTransferAssetAmount(transfer.amount)} ${transfer.asset}',
            style: AppTextStyles.caption.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _WalletIcon(wallet: wallet, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                wallet.name,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              formatTransferUsd(wallet.balanceUsd),
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(width: 8),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: _transferPrimary),
          ],
        ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _AssetLogo(asset: asset, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.symbol,
                    style: AppTextStyles.baseMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    asset.name,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            Text(
              formatTransferAssetAmount(asset.available),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(width: 8),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: _transferPrimary),
          ],
        ),
      ),
    );
  }
}

class TransferSuccessBanner extends StatelessWidget {
  const TransferSuccessBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _transferGreen.withValues(alpha: .12),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _transferGreen.withValues(alpha: .30)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: _transferGreen,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Chuyển thành công!',
            style: AppTextStyles.caption.copyWith(
              color: _transferGreen,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
