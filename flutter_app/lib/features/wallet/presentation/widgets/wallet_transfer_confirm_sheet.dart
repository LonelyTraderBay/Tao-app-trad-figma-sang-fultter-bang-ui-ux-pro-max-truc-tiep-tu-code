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
        padding: const EdgeInsets.fromLTRB(
          20,
          16,
          20,
          24 + DeviceMetrics.nativeBottomChrome,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Xác nhận chuyển nội bộ',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _transferPanel2,
                borderRadius: AppRadii.cardRadius,
              ),
              child: Column(
                children: [
                  _ConfirmRow(label: 'Từ', value: fromWallet.name),
                  _ConfirmRow(label: 'Đến', value: toWallet.name),
                  _ConfirmRow(label: 'Tài sản', value: asset.symbol),
                  _ConfirmRow(
                    label: 'Số lượng',
                    value:
                        '${formatTransferAssetAmount(amount)} ${asset.symbol}',
                    highlight: true,
                  ),
                  _ConfirmRow(
                    label: 'Giá trị',
                    value: formatTransferUsd(usdValue),
                  ),
                  const _ConfirmRow(
                    label: 'Phí',
                    value: 'Miễn phí',
                    valueColor: _transferGreen,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const _ConfirmNote(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SheetButton(
                    label: 'Huỷ',
                    background: _transferPanel2,
                    color: AppColors.text2,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SheetButton(
                    buttonKey: const Key('sc146_transfer_confirm'),
                    label: 'Xác nhận',
                    background: _transferPrimary,
                    color: AppColors.onAccent,
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
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color:
                  valueColor ??
                  (highlight ? _transferPrimary : AppColors.text1),
              fontSize: 13,
              fontWeight: FontWeight.w800,
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _transferPrimary.withValues(alpha: .08),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline_rounded,
              color: _transferPrimary,
              size: 13,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chuyển nội bộ xử lý ngay lập tức, không mất phí.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                height: 1.45,
              ),
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
    required this.background,
    required this.color,
    required this.onTap,
  });

  final Key? buttonKey;
  final String label;
  final Color background;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: buttonKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
