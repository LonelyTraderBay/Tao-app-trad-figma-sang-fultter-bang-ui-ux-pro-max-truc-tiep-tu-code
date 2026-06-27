part of 'wallet_transfer_sections.dart';

class RecentTransfersList extends StatelessWidget {
  const RecentTransfersList({super.key, required this.transfers});

  final List<WalletRecentTransfer> transfers;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      density: VitDensity.compact,
      child: Column(
        children: [
          for (var i = 0; i < transfers.length; i++)
            _RecentTransferRow(
              transfer: transfers[i],
              showDivider: i != transfers.length - 1,
            ),
        ],
      ),
    );
  }
}

class _RecentTransferRow extends StatelessWidget {
  const _RecentTransferRow({required this.transfer, required this.showDivider});

  final WalletRecentTransfer transfer;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return VitInfoRow(
      label:
          '${transfer.fromWallet} \u2192 ${transfer.toWallet} \u00b7 ${transfer.time}',
      value: '${formatTransferAssetAmount(transfer.amount)} ${transfer.asset}',
      density: VitDensity.compact,
      showDivider: showDivider,
      leading: const Icon(Icons.swap_vert_rounded),
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
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: selected ? _transferPrimary : AppColors.border,
      child: VitInfoRow(
        label: wallet.name,
        value: formatTransferUsd(wallet.balanceUsd),
        density: VitDensity.compact,
        leading: _WalletIcon(wallet: wallet, color: color),
        trailing: selected
            ? const Icon(
                Icons.check_circle_rounded,
                color: _transferPrimary,
                size: _transferActionIcon,
              )
            : null,
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
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: selected ? _transferPrimary : AppColors.border,
      child: VitInfoRow(
        label: '${asset.symbol} \u00b7 ${asset.name}',
        value: formatTransferAssetAmount(asset.available),
        density: VitDensity.compact,
        leading: _AssetLogo(asset: asset, size: _transferIconBox),
        trailing: selected
            ? const Icon(
                Icons.check_circle_rounded,
                color: _transferPrimary,
                size: _transferActionIcon,
              )
            : null,
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
      density: VitDensity.compact,
      borderColor: _transferGreen.withValues(alpha: .30),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: _transferGreen,
            size: _transferActionIcon,
          ),
          const SizedBox(width: _transferInlineGap),
          Text(
            'Chuy\u1ec3n th\u00e0nh c\u00f4ng!',
            style: AppTextStyles.control.copyWith(color: _transferGreen),
          ),
        ],
      ),
    );
  }
}
