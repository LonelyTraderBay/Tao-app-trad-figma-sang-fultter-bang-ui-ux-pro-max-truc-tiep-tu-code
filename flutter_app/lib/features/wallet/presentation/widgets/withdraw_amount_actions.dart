part of 'withdraw_form_sections.dart';

class WithdrawRecentAddresses extends StatelessWidget {
  const WithdrawRecentAddresses({
    required this.addresses,
    required this.onSelect,
    super.key,
  });

  final List<WalletRecentAddress> addresses;
  final ValueChanged<WalletRecentAddress> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.menu_book_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Lịch sử địa chỉ gần đây',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.rowGap),
        for (final address in addresses) ...[
          Semantics(
            button: true,
            label: 'Use recent withdrawal address ${address.label}',
            hint: address.address,
            child: VitCard(
              key: withdrawRecentAddressKey(address.label),
              onTap: () => onSelect(address),
              variant: VitCardVariant.ghost,
              borderColor: AppColors.divider,
              padding: AppSpacing.walletWithdrawRecentAddressPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          address.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          address.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    address.lastUsed,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}

class WithdrawAmountInput extends StatelessWidget {
  const WithdrawAmountInput({
    required this.asset,
    required this.available,
    required this.controller,
    required this.onChanged,
    required this.onAll,
    super.key,
  });

  final String asset;
  final double available;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: WithdrawSectionLabel('Số lượng rút')),
            VitChoicePill(
              key: withdrawAllAmountKey,
              label: 'Tất cả',
              selected: false,
              onTap: onAll,
              height: AppSpacing.buttonCompact,
              accentColor: withdrawPrimary,
              semanticLabel: 'Use full withdrawable balance',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.rowGap),
        VitInput(
          fieldKey: withdrawAmountFieldKey,
          controller: controller,
          semanticLabel: 'Withdrawal amount',
          hintText: '0.00',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          textStyle: AppTextStyles.amountSm.copyWith(
            fontFeatures: AppTextStyles.tabularFigures,
            fontWeight: AppTextStyles.bold,
          ),
          onChanged: onChanged,
          suffix: Text(
            asset,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}

class WithdrawPreviewBlockedNotice extends StatelessWidget {
  const WithdrawPreviewBlockedNotice({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: withdrawAmber.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: withdrawAmber,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(
                color: withdrawAmber,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawWarning extends StatelessWidget {
  const WithdrawWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      borderColor: withdrawAmber.withValues(alpha: .30),
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.access_time_rounded,
            color: withdrawAmber,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Rút tiền cần xác minh 2FA. Yêu cầu rút trên \$10,000 chỉ được xem xét trong 24h.',
              style: AppTextStyles.micro.copyWith(color: withdrawAmber),
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawSupportLink extends StatelessWidget {
  const WithdrawSupportLink({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open contextual withdrawal support',
      child: VitCtaButton(
        key: withdrawSupportKey,
        onPressed: onTap,
        variant: VitCtaButtonVariant.ghost,
        height: AppSpacing.inputHeight - AppSpacing.x2,
        leading: const Icon(Icons.support_agent_rounded),
        trailing: const Icon(Icons.chevron_right_rounded),
        child: const Text('Mở hồ sơ hỗ trợ'),
      ),
    );
  }
}

class WithdrawNextButton extends StatelessWidget {
  const WithdrawNextButton({
    required this.onTap,
    this.disabledReason,
    super.key,
  });

  final VoidCallback? onTap;
  final String? disabledReason;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: 'Preview withdrawal',
      hint: disabledReason,
      child: Tooltip(
        message: disabledReason ?? 'Preview withdrawal',
        child: VitCtaButton(
          key: withdrawNextKey,
          onPressed: onTap,
          height: AppSpacing.inputHeight,
          child: const Text('Tiếp tục →'),
        ),
      ),
    );
  }
}
