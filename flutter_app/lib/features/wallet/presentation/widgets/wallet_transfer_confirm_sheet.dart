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
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.transferSheetPaddingWithAdditionalBottom(
          DeviceMetrics.nativeBottomChrome,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'X\u00e1c nh\u1eadn chuy\u1ec3n n\u1ed9i b\u1ed9',
              style: AppTextStyles.baseMedium,
            ),
            const SizedBox(height: AppSpacing.transferInfoGap),
            VitCard(
              variant: VitCardVariant.inner,
              padding: AppSpacing.transferCardInnerPadding,
              child: Column(
                children: [
                  _ConfirmRow(label: 'T\u1eeba', value: fromWallet.name),
                  _ConfirmRow(label: '\u0110\u1ebfn', value: toWallet.name),
                  _ConfirmRow(label: 'T\u00e0i s\u1ea3n', value: asset.symbol),
                  _ConfirmRow(
                    label: 'S\u1ed1 l\u01b0\u1ee3ng',
                    value:
                        '${formatTransferAssetAmount(amount)} ${asset.symbol}',
                    highlight: true,
                  ),
                  _ConfirmRow(
                    label: 'Gi\u00e1 tr\u1ecb',
                    value: formatTransferUsd(usdValue),
                  ),
                  const _ConfirmRow(
                    label: 'Ph\u00ed',
                    value: 'Mi\u1ec5n ph\u00ed',
                    valueColor: _transferGreen,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.rowGap),
            const _ConfirmNote(),
            const SizedBox(height: AppSpacing.transferInputGap),
            Row(
              children: [
                Expanded(
                  child: _SheetButton(
                    label: 'Hu\u1ef7',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.searchBarHorizontalTrailingPadding,
                ),
                Expanded(
                  child: _SheetButton(
                    buttonKey: const Key('sc146_transfer_confirm'),
                    label: 'X\u00e1c nh\u1eadn',
                    primary: true,
                    onTap: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool highlight;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.walletTransferConfirmRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.control.copyWith(
              color:
                  valueColor ??
                  (highlight ? _transferPrimary : AppColors.text1),
            ),
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
      padding: AppSpacing.transferNoticePadding,
      borderColor: _transferPrimary.withValues(alpha: .20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.walletTransferNoteIconPadding,
            child: Icon(
              Icons.info_outline_rounded,
              color: _transferPrimary,
              size: AppSpacing.transferActionIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Chuy\u1ec3n n\u1ed9i b\u1ed9 x\u1eed l\u00fd ngay l\u1eadp t\u1ee5c, kh\u00f4ng m\u1ea5t ph\u00ed.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    this.buttonKey,
    required this.label,
    this.primary = false,
    required this.onTap,
  });

  final Key? buttonKey;
  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: buttonKey,
      onPressed: onTap,
      variant: primary
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.secondary,
      height: AppSpacing.inputHeight,
      child: Text(label),
    );
  }
}
