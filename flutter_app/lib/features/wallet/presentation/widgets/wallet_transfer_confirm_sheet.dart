part of 'wallet_transfer_sections.dart';

class TransferConfirmSheet extends StatelessWidget {
  const TransferConfirmSheet({
    super.key,
    required this.fromWallet,
    required this.toWallet,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.onConfirm,
  });

  final WalletTransferWallet fromWallet;
  final WalletTransferWallet toWallet;
  final WalletTransferAsset asset;
  final double amount;
  final double usdValue;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: 'X\u00e1c nh\u1eadn chuy\u1ec3n n\u1ed9i b\u1ed9',
      child: ListView(
        shrinkWrap: true,
        children: [
          VitInfoRow(
            label: 'T\u1eeb',
            value: fromWallet.name,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: '\u0110\u1ebfn',
            value: toWallet.name,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'T\u00e0i s\u1ea3n',
            value: asset.symbol,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'S\u1ed1 l\u01b0\u1ee3ng',
            value: '${formatTransferAssetAmount(amount)} ${asset.symbol}',
            valueColor: _transferPrimary,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Gi\u00e1 tr\u1ecb',
            value: formatTransferUsd(usdValue),
            density: VitDensity.compact,
            showDivider: true,
          ),
          const VitInfoRow(
            label: 'Ph\u00ed',
            value: 'Mi\u1ec5n ph\u00ed',
            valueColor: _transferGreen,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.rowGap),
          const _ConfirmNote(),
          const SizedBox(height: AppSpacing.rowGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  onPressed: () => Navigator.of(context).pop(),
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.inputHeight,
                  child: const Text('Hu\u1ef7'),
                ),
              ),
              const SizedBox(width: _transferInlineGap),
              Expanded(
                child: VitCtaButton(
                  key: const Key('sc146_transfer_confirm'),
                  onPressed: onConfirm,
                  variant: VitCtaButtonVariant.primary,
                  height: AppSpacing.inputHeight,
                  child: const Text('X\u00e1c nh\u1eadn'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfirmNote extends StatelessWidget {
  const _ConfirmNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: _transferPrimary.withValues(alpha: .20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _transferPrimary,
            size: _transferActionIcon,
          ),
          const SizedBox(width: _transferInlineGap),
          Expanded(
            child: Text(
              'Chuy\u1ec3n n\u1ed9i b\u1ed9 x\u1eed l\u00fd ngay l\u1eadp t\u1ee9c. Ki\u1ec3m tra v\u00ed ngu\u1ed3n, v\u00ed nh\u1eadn, s\u1ed1 l\u01b0\u1ee3ng v\u00e0 ph\u00ed tr\u01b0\u1edbc khi x\u00e1c nh\u1eadn.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
