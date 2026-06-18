part of '../pages/p2p_wallet_transfer_page.dart';

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.controller,
    required this.asset,
    required this.insufficient,
    required this.onChanged,
    required this.onMax,
  });

  final TextEditingController controller;
  final String asset;
  final bool insufficient;
  final VoidCallback onChanged;
  final VoidCallback onMax;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Số tiền',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Material(
              key: P2PWalletTransferPage.maxKey,
              color: AppModuleAccents.p2p.withValues(alpha: .15),
              borderRadius: AppRadii.mdRadius,
              child: InkWell(
                onTap: onMax,
                borderRadius: AppRadii.mdRadius,
                child: Padding(
                  padding: AppSpacing.p2pWalletTransferChipPadding,
                  child: Text(
                    'MAX',
                    style: AppTextStyles.micro.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitInput(
          controller: controller,
          fieldKey: P2PWalletTransferPage.amountFieldKey,
          semanticLabel: 'P2P wallet transfer amount',
          hintText: '0.00',
          errorText: insufficient ? 'Số dư không đủ' : null,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          textStyle: AppTextStyles.amountSm,
          suffix: Text(
            asset,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          onChanged: (_) => onChanged(),
        ),
        if (insufficient) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Số dư không đủ',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickPercentRow extends StatelessWidget {
  const _QuickPercentRow({required this.onPercent});

  final ValueChanged<int> onPercent;

  @override
  Widget build(BuildContext context) {
    const values = [25, 50, 75, 100];
    return Row(
      children: [
        for (var index = 0; index < values.length; index++) ...[
          Expanded(
            child: Material(
              key: P2PWalletTransferPage.percentKey(values[index]),
              color: AppColors.surface2,
              borderRadius: AppRadii.xlRadius,
              child: InkWell(
                onTap: () => onPercent(values[index]),
                borderRadius: AppRadii.xlRadius,
                child: Padding(
                  padding: AppSpacing.p2pWalletTransferPercentPadding,
                  child: Text(
                    '${values[index]}%',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (index != values.length - 1) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _FeeNotice extends StatelessWidget {
  const _FeeNotice();

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PWalletTransferPage.feeKey,
      color: AppColors.buy.withValues(alpha: .10),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppColors.buy.withValues(alpha: .30)),
      ),
      child: Padding(
        padding: AppSpacing.p2pWalletCompactCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.bolt_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Miễn phí & Tức thì',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Chuyển tiền nội bộ hoàn toàn miễn phí và được xử lý ngay lập tức.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.p2pWalletTransferNoticeLineHeight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EscrowNotice extends StatelessWidget {
  const _EscrowNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PWalletTransferPage.escrowNoteKey,
      color: AppModuleAccents.p2p.withValues(alpha: .10),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(
          color: AppModuleAccents.p2p.withValues(alpha: .32),
        ),
      ),
      child: Padding(
        padding: AppSpacing.p2pWalletCompactCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.p2pWalletTransferNoticeLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PWalletTransferPage.submitKey,
      color: enabled ? AppModuleAccents.p2p : AppColors.surface2,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: AppRadii.lgRadius,
        child: SizedBox(
          height: AppSpacing.inputHeight,
          child: Center(
            child: Text(
              label.trim(),
              style: AppTextStyles.baseMedium.copyWith(
                color: enabled ? AppColors.onAccent : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
